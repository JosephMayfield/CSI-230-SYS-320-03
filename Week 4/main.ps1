# main.ps1
# ------------------------------------------
# Main script to execute Get-ApacheLogs.ps1
# ------------------------------------------

# Import the function script (make sure it's in the same folder)
.(Join-Path $PSScriptRoot Apache-Logs.ps1)

# Prompt user for inputs
$page = Read-Host "Enter page to search (e.g., index.html or press Enter to skip)"
$httpCode = Read-Host "Enter HTTP code (e.g., 200, 404, or press Enter to skip)"
$browser = Read-Host "Enter browser name (e.g., Chrome, Firefox, or press Enter to skip)"

# Run the function and capture results
$results = Get-ApacheLogs -Page $page -HttpCode $httpCode -Browser $browser

# Display header
Write-Host "`n--- Apache Log Summary ---" -ForegroundColor Cyan
Write-Host "Page: $page | HTTP Code: $httpCode | Browser: $browser`n" -ForegroundColor Yellow

# Display formatted output
if ($results.Count -gt 0) {
    $results | Format-Table -AutoSize -Wrap
} else {
    Write-Host "No matching log entries found." -ForegroundColor Red
}
