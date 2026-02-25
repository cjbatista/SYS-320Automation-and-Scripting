<# String-Helper
*************************************************************
   This script contains functions that help with String/Match/Search
   operations. 
************************************************************* #>

<# ******************************************************
   Function: getMatchingLines
   Input:   1) Text with multiple lines  
            2) Keyword
   Output:  1) Array of lines that contain the keyword
********************************************************* #>
function getMatchingLines($contents, $lookline){
    $allines = @()
    $splitted = $contents.split([Environment]::NewLine)
    for($j=0; $j -lt $splitted.Count; $j++){  
        if($splitted[$j].Length -gt 0){  
            if($splitted[$j] -ilike $lookline){ 
                $allines += $splitted[$j] 
            }
        }
    }
    return $allines
}

<# ******************************************************
   Function: checkPassword
   Input:   1) A plain-text password string
   Output:  1) True if password meets requirements, False if not
   Rules:   - At least 6 characters
            - At least 1 letter
            - At least 1 number
            - At least 1 special character
********************************************************* #>
function checkPassword($password){
    if($password.Length -lt 6){
        Write-Host "Password must be at least 6 characters long."
        return $false
    }
    if($password -notmatch '[a-zA-Z]'){
        Write-Host "Password must contain at least 1 letter."
        return $false
    }
    if($password -notmatch '[0-9]'){
        Write-Host "Password must contain at least 1 number."
        return $false
    }
    if($password -notmatch '[^a-zA-Z0-9]'){
        Write-Host "Password must contain at least 1 special character."
        return $false
    }
    return $true
}
