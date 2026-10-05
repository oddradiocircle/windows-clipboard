param(
    [ValidateSet('On','Off')][string]$Sound = 'On',
    [ValidateSet('Classic','Digital','Crystal')][string]$Timbre = 'Digital'
)
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
Add-Type -AssemblyName System.Windows.Forms
# Take one text snapshot. Reading never replaces the clipboard.
if (-not [Windows.Forms.Clipboard]::ContainsText()) {
    throw 'Clipboard has no text to receive.'
}
$text = [Windows.Forms.Clipboard]::GetText()
if ($Sound -eq 'On') {
    try {
        & (Join-Path $PSScriptRoot 'robot-voice.ps1') -Word RCV -Mood Neutral -MorseUnitMs 50 -Speed 1.2 -PauseMs 0 -Timbre $Timbre -Articulation Plain | Out-Null
    } catch {
        [Console]::Error.WriteLine('Clipboard text received, but the notification sound failed.')
        [Console]::Out.Write($text)
        exit 1
    }
}
# No status labels or extra newline: stdout contains only the received text.
[Console]::Out.Write($text)
