# RebuildOS Playbook

## Features
- More tweaks for Windows 10 (Windows 11 is not supported yet)
- You can select which tweaks you want to apply (not all of them)

## How to use
- Download AME Wizard from [here](https://download.ameliorated.io/AME%20Wizard%20Beta.zip)
- Download this playbook from [releases](https://github.com/TheRebuild/Playbook/releases)
- Run AME Wizard and drag and drop this playbook
- Select which tweaks you want to apply
- Enjoy!

## Changelog
- 0.2.0 - Secondary release
  - added features:
    - Now playbook can delete these packages:
    
      (You can remove these packages if you want to, and they won't be installed from Windows Update):
      - Skype
      - Teams
      - Media Player
      - OneDrive
      - Xbox Legacy Companion
      - Cortana
      - Alarms & Clock
      - Paint 3D
      - Films & TV
      - Spotify
      - Disney+
      - Tips
      - Microsoft Family
      - Mixed Reality Portal
      - DevHome
      - Bing Weather
      - Bing News
      - Outlook (new)
      - Get Help
      - 3D Viewer
      - Office Hub (Get Office)
      - Solitaire Collection
      - Sticky Notes
      - People
      - OneNote
      - Power Automate Desktop
      - Snipping Tool
      - Windows Wallet
      - Windows Camera
      - To-Dos
      - Feedback Hub
      - Maps
      - Sound Recorder
      - Music Player
      - Your Phone
    
    - Added finalizing steps of the playbook
    - Option to restore old search icon
    - Disabling automatic store updates
    - Disabling automatic updates in Windows Update and pause it until 2077
    - DirectPlay and LegacyComponents components are now enabled by default
    - Remote Differential Compression is disabled by default
    - Optionally, you can uninstall Microsoft Edge and Onedrive in the Features page
    - and more


- 0.1.0 - Initial alpha release
    - added features:
      - Disable GameBar (optional)
      - Disable Acrylic Blur on login screen (optional)
      - Hide most used apps from start menu (optional)
      - Hide recently added apps from start menu (optional)
      - Remove Previous Versions tab from explorer (optional)
      - Remove 3D Objects from navigation pane (optional)
      - Disable cloud notifications in Explorer
      - Show more information when copying files
      - Disable 'Reserved Storage' feature (optional)
      - Disable Content Delivery Manager
      - Disable AutoRun (optional)
      - Remove telemetry or unused services
      - Remove 'Windows Error Reporting' (optional)
      - Enable Dark Mode by default
      - Add Batch Scripts to 'New' Context Menu (optional)
      - Disable Background Apps (optional)
      - Disable Memory Paging Settings
      - Hide People Bar from Taskbar
      - Prevent the usage of OneDrive for file storage
      - OOBE Tweaks (DisablePrivacyExperience, ScoobeSystemSettingEnabled)
      - Remove Program Compatibility Assistant (soon will be optional)
      - Disable unused scheduled tasks
      - Set boot menu policy to Legacy
      - Disable svchost Splitting (Microsoft's recommendation for lower RAM usage)