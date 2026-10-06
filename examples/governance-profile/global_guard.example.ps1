# 範例：正則黑名單，非安全邊界。
# 已知限制見 tools/pretooluse-guard-spec.md；本範例只參數化，不修補來源邏輯。
# 只檢查當次工具名與參數，不落地記錄；允許呼叫保持靜默。
param([string]$ConfigPath)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($ConfigPath)) {
    $ConfigPath = Join-Path $PSScriptRoot 'guard-config.example.json'
}
$config = Get-Content -LiteralPath $ConfigPath -Raw | ConvertFrom-Json
# 路徑值為相對片段；轉為原有正則形式，不新增正規化或檔案權限檢查。
$protectedPaths = (@($config.protectedPaths) | ForEach-Object {
    [regex]::Escape([string]$_).Replace('/', '[\\/]')
}) -join '|'
$agentTools = '^(?:' + ((@($config.subagentTools) | ForEach-Object {
    [regex]::Escape([string]$_)
}) -join '|') + ')$'


function Write-Deny([string]$Reason) {
    @{
        hookSpecificOutput = @{
            hookEventName = 'PreToolUse'
            permissionDecision = 'deny'
            permissionDecisionReason = $Reason
        }
    } | ConvertTo-Json -Depth 5 -Compress
    exit 0
}

function Test-ActiveWindow([string]$Name) {
    $value = [Environment]::GetEnvironmentVariable($Name)
    if ([string]::IsNullOrWhiteSpace($value)) { return $false }
    try {
        $until = [DateTimeOffset]::Parse($value, [Globalization.CultureInfo]::InvariantCulture)
        $now = [DateTimeOffset]::UtcNow
        return ($until -gt $now -and $until -le $now.AddMinutes([double]$config.authorization.maxWindowMinutes))
    } catch {
        return $false
    }
}

if ([Environment]::GetEnvironmentVariable([string]$config.authorization.reentryVariable) -eq '1') {
    Write-Deny '治理 hook 重入已攔截。'
}
[Environment]::SetEnvironmentVariable([string]$config.authorization.reentryVariable, '1')

$raw = [IO.StreamReader]::new([Console]::OpenStandardInput(), [Text.UTF8Encoding]::new($false)).ReadToEnd()
try {
    $event = $raw | ConvertFrom-Json
} catch {
    exit 0
}

$toolName = [string]$event.tool_name
if ([string]::IsNullOrWhiteSpace($toolName)) { $toolName = [string]$event.tool }
$toolInput = $event.tool_input
$serialized = if ($null -eq $toolInput) { '' } else { $toolInput | ConvertTo-Json -Depth 20 -Compress }
$command = ''
if ($null -ne $toolInput) {
    if ($null -ne $toolInput.command) { $command = [string]$toolInput.command }
    elseif ($null -ne $toolInput.cmd) { $command = [string]$toolInput.cmd }
}

$agentAllowed = Test-ActiveWindow ([string]$config.authorization.agentUntilVariable)
$riskAllowed = Test-ActiveWindow ([string]$config.authorization.riskUntilVariable)

if ($toolName -match $agentTools -and -not $agentAllowed) {
    Write-Deny '子代理工具需人工核准。請由人控制的 CLI 啟動環境提供設定中指定的時效型授權；AI 不得自設變數或另開行程自授權。先回報用途與規模。'
}

