<#
.SYNOPSIS
    Create a current date markdown log file for notes from the command line or IDE.
    Written with pwsh (powershell core) for cross system compatibility.  

.DESCRIPTION
USAGE
    .\Scribe.ps1 Command Entry

COMMANDS
    edit: Open file in current session for manual edit. 
    help: Access this help content.
    log: Record new log entry, create log file for current date if none exists.        
    list: Returns all files in the logs directory ordered by date descending.
    search: Pattern search of all markdown files in logs directory. 
    test: Execute this script with no side effects.
    publish: TBD
    
LOGIC
    Check for existence of log file with current date file name.
    Create the file if it doesn't exist in log directory.  
    Log File naming convention is YYYYMMDD.md i.e. 20211120.md   
    
    Apply a markdown template for the new entry in the log file.
    Each entry is stamped with a UTC date time to the microsecond with timezone offset.
    The first line logged will use Markdown header two format.
    Markdown syntax is supported for log entries.
    Entries are separated by a horizontal rule and a new line.
    
    i.e. 
    2021-11-19T17:02:17.9448727-05:00

    ## This is a multiline log entry
    - bullet 1
    - bullet 2
    - bullet 3
    - [ ] task 1
    - [ ] task 2


    ---

    Provide features for log, edit, search, and help to facilitate note taking 
    and use of notes for problem solving.

SETUP
    Create your a directory for your log files.
    Copy this script (Scribe.ps1)

    Make things easier for linking content.
    Useful for screenshots and bug reporting etc.

    Configure OS to save screenshots to folder.
    i.e. C:\Users\dj\OneDrive\Pictures\Captures
    
    When a screenshot is taken, it is easy to link your notes to the image,
    using markdown syntax.

EXAMPLES
    
    Create an alias for ease of use:
        set-alias -name l -value .\Scribe.ps1
    
    Single Line Entry:    
        Input:
        l log this is a single line entry

        Output:
        2021-11-19T17:07:43.7853097-05:00

        ## this is a single line entry

        ---

    Screenshot Links:
        Include a screenshot with normal markdown linking
        Input:
        In this case we use the sub directory for our image link.
        l log '![Random Screenshot](./Captures/20211116.png)'
        
        Please note, to make capturing screenshots easier,
        make the default location for screenshots a sub directory
        under the logs directory.
        This makes linking to the image relative path easier.
        
        Windows Capture Settings will only allow a 
        directory with the name Captures.

        This is multipart operation.
        1. Create a Captures directory under logs.
        i.e. ../logs/Captures.

        2. Go to the default Pictures/Screenshot
            right click and select location.
        3. Move the location to your shiny new minty 
            ../Codex/logs/Capture directory.
        4. Test single and multi screenshots.
        5. All screenshots should go to the new Captures
            directory under your logs directory.

    Multiline Entry:
        Log entry uses a single or double quote to open and close the multiline entry.
        
        Input:
        l log 'This is a multiline log entry 
        >> - bullet 1
        >> - bullet 2
        >> - bullet 3
        >> - [ ] task 1
        >> - [ ] task 2
        >> '

        Output:
        2021-11-19T17:02:17.9448727-05:00

        ## This is a multiline log entry
        - bullet 1
        - bullet 2
        - bullet 3
        - [ ] task 1
        - [ ] task 2


        ---

    Code Snippet Log Entry:
        Code snippet logging, same rules as above, and we add the markdown backtick for `code` content rendering.

        Input:
        l log 'Powershell Rename All Markdown Files to YYYYMMDD-Name.md  
        >> `gci *.md | %{$logdate = ($_.LastWriteTime).ToString("yyyyMMdd"); $newName = "$logdate-$($_.Name)"; $_ | Rename-Item -NewName  $newName }`'

        Output:
        2021-11-19T17:00:38.5762163-05:00

        ## Powershell Rename All Markdown Files to YYYYMMDD-Name.md  
        `gci *.md | %{$logdate = ($_.LastWriteTime).ToString("yyyyMMdd"); $newName = "$logdate-$($_.Name)"; $_ | Rename-Item -NewName  $newName }`

        ---
