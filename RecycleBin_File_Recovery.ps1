$UserName = [System.Environment]::UserName

Write-Host -ForegroundColor Yellow "=============================="
Write-Host -ForegroundColor Yellow "=====Script By AntonyN0p======"
Write-Host -ForegroundColor Yellow "===For RecBin File Recovery==="
Write-Host -ForegroundColor Yellow "=============================="

Write-Host "[+]  Hello, $UserName"
Write-Host  " "
Start-Sleep -s 1


Write-Host -ForegroundColor Yellow "Enter Volume Name where file was deleted: "

[string]$Vol_Name = read-host

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

[int]$index = read-host


$file_record = Get-ForensicFileRecord -VolumeName $Vol_Name -Index $index.ToString()
$Resident_ByteArray = (((Get-ForensicFileRecord -VolumeName $Vol_Name -Index ($index+1).ToString()).Attribute | Where-Object {$_.name -eq 'DATA'}).RawData)
[string]$file_name = Split-Path -Path ([System.Text.Encoding]::UTF8.GetString($Resident_ByteArray[27..$Resident_ByteArray.Length])) -Leaf

$file_descriptor=$file_record.Attribute | Where-Object {$_.name -eq 'DATA'}
[int64]$RSize = $file_descriptor.RealSize
[int64]$AllocSize = $file_descriptor.AllocatedSize
$st_cl = $file_descriptor.DataRun | select *

echo $st_cl

if ($st_cl.StartCluster -eq $null -and $st_cl.ClusterLength -eq $null){
    Write-Host "Start cluster equal null!"
    Write-Host "File is resident!"
	
}
else{
	try{
	$destinationPath = Read-Host "Enter the full destination recovery path for file $file_name (Example:  C:\...\filename.exe)"
	$bytearray = Invoke-ForensicDD -InFile \\.\$Vol_Name -Offset (($file_descriptor.DataRun).StartCluster*4096) -BlockSize (($file_descriptor.DataRun).ClusterLength*4096) -Count 1
	[System.IO.File]::WriteAllBytes($destinationPath,$bytearray[0..($bytearray.Length - (($AllocSize-$RSize)+1))])
	Write-Host -ForegroundColor Green "File was recovered successfully to $path!" 
	}
	catch
	{	
		Write-Host -ForegroundColor Red "Error in file recovering"
		Write-Host $_
	}
}
