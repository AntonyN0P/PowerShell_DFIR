$UserName = [System.Environment]::UserName

Write-Host -ForegroundColor Yellow "======================="
Write-Host -ForegroundColor Yellow "==Script By AntonyN0p=="
Write-Host -ForegroundColor Yellow "===For File Recovery==="
Write-Host -ForegroundColor Yellow "======================="

Write-Host "[+]  Hello, $UserName"
Write-Host  " "
Start-Sleep -s 1


Write-Host -ForegroundColor Yellow "Enter Volume Name where file was deleted: "

$Vol_Name = read-host

try {
    Get-ForensicFileRecord -VolumeName $Vol_Name | Where-Object {$_.Deleted} | Where-Object {$_.Name -like '$R*'}
}
catch {
    Write-Host -ForegroundColor Red "ERROR Entered volume name is incorrect!"
    Write-Host -ForegroundColor Red "`r`nExample:  D: "
    Write-Output $_
    exit
}
Write-Host -ForegroundColor Yellow "Enter file record number:"

$index = read-host

Write-Host -ForegroundColor Yellow "Enter file recovered filename:"

$name = read-host

$file_record = Get-ForensicFileRecord -VolumeName $Vol_Name -Index $index

$file_descriptor=$file_record.Attribute | Where-Object {$_.name -eq 'DATA'}

$st_cl = $file_descriptor.DataRun | select *

echo $st_cl

if ($st_cl.StartCluster -eq $null -and $st_cl.ClusterLength -eq $null){
    Write-Host "Start cluster equal null!"
    Write-Host "Cluster Length equal null!"
}
else{
Write-Host "Start cluster equal:" $st_cl.StartCluster
Write-Host "Cluster Length equal:" $st_cl.ClusterLength

Invoke-ForensicDD -InFile \\.\$Vol_Name -Offset ($st_cl.StartCluster*4096) -BlockSize ($st_cl.ClusterLength*4096) -Count 1 -OutFile $Vol_Name\$name
}
