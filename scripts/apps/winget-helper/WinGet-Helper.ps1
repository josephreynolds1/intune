param(
    [Parameter(Mandatory)]
    [string]$App,
    [ValidateSet('install', 'uninstall')]
    [string]$Action = "install",
    [ValidateSet('machine', 'user')]
    [string]$Scope = "machine",
    [string]$InstallCustomCommand,
    [string]$InstallOverrideCommand,
    [string]$UninstallCustomCommand,
    [string]$UninstallCustomArguments
)

$ScriptName = "WinGet Helper"
$ScriptVersion = "1.0"
$ScriptDate = "07/20/2025"
$ScriptAuthor = "jreynolds@torreontek.com"
$LogDate = Get-Date -Format MMddyyyy-HHmmss
$LogPath = "$env:ProgramData\TorreonTek\Logs"
$LogFile = "winget_$($App)_$($Action).log"

if (Test-Path -Path "$($LogPath)"){
    Write-Host -Message "Log path exists: $($LogPath)"
} else {
    Write-Host "Log path is missing... creating"
    New-Item -ItemType Directory -Path "$($LogPath)" -Force
}

Start-Transcript -Path "$($LogPath)\$($LogFile)"

Write-Host "$($ScriptName) - $($ScriptVersion)"
Write-Host "$($Action) App: $($App)"
Write-Host "Scope: $($Scope)"
Write-Host "Checking WinGet path..."

if ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name -eq "NT AUTHORITY\SYSTEM") {
    $SystemAccount = $true
    Write-Host "Running as: SYSTEM"
} else {
    $SystemAccount = $false
    Write-Output "Not running as: SYSTEM"
}

if ($SystemAccount -eq $true) {
    Write-Host "Checking system WinGet path: $($env:SystemDrive)\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_8wekyb3d8bbwe\winget.exe"
    if (Test-Path -Path "$($env:SystemDrive)\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_8wekyb3d8bbwe\winget.exe"){
        $WinGetPath = "$($env:SystemDrive)\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_8wekyb3d8bbwe\winget.exe"
        Write-Host "WinGet path: $($WingetPath)"
    } else {
        Write-Host "Unable to determine WinGet SYSTEM context path!"
    }
} else {
    $GetWinGetPathUser = Get-Command winget.exe -ErrorAction SilentlyContinue
    if ($GetWinGetPathUser.Source) {
        $WinGetPath = "$($GetWinGetPathUser.Source)"
        Write-Host "WinGet path: $($WinGetPath)"
    } else {
        Write-Host "Unable to determine WinGet user context path!"
        exit 9999
    }
}

if ($UninstallCustomCommand) {
    Write-Host "Custom uninstall command specified!"
    Write-Host "Command: $($UninstallCustomCommand)"
    $Uninstall = "$($UninstallCustomCommand)"
    if ($UninstallCustomArguments) {
        Write-Host "Arguments: $($UninstallCustomArguments)"
        $Arguments = @("$UninstallCustomArguments")
    }
    try {
        Start-Process $($Uninstall) -ArgumentList $($Arguments) -Wait -Verbose
    } catch {
        Write-Host "Failed to $($Action) Custom: $($App)"
    }
} else {
    try {
        if ($($Action) -eq "install") {
            & $($WinGetPath) "$($Action)" --id "$($App)" --scope "$($Scope)" --silent --custom $($InstallCustomCommand) --override $($InstallOverrideCommand) --accept-package-agreements --accept-source-agreements --verbose
        } elseif ($($Action) -eq "uninstall") {
            & $($WinGetPath) "$($Action)" --id "$($App)" --silent --accept-source-agreements --verbose
        }
    } catch {
        Write-Host "Failed to $($Action): $($App)"
    }
}

Write-Host "Exit code: $($LASTEXITCODE)"

Stop-Transcript

exit $LASTEXITCODE

