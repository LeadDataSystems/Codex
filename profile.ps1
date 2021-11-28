<#
.SYNOPSIS
This is a sample profile.ps1 script, used to demonstrate
a technique to alias a PowerShell script in new PowerShell sessions
It allows a shortened command line interface from any directory location
on the machine.
Note PowerShell profiles are located in different locations for various reasons.
get-help about_profiles describes the use of profiles.

This code is designed to run in the scope of current user all hosts.
$Home\[My ]Documents\PowerShell\Profile.ps1
in my environment this file is located at 
C:\Users\dj\OneDrive\Documents\PowerShell\profile.ps1

.DESCRIPTION
Long description

.PARAMETER Command
Parameter description

.PARAMETER Rest
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function invoke-codex {
    param(
        [Parameter(Position = 0)]
        #[ValidateSet("edit", "help", "log", "list", "search", "test")]
        [string]$Command,

        [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
        $Rest
    )
    try {

        # Get the current location so we can return to it in the finally block.
        $currentLocation = Get-Location

        # Set an env variable.
        # TODO: Move this to system env variable reference.
        $env:Codex = 'X:\OneDrive\Documents\root\lds\Projects\Codex\'
        
        # Use location to call script and pass params through.
        set-location $env:Codex
        ./Scribe.ps1 $Command $Rest

    } 
    finally {
        # In all conditions return to the original location.
        set-location $currentLocation
    }
}

# Set alias for reference and use at command line.
Set-Alias codex invoke-codex 