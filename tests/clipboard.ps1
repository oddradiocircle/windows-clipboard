$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
Add-Type -AssemblyName System.Windows.Forms
$copy = Join-Path (Split-Path $PSScriptRoot -Parent) 'scripts/copy.ps1'
$previous = [Windows.Forms.Clipboard]::GetText()
$probe = 'Unicode: ' + [char]0x00F1 + ' ' + [char]0x00E9 + "`n" + 'Literal: $(not_a_command) "quotes"' + "`n"
try {
    & $copy -Text $probe
    $observed = [Windows.Forms.Clipboard]::GetText()
    if ($observed -cne $probe) { throw 'Clipboard text changed during copy.' }
    Write-Output 'PASS: exact Unicode, multiline and literal content.'
    $silentProbe = $probe + 'Sound Off'
    $silentOutput = & $copy -Text $silentProbe -Sound Off
    if (([Windows.Forms.Clipboard]::GetText()) -cne $silentProbe) { throw 'Silent copy changed content.' }
    if ($silentOutput -ne 'Clipboard updated; sound disabled.') { throw 'Unexpected silent copy result.' }
    $rejected = $false
    try { & $copy -Text 'Must not copy' -Sound Invalid }
    catch { $rejected = $true }
    if (-not $rejected -or ([Windows.Forms.Clipboard]::GetText()) -cne $silentProbe) { throw 'Invalid sound option changed the clipboard.' }
    Write-Output 'PASS: Sound Off copies without a sound call; invalid option rejected.'
} finally { Set-Clipboard -Value $previous }
