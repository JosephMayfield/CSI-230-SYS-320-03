. (Join-Path "C:\champuser\Downloads" String-Helper.ps1)

clear

#Get Login and Logoffs from the last 15 days
$loginoutTable = getLogInAndOffs 40;
$loginoutTable

# Get Shut Downs from the last 25 days
$shutdownsTable = getShutDowns 40;
$shutdownsTable

# Get Start Ups from the last 25 days
$startupsTable = getStartUps 40;
$startupsTable 