# Last-Log Plugin for Chatterino

## Table of Contents

- [Last-Log Plugin for Chatterino](#last-log-plugin-for-chatterino)
  - [Table of Contents](#table-of-contents)
    - [About ](#about-)
    - [Prerequisites](#prerequisites)
  - [Installing](#installing)
  - [Troubleshooting](#troubleshooting)
  - [Usage ](#usage-)

### About <a name = "about"></a>

A plugin for Chatterino that fetches and displays the last message of a specified user in a given channel.

### Prerequisites<a name = "prerequisites"></a>

Chatterino v2.5.2 or later (a version that has plugin support). You can find the section for Plugins on the left side of the settings menu.

## Installing<a name = "installing"></a>

- Ensure your version of Chatterino has plugin support (as of v2.5.2) *(Note that plugins are currently in alpha and are subject to change)*
- Either clone this repo or download the plugin files directly
- If direct download, create a folder named `last-log` (can be whatever) in `<username>/AppData/Roaming/Chatterino2/Plugins`
- Place [init.lua](https://github.com/jccdev45/last-log/blob/master/init.lua), [info.json](https://github.com/jccdev45/last-log/blob/master/info.json) inside the new folder
- Click `Enable` on the plugin in Chatterino Settings -> Plugins

## Troubleshooting<a name = "troubleshooting"></a>

- If you don't see the plugin listed, verify that the location of the folder (with `init.lua` and `info.json`) is inside `/Plugins` and restart Chatterino. Any additional nested folders *will not* be recognized
- If the plugin is not fetching messages, ensure you have a stable internet connection and that the Twitch channel exists

## Usage <a name = "usage"></a>

- `/lastlog <username> <channel>`: Fetches and displays the last message of the specified user in the given channel
- `/lastloghelp`: Displays help information for the Last-Log plugin

Example usage:

```txt
/lastlog jcc_bot jccdev45
```

This will fetch and display the last message from user 'jcc_bot' in the 'jccdev45' channel.

Note: There is a 10-second cooldown between uses of the `/lastlog` command to prevent excessive API requests.
