. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)
. (Join-Path $PSScriptRoot String-Helper.ps1)

clear

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - List at Risk Users`n"
$Prompt += "10 - Exit`n"



$operation = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 10){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false
    }

    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }


    # Create a user
    elseif($choice -eq 3){

        $name = Read-Host -Prompt "Please enter the username for the new user"
        $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"

        # Check if user already exists
        if (checkUser $name) {
            Write-Host "User: $name already exists." | Out-String
            continue
        }

        # Check if password meets requirements
        if (-not (checkPassword $password)) {
            Write-Host "Password does not meet requirements. Password must be at least 6 characters and contain at least 1 letter, 1 number, and 1 special character." | Out-String
            continue
        }

        createAUser $name $password

        Write-Host "User: $name is created." | Out-String
    }


    # Remove a user
    elseif($choice -eq 4){

        $name = Read-Host -Prompt "Please enter the username for the user to be removed"

        if (-not (checkUser $name)) {
            Write-Host "User: $name does not exist." | Out-String
            continue
        }

        removeAUser $name

        Write-Host "User: $name Removed." | Out-String
    }


    # Enable a user
    elseif($choice -eq 5){

        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"

        if (-not (checkUser $name)) {
            Write-Host "User: $name does not exist." | Out-String
            continue
        }

        enableAUser $name

        Write-Host "User: $name Enabled." | Out-String
    }


    # Disable a user
    elseif($choice -eq 6){

        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"

        if (-not (checkUser $name)) {
            Write-Host "User: $name does not exist." | Out-String
            continue
        }

        disableAUser $name

        Write-Host "User: $name Disabled." | Out-String
    }


    elseif($choice -eq 7){

        $name = Read-Host -Prompt "Please enter the username for the user logs"

        if (-not (checkUser $name)) {
            Write-Host "User: $name does not exist." | Out-String
            continue
        }

        $days = Read-Host -Prompt "Please enter the number of days to search"
        $userLogins = getLogInAndOffs $days

        Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }


    elseif($choice -eq 8){

        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"

        if (-not (checkUser $name)) {
            Write-Host "User: $name does not exist." | Out-String
            continue
        }

        $days = Read-Host -Prompt "Please enter the number of days to search"
        $userLogins = getFailedLogins $days

        Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }


    # List at Risk Users
    elseif($choice -eq 9){

        $days = Read-Host -Prompt "Please enter the number of days to search"
        $failedLogins = getFailedLogins $days

        # Group by user and count failed logins
        $atRiskUsers = $failedLogins | Group-Object -Property User | Where-Object { $_.Count -gt 10 } | Select-Object Name, Count

        if ($atRiskUsers) {
            Write-Host ($atRiskUsers | Format-Table | Out-String)
        } else {
            Write-Host "No at-risk users found with more than 10 failed logins in the last $days days." | Out-String
        }
    }


    # Invalid input handling
    else {
        Write-Host "Invalid choice. Please enter a number between 1 and 10." | Out-String
    }
    

}