HELP
    .\scribe.ps1

    .\scribe.ps1 help

    .\scribe.ps1 -?

    Get-Help .\scribe.ps1





.NOTES
    CREDITS
        Concepts    
            https://dev.to/scottshipp/series/15100

        Powershell CLI basics
            https://kevinareed.com/2021/04/14/creating-a-command-based-cli-in-powershell/
        
#>

param(
    [Parameter(Position = 0)]
    [ValidateSet("edit", "help", "log", "list", "search", "test")]
    [string]$Command,

    [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
    $Rest
)


function invoke-help { Get-Help $PSCommandPath }

if (!$Command) {
    invoke-help
    exit
}

# Set default logging location
$sourceDirectory = "$PSScriptRoot\logs\"

function invoke-logfile {
    param (
        [Parameter(Position = 0, Mandatory = $True)]
        [string]$logEntry
    )

    # Create new file name
    $logDate = (get-date).ToString("yyyyMMdd")
    $fileName = "$logDate.md"
    
    # Full path of the file with name
    $fullFileName = "$($sourceDirectory)$($fileName)"

    #If the file does not exist, create it.
    if (-not(Test-Path -Path $fullFileName -PathType Leaf)) {
        try {
            $null = New-Item -ItemType File -Path $fullFileName -Force -ErrorAction Stop
            Write-Host "The file [$fullFileName] has been created."
            
            #Append new entry
            invoke-appendEntry $logEntry $fullFileName
        }
        catch {
            $Exception = $_; 
            $Exception | 
                Format-List * -Force |
                Out-String ; 
            
            $Exception.InvocationInfo |
                Format-List * -Force |
                Out-String;
        }
    }
    # If the file already exists, append new entry.
    else {
    try {
        #Write-Host "Cannot create [$fullFileName] because a file with that name already exists."
        invoke-appendEntry $logEntry $fullFileName
    }
    catch {
        $Exception = $_; 
        $Exception | 
            Format-List * -Force |
            Out-String ; 
        
        $Exception.InvocationInfo |
            Format-List * -Force |
            Out-String;
    }

    }
}

function invoke-appendEntry {
    param (
        [Parameter(Position = 0, Mandatory = $True)]
        [string]$entry,
        [Parameter(Position = 1, Mandatory = $True)]
        [string]$fullFileName
    )

    #generate a utc timestamp with offset for timezone
    $timeStamp = ((get-date)).ToString("yyyy-MM-ddTHH:mm:ss.fffffffzzz")

    #apply markdown template
    #make use of the double quoted here-string in powershell for the log entry.
    $appendEntry = 
@"

$timeStamp

## $entry

---

"@

    #Append the new entry to log file
    Add-Content $fullFileName $appendEntry
}

function invoke-searchentry {
    param (
        [Parameter(Position = 0, Mandatory = $True)]
        [string]$pattern
    )

    Get-ChildItem -path $sourceDirectory | Sort-Object -Property {$_.LastWriteTime} -Descending | Select-String -pattern $pattern
}

function invoke-editlog {
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [string]$logFileName   
    )

    if (!($logFileName)) {
        $logFileName = (Get-ChildItem $sourceDirectory | Sort-Object -Descending -Property LastWriteTime | Select-Object -First 1).Name
    }

    $fullFileName = "$($sourceDirectory)$($logFileName)"
    Start-Process $fullFileName
     
}

function invoke-listlogs {

    (Get-ChildItem $sourceDirectory | Sort-Object -Descending -Property LastWriteTime)
    
}

switch ($Command) {
    "edit" { invoke-editlog $Rest }
    "help" { invoke-help }
    "log" { invoke-logfile $Rest } 
    "list" { invoke-listlogs $Rest }
    "search" { invoke-searchentry $Rest }
    "test" { write-host $Rest }
}