#NoEnv                            ; Disables the automatic inclusion of parent environment variables in the script.
SetWorkingDir %A_ScriptDir%       ; Sets the working directory of the script to the directory containing the script itself.
#SingleInstance Force             ; Ensures that only a single instance of the script is allowed to run at any given time.
#Persistent                       ; Keeps the script running even after the auto-execute section has finished.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global Application := "GTA5.exe" ; Change this to the game or application you want to use. GTA5.exe for Eclipse, notepad.exe is good for testing (Open Notepad).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global vRPLines := "RPLines.txt" ; Change this to the new RP Line text file name, if you choose a different name.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Interface Elements
global activeGuiName, RandomRPButton, AddRPButton, EditRPButton, DeleteRPButton, StopRPLine

; Position & Size - Compact Gui
global compactGuiX := 0, compactGuiY := 0, compactGuiW := 0, compactGuiH := 0

; Position & Size - Full Size Gui
global fullSizeGuiX := 0, fullSizeGuiY := 0, fullSizeGuiW := 0, fullSizeGuiH := 0

; List View Dimensions
global listViewX := 10, listViewY := 60, listViewW := 316, listViewH := 86
global listViewMainW := 672, listViewMainH := 335

; Resizing Elements
global resizeBoxX := 0, resizeBoxY := 150, ResizeBox, FullSizeGuiResizeBoxX := 0, resizeBoxMainY := 421
global HandleDragOrResizeText, IsResizing := 0

; Miscellaneous Interface Settings
global GUITransparency := 255, TransparencySlider
global dropdownCount := 1, dropdownrandomY := 10
global stopTyping := false, stopSending := 0, isTypingActive := 0
global previousLine := {}

; User Settings
global tickboxState := 0, tickboxStateCompact := 0, closeOnSelectState := 0
global variableValues := {}, currentDropdownSelections := []
global vEdit1, vEdit2, vEdit3, vEdit4, vEdit5, vEdit6, vEdit7, vEdit8, vEdit9, vEdit10, vEdit11, vEdit12, vEdit13, vEdit14, vEdit15, vEdit16, vEdit17, vEdit18, vEdit19, vEdit20, vEdit21, vEdit22, vEdit23, vEdit24, vEdit25, vEdit26, vEdit27, vEdit28, vEdit29, vEdit30, vEdit31, vEdit32, vEdit33, vEdit34, vEdit35, vEdit36, vEdit37, vEdit38, vEdit39, vEdit40, vEdit41, vEdit42, vEdit43, vEdit44, vEdit45, vEdit46, vEdit47, vEdit48, vEdit49, vEdit50


