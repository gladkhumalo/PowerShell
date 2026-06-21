# Day 000 Setup Validation

Write-Host "Checking Environment..."

Write-Host "`nPowerShell Version:"
$PSVersionTable.PSVersion

Write-Host "`nComputer Name:"
$env:COMPUTERNAME

Write-Host "`nCurrent User:"
$env:USERNAME

Write-Host "`nDate:"
Get-Date