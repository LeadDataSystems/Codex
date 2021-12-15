# Codex
 ## A simple process for recording notes in markdown from the command line.

 ### Origin
 #### The idea for Codex came from this excellent 4 part write up and code repo from Scott Shipp (@scottashipp).
   - Post: https://dev.to/scottshipp/an-amazing-note-taking-system-with-markdown-and-git-part-1-48b1
     - In his posts he describes all of the issues, I've faced taking digital notes over the years.
   - Repo: https://github.com/scottashipp/noted
   - Scott is an open-source software and Java guru, I work in .Net, Azure, and Microsoft tech, because of a comfort level with PowerShell and it's cross platform capabilities his work inspired this implementation of similar but separate features in PowerShell Core.

### Goal
#### The overall goal of Codex is to provide a simple way to take and make use of your notes
##### Powershell functions implemented as command line interface features make this possible.
  - codex help
  - codex log
  - codex edit 
  - codex search
  - codex list
  - codex test
 
 ### Setup and Configuration
   - TBD

 ### Use Cases
  - Realtime Log Entry:
    - Similar to a lab notebook or engineering log.
    - Screen shot links, useful for recording debugging session etc.
  - Edit Log:
    - Edit the last modified Markdown Log File in your text editor.
    - I use VSCode for this work.
  - Search Logs:
    - Pattern search across your logs
    - Find content you've created and make use of it.
  - List Logs:
    - List all logs by file name, sorted by last modified date descending.
