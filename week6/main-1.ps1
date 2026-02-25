. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

clear

$Prompt  = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - List At-Risk Users`n"
$Prompt += "10 - Exit`n"

$operation = $true

while($operation){

    Write-Host $Prompt
    $choice = Read-Host "Enter choice"

    # ── Exit ────────────────────────────────────────────────
    if($choice -eq 10){
        Write-Host "Goodbye"
        $operation = $false
    }

    # ── 1: List Enabled Users ───────────────────────────────
    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    # ── 2: List Disabled Users ──────────────────────────────
    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }

    # ── 3: Create a User ────────────────────────────────────
    elseif($choice -eq 3){
        $name = Read-Host "Please enter the username for the new user"

        if(checkUser $name){
            Write-Host "A user with the name '$name' already exists. Please choose a different username."
        }
        else {
            $passwordPlain   = Read-Host "Please enter the password for the new user"
            $passwordIsValid = checkPassword $passwordPlain

            if(-not $passwordIsValid){
                Write-Host "User was not created due to invalid password."
            }
            else {
                $securePassword = ConvertTo-SecureString $passwordPlain -AsPlainText -Force
                createAUser $name $securePassword
                Write-Host "User: $name has been created (disabled by default)."
            }
        }
    }

    # ── 4: Remove a User ────────────────────────────────────
    elseif($choice -eq 4){
        $name = Read-Host "Please enter the username for the user to be removed"

        if(-not (checkUser $name)){
            Write-Host "User '$name' does not exist."
        }
        else {
            removeAUser $name
            Write-Host "User: $name has been removed."
        }
    }

    # ── 5: Enable a User ────────────────────────────────────
    elseif($choice -eq 5){
        $name = Read-Host "Please enter the username for the user to be enabled"

        if(-not (checkUser $name)){
            Write-Host "User '$name' does not exist."
        }
        else {
            enableAUser $name
            Write-Host "User: $name has been enabled."
        }
    }

    # ── 6: Disable a User ───────────────────────────────────
    elseif($choice -eq 6){
        $name = Read-Host "Please enter the username for the user to be disabled"

        if(-not (checkUser $name)){
            Write-Host "User '$name' does not exist."
        }
        else {
            disableAUser $name
            Write-Host "User: $name has been disabled."
        }
    }

    # ── 7: Get Log-In Logs ──────────────────────────────────
    elseif($choice -eq 7){
        $name = Read-Host "Please enter the username to filter logs"

        if(-not (checkUser $name)){
            Write-Host "User '$name' does not exist."
        }
        else {
            $days = Read-Host "How many days back would you like to search?"
            if($days -match '^\d+$'){
                $userLogins = getLogInAndOffs $days
                Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name" } | Format-Table | Out-String)
            }
            else {
                Write-Host "Please enter a valid number of days."
            }
        }
    }

    # ── 8: Get Failed Log-In Logs ───────────────────────────
    elseif($choice -eq 8){
        $name = Read-Host "Please enter the username for the user's failed login logs"

        if(-not (checkUser $name)){
            Write-Host "User '$name' does not exist."
        }
        else {
            $days = Read-Host "How many days back would you like to search?"
            if($days -match '^\d+$'){
                $userLogins = getFailedLogins $days
                Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name" } | Format-Table | Out-String)
            }
            else {
                Write-Host "Please enter a valid number of days."
            }
        }
    }

    # ── 9: List At-Risk Users ────────────────────────────────
    elseif($choice -eq 9){
        $days = Read-Host "How many days back would you like to search?"

        if($days -notmatch '^\d+$'){
            Write-Host "Please enter a valid number of days."
        }
        else {
            $allFailed = getFailedLogins $days

            $atRisk = $allFailed |
                Group-Object User |
                Where-Object { $_.Count -gt 10 } |
                Select-Object @{Name="User"; Expression={$_.Name}},
                              @{Name="FailedAttempts"; Expression={$_.Count}} |
                Sort-Object FailedAttempts -Descending

            if($atRisk){
                Write-Host "`nAt-Risk Users (more than 10 failed logins in the last $days days):"
                Write-Host ($atRisk | Format-Table | Out-String)
            }
            else {
                Write-Host "No at-risk users found in the last $days days."
            }
        }
    }

    # ── Invalid Input ────────────────────────────────────────
    else {
        Write-Host "Invalid choice '$choice'. Please enter a number between 1 and 10."
    }
}
