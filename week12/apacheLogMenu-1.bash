#! /bin/bash

logFile="/var/log/apache2/access.log.1"

function displayAllLogs(){
        cat "$logFile"
}

function displayOnlyIPs(){
        cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c
}

# function: displayOnlyPages:
# like displayOnlyIPs - but only pages
function displayOnlyPages(){
        cat "$logFile" | awk '{print $7}' | sort | uniq -c
}

function histogram(){

        local visitsPerDay=$(cat "$logFile" | cut -d " " -f 4,1 | tr -d '['  | sort \
                              | uniq)

        :> newtemp.txt
        echo "$visitsPerDay" | while read -r line;
        do
                local withoutHours=$(echo "$line" | cut -d " " -f 2 \
                                     | cut -d ":" -f 1)
                local IP=$(echo "$line" | cut -d  " " -f 1)

                local newLine="$IP $withoutHours"
                echo "$IP $withoutHours" >> newtemp.txt
        done 
        cat "newtemp.txt" | sort -n | uniq -c
}

# Frequent visitors (>10)
function frequentVisitors(){
        histogram | while read -r count ip day;
        do
                if [[ $count -gt 10 ]]; then
                        echo "$count $ip $day"
                fi
        done
}

# Suspicious visitors (requires ioc.txt)
function suspiciousVisitors(){
        if [[ ! -f ioc.txt ]]; then
                echo "ioc.txt not found!"
                return
        fi

        grep -f ioc.txt "$logFile" | awk '{print $1}' | sort -n | uniq -c
}

while :
do
        echo "PLease select an option:"
        echo "[1] Display all Logs"
        echo "[2] Display only IPS"
        echo "[3] Display only pages visited"
        echo "[4] Histogram"
        echo "[5] Frequent visitors (>10)"
        echo "[6] Suspicious visitors"
        echo "[7] Quit"

        read userInput
        echo ""

        if [[ "$userInput" == "7" ]]; then
                echo "Goodbye"        
                break

        elif [[ "$userInput" == "1" ]]; then
                echo "Displaying all logs:"
                displayAllLogs

        elif [[ "$userInput" == "2" ]]; then
                echo "Displaying only IPS:"
                displayOnlyIPs

        elif [[ "$userInput" == "3" ]]; then
                echo "Displaying only pages visited:"
                displayOnlyPages

        elif [[ "$userInput" == "4" ]]; then
                echo "Histogram:"
                histogram

        elif [[ "$userInput" == "5" ]]; then
                echo "Frequent visitors (>10):"
                frequentVisitors

        elif [[ "$userInput" == "6" ]]; then
                echo "Suspicious visitors:"
                suspiciousVisitors

        else
                echo "Invalid input, try again."
        fi
done