; Reads the RP lines from a text file and updates the ListView with RP Sections and RPs
ReadTXTAndUpdateListView:
    ; Combine the script directory with the RP lines file name
    TxtFile := A_ScriptDir "\" vRPLines

    ; If the RP lines text file does not exist, create it and write the default data
    IfNotExist, %TxtFile%
    {
        FileAppend, 
        (LTrim Join`n
        [Work Tasks]
        /me begins typing on the computer, working quickly to get the task finished.
        /me grabs a broom and begins sweeping up the dust from around the area.
        /melow begins scrubbing on the windows with cleaner, trying to get them clean.

        [BLS Kit]
        /me places the BLS kit on the floor, unzips it, and retrieves {Medical Item}.
        /me grabs {Medical Item} from the BLS kit, setting the kit on the {Surface Type}.
        /me quickly unzips the BLS kit, searches around inside and grabs out {Medical Item}.
        
        [Floating Dos]
        /fdo FLYER: ~y~Club Arcadius is the ~r~BEST ~w~nightclub in Los Santos!
        /fdo Sign: ~y~Arcadius Loans - ~b~ Cash when you need it most.
        /fdo {Flyer, Sign or Poster}: ~f~For a good time, call {Phone Number}.
        /fdo {Poster or Flyer} Big Party at {Party Location} on {Event Date}!
        /removefdo {FDO Number} tears down the {Flyer, Note, Etc} and crumples it up.

        [Special Variables]
        /me sets a mental reminder that the due date is {NumberOfWeeksFromToday}.
        /me thinks about how it is currently {UTCDateTime}.
        /me thinks deeply about how it is already {TodaysDate}.
        /me wishes he had {RandomNumber} pieces of candy.
        ), %TxtFile%
    }

    ; Clear the existing ListView to prepare for updates
    LV_Delete()

    ; Initialize RPSection variable to hold the current RP Section name
    RPSection := ""

    ; Loop through the lines in the TXT file to read RP Sections and RPs
    Loop, Read, %TxtFile%
    {
        ; Get the current line from the TXT file
        currentLine := A_LoopReadLine

        ; Check if the line is a section name (RP Section) and extract it if so
        if (SubStr(currentLine, 1, 1) = "[")
        {
            RPSection := SubStr(currentLine, 2, StrLen(currentLine) - 2)
            continue
        }

        ; Skip the line if it is empty or starts with a semicolon (comment)
        if (StrLen(currentLine) = 0 || SubStr(currentLine, 1, 1) = ";")
            continue

        ; Assign the current line as the Roleplay text
        RP := currentLine

        ; Add the Roleplay Section and Roleplay text to the ListView
        LV_Add("", RPSection, RP)
    }

    ; Call the SanitizeFile subroutine to clean up the file
    Gosub, SanitizeFile

return


; ---------------- USER-FRIENDLY HOTKEYS SECTION ----------------


; Replace the keys within the colons with the desired hotkey.
; E.g., to change the ToggleSizeFunction from Shift+F5 to F4, replace "+F5" with "F4".

F5::ToggleRPGui()                  ; Main hotkey to open the RP Menu.

+F5::ToggleSizeFunction()          ; Toggle between Full size and Compact size menus

^F5::PlayRandomRPFunction()      ; Play a random RP Line

f11::Pause       ; Pause entire script and current typing. Press again to resume typing. 

F12::KillswitchFunction()  ; Activate the killswitch, stopping all actions and terminating the script

; ---------------------------------------------------------------
; ---------------------------------------------------------------

; If the typing is currently active, and No GUI is open from this script, these buttons can be pressed to stop the active typing and any consecutive lines after them. 
#If (isTypingActive = 1 && !IsScriptGuiActive())

; Stops typing if the user hits any F hotkey except the pause F11 hotkey or F5 key. IF YOU CHANGE THEM ABOVE, ADD F5 AND F11, or else they will not stop active typing if pressed. 
F1::
F2::
F3::
F4::
F6::
F7::
F8::
F9::
F10::
    stopSending := 1
    StopTypingFunction()
return

Enter::
    stopSending := 1
    StopTypingFunction()
return

Alt::
    stopSending := 1
    StopTypingFunction()
return

Tab::
    stopSending := 1
    StopTypingFunction()
return

LWin::
    stopSending := 1
    StopTypingFunction()
    return

#If


; Toggles the main RP GUI, or compact GUI
ToggleRPGui() {
    ; Close "Select Categories" sub-menu if open
    IfWinExist, Select Random Categories
    {
        ResetRandomGui()
        Gui, RandomRP:Destroy
    }

    ; Close "Edit a RP line" sub-menu if open
    IfWinExist, Edit a RP line
    {
        Gui, EditRPLine:Destroy
    }

    ; Close "Add a RP line" sub-menu if open
    IfWinExist, Add a RP line
    {
        Gui, AddRPLine:Destroy
    }

    ; Close "Delete Selection" GUI and associated confirmation GUIs
    IfWinExist, Delete Selection
    {
        Gui, DeleteConfirm:Destroy
    }
    IfWinExist, No Selection
    {
        Gui, NoSelection:Destroy
    }
    IfWinExist, Confirm Delete
    {
        Gui, DeleteConfirm2:Destroy
    }

    ; Close "Enter Variables" GUI if open
    IfWinExist, Enter Variables
    {
        Gui, VariablesGUI:Destroy
    }

    ; If active GUI is from the script, handle closure accordingly
    if (IsScriptGuiActive())
    {
        activeTitle := GetActiveGuiTitle()
        if (activeTitle != "Select Categories" and activeTitle != "Edit a RP line" and activeTitle != "Add a RP line" and activeTitle != "Delete Selection" and activeTitle != "Confirm Delete" and activeTitle != "Enter Variables")
        {
            ; Close active window by handle if not any of the specified ones
            WinGet, activeGuiHwnd, ID, A
            SendMessage, 0x112, 0xF060,,, % "ahk_id " activeGuiHwnd
        }
    }
    else
    {
        ; Terminate any ongoing typing and close the active GUI if existing
        stopSending := 1
        StopTypingFunction()
        IfWinExist, %activeGuiName%
        {
            if (activeGuiName != "") ; Safeguard check before destruction
            {
                Gui, %activeGuiName%:Destroy
                guiOpen := 0
                return
            }
        }

        ; Open the appropriate GUI (Compact or FullSize) based on active GUI type
        if (activeGuiName = "CompactGui")
        {
            CompactGui() ; Recreate the compact GUI
            guiOpen := 1
        }
        else
        {
            Gosub FullSizeGui
            guiOpen := 1
        }
    }
    Gosub, VariableCancel
}


; Toggles between Full size and Compact size menus.
ToggleSizeFunction() {
    global isTypingActive ; Global flag to indicate typing activity
    stopSending := 1
    StopTypingFunction()


    ; Close "Select Categories" sub-menu if open
    IfWinExist, Select Random Categories
    {
        ResetRandomGui()
        Gui, RandomRP:Destroy
    }

    ; Close "Edit a RP line" sub-menu if open
    IfWinExist, Edit a RP line
    {
        Gui, EditRPLine:Destroy
    }

    ; Close "Add a RP line" sub-menu if open
    IfWinExist, Add a RP line
    {
        Gui, AddRPLine:Destroy
    }

    ; Close "Delete Selection" GUI and associated confirmation GUIs
    IfWinExist, Delete Selection
    {
        Gui, DeleteConfirm:Destroy
    }
    IfWinExist, No Selection
    {
        Gui, NoSelection:Destroy
    }
    IfWinExist, Confirm Delete
    {
        Gui, DeleteConfirm2:Destroy
    }

    ; Close "Enter Variables" GUI if open
    IfWinExist, Enter Variables
    {
        Gui, VariablesGUI:Destroy
    }

    ; If active GUI is from the script, handle closure accordingly
    if (IsScriptGuiActive())
    {
        activeTitle := GetActiveGuiTitle()
        if (activeTitle != "Select Categories" and activeTitle != "Edit a RP line" and activeTitle != "Add a RP line" and activeTitle != "Delete Selection" and activeTitle != "Confirm Delete" and activeTitle != "Enter Variables")
        {
            ; Close active window by handle if not any of the specified ones
            WinGet, activeGuiHwnd, ID, A
            SendMessage, 0x112, 0xF060,,, % "ahk_id " activeGuiHwnd
        }
    }
    ; Toggle Compact mode if active GUI exists
    if (activeGuiName != "") {
        tickboxStateCompact := !tickboxStateCompact
        Gosub, ToggleCompactMode
    }
    Gosub, VariableCancel
return
}


; Plays a random RP Line 
PlayRandomRPFunction() {
    global isTypingActive ; Global flag to indicate typing activity

    ; Store the current value of activeGuiName
    storedGuiName := activeGuiName

    stopSending := 1
    StopTypingFunction()
    
    ; Check if a GUI with the title "Select Random Categories" is open
    if WinExist("Select Random Categories") {
        ; If it is open, close it
        WinClose, Select Random Categories
    } 
    else if (activeGuiName = "RandomRP") {
        ; If the RandomRP GUI is already active, close it
        Gui, RandomRP:Destroy
    } else {
        ; If the RandomRP GUI is not active, execute the RandomRP subroutine
        Gosub RandomRP
    }

    ; Restore the original value of activeGuiName
    activeGuiName := storedGuiName

    Gosub, VariableCancel
Return
}


; Activates the killswitch, stopping all current actions and terminating the script.
KillswitchFunction() {
    Gosub, Killswitch ; Execute Killswitch subroutine
Return
}


; Determines if the active GUI window is part of the current script process and thread
IsScriptGuiActive() {
    hWnd := WinActive("A") ; Get the handle of the active window
    WinGet, pid, PID, % "ahk_id " hWnd ; Get the process ID of the active window
    ; Return true if thread ID of the active window matches current thread, and process ID matches current process
    return DllCall("GetWindowThreadProcessId", "Ptr", hWnd, "UInt*", 0) = DllCall("GetCurrentThreadId") && pid = DllCall("GetCurrentProcessId")
}


; Gets the title of the active GUI window
GetActiveGuiTitle() {
    hWnd := WinActive("A") ; Get the handle of the active window
    WinGetTitle, windowTitle, % "ahk_id " hWnd ; Get the title of the active window
    return windowTitle
}


; Trigger Esc hotkey only if script's GUI is active or typing function is running
#If (IsScriptGuiActive() || isTypingActive)
Esc::
    stopSending := 1
    StopTypingFunction() ; Stop typing function

    if (IsScriptGuiActive()) {
        activeTitle := GetActiveGuiTitle() ; Get title of active GUI
        if (activeTitle = "Enter Variables") {
            Gosub, VariableCancel ; Jump to the Cancel label when the "Enter Variables" GUI is active
        }
        else if (activeTitle = "Select Categories" or activeTitle = "Add a RP line" or activeTitle = "Edit a RP line") {
            ; Destroy corresponding GUIs for specified titles
            Gui, RandomRP:Destroy
            Gui, AddRPLine:Destroy
            Gui, EditRPLine:Destroy
        } else {
            ; Close active window using handle
            WinGet, activeGuiHwnd, ID, A
            SendMessage, 0x112, 0xF060,,, % "ahk_id " activeGuiHwnd ; WM_SYSCOMMAND := 0x112, SC_CLOSE := 0xF060
        }
    }
return


; The StoreFullSizeGuiValues subroutine stores the current size and position of the main GUI.
StoreFullSizeGuiValues:
    Gui, FullSizeGui:Submit, NoHide ; Save the current state of the main GUI
    WinGetPos, newX, newY, newW, newH, RP Menu ; Get the current position and size of the main GUI
    fullSizeGuiX := newX ; Store the current x position
    fullSizeGuiY := newY ; Store the current y position
    fullSizeGuiW := newW ; Store the current width
    fullSizeGuiH := newH ; Store the current height
return


; The StoreCompactGuiValues subroutine stores the current size and position of the compact GUI.
StoreCompactGuiValues:
    Gui, CompactGui:Submit, NoHide ; Save the current state of the compact GUI
    WinGetPos, newX, newY, newW, newH, Compact RP Menu ; Get the current position and size of the compact GUI
    compactGuiX := newX ; Store the current x position
    compactGuiY := newY ; Store the current y position
    compactGuiW := newW ; Store the current width
    compactGuiH := newH ; Store the current height
return


; The SetActiveGuiName function sets the name of the currently active GUI for reference.
SetActiveGuiName(guiName) {
    global activeGuiName ; Declare 'activeGuiName' as a global variable to access it throughout the script
    activeGuiName := guiName ; Assign the name of the currently active GUI to the variable
}


; Main GUI for the Full Size RP Menu
FullSizeGui:
    ; Setup of the FullSize GUI: AlwaysOnTop attribute is determined by the state of closeOnSelectState
    ; If closeOnSelectState is not equal to zero, the GUI will stay on top of all other windows
    if (closeOnSelectState != 0) {
        Gui, FullSizeGui:New, +OwnDialogs -Caption +AlwaysOnTop
    } else {
        Gui, FullSizeGui:New, +OwnDialogs -Caption
    }
    
    ; Create a new GUI with options for custom dialog handling
    Gui, FullSizeGui:Font, s9, Segoe UI Semibold
    Gui, FullSizeGui:Color, C0C0C0

    ; Set the WM_EXITSIZEMOVE Windows messages to trigger specific subroutines
    OnMessage(0x0232, "WM_EXITSIZEMOVE")      ; End of drag/resize event
    OnMessage(0x84, "WM_NCHITTEST") ; Makes the GUI draggable
    OnMessage(0x200, "WM_MOUSEMOVE") ; Handle mouse move events
    OnMessage(0x20, "WM_SETCURSOR") ; Makes the cursor change to resize when hovering over the resize bar

    ; Add a custom title bar and close button
    Gui, Add, Text, x0 y3 w692 h30 vTitleBar cGray +Center, Roleplay Menu
    Gui, Add, Button, x652 y5 w35 h15 gGuiClose , X 
    
    ; Add buttons for song management: Add, Delete, Random, Edit, and Stop
    Gui, Add, Button, x10 y20 w60 h20 gAddRPLine, Add RP
    Gui, Add, Button, x75 y20 w80 h20 gDeleteRPLine, Delete RP
    Gui, Add, Button, x75 y50 w82 h20 gRandomRP, Random RP
    Gui, Add, Button, x10 y50 w60 h20 gEditRPLine, Edit RP
    Gui, Add, Button, Default Hidden, ButtonOK

    
    Gui, FullSizeGui:Font, s9, Segoe UI Semibold
    Gui, Add, Slider, x588 y22 w100 h20 Thick19 vTransparencySlider Range50-255 gAdjustTransparency Invert
    GuiControl, , TransparencySlider, %GUITransparency%

    ; Add checkboxes to toggle Compact Mode and to control whether the GUI should stay open
    Gui, Add, CheckBox, x580 y56 vCheckboxVar2 gToggleCompactMode Checked%tickboxStateCompact%, Compact Mode
    Gui, Add, CheckBox, x494 y56 vCloseOnSelectVar gToggleCloseOnSelect Checked%closeOnSelectState%, Keep Open

    ; Add labels for sliders, controls and a text prompt for song search
    Gui, Add, Text, x522 y26, Transparent:
    Gui, Add, Text, x166 y22, Search RP lines or Category:

    ; Add hidden OK button, ListView to display songs, and a text box for song search
    Gui, Add, Button, Hidden Default , OK

    ; ListView: This is a list of songs displayed in the GUI. It includes several columns for details such as Artist, Album, Song, Link, Favorite and Fav. 
    Gui, Add, ListView, x10 y80 w%listViewMainW% h%listViewMainH%  vRPLines gSelectRPFromListView BackgroundE0FFFC, Category|RP Line
    LV_ModifyCol(1, 110) ; Sets the width of the 'Category' column
    LV_ModifyCol(2, 540) ; Sets the width of the 'RP Line' column


    ; Query: This text box allows the user to search for songs, artists, or albums. 
    Gui, Add, Edit, x320 y20 w172 h20 vQuery gSearchAll +WantReturn

    ; Custom progress bar to grab and drag at the bottom of the GUI to resize
    Gui, Add, Progress, x%resizeBoxX% y%resizeBoxMainY% w692 h4 Background000000 Disabled vResizeBox,
    Gui, Add, Text, xp yp wp hp BackgroundTrans 0x201 vHandleDragOrResizeText gHandleDragOrResizeFullSizeGui,

    ; Conditionally show or hide the speaker number input box and label based on tickboxState
    if (!tickboxState) {
        GuiControl, Hide, AdditionalInput
    }

    ; Set the ListView to be resizable
    GuiControl, +Resize, RPLines

    ; Add an outline around the GUI
    DRAW_OUTLINEFullSizeGui("FullSizeGui", 0, 0, 692, 425)

    ; Set the active GUI for other functions to use
    SetActiveGuiName("FullSizeGui")

    ; Update the always-on-top state of the GUI
    Gosub, UpdateAlwaysOnTopState

    ; Determine if GUI needs to be shown in a new location or at a previously set one
    if (fullSizeGuiX = 0 and fullSizeGuiY = 0) {
        SetGuiTransparency("FullSizeGui", GUITransparency)
        Gui, Show, w692 h425, RP Menu
        Gosub, StoreFullSizeGuiValues

    } else {
        ; Use stored width and height if available, default to 692 and 425 otherwise
        fullSizeGuiW := (fullSizeGuiW = 0) ? 692 : fullSizeGuiW
        fullSizeGuiH := (fullSizeGuiH = 0) ? 425 : fullSizeGuiH
        SetGuiTransparency("FullSizeGui", GUITransparency)
        Gui, Show, x%fullSizeGuiX% y%fullSizeGuiY% w%fullSizeGuiW% h%fullSizeGuiH%, RP Menu
    }

    ; Set the initial transparency for the main GUI
    SetGuiTransparency("FullSizeGui", GUITransparency)

    ; Perform an initial search to populate the ListView
    Gosub, SearchAll

    ; Sets the curser on the search bar by default
    GuiControl, Focus, Query
    Hotkey, IfWinActive, RP Menu
    Hotkey, Enter, ButtonOK, UseErrorLevel
return


; This function handles the recreation of the GUI, allowing changes to be reflected immediately in the interface.
RecreateGUI:
    ; The existing AddSong and Search GUIs are destroyed to make room for the new GUI.
    Gui, AddSongGui:Destroy
    Gui, FullSizeGui:Destroy

    ; Depending on the state of the 'tickboxStateCompact', the GUI is recreated in either Compact or Main (full) mode.
    if (tickboxStateCompact) {
        if (WinExist("Compact RP Menu")) {
            CompactGui()
        }
    } else {
        Gosub, FullSizeGui
    }
return


; This function responds to the WM_EXITSIZEMOVE message, which is sent by the operating system when the user stops moving or resizing a window.
WM_EXITSIZEMOVE(wParam, lParam, msg, hwnd) {
    ; If the window being moved or resized is the RP Menu...
    if (hwnd = WinExist("RP Menu")) { 
        ; Get the new position of the window and update the stored position.
        WinGetPos, newX, newY,,, A 
        fullSizeGuiX := newX 
        fullSizeGuiY := newY

        ; Update the transparency of the GUI to maintain its current level.
        SetGuiTransparency("FullSizeGui", GUITransparency)

        ; Get the new size of the window and update the stored size.
        WinGetPos, , , newW, newH, A
        fullSizeGuiW := newW
        fullSizeGuiH := newH

        ; Calculate the new dimensions for the ListView and ResizeBox button based on the new size of the window.
        listViewMainW := newW - 20
        listViewMainH := newH - 90
        resizeBoxMainY := newH - 4

        ; Update the size and position of the ListView and ResizeBox button based on the new dimensions.
        GuiControl, Move, RPLines, w%listViewMainW% h%listViewMainH%
        GuiControl, Move, ResizeBox, y%resizeBoxMainY%
        GuiControl, Move, HandleDragOrResizeText, y%resizeBoxMainY%

    ; If the window being moved or resized is the Compact RP Menu...
    } else if (hwnd = WinExist("Compact RP Menu")) { 
        ; Get the new position and size of the window and update the stored position and size.
        WinGetPos, newX, newY, newW, newH, A
        compactGuiX := newX
        compactGuiY := newY
        compactGuiW := newW
        compactGuiH := newH

        ; Calculate the new dimensions for the ListView and ResizeBox button based on the new size of the window.
        listViewW := newW - 19
        listViewH := newH - 68
        resizeBoxY := newH - 4

        ; Update the size and position of the ListView and ResizeBox button based on the new dimensions.
        GuiControl, Move, RPLines, w%listViewW% h%listViewH%
        GuiControl, Move, ResizeBox, y%resizeBoxY%
        GuiControl, Move, HandleDragOrResizeText, y%resizeBoxY%
    }
}


; This function alters the 'closeOnSelectState' variable. The closeOnSelectState dictates whether the GUI will close after a song has been selected.
ToggleCloseOnSelect:
    closeOnSelectState := !closeOnSelectState ; Flip the state of 'closeOnSelectState'
    Gosub, UpdateAlwaysOnTopState ; Update the 'Always On Top' state according to the new 'closeOnSelectState'
return


; This function switches the GUI between full size and compact modes.
ToggleCompactMode:
    GuiControlGet, tickboxStateCompact, , CheckboxVar2 ; Fetch the current state of the compact mode toggle

    ; If compact mode is currently enabled
    if (tickboxStateCompact) {
        ; Record the current position of the main GUI before closing it
        if IsScriptGuiActive() ; Check if the active GUI is part of this script
        {
            WinGetPos, FullSizeGuiX, FullSizeGuiY,,, A
            fullSizeGuiX := FullSizeGuiX
            fullSizeGuiY := FullSizeGuiY
        }

        Gui, FullSizeGui:Destroy ; Destroy the current main GUI

        CompactGui() ; Create the compact GUI
    } 
    else {
        ; If compact mode is currently disabled
        ; Record the current position of the compact GUI before closing it
        if IsScriptGuiActive() ; Check if the active GUI is part of this script
        {
            WinGetPos, CompactGuiX, CompactGuiY,,, A
            compactGuiX := CompactGuiX
            compactGuiY := CompactGuiY
        }

        ; Destroy the current compact GUI
        Gui, CompactGui:Destroy 

        ; Open the main GUI
        Gosub, FullSizeGui 

        ; Reset the 'tickboxStateCompact' variable when transitioning from CompactGUI to FullSizeGui
        tickboxStateCompact := 0
    }
return


; Main GUI for the Compact RP Menu
CompactGui() {
    ; Setup of the Compact GUI: AlwaysOnTop attribute is determined by the state of closeOnSelectState
    ; If closeOnSelectState is not equal to zero, the GUI will stay on top of all other windows
    if (closeOnSelectState != 0) {
        Gui, CompactGui:New, +OwnDialogs -Caption +AlwaysOnTop
    } else {
        Gui, CompactGui:New, +OwnDialogs -Caption
    }

    ; Set the font and color of the CompactGui
    Gui, CompactGui:Font, s9, Segoe UI Semibold
    Gui, CompactGui:Color, C0C0C0

    ; Intercept Windows messages to control GUI behavior
    OnMessage(0x84, "WM_NCHITTEST") ; Allows the GUI to be draggable by the user
    OnMessage(0x0232, "WM_EXITSIZEMOVE") ; Updates compactGuiX and compactGuiY values as the GUI is moved
    OnMessage(0x20, "WM_SETCURSOR") ; Changes the cursor when it hovers over the GUI
    OnMessage(0x200, "WM_MOUSEMOVE") ; Handles mouse movement events within the GUI

    ; Add a query input field to search for songs
    Gui, Add, Edit, x8 y8 w100 h20 vQuery gSearchAllCompact +WantReturn

    ; Add a ListView control to display songs
    ; Information includes Artist, Album, Song, Link, Favorite status
    Gui, Add, ListView, x%listViewX% y%listViewY% w%listViewW% h%listViewH%  vRPLines gSelectRPFromListView BackgroundE0FFFC, Category|RP Line
    LV_ModifyCol(1, 110) ; Sets the width of the 'Category' column
    LV_ModifyCol(2, 185) ; Sets the width of the 'RP Line' column

    ; Add Compact Mode and "Always On Top" toggles
    Gui, Add, CheckBox, x260 y42 vCheckboxVar2 gToggleCompactMode Checked%tickboxStateCompact%, Compact
 
    ; Add an additional input box (with its font and label)
    Gui, CompactGui:Font, s8, Microsoft Sans Serif
    ;Gui, Add, Edit, x142 y8 w30 h20 vAdditionalInput +WantReturn, %SpeakerNumberSet%
    Gui, CompactGui:Font, s8, Segoe UI Semibold

    ; Add a checkbox for keeping the GUI open after a song is selected
    Gui, Add, CheckBox, x178 y42 vCloseOnSelectVar gToggleCloseOnSelect Checked%closeOnSelectState%, Keep Open

    ; Conditionally show or hide the input box and label based on tickboxState
    if (!tickboxState) {
        GuiControl, Hide, SpeakerLabel
        GuiControl, Hide, AdditionalInput
    }

    Gui, Add, Slider, x246 y3 w80 h18 vTransparencySlider Range50-255 gAdjustTransparency Thick18 +gShowCustomTooltip Invert
    GuiControl, , TransparencySlider, %GUITransparency%
    Gui, Add, Text, x180 y6, Transparent :

    ; Add controls for song manipulation and GUI resize
    Gui, Add, Progress, x%resizeBoxX% y%resizeBoxY% w360 h4 Background000000 Disabled vResizeBox,
    Gui, Add, Text, xp yp wp hp BackgroundTrans 0x201 vHandleDragOrResizeText gHandleDragOrResize,

    ; Add the GUI border
    DRAW_OUTLINE("CompactGui", 0, 0, 335, 153)

    ; Add button controls for various song actions such as random play, add song, edit song, delete song, and add to favorites
    Gui, CompactGui:Font, Bold s11, Microsoft Sans Serif 
    Gui, Add, GroupBox, x30 y38 w18 h18 Border c000000, ; This is the border around the progress bar
    Gui, Add, Button, x31 y39 w16 h16 vRandomRPButton gRandomRP, R
    Gui, Add, GroupBox, x10 y38 w18 h18 Border c000000, ; This is the border around the progress bar
    Gui, Add, Button, x11 y39 w16 h16 gAddRPLine vAddRPButton, A
    Gui, Add, GroupBox, x70 y38 w18 h18 Border c000000, ; This is the border around the progress bar
    Gui, Add, Button, x71 y39 w16 h16 gEditRPLine vEditRPButton, E
    Gui, Add, GroupBox, x90 y38 w18 h18 Border c000000, ; This is the border around the progress bar
    Gui, Add, Button, x91 y39 w16 h16 gDeleteRPLine vDeleteRPButton, D
    Gui, CompactGui:Font, s18, Times New Roman
    Gui, CompactGui:Font, s8, Segoe UI Semibold

    ; Set the initial transparency for the compact GUI
    SetGuiTransparency("CompactGui", GUITransparency)

    ; Set the active GUI to CompactGui and update the AlwaysOnTop state
    SetActiveGuiName("CompactGui")
    Gosub, UpdateAlwaysOnTopState

    ; Initialize the search in compact mode
    Gosub, SearchAllCompact

    ; Displaying the compact GUI
    ; Checks if the position values for the compact GUI (X and Y coordinates) are set to 0
    if (compactGuiX = 0 and compactGuiY = 0) {
        ; If the position values are not set, it shows the GUI at default position and size, and stores the GUI values
        Gui, Show, w335 h153, Compact RP Menu
        Gosub, StoreCompactGuiValues
    } else {
        ; If the position values are set, it checks if the width and height values for the GUI are set
        compactGuiW := (compactGuiW = 0) ? 335 : compactGuiW
        compactGuiH := (compactGuiH = 0) ? 153 : compactGuiH
        ; If the width and height values are not set, it uses the default width and height values (335 and 153 respectively)
        ; And displays the GUI at the specified position and size
        Gui, Show, x%compactGuiX% y%compactGuiY% w%compactGuiW% h%compactGuiH%, Compact RP Menu
    }

    ; Set the transparency for the compact GUI again after it has been shown
    SetGuiTransparency("CompactGui", GUITransparency)

    ; Sets the curser on the search bar by default
    GuiControl, Focus, Query
    Hotkey, IfWinActive, Compact RP Menu
    Hotkey, Enter, ButtonOK, UseErrorLevel
}


; This function creates an outline around a GUI.
DRAW_OUTLINE(GUI_NAME, X, Y, W, H, COLOR1:="BLACK", COLOR2:="BLACK", THICKNESS:=3) {
    ; Adding a horizontal progress bar at the top of the GUI for the outline.
    Gui, % GUI_NAME ": ADD", Progress, % "X" X " Y" Y " W" W " H" THICKNESS " BACKGROUND" COLOR1 

    ; Adding a vertical progress bar on the left side of the GUI for the outline.
    Gui, % GUI_NAME ": ADD", Progress, % "X" X " Y" Y " W" THICKNESS " H" H + 10000 " BACKGROUND" COLOR1 

    ; The bottom border of the GUI is currently disabled for dynamic adjustment.
    ; Gui , % GUI_NAME ": ADD" , Progress , % "X" X " Y" Y + H - THICKNESS " W" W " H" THICKNESS " BACKGROUND" COLOR2 

    ; Adding a vertical progress bar on the right side of the GUI for the outline.
    Gui, % GUI_NAME ": ADD", Progress, % "X" X + W - THICKNESS " Y" Y " W" THICKNESS " H" H + 10000 " BACKGROUND" COLOR2     
}


; This function creates an outline around a 'main' GUI.
DRAW_OUTLINEFullSizeGui(GUI_NAME, X, Y, W, H, COLOR1:="BLACK", COLOR2:="BLACK", THICKNESS:=3) {
    ; Adding a horizontal progress bar at the top of the main GUI for the outline.
    Gui, % GUI_NAME ": ADD", Progress, % "X" X " Y" Y " W" W " H" THICKNESS " BACKGROUND" COLOR1 

    ; Adding a vertical progress bar on the left side of the main GUI for the outline.
    Gui, % GUI_NAME ": ADD", Progress, % "X" X " Y" Y " W" THICKNESS " H" H + 10000 " BACKGROUND" COLOR1 

    ; The bottom border of the main GUI is currently disabled for dynamic adjustment.
    ; Gui , % GUI_NAME ": ADD" , Progress , % "X" X " Y" Y + H - THICKNESS " W" W " H" THICKNESS " BACKGROUND" COLOR2 

    ; Adding a vertical progress bar on the right side of the main GUI for the outline.
    Gui, % GUI_NAME ": ADD", Progress, % "X" X + W - THICKNESS " Y" Y " W" THICKNESS " H" H + 10000 " BACKGROUND" COLOR2     
}


; Function to handle mouse movement over GUI controls
; displaying tooltips for various buttons with associated information.
WM_MOUSEMOVE() {
    static CurrControl, PrevControl
    CurrControl := A_GuiControl

    ; Check if the mouse is hovering over a different control and it is not blank
    if (CurrControl <> PrevControl and not InStr(CurrControl, " ")) {
        ToolTip  ; Clear any existing tooltip
        SetTimer, DisplayToolTip, 500 ; Set a timer to display the tooltip
        PrevControl := CurrControl ; Update the previous control
    }
    return

    ; Subroutine to display the tooltip based on the hovered control
    DisplayToolTip:
    SetTimer, DisplayToolTip, Off ; Turn off the timer for tooltip display

    ; Display tooltip text based on the specific control
     if (CurrControl = "AddRPButton") {
        ToolTip, Add RP Line
    } else if (CurrControl = "RandomRPButton") {
        ToolTip, Random RP Line
    } else if (CurrControl = "EditRPButton") {
        ToolTip, Edit RP Line
    } else if (CurrControl = "DeleteRPButton") {
        ToolTip, Delete RP Line
    } else if (CurrControl = "VariableButton") {
        ToolTip, Highlight any text and press this button to turn it into a variable

    }

    ; Set a timer to remove the tooltip after 8 seconds
    SetTimer, RemoveToolTipCompact, 8000
    return

    ; Subroutine to remove the displayed tooltip
    RemoveToolTipCompact:
    SetTimer, RemoveToolTipCompact, Off ; Turn off the timer for tooltip removal
    ToolTip ; Remove the tooltip
    return
}


; Display tooltip when HelpButton is pressed
DisplayToolTipForHelpButton:
    ToolTip,
    (LTrim
        Use `{brackets`} for variables in your RP lines, or bracket button to add.

        Examples:

        /me takes a sip of their `{Drink`} while watching the `{Show or Event}`.
        /me grabs a `{BLS Item`} and sets it on the `{Surface Type`} carefully`.

        Input boxes will be created for every `{Variable`} in the sentence for you.


        Special Variables:

        {TodaysDate} - Automatically inputs todays current date.
        {UTCDateTime} - Automatically inputs the current Date and Time UTC.
        {NumberOfWeeksFromToday} - Input a number and get that date X weeks from today.
        {RandomNumber} - Inputs a random number 1-100.
        {DoNotEnter} - Will not automatically press the Enter key on the RP line. 
    )
    ; Set a timer to remove the tooltip after 8 seconds
    SetTimer, RemoveToolTip, 8000
return


; Display tooltip when HelpButtonRandomRP is pressed
DisplayToolTipForHelpButtonRandomRP:
    ToolTip,
    (LTrim
        Select a Category and submit for a random line from that section. 
        Categories can be stacked with the + button, to run consecutively in order.

        Examples:

        Category 1: /me picks up a `{Cleaning Item`} and begins cleaning the `{Area`}
        Category 2: /me cleans the `{Surface`}, scrubbing the area with `{Cleaning Item`}
        
    )
    ; Set a timer to remove the tooltip after 8 seconds
    SetTimer, RemoveToolTip, 8000
