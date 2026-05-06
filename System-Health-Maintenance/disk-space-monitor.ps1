<#
.SYNOPSIS
    Monitors disk space on local or remote servers and sends alerts if below threshold.

.PARAMETER ComputerName
    One or more computer names (default: local machine)

.PARAMETER ThresholdGB
    Minimum free space in GB before alert

.PARAMETER ThresholdPercent
    Minimum free space percentage before alert

.PARAMETER EmailTo
    Email address(es) to send alert
#>

param(
    [string[]]$ComputerName = $env:COMPUTERNAME,
    [double]$ThresholdGB = 20,
    [int]$ThresholdPercent = 15,
    [string]$EmailTo = "admin@yourdomain.com",
    [string]$EmailFrom = "monitor@yourdomain.com",
    [string]$SMTPServer = "smtp.yourdomain.com"
)

$Report = @()
$Alert = $false

foreach ($Computer in $ComputerName) {
    try {
        $Disks = Get-CimInstance -ComputerName $Computer -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction Stop
        
        foreach ($Disk in $Disks) {
            $FreeGB = [math]::Round($Disk.FreeSpace / 1GB, 2)
            $TotalGB = [math]::Round($Disk.Size / 1GB, 2)
            $PercentFree = [math]::Round(($Disk.FreeSpace / $Disk.Size) * 100, 1)
            
            $Status = "Healthy"
            if ($FreeGB -lt $ThresholdGB -or $PercentFree -lt $ThresholdPercent) {
                $Status = "LOW SPACE - ALERT"
                $Alert = $true
            }
            
            $Report += [PSCustomObject]@{
                ComputerName = $Computer
                Drive        = $Disk.DeviceID
                TotalGB      = $TotalGB
                FreeGB       = $FreeGB
                PercentFree  = $PercentFree
                Status       = $Status
            }
        }
    }
    catch {
        $Report += [PSCustomObject]@{
            ComputerName = $Computer
            Drive        = "Error"
            TotalGB      = 0
            FreeGB       = 0
            PercentFree  = 0
            Status       = "ERROR: $($_.Exception.Message)"
        }
        $Alert = $true
    }
}

# Output to console and CSV
$Report | Format-Table -AutoSize
$Report | Export-Csv -Path "C:\Logs\DiskSpace_Report_$(Get-Date -Format 'yyyy-MM-dd_HH-mm').csv" -NoTypeInformation

# Send Email Alert if needed
if ($Alert -and $EmailTo) {
    $Body = $Report | ConvertTo-Html -Fragment | Out-String
    $Subject = "DISK SPACE ALERT - Low space detected on $($ComputerName -join ', ')"
    
    Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $Subject `
        -Body $Body -BodyAsHtml -SmtpServer $SMTPServer
    Write-Host "Alert email sent!" -ForegroundColor Red
}

Write-Host "Disk space check completed." -ForegroundColor Green
