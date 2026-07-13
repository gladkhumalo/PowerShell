# Day 004 - Windows Event Log Analyzer

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "     Windows Event Log Analyzer           " -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

# Number of events to retrieve
$MaxEvents = 50

Write-Host "`nRetrieving the latest error and warning events..." -ForegroundColor Yellow

$Events = Get-WinEvent -LogName System -MaxEvents $MaxEvents |
Where-Object {
    $_.LevelDisplayName -in @("Error", "Warning")
} |
    Select-Object TimeCreated,
    LevelDisplayName,
    ProviderName,
    Id,
    Message

if ($Events.Count -eq 0) {
    Write-Host "`nNo warning or error events found." -ForegroundColor Green
} else {
    $Events | Format-Table TimeCreated, LevelDisplayName, ProviderName, Id -AutoSize

    Write-Host ""
    Write-Host "Summary" -ForegroundColor Green
    Write-Host "Events Found: $($Events.Count)"

    $Events | Export-Csv ".\event-log-report.csv" -NoTypeInformation

    Write-Host ""
    Write-Host "Report exported to event-log-report.csv" -ForegroundColor Yellow
}