return


; Remove the displayed tooltip
RemoveToolTip:
    SetTimer, RemoveToolTip, Off ; Turn off the timer for tooltip removal
    ToolTip ; Remove the tooltip
return


; Function to handle window resizing and dragging in compact mode
WM_NCHITTEST(wParam, lParam, msg, hwnd) {
    if (IsResizing) {
        return HTBOTTOM
    }
    ; Set the cursor to the default (HTCAPTION = 2) to indicate the GUI should be draggable
    return 2
    if (A_Gui = "CompactGui") {
        ; Get the mouse cursor position in the client area of the window
        CoordMode, Mouse, Client
        MouseGetPos, mouseX, mouseY

        ; Define the boundaries of the resize button
        resizeButtonX1 := resizeBoxX
        resizeButtonY1 := resizeBoxY
        resizeButtonX2 := resizeBoxX + 360
        resizeButtonY2 := resizeBoxY + 10

    }
    return 0
}


; Process the WM_SETCURSOR message to change the cursor when hovering over the resize button in CompactGUI and FullSizeGui
WM_SETCURSOR(wParam, lParam, msg, hwnd) {
    if (A_Gui = "CompactGui" || A_Gui = "FullSizeGui") {
        ; Get the current position of the mouse cursor relative to the client area of the window
        CoordMode, Mouse, Client
        MouseGetPos, mouseX, mouseY

        ; Define the boundaries of the resize button for the CompactGUI
        if (A_Gui = "CompactGui") {
            resizeButtonX1 := resizeBoxX
            resizeButtonY1 := resizeBoxY
            resizeButtonX2 := resizeBoxX + 360
            resizeButtonY2 := resizeBoxY + 10
        }
        
        ; Define the boundaries of the resize button for the FullSizeGui
        else if (A_Gui = "FullSizeGui") {
            resizeButtonX1 := resizeBoxX
            resizeButtonY1 := resizeBoxMainY
            resizeButtonX2 := resizeBoxX + 692
            resizeButtonY2 := resizeBoxMainY + 4
        }
        
        ; Check if the cursor is currently over the resize button
        if (mouseX >= resizeButtonX1 && mouseX <= resizeButtonX2 && mouseY >= resizeButtonY1 && mouseY <= resizeButtonY2) {
            ; Load the vertical resize cursor and set the cursor to it
            cursorResize := DllCall("LoadCursor", "Ptr", 0, "Int", 32645, "Ptr") ; 32645 is the ID of the vertical resize cursor
            DllCall("SetCursor", "Ptr", cursorResize)
            return 1 ; Prevent the system from setting the cursor
        } else {
            ; Load the default cursor and set the cursor to it
            cursorNormal := DllCall("LoadCursor", "Ptr", 0, "Int", 32512, "Ptr") ; 32512 is the ID of the default cursor
            DllCall("SetCursor", "Ptr", cursorNormal)
            return 1 ; Prevent the system from setting the cursor
        }
    }
    return 0 ; Allow the system to set the cursor
}


