<#
.SYNOPSIS
Unistalling kaspersky Endpoint Security using Windows Uninstallstring.

.DESCRIPTION
This script finds and removes (uninstall) Kaspersky Endpoint Security from a Windows 10 computer.
This will also work on Windows 7 and Windows 8, but the Registry's path might change.

.EXAMPLE
start-process "msiexec.exe" -arg "/X $uninstall64 /qb" -Wait

The next cmdlet displays all installed applications and their Uninstallstring:
Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, UninstallString | Format-Table -AutoSize

.NOTES
In order to uninstall any program using this script, you will have to run this script as admin.You can also automate by creating a function and just inputting a name for the program that needs to be removed.

Author: Omar Rosa
#>

$uninstall32 = gci "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "Kaspersky Endpoint Security" } | select UninstallString
$uninstall64 = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "Kaspersky Endpoint Security" } | select UninstallString

if ($uninstall64) {
#The following line removes unnecessary components of the Uninstallstring string. We are just basically extracting the "Uninstallstring" string.
$uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X","" 
$uninstall64 = $uninstall64.Trim()
Write "Uninstalling..."
start-process "msiexec.exe" -arg "/X $uninstall64 /qb" -Wait}

if ($uninstall32) {
$uninstall32 = $uninstall32.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall32 = $uninstall32.Trim()
Write "Uninstalling..."
start-process "msiexec.exe" -arg "/X $uninstall32 /qb" -Wait}

