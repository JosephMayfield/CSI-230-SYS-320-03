$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.38/ToBeScraped.html

# Get a count of the links in the page
$scraped_page.count

#Display links as HTML Element
$scraped_page.Links  

#Display only URL and its text
$scraped_page.Links | Select-Object outerText,href

$h2s=$scraped_page.ParsedHtml.body.getElementsByTagName("h2") | Select-Object outerText

$h2s

#print innerText of every div element that has the classs as "div-1"
$divs1=$scraped_page.ParsedHtml.body.getElementsByTagName("div") | Where-Object {
$_.getAttributeNode("class").Value -ilike "*div-1"} | select innerText

$divs1