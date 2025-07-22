Create intunewin file including script

Install command examples:

&#x20;   **powershell.exe -ExecutionPolicy Bypass -File .\WinGet-Helper.ps1 -App Notepad++.Notepad++ -Action install -Scope machine**

Uninstall command examples:

&#x20;   **powershell.exe -ExecutionPolicy Bypass -File .\WinGet-Helper.ps1 -App Notepad++.Notepad++ -Action uninstall -Scope machine**

With custom uninstall command and arguments:

&#x20;   **powershell.exe -ExecutionPolicy Bypass -File .\WinGet-Helper.ps1 -App VideoLAN.VLC -Action uninstall -UninstallCustomCommand "c:\Program Files\VideoLAN\VLC\uninstall.exe" -UninstallCustomArguments "/S"**&#x20;
