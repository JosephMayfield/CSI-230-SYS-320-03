function Get-ApacheLogs {
    param (
        [string]$Page,       # The page visited (index.html, page1.html, …)
        [string]$HttpCode,   # HTTP code returned (200, 404, 500, …)
        [string]$Browser     # Web browser (Chrome, Firefox, Edge, …)
    )

    # Path to Apache access log
    $logPath = "C:\xampp\apache\logs\access.log"

    # 1. Read and parse the log file
    $logsNotFormatted = Get-Content $logPath
    $tableRecords = @()

    for ($i = 0; $i -lt $logsNotFormatted.Count; $i++) {
        # Split each log line into parts
        $words = $logsNotFormatted[$i] -split " "

        if ($words.Length -gt 11) {
            $tableRecords += [PSCustomObject]@{
                IP        = $words[0]
                Time      = $words[3].Trim('[')
                Method    = $words[5].Trim('"')
                Page      = $words[6]
                Protocol  = $words[7].Trim('"')
                Response  = $words[8]
                Referrer  = $words[10].Trim('"')
                Client    = ($words[11..($words.Length - 1)] -join " ")
            }
        }
    }

    # 2. Apply filtering based on parameters
    $filtered = $tableRecords | Where-Object {
        ($null -eq $Page -or $_.Page -match $Page) -and
        ($null -eq $HttpCode -or $_.Response -match $HttpCode) -and
        ($null -eq $Browser -or $_.Client -match $Browser)
    }

    # 3. Count IP occurrences in the filtered data
    $counts = $filtered |
        Group-Object -Property IP |
        Select-Object Name, Count

    # 4. Return results
    return $counts
}

# Example usage
$tableRecords = Get-ApacheLogs -Page "index.html" -HttpCode "200" -Browser "Chrome"
$tableRecords | Format-Table -AutoSize -Wrap
