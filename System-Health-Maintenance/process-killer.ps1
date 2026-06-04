# ==========================================
# process-killer.ps1
# Automatically kills high CPU processes
# Then exports logs to CSV
# ==========================================

# CONFIGURATION
$cpuThreshold = 300

$excludedProcesses = @(
    "System",
    "Idle",
    "explorer",
    "svchost",
    "powershell"
)

# CSV LOG FILE
$csvLogFile = "$PSScriptRoot\process-killer-log.csv"

# CREATE CSV FILE IF IT DOESN'T EXIST
if (!(Test-Path $csvLogFile)) {

    [PSCustomObject]@{
        Timestamp   = ""
        ProcessName = ""
        PID         = ""
        CPUTime     = ""
        Status      = ""
    } | Export-Csv -Path $csvLogFile -NoTypeInformation
}

# FUNCTION: WRITE CSV LOG
function Write-CSVLog {
    param (
        [string]$ProcessName,
        [int]$ProcessID,
        [double]$CPUTime,
        [string]$Status
    )

    $logEntry = [PSCustomObject]@{
        Timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        ProcessName = $ProcessName
        PID         = $ProcessID
        CPUTime     = [math]::Round($CPUTime, 2)
        Status      = $Status
    }

    $logEntry | Export-Csv -Path $csvLogFile -Append -NoTypeInformation
}

Write-Host "Scanning for high CPU processes..." -ForegroundColor Cyan

# GET PROCESSES
$processes = Get-Process | Sort-Object CPU -Descending

foreach ($process in $processes) {

    # SKIP NULL CPU
    if ($null -eq $process.CPU) {
        continue
    }

    # SKIP EXCLUDED PROCESSES
    if ($excludedProcesses -contains $process.ProcessName) {
        continue
    }

    # CHECK CPU THRESHOLD
    if ($process.CPU -gt $cpuThreshold) {

        Write-Host "`nHigh CPU Process Detected:" -ForegroundColor Yellow
        Write-Host "Name : $($process.ProcessName)"
        Write-Host "CPU  : $([math]::Round($process.CPU,2))"
        Write-Host "PID  : $($process.Id)"

        try {
            Stop-Process -Id $process.Id -Force

            Write-Host "Process terminated." -ForegroundColor Red

            Write-CSVLog `
                -ProcessName $process.ProcessName `
                -PID $process.Id `
                -CPUTime $process.CPU `
                -Status "Killed"
        }
        catch {

            Write-Host "Failed to terminate process." -ForegroundColor DarkRed

            Write-CSVLog `
                -ProcessName $process.ProcessName `
                -PID $process.Id `
                -CPUTime $process.CPU `
                -Status "Failed"
        }
    }
}

Write-Host "`nScan complete." -ForegroundColor Green
Write-Host "CSV Log File: $csvLogFile"

<#
What to add next:

    Email alerts
    Teams/Slack notifications
    Whitelisting critical apps
    Scheduled Task automation
    CPU percentage instead of CPU time
    Interactive menu system
#>