; Function to start resizing the compact menu
StartResize() {
    ; Declare global variables
    global hwnd, IsResizing, compactGuiX, compactGuiY, compactGuiH, compactGuiW, listViewW, listViewH, resizeBoxY
    ; Get the current position of the mouse and the ID of the window under the cursor
    MouseGetPos, startX, startY, hwnd
    ; Get the current position and size of the window
    WinGetPos, guiX, guiY, guiW, guiH, ahk_id %hwnd%

    ; Define minimum and maximum height constraints
    minHeight := 155 ; Adjust the value as needed
    maxHeight := 6000 ; Adjust the value as needed

    ; Continue resizing as long as the left mouse button is held down
    while (GetKeyState("LButton", "P")) {
        Sleep 10
        ; Get the current position of the mouse
        MouseGetPos, endX, endY
        ; Calculate the new height of the window
        newHeight := guiH + (endY - startY)

        ; Ensure the new height is within the defined constraints
        newHeight := (newHeight < minHeight) ? minHeight : (newHeight > maxHeight) ? maxHeight : newHeight

        ; Resize the GUI
        Gui, CompactGui:Show, h%newHeight%

        ; Move the black box along with the resizing
        newY := newHeight - 4
        GuiControl, Move, ResizeBox, y%newY%

        ; Move the transparent text control along with the black box
        GuiControl, Move, HandleDragOrResizeText, y%newY%

        ; Resize the ListView
        newListViewHeight := newHeight - 68
        GuiControl, Move, RPLines, h%newListViewHeight%
    }

    ; Update global variables with the new size and position of the GUI and its controls
    compactGuiH := newHeight
    compactGuiW := guiW
    listViewH := newListViewHeight
    resizeBoxY := newY

    ; Indicate that resizing is over
    IsResizing := 0
}


; Function to handle dragging or resizing the compact menu
HandleDragOrResize() {
    global IsResizing, compactGuiX, compactGuiY
    ; Toggle the resizing state
    IsResizing := !IsResizing
    if (IsResizing) {
        ; If we just started resizing, call the StartResize function
        StartResize()
    }
}


; Function to start resizing the main GUI
StartResizeFullSizeGui() {
    ; Declare global variables
    global hwnd, IsResizing, fullSizeGuiX, fullSizeGuiY, fullSizeGuiH, fullSizeGuiW, listViewMainW, listViewMainH, resizeBoxMainY
    ; Get the current position of the mouse and the ID of the window under the cursor
    MouseGetPos, startX, startY, hwnd
    ; Get the current position and size of the window
    WinGetPos, guiX, guiY, guiW, guiH, ahk_id %hwnd%

    ; Define minimum and maximum height constraints
    minHeight := 180 ; Adjust the value as needed for minimum GUI
    maxHeight := 6000 ; Adjust the value as needed for maximum GUI

    ; Continue resizing as long as the left mouse button is held down
    while (GetKeyState("LButton", "P")) {
        Sleep 10
        ; Get the current position of the mouse
        MouseGetPos, endX, endY
        ; Calculate the new height of the window
        newHeight := guiH + (endY - startY)

        ; Ensure the new height is within the defined constraints
        newHeight := (newHeight < minHeight) ? minHeight : (newHeight > maxHeight) ? maxHeight : newHeight

        ; Resize the GUI
        Gui, FullSizeGui:Show, h%newHeight%

        ; Move the black box along with the resizing
        newY := newHeight - 4
        GuiControl, Move, ResizeBox, y%newY%

        ; Move the transparent text control along with the black box
        GuiControl, Move, HandleDragOrResizeText, y%newY%

        ; Resize the ListView
        newListViewHeight := newHeight - 90
        GuiControl, Move, RPLines, h%newListViewHeight%
    }

    ; Update global variables with the new size and position of the GUI and its controls
    fullSizeGuiH := newHeight
    fullSizeGuiW := guiW
    listViewMainH := newListViewHeight
    resizeBoxMainY := newY

    ; Indicate that resizing is over
    IsResizing := 0
}


; Function to handle dragging or resizing the main GUI
HandleDragOrResizeFullSizeGui() {
    global IsResizing, fullSizeGuiX, fullSizeGuiY
    ; Toggle the resizing state
    IsResizing := !IsResizing
    if (IsResizing) {
        ; If we just started resizing, call the StartResizeFullSizeGui function
        StartResizeFullSizeGui()
    }
}


; Label to adjust the transparency and update the global variable
AdjustTransparency:
    ; Get the current position of the TransparencySlider
    GuiControlGet, GUITransparency, , TransparencySlider
    
    ; Calculate the transparency percentage
    transparencyPercent := Round((255 - GUITransparency) / 2.05)
    
    ; Define the tooltip text
    tooltipText := transparencyPercent . "%"
    
    ; Show the tooltip near the cursor position
    ToolTip, %tooltipText%, A_CaretX + 20, A_CaretY
    
    ; Set a timer to remove the tooltip after 1 second
    SetTimer, RemoveToolTip, -1000
    
    ; Set the transparency of the two GUIs
    WinSet, Transparent, %GUITransparency%, Compact RP Menu
    WinSet, Transparent, %GUITransparency%, RP Menu
return


; Function to set the transparency of a GUI
SetGuiTransparency(GuiName, Transparency) {
    ; Get the window handle of the GUI
    Gui, %GuiName%: +LastFound
    hWnd := WinExist()

    ; Define the constants for the window style and layered attribute
    WS_EX_LAYERED := 0x80000
    LWA_ALPHA := 0x2

    ; Get the current window style
    WinGet, ExStyle, ExStyle, ahk_id %hWnd%

    ; Add the WS_EX_LAYERED style to the existing window styles
    ExStyle := ExStyle | WS_EX_LAYERED
    DllCall("SetWindowLong", "Ptr", hWnd, "Int", -20, "Int", ExStyle)

    ; Set the transparency of the window
    DllCall("SetLayeredWindowAttributes", "Ptr", hWnd, "UInt", 0, "UInt", Transparency, "UInt", LWA_ALPHA)
}


