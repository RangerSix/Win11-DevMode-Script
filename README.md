# Win11-DevMode-Script
---
# Work in progress. Use at own risk.
---
What the script does: At this point:

1. Administrator Check:
   The script starts by ensuring it runs with elevated privileges so that registry changes and installations can be performed without permission issues.

2. Enabling Developer Mode:
   The necessary registry keys under HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock are created (if missing) and set to enable Developer Mode. This unlocks       
   various developer-centric functionalities in Windows.

3. Installing Visual Studio Code:
   Visual Studio Code is installed using Winget. This part of the script checks if Winget is available and then installs VS Code with the required acceptance flags.

4. Downloading and Installing Git for Windows:
   Instead of using Winget for Git, the script downloads the installer directly from the Git for Windows website (via GitHub releases). It saves the installer to the temporary folder and then runs it silently using NSIS flags (/VERYSILENT and 
   /NORESTART). After installation, it cleans up the temporary file.
