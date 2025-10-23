function ApacheLogs1 {
    # Path to the Apache access log
    $logsNotformatted = Get-Content "C:\xampp\apache\logs\access.log"
    $tableRecords = @()

    # Loop through each log entry
    for ($i = 0; $i -lt $logsNotformatted.Count; $i++) {

        # Split each line into separate words
        $words = $logsNotformatted[$i].Split(" ")

        # Add a new PSCustomObject for each record
        $tableRecords += [PSCustomObject]@{
            "IP"        = $words[0]
            "Time"      = $words[3].Trim('[')
            "Method"    = $words[5].Trim('"')
            "Page"      = $words[6]
            "Protocol"  = $words[7].Trim('"')
            "Response"  = $words[8]
            "Referrer"  = $words[10].Trim('"')
            "Client"    = ($words[11..($words.Length - 1)] -join " ").Trim('"')
        }
    } # end of for loop

    # Return only entries from the 10.* network
    return $tableRecords | Where-Object { $_.IP -like "10.*" }
}

# Call the function and display results in a formatted table
$tableRecords = ApacheLogs1
$tableRecords | Format-Table -AutoSize -Wrap
