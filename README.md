# PowerShell_DFIR
Usefully PowerShell scripts

BestPracites_Windows_Check.ps1 - check PowerShell Module Logging, ScriptBlockLogging, Transcription Logging, Windows Credential Guard, UAC.

![image](https://user-images.githubusercontent.com/97513066/158873772-fe15ba30-e37d-4028-aafd-0cbf82889ce2.png)

Powershell_logging_check.ps1 - collect suspicious logs (4103 & 4104) with code blocks and PowerShell history and pack to powerShell_logs.txt

![PowerShell_Logging](https://user-images.githubusercontent.com/97513066/158879999-01ff7e75-9104-4cf2-90fb-efc6784b0fd1.gif)

![image](https://user-images.githubusercontent.com/97513066/158874988-655cd371-21da-416c-958e-333daa5624c8.png)

Powershell_logging_check.ps1 script can help to find malicious activity:

![image](https://user-images.githubusercontent.com/97513066/158875137-60a7413c-fb80-4b08-85eb-ef93a34f0901.png)

SecureBoot_checker.ps1 - check your secure boot policies for prevent bootkit/rootkit runs.

![SecureBootCecher](https://user-images.githubusercontent.com/97513066/158877701-2e075c29-297e-40ee-899c-d6f0aa0f4a3c.JPG)

Before use this script, you must install PowerShell PowerForensics module.

FileRecoveryScript.ps1 - allow to recover recent deleted files with different extenstions and size (before~4GB!), work for both resident and non-resident files.

![FileRecoveryScript_inaction](https://user-images.githubusercontent.com/97513066/160291854-8efe7705-27be-49f8-bae7-59e6b0fa702d.gif)

WindowsEvtxAndPrefetchFileRecovery.ps1 - Can help investigators to recover deleted Prefetch and Evtx files. Script gain information about deleted files from $mft and build them.
