## Roleplaying Menu ##

Welcome to the  Roleplaying Menu! This app is your one-stop-shop for managing and using your favorite RP lines, /FloatingDo's, and much more on Eclipse RP for GTA 5. This guide provides a quick start guide, and an in-depth overview of the application's features, and user interface navigation tips. This runs off one AutoHotkey script.

## Overview

The AutoHotKey Roleplaying Menu allows you to:

- Manage your Roleplay collection.
- Add RP Lines and Categories.
- Edit RP Line details.
- Quickly delete RP Lines or entire categories from your library.
- Use single or consecutive random Category RP Line playback.
- Adjust the app's size and transparency.

*(Using Notepad for Examples. Default will target GTA5.exe application)*


![Example1](https://github.com/Bassna/Roleplaying-Menu/assets/33616653/f2d74de1-1dc7-4f77-b030-cd6b335bbeca)



## Quick Start Guide

Before we dive into the features, here's how to get started. Download and run `RoleplayingMenu.AHK`. Then, press the `F5` hotkey to open the main Roleplaying Menu. A RPLines.txt file will be created to store your Roleplay lines in the same folder.

If you prefer not to use AutoHotKey, an alternative is to use `RoleplayingMenu.exe`. This executable runs the Roleplaying Menu on Windows and is identical to the AHK version and located in the OPTIONAL folder.

## User Interface

The Roleplaying Menu interface uses hotkeys for quick navigation:

- **F5**: *Open the Main Roleplay menu. Toggle the menu open or closed. Also stops any on-going typing*
- **SHIFT + F5**: *Toggle between Full Size and Compact size menus.*
- **CTRL + F5**: *Play a random category RP line, or multiple consecutively.*
- **F11**: *Pauses the current RP Line typing. Press again to resume the RP Line typing.*
- **F12**: *Stop and completely close the Roleplay Menu script.*

## Roleplay Menu Features

### Full Size and Compact Roleplaying Windows

The Full Size and Compact Roleplay Window provide various functionalities:

- **Search**: *Filter your `RPList.txt` file for RP Line or Categories.*
- **Add/Edit/Delete RP Lines**: *Modify your RP library.*
- **Random RP Lines**: *Play a random RP Line from any category. Set up one after another to do multiple lines!*
- **Display Settings**: *Adjust the transparency, and size of the app.*


## Adding RP Lines to Your Library

You can add RP Lines to your library by pressing the **Add RP** button. Select a saved category, or type in a new one!

![ExampleAdd](https://github.com/Bassna/Roleplaying-Menu/assets/33616653/f398b46a-37b7-40ad-9435-00992be9823f)



## Random RP Lines! ##

Choose a single category to get a random line pre-saved RP for that category.

![randomrandom](https://github.com/Bassna/Roleplaying-Menu/assets/33616653/63ed922f-4e91-4061-8962-f905d7d83802)


**Multiple categories can be selected to run in sequence, one after another in order.**

![ExampleRandom](https://github.com/Bassna/Roleplaying-Menu/assets/33616653/84040059-201d-4e01-bd5b-d18006f030ee)




## Quick Stop Safety Feature ##

While the typing is active, hitting the Escape, Enter, any of the F1-F12, Alt, Tab, and similar keys will instantly stop and clear any ongoing RP lines. However, the F11 key is unique — it will allow you to pause and then resume the typing process as needed.


🎵 Enjoy your Roleplay with the Eclipse Roleplaying Menu! 🎵


## Special Pre-Set variables ##

- {TodaysDate} - Automatically inputs todays current date.
- {UTCDateTime} - Automatically inputs the current Date and Time UTC.
- {NumberOfWeeksFromToday} - Enter a number to calculate the date X weeks from today automatically.
- {RandomNumber} - Inputs a random number 1-100.

![SPECIAL](https://github.com/Bassna/Roleplaying-Menu/assets/33616653/5f4f24a8-9fa6-4fda-9206-a71a1e4ff634)



## Troubleshooting ##
It's not opening GTA5.exe to target the game! -  Try to 'Run as Administrator'.  Right click > Run as admin. 


## Optional Folder 

In the `OPTIONAL` folder, you'll find:

- **RoleplayingMenu.exe**: A windows executable for people who do not want to use Autohotkey for any reason.
