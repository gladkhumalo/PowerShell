<#
.SYNOPSIS
    Disk Space Monitoring & Alert Script
    Checks free space on local or remote drives (fixed disks only).
    Logs all results and sends alerts via Email and/or Slack if free space falls below a threshold.

.DESCRIPTION
    - Uses Get-CimInstance Win32_LogicalDisk (works locally + remotely)
    - Calculates free space percentage
    - Logs every check to a file (timestamped)
    - If any drive is below threshold, sends consolidated alert (Email + Slack if configured)
    - Prevents outages by early warning on low disk space

.EXAMPLE
    # Basic local check (15% threshold)
    .\DiskSpaceMonitor.ps1

    # Remote servers + custom threshold + email + Slack
    .\DiskSpaceMonitor.ps1 -ComputerName "SRV01","SRV02" -ThresholdPercent 20 `
        -SmtpServer "smtp.contoso.com" -FromEmail "alert@contoso.com" -ToEmail "admin@contoso.com" `
        -SlackWebhook "https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXX"

.NOTES
    Key cmdlets used: Get-CimInstance, Send-MailMessage, Invoke-RestMethod
    Run as scheduled task for continuous monitoring.
#>

param(
    # Computer(s) to check (localhost works for local machine)
    [string[]]$ComputerName = @("localhost"),

    # Alert if free space % is at or below this value
    [int]$ThresholdPercent = 15,

    # Log file path (will create directory if it doesn't exist)
    [string]$LogFile = "C:\DiskSpaceMonitor\DiskSpace.log",

    # === EMAIL ALERT SETTINGS (optional - leave blank to disable) ===
    [string]$SmtpServer,
    [string]$FromEmail,
    [string[]]$ToEmail,

    # === SLACK ALERT SETTINGS (optional - leave blank to disable) ===
    # Slack Incoming Webhook URL (create one in Slack: https://api.slack.com/apps)
    [string]$SlackWebhook
)

# ============================================================================
# Setup logging
# ============================================================================
$logDir = Split-Path $LogFile -Parent
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $LogFile -Append -Encoding UTF8
}

Write-Log "=== Disk Space Monitoring Started ==="

# ============================================================================
# Collect alerts
# ============================================================================
$alertMessages = @()

foreach ($computer in $ComputerName) {
    try {
        # Get fixed drives (DriveType=3) - works locally and remotely
        $disks = Get-CimInstance -ClassName Win32_LogicalDisk `
                                 -ComputerName $computer `
                                 -Filter "DriveType=3" `
                                 -ErrorAction Stop

        foreach ($disk in $disks) {
            if ($disk.Size -eq 0) { continue }  # Skip zero-size entries

            $freePercent = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)
            $sizeGB      = [math]::Round($disk.Size / 1GB, 2)
            $freeGB      = [math]::Round($disk.FreeSpace / 1GB, 2)
            $driveLetter = $disk.DeviceID

            $logLine = "Computer: $computer | Drive: $driveLetter | Size: ${sizeGB} GB | Free: ${freeGB} GB (${freePercent}%)"
            Write-Log $logLine

            # Check threshold
            if ($freePercent -le $ThresholdPercent) {
                $alert = "ALERT: Low disk space on $computer - Drive $driveLetter is at ${freePercent}% free (${freeGB} GB free / ${sizeGB} GB total)"
                Write-Log $alert
                $alertMessages += $alert
            }
        }
    }
    catch {
        $err = "ERROR: Failed to check $computer - $($_.Exception.Message)"
        Write-Log $err
        $alertMessages += $err
    }
}

# ============================================================================
# Send alerts if any were triggered
# ============================================================================
if ($alertMessages.Count -gt 0) {
    $subject = "Disk Space Alert - Low Free Space Detected"
    $body = @"
Disk Space Monitoring Alert
===========================
$($alertMessages -join "`n`n")
Threshold: $ThresholdPercent%
Checked at: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Log file: $LogFile
"@

    # --- EMAIL ALERT ---
    if ($SmtpServer -and $FromEmail -and $ToEmail) {
        try {
            Send-MailMessage -SmtpServer $SmtpServer `
                             -From $FromEmail `
                             -To $ToEmail `
                             -Subject $subject `
                             -Body $body `
                             -ErrorAction Stop
            Write-Log "Email alert sent successfully to $($ToEmail -join ', ')"
        }
        catch {
            Write-Log "Failed to send email: $($_.Exception.Message)"
        }
    }

    # --- SLACK ALERT ---
    if ($SlackWebhook) {
        try {
            $payload = @{
                text = "$subject`n`n$body"
            } | ConvertTo-Json -Depth 3

            Invoke-RestMethod -Uri $SlackWebhook `
                              -Method Post `
                              -Body $payload `
                              -ContentType "application/json" `
                              -ErrorAction Stop | Out-Null

            Write-Log "Slack alert sent successfully"
        }
        catch {
            Write-Log "Failed to send Slack alert: $($_.Exception.Message)"
        }
    }
}
else {
    Write-Log "No drives below threshold ($ThresholdPercent%). All clear."
}

Write-Log "=== Disk Space Monitoring Completed ===`n"
