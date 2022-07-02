<#
.SYNOPSIS
Recover deleted prefetch and evtx files, create 2 logs files with description what files was recovered.

.DESCRIPTION
Script written by Antony N0p for DFIR and investigations Cyber Security incidents. 
Allow to recover deleted prefetch and evtx files.

.Inputs
Parameters "Volume name" and Decision (yes or no) need in revovery process.
#>


$UserName = [System.Environment]::UserName

Write-Host -ForegroundColor Yellow "==================================="
Write-Host -ForegroundColor Yellow "=====DFIR Script By AntonyN0p======"
Write-Host -ForegroundColor Yellow "=====Evidences Files Recovery======"
Write-Host -ForegroundColor Yellow "==================================="

Write-Host "[+]  Hello, $UserName"
Write-Host  " "
Start-Sleep -s 1

Write-Host -ForegroundColor Yellow "Enter Volume Name where file was deleted: "

$Vol_Name = read-host

Write-Host -ForegroundColor Yellow "`r`nEnter full path directory where files will be recovery and save logs, example: C:\Recovery "
$fullpath = read-host


try {
    $DeletedWindowsLogs = Get-ForensicFileRecord -VolumeName $Vol_Name | Where-Object {$_.Deleted} | Where-Object {$_.Name -like '*.evtx'}
    $DeletedPrefetchFiles = Get-ForensicFileRecord -VolumeName $Vol_Name | Where-Object {$_.Deleted} | Where-Object {$_.Name -like '*.pf'} 
}
catch {
    Write-Host -ForegroundColor Red "ERROR Entered volume name is incorrect!"
    Write-Host -ForegroundColor Red "`r`nExample:  D: "
    Write-Output $_
    exit
}

if ($DeletedWindowsLogs){
    Write-Host -ForegroundColor Yellow "`r`nDeleted Windows Events journals:"
    Write-Host $DeletedWindowsLogs
}
if ($DeletedPrefetchFiles){
    Write-Host -ForegroundColor Yellow "`r`nDeleted Windows Prefetch Files:"
    Write-Host $DeletedPrefetchFiles | Sort $_.AccessedTime -Descending
} else{
    Write-Host -ForegroundColor Yellow "`r`nDeleted Windows Prefetch Files is empty"
}

Write-Host -ForegroundColor Yellow "`r`nDo you want to recover deleted Prefetch Files? (y/n)"
$DecisionPF = read-host
    if(($DecisionPF -eq "y") -and $DeletedPrefetchFiles){
    Add-Content -Path "$fullpath\DeletedPrefetch.log" -Value ($DeletedPrefetchFiles | select *)
    for($i=0;$i -lt $DeletedPrefetchFiles.Count;$i++){
        try{
        $FileName = $DeletedPrefetchFiles[$i].Name
        $FileRecordNumber = $DeletedPrefetchFiles[$i].RecordNumber
        $File_record = Get-ForensicFileRecord -VolumeName $Vol_Name -Index $FileRecordNumber
        $File_descriptor=$file_record.Attribute | Where-Object {$_.name -eq 'DATA'}
        $st_cl = $file_descriptor.DataRun | select *
        $Lines = $st_cl.StartCluster | Measure-Object -Line 
        if ([int]$Lines.Lines -ne 1){
            for($i=0;$i -lt $Lines.Lines; $i++){
                     $st_cl.StartCluster[$i]
                     $st_cl.ClusterLength[$i]
                     $SumRawBytes += Invoke-ForensicDD -InFile \\.\C: -Offset ($st_cl.StartCluster[$i]*4096) -BlockSize ($st_cl.ClusterLength[$i]*4096) -Count 1
                     Write-Host -ForegroundColor Green 'Multiple cluster detected for'
                     Write-Host -ForegroundColor Green $FileName
             }
             
             Set-Content -Path "$fullpath\$FileName" -Value $SumRawBytes -Encoding Byte
             }
        else{Invoke-ForensicDD -InFile \\.\$Vol_Name -Offset ($st_cl.StartCluster*4096) -BlockSize ($st_cl.ClusterLength*4096) -Count 1 -OutFile "$fullpath\$FileName"}
        }
        catch {
            Write-Host -ForegroundColor Red "`r`nERROR when file $FileName recovering "
            Write-Output $_
        }
    }
    break
    }

Write-Host -ForegroundColor Yellow "Do you want to recover deleted Windows Logs files? (y/n)"
$DecisionLog = read-host
    if(($DecisionLog -eq "y") -and $DeletedWindowsLogs){
    Add-Content -Path "$fullpath\WindowsJournal.txt" -Value ($DeletedWindowsLogs | select *)
    for($i=0;$i -lt $DeletedWindowsLogs.Count;$i++){
        try{
        $FileName = $DeletedWindowsLogs[$i].Name
        $FileRecordNumber = $DeletedWindowsLogs[$i].RecordNumber
        $File_record = Get-ForensicFileRecord -VolumeName $Vol_Name -Index $FileRecordNumber
        $File_descriptor=$file_record.Attribute | Where-Object {$_.name -eq 'DATA'}
        $st_cl = $file_descriptor.DataRun | select *
        $Lines = $st_cl.StartCluster | Measure-Object -Line 
        if ([int]$Lines.Lines -ne 1){
            for($i=0;$i -lt $Lines.Lines; $i++){
                     $st_cl.StartCluster[$i]
                     $st_cl.ClusterLength[$i]
                     $SumRawBytes += Invoke-ForensicDD -InFile \\.\C: -Offset ($st_cl.StartCluster[$i]*4096) -BlockSize ($st_cl.ClusterLength[$i]*4096) -Count 1
                     Write-Host -ForegroundColor Green 'Multiple cluster detected for'
                     Write-Host -ForegroundColor Green $FileName
             }
             Set-Content -Path "$fullpath\$FileName" -Value $SumRawBytes -Encoding Byte
             }
        else{Invoke-ForensicDD -InFile \\.\$Vol_Name -Offset ($st_cl.StartCluster*4096) -BlockSize ($st_cl.ClusterLength*4096) -Count 1 -OutFile "$fullpath\$FileName"}
        }
        catch {
            Write-Host -ForegroundColor Red "`r`nERROR when file $FileName recovering "
            Write-Output $_
        }
    }
    break
    }