; Label to show the custom tooltip based on the slider value and adjust transparency
ShowCustomTooltip:
    ; Get the current position of the TransparencySlider
    GuiControlGet, currentTransparency, , TransparencySlider
    
    ; Calculate the transparency percentage
    transparencyPercent := Round(((255 - currentTransparency) / 205) * 100)
    
    ; Define the tooltip text
    tooltipText := transparencyPercent . "%"
    
    ; Get the current position of the mouse cursor
    MouseGetPos, mouseX, mouseY
    
    ; Show the tooltip near the cursor position
    ToolTip, %tooltipText%, mouseX + 15, mouseY - 20
    
    ; Set a timer to remove the tooltip after 2 seconds
    SetTimer, RemoveToolTip, 2000

    ; Call the label to adjust transparency
    Gosub, AdjustTransparency
return


; Add a new label to show or hide the input box and label based on the checkbox state
ShowHideInput:
    ; Update the GUI controls
    Gui, Submit, NoHide
    
    ; Get the state of the checkbox
    tickboxState := CheckboxVar
    
    ; Show or hide the input box and label based on the checkbox state
    if (CheckboxVar) {
        GuiControl, Show, AdditionalInput
        GuiControl, Show, SpeakerLabel
        GuiControl, Focus, AdditionalInput ; set the focus to the speaker input box
    } else {
        GuiControl, Hide, AdditionalInput
        GuiControl, Hide, SpeakerLabel
    }
return


; Detect Enter key press in ListView and call SelectRPFromListView function
ButtonOK:
    
    ; Get the control that currently has keyboard focus
    Gui, %activeGuiName%:Default
    GuiControlGet, FocusedControl, FocusV
    
    ; If the control with focus is not the RPLines, exit the subroutine
    if (FocusedControl != "RPLines")
        return
    
    ; Call the SelectRPFromListView function and pass "Enter" as an argument
    SelectRPFromListView("Enter")
return


; Updates the ListView with search results based on the user's query.
SearchAll:
    Gui, Submit, NoHide
    GuiControl, -Redraw, RPLines
    LV_Delete()

    ; Full path to the TXT file
    TxtFile := A_ScriptDir "\" vRPLines

    ; Loop over each line in the TXT file
    Loop, Read, %TxtFile%
    {
        ; Get the current line
        currentLine := A_LoopReadLine

        ; If the line starts with a bracket, it's a section name (category)
        if (SubStr(currentLine, 1, 1) = "[")
        {
            category := SubStr(currentLine, 2, StrLen(currentLine) - 2)
            continue
        }

        ; If the line is empty or starts with a semicolon, skip it
        if (StrLen(currentLine) = 0 || SubStr(currentLine, 1, 1) = ";")
            continue

        ; Otherwise, treat the entire line as the RP.
        RP := currentLine

        ; Add the RP to the ListView if it matches the search query
        if (Query == "" or InStr(category, Query) or InStr(RP, Query))
            LV_Add("", category, RP)
    }

    GuiControl, +Redraw, RPLines
return


; Search function for the compact GUI
SearchAllCompact:
    Gui, CompactGui:Submit, NoHide
    ; Disable redrawing of the RPLines control to improve performance
    GuiControl, -Redraw, RPLines
    ; Clear the ListView
    LV_Delete()

    ; Full path to the TXT file
    TxtFile := A_ScriptDir "\" vRPLines

    ; Loop over each line in the TXT file
    Loop, Read, %TxtFile%
    {
        ; Get the current line
        currentLine := A_LoopReadLine

        ; If the line starts with a bracket, it's a section name (category)
        if (SubStr(currentLine, 1, 1) = "[")
        {
            category := SubStr(currentLine, 2, StrLen(currentLine) - 2)
            continue
        }

        ; If the line is empty or starts with a semicolon, skip it
        if (StrLen(currentLine) = 0 || SubStr(currentLine, 1, 1) = ";")
            continue

        ; Otherwise, treat the entire line as the RP.
        RP := currentLine

        ; Add the RP to the ListView if it matches the search query
        if (Query == "" or InStr(category, Query) or InStr(RP, Query))
            LV_Add("", category, RP)
    }

    ; Enable redrawing of the RPLines control
    GuiControl, +Redraw, RPLines
return


; Function to replace variables within the text, with a GUI allowing users to input variable values
ReplaceVariables(RPToSend, sectionName) {

    ; Process special commands without triggering GUI
    RPToSend := ProcessSpecialCommands(RPToSend)

    ; Declare WrappedText as global
    global WrappedText
    GuiCanceled := false

    ; Preserve the original text
    originalRPToSend := RPToSend
    Gosub, CheckTickBoxAndClose

    ; Initialize and store variables detected in the text
    variableList := []
    doNotEnterFlag := false ; Flag to check if {DoNotEnter} is present
    
    while (Pos := RegExMatch(originalRPToSend, "\{([^{}]+)\}", var)) {
        variableName := var1
    
        ; If the variable is {DoNotEnter}, set the flag and skip further processing for this variable
        if (variableName = "DoNotEnter") {
            doNotEnterFlag := true
            originalRPToSend := StrReplace(originalRPToSend, "{DoNotEnter}", "")
            continue
        }
    
        ; Return an error if an empty variable is detected
        if (!variableName) {
            MsgBox, Error: Detected an empty variable.
            return
        }
    
        ; Exclude special commands from variable processing
        if (variableName = "UTCDateTime") ; add other special commands as needed
            continue
    
        ; Store the variable name and remove it from the original text
        variableList.Push(variableName)
        originalRPToSend := StrReplace(originalRPToSend, "{" . variableName . "}", "", 1)
    }


    numVariables := variableList.Length()

    ; If variables are found, show the GUI for input
    if (numVariables > 0) {
        
        ; Temporarily disable AlwaysOnTop for main GUI
        Gui, RandomRP:-AlwaysOnTop
        
        ; Calculate how many columns we'll have
        numColumns := Ceil(numVariables / 10)

        ; Adjust the WrappedText width for each extra column
        wrapWidth := 300 + (numColumns - 1) * 300

        ; Prepare variables GUI with styling
        Gui, VariablesGUI:New, +AlwaysOnTop -SysMenu
        Gui, Font, s10, Segoe UI Semibold
        Gui, Color, C0C0C0
        Gui, VariablesGUI:Add, Text,, % "Entering variables for: " sectionName
        Gui, VariablesGUI:Add, Text, w%wrapWidth% vWrappedText, % "Selected line: " RPToSend ; Updated width for word wrap.
        
        ; Calculate the number of lines the wrapped text occupies.
        GuiControlGet, WrappedText
        lines := Ceil(StrLen(WrappedText) / (wrapWidth / 10)) ; Update character count estimate based on new width.
        
        ; Adjust yTextOffset and yEditOffset based on the wrapped text's height
        lineHeight := 10 ; This is an estimate for a single line's height. Adjust accordingly.
        additionalOffset := lines * lineHeight ; Calculate the additional offset needed.
        
        ; Variables for layout management
        maxRows := 10 ; Set the number of rows before starting a new column
        leftPadding := 12 ; Left padding for the columns
        xOffset := leftPadding ; X-offset for new columns
        baseYOffset := 60 + additionalOffset ; This will be our starting Y-offset for each column
        yTextOffset := baseYOffset ; Initialize yTextOffset with baseYOffset
        yEditOffset := 80 + additionalOffset ; Y-offset for edit boxes adjusted based on the wrapped text height.

        ; Loop through variables and create the GUI layout
        loop, % numVariables {
            ; Check if a new column needs to be started
            if (A_Index > maxRows and Mod(A_Index, maxRows) = 1) {
                xOffset += 350 + leftPadding ; Adjust for the new column
                yTextOffset := baseYOffset ; Reset the Y-offset for the new column based on baseYOffset
                yEditOffset := 80 + additionalOffset ; Reset for edit boxes
            }
        
            ; Add text and edit boxes to the GUI
            Gui, VariablesGUI:Add, Text, x%xOffset% y%yTextOffset%, % "Enter " variableList[A_Index] ":"
            defaultValue := variableValues.HasKey(variableList[A_Index]) ? variableValues[variableList[A_Index]] : ""
            Gui, VariablesGUI:Add, Edit, x%xOffset% y%yEditOffset% w300 h30 vvEdit%A_Index%, % defaultValue
        
            yTextOffset += 60 
            yEditOffset += 60
        }

        ; Detect when Enter is pressed in the Edit controls
        OnMessage(0x100, "HandleEnterKey")

        ; Add Accept and Cancel buttons
        ButtonWidth := 70
        Gui, VariablesGUI:Add, Button, w%ButtonWidth% gVariableAccept, Accept
        Gui, VariablesGUI:Add, Button, x+5 w%ButtonWidth% gVariableCancel, Cancel

        ; Show the GUI
        Gui, VariablesGUI:Show, Center, Enter Variables

        ; Loop to keep the GUI open
        guiOpen := true
        While, guiOpen {
            Sleep, 100
        }

        if (GuiCanceled) {
            return ""
        }

    ; Replace variables in the text with user input
    for index, variableName in variableList {
        controlName := "vEdit" . index
        userInput := %controlName%
        userInput := StrReplace(userInput, "`n", " ") ; Convert newlines to spaces

        ; Process NumberOfWeeksFromToday variable
        if (variableName = "NumberOfWeeksFromToday") {
            weeks := userInput
            NumberOfWeeksFromToday := A_Now
            NumberOfWeeksFromToday += weeks * 7, days
            FormatTime, formattedDate, %NumberOfWeeksFromToday%, MMMM d, yyyy
            userInput := formattedDate
        }

    RPToSend := StrReplace(RPToSend, "{" . variableName . "}", userInput)
    variableValues[variableName] := userInput
}

        ; Remove the OnMessage function
        OnMessage(0x100, "")

        ; Re-enable AlwaysOnTop for main GUI
        Gosub, UpdateAlwaysOnTopState
    }

    return RPToSend
}


; Special variables that are set up for special functionality.
ProcessSpecialCommands(RPLine) {
    ; Handle the CurrentDateTimeUTC special command
    if (InStr(RPLine, "{UTCDateTime}")) {
        FormatTime, date, %A_NowUTC%, dd/MMM  ; Formats the current UTC date into 'dd/MMM' format.
        FormatTime, time, %A_NowUTC%, hh:mm tt  ; Formats the current UTC time into 'hh:mm tt' format.
        StringUpper, date, date  ; Converts the date to uppercase.
        CurrentDateTime = %time% %date%  ; Combines the time and date into a single variable.
        RPLine := StrReplace(RPLine, "{UTCDateTime}", CurrentDateTime)
    }

    ; Handle the TodayDate special command
    if (InStr(RPLine, "{TodaysDate}")) {
        FormatTime, todaysDate,, MMMM d, yyyy  ; Formats today's date as 'MMMM d, yyyy'.
        RPLine := StrReplace(RPLine, "{TodaysDate}", todaysDate)
    }

    ; Handle the RandomNumber special command
    if (InStr(RPLine, "{RandomNumber}")) {
        Random, randomNumber, 1, 100 ; Generates a random number between 1 and 100.
        RPLine := StrReplace(RPLine, "{RandomNumber}", randomNumber)
    }

    return RPLine
}


; Function to handle the Enter key press within specific windows, triggering different subs based on the active window
HandleEnterKey(wParam, lParam) {
    if (wParam = 0xD) ; Check for VK_RETURN or Enter key code
    {
        ; Determine the active window and call the corresponding subroutine
        IfWinActive, Add a RP line
            Gosub, SubmitAddRPLine
        Else IfWinActive, Edit a RP line
            Gosub, SubmitEditRPLine
        Else IfWinActive, Enter Variables
            Gosub, VariableAccept
    }
    return
}


