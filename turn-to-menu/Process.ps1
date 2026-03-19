function openChrome {

   $chrome = Get-Process chrome -ErrorAction SilentlyContinue

   if (-not $chrome){

       Start-Process "C:\Program Files\Google\Chrome\Application\chrome.exe" "https://www.champlain.edu"

   }
   else{

       Write-Host "Chrome is already running"

   }
}
