# Day 001 - System Information Reporter

# Gather system information
$ComputerName = $env:COMPUTERNAME
$OS = Get-CimInstance Win32_OperatingSystem
$CPU = Get-CimInstance Win32_Processor
$Memory = Get-CimInstance Win32_ComputerSystem

# Calculate RAM in GB
$RAM = [math]::Round($Memory.TotalPhysicalMemory / 1GB, 2)

# Display report
Write-Host "===================================" -ForegroundColor Green
Write-Host "     System Information Report     " -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green

Write-Host "`nComputer Name:"
Write-Host $ComputerName

Write-Host "`nOperating System:"
Write-Host "$($OS.Caption) $($OS.Version)"

Write-Host "`nProcessor:"
Write-Host $CPU.Name

Write-Host "`nMemory:"
Write-Host "$RAM GB"

Write-Host "`nDisk Information:"

Get-Volume | Where-Object { $_.DriveLetter } |
Select-Object @{
    Name = "Drive"
    Expression = { $_.DriveLetter }
}, @{
    Name = "SizeGB"
    Expression = { [math]::Round($_.Size / 1GB, 2) }
}, @{
    Name = "FreeGB"
    Expression = { [math]::Round($_.SizeRemaining / 1GB, 2) }
} | Format-Table -AutoSize

Write-Host "`nReport Generated:"
Write-Host (Get-Date)

# Create report object
$Report = [PSCustomObject]@{
    ComputerName = $ComputerName
    OperatingSystem = $OS.Caption
    OSVersion = $OS.Version
    Processor = $CPU.Name
    RAMGB = $RAM
    GeneratedOn = Get-Date
}

# Export report to CSV
$Report | Export-Csv -Path ".\system-report.csv" -NoTypeInformation

Write-Host "`nSystem report exported to system-report.csv" -ForegroundColor Yellow
