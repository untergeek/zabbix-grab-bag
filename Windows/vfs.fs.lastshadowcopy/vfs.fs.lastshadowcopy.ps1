Param($Ltr)
$Ltr = $Ltr -replace ":",""
$Disk = Get-Volume | Where { $_.DriveLetter -eq $Ltr -and $_.DriveType -eq "Fixed" }
if(-Not $Disk) {
    Write-Host ZBX_NOTSUPPORTED
    exit
}

$LastSnap = (Get-WMIObject win32_shadowcopy)|Where { $_.VolumeName -eq $Disk.Path -and $_.ClientAccessible -eq $true }|Sort InstallDate|Select-Object -Last 1
$Dt = [system.management.managementdatetimeconverter]::todatetime(($LastSnap).InstallDate)

if($LastSnap) {
    [int][double]::Parse((Get-Date ((Get-Date $Dt).ToUniversalTime()) -UFormat %s))
} else {
    Write-Host 0
}
