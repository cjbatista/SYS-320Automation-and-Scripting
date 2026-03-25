<# String-Helper
*************************************************************
   This script contains functions that help with String/Match/Search
   operations. 
************************************************************* 
#>


<# ******************************************************
   Functions: Get Matching Lines
   Input:   1) Text with multiple lines  
            2) Keyword
   Output:  1) Array of lines that contain the keyword
********************************************************* #>
function getMatchingLines($contents, $lookline){

$allines = @()
$splitted =  $contents.split([Environment]::NewLine)

for($j=0; $j -lt $splitted.Count; $j++){  
 
   if($splitted[$j].Length -gt 0){  
        if($splitted[$j] -ilike $lookline){ $allines += $splitted[$j] }
   }

}

return $allines
}

function checkPassword {

    param (
        [String] $password
    )

    # Write-Host $password

    if ($password.Length -gt 5 -and $password -match '\d' -and $password -match '[a-z]' -and $password -match '[!@#$%^&*?\/~]+' ) {
        return $true
    } else {
        return $false
    }

}
