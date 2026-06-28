# Day 003 - Disk Space Monitor

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "       Disk Space Monitor          " -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

$WarningThreshold = 20

$DiskReport = foreach ($Drive in Get-Volume | Where-Object { $_.DriveLetter }) {

    $SizeGB = [math]::Round($Drive.Size / 1GB, 2)
    $FreeGB = [math]::Round($Drive.SizeRemaining / 1GB, 2)
    $UsedGB = [math]::Round($SizeGB - $FreeGB, 2)

    $FreePercent = [math]::Round(($Drive.SizeRemaining / $Drive.Size) * 100, 2)

    $Health = if ($FreePercent -lt $WarningThreshold) {
        "WARNING"
    }
    else {
        "Healthy"
    }

    [PSCustomObject]@{
        Drive          = $Drive.DriveLetter
        FileSystem     = $Drive.FileSystemType
        SizeGB         = $SizeGB
        UsedGB         = $UsedGB
        FreeGB         = $FreeGB
        FreePercent    = "$FreePercent%"
        Health         = $Health
    }
}

$DiskReport | Format-Table -AutoSize

$Warnings = $DiskReport | Where-Object { $_.Health -eq "WARNING" }

Write-Host ""
Write-Host "Summary" -ForegroundColor Green
Write-Host "Drives Checked : $($DiskReport.Count)"
Write-Host "Warnings Found : $($Warnings.Count)"

$DiskReport | Export-Csv ".\disk-space-report.csv" -NoTypeInformation

Write-Host ""
Write-Host "Disk report exported to disk-space-report.csv" -ForegroundColor Yellow