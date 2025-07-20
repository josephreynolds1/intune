Create intunewin file including script

Install command examples:
powershell.exe -ExecutionPolicy Bypass -file .\WinGet-Helper.ps1 -App Notepad++.Notepad++ -Action install -Scope machine

Uninstall command examples:
powershell.exe -ExecutionPolicy Bypass -file .\WinGet-Helper.ps1 -App Notepad++.Notepad++ -Action uninstall -Scope machine

With custom uninstall command and arguments:
.\WinGet-Helper.ps1 -App VideoLAN.VLC -Action uninstall -UninstallCustomCommand "$env:SystemDrive\Program Files\VideoLAN\VLC\uninstall.exe" -UninstallCustomArguments "/S" 
