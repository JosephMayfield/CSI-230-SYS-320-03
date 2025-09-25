# Define process and URL
$processName = "chrome"
$url = "https://www.champlain.edu"

# Check if Chrome is running
if (-not (Get-Process -Name $processName -ErrorAction SilentlyContinue)) {
    # Chrome not running, so start it and go to Champlain.edu
    Start-Process $processName $url
    Write-Host "Chrome started and directed to Champlain.edu"
}
else {
    # Chrome running, so stop it
    Get-Process -Name $processName | Stop-Process -Force
    Write-Host "Chrome was running and has been stopped"
}
