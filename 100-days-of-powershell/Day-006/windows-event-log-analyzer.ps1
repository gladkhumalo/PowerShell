# ==========================================
# Day 006 - Windows Event Log Analyzer
# ==========================================

Write-Host "===== Windows Event Log Analyzer =====" -ForegroundColor Cyan

# Get events from the last 24 hours
$Yesterday = (Get-Date).AddDays(-1)

$Events = @(Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    Level = 2
    StartTime = $Yesterday
} -ErrorAction SilentlyContinue)
if ($Events.Count -eq 0)
{
    Write-Host "`nNo critical errors found in the last 24 hours." -ForegroundColor Green
}
else
{
    Write-Host "`nCritical Errors:" -ForegroundColor Red

    $Events |
    Select-Object TimeCreated, Id, ProviderName, LevelDisplayName, Message |
    Format-Table -AutoSize
}

$Events |
Select-Object TimeCreated, Id, ProviderName, LevelDisplayName, Message |
Export-Csv ".\SystemErrors.csv" -NoTypeInformation -Encoding utf8

Write-Host "Report exported to SystemErrors.csv"
