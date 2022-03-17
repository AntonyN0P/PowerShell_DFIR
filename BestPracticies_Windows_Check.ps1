$UserName = [System.Environment]::UserName

Write-Host -ForegroundColor Yellow "======================="
Write-Host -ForegroundColor Yellow "==Script By AntonyN0p=="
Write-Host -ForegroundColor Yellow "======================="

Write-Host "[+]  Hello, $UserName"
Write-Host  " "
Start-Sleep -s 1

#Check Enabled: ModuleLogging, ScriptBlock Logging, Transcripting logging
Write-Host -ForegroundColor Yellow "[+]  ModuleLogging, ScriptBlock Logging, Transcripting logging"
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


#Checking Windows Credential Guard
Write-Host -ForegroundColor Yellow "`r`n[+]  Checking Windows Credential Guard"
$CredGuard = (Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard).SecurityServicesRunning
if ($CredGuard -match 1){
    Write-Host -ForegroundColor Green "`r`nCredential Guard is Enabled"
}  
else {
    Write-Host -ForegroundColor Red "`r`nCredential Guard is Disabled"
}
# Check registry for EnableLUA
####################################################################
Write-Host -ForegroundColor Yellow "`r`n[+]  Checking current Admin Approval Mode policy"
if (Test-Path -Path HKLM:"\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System") {
  $EnableLUAvalue = Get-ItemPropertyValue  HKLM:"\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA"
  if ($EnableLUAvalue -match '1') {
    Write-Host -ForegroundColor Green "`r`nAdmin Approval Mode is Enabled"
  } else {
        Write-Host -ForegroundColor Green "`r`nAdmin Approval Mode is Disabled"
    }
}
