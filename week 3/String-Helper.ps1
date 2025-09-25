#Get login and logoff records from Windows Events and save to a variable 
#Get the last 14 days 
$loginouts = Get-EventLog system -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-40)

$loginoutsTable = @() #Empty array to fill customly
for($i=0; $i -lt $loginouts.Count; $i++){

#Creating event property value 
$event = ""
if($loginouts[$i].InstanceID -eq 7001) {$type="Logon"}
if($loginouts[$i].InstanceID -eq 7002) {$type="Logoff"}

# Creating user property value 
$user = $loginouts[$i].ReplacementStrings[1]

$user = (New-Object System.Security.Principal.SecurityIdentifier `
        $loginouts[$i].ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])

#Adding each new line (in form of a custom object) to our empty array
$loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated; `
                                        "Id" = $loginouts[$i].InstanceId; `
                                     "Event" = $event; `
                                      "User" = $user;
                                      }
} # End of For

return $loginoutsTable

<#************************
    Function Explaination
**************************#>
function getFailedLogins($timeBack){

$failedlogins = Get-EventLog security -After (Get-Date).AddDays("-"+"$timeBack") | Where { $_InstanceID -eq "4625" }

$failedlogins = @()
for(i=0; $i -lt $failedlogins.Count; $i++){

  $account=""
  $domain=""

  #$failedlogins[i].Message | Out-String
    $usrlines = getMatchingLines $failedlogins[$i].Message "*Account 
Name*"
    $usr = $usrlines[1].Split(":")[1].trim()

    $dmnlines = getMatchingLines $failedlogins[$i].Message "*Account
Domain*"
    $dmn = $dmnlines[1].Split(":")[1].trim()

    $user = $dmn+"\"+$usr;

    $failedloginsTable += [pscustomobject]@{"Time" =
$failedlogins[$i].TimeGenerated; `
                                       "Id" =
$failedlogins[$i].InstanceId; `
                                    "Event" = "Failed";
                                     "User" = $user;
                                     }
}

return $failedloginsTable
} # End of function FailedloginsTable

<# **********************
     Function Explaination
    ***********************#>
function getShutDowns($timeBack){

 $shutdowns = Get-EventLog system -After (Get-Date).AddDays("-"+"$timeBack") | Where { $_.EventID -eq "6006" }
    
 $shutdownsTable = @() 
 for($i=0; $i -lt $shutdowns.Count; $i++){
                         
   $shutdownsTable += [pscustomobject]@{"Time" = $shutdowns[$i].TimeGenerated; `
                                      "Id" = $shutdowns[$i].EventId; `
                                   "Event" = "Shutdown"; `
                                    "User" = "System";
                                    }
}

return $shutdownsTable
} # End of Function getShutDowns()

<#******************************
    Function Explaination
***************************** #>
function getStartUps($timeBack){

  $startups = Get-EventLog system -After (Get-Date).AddDays("-
"+"$timeBack") | Where { $_.EventID -eq "6005" }

  $startupsTable = @()
  for($i=0; $i -lt $startups.Count; $i++){

    $startupsTable += [pscustomobject]@{"Twin" =
$startups[$i].TimeGenerated; `
                                       "Id" = $startups[$i].EventId; `
                                    "Event" = "Startup"; `
                                     "User" = "System";
                                     }
}

return $startupsTable
} # End of function getstartUps


