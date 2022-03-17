$UserName = [System.Environment]::UserName
Write-Host -ForegroundColor Yellow '============================================='
Write-Host -ForegroundColor Yellow '==Root/Boot_protection_checker_by_AntonyN0p=='
Write-Host -ForegroundColor Yellow '============================================='

Write-Host "[+]  Hello, $UserName"
Write-Host  " "
Start-Sleep -s 1

Write-Host -ForegroundColor Yellow "`r`nCheck your privileges! You must have Administrator's privileges"
Start-Sleep -s 1
Write-Host -ForegroundColor Yellow "`r`n[+] Checking Secure Boot status:"
$SecureBoot = Confirm-SecureBootUEFI
if ($SecureBoot -match 'True'){
    Write-Host -ForegroundColor Green "`r`nSecureBoot is enable"
}
else{
    Write-Host -ForegroundColor Red "`r`nSecureBoot is disabled"
}

Write-Host -ForegroundColor Yellow "`r`n[+] Checking TPM status:"
Start-Sleep -s 1
$TPM_checker=Get-Tpm

if($TPM_checker -match 5){
    Write-Host -ForegroundColor Green "`r`nTPM: lockout authorization is enabled`r`n"
}
else{
    Write-Host -ForegroundColor Red "`r`nTPM: lockout authorization is disabled value = $TPM_checker`r`n"
}
