# shell scripts and system management with mac OS
## using launchd
> You can use launchd to create a sub-directory each day in the ~/launchd-screenshots directory with the name assigned dynamically based on the current day. Here's an example of how you can achieve this:
1. Create a new plist file that defines the launchd job. Open Terminal and enter the following command to create the plist file:
  + `touch  ~/Library/LaunchAgents/com.example.dailydirectory.plist`
  + open the file in vscode: code ~/Library/LaunchAgents/com.example.dailydirectory.plist
2. Load the launchd job: `launchctl load ~/Library/LaunchAgents/com.example.dailydirectory.plist`
