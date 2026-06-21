# Day 001 - Environment Setup

## Objective

Set up my PowerShell learning environment and verify that all required tools are installed and working correctly.

## Script

```powershell
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
```
<!-- Sample output -->
![Screenshot](assets/Screenshot%202026-06-21%20222146.jpg)

## Concepts Learned

* Using `Write-Host` to display information
* Accessing environment variables with `$env:`
* Viewing PowerShell version information with `$PSVersionTable`
* Retrieving the current date and time using `Get-Date`

## Commands Used

```powershell
$PSVersionTable
Get-Date
```

## Example Output

```text
Checking Environment...

PowerShell Version:
7.5.2

Computer Name:
DESKTOP-XXXXXXX

Current User:
Glad

Date:
Sunday, June 21, 2026
```

## Reflection

Today I initialized my 100 Days of PowerShell journey, verified my development environment, and created my first PowerShell script. Everything is configured and ready for Day 001.
