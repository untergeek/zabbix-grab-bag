Param($Ltr)
$Disk = Get-WmiObject -Class Win32_Volume | Where { $_.DriveLetter -eq $Ltr -and $_.DriveType -eq 0x3 }
if(-Not $Disk) {
    Write-Host ZBX_NOTSUPPORTED
    exit
}
$LastSnap = (Get-WMIObject win32_shadowcopy)|Where { $_.VolumeName -eq $Disk.DeviceId -and $_.ClientAccessible -eq $true }|Sort InstallDate|Select-Object -Last 1
if($LastSnap) {
    $Dt = [system.management.managementdatetimeconverter]::todatetime(($LastSnap).InstallDate)
    [int][double]::Parse((Get-Date ((Get-Date $Dt).ToUniversalTime()) -UFormat %s))
} else {
    Write-Host 0
}