if (-not $riskAllowed -and -not [string]::IsNullOrWhiteSpace($command)) {
    # 純資料剝除：heredoc（餵 shell 時保留）、
    # PowerShell here-string（執行程式碼時保留）與 commit/tag 的訊息參數。
    $shellConsumer = '(?i)(^|[\s|;&(])(bash|sh|zsh|dash|ksh|pwsh|powershell|cmd|iex|Invoke-Expression|Invoke-Command)(\.exe)?(?=$|[\s;|&)])'
    $scan = [regex]::Replace($command, '(?ms)^([^\n]*?)<<-?[ \t]*([''"]?)([A-Za-z_][A-Za-z0-9_]*)\2([^\n]*)\n.*?^[ \t]*\3[ \t]*$', [System.Text.RegularExpressions.MatchEvaluator]{
        param($m)
        if (($m.Groups[1].Value + $m.Groups[4].Value) -match $shellConsumer) { return $m.Value }
        return $m.Groups[1].Value + '<<' + $m.Groups[3].Value + $m.Groups[4].Value
    })
    if ($scan -notmatch $shellConsumer) {
        $scan = [regex]::Replace($scan, '(?s)@([''"])\r?\n.*?\r?\n\1@', '@$1$1@')
    }
    $scan = [regex]::Replace($scan, '(?i)(\s(?:-m|--message)(?:=|\s+))("(?:[^"\\]|\\.)*"|''[^'']*'')', '$1""')
    $destructive = '(?i)(\bgit\s+reset\s+--hard\b|\bgit\s+clean\s+-[^\s]*[fdx]|\bgit\s+push\b[^\r\n]*(--force|-f\b)|\bgit\s+push\b[^\r\n|;&]*\s\+[\w./:-]|\brm\s+-[^\r\n]*r[^\r\n]*f|\brm\b[^\r\n|;&]*\s(?:--recursive|-Recurse\b|-[a-z]{0,3}r[a-z]{0,3}(?=[\s;|&]|$))|\bRemove-Item\b[^\r\n]*(?:-Recurse|-Force)|\b(?:rmdir|rd)\b[^\r\n]*/s\b|\bdel\b[^\r\n]*/[sq]\b|\b(?:Get-ChildItem|gci|ls|dir)\b[^\r\n;&]*\s-r(?:ecurse)?\b[^\r\n;&]*\|\s*(?:Remove-Item|ri|rm|del)\b|\bfind\b[^\r\n|;&]*\s-delete\b|\bformat(?:\.com)?\s+(?:/\S+\s+)*[a-z]:(?=\s|$)|\bFormat-Volume\b|\bdiskpart\b|\bgit\s+checkout\b[^\r\n|;&]*\s--(?=\s|$)|\bgit\s+checkout\s+(?:-f\b|--force\b|\.(?=\s|$))|\bgit\s+restore\b(?![^\r\n|;&]*--staged)|\bgit\s+stash\s+(?:drop|clear)\b|\bgit\s+branch\s+(?-i:-D)\b)'
    if ($scan -match $destructive) {
        Write-Deny '命中破壞性命令規則。請先向人列出精確動作與理由，再由人執行或透過受控通道核准；不得改寫命令重跑。'
    }

    # 同命令段內寫入運算子須在受保護路徑之前；單純讀取或文字提及放行。
    $protectedWrite = '(?i)(Set-Content|Out-File|Add-Content|Copy-Item|Move-Item|\btee\b|>)[^\r\n|;&]*?[\\/](' + $protectedPaths + ')'
    if ($scan -match $protectedWrite) {
        Write-Deny '命中受保護全域配置的寫入、複製或移動規則。請使用經審查的結構化局部修改，或先取得人工核准。'
    }

    $sensitiveWrite = '(?i)(Set-Content|Out-File|Add-Content|New-Item|Copy-Item|Move-Item|Remove-Item|\b(?:tee|rm|del|erase|mv|cp)\b|>)[^\r\n|;&]*?[\s\\/''"=](?:' + [string]$config.secretFilePattern + ')(?=$|[\s\\/''";|&)])'
    if ($scan -match $sensitiveWrite) {
        Write-Deny '命中秘密檔的寫入、移動或刪除規則。請先取得人工確認，不回顯秘密內容。'
    }
}

if (-not $riskAllowed -and $toolName -match '^(Write|Edit|MultiEdit|apply_patch)$') {
    # 比對目標路徑；檔案內容僅提及路徑不阻擋（apply_patch 維持序列化輸入比對）。
    $target = if ($toolName -ne 'apply_patch' -and $null -ne $toolInput.file_path) { [string]$toolInput.file_path } else { $serialized }
    $sensitivePath = [string]$config.secretPathPattern
    if ($target -match $sensitivePath) {
        Write-Deny '編輯秘密檔需人工確認。請先回報預計變更，不回顯秘密內容。'
    }
    if ($toolName -eq 'Write' -and $target -match ('(?i)([\\/](' + $protectedPaths + '))')) {
        Write-Deny '受保護全域配置禁止整檔 Write；請使用經審查的結構化局部修改。'
    }
}

exit 0
