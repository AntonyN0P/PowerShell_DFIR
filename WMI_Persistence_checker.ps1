  $UserName = [System.Environment]::UserName
$CurrentPath = pwd | Select-Object | %{$_.ProviderPath}

Write-Host -ForegroundColor Yellow "======================="
Write-Host -ForegroundColor Yellow "==Script By AntonyN0p=="
Write-Host -ForegroundColor Yellow "======================="

Write-Host -ForegroundColor Yellow  "`r`n[+]  Hello, $UserName"
Write-Host  " "
Start-Sleep -s 1

$suspiciouseWMIClasses = @('__EventFilter', '__EventConsumer', 'CommandLineEventConsumer','__FilterToConsumerBinding')
$suspiciouseKeyWords = @('Download','Start-Process','FromBase64', 'rundll32','IEX','Invoke-Expression','Web-Client','powershell -version','http','bitstransfer','System.Net.WebClient')
$suspiciouseWMIClasses | ForEach-Object {
    Write-Host -ForegroundColor Green "Checking WMI Class:" $_
    try{
        $wmiObj = Get-WmiObject -Namespace root\Subscription -class $_
        if (!$wmiObj){
            Write-Host -ForegroundColor Yellow "$_ Is empty"
        }else{
            Get-WmiObject -Namespace root\Subscription -class $_
        }
    }
    catch{
        Write-Host -ForegroundColor red "Error in request"
        Write-Host $_
    }
}
$EnableModLogging = Get-ItemProperty HKLM:"\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Name "EnableModuleLogging"
if ($EnableModLogging -match 1){
    Write-Host -ForegroundColor Yellow "`r`n=============Check Logging Policies============="
    Write-Host -ForegroundColor Green "`r`nModuleLogging is Enabled"
}
else {
    Write-Host -ForegroundColor Red "`r`nModuleLogging is disabled"
}
$EnableScriptBlockLogging = Get-ItemProperty HKLM:"\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name "EnableScriptBlockLogging"
if ($EnableScriptBlockLogging -match 1){
    Write-Host -ForegroundColor Green "`r`nEnabledScriptBlockLogging is Enabled"
}
else {
    Write-Host -ForegroundColor Red "`r`nEnabledScriptBlockLogging is Disabled"
}
$EnableTranscripting = Get-ItemProperty HKLM:"\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\Transcription" -Name "EnableTranscripting"
if ($EnableScriptBlockLogging -match 1){
    Write-Host -ForegroundColor Green "`r`nEnabledTranscripting is Enabled"
}
else {
    Write-Host -ForegroundColor Red "`r`nEnabledTranscripting is Disabled"
}

$EnabledAudProcCreation = Get-ItemProperty HKLM:"\Software\Microsoft\Windows\CurrentVersion\Policies\System\Audit" -Name "ProcessCreationIncludeCmdLine_Enabled"
if ($EnabledAudProcCreation -match 1){
    Write-Host -ForegroundColor Green "`r`nEnabled Audit Process Creation is Enabled"
    Write-Host -ForegroundColor Yellow "`r`nAudit_process_creation.txt"
    try {
        $SuspiciousProcess_events=Get-WinEvent -LogName Security | select * | Where-Object {$_.Id -eq 4688} 
        Add-Content -Path $CurrentPath\Audit_process_creation.txt -Value $SuspiciousProcess_events
    }
    catch {
        Write-Host -ForegroundColor Red "`r`n Error "
        Write-Host  -ForegroundColor Yellow $_
    }
}

else {
    Write-Host -ForegroundColor Red "`r`nAudit Process Creation is Disabled"
}

if ($EnableModLogging -match 1 -or $EnableScriptBlockLogging -match 1 -or $EnableTranscripting -match 1){
     $PS_event = Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" | select * | Where-Object {$_.Id -eq 4104 -or $_.Id -eq 4103}
     $suspiciouseKeyWords | ForEach-Object {
        $SuspiciousPS_event = $PS_event | Select-String -InputObject {$_.message} -Pattern $_ | select *
    }
    Write-Host -ForegroundColor Yellow "`r`nWriting to PowerShell_logs.txt"
    Add-Content -Path $CurrentPath\PowerShell_logs.txt -Value $PS_event

    Write-Host -ForegroundColor Yellow "`r`nPowerShell_Suscpicious_logs.txt"
    Add-Content -Path $CurrentPath\PowerShell_Suscpicious_logs.txt -Value $SuspiciousPS_event
}
