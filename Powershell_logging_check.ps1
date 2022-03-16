$UserName = [System.Environment]::UserName
$CurrentPath = pwd | Select-Object | %{$_.ProviderPath}

Write-Host -ForegroundColor Yellow "======================="
Write-Host -ForegroundColor Yellow "==Script By AntonyN0p=="
Write-Host -ForegroundColor Yellow "======================="

Write-Host "`r`n[+]  Hello, $UserName"
Write-Host  " "
Start-Sleep -s 1

#Check Enabled: ModuleLogging, ScriptBlock Logging, Transcripting logging
$EnableModLogging = Get-ItemProperty HKLM:"\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Name "EnableModuleLogging"
if ($EnableModLogging -match 1){
    Write-Host -ForegroundColor Green "`r`nModuleLogging is Enabled"
}
else {
    Write-Host -ForegroundColor Red "`r`nModuleLogging is disabled"
}
$EnableScriptBlockLogging = Get-ItemProperty HKLM:"\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name "EnableScriptBlockLogging"
if ($EnableScriptBlockLogging -match 1){
    Write-Host -ForegroundColor Green "`r`nEnableScriptBlockLogging is Enabled"
}
else {
    Write-Host -ForegroundColor Red "`r`nEnableScriptBlockLogging is Disabled"
}
$EnableTranscripting = Get-ItemProperty HKLM:"\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\Transcription" -Name "EnableTranscripting"
if ($EnableScriptBlockLogging -match 1){
    Write-Host -ForegroundColor Green "`r`nEnableTranscripting is Enabled"
}
else {
    Write-Host -ForegroundColor Red "`r`nEnableTranscripting is Disabled"
}

Start-Sleep -s 1

if ($EnableModLogging -match 1 -or $EnableScriptBlockLogging -match 1 -or $EnableTranscripting -match 1){
    $SuspiciousPS_event = Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" | select * | where {$_.Id -eq 4104 -or $_.Id -eq 4103}
    Add-Content -Path $CurrentPath\powerShell_logs.txt -Value "$SuspiciousPS_event"
}
#Check PowerShell history for all sessions
Write-Host -ForegroundColor Yellow "[+]  Checking Powershell history for all session"
$CurrentPath = pwd | Select-Object | %{$_.ProviderPath}
$TheHistory = Get-Content -tail 30 (Get-PSReadlineOption).HistorySavePath
$HistArray = @()
$TheHistory > $CurrentPath\TEMP1.txt
Get-Content $CurrentPath\TEMP1.txt | ForEach-Object {
  if ($_ -match "[a-zA-Z0-9]") {
    $HistArray += $_
  }
}
$j = 0
$HistArrayLen = $HistArray.length
if ($HistArrayLen -lt 1) {
  Add-Content -Path $CurrentPath\powerShell_logs.txt -Value "`r`nPowershell History         : No history found!"
} else {
    Add-Content -Path $CurrentPath\powerShell_logs.txt -Value "`r`nPowershell History         : Last few Powershell commands-"
    $TheHistory | ForEach-Object {
      if ($j -lt 1) {
        Add-Content -Path $CurrentPath\powerShell_logs.txt -Value "`r`n                             $_"
        $j++
      } else {
          Add-Content -Path $CurrentPath\powerShell_logs.txt -Value "                             $_"
        }
    }
  }
Remove-Item $CurrentPath\TEMP.txt 2>&1>$null
Remove-Item $CurrentPath\TEMP1.txt 2>&1>$null
