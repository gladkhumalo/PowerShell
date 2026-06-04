# Script1-Basics.ps1
Write-Host "=== PowerShell Basics ===" -ForegroundColor Cyan

# Variables
$name = "Alex"
$age = 28
$isAdmin = $true

Write-Host "Name: $name | Age: $age | Admin: $isAdmin"

# User Input
$userName = Read-Host "Enter your name"
$number1 = [int](Read-Host "Enter first number")
$number2 = [int](Read-Host "Enter second number")

$result = $number1 + $number2
Write-Host "Hello $userName! $number1 + $number2 = $result" -ForegroundColor Green