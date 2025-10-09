function Get-ApacheLogs {
    param (
        [string]$Page,       # The page visited or referred from (index.html, page1.html, …)
        [string]$HttpCode,   # HTTP code returned (200, 404, 500, …)
        [string]$Browser     # Web browser (Chrome, Firefox, Edge, …)
    )

    # Path to Apache access log
    $logPath = "C:\xampp\apache\logs\access.log"

    # 1. Read the log
    $logs = Get-Content $logPath

    # 2. Filter logs based on parameters
    $filtered = $logs |
        Where-Object { $_ -match $Page -and $_ -match $HttpCode -and $_ -match $Browser }

    # 3. Extract IP addresses using regex
    $regex = [regex]"(\d{1,3}\.){3}\d{1,3}"
    $ipsUnorganized = foreach ($line in $filtered) {
        $match = $regex.Match($line)
        if ($match.Success) { $match.Value }
    }

    # 4. Convert IPs into objects
    $ips = foreach ($ip in $ipsUnorganized) {
        [pscustomobject]@{ IP = $ip }
    }

    # 5. Count occurrences
    $counts = $ips | Group-Object -Property IP | Select-Object Count, Name

    return $counts
}