; GUI Event Handlers for handling Accept and Cancel actions within the Variables GUI
VariableAccept:
    global guiOpen
    Gui, VariablesGUI:Submit, NoHide ; Submit the GUI without hiding
    guiOpen := false ; Close the GUI loop
    Gui, VariablesGUI:Destroy ; Destroy the Variables GUI
Return


; Cancel button for the Variables GUI
VariableCancel:
    global guiOpen, GuiCanceled
    GuiCanceled := true
    guiOpen := false
    Gui, VariablesGUI:Destroy
Return


; Function to handle the selection of an RP line from the ListView either by pressing Enter or double-clicking
; Executes the corresponding RP line by activating the window, saving the GUI state, checking a checkbox, and sending the RP line with a delay
SelectRPFromListView(eventType := "") {
    ; Exit the function if neither a double click nor "Enter" triggered it
    if (eventType != "Enter" && A_GuiEvent != "DoubleClick") {
        return
    }

    ; If "Enter" was pressed or a double click occurred, retrieve details from the selected row
    if (eventType == "Enter") {
        focusedRow := LV_GetNext(0, "Focused") ; Get the focused row number
        LV_GetText(RPToSend, focusedRow, 2) ; Get RP line from 2nd column
        LV_GetText(sectionNameForRP, focusedRow, 1) ; Get section name from 1st column
    } else if (A_GuiEvent = "DoubleClick") {
        focusedRow := A_EventInfo ; Get row number from event info
        LV_GetText(RPToSend, focusedRow, 2) ; Get RP line from 3rd column
        LV_GetText(sectionNameForRP, focusedRow, 1) ; Get section name from 1st column
    }

    ; If no valid RP line is selected, show a message box
    if (RPToSend = "" || RPToSend = "RP Line") {
        return
    }

    ; Replace variables in the RP line and exit if user cancels input
    RPToSend := ReplaceVariables(RPToSend, sectionNameForRP)
    RPToSend := ReplaceDateTime(RPToSend)
    if (RPToSend = "")
        return

    ; Activate the target application window and save the current state of the GUI without hiding it
    WinActivate, ahk_exe %Application%
    Gui, FullSizeGui:Submit, NoHide

    ; Check the checkbox state and close the GUI if checked
    Gosub, CheckTickBoxAndClose

    ; Send the RP line with a specified delay
    SendMessagewithDelayFunction(RPToSend)
}


; Subroutine to check if the GUI should be closed after a selection and destroy it if needed
CheckTickBoxAndClose:
    ; Destroy the GUI if the closeOnSelectState variable is false
    if (!closeOnSelectState)
        Gui, Destroy
return


; Function to update the AlwaysOnTop state of the active GUI based on the closeOnSelectState variable
; Enables or disables the AlwaysOnTop property for both FullSizeGui and CompactGui, depending on the condition
UpdateAlwaysOnTopState:
    ; Check if the active GUI is FullSizeGui
    if (activeGuiName = "FullSizeGui") {
        if (closeOnSelectState) {
            Gui, FullSizeGui:+AlwaysOnTop ; Enable AlwaysOnTop if closeOnSelectState is true
        } else {
            Gui, FullSizeGui:-AlwaysOnTop ; Disable AlwaysOnTop if closeOnSelectState is false
        }
    } 
    ; Check if the active GUI is CompactGui
    else if (activeGuiName = "CompactGui") {
        if (closeOnSelectState) {
            Gui, CompactGui:+AlwaysOnTop ; Enable AlwaysOnTop if closeOnSelectState is true
        } else {
            Gui, CompactGui:-AlwaysOnTop ; Disable AlwaysOnTop if closeOnSelectState is false
        }
    }
return


; Custom made variable for entering the UTC Date and Time automatically
ReplaceDateTime(RPLine) {
    ; Check if the RP line contains the placeholder
    if (InStr(RPLine, "{UTC_DATETIME}")) {
        FormatTime, date, %A_NowUTC%, dd/MMM  ; Formats the current UTC date into 'dd/MMM' format.
        FormatTime, time, %A_NowUTC%, hh:mm tt  ; Formats the current UTC time into 'hh:mm tt' format.
        StringUpper, date, date  ; Converts the date to uppercase.
        CurrentDateTime := time . " " . date  ; Combines the time and date into a single variable.
        
        ; Replace the placeholder with the actual date and time
        RPLine := StrReplace(RPLine, "{UTC_DATETIME}", CurrentDateTime)
    }
    return RPLine
}


; Function to display GUI for adding RP line, including checks for text content
AddRPLine:
    ; Get sections from the TXT file
    sections := []
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, txtData, %TxtFile%
    Loop, Parse, txtData, `n, `r
    {
        line := A_LoopField
        if (SubStr(line, 1, 1) = "[") ; If the line starts with a bracket, it's a section name
            sections.Push(SubStr(line, 2, StrLen(line) - 2))
    }
    Gosub, CheckTickBoxAndClose

    ; Setup OnMessage to detect when Enter is pressed in the Edit controls
    OnMessage(0x100, "HandleEnterKey")

    ; Create the GUI
    Gui, AddRPLine:New, +AlwaysOnTop -SysMenu
    Gui, Font, s11, Segoe UI Semibold
    Gui, Color, C0C0C0

    ; GUI controls for selecting category and entering RP Line
    Gui, Add, Text, x10 y10, Select a Category or type in a new one
    Gui, Add, ComboBox, vNewSection x10 y30 w300 h400, % StrJoin("|", sections)

    Gui, Add, Text, x10 y70, RP Line
    Gui, Add, Edit, vNewRPLine x10 y90 w500 h70 hwndNewRPLineHWND,
    Gui, FullSizeGui:Font, s8, Microsoft Sans Serif
    Gui, Add, Button, x470 y60 w40 h18 gInsertBrackets vVariableButton, {    }
    Gui, Font, s11, Segoe UI Semibold
    Gui, Add, Button, gSubmitAddRPLine x100 y170 w120 Default, Add RP Line
    Gui, Add, Button, gCancelAddRP x290 y170 w120, Cancel
    Gui, Add, Button, x490 y10 w20 h20 gDisplayToolTipForHelpButton vHelpButton, ?
    Gui, Show, , Add a RP line

    ; Store control HWNDs for Enter key handling
    GuiControlGet, NewRPLineHwnd, Hwnd, NewRPLine
    GuiControlGet, NewSectionHwnd, Hwnd, NewSection ; Store the HWND of the category dropdown box

return


; Custom button for canceling the Add RP GUI
CancelAddRP:
    if (closeOnSelectState = 1)
    {
        ; Assuming you're trying to close the "Add a RP line" sub-GUI
        Gui, AddRPLine:Destroy
    }
    else
    {
        ToggleRPGui()
    }
return


; Function to insert brackets around selected text in the edit control
InsertBrackets:
    ; Get the currently selected text in the edit control
    ControlGetText, CurrentContent, Edit2, Add a RP line
    ControlGet, SelectedText, Selected,, Edit2, Add a RP line

    ; If there's no selected text, show a message and exit
    if (SelectedText = "")
    {
        ; Show the message box on top of other windows
        MsgBox, 262144, , Select the text to add brackets
        return
    }

    ; Check if there's a trailing space
    HasTrailingSpace := (SubStr(SelectedText, 0) = " ")

    ; Trim spaces from the selected text
    SelectedText := Trim(SelectedText)

    ; Bracket the text and add a space after if there was a trailing space
    BracketedText := "{" . SelectedText . "}" . (HasTrailingSpace ? " " : "")

    ; Set focus to the control to prepare for SendInput
    ControlFocus, Edit2, Add a RP line

    ; Use SendInput to simulate the necessary keystrokes:
    SendInput, ^x{Raw}%BracketedText%
return

; Function to control adding brackets for the Edit menu
InsertBracketsForEdit:
    ; Make sure we're working with the correct GUI
    Gui, EditRPLine:Default

    ; Get the currently selected text in the second edit control
    ControlGet, SelectedText, Selected,, Edit2, Edit a RP line

    ; If there's no selected text, show a message and exit
    if (SelectedText = "") {
        ; Show the message box on top of other windows
        MsgBox, 262144, , Select the text to add brackets
        return
    }

    ; Check if there's a trailing space
    HasTrailingSpace := (SubStr(SelectedText, 0) = " ")

    ; Trim spaces from the selected text
    SelectedText := Trim(SelectedText)

    ; Bracket the text and add a space after if there was a trailing space
    BracketedText := "{" . SelectedText . "}" . (HasTrailingSpace ? " " : "")

    ; Set focus to the second control to prepare for SendInput
    ControlFocus, Edit2, Edit a RP line

    ; Use SendInput to simulate the necessary keystrokes:
    SendInput, ^x{Raw}%BracketedText%
return


