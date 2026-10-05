$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
$reader = Join-Path (Split-Path $PSScriptRoot -Parent) 'scripts/read.ps1'
$previous = [Windows.Forms.Clipboard]::GetText()
$probe = 'Unicode: ' + [char]0x00F1 + ' ' + [char]0x00E9 + "`n" + 'Literal: $(not_a_command) "quotes"' + "`n"
function Invoke-Reader([string]$Sound) {
    $info = [Diagnostics.ProcessStartInfo]::new()
    $info.FileName = Join-Path $PSHOME 'powershell.exe'
    $info.Arguments = '-NoProfile -NonInteractive -File "' + $reader + '" -Sound ' + $Sound
    $info.UseShellExecute = $false
    $info.RedirectStandardOutput = $true
    $info.RedirectStandardError = $true
    $info.StandardOutputEncoding = [Text.UTF8Encoding]::new($false)
    $process = [Diagnostics.Process]::Start($info)
    $outputTask = $process.StandardOutput.ReadToEndAsync()
    $errorTask = $process.StandardError.ReadToEndAsync()
    if (-not $process.WaitForExit(60000)) { $process.Kill(); throw 'Reader timed out.' }
    $text = $outputTask.GetAwaiter().GetResult()
    $errorText = $errorTask.GetAwaiter().GetResult()
    $result = @{Text=$text; Error=$errorText; Exit=$process.ExitCode}
    $process.Dispose()
    return $result
}
try {
    Set-Clipboard -Value $probe
    foreach ($sound in @('Off','On')) {
        $result = Invoke-Reader $sound
        if ($result.Exit -ne 0 -or $result.Text -cne $probe -or $result.Error) { throw 'Read did not return exact UTF-8 text.' }
        if (([Windows.Forms.Clipboard]::GetText()) -cne $probe) { throw 'Reading changed the clipboard.' }
    }
    Write-Output 'PASS: exact text received with Sound On/Off; clipboard unchanged.'
    $result = Invoke-Reader 'Invalid'
    if ($result.Exit -eq 0 -or $result.Text) { throw 'Invalid option returned clipboard content.' }
    [Windows.Forms.Clipboard]::Clear()
    $result = Invoke-Reader 'On'
    if ($result.Exit -eq 0 -or $result.Text) { throw 'Empty clipboard announced reception.' }
    Write-Output 'PASS: invalid option and missing text rejected without receipt.'
} finally {
    if ([string]::IsNullOrEmpty($previous)) { [Windows.Forms.Clipboard]::Clear() }
    else { Set-Clipboard -Value $previous }
}
