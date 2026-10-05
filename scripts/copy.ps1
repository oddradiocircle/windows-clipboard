param(
    [AllowEmptyString()][string]$Text,
    [switch]$FromStdin,
    [ValidateSet('On','Off')][string]$Sound = 'On',
    [ValidateSet('Classic','Digital','Crystal')][string]$Timbre = 'Digital'
)
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
if ($FromStdin) {
    [Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
    $Text = [Console]::In.ReadToEnd()
} elseif (-not $PSBoundParameters.ContainsKey('Text')) {
    throw 'Supply -Text or -FromStdin.'
}
Set-Clipboard -Value $Text
if ($Sound -eq 'Off') {
    Write-Output 'Clipboard updated; sound disabled.'
    return
}
try {
    & (Join-Path $PSScriptRoot 'robot-voice.ps1') -Word OK -Mood Ready -MorseUnitMs 50 -Speed 1.2 -PauseMs 0 -Timbre $Timbre -Articulation Plain
} catch {
    throw 'Clipboard updated, but the notification sound failed.'
}
Write-Output 'Clipboard updated; robot OK notification requested.'