; Function to submit the new RP Line, ensuring no more than 20 variables within brackets are entered
SubmitAddRPLine:
    Gui, Submit, NoHide

    ; Remove any whitespace from the start and end of both inputs
    NewRPLine := Trim(NewRPLine)
    NewSection := Trim(NewSection)

    ; Count occurrences of opening brackets { to represent the variables
    count := 0
    Loop, Parse, NewRPLine, { ; Only parse for opening brackets
    {
        count++
    }

    ; Check if more than 50 variables have been added
    if (count > 51)
    {
        Gui, AddRPLine:Destroy
        MsgBox, No more than 50 variables allowed.
        return
    }

    ; Validate if the NewRPLine or NewSection is essentially empty
    if (NewRPLine = "" || NewSection = "")
    {
        ; Close the Add RP GUI
        Gui, AddRPLine:Destroy
        MsgBox, Please ensure that both the category and RP line are not empty.
        return
    }

    ; Convert any newlines in RP line to spaces, condensing it into a single line
    NewRPLine := StrReplace(NewRPLine, "`n", " ")

    ; Read the entire TXT file
    FileRead, txtData, %TxtFile%

    sectionStart := InStr(txtData, "[" . NewSection . "]")
    if(sectionStart = 0) ; If the section does not exist
    {
        newLine := "`n`n[" . NewSection . "]`n" . NewRPLine  
        txtData := txtData . newLine
    }
    else
    {
        ; Find the end of the section to append the new RP line
        sectionEnd := InStr(txtData, "`n[", false, sectionStart + StrLen(NewSection) + 2)

        ; Prepare the new RP line
        newLine := "`n" . NewRPLine 

        ; If there is no other section, append the new line to the end of the file
        if (sectionEnd = 0)
        {
            txtData := txtData . newLine
        }
        else
        {
            ; Find the last newline before the next section
            lastNewlineBeforeSection := sectionEnd - 1
            while (SubStr(txtData, lastNewlineBeforeSection, 1) != "`n" && lastNewlineBeforeSection > sectionStart)
                lastNewlineBeforeSection--
        
            ; Insert the new RP line right after the last newline before the next section
            txtData := SubStr(txtData, 1, lastNewlineBeforeSection - 1) . newLine . SubStr(txtData, lastNewlineBeforeSection)
        }
    }

    ; Write the updated data to the TXT file
    FileDelete, %TxtFile%
    FileAppend, %txtData%, %TxtFile%
    Gosub, SanitizeFile

    ; Close the GUI
    Gui, AddRPLine:Destroy

    ; Update the ListView
    Gosub, RecreateGUI
return


; Function to edit an RP line. This function is triggered when a user wants to edit a specific RP line from the ListView.
EditRPLine:
    ; Get the number of the focused row in the ListView
    focusedRow := LV_GetNext(0, "Focused")

    ; If no row is selected, show a message dialog and exit the function
    if (focusedRow = 0) {
        Gui, NoSelection:New, +AlwaysOnTop -SysMenu 
        Gui, Font, s11, Segoe UI Semibold
        Gui, Color, C0C0C0
        Gui, Add, Text, , Please first select a line from the list to edit.
        Gui, Add, Button, gGUIClose x120 y40 w80, OK
        Gui, Show, , No Selection
        return
    }

    ; Get the Category and RP of the selected row
    LV_GetText(selectedCategory, focusedRow, 1)
    LV_GetText(selectedRP, focusedRow, 2)
    Gosub, CheckTickBoxAndClose ; Check the checkbox state and close the GUI if needed

    ; Setup OnMessage to detect when Enter is pressed in the Edit controls
    OnMessage(0x100, "HandleEnterKey")

    ; Create a GUI with input boxes for editing the category and the RP line
    Gui, EditRPLine:New, +AlwaysOnTop -SysMenu 
    Gui, Font, s11, Segoe UI Semibold
    Gui, Color, C0C0C0
    Gui, Add, Text, x10 y10, Edit Category Name
    Gui, Add, Edit, vEditedCategory +WantReturn x10 y30 w500, %selectedCategory%
    Gui, Add, Text, x10 y70, Edit RP Line
    Gui, Add, Edit, vEditedRPLine +WantReturn x10 y90 h90 w500, %selectedRP%
    Gui, Add, Button, gSubmitEditRPLine x100 y190 w120 Default, Edit RP Line 
    Gui, Add, Button, x470 y60 w40 h18 gInsertBracketsForEdit vVariableButton, {    }
    Gui, Add, Button, gCancelEditRP x290 y190 w120, Cancel   
    Gui, Show, , Edit a RP line
return


; Custom button for closing the Edit RP GUI
CancelEditRP:
    if (closeOnSelectState = 1)
    {
        ; Close the "Edit a RP line" GUI
        Gui, EditRPLine:Destroy
    }
    else
    {
        ToggleRPGui()
    }
return


; Function to submit an edited RP line. This function saves the changes made to a specific RP line in the TXT file and updates the GUI accordingly.
SubmitEditRPLine:
    Gui, Submit, NoHide ; Submit changes made in the Edit RP line GUI

    ; Convert any newlines in the edited RP line to spaces, condensing it into a single line
    EditedRPLine := StrReplace(EditedRPLine, "`n", " ")

    ; Read the entire TXT file containing the RP lines
    FileRead, txtData, %vRPLines%

    ; Check for duplicate categories
    if (selectedCategory != EditedCategory && InStr(txtData, "[" . EditedCategory . "]") > 0) ; If the edited category is not the same as the selected one and it already exists
    {
        Gui, EditRPLine:Destroy
        MsgBox, This category already exists. Please choose another name.
        return
    }

    ; Replace the specific category and RP line in the TXT file with the edited values
    txtData := StrReplace(txtData, "[" . selectedCategory . "]", "[" . EditedCategory . "]")
    txtData := StrReplace(txtData, selectedRP, EditedRPLine)

    ; Write the updated data back to the TXT file
    FileDelete, %vRPLines% ; Delete the original TXT file
    FileAppend, %txtData%, %vRPLines% ; Append the updated data to a new TXT file

    ; Close the Edit RP line GUI
    Gui, EditRPLine:Destroy

    ; Update the ListView to reflect the changes
    Gosub, RecreateGUI
return


; Function to delete a selected RP line or entire category from the menu
DeleteRPLine:
    ; Get the focused row in the list view
    focusedRow := LV_GetNext(0, "Focused")

    ; If no row is focused, display a dialog to inform the user to select a line
    if (focusedRow = 0)
    {
        Gui, NoSelection:New, +AlwaysOnTop -SysMenu 
        Gui, Font, s11, Segoe UI Semibold
        Gui, Color, C0C0C0
        Gui, Add, Text, , Please first select a line from the list to delete.
        Gui, Add, Button, gGUIClose x130 y40 w80, OK
        Gui, Show, , No Selection
        return
    }

    ; Get the text of the selected category and RP line
    LV_GetText(selectedCategory, focusedRow, 1)
    LV_GetText(selectedRPLine, focusedRow, 2)
    ; Subroutine to check the tick box and close the window
    Gosub, CheckTickBoxAndClose

    ; Display the delete confirmation dialog
    Gui, DeleteConfirm:New, +AlwaysOnTop -SysMenu 
    Gui, Font, s11, Segoe UI Semibold
    Gui, Color, C0C0C0
    Gui, Add, Text,, Do you want to:
    Gui, Add, Button, gDeleteLine x8 y40 w180, Delete only this line
    Gui, Add, Button, gDeleteCategory x8 y80 w180, Delete entire category
    Gui, Add, Button, gCancelDeleteRP x8 y120 w180, Cancel
    Gui, Show, , Delete Selection
return


; Function to delete a single line, setting the delete choice as "Line"
DeleteLine:
    deleteChoice := "Line"
    ; Subroutine to confirm the delete action
    Gosub, ConfirmDeleteAction
return


; Function to delete an entire category, setting the delete choice as "Category"
DeleteCategory:
    deleteChoice := "Category"
    ; Subroutine to confirm the delete action
    Gosub, ConfirmDeleteAction
return


; Custom button for canceling the Delete RP GUI
CancelDeleteRP:
    if (closeOnSelectState = 1)
    {
        ; Close the "Delete Selection" GUI
        Gui, DeleteConfirm:Destroy
    }
    else
    {
        ToggleRPGui()
    }
return


; Function to confirm the deletion action for either an RP line or category
ConfirmDeleteAction:
    controlWidth := 500 ; Default width for the RP Line

    ; Set the display text based on whether it's a line or category deletion
    if (deleteChoice = "Line") {
        displayText := "Delete the line """ . selectedRPLine . """?"
    }
    else if (deleteChoice = "Category") {
        displayText := "Delete the category """ . selectedCategory . """ and all its lines?"
        controlWidth := 300 ; Adjust width for the category deletion
    }

    ; Configure the GUI settings and add text control
    Gui, DeleteConfirm2:New, +AlwaysOnTop -SysMenu 
    Gui, Font, s11, Segoe UI Semibold
    Gui, Color, C0C0C0
    Gui, Add, Text, w%controlWidth% vTextControl, %displayText%

    ; Determine the height of the text control by temporarily displaying the GUI
    Gui, Show, NoActivate Hide, Confirm Delete
    GuiControlGet, TextControl, Pos, TextControl
    textHeight := TextControlH
    Gui, Hide

    ; Calculate the overall GUI height
    baseHeight := 90 ; Base height adjusted for single line
    lineHeight := 20 ; Estimated height for each line
    numLines := Round(textHeight / lineHeight)
    guiHeight := baseHeight + (lineHeight * (numLines - 1))

    ; Calculate positions for the buttons
    yOffset := textHeight + 30  ; Position buttons 20 pixels below the text

    ; Calculate the X position for buttons considering their width and spacing
    buttonWidth := 80 ; Width of each button
    spaceBetweenButtons := 20 ; Space between buttons
    combinedButtonWidth := (buttonWidth * 2) + spaceBetweenButtons
    startXPos := (controlWidth - combinedButtonWidth) / 2
    firstButtonXPos := startXPos
    secondButtonXPos := startXPos + buttonWidth + spaceBetweenButtons

    ; Add buttons based on the deletion choice (Line or Category)
    if (deleteChoice = "Line") {
        Gui, Add, Button, gExecuteDeleteAction x%firstButtonXPos% y%yOffset% w80, Yes
        Gui, Add, Button, gGUIClose x%secondButtonXPos% y%yOffset% w80, No
    } else if (deleteChoice = "Category") {
        Gui, Add, Button, gExecuteDeleteAction x%firstButtonXPos% y%yOffset% w80, Accept
        Gui, Add, Button, gGUIClose x%secondButtonXPos% y%yOffset% w80, Cancel
    }

    ; Show the final GUI with calculated height
    Gui, Show, h%guiHeight% , Confirm Delete
return


; Execute an action to delete either a line or a category within the RP Text Line Menu
ExecuteDeleteAction:
    ; Check if the user wants to delete a Line
    if (deleteChoice = "Line")
    {
        Gosub, DeleteYes
    }
    ; Check if the user wants to delete a Category
    else if (deleteChoice = "Category")
    {
        ; Read the RP lines file
        FileRead, txtData, %vRPLines%

        ; Find the start of the selected category
        categoryStart := InStr(txtData, "[" . selectedCategory . "]")
        if (categoryStart > 0)
        {
            ; Find the end of the selected category
            categoryEnd := InStr(txtData, "`n[", false, categoryStart)
            if (categoryEnd = 0)
                categoryEnd := StrLen(txtData) + 1
            ; Remove the selected category from the text data
            txtData := SubStr(txtData, 1, categoryStart - 1) . SubStr(txtData, categoryEnd)
            ; Delete and re-append the text data to the file
            FileDelete, %vRPLines%
            FileAppend, %txtData%, %vRPLines%
        }
        ; Recreate the GUI to reflect changes
        Gosub, RecreateGUI
    }

    ; Sanitize the file and reset variables
    Gosub, SanitizeFile
    deleteChoice := ""
    ; Destroy the delete confirmation GUIs
    Gui, DeleteConfirm:Destroy
    Gui, DeleteConfirm2:Destroy
return


; Delete a specific line that was confirmed by the user
DeleteYes:
    ; Destroy the delete confirmation GUI
    Gui, DeleteConfirm:Destroy

    ; Delete the selected row from the ListView
    LV_Delete(focusedRow)

    ; Read the RP lines file
    FileRead, txtData, %vRPLines%

    lineCounter := 0
    linePos := 1 ; Starting from the first character
    targetLineStartPos := 0
    targetLineEndPos := 0

    while (lineCounter < focusedRow and linePos <= StrLen(txtData)) {
        nextLinePos := InStr(txtData, "`n", false, linePos)
        
        ; Extract the current line's content
        currentLine := (nextLinePos > 0) ? SubStr(txtData, linePos, nextLinePos - linePos) : SubStr(txtData, linePos)

        ; Check if the line is a category or empty; if not, increase the counter
        if (currentLine != "" and SubStr(currentLine, 1, 1) != "[") {
            lineCounter++
            ; Check if we've found our target line to delete
            if (lineCounter = focusedRow) {
                targetLineStartPos := linePos
                targetLineEndPos := (nextLinePos > 0) ? nextLinePos : StrLen(txtData) + 1
                break
            }
        }

        ; Move to the next line
        linePos := (nextLinePos > 0) ? nextLinePos + 1 : StrLen(txtData) + 1
    }

    if (targetLineStartPos > 0 and targetLineEndPos > 0) {
        ; Remove the line and update the text data
        txtData := SubStr(txtData, 1, targetLineStartPos - 1) . SubStr(txtData, targetLineEndPos + 1)

        ; Delete and re-append the text data to the file
        FileDelete, %vRPLines%
        FileAppend, %txtData%, %vRPLines%
    }

    ; Sanitize the file and recreate the GUI
    Gosub, SanitizeFile
    Gosub, RecreateGUI
return


; Sanitizes the given text file by removing unnecessary empty lines and formatting category sections
SanitizeFile:
    ; Read the entire file into memory
    FileRead, txtData, %TxtFile%

    ; Remove all consecutive empty lines, leaving only single line breaks
    txtData := RegExReplace(txtData, "`n\s*`n+", "`n")

    ; Ensure there's exactly one empty line above each category, except at the start of the file
    txtData := RegExReplace(txtData, "(?<!^)(?<!`n)`n(\[.*?\])", "`n`n$1")

    ; Remove any leading empty lines before the first category
    txtData := RegExReplace(txtData, "^\s*`n+", "")

    ; Write the sanitized data back to the file
    FileDelete, %TxtFile%
    FileAppend, %txtData%, %TxtFile%
return


; This function handles the Random RP menu, allowing the user to destroy any previous GUI, check a checkbox's state, read sections from a TXT file,
; create a new GUI with a dropdown list and various buttons, and adjust the GUI's size.
RandomRP:

    ; Check the state of the checkbox and close the GUI if the checkbox is checked
    Gosub, CheckTickBoxAndClose
    
    ; Initialize sections array and read from the TXT file
    sections := []
    FileRead, txtData, %vRPLines%
    Loop, Parse, txtData, `n, `r
    {
        line := A_LoopField
        ; Add the line to the sections array if it starts with a bracket (it's a section name)
        if (SubStr(line, 1, 1) = "[")
            sections.Push(SubStr(line, 2, StrLen(line) - 2))
    }

    ; Create a new GUI with specific styling and a dropdown list
    Gui, RandomRP:New, +AlwaysOnTop -SysMenu 
    Gui, Font, s11, Segoe UI Semibold
    Gui, Color, C0C0C0

    currentY := dropdownrandomY

    ; Loop through the dropdowns and add them to the GUI
    Loop, %dropdownCount%
    {
        ; Add dropdown with previously selected items if available
        if (A_Index <= currentDropdownSelections.MaxIndex()) {
            selection := currentDropdownSelections[A_Index]
            selectedIndex := GetIndex(selection, sections)
            Gui, Add, DropDownList, vSelectedSection%A_Index% x10 y%currentY% w200 h400 Choose%selectedIndex%, % StrJoin("|", sections) 
        } else {
            Gui, Add, DropDownList, vSelectedSection%A_Index% x10 y%currentY% w200 h400 Choose1, % StrJoin("|", sections) 
        }
        currentY += 30 ; Move down for the next dropdown
    }


    ; Add various buttons to the GUI
    Gui, Font, s9, Segoe UI Semibold        
    Gui, Add, Button, x214 y2 w14 h14 gDisplayToolTipForHelpButtonRandomRP vHelpButtonRandomRP, ?
    Gui, Font, s11, Segoe UI Semibold
    Gui, Add, Button, gSubmitRandomRP x10 y%currentY% w80 Default, Submit ; Submit button
    Gui, Add, Button, gCloseRandomRP x100 y%currentY% w60, Cancel         ; Cancel button
    Gui, Add, Button, gRemoveDropdown x170 y%currentY% w20, -              ; Minus Category - button
    Gui, Add, Button, gAddDropdown x190 y%currentY% w20, +                ; Add Category + button

    currentY += 30 ; Adjust for next potential dropdown

    GuiHeight := currentY + 10 ; Set the GUI's height with some padding
    Gui, Show, w230 h%GuiHeight%, Select Random Categories
return


; Removes the last dropdown from the current selections and decreases the dropdown count
RemoveDropdown:
    if (dropdownCount <= 1) ; Ensure never going below 1 dropdown
        return

    currentDropdownSelections := [] ; Clear the current dropdown selections
    Loop, %dropdownCount%
    {
        GuiControlGet, currentSelection, , SelectedSection%A_Index%
        currentDropdownSelections.Push(currentSelection) ; Store current dropdown values
    }

    dropdownCount-- ; Decrement the dropdown count
    Gosub, RandomRP ; Jump to RandomRP subroutine
return


; This function handles the destruction of the Random RP GUI and resets its settings
CloseRandomRP:
    Gui, RandomRP:Destroy ; Destroy the Random RP GUI
    activeGuiName := "" ; Reset active GUI name
    ResetRandomGui() ; Reset settings of the Random RP GUI
return


; Function to retrieve the index of a specific item within an array
GetIndex(item, array) {
    ; Iterate through the array
    for index, value in array {
        ; If the current value equals the target item, return its index
        if (value = item)
            return index
    }
    ; Return 0 if the item was not found in the array
    return 0
}


; Label to handle the AddDropdown button click
ButtonAddDropdown:
    ; Call the AddDropdown subroutine when the button is clicked
    Gosub, AddDropdown
return


; Function for submitting the random RP with the custom variables
SubmitRandomRP:
    ; Store the current value of activeGuiName in a local variable
    storedGuiName := activeGuiName
    ; Submit the current state of the GUI without hiding it
    Gui, Submit, NoHide

    ; Retrieve all dropdown values and store them in an array
    sectionNames := []
    Loop, %dropdownCount%
    {
        GuiControlGet, sectionName, , SelectedSection%A_Index%
        sectionNames.Push(sectionName)
    }

    ; Destroy the RandomRP GUI
    Gui, RandomRP:Destroy

    ; Initialize an empty array to hold the RP lines to send
    RPToSendList := []
    chosenTextLines := [] ; Array to store the selected text lines for display
    Loop, %dropdownCount%
    {
        sectionName := sectionNames[A_Index]
        ; Check if the section name is empty and show a message box if true
        if (sectionName = "") {
            MsgBox, Please make sure all dropdowns have a category selected!
            return
        }

        ; Read the TXT file and find the selected section's data
        FileRead, txtData, %vRPLines%
        sectionStart := InStr(txtData, "[" . sectionName . "]") + StrLen(sectionName) + 2
        sectionEnd := InStr(txtData, "`n[", false, sectionStart)
        sectionData := (sectionEnd = 0) ? SubStr(txtData, sectionStart) : SubStr(txtData, sectionStart, sectionEnd - sectionStart)

        ; Split the lines, trim whitespace, and add valid lines to the cleanedLines array
        lines := StrSplit(sectionData, "`n", "`r")
        cleanedLines := []
        for _, line in lines {
            line := Trim(line)
            if (StrLen(line) > 0 && SubStr(line, 1, 1) != "[" && SubStr(line, 1, 1) != ";")
                cleanedLines.Push(line)
        }

        ; Select a random line if available and add it to the RPToSendList array
        if (cleanedLines.MaxIndex() > 0) {
            Random, rand, 1, cleanedLines.MaxIndex()

            ; Ensure we don't select the same line twice in a row
            while (cleanedLines.MaxIndex() > 1 && previousLine.HasKey(sectionName) && cleanedLines[rand] = previousLine[sectionName]) {
                Random, rand, 1, cleanedLines.MaxIndex()
            }

            ; Store the chosen line as the previous line for the category
            previousLine[sectionName] := cleanedLines[rand]
            
            ; Store the chosen line for display purposes
            chosenTextLines.Push(sectionName . ": " . cleanedLines[rand])

            RPToSendList.Push(cleanedLines[rand])
        }
    }



    ; Replace variables within RP lines, if they exist
    for index, RPLine in RPToSendList {
        RPToSendList[index] := ReplaceVariables(RPLine, sectionNames[index])
        if (RPToSendList[index] = "") {
;            MsgBox, User canceled variable input! Process halted.
            return
        }
    }

    ; Prepare to send each RP line by destroying any existing GUI and activating the application
    Gui, RandomRP:Destroy
    Gui, Destroy
    WinActivate, ahk_exe %Application%
    Gui, FullSizeGui:Submit, NoHide
    stopSending := 0
    for _, RPToSend in RPToSendList {
        if (stopSending) {  ; Break if stopSending flag is set, and reset the flag
            stopSending := 0
            return
        }
        ResetRandomGui()
        SendMessagewithDelayFunction(RPToSend)
    }

    ; Restore the original value of activeGuiName
    activeGuiName := storedGuiName
return


; Resets the dropdown count and clears the current dropdown selections
ResetRandomGui() {
    dropdownCount := 1 ; Set the dropdown count to 1
    currentDropdownSelections := [] ; Clear the current dropdown selections
}


; Removes blank elements from an array
RemoveBlanks(arr) {
    newArr := [] ; Initialize new array
    for index, value in arr
        if (value != "") ; If the value is not blank, add it to the new array
            newArr.Push(value)
    return newArr ; Return the new array
}


; Joins an array of strings into a single string using a specified delimiter
StrJoin(delimiter, strings) {
    result := "" ; Initialize result string
    Loop, % strings.MaxIndex() {
        result .= strings[A_Index] ; Add each string to the result
        if (A_Index < strings.MaxIndex()) ; Don't add delimiter after the last element
            result .= delimiter
    }
    return result ; Return the concatenated string
}


; Adds a dropdown to the current selections and increases the dropdown count
AddDropdown:
    currentDropdownSelections := [] ; Clear the current dropdown selections
    Loop, %dropdownCount%
    {
        GuiControlGet, currentSelection, , SelectedSection%A_Index%
        currentDropdownSelections.Push(currentSelection) ; Store current dropdown values
    }

    dropdownCount++ ; Increment the dropdown count
    Gosub, RandomRP ; Jump to RandomRP subroutine
return


; Generates a random number between min and max (inclusive)
Rand(min, max) {
    Random, rand, min, max ; Generates a random number between min and max
    return rand ; Return the generated number
}


; Exits the script immediately
KillSwitch:
	ExitApp
return


; Handles the closing of the GUI
GuiClose:
    if (A_Gui == "RandomRP") ; Check if the closing GUI is "RandomRP"
    {
        ResetRandomGui() ; If so, reset the GUI
    }
    else
    {
        Gui, Destroy ; For other GUIs, just destroy
    }
return

; Function to send a message in-game with a character-based delay, with the option to send Enter at the end
; TextToSend: The text to send
; SendEnter: Whether to press Enter after sending the text (default is True)
SendMessagewithDelayFunction(TextToSend, SendEnter=True) {
    global stopTyping ; Global flag to control stopping of typing
    global isTypingActive ; Global flag to indicate typing activity

    ; Check if {DoNotEnter} is present in the TextToSend
    if (InStr(TextToSend, "{DoNotEnter}")) {
        ; Remove {DoNotEnter} from the text
        TextToSend := StrReplace(TextToSend, "{DoNotEnter}", "")
        ; Set SendEnter to false to prevent pressing Enter
        SendEnter := false
    }

    isTypingActive := 1 ; Set the typing active flag

    ; Reset the stopTyping flag
    stopTyping := false

    ; Activate the window of the specified application
    WinActivate, ahk_exe %Application%
    ; Press the 't' key to initiate text input
    SendInput, t

    ; Define sleep time per character (adjust as needed)
    sleepTimePerCharacter := 50 ; In milliseconds

    ; Loop through each character in the text and send one by one
    Loop, Parse, TextToSend
    {
        ; If stopTyping flag is set, reset and exit early
        if (stopTyping)
        {
            stopTyping := false
            isTypingActive := 0
            return
        }

        ; Send the current character
        SendInput, %A_LoopField%
        ; Wait based on defined sleep time per character
        Sleep, %sleepTimePerCharacter%
    }

    ; If SendEnter is True, send Enter key
    if (SendEnter)
    {
        Sleep, 15
        SendInput, {Enter}
    }

    ; Additional sleep of 500ms at the end
    Sleep, 1000

    ; Reset the typing active flag
    isTypingActive := 0
}



; Function to stop the typing operation made by SendMessagewithDelayFunction
StopTypingFunction() {
    global stopTyping ; Global flag to control stopping of typing
    stopTyping := true ; Set the stopTyping flag
}


; Created by Bassna, aka "Jonathan Willowick" for GTA 5 Eclipse RP server
; https://github.com/Bassna/Roleplaying-Menu
; Bassna on Discord
