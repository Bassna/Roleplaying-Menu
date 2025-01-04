#NoEnv                            ; Disables the automatic inclusion of parent environment variables in the script.
SetWorkingDir %A_ScriptDir%       ; Sets the working directory of the script to the directory containing the script itself.
#SingleInstance Force             ; Ensures that only a single instance of the script is allowed to run at any given time.
#Persistent                       ; Keeps the script running even after the auto-execute section has finished.
ListLines Off

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global Application := "GTA5.exe" ; Change this to the game or application you want to use. GTA5.exe for Eclipse, notepad.exe is good for testing (Open Notepad).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global ChatOpenKey := "t" ; Change this to the key you want to use to open the chat (e.g., "y" or "/").
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global vRPLines := "RPLines.txt" ; Change this to the new RP Line text file name, if you choose a different name.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Global Variables
global TestModeEnabled := false
global TestGui := "TestTypingGui"
global TestEdit


; Declare global variables
global previousSelections := {}
global listGroupOrder := []
global listGroupsGlobal := {}
global ListControlVar1, ListControlVar2, ListControlVar3, ListControlVar4, ListControlVar5, ListControlVar6, ListControlVar7, ListControlVar8, ListControlVar9, ListControlVar10, ListControlVar11, ListControlVar12, ListControlVar13, ListControlVar14, ListControlVar15, ListControlVar16, ListControlVar17, ListControlVar18, ListControlVar19, ListControlVar20, ListControlVar21, ListControlVar22, ListControlVar23, ListControlVar24, ListControlVar25, ListControlVar26, ListControlVar27, ListControlVar28, ListControlVar29, ListControlVar30, ListControlVar31, ListControlVar32, ListControlVar33, ListControlVar34, ListControlVar35, ListControlVar36, ListControlVar37, ListControlVar38, ListControlVar39, ListControlVar40, ListControlVar41, ListControlVar42, ListControlVar43, ListControlVar44, ListControlVar45, ListControlVar46, ListControlVar47, ListControlVar48, ListControlVar49, ListControlVar50
global SliderTextVar1, SliderTextVar2, SliderTextVar3, SliderTextVar4, SliderTextVar5


; Interface Elements
global activeGuiName, RandomRPButton, HelpMenuButton, EditRPButton, DeleteRPButton, PresetRPButton, StopRPLine, SpecialVarTree, SpecialVarDescription

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
global floatingGuis := []

; User Settings
global tickboxState := 0, tickboxStateCompact := 0, closeOnSelectState := 0
global variableValues := {}, currentDropdownSelections := []
global floatingGuiCheckboxStates := {}

global selectedCategory := ""
global selectedRPLine := ""
global TestModeEnabled := false

global floatingGuis := {}          ; Existing associative array mapping GUI names to preset names
global floatingGuiHwnds := {}      ; New associative array mapping HWNDs to GUI names
global floatingGuiPositions := {}  ; New associative array mapping GUI names to positions


; ---------------------------------------------------------------
InitializeRPLinesFile()

; ---------------- HOTKEYS SECTION ----------------


; Replace the keys within the colons with the desired hotkey.
; E.g., to change the ToggleSizeFunction from Shift+F5 to F4, replace "+F5" with "+F4".

F5::  ToggleRPGui()                  ; Main hotkey to open the RP Menu.

+F5::  ToggleSizeFunction()          ; Toggle between Full size and Compact size menus

^F5::  PlayRandomRPFunction()        ; Play a random RP Line

!F5::  TogglePresetGUI()             ; Toggle the Preset GUI

f11::  Pause                         ; Pause entire script and current typing. Press again to resume typing. 

F12::  KillswitchFunction()          ; Activate the killswitch, stopping all actions and terminating the script

; ---------------------------------------------------------------


InitializeRPLinesFile() {
    TxtFile := A_ScriptDir "\" vRPLines

    ; If the RP lines text file does not exist, create it and write the default data
    IfNotExist, %TxtFile%
    {
        FileAppend, 
        (LTrim Join`n
        [Work Tasks Examples]
        /me begins typing on the computer, working quickly to get the task finished.
        /me grabs a broom and begins sweeping up the dust from around the area.
        /me begins scrubbing on the windows with cleaner, trying to get them clean.

        [Medical Kit Examples]
        /me places the BLS kit on the floor, unzips it, and retrieves {Medical Item}.
        /me grabs {Medical Item} from the BLS kit, setting the kit on the ground.
        /me quickly unzips the BLS kit, searches around inside and grabs out {Medical Item}.
        
        [Floating Dos Examples]
        /fdo ~r~[FLYER]: ~y~Club Arcadius is the ~r~BEST ~w~nightclub in Los Santos!
        /fdo ~r~[Sign]: ~y~Arcadius Loans - ~b~ Cash when you need it most.
        /fdo ~r~[{Slider: Poster Type: Flyer, Sign, Poster}] ~y~Big Party at {Party Location} on ~b~{Event Date}!

        [Special Variables Examples]
        /me sets a mental reminder that the due date is {NumberOfWeeksFromToday}.
        /me fills out the report with the date {TodaysDate}.
        /me wishes he had {RandomNumber} pieces of candy.
        /me notes the time of the event as {UTCDateTime} UTC.
        /me The total cost is $3502253  {FormatNumbers} 
        /me The total cost is $253.69  {RoundNumbers} 
        /me writes down the number {Slider: <1-100>}.
        /me writes down the number {Slider: <0.1-100>} with decimals.

        [TV Links]
        {Comment=Arcadius Commercial} https://www.youtube.com/watch?v=Dt3riT2cH5U {SendInstantly} {SkipChatOpen}
        {Comment=Fix it Up} https://www.youtube.com/watch?v=sAhkXc7aWQc {SendInstantly} {SkipChatOpen}
        
        [Other Examples]
        My callsign is {Example Callsign Variable}.
        My favorite fruit is a {List: First Fruit: Apple, Orange, Peach} and second favorite is {Slider: Second Fruit: Grape, Strawberry, Banana}.
        {Number 1} percent of {Number 2} is {{ {Number 1} `%` {Number 2} }}. {FormatNumbers}
        /createbolo {UTCDateTime} | {DoNotEnter} {SendInstantly}
        /AddPropertyPermission {Person} {List: AccessProperty, BuildProperty, ManageProperty, AccessVending} {SendInstantly}
        /RemovePropertyPermission {Person} {List: AccessProperty, BuildProperty, ManageProperty, AccessVending} {SendInstantly}

        [Default Variable Values]
        {Example Callsign Variable} = 3-K-1

        [Presets]
        Preset Example 1;RandomFrom: [Medical Kit Examples]; /me puts the {Medical Item} back into the BLS kit.
        Preset Example 2; /me pulls a flyer out of their right pocket.; /fdo FLYER: ~y~Club Arcadius is the ~r~BEST; /me thinks about the party on {TodaysDate}.
        Math Example 1; If you have {Sheep Number 1} sheep and buy {Sheep Number 2} more sheep, and a wolf kills half of your sheep, you will have {{ {Sheep Number 1} + {Sheep Number 2} / 2 }} sheep left.
        Math Example 2; {Percent Amount}`%` of {Number 1} would be ${{ {Percent Amount} `%` {Number 1} = {MathOutput1} }}. {FormatNumbers}; So you owe me ${MathOutput1}. {FormatNumbers}
        List Example 1; My favorite night club in Los Santos is {List: Club Arcadius, Plagues Tomb, The Lust Drop, The Pink Sandwich}.; I go there {RandomNumber} times a month. 
        List Example 2; {List: Arcadius Business Center, LSPD, Downtown Cab Co} gets a discount of {List: Arcadius Business Center (75), LSPD (50), Downtown Cab Co (25)}`%.
        Slider Example 1; We need to pick up {Slider: Apples, Grapes, Oranges} from the market.; Make sure to pick up {Slider: <0-100>} of them.
        List with Math Example 1;  /me writes up an invoice for {List: car mods, a repair} and adds a discount of {List: LSC (100), LSPD (50), Downtown Cab Co (75)}`%`.; /mechoffer {List: car mods (1), a repair (0)} {{ {Mod Cost} * 0.2 * {List: LSC (0), LSPD (0.50), Downtown Cab Co (0.25)} }}
        ), %TxtFile%

        ; Call the GUI toggle function after the file is created
        ToggleRPGui()
        ShowWelcomeMessage()
    }
    else
    {
        ; Check if the file already contains a [Presets] section
        PresetsFound := false
        Loop, Read, %TxtFile%
        {
            if (A_LoopReadLine = "[Presets]") {
                PresetsFound := true
                break
            }
        }

        ; If the [Presets] section is not found, append the example presets after adding a blank line
        if (!PresetsFound) {
            FileAppend, `n`n, %TxtFile%  ; Ensure there are new lines before adding the Presets section
            FileAppend, 
            (LTrim Join`n
            [Presets]
            Preset Example 1; /me tosses their BLS kit onto the ground.; RandomFrom: [Work Tasks Examples]; /me puts the {Medical Item} back into the BLS kit.
            Preset Example 2; /me pulls a flyer out of their right pocket.; /fdo FLYER: ~y~Club Arcadius is the ~r~BEST; /me thinks about the party on {TodaysDate}.
            Math Example 1; If you take {Sheep Number 1} sheep and buy {Sheep Number 2}, and a wolf kills half of your sheep, you will have {{ {Sheep Number 1} + {Sheep Number 2} / 2 }} sheep left.
            Math Example 2; {Percent Amount}`%` of {Number 1} would be ${{ {Percent Amount} `%` {Number 1} = {MathOutput1} }}. {FormatNumbers}; So you owe me ${MathOutput1}. {FormatNumbers}
            List Example; My favorite night club in Los Santos is {List: Club Arcadius, Plagues Tomb, The Lust Drop, The Pink Sandwich}.; I go there {RandomNumber} times a month.
            List and Slider Example; {List: Arcadius Business Center, LSPD , Downtown Cab Co} gets a discount of {Slider: Arcadius Business Center (75), LSPD (50), Downtown Cab Co (25)}`%. 
            List with Math Example;  /me writes up an invoice for {List: car mods, a repair} and adds a discount of {List: LSC (100), LSPD (50), DCC (75)}`%`.; /mechoffer {List: car mods (1), a repair (0)} {{ {Mod Cost} * 0.2 * {List: LSC (0), LSPD (0.50), DCC (0.25)} }}
            ), %TxtFile%
        }
    }

    ; Optional: Call a SanitizeFile function if necessary to clean up the file
    Gosub, SanitizeFile



    LoadDefaultVariableValues()
}

ShowWelcomeMessage() {
    Gui, Welcome:New, +AlwaysOnTop +ToolWindow -Caption +Border
    Gui, Welcome:Margin, 15, 15
    Gui, Welcome:Font, s12 Bold cWhite, Segoe UI
    Gui, Welcome:Color, 202020 ; Dark gray background
    Gui, Add, Text, x0 y10 w350 Center, Welcome to the Roleplaying Menu!
    Gui, Welcome:Font, s10, Segoe UI
    Gui, Add, Text, x0 y60 w350 Center, Press F5 to toggle the menu open or closed.
    Gui, Welcome:Show, xCenter yCenter w350 h100, Welcome
    SetTimer, CloseWelcomeMessage, -5000 ; Close after 5 seconds
}

CloseWelcomeMessage() {
    Gui, Welcome:Destroy
}




; If the typing is currently active, and No GUI is open from this script, these buttons can be pressed to stop the active typing and any consecutive lines after them. 
#If (isTypingActive = 1 && !IsScriptGuiActive())

; Stops typing if the user hits any F hotkey except the pause F11 hotkey or F5 key. IF YOU CHANGE THEM ABOVE, ADD THE PREVIOUS HOTKEYS HERE if you want them to stop active typing if pressed. 
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

Backspace::
    stopSending := 1
    StopTypingFunction()
return

LWin::
    stopSending := 1
    StopTypingFunction()
    return

#If


; Function to load RP lines into TreeView with optional exclusion of "Presets" and "Default Variable Values" categories
LoadRPLinesToTreeView(includeChildren := true, excludePresets := false, excludeDefaultVars := false) {
    ; Path to the RP lines file
    TxtFile := A_ScriptDir "\" vRPLines

    ; Read the entire content of the text file
    FileRead, content, %TxtFile%

    ; Check if [Default Variable Values] section exists; if not, add it with a default example variable
    if !RegExMatch(content, "\[Default Variable Values\]") {
        content := content "`n`n[Default Variable Values]`n{Example Callsign Variable} = 3-K-1`n"
        FileDelete, %TxtFile%  ; Delete the old file
        FileAppend, %content%, %TxtFile%  ; Write the updated content back to the file
    }

    ; Clear the TreeView control before loading
    GuiControl, , RPLineTreeView

    currentCategory := ""
    inExcludedSection := false  ; Flag to track if we are currently parsing an excluded section

    ; Parse each line to find categories and, optionally, children
    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        
        ; Skip empty lines and comments
        if (line = "" || SubStr(line, 1, 1) = ";")
            continue

        ; If the line is a category, process it
        if (SubStr(line, 1, 1) = "[") {
            currentCategory := SubStr(line, 2, StrLen(line) - 2)  ; Capture category name
            
            ; Update inExcludedSection based on the current category and exclusion flags
            if (excludePresets && currentCategory = "Presets") {
                inExcludedSection := true
            } else if (excludeDefaultVars && currentCategory = "Default Variable Values") {
                inExcludedSection := true
            } else {
                inExcludedSection := false
            }
            
            ; Skip the excluded categories entirely if exclusion is enabled for them
            if (inExcludedSection)
                continue

            ; Add the category as a parent item to the TreeView
            parentItem := TV_Add(currentCategory, "")
            continue
        }

        ; Skip processing for lines within excluded sections
        if (inExcludedSection)
            continue

        ; Add RP lines as children under their categories if `includeChildren` is true
        if (includeChildren) {
            TV_Add(line, parentItem)
        }
    }
}






LoadPresetsToTreeView:
    ; Path to the RP lines file
    TxtFile := A_ScriptDir "\" vRPLines

    ; Read the entire content of the text file
    FileRead, content, %TxtFile%

    GuiControl, , PresetTreeView,  ; Clear the TreeView before loading

    ; Extract and parse the relevant section content, in this case, [Presets]
    position := InStr(content, "[Presets]")
    if (position = 0)
        return  ; No presets section found

    ; Parse each line under the [Presets] section
    presetsContent := SubStr(content, position)
    sectionEnd := InStr(presetsContent, "`n[", false, 1)
    if (sectionEnd)
        presetsContent := SubStr(presetsContent, 1, sectionEnd - 1)

    Loop, Parse, presetsContent, `n, `r
    {
        line := Trim(A_LoopField)
        if (line = "" || line = "[Presets]" || SubStr(line, 1, 1) = ";")
            continue  ; Skip empty lines and comments

        SplitPos := InStr(line, ";")
        if (SplitPos > 0) {
            presetName := SubStr(line, 1, SplitPos - 1)
            details := SubStr(line, SplitPos + 1)
            parentItem := TV_Add(presetName, "")  ; Add preset name as a parent item
            Loop, Parse, details, `;
            {
                numberedLine := A_Index . ". " . Trim(A_LoopField)  ; Add numbering to each RP line
                TV_Add(numberedLine, parentItem)
            }
        }
    }
return

; Function to load default variable values from RPLines.txt and set them into variableValues
LoadDefaultVariableValues() {
    global variableValues
    TxtFile := A_ScriptDir "\" vRPLines

    ; Read the entire content of the text file
    FileRead, content, %TxtFile%

    inDefaultVarsSection := false  ; Track if we are in the [Default Variable Values] section

    ; Parse each line to find default variable values
    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)

        ; Skip empty lines and comments
        if (line = "" || SubStr(line, 1, 1) = ";")
            continue

        ; Check if we've reached the [Default Variable Values] section
        if (SubStr(line, 1, 1) = "[") {
            currentSection := SubStr(line, 2, StrLen(line) - 2)
            inDefaultVarsSection := (currentSection = "Default Variable Values")
            continue
        }

        ; Only process lines if we are in the [Default Variable Values] section
        if (inDefaultVarsSection) {
            ; Assume each line in this section is in "variable=value" format
            if (InStr(line, "=")) {
                StringSplit, parts, line, =
                variableName := Trim(parts1)
                variableValue := Trim(parts2)

                ; Remove curly brackets from variable name and variable value if present
                variableName := RegExReplace(variableName, "^\{|\}$")
                variableValue := RegExReplace(variableValue, "^\{|\}$")

                ; Set the variable and its value in variableValues
                variableValues[variableName] := variableValue
            }
        }
    }
}



; Toggles the Preset GUI
TogglePresetGUI() {
    global activeGuiName ; Global variable to track active GUI
    global isTypingActive ; Global flag to indicate typing activity

    ; Store the current value of activeGuiName
    storedGuiName := activeGuiName

    stopSending := 1
    StopTypingFunction()
    
    ; Check if a GUI with the title "Preset Menu" is open
    if WinExist("Preset Menu") {
        ; If it is open, close it
        WinClose, Preset Menu
    } 
    else if (activeGuiName = "Presets") {
        ; If the Presets GUI is already active, close it
        Gui, Presets:Destroy
    } else {
        ; If the Presets GUI is not active, execute the PresetRP subroutine
        Gosub OpenPresetRP
    }

    ; Restore the original value of activeGuiName
    activeGuiName := storedGuiName

    Gosub, VariableCancel
Return
}

; Toggles the main RP GUI, or compact GUI
ToggleRPGui() {

    HideFloatingGuisIfUnticked()

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

; Function to bring unticked floating GUIs to the front
BringFloatingGuisToFront() {
    global floatingGuis, floatingGuiCheckboxStates, floatingGuiPositions

    ; Loop through each floating GUI and bring to front if "Keep Open" is not checked
    for guiName, presetName in floatingGuis {
        keepOpenState := (floatingGuiCheckboxStates.HasKey(guiName)) ? floatingGuiCheckboxStates[guiName] : 1
        if (!keepOpenState) {
            ; Show the GUI at the stored position if available
            if (floatingGuiPositions.HasKey(guiName)) {
                X := floatingGuiPositions[guiName]["X"]
                Y := floatingGuiPositions[guiName]["Y"]
                Gui, %guiName%:Show, AutoSize x%X% y%Y%, Floating Preset - %presetName%
            } else {
                Gui, %guiName%:Show, AutoSize, Floating Preset - %presetName%
            }
        }
    }
}

; Function to hide floating GUIs if "Keep Open" is unticked
HideFloatingGuisIfUnticked() {
    global floatingGuis, floatingGuiCheckboxStates

    ; Loop through each floating GUI and hide it if "Keep Open" is not checked
    for guiName, presetName in floatingGuis {
        keepOpenState := (floatingGuiCheckboxStates.HasKey(guiName)) ? floatingGuiCheckboxStates[guiName] : 1
        if (!keepOpenState) {
            ; Hide the GUI
            Gui, %guiName%:Hide
        }
    }
}




; Toggles between Full size and Compact size menus.
ToggleSizeFunction() {
    global isTypingActive ; Global flag to indicate typing activity
    stopSending := 1
    StopTypingFunction()

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
    global floatingGuis
    hWnd := WinActive("A") ; Get the handle of the active window
    WinGet, pid, PID, % "ahk_id " hWnd ; Get the process ID of the active window

    ; Return true if thread ID of the active window matches current thread, and process ID matches current process
    if (DllCall("GetWindowThreadProcessId", "Ptr", hWnd, "UInt*", 0) = DllCall("GetCurrentThreadId") && pid = DllCall("GetCurrentProcessId")) {
        ; Check if the active window is either a Test Mode GUI or a floating button GUI
        WinGetTitle, activeTitle, ahk_id %hWnd%

        ; Remove "Floating Preset - ", then replace spaces with underscores to match floatingGuis key format
        sanitizedTitle := "FloatingPreset_" . StrReplace(RegExReplace(activeTitle, "^Floating Preset - "), " ", "_")

        
        ; Check if this sanitized title matches any in floatingGuis
        if (activeTitle = "Test Mode Window" || floatingGuis.HasKey(sanitizedTitle)) {
            return false ; Ignore Test Mode and floating GUIs
        }
        

        return true
    }
    return false
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
    if (closeOnSelectState != 0) {
        Gui, FullSizeGui:New, +OwnDialogs -Caption +AlwaysOnTop
    } else {
        Gui, FullSizeGui:New, +OwnDialogs -Caption
    }

    ; Set up basic GUI properties
    Gui, FullSizeGui:Font, s9, Segoe UI Semibold
    Gui, FullSizeGui:Color, C0C0C0
    OnMessage(0x0232, "WM_EXITSIZEMOVE")
    OnMessage(0x84, "WM_NCHITTEST")
    OnMessage(0x200, "WM_MOUSEMOVE")
    OnMessage(0x20, "WM_SETCURSOR")

    ; Add GUI title and control buttons
    Gui, Add, Text, x0 y3 w692 h30 vTitleBar cGray +Center, Roleplay Menu
    Gui, Add, Button, x652 y5 w35 h15 gGuiClose , X 
    Gui, Add, Button, x75 y20 w82 h20 gRandomRP, Random RP
    Gui, Add, Button, x10 y20 w60 h20 gTreeEditRPLines, Edit RP
    Gui, Add, Button, x10 y50 w60 h20 gOpenPresetRP, Presets
    Gui, Add, Button, x75 y50 w82 h20 gOpenHelpGUI, Help Menu
    Gui, Add, CheckBox, x166 y56 vTestModeCheckbox gToggleTestMode Checked%TestModeEnabled%, Testing Mode
    Gui, FullSizeGui:Font, s9, Segoe UI Semibold
    Gui, Add, Slider, x588 y22 w100 h20 Thick19 vTransparencySlider Range50-255 gAdjustTransparency Invert
    GuiControl, , TransparencySlider, %GUITransparency%
    Gui, Add, CheckBox, x580 y56 vCheckboxVar2 gToggleCompactMode Checked%tickboxStateCompact%, Compact Mode
    Gui, Add, CheckBox, x494 y56 vCloseOnSelectVar gToggleCloseOnSelect Checked%closeOnSelectState%, Keep Open
    Gui, Add, Text, x522 y26, Transparent:
    Gui, Add, Text, x166 y22, Search RP lines or Category:
    Gui, Add, Edit, x320 y20 w172 h20 vQuery gSearchAll +WantReturn

    ; Add TreeView for displaying RP Sections and RP Lines
    Gui, Add, TreeView, x10 y80 w%listViewMainW% h%listViewMainH% vRPLines gSelectRPFromTreeView BackgroundE0FFFC,

    ; Custom progress bar for resizing the GUI
    Gui, Add, Progress, x%resizeBoxX% y%resizeBoxMainY% w692 h4 Background000000 Disabled vResizeBox,
    Gui, Add, Text, xp yp wp hp BackgroundTrans 0x201 vHandleDragOrResizeText gHandleDragOrResizeFullSizeGui,

    ; Conditionally show or hide elements based on compact mode
    if (!tickboxState) {
        GuiControl, Hide, AdditionalInput
    }

    ; Add an outline around the GUI
    DRAW_OUTLINEFullSizeGui("FullSizeGui", 0, 0, 692, 425)

    ; Update the always-on-top state and show the GUI
    Gosub, UpdateAlwaysOnTopState
    if (fullSizeGuiX = 0 and fullSizeGuiY = 0) {
        SetGuiTransparency("FullSizeGui", GUITransparency)
        Gui, Show, w692 h425, RP Menu
        Gosub, StoreFullSizeGuiValues
    } else {
        fullSizeGuiW := (fullSizeGuiW = 0) ? 692 : fullSizeGuiW
        fullSizeGuiH := (fullSizeGuiH = 0) ? 425 : fullSizeGuiH
        SetGuiTransparency("FullSizeGui", GUITransparency)
        Gui, Show, x%fullSizeGuiX% y%fullSizeGuiY% w%fullSizeGuiW% h%fullSizeGuiH%, RP Menu
    }

    ; Set the active GUI for other functions to use
    SetActiveGuiName("FullSizeGui")

    ; Load RP lines into the TreeView with children
    LoadRPLinesToTreeView(true, true, true)

    BringFloatingGuisToFront()
    
    ; Set initial transparency and focus on the search bar
    SetGuiTransparency("FullSizeGui", GUITransparency)
    GuiControl, Focus, Query
    Hotkey, IfWinActive, RP Menu
    Hotkey, Enter, ButtonOK, UseErrorLevel
return



; Function to handle the selection of an RP line from the TreeView, either by pressing Enter or double-clicking
SelectRPFromTreeView(eventType := "") {
    if (eventType != "Enter" && A_GuiEvent != "DoubleClick") {
        return
    }

    selectedID := TV_GetSelection()
    if (!selectedID) ; No item selected
        return

    ; Check if the user double-clicked on the expand/collapse arrow
    if (A_GuiEvent = "DoubleClick" && TV_GetChild(selectedID)) {
        return  ; Exit if the selected item is a category with children
    }

    ; Get the text of the selected item
    TV_GetText(selectedText, selectedID)
    parentID := TV_GetParent(selectedID)
    
    if (parentID = 0) {
        ; The selected item is a category (parent)
        categoryName := selectedText
        ; Get a random RP line from the selected category
        RPToSend := GetRandomRPLineFromCategory(categoryName)
        if (RPToSend = "") {
            MsgBox, No RP lines found in category '%categoryName%'.
            return
        }
        sectionNameForRP := categoryName
    } else {
        ; The selected item is an RP line (child)
        RPToSend := selectedText
        TV_GetText(sectionNameForRP, parentID)
    }

    ; Replace variables in the RP text
    RPToSend := ReplaceVariables(RPToSend, sectionNameForRP)
    RPToSend := ReplaceDateTime(RPToSend)
    if (RPToSend = "")
        return

    Gui, FullSizeGui:Submit, NoHide
    Gosub, CheckTickBoxAndClose

    ; Use the same process as in RunPreset to handle Test GUI mode
    if (TestModeEnabled) {
        InitTestGui()
    }

    RPToSend := ProcessSpecialCommands(RPToSend)
    SendMessagewithDelayFunction(RPToSend)
    if (TestModeEnabled) {
        UpdateTestGui(RPToSend)
    }
}


; Function to get a random RP line from a specific category
GetRandomRPLineFromCategory(categoryName) {
    ; Path to the RP lines file
    TxtFile := A_ScriptDir "\" vRPLines
    
    ; Read the entire content of the text file
    FileRead, txtData, %TxtFile%
    
    ; Find the start and end positions of the category in the text
    sectionStart := InStr(txtData, "[" . categoryName . "]") + StrLen(categoryName) + 2
    if (sectionStart = 0) {
        return ""  ; Category not found
    }
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

    ; Select a random line if available and return it
    if (cleanedLines.MaxIndex() > 0) {
        Random, rand, 1, cleanedLines.MaxIndex()
        return cleanedLines[rand]
    } else {
        return ""  ; No RP lines found in category
    }
}



; Handler for the Test Mode toggle
ToggleTestMode:
    Gui, Submit, NoHide
    TestModeEnabled := !TestModeEnabled
    
return


; Handler for the Help button
OpenHelpGUI:
    Gui, HelpGUI:New, +OwnDialogs
    Gui, Font, s11, Arial bold

    Gui, Add, TreeView, vHelpTreeView w250 h500 gHelpTreeViewSelect    
    Gui, Add, Edit, x270 y7 w720 h498 vHelpTextField ReadOnly
    ; Add the Done button
    Gui, Add, Button, x530 y510 w200 h24 gDoneHelp, Done

    ; Define the help sections and their content
    HelpSections := Object()

    ; Define the order of help sections
    HelpSectionOrder := ["General", "Hotkeys", "Random RP", "Presets", "Custom Variables", "Special Variables", "Math Variables", "Emergency Stop", "Support"]


    ; Top-Level Sections
    HelpSections["General"] := Object()
    HelpSections["General"]["_content"] := "Welcome to the Roleplaying Menu! This tool helps you manage your RP lines and commands.`n`n"
        . "**Key Features**`n`n"
        . "1. **Manage Roleplay Content**`n"
        . "   - Add, Edit, or Delete RP Categories and Lines.`n"
        . "   - Quickly Search through your collection.`n`n"
        . "2. **Random Playback**`n"
        . "   - Play random lines from Categories or in Presets.`n`n"
        . "3. **Presets**`n"
        . "   - Organize RP lines into Presets for sequential playback.`n`n"
        . "4. **Testing Mode**`n"
        . "   - Preview RP lines inside the menu before sending them.`n`n"
        . "5. **Custom Replacement Variables**`n"
        . "   - Dynamicac placeholders in your RP lines using variables enclosed in curly brackets `{}`.`n"
        . "   - Fill in values when executing the line, or set default values to save time.`n"
        . "**Getting Started**`n`n"
        . "Use the Edit RP button to add or edit lines. Double-click a line or press Enter to send it, or press Enter on a category to send a random line from it."

    
    HelpSections["Hotkeys"] := Object()
    HelpSections["Hotkeys"]["_content"] := "This section provides an overview of the hotkeys available for the Roleplaying Menu. Below are the default hotkeys and their functions:`n`n"
        . "**Hotkey Functions**`n`n"
        . "- **[F5]**: Toggle Open/Closed the Roleplaying Menu to manage and use RP lines.`n`n"
        . "- **[SHIFT + F5]**: Toggle between full size and compact menus.`n`n"
        . "- **[CTRL + F5]**: Open the Random RP Menu directly.`n`n"
        . "- **[ALT + F5]**: Open the Preset Menu directly.`n`n"
        . "- **[F11]**: Pause the script and current typing (press again to resume).`n`n"
        . "- **[F12]**: Stop and terminate the script immediately."
    
    HelpSections["Random RP"] := Object()
    HelpSections["Random RP"]["_content"] := "The Random RP feature brings variety to your Roleplaying sessions by running random lines from selected categories.`n`n"
        . "**How to Use the Random RP Menu**`n`n"
        . "1. **Open the Random RP Menu**: Start by selecting the Random RP option from the main menu.`n"
        . "2. **Select Categories**: Choose one or more categories containing your RP lines.`n"
        . "3. **Run Random Lines**: Click submit to pull random lines from the selected categories and run them in sequence.`n`n"
        . "**Example Usage**`n`n"
        . "- **Single Category**: Selecting 'Greetings' will run one random line from that category.`n"
        . "- **Multiple Categories**: Selecting 'Greetings' and 'Farewells' will run a random line from each category in order.`n`n"    

    HelpSections["Presets"] := Object()
    HelpSections["Presets"]["_content"] := "The Presets feature lets you create and save sequences of RP lines, including specific lines or random lines from categories.`n`n"
        . "**How to Use Presets**`n`n"
        . "1. **Create a Preset**: Open the Preset Menu, click 'Create New Preset' and name it.`n"
        . "2. **Add RP Lines**: Add specific lines from your library or select a Category to include a random line from that Category.`n"
        . "3. **Run a Preset**: Select a preset in the Preset Menu and click 'Run Preset' to play the lines in sequence.`n`n"
        . "**Floating Preset Buttons**`n`n"
        . "Create a floating button for any preset by selecting it in the Preset Menu and clicking 'Floating Preset Button'. Drag it anywhere for quick access!"
    
    HelpSections["Custom Variables"] := Object()
    HelpSections["Custom Variables"]["_content"] := "Custom Variables let you create dynamic RP lines by adding placeholders in curly brackets `{}`. When the line runs, you will be prompted to fill in the values.`n`n"
        . "**How to Use Custom Variables**`n`n"
        . "1. **Define Variables**: Add placeholders like `{Item}` or `{Location}` in your RP lines.`n"
        . "2. **Run RP Lines**: When you run a line with variables, a pop-up will prompt you to enter values, which are then replaced in the final line.`n"
        . "3. **Use Multiple Variables**: Include multiple placeholders in a single line, and fill them all at once in the pop-up.`n`n"
        . "**Default Values**`n`n"
        . "- Set default values in the Edit RP section to auto-fill variables the next time you use them.`n`n"
        . "**Examples**`n`n"
        . "- **Single Variable**: `/me pulls out a {BLS Kit Item} from the kit.` Enter 'bandage' to get `/me pulls out a bandage from the kit.` `n`n"
        . "- **Multiple Variables**: `/me arrives at {Location}, looking for {Item}.` Enter 'the park' and 'a bench' to get `/me arrives at the park, looking for a bench.`"
        
    ; Special Variables Section
    HelpSections["Special Variables"] := Object()
    HelpSections["Special Variables"]["_content"] := "Special Variables add dynamic functionality to your RP lines, allowing you to insert specific information, perform calculations, or automate tasks.`n`n"
        . "- **Insert Dynamic Values**: Automatically include details like the current date or random numbers.`n"
        . "- **Automate Actions**: Control how lines are sent, such as skipping chat opening or sending lines instantly.`n"
        . "- **Perform Calculations**: Use variables to round or format numbers, or calculate future dates.`n"
        . "- **Interactive Options**: Create dropdowns, sliders, or repeat lines a specified number of times.`n`n"
        . "Each Special Variable has its own submenu with detailed instructions and examples."
    
    ; Add each special variable as a sub-section
    HelpSections["Special Variables"]["TodaysDate"] := "Inserts today's current date automatically.`n`n"
        . "- **Example**: `/me fills out the report with the date {TodaysDate}.` `n`n"
        . "- **Result**: `/me fills out the report with the date 2024-08-03.` `n`n"

    HelpSections["Special Variables"]["UTCDateTime"] := "Inserts the current date and time in UTC automatically.`n`n"
        . "- **Example**: `/me notes the time of the event as {UTCDateTime} UTC.` `n`n"
        . "- **Result**: `/me notes the time of the event as 2024-08-03 UTC.` `n`n"

    HelpSections["Special Variables"]["NumberOfWeeksFromToday"] := "Calculates the date X weeks from today based on the input provided.`n`n"
        . "- **Example**: `/me schedules the follow-up meeting for {NumberOfWeeksFromToday}.` `n`n"
        . "- **Result**: `/me schedules the follow-up meeting for August 9th, 2024.` `n`n"

    HelpSections["Special Variables"]["RandomNumber"] := "Generates a random number between 1-1000.`n`n"
        . "- **Example**: `/me rolls a dice and gets a {RandomNumber}.` `n`n"
        . "- **Result**: `/me rolls a dice and gets a 42.` `n`n"

    HelpSections["Special Variables"]["DoNotEnter"] := "Prevents the script from pressing the Enter key at the end of the RP line automatically.`n`n"

    HelpSections["Special Variables"]["SendInstantly"] := "Sends the RP line instantly, bypassing slow typing mode.`n`n"

    HelpSections["Special Variables"]["SkipChatOpen"] := "Skips opening the chat before sending the text. Useful for other UI's.`n`n"
        . "- **Example**: `{SkipChatOpen} https://www.youtube.com/watch?v=Dt3riT2cH5U {SkipChatOpen}` `n`n"
        . "- **Result**: `https://www.youtube.com/watch?v=Dt3riT2cH5U` `n`n"

    HelpSections["Special Variables"]["Comment="] := "Adds comments or identifiers to lines that will be ignored by the script.`n`n"
        . "- **Example**: `{Comment=Arcadius Commercial} {SkipChatOpen} https://www.youtube.com/watch?v=Dt3riT2cH5U` `n`n"
        . "- **Result**: `https://www.youtube.com/watch?v=Dt3riT2cH5U` `n`n"

    HelpSections["Special Variables"]["FormatNumbers"] := "Adds commas as thousand separators to numbers in the line.`n`n"
        . "- **Example**: `The total cost is $3502253 {FormatNumbers}` `n`n"
        . "- **Result**: `The total cost is $3,502,253` `n`n"

    HelpSections["Special Variables"]["RoundNumbers"] := "Rounds all numbers in the line to the nearest whole number.`n`n"
        . "- **Example**: `The total cost is $253.69 {RoundNumbers}` `n`n"
        . "- **Result**: `The total cost is $254` `n`n"

    HelpSections["Special Variables"]["Loop"] := "Repeats the line a specified number of times based on user input.`n`n"
        . "- **Example**: `Burger. {Loop} {DoNotEnter}` `n`n"
        . "- **User Input**: 5`n"
        . "- **Result**: `Burger. Burger. Burger. Burger. Burger.` `n`n"
        . "- **Note**: Combine `{Loop}` with other variables like `{DoNotEnter}` for customized behavior.`n`n"

    HelpSections["Special Variables"]["List"] := "Creates a dropdown list of options with optional labels, ranges, or outputs in parentheses.`n`n"
        . "- **Example**: `/me chooses an option from the list: {List: LSC, LSPD, Bayview}.` `n`n"
        . "- **Result**: `/me chooses an option from the list: LSC.` `n`n"
        . "- **Example**: `/me selects a number: {List: Numbers: <1-10>}.` `n`n"
        . "- **Result**: `/me selects a number: 5.` (Dropdown labeled 'Numbers' with a range of 1 to 10 is created.) `n`n"
        . "- **Note**: Use `<start-end>` syntax for ranges (e.g., `<1-10>`). Add optional labels with a colon (e.g., `{List: Choices:}`). Matching variables combine into a single dropdown.`n`n"

    HelpSections["Special Variables"]["Slider"] := "Creates a slider for selecting values, with optional labels, ranges, or outputs in parentheses.`n`n"
        . "- **Example**: `/me adjusts the slider: {Slider: Low, Medium, High}.` `n`n"
        . "- **Result**: `/me adjusts the slider: Medium.` (Slider with three positions is created.) `n`n"
        . "- **Example**: `/me selects a speed: {Slider: Speed: <1-100>}.` `n`n"
        . "- **Result**: `/me selects a speed: 50.` (Slider labeled 'Speed' with a range of 1 to 100 is created.) `n`n"
        . "- **Note**: Use `<start-end>` syntax for ranges (e.g., `<1-100>`). Add labels with a colon (e.g., `{Slider: Speed:}`). Matching variables combine into a single slider.`n`n"


    ; Math Variables Section
    HelpSections["Math Variables"] := Object()
    HelpSections["Math Variables"]["_content"] := "Math Variables allow you to perform calculations directly within your RP lines, enabling dynamic and precise outputs.`n`n"
        . "**Supported Operations**`n`n"
        . "- **Addition (`+`)**: Add two or more values.`n"
        . "- **Subtraction (`-`)**: Subtract one value from another.`n"
        . "- **Multiplication (`*` or `x`)**: Multiply values together.`n"
        . "- **Division (`/`)**: Divide one value by another.`n"
        . "- **Percentage (`%`)**: Calculate percentages.`n"
        . "- **Average (`@`)**: Find the average of multiple values.`n`n"
        . "**How to Use Math Variables**`n`n"
        . "To use math operations, enclose your expressions in double curly brackets {{ }}. For example:`n"
        . "- `{{ {Number1} + {Number2} }}` will calculate the sum of `Number1` and `Number2.` `n"
. "- `{{ {Number1} * {Number2} + {Number3}}}}` will multiply `Number1` and `Number2, and then add `Number3` `n`n"
        . "**Usage Tips**`n`n"
        . "- Combine multiple operations in a single line for complex calculations.`n"
        . "- Save results to variables like `{MathOutput1}` for reuse in other RP lines.`n"
        . "- Operations are processed from left to right in the order they appear."
    
    

    ; Add each math variable as a sub-section
    HelpSections["Math Variables"]["Addition"] := "Perform addition to calculate the sum of two or more values.`n`n"
        . "- **Example**: `{{ {Number1} + {Number2} }}` `n`n"
        . "- **Result**: If `Number1 = 6` and `Number2 = 9`, the result will be `15.` `n`n"
        . "- **Calculation**: `6 + 9` = `15.` `n`n"

    HelpSections["Math Variables"]["Subtraction"] := "Perform subtraction to calculate the difference between two values.`n`n"
        . "- **Example**: `{{ {Number1} - {Number2} }}` `n`n"
        . "- **Result**: If `Number1 = 10` and `Number2 = 4`, the result will be `6.` `n`n"
        . "- **Calculation**: `10 - 4` = `6.` `n`n"

    HelpSections["Math Variables"]["Multiply"] := "Perform multiplication to calculate the product of two or more values.`n`n"
        . "- **Example**: `{{ {Number1} * {Number2} }}` `n`n"
        . "- **Result**: If `Number1 = 6` and `Number2 = 7`, the result will be `42.` `n`n"
        . "- **Calculation**: `6 * 7` = `42.` `n`n"

    HelpSections["Math Variables"]["Divide"] := "Perform division to calculate the quotient of two values.`n`n"
        . "- **Example**: `{{ {Number1} / {Number2} }}` `n`n"
        . "- **Result**: If `Number1 = 20` and `Number2 = 4`, the result will be `5.` `n`n"
        . "- **Calculation**: `20 / 4` = `5.` `n`n"

    HelpSections["Math Variables"]["Percent"] := "Calculate a percentage of a value.`n`n"
        . "- **Example**: `{{ {Number1} % {Number2} }}` `n`n"
        . "- **Result**: If `Number1 = 25` and `Number2 = 200`, the result will be `50.` `n`n"
        . "- **Calculation**: `25% of 200` = `50.` `n`n"

    HelpSections["Math Variables"]["Average"] := "Calculate the average of multiple values.`n`n"
        . "- **Example**: `{{ {Number1} @ {Number2} @ {Number3} }}` `n`n"
        . "- **Result**: If `Number1 = 4`, `Number2 = 8`, and `Number3 = 12`, the average will be `8.` `n`n"
        . "- **Calculation**: `(4 + 8 + 12) / 3` = `24 / 3` = `8.` `n`n"

    HelpSections["Math Variables"]["Combined Math Output"] := "Store and reuse the results of math operations in your script.`n`n"
        . "- **Saving a Result**:`n"
        . "  - Input: `{{ {Number1} + {Number2} / 2 + {Number3} = {MathOutput3} }}` `n`n"
        . "  - Explanation: Adds `{Number1}` and `{Number2}`, divides by 2, adds `{Number3}`, and saves the result to `{MathOutput3}`.`n`n"
        . "- **Combining Saved Outputs**:`n"
        . "  - Input: `{{ {MathOutput1} + {MathOutput2} }}` `n`n"
        . "  - Explanation: Adds the values stored in `{MathOutput1}` and `{MathOutput2}`.`n`n"
        . "**Tip**: Use `{MathOutput}` or `{MathOutputX}` for organized result tracking."


    HelpSections["Emergency Stop"] := Object()
    HelpSections["Emergency Stop"]["_content"] := "The Emergency Stop feature allows you to quickly halt ongoing typing or prevent future lines from being executed. This is useful in emergencies, to correct mistakes, or to pause the script. Below are the methods to stop typing:`n`n"
        . "**Ways to Stop Typing**`n`n"
        . "1. **Function Keys (F1 to F10)**: Press any of these keys to immediately stop all ongoing typing and future lines.`n`n"
        . "2. **Windows Key**: Press the Windows key to halt typing and prevent further lines.`n`n"
        . "3. **Alt Key**: Use the Alt key to stop typing and block additional lines.`n`n"
        . "4. **Tab Key**: Press the Tab key to stop typing and prevent further actions.`n`n"
        . "5. **Backspace Key**: Press Backspace to halt the current typing operation and any queued lines.`n`n"
        . "6. **Escape Key**: Use the Escape key to immediately interrupt ongoing typing and stop future lines.`n`n"
        . "7. **Enter Key**: Press Enter to stop typing but send the text currently typed before stopping.`n`n"
        . "**Note**: These methods ensure you maintain full control over the script, providing quick and effective ways to intervene if necessary."
    

    HelpSections["Support"] := Object()
    HelpSections["Support"]["_content"] := "If you need assistance or would like to contribute to future updates:`n`n"
        . "**Getting Help**`n`n"
        . "1. **GitHub Repository**`n"
        . "   - Visit the official GitHub repository for the Roleplaying Menu: `n"
        . "     https://github.com/Bassna/Roleplaying-Menu`n"
        . "   - You can explore updates, submit bug reports, and give feedback.`n`n"
        . "2. **Report Issues**`n"
        . "   - Found a bug or issue? Report it on GitHub Issues: `n"
        . "     https://github.com/Bassna/Roleplaying-Menu/issues`n"
        . "   - Your feedback helps fix problems and improve the program.`n`n"
        . "**Support**`n`n"
        . "1. **GitHub**`n"
        . "   - If you find the Roleplaying Menu helpful and want to support its development: `n"
        . "     https://github.com/sponsors/Bassna`n"

    ; Specify the order of math variable children
    HelpSections["Math Variables"]["_order"] := ["Addition", "Subtraction", "Multiply", "Divide", "Percent", "Average", "Combined Math Output"]

    ; Initialize the HelpContent Map
    global HelpContent := Object()

    ; Function to build the TreeView recursively
    BuildTreeView(Sections, ParentID := 0) {
        global HelpContent
        for key, value in (Sections.HasKey("_order") ? Sections["_order"] : Sections) {
            ; Handle ordering properly
            if Sections.HasKey("_order")
                name := value  ; Use ordered name
            else
                name := key  ; Use section key for unordered sections

            ; Skip the _content key
            if (name = "_content")
                continue

            ; Add the current section to the TreeView
            itemID := TV_Add(name, ParentID)

            ; If the section has content, store it
            if (IsObject(Sections[name])) {
                ; Store parent node's content if available
                if (Sections[name].HasKey("_content")) {
                    HelpContent[itemID] := Sections[name]["_content"]
                }
                ; Recursively add children
                BuildTreeView(Sections[name], itemID)
            } else {
                ; Leaf node: Store the content directly
                HelpContent[itemID] := Sections[name]
            }
        }
    }

    ; Use the specified order to build the top-level TreeView
    for _, sectionName in HelpSectionOrder {
        if HelpSections.HasKey(sectionName) {
            ParentID := TV_Add(sectionName)  ; Add the top-level section
            ; Store top-level content in HelpContent map
            if (IsObject(HelpSections[sectionName]) && HelpSections[sectionName].HasKey("_content")) {
                HelpContent[ParentID] := HelpSections[sectionName]["_content"]
            }
            BuildTreeView(HelpSections[sectionName], ParentID)  ; Add child nodes recursively
        }
    }

    Gui, Show, w1000 h540, Help
return

; Handler for TreeView selection
HelpTreeViewSelect:
    selectedID := TV_GetSelection()
    if (selectedID != 0) {
        ; Get the help content associated with the selected item
        helpText := HelpContent[selectedID]
        if (helpText != "")
            GuiControl,, HelpTextField, %helpText%
        else
            GuiControl,, HelpTextField, % "No additional information available."
    }
return

; Handler for Done button
DoneHelp:
    Gui, HelpGUI:Destroy
return







OpenPresetRP:
    global lastEditedPreset  ; Ensure lastEditedPreset is a global variable

    ; Reset the last edited preset so no presets are expanded initially
    lastEditedPreset := ""

    ; Close the PresetRP GUI if it's open
    Gui, Presets:Destroy

    ; Close the main GUI if necessary (CheckTickBoxAndClose should handle this)
    Gosub, CheckTickBoxAndClose

    ; Now open the new PresetRP GUI
    Gosub, PresetRP
return



; Setup the Preset GUI with enhanced TreeView interaction
PresetRP:
    global lastEditedPreset  ; Ensure lastEditedPreset is a global variable

    Gui, Presets:New, +OwnDialogs
    Gui, Add, TreeView, vPresetTreeView w800 h434 gTreeViewSelect
    Gui, Add, Button, x820 y10 w150 h30 gCreatePreset, Create New Preset
    Gui, Add, Button, x820 y50 w150 h30 gOpenAddRPPresetLine, Add RP Line
    Gui, Add, Button, x820 y90 w150 h30 gEditPreset, Edit
    Gui, Add, Button, x820 y130 w150 h30 gMovePresetUp, Move Up
    Gui, Add, Button, x820 y170 w150 h30 gMovePresetDown, Move Down
    Gui, Add, Button, x820 y210 w150 h30 gDeletePresetRPLine, Delete
    Gui, Add, Button, x820 y250 w150 h30 gCreateFloatingPresetButton, Floating Preset Button
    Gui, Add, Button, x820 y372 w150 h30 gRunPreset Default, Run Preset  
    Gui, Add, Button, x820 y412 w150 h30 gCancelPresetRP, Cancel  

    Gosub SanitizeFile
    Gosub LoadPresetsToTreeView

    lastEditedItemID := 0  ; Initialize variable to store the last edited item ID

    ; Find the ID of the last edited preset and expand it
    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        SplitPos := InStr(line, ";")
        if (SplitPos > 0) {
            presetName := SubStr(line, 1, SplitPos - 1)
            if (presetName = lastEditedPreset) {
                parentItem := TV_GetChildByName(vPresetTreeView, presetName)
                if (parentItem) {
                    lastEditedItemID := parentItem
                    break
                }
            }
        }
    }

    Gui, Show, w980 h450, Preset Menu

    ; Expand the last edited preset if it exists
    if (lastEditedItemID) {
        TV_Modify(lastEditedItemID, "Expand")
    }
return



; Function to create a floating button for quick access to a preset
CreateFloatingPresetButton:
    global floatingGuis, floatingGuiHwnds, floatingGuiPositions, floatingGuiCheckboxStates

    selectedID := TV_GetSelection()
    if !selectedID {
        MsgBox, 48, Error, Please select a preset first.
        return
    }

    ; Check if the selected item is a child (RP line) rather than a preset parent
    parentID := TV_GetParent(selectedID)
    if (parentID) {
        MsgBox, 48, Error, Please select a preset, not an RP line.
        return
    }

    ; Get the selected preset name
    TV_GetText(presetName, selectedID)

    ; Sanitize the preset name for use as a GUI name
    sanitizedPresetName := RegExReplace(presetName, "[^A-Za-z0-9]", "_")
    floatingGuiName := "FloatingPreset_" . sanitizedPresetName

    ; Destroy any existing floating GUI with the same name to avoid duplicates
    Gui, %floatingGuiName%:Destroy

    ; Create a new floating GUI for quick access to the preset
    keepOpenState := (floatingGuiCheckboxStates.HasKey(floatingGuiName)) ? floatingGuiCheckboxStates[floatingGuiName] : 1
    alwaysOnTopOption := keepOpenState ? "+AlwaysOnTop" : ""
    Gui, %floatingGuiName%:New, %alwaysOnTopOption% +ToolWindow -Caption +Border +HwndFloatingGuiHwnd
    Gui, Font, s9, Segoe UI Bold
    Gui, Color, C0C0C0

    ; Calculate button width based on text length, setting a minimum width
    buttonWidth := (StrLen(presetName) * 7) + 30  ; Adjust width calculation as needed
    buttonWidth := (buttonWidth < 150) ? 150 : buttonWidth

    ; Add the "Keep Open" checkbox
    Gui, Add, CheckBox, x12 y2 vfloatingCloseOnSelectState gToggleFloatingKeepOpen Checked%keepOpenState%, Keep Open

    Gui, Font, s10, Segoe UI Bold
    Gui, Color, C0C0C0
    
    ; Add the main preset button with dynamic width
    Gui, Add, Button, x10 y23 w%buttonWidth% h30 gRunFloatingPreset vFloatingPresetName, %presetName%

    Gui, Font, s9, Segoe UI Bold
    Gui, Color, C0C0C0

    ; Show the GUI temporarily to capture its final width
    Gui, %floatingGuiName%:Show, AutoSize, Floating Preset - %presetName%

    ; Get the final width of the GUI for positioning the "X" button
    WinGetPos, , , guiWidth,, ahk_id %FloatingGuiHwnd%
    xCloseButton := guiWidth - 27  ; Position for the "X" button to align it at the far-right
    

    ; Add the "X" button at the calculated position
    Gui, %floatingGuiName%:Add, Button, x%xCloseButton% y2 w14 h14 gHandleCloseButton, X

    ; Show the GUI again at the stored position if available
    if floatingGuiPositions.HasKey(floatingGuiName) {
        X := floatingGuiPositions[floatingGuiName]["X"]
        Y := floatingGuiPositions[floatingGuiName]["Y"]
        Gui, %floatingGuiName%:Show, x%X% y%Y%, Floating Preset - %presetName%
    } else {
        Gui, %floatingGuiName%:Show,, Floating Preset - %presetName%
    }

    ; Store the HWND and associate it with the GUI name
    floatingGuiHwnds[FloatingGuiHwnd] := floatingGuiName

    ; Store the preset name in the GUI control variable
    Gui, %floatingGuiName%:Default
    GuiControl, , FloatingPresetName, %presetName%

    ; Add the GUI name and preset name to the floatingGuis associative array
    floatingGuis[floatingGuiName] := presetName
    floatingGuiCheckboxStates[floatingGuiName] := keepOpenState

return





; Toggle "Keep Open" checkbox state for floating GUI and set AlwaysOnTop based on its value
ToggleFloatingKeepOpen:
    floatingGuiName := A_Gui
    GuiControlGet, floatingCloseOnSelectState, , floatingCloseOnSelectState
    floatingGuiCheckboxStates[floatingGuiName] := floatingCloseOnSelectState

    ; Set or remove AlwaysOnTop based on checkbox state
    if (floatingCloseOnSelectState) {
        Gui, %floatingGuiName%:+AlwaysOnTop
    } else {
        Gui, %floatingGuiName%:-AlwaysOnTop
    }
return

; Shared handler for "X" button to close and remove the floating GUI
HandleCloseButton:
    ; Determine which GUI (floating button) called this function
    floatingGuiName := A_Gui
    CloseFloatingPresetButton(floatingGuiName)
return

; Function to close and remove the floating GUI from tracking arrays
CloseFloatingPresetButton(floatingGuiName) {
    global floatingGuis, floatingGuiPositions, floatingGuiCheckboxStates, floatingGuiHwnds

    ; Destroy the specified GUI
    Gui, %floatingGuiName%:Destroy

    ; Remove the GUI from all tracking arrays
    floatingGuis.Delete(floatingGuiName)
    floatingGuiPositions.Delete(floatingGuiName)
    floatingGuiCheckboxStates.Delete(floatingGuiName)

    ; Find and remove the HWND entry associated with this GUI
    for hwnd, name in floatingGuiHwnds {
        if (name = floatingGuiName) {
            floatingGuiHwnds.Delete(hwnd)
            break
        }
    }
}


; Function to run the preset when the floating button is clicked
RunFloatingPreset:
    GuiControlGet, presetName, , FloatingPresetName

    if (presetName != "")
    {
        RunPresetByName(presetName)
    }
    else
    {
        MsgBox, Error: Could not find preset name.
    }
return


; Main function to run a preset based on TreeView selection
RunPreset:
    selectedID := TV_GetSelection()
    if !selectedID
        return

    ; Determine if the selected item has a parent (indicating it’s an RP line in the preset)
    parentID := TV_GetParent(selectedID)
    if (parentID) {
        TV_GetText(presetName, parentID)
    } else {
        TV_GetText(presetName, selectedID)
    }

    ; Run the preset by name
    RunPresetByName(presetName)
return

; Function to run a preset by its name, replicating full RunPreset functionality
RunPresetByName(presetName) {
    global vRPLines, stopSending, TestModeEnabled

    stopSending := 0  ; Reset the stopSending flag
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%

    presetFound := false
    RPLineArray := []
    RPToSendArray := []
    SpecialCommands := []

    ; Parse the file to find and load the specified preset
    Loop, Parse, content, `n, `r
    {
        if (stopSending)
            return

        line := Trim(A_LoopField)
        if (line = "" || SubStr(line, 1, 1) = ";")
            continue

        if (SubStr(line, 1, 1) = "[") {
            if (presetFound)
                break
            presetFound := (SubStr(line, 2, StrLen(line) - 2) = "Presets")
            continue
        }

        if (presetFound && InStr(line, presetName . ";") = 1) {
            presetParts := StrSplit(line, ";")
            RPLineArray := presetParts
            break
        }
    }

    RPLineArray.RemoveAt(1)  ; Remove the preset name from the array
    for index, RPLine in RPLineArray {
        TrimmedRPLine := Trim(RPLine)
        RPToSendArray.Push(TrimmedRPLine)
    }

    ; Collect variables and handle special commands before execution
    for index, RPToSend in RPToSendArray {
        if (stopSending)
            return

        ; Handle "RandomFrom" categories
        if (RPToSend ~= "i)RandomFrom: \[.*\]") {
            category := RegexReplace(RPToSend, ".*RandomFrom: \[(.*)\].*", "$1")
            RPToSend := GetRandomLineFromCategory(category, content)
            RPToSendArray[index] := RPToSend
        }

        ; Handle KeyPress commands
        if (RegExMatch(RPToSend, "KeyPress: \[(.*?)\]")) {
            SpecialCommands.Push({index: index, command: RPToSend})
        } else {
            RPToSend := ReplaceVariables(RPToSend, presetName)
            if (GuiCanceled)  ; Stop if GUI is canceled
                return
            RPToSendArray[index] := RPToSend
        }
    }

    ; Initialize Test GUI if enabled and not canceled
    if (TestModeEnabled && !GuiCanceled) {
        InitTestGui()
    }

    ; Send each RP line and process special commands
    for index, RPToSend in RPToSendArray {
        if (stopSending)
            return

        if (RPToSend != "") {
            RPToSend := ProcessSpecialCommands(RPToSend)
            SendMessagewithDelayFunction(RPToSend)
            if (TestModeEnabled && !GuiCanceled) {
                UpdateTestGui(RPToSend)
            }
        }

        ; Check if there's a special command for this index
        for _, specialCmd in SpecialCommands {
            if (specialCmd.index == index) {
                specialCmd.command := ProcessSpecialCommands(specialCmd.command)
                SendMessagewithDelayFunction(specialCmd.command)
                if (TestModeEnabled && !GuiCanceled) {
                    UpdateTestGui(specialCmd.command)
                }
            }
        }
    }
}



OpenAddRPPresetLine:
    global selectedText, selectedRPLine  ; Ensure that the selected preset name and RP line are available

    ; Get the currently selected item in the tree view
    selectedID := TV_GetSelection()
    
    ; Check if the selected item is an RP line by seeing if it has a parent
    if (TV_GetParent(selectedID) != 0) {
        ; If selected on an RP line, move up to the parent preset
        parentID := TV_GetParent(selectedID)
        TV_GetText(selectedText, parentID)
    } else {
        ; Otherwise, get the preset directly
        TV_GetText(selectedText, selectedID)
    }

    ; Create a new GUI window for typing and adding RP lines to the selected preset
    Gui, InputRPLine:New, +OwnDialogs
    Gui, Font, s10, Segoe UI  ; Set a modern font with a decent size

    ; Add a label with instructions
    Gui, Add, Text, x10 y10 w600, Type your RP Line below. Multiple lines can be added and each line will be added as a Preset line.

    ; Input field for the RP line with multiple line support
    Gui, Add, Edit, vUserRPLine x10 y40 w740 h150 -Wrap HScroll

    ; Add buttons for additional functionality, similar to the Edit Preset GUI
    Gui, Add, Button, x760 y40 w150 h30 gSelectAddPresetRPLine, Choose from Category    ; Opens selection menu
    Gui, Add, Button, x760 y80 w150 h30 gInsertCustomVariablePresetAddLine, Add Custom Variable  ; Adds a custom variable
    Gui, Add, Button, x760 y120 w150 h30 gSpecialVarsAddLine, Special Variables  ; Opens special variables menu
    Gui, Add, Button, x760 y160 w150 h30 Default gSubmitTypedRPLine, Submit  ; Submits the typed line to the preset

    ; Set the window title to include the preset name and show the GUI
    GuiTitle := "Add RP Line to Preset '" . selectedText . "'"
    Gui, Show, w920 h210, %GuiTitle%
return




; Define the new subroutine to handle the 'Add RP Line' button click
SelectAddPresetRPLine:
    global selectedText, editing, lastEditedPreset, vPresetTreeView  ; Declare variables as global

    ; Ensure a preset or RP line under a preset is selected before proceeding
    selectedID := TV_GetSelection()
    TV_GetText(selectedText, selectedID)  ; Get the text of the selected item

    ; If the selected item is an RP line, get the parent preset name
    if (TV_GetParent(selectedID) != 0) {
        parentID := TV_GetParent(selectedID)
        TV_GetText(selectedText, parentID)
    }

    ; Verify that a preset name is now selected
    if (selectedText = "" || TV_GetParent(selectedID) != 0 && TV_GetParent(parentID) != 0) {
        MsgBox, 262192, Error, "Please select a top-level preset name or an RP line under a preset."  ; 262192 = MB_ICONERROR | MB_TOPMOST | MB_OK
        return
    }

    ; Close the PresetRP GUI
    Gui, Presets:Destroy

    ; Setup the GUI for adding RP Lines to a Preset
    Gui, RPLine:New, +OwnDialogs
    Gui, Add, TreeView, vRPLineTreeView w800 h434 gRPLineTreeViewSelect  

    ; Adding buttons from the top down
    Gui, Add, Button, x820 y372 w150 h30 gAddLineToPreset, Add Selection to Preset
    Gui, Add, Button, x820 y50 w150 h30 gOpenKeyCommandGUI, Add Key Command
    Gui, Add, Button, x820 y412 w150 h30 gCancelAddRPLinePreset, Cancel  

    ; Load RP lines into the TreeView with children
    LoadRPLinesToTreeView(true, true, true)
    
    GuiTitle := "Select Specific RP Line, or Category to add to Preset '" . selectedText . "'"
    Gui, RPLine:Show, w980 h450, %GuiTitle%

    editing := false  ; Clear the editing flag
return


; Subroutine to handle adding a new RP line to a preset
AddLineToPreset:
    global selectedText, lastEditedPreset  ; Declare variables as global

    Gui, RPLineTreeView:Submit, NoHide
    selectedID := TV_GetSelection()
    TV_GetText(selectedRPLineText, selectedID)
    if (!selectedRPLineText || !selectedText) {
        MsgBox, 48, Error, "Please select both a preset and an RP line."
        return
    }

    ; Determine if the selected item is a top-level category (no parent)
    isTopLevelCategory := (TV_GetParent(selectedID) = 0)

    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%

    newContent := ""
    foundPreset := false
    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)

        if (SubStr(line, 1, StrLen(selectedText) + 1) = selectedText . ";") {
            foundPreset := true
            ; Check if the line ends with a semicolon and optionally add one with a space
            if (SubStr(line, StrLen(line), 1) = ";") {
                if (StrLen(line) == StrLen(selectedText) + 1) {
                    line .= " "  ; Add space if it's an empty preset line ending with a semicolon
                }
            } else {
                line .= "; "  ; Add semicolon and space if not present
            }

            ; Format the line to be added based on whether it's a category
            if (isTopLevelCategory) {
                line .= "RandomFrom: [" . selectedRPLineText . "]"
            } else {
                line .= selectedRPLineText
            }
        }

        newContent .= line "`n"
    }

    if (!foundPreset) {
        MsgBox, 48, Error, "Preset `" . selectedText . "` not found in file."
        return
    }

    ; Write the modified content back to the file, ensuring it ends correctly
    FileDelete, %TxtFile%  ; Delete the old file to avoid appending
    FileAppend, %newContent%, %TxtFile%  ; Write the new content

    Gosub ReloadPresetsTreeView
    lastEditedPreset := selectedText  ; Set the last edited preset
    Gui, RPLine:Destroy  ; Close the RP line addition GUI
    Gosub PresetRP  ; Reopen the PresetRP GUI and expand the last edited preset
return

; Handler for the Cancel button in PresetRP GUI
CancelPresetRP:
    Gui, Presets:Destroy
return

EditPreset:
    global selectedText, originalRPLine, editing, selectedRPLineIndex, lastEditedPreset

    selectedID := TV_GetSelection()
    if (selectedID = 0) {
        MsgBox, 48, Error, "Please select a preset or an RP line to edit."
        return
    }

    parentID := TV_GetParent(selectedID)

    if (parentID = 0) {
        ; The user selected a preset name, so we'll rename the preset
        TV_GetText(selectedPreset, selectedID)
        InputBox, newPresetName, Rename Preset, Enter a new name for the preset:, , 220, 130, , , , %selectedPreset%
        if (ErrorLevel = 1 || newPresetName = "") {
            return  ; User pressed Cancel or left it blank
        }

        ; Update the preset name in the main file
        UpdatePresetNameInFile(selectedPreset, newPresetName)

        ; Update the last edited preset to the new name
        lastEditedPreset := newPresetName

        ; Refresh the TreeView
        TV_Modify(selectedID, "Text", newPresetName)  ; Update the TreeView item text
        TV_Modify(selectedID, "Select")  ; Reselect the updated item

        ; Ensure the TreeView is focused after the update
        GuiControl, Focus, PresetTreeView
    } else {
        ; The user selected an RP line, so we'll open the OpenTypeRPLineGUI directly to edit it
        TV_GetText(selectedRPLine, selectedID)
        ; Strip the numbering when storing the selected RP line
        selectedRPLine := RegExReplace(selectedRPLine, "^\d+\.\s*")
        TV_GetText(selectedText, parentID)  ; Get the name of the parent preset

        ; Determine the index of the selected RP line within the preset
        selectedRPLineIndex := 0
        currentRPLineCount := 0
        currentID := TV_GetChild(parentID)

        while (currentID) {
            currentRPLineCount++
            if (currentID = selectedID) {
                selectedRPLineIndex := currentRPLineCount
                break
            }
            currentID := TV_GetNext(currentID)
        }

        if (selectedRPLineIndex = 0) {
            MsgBox, 48, Error, "Selected RP line not found in preset."
            return
        }

        ; Store the last edited preset name and the original RP line
        lastEditedPreset := selectedText
        originalRPLine := selectedRPLine
        editing := true  ; Set the editing flag



        ; Open the OpenTypeRPLineGUI directly, pre-filling it with the selected RP line
        Gosub OpenTypeRPLineGUI
    }
return



; Event handler for Edit Preset button
AddLinePresetOpenPreset:
    ; Directly open the add rp line preset GUI without checking for selection
    Gosub, SelectAddPresetRPLine
return

ReloadEditPresetTreeView:
    global lastEditedPreset, lastEditedRPLine, lastEditedRPLineIndex

    ; Clear the existing TreeView
    TV_Delete("EditPresetTreeView")

    ; Load all presets into the TreeView
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%

    lastEditedItemID := 0  ; Initialize variable to store the last edited item ID
    lastEditedRPLineID := 0  ; Initialize variable to store the last edited RP line ID

    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        SplitPos := InStr(line, ";")
        if (SplitPos > 0) {
            presetName := SubStr(line, 1, SplitPos - 1)
            details := SubStr(line, SplitPos + 1)
            parentItem := TV_Add(presetName, "EditPresetTreeView")  ; Add preset name as a parent item
            if (presetName = lastEditedPreset) {
                lastEditedItemID := parentItem  ; Store the ID of the last edited item
            }
            RPLineIndex := 1  ; Initialize the RP line index for numbering
            Loop, Parse, details, `;
            {
                numberedLine := RPLineIndex . ". " . Trim(A_LoopField)  ; Add numbering to each RP line
                childID := TV_Add(numberedLine, parentItem)
                if (presetName = lastEditedPreset && RPLineIndex = lastEditedRPLineIndex) {
                    lastEditedRPLineID := childID
                }
                RPLineIndex++  ; Increment the RP line index
            }
        }
    }

    ; Re-highlight the last edited preset or RP line
    if (lastEditedRPLineID) {
        TV_Modify(lastEditedRPLineID, "Select")  ; Select the last edited RP line
        TV_Modify(lastEditedItemID, "Expand")  ; Expand only if an RP line was selected
        TV_Modify(lastEditedRPLineID, "Focus")  ; Ensure focus is set for proper highlighting
    } else if (lastEditedItemID) {
        TV_Modify(lastEditedItemID, "Select")  ; Select the last edited preset
        TV_Modify(lastEditedItemID, "Focus")  ; Ensure focus is set for proper highlighting
    }

    ; Set focus to the TreeView control
    GuiControl, Focus, EditPresetTreeView
    ; Ensure the selected item is in view
    TV_Modify(TV_GetSelection(), "EnsureVisible")
return


EditRPLineInPreset:
    global selectedText, originalRPLine, editing, selectedRPLineIndex, lastEditedPreset

    Gui, RPLineTreeView:Submit, NoHide
    selectedID := TV_GetSelection()
    TV_GetText(selectedRPLine, selectedID)
    if (selectedRPLine = "") {
        MsgBox, 48, Error, "Please select or type an RP line."
        return
    }

    ; Strip the numbering when storing the selected RP line
    selectedRPLine := RegExReplace(selectedRPLine, "^\d+\.\s*")

    ; Determine if the selected item is a top-level category (no parent)
    isTopLevelCategory := (TV_GetParent(selectedID) = 0)

    ; Read the RP lines file and prepare for modification
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%
    newContent := ""
    foundPreset := false
    currentRPLineCount := 0

    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        if (SubStr(line, 1, StrLen(selectedText) + 1) = selectedText . ";") {
            foundPreset := true
            parts := StrSplit(line, ";")

            ; Ensure the correct RP line position within the preset
            if (selectedRPLineIndex <= parts.MaxIndex()) {
                ; Replace the line with the selected RP line or category
                if (isTopLevelCategory) {
                    parts[selectedRPLineIndex + 1] := " RandomFrom: [" . selectedRPLine . "]"
                } else {
                    parts[selectedRPLineIndex + 1] := " " . selectedRPLine
                }
            } else {
                MsgBox, 48, Error, "Unable to update RP line at the specified position."
                return
            }

            ; Reconstruct the line after updating the selected RP line
            line := parts[1]
            for index, part in parts {
                if (index > 1) {
                    line .= ";" . part
                }
            }
        }
        newContent .= line "`n"
    }

    if (!foundPreset) {
        MsgBox, 48, Error, "Preset `" . selectedText . "` not found in file."
        return
    }

    ; Write the updated content back to the file
    FileDelete, %TxtFile%
    FileAppend, %newContent%, %TxtFile%

    ; Close the AddRPLine GUI, then reopen the PresetRP GUI
    Gui, AddRPLine:Destroy
    Gosub PresetRP  ; Reopen the PresetRP GUI
return






OpenTypeRPLineGUI:
    global selectedText, selectedRPLine  ; Ensure that the selected preset name and RP line are available

    Gui, InputRPLine:New, +OwnDialogs
    Gui, Font, s10, Segoe UI  ; Set a modern font with a decent size

    ; Add a label for instruction on the left side
    Gui, Add, Text, x10 y10 w600, Edit the selected RP Line below:

    ; Add a single-line edit control for the RP line input on the left side
    Gui, Add, Edit, vUserRPLine x10 y40 w740 h150 -Wrap HScroll, %selectedRPLine%  ; Pre-fill with the selected RP line for editing

    ; Add buttons vertically on the right side
    Gui, Add, Button, x760 y40 w150 h30 gOpenSelectionMenu, Choose from Category    ; Moved Open Selection Menu button to the top
    Gui, Add, Button, x760 y80 w150 h30 gInsertCustomVariablePresetAddLine, Add Custom Variable  ; Moved Add Custom Variable button below
    Gui, Add, Button, x760 y120 w150 h30 gSpecialVarsAddLine, Special Variables
    Gui, Add, Button, x760 y160 w150 h30 Default gSubmitEditTypedRPLine, Submit

    ; Adjust the window size and set the title dynamically to include the preset name
    GuiTitle := "Edit RP Line for Preset '" . selectedText . "'"
    Gui, Show, w920 h210, %GuiTitle%
return



OpenSelectionMenu:
    global selectedText

    ; Close the InputRPLine GUI when opening the selection menu
    Gui, InputRPLine:Destroy

    ; Open the Add RP Line GUI for selection
    Gui, AddRPLine:New, +OwnDialogs
    Gui, Add, TreeView, vRPLineTreeView w800 h434 gRPLineTreeViewSelect
    Gui, Add, Button, x820 y370 w150 h30 gEditRPLineInPreset, Submit Selected Line  
    Gui, Add, Button, x820 y410 w150 h30 gCancelSelectionMenu, Cancel  
    ; Load RP lines into the TreeView with children
    LoadRPLinesToTreeView(true, true, true)
    GuiTitle := "Select RP Line for Preset '" . selectedText . "'"
    Gui, AddRPLine:Show, w980 h450, %GuiTitle%
return

CancelSelectionMenu:
    Gui, AddRPLine:Destroy
    Gosub, OpenTypeRPLineGUI
return




SubmitTypedRPLine:
    global selectedText, originalRPLine, editing, selectedRPLineIndex
    Gui, InputRPLine:Submit  ; Save the input from the user
    if (UserRPLine = "") {
        MsgBox, 48, Error, Please type an RP line before submitting.
        return
    }

    ; Process user input to handle multiple lines
    UserRPLine := StrReplace(UserRPLine, "`r", "")  ; Normalize line endings
    lines := StrSplit(UserRPLine, "`n")  ; Split by newlines

    ; Prepare a list of formatted lines to add
    formattedLines := []
    for index, line in lines {
        line := Trim(line)
        if (line != "") {
            formattedLines.Push(line)  ; Add each line individually
        }
    }

    ; Add or replace the typed RP lines in the preset
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%
    newContent := ""
    foundPreset := false

    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        if (SubStr(line, 1, StrLen(selectedText) + 1) = selectedText . ";") {
            foundPreset := true
            parts := StrSplit(line, ";")

            ; Clean up trailing empty parts or duplicate semicolons
            while (Trim(parts[parts.MaxIndex()]) = "") {
                parts.RemoveAt(parts.MaxIndex())
            }

            ; Append new lines at the end
            for index, newLine in formattedLines {
                parts.Push(newLine)
            }

            ; Reconstruct the line
            line := parts[1]
            for index, part in parts {
                if (index > 1) {
                    line .= ";" . Trim(part)
                }
            }
        }
        newContent .= line "`n"
    }

    if (!foundPreset) {
        MsgBox, 48, Error, "Preset `" . selectedText . "` not found in file."
        return
    }

    ; Write the updated content back to the file
    FileDelete, %TxtFile%
    FileAppend, %newContent%, %TxtFile%

    ; Refresh the Preset TreeView and close all relevant GUIs
    Gosub ReloadPresetsTreeView
    Gui, InputRPLine:Destroy  ; Close the typing GUI

    ; Reopen the PresetRP GUI
    Gosub PresetRP
return




SubmitEditTypedRPLine:
    global selectedText, originalRPLine, editing, selectedRPLineIndex
    Gui, InputRPLine:Submit  ; Save the input from the user

    ; Ensure user input is not empty
    if (UserRPLine = "") {
        MsgBox, 48, Error, Please type an RP line before submitting.
        return
    }

    ; Merge multiple lines into one without semicolons
    UserRPLine := StrReplace(UserRPLine, "`r", "")  ; Normalize line endings
    UserRPLine := StrReplace(UserRPLine, "`n", " ")  ; Replace newlines with a space
    UserRPLine := Trim(UserRPLine)  ; Remove leading/trailing spaces

    ; Add or replace the typed RP line in the preset
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%
    newContent := ""
    foundPreset := false
    foundOriginalLine := false

    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        if (SubStr(line, 1, StrLen(selectedText) + 1) = selectedText . ";") {
            foundPreset := true
            parts := StrSplit(line, ";")

            if (editing) {
                ; Editing an existing RP line
                if (parts.MaxIndex() >= selectedRPLineIndex + 1) {
                    parts[selectedRPLineIndex + 1] := UserRPLine  ; Replace with merged input
                    foundOriginalLine := true
                } else {
                    MsgBox, 48, Error, "Original RP line not found in the preset."
                    return
                }
            } else {
                ; Adding a new RP line (shouldn't happen here but for safety)
                MsgBox, 48, Error, "This action is for editing, not adding new RP lines."
                return
            }

            ; Reconstruct the line without adding unnecessary semicolons
            line := parts[1]
            for index, part in parts {
                if (index > 1) {
                    line .= ";" . Trim(part)
                }
            }
        }
        newContent .= line "`n"
    }

    if (!foundPreset) {
        MsgBox, 48, Error, "Preset `" . selectedText . "` not found in file."
        return
    }

    if (editing && !foundOriginalLine) {
        MsgBox, 48, Error, "Original RP line not found in the preset."
        return
    }

    ; Write the updated content back to the file
    FileDelete, %TxtFile%
    FileAppend, %newContent%, %TxtFile%

    ; Refresh the Preset TreeView and close all relevant GUIs
    Gosub ReloadPresetsTreeView
    Gui, InputRPLine:Destroy  ; Close the typing GUI

    ; Reopen the PresetRP GUI
    Gosub PresetRP
return




InsertCustomVariablePresetAddLine:
    InputBox, CustomVar, Add Custom Variable, Please enter the custom variable name:, , 220, 130
    if (ErrorLevel = 0 && CustomVar != "") {
        GuiControlGet, UserRPLine, , UserRPLine
        GuiControl, , UserRPLine, %UserRPLine%{%CustomVar%}
        GuiControl, Focus, UserRPLine
        SendInput {End}
    }
return






; Common function to show the special variables menu
ShowSpecialVarsMenu(section) {
    global specialVarSection, SpecialVarTree, SpecialVarDescription
    specialVarSection := section  ; Track the invoking section

    Gui, SpecialVars:New, +OwnDialogs
    ; Create a wider and slightly shorter TreeView and Edit area
    Gui, Add, TreeView, vSpecialVarTree w300 h320 gSpecialVarTreeSelect
    Gui, Add, Edit, x320 y6 w480 h320 vSpecialVarDescription ReadOnly
    Gui, Add, Button, x86 y340 w150 h30 gInsertSpecialVar, Insert

    ; Add special variables to the TreeView
    TV_Add("TodaysDate")
    TV_Add("UTCDateTime")
    TV_Add("NumberOfWeeksFromToday")
    TV_Add("RandomNumber")
    TV_Add("DoNotEnter")
    TV_Add("SendInstantly")
    TV_Add("Comment=")
    TV_Add("FormatNumbers")
    TV_Add("RoundNumbers")
    TV_Add("SkipChatOpen")
    TV_Add("Loop")
    TV_Add("List")    
    TV_Add("Slider")    
    hMathOperations := TV_Add("Math Operations")
    TV_Add("Addition", hMathOperations)
    TV_Add("Subtraction", hMathOperations)
    TV_Add("Multiply", hMathOperations)
    TV_Add("Divide", hMathOperations)
    TV_Add("Percent", hMathOperations)
    TV_Add("Average", hMathOperations)
    TV_Add("Combined Math Output", hMathOperations)

    ; Adjust window size to fit the new layout
    Gui, Show, w820 h380, Special Variables
}



; Function to handle the insertion of the selected special variable
InsertSpecialVar:
    selectedID := TV_GetSelection()
    if (selectedID != 0) {
        TV_GetText(SpecialVar, selectedID)
        Gui, SpecialVars:Destroy

        ; Use the example string associated with the selected special variable
        SpecialVarExamples := Object()
        SpecialVarExamples["TodaysDate"] := "{TodaysDate}"
        SpecialVarExamples["UTCDateTime"] := "{UTCDateTime}"
        SpecialVarExamples["NumberOfWeeksFromToday"] := "{NumberOfWeeksFromToday}"
        SpecialVarExamples["RandomNumber"] := "{RandomNumber}"
        SpecialVarExamples["DoNotEnter"] := "{DoNotEnter}"
        SpecialVarExamples["SendInstantly"] := "{SendInstantly}"
        SpecialVarExamples["Comment="] := "{Comment=}"
        SpecialVarExamples["FormatNumbers"] := "{FormatNumbers}"
        SpecialVarExamples["RoundNumbers"] := "{RoundNumbers}"
        SpecialVarExamples["SkipChatOpen"] := "{SkipChatOpen}"      
        SpecialVarExamples["Loop"] := "{Loop}" 
        SpecialVarExamples["List"] := "{List: Option 1, Option 2 (25), Option 3}"     
        SpecialVarExamples["Slider"] := "{Slider: Option 1, Option 2 (25), Option 3}" 
        SpecialVarExamples["Addition"] := "{{ {Number 1} + {Number 2} }}"
        SpecialVarExamples["Subtraction"] := "{{ {Number 1} - {Number 2} }}"
        SpecialVarExamples["Multiply"] := "{{ {Number 1} * {Number 2} }}"
        SpecialVarExamples["Divide"] := "{{ {Number 1} / {Number 2} }}"
        SpecialVarExamples["Percent"] := "{{ {Number 1} % {Number 2} }}"
        SpecialVarExamples["Average"] := "{{ {Number 1} @ {Number 2} @ {Number 3} }}"
        SpecialVarExamples["Combined Math Output"] := "{{ {Number 1} + {Number 2} * {Number 3} = {MathOutput1} }}"
        ExampleToInsert := SpecialVarExamples[SpecialVar]

        ; Insert into the correct input box depending on which section invoked the menu
        if (specialVarSection = "AddLine") {
            GuiControlGet, UserRPLine, InputRPLine:
            GuiControl, InputRPLine:, UserRPLine, %UserRPLine%%ExampleToInsert%
            GuiControl, InputRPLine:Focus, UserRPLine
        } else if (specialVarSection = "RPLine") {
            GuiControlGet, newRPLine, AddRPLine:
            GuiControl, AddRPLine:, NewRPLine, %newRPLine%%ExampleToInsert%
            GuiControl, AddRPLine:Focus, NewRPLine
        } else if (specialVarSection = "EditLine") {
            GuiControlGet, editedRPLine, EditRPLine:, EditedRPLine
            GuiControl, EditRPLine:, EditedRPLine, %editedRPLine%%ExampleToInsert%
            GuiControl, EditRPLine:Focus, EditedRPLine
        }
        SendInput {End}
    }
return

; Function to handle the selection of a special variable from the TreeView
SpecialVarTreeSelect:
    selectedID := TV_GetSelection()
    if (selectedID != 0) {
        TV_GetText(SpecialVar, selectedID)
        ; Define descriptions for each special variable
        SpecialVarDescriptions := Object()
        SpecialVarDescriptions["Math Operations"] := "Various math operations to use as variables for calculations, including addition, subtraction, multiplication, division, and more."
        SpecialVarDescriptions["DoNotEnter"] := "Will not automatically press the Enter key on the RP line at the end."
        SpecialVarDescriptions["SendInstantly"] := "Sends the typing instantly instead of typing slowly."
        SpecialVarDescriptions["TodaysDate"] := "Automatically inputs today's current date.`n`n"
            . "      - Example: `/me fills out the report with the date {TodaysDate}.` `n`n"
            . "            - Result: `/me fills out the report with the date 2024-08-03.` `n`n"
        SpecialVarDescriptions["UTCDateTime"] := "Automatically inputs the current Date and Time in UTC.`n`n"
            . "      - Example: `/me notes the time of the event as {UTCDateTime} UTC.` `n`n"
            . "            - Result: `/me notes the time of the event as 04:20 09/AUG UTC.` `n`n"
        SpecialVarDescriptions["NumberOfWeeksFromToday"] := "Enter a number to calculate the date X weeks from today automatically.`n`n"
            . "      - Example: `/me schedules the follow-up meeting for {NumberOfWeeksFromToday}.` `n`n"
            . "            - Result: `/me schedules the follow-up meeting for August 9th, 2024.` `n`n"
        SpecialVarDescriptions["RandomNumber"] := "Inputs a random number between 1-100.`n`n"
            . "      - Example: `/me rolls a dice and gets a {RandomNumber}.` `n`n"
            . "            - Result: `/me rolls a dice and gets a 69.` `n`n"
        SpecialVarDescriptions["Comment="] := "Use this for identifying lines for TV links or any other comments. This variable will be ignored by the AHK.`n`n"
            . "      - Example: `{Comment=Arcadius Commercial} {SkipChatOpen} https://www.youtube.com/watch?v=Dt3riT2cH5U` `n`n"
            . "            - Result: `https://www.youtube.com/watch?v=Dt3riT2cH5U` `n`n"

        SpecialVarDescriptions["FormatNumbers"] := "Automatically format all numbers in the line by adding commas as thousand separators.`n`n"
            . "      - Example: `The total cost is $3502253 {FormatNumbers}` `n`n"
            . "            - Result: `The total cost is $3,502,253` `n"
            . "            - Use `{FormatNumbers}` anywhere in the line to apply formatting to all numbers in that line.`n`n"

        SpecialVarDescriptions["RoundNumbers"] := "Automatically rounds to the nearest whole number. n`n"
            . "      - Example: `The total cost is $253.69 {RoundNumbers}` `n`n"
            . "            - Result: `The total cost is $254` `n"
            . "            - Use `{RoundNumbers}` anywhere in the line to apply rounding to all numbers in that line.`n`n"

        SpecialVarDescriptions["SkipChatOpen"] := "Skips opening the chat before sending the text.`n`n"
            . "      - Example: `{SkipChatOpen} https://www.youtube.com/watch?v=Dt3riT2cH5U {SkipChatOpen}` `n`n"
            . "            - Result: `https://www.youtube.com/watch?v=Dt3riT2cH5U` `n"
            . "            - Note: Use this when the chat is already open or when you want to send a command without opening the chat automatically.`n`n"

        SpecialVarDescriptions["Loop"] := "Repeat a line a specified number of times by using the {Loop} variable.`n`n"
            . "      - Example: `Burger. {Loop} {DoNotEnter}` `n`n"
            . "            - User Input: 5`n"
            . "            - Result: `Burger. Burger. Burger. Burger. Burger.` `n`n"
            . "            - Note: The `{Loop}` variable allows you to enter the number of times the line should be repeated. Combine it with other variables like `{DoNotEnter}` to customize how the line is sent.`n`n"

        SpecialVarDescriptions["List"] := "Create a dropdown list of options with optional outputs in parentheses, a range, or an optional label.`n`n"
        . "      - Example: `/me chooses an option from the list: {List: LSC, LSPD, Bayview}.` `n`n"
        . "            - Result: `/me chooses an option from the list: LSC.` `n`n"
        . "      - Example: `/me chooses an option from the list: {List: LSC (25), LSPD (50), Bayview (75)}.` `n`n"
        . "            - Result: `/me chooses an option from the list: 25.` `n`n"
        . "      - Example: `/me selects a number from the range: {List: Numbers: <1-10>}.` `n`n"
        . "            - Result: `/me selects a number from the range: 5.` (A dropdown labeled 'Numbers' with numbers 1 through 10 is created.) `n`n"
        . "      - Example: `/me selects a fruit: {List: Fruit Choices: Apple, Orange, Grape}.` `n`n"
        . "            - Result: `/me selects a fruit: Orange.` (A dropdown labeled 'Fruit Choices' is created with options Apple, Orange, and Grape.) `n`n"
        . "      - Note: Use the `<start-end>` syntax to create a range-based dropdown (e.g., `<1-10>` or `<0.1-1>` for decimal ranges).`n"
        . "      - Note: You can include optional outputs in parentheses for each item in the list.`n"
        . "      - Note: To add an optional label, include it before the colon (e.g., `{List: Fruit Choices:}`).`n"
        . "      - Note: Matching list variables will combine into one dropdown menu.`n`n"
        
        SpecialVarDescriptions["Slider"] := "Create a slider of options with optional outputs in parentheses, a range, or an optional label.`n`n"
        . "      - Example: `/me adjusts the slider: {Slider: Low, Medium, High}.` `n`n"
        . "            - Result: `/me adjusts the slider: Medium.` (A slider with three positions is created.) `n`n"
        . "      - Example: `/me adjusts the slider: {Slider: Speed: <1-100>}.` `n`n"
        . "            - Result: `/me adjusts the slider: 50.` (A slider labeled 'Speed' with whole-number increments from 1 to 100 is created.) `n`n"
        . "      - Example: `/me selects a fruit: {Slider: Fruit Choices: Apple, Orange, Grape}.` `n`n"
        . "            - Result: `/me selects a fruit: Orange.` (A slider labeled 'Fruit Choices' is created with options Apple, Orange, and Grape.) `n`n"
        . "      - Note: Use the `<start-end>` syntax to create a range-based slider (e.g., `<1-100>` or `<0.1-10>` for decimal ranges).`n"
        . "      - Note: You can include optional outputs in parentheses for each item in the slider.`n"
    . "      - Note: To add an optional label, include it before the colon (e.g., `{Slider: Fruit Choices:}`).`n"
        . "      - Note: Matching slider variables will combine into one slider menu.`n`n"
    

        SpecialVarDescriptions["Addition"] := "Addition operation.`n`n"
            . "      - Example: `{{ {Number1} + {Number2} }}` `n`n"
            . "            - Result: If `Number1 = 6` and `Number2 = 9`, the result will be `15.` `n`n"
            . "                - Calculation: `6 + 9` = `15.` `n`n"
        
        SpecialVarDescriptions["Subtraction"] := "Subtraction operation.`n`n"
            . "      - Example: `{{ {Number1} - {Number2} }}` `n`n"
            . "            - Result: If `Number1 = 10` and `Number2 = 4`, the result will be `6.` `n`n"
            . "                - Calculation: `10 - 4` = `6.` `n`n"
        
        SpecialVarDescriptions["Multiply"] := "Multiplication operation.`n`n"
            . "      - Example: `{{ {Number1} * {Number2} }}` `n`n"
            . "            - Result: If `Number1 = 6` and `Number2 = 7`, the result will be `42.` `n`n"
            . "                - Calculation: `6 * 7` = `42.` `n`n"
        
        SpecialVarDescriptions["Divide"] := "Division operation.`n`n"
            . "      - Example: `{{ {Number1} / {Number2} }}` `n`n"
            . "            - Result: If `Number1 = 20` and `Number2 = 4`, the result will be `5.` `n`n"
            . "                - Calculation: `20 / 4` = `5.` `n`n"
        
        SpecialVarDescriptions["Percent"] := "Percentage calculation.`n`n"
            . "      - Example: `{{ {Number1} % {Number2} }}` `n`n"
            . "            - Result: If `Number1 = 25` and `Number2 = 200`, the result will be `50.` `n`n"
            . "                - Calculation: `25% of 200` = `50.` `n`n"
        
        SpecialVarDescriptions["Average"] := "Average calculation.`n`n"
            . "      - Example: `{{ {Number1} @ {Number2} @ {Number3} }}` `n`n"
            . "            - Result: If `Number1 = 4`, `Number2 = 8`, and `Number3 = 12`, the average will be `8.` `n`n"
            . "                - Calculation: `(4 + 8 + 12) / 3` = `24 / 3` = `8.` `n`n"
        
        SpecialVarDescriptions["Combined Math Output"] := "Store the results of math operations for reuse in your script.`n`n"
            . "   - Supported symbols:`n`n"
            . "   `+` (Addition), `-` (Subtraction), `*` (Multiplication), `/` (Division), `%` (Percentage), and '@' (Average).`n`n"
            . "1. Example: Saving a Result`n`n"
            . "      - `{{ {Number1} + {Number2} / 2 + {Number3}= {MathOutput3} }}` `n"
            . "            - Adds the values in `{Number1}` and `{Number2}`, Divides by 2, then adds `{Number3}`.`n`n"
            . "            - Saves the result to `{MathOutput3}` for later use.`n`n"
            . "2. Example: Combining Saved Outputs`n`n"
            . "      - `{{ {MathOutput1} + {MathOutput2} }}` `n"
            . "            - Adds the values stored in `{MathOutput1}` and `{MathOutput2}`.`n`n"
            . "   - You can save results to `{MathOutput}` or `{MathOutputX}` for specific tracking."    

        Description := SpecialVarDescriptions[SpecialVar]
        GuiControl, , SpecialVarDescription, %Description%
    }
return


; Label for Add Line section
SpecialVarsAddLine:
    ShowSpecialVarsMenu("AddLine")
return

; Label for RP Line section
SpecialVarsRPLine:
    ShowSpecialVarsMenu("RPLine")
return

; Label for Edit Line section
SpecialVarsEditLine:
    ShowSpecialVarsMenu("EditLine")
return





DoneEditingPresets:
    Gui, EditPresetGUI:Destroy
    Gosub, OpenPresetRP
return

; Handler for the Move Preset Up button
MovePresetUp:
    global lastEditedPreset, lastEditedRPLine, lastEditedRPLineIndex
    selectedID := TV_GetSelection()
    if (selectedID = 0) {
        MsgBox, 48, Error, "Please select a preset or RP line to move."
        return
    }
    if (TV_GetParent(selectedID) = 0) {  ; It's a preset
        TV_GetText(lastEditedPreset, selectedID)
        lastEditedRPLine := ""
        lastEditedRPLineIndex := 0
        MoveItemPreset(selectedID, -1)
    } else {  ; It's an RP line
        TV_GetText(lastEditedPreset, TV_GetParent(selectedID))
        TV_GetText(lastEditedRPLine, selectedID)
        lastEditedRPLineIndex := GetChildIndex(selectedID)
        MoveItemPreset(selectedID, -1)
        if (lastEditedRPLineIndex > 1) { ; Update the index for moving up if not at the top
            lastEditedRPLineIndex -= 1
        }
    }
    Gosub, ReloadPresetsTreeView
return

; Handler for the Move Preset Down button
MovePresetDown:
    global lastEditedPreset, lastEditedRPLine, lastEditedRPLineIndex
    selectedID := TV_GetSelection()
    if (selectedID = 0) {
        MsgBox, 48, Error, "Please select a preset or RP line to move."
        return
    }
    if (TV_GetParent(selectedID) = 0) {  ; It's a preset
        TV_GetText(lastEditedPreset, selectedID)
        lastEditedRPLine := ""
        lastEditedRPLineIndex := 0
        MoveItemPreset(selectedID, 1)
    } else {  ; It's an RP line
        TV_GetText(lastEditedPreset, TV_GetParent(selectedID))
        TV_GetText(lastEditedRPLine, selectedID)
        lastEditedRPLineIndex := GetChildIndex(selectedID)
        MoveItemPreset(selectedID, 1)
        if (lastEditedRPLineIndex < TV_GetChildCount(TV_GetParent(selectedID))) { ; Update the index for moving down if not at the bottom
            lastEditedRPLineIndex += 1
        }
    }
    Gosub, ReloadPresetsTreeView
return

; Function to move the preset or RP line in the file for presets
MoveItemPreset(selectedID, direction) {
    parentID := TV_GetParent(selectedID)
    TV_GetText(selectedItem, selectedID)
    if (InStr(selectedItem, ". ")) {
        selectedItem := SubStr(selectedItem, InStr(selectedItem, ". ") + 2)  ; Remove numbering if any
    }
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%

    ; Convert content to an array of lines
    presets := StrSplit(content, "`n", "`r")

    if (parentID = 0) {  ; It's a main preset
        ; Find the preset line and determine its index
        for index, line in presets {
            if (SubStr(line, 1, StrLen(selectedItem) + 1) = selectedItem . ";") {
                targetIndex := index + direction

                ; Check category boundaries
                if (direction == -1 && (index == 1 || presets[index-2] == "")) {
                    return  ; Don't move up if it's the first line or after an empty line (category start)
                }
                if (direction == 1 && (targetIndex > presets.MaxIndex() || presets[targetIndex] == "")) {
                    return  ; Don't move down if it's the last line or before an empty line (category end)
                }

                ; Swap lines if within valid range
                temp := presets[targetIndex]
                presets[targetIndex] := presets[index]
                presets[index] := temp

                ; Update lastEditedPreset to the moved preset
                lastEditedPreset := selectedItem
                break
            }
        }
    } else {  ; It's an RP line
        TV_GetText(presetName, parentID)  ; Get the name of the parent preset
        selectedRPLineIndex := 0
        currentRPLineCount := 0
        currentID := TV_GetChild(parentID)

        ; Determine the exact index of the selected RP line
        while (currentID) {
            TV_GetText(currentText, currentID)
            if (InStr(currentText, ". ")) {
                currentText := SubStr(currentText, InStr(currentText, ". ") + 2)  ; Remove numbering if any
            }
            if (Trim(currentText) = Trim(selectedItem)) {
                currentRPLineCount++
                if (currentID = selectedID) {
                    selectedRPLineIndex := currentRPLineCount
                    break
                }
            }
            currentID := TV_GetNext(currentID)
        }

        ; Find the correct line and modify it
        for index, line in presets {
            if (SubStr(line, 1, StrLen(presetName) + 1) = presetName . ";") {
                rpLines := StrSplit(SubStr(line, StrLen(presetName) + 2), ";")
                currentRPLineCount := 0
                for rpIndex, rpLine in rpLines {
                    if (Trim(rpLine) = Trim(selectedItem)) {
                        currentRPLineCount++
                        if (currentRPLineCount = selectedRPLineIndex) {
                            targetIndex := rpIndex + direction

                            ; Ensure targetIndex is within bounds
                            if (targetIndex < 1 || targetIndex > rpLines.MaxIndex())
                                return

                            ; Swap RP lines
                            temp := rpLines[targetIndex]
                            rpLines[targetIndex] := rpLines[rpIndex]
                            rpLines[rpIndex] := temp

                            ; Update the index to reflect the new position
                            selectedRPLineIndex := targetIndex
                            break
                        }
                    }
                }

                ; Rebuild the preset line
                rebuiltRPLine := presetName . ";"
                first := true
                for _, rp in rpLines {
                    if (first) {
                        rebuiltRPLine .= " " . Trim(rp)
                        first := false
                    } else {
                        rebuiltRPLine .= "; " . Trim(rp)
                    }
                }
                presets[index] := Trim(rebuiltRPLine)
                break
            }
        }
    }

    ; Rebuild the content from the array
    newContent := ""
    for _, line in presets {
        newContent .= line "`n"
    }

    ; Write back to the file
    FileDelete, %TxtFile%
    FileAppend, %newContent%, %TxtFile%

    ; Reload the tree view to reflect the changes
    Gosub ReloadPresetsTreeView
}


; Function to get the index of a child in its parent
GetChildIndex(selectedID) {
    parentID := TV_GetParent(selectedID)
    currentID := TV_GetChild(parentID)
    index := 0
    while (currentID) {
        index++
        if (currentID = selectedID) {
            return index
        }
        currentID := TV_GetNext(currentID)
    }
    return -1  ; Not found (should not happen)
}

; Function to get the number of children of a parent
TV_GetChildCount(parentID) {
    count := 0
    currentID := TV_GetChild(parentID)
    while (currentID) {
        count++
        currentID := TV_GetNext(currentID)
    }
    return count
}

DeletePresetRPLine:
    global lastEditedPreset, lastEditedRPLine, lastEditedRPLineIndex, expandCategory
    selectedID := TV_GetSelection()
    if (selectedID = 0) {
        MsgBox, 48, Error, "Please select a preset or RP line to delete."
        return
    }
    TV_GetText(selectedItem, selectedID)
    parentID := TV_GetParent(selectedID)
    if (parentID != 0) {
        TV_GetText(lastEditedPreset, parentID)
    }

    ; Strip the numbering when storing the selected item
    selectedItem := RegExReplace(selectedItem, "^\d+\.\s*")

    MsgBox, 4, Confirm Deletion, Are you sure you want to delete "%selectedItem%"?
    IfMsgBox, No
        return

    ; Call function to handle the deletion based on the selected item type
    ExecuteDeleteAction(selectedID, selectedItem, parentID)

    ; Set flags to ensure the category is expanded after deleting
    if (parentID != 0) {
        lastEditedRPLine := ""
        lastEditedRPLineIndex := GetChildIndex(parentID)
    } else {
        lastEditedRPLine := ""
        lastEditedRPLineIndex := 0
    }
    expandCategory := true
    Gosub, ReloadPresetsTreeView
return

ExecuteDeleteAction(selectedID, selectedItem, parentID) {
    global lastEditedPreset
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%
    presets := StrSplit(content, "`n", "`r")

    if (parentID = 0) {  ; It's a main preset
        ; Find and delete the whole preset line
        for index, line in presets {
            if (SubStr(line, 1, StrLen(selectedItem) + 1) = selectedItem . ";") {
                presets.RemoveAt(index)
                break
            }
        }
    } else {  ; It's an RP line
        TV_GetText(parentItem, parentID)  ; Get the name of the parent preset
        selectedRPLineIndex := 0
        currentRPLineCount := 0
        currentID := TV_GetChild(parentID)

        ; Determine the exact index of the selected RP line
        while (currentID) {
            TV_GetText(currentText, currentID)
            ; Strip the numbering when comparing
            currentText := RegExReplace(currentText, "^\d+\.\s*")
            if (Trim(currentText) = Trim(selectedItem)) {
                currentRPLineCount++
                if (currentID = selectedID) {
                    selectedRPLineIndex := currentRPLineCount
                    break
                }
            }
            currentID := TV_GetNext(currentID)
        }

        ; Find the correct line and modify it
        for index, line in presets {
            if (SubStr(line, 1, StrLen(parentItem) + 1) = parentItem . ";") {
                rpLines := StrSplit(SubStr(line, StrLen(parentItem) + 2), ";")
                currentRPLineCount := 0
                ; Iterate through RP lines to find the exact match
                for rpIndex, rpLine in rpLines {
                    rpLine := RegExReplace(rpLine, "^\d+\.\s*")  ; Strip numbering
                    if (Trim(rpLine) = Trim(selectedItem)) {
                        currentRPLineCount++
                        if (currentRPLineCount = selectedRPLineIndex) {
                            rpLines.RemoveAt(rpIndex)
                            break
                        }
                    }
                }
                ; Rebuild the preset line with the remaining RP lines
                rebuiltRPLine := parentItem . ";"
                first := true
                for _, rp in rpLines {
                    if (first) {
                        rebuiltRPLine .= Trim(rp)
                        first := false
                    } else {
                        rebuiltRPLine .= "; " . Trim(rp)
                    }
                }
                presets[index] := rebuiltRPLine
                break
            }
        }
    }

    ; Rebuild the content from the array
    newContent := ""
    for _, line in presets {
        newContent .= line "`n"
    }

    ; Write back to the file
    FileDelete, %TxtFile%
    FileAppend, %newContent%, %TxtFile%
}




; Handler for TreeView selections in the EditPresetGUI
EditTreeViewSelect:
    selectedID := TV_GetSelection()  ; Uses the last active TreeView which should be the one in EditPresetGUI
    TV_GetText(selectedPreset, selectedID)  ; Get the text of the selected item
return


; Function to update the preset name in the file
UpdatePresetNameInFile(selectedPreset, newPresetName) {
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%
    
    newContent := ""
    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        if (SubStr(line, 1, StrLen(selectedPreset) + 1) = selectedPreset . ";") {
            line := newPresetName . SubStr(line, StrLen(selectedPreset) + 1)
        }
        newContent .= line "`n"
    }

    FileDelete, %TxtFile%
    FileAppend, %newContent%, %TxtFile%
}


; Event handler for TreeView selections
TreeViewSelect:
    selectedID := TV_GetSelection()
    TV_GetText(selectedText, selectedID)
return


; Event handler for RP Line TreeView selections
RPLineTreeViewSelect:
    selectedRPLineID := TV_GetSelection()
    TV_GetText(selectedRPLineText, selectedRPLineID)
return


; Helper function to get the child item by name
TV_GetChildByName(TV, name) {
    childID := TV_GetChild(TV)
    while (childID) {
        TV_GetText(childText, childID)
        if (childText = name) {
            return childID
        }
        childID := TV_GetNext(childID)
    }
    return 0
}


; Define the subroutine for the Cancel button
CancelAddRPLinePreset:
    Gui, RPLine:Destroy  ; Close the AddRPtoPreset GUI
    Gosub, PresetRP
return


OpenKeyCommandGUI:
    Gui, KeyCmd:New, +OwnDialogs
    Gui, Font, s10, Segoe UI
    Gui, Add, Text, x12 y10 w100 h20, Select Key:
    Gui, Add, DropDownList, x120 y10 w150 vSpecialKeyChoice, UpArrow||DownArrow|LeftArrow|RightArrow|Enter|Backspace|Escape  ; Default to UpArrow
    Gui, Add, Text, x12 y40 w100 h20, Press Count:
    Gui, Add, Edit, x120 y40 w50 vKeyPressCount, 1  ; Default to 1 press
    Gui, Add, Button, x40 y80 w100 h30 Default gSubmitKeyCommand, OK
    Gui, Add, Button, x160 y80 w100 h30 gCancelKeyCommand, Cancel
    Gui, Show, w300 h120, Select Key Command
return



SubmitKeyCommand:
    Gui, KeyCmd:Submit  ; Gather inputs from the KeyCmd GUI

    if (SpecialKeyChoice = "" or KeyPressCount = "") {
        MsgBox, 48, Error, "Please complete all fields."
        return
    }
    if (!RegexMatch(KeyPressCount, "^\d+$")) {  ; Ensure that KeyPressCount is numeric
        MsgBox, 48, Error, "Press Count must be a numeric value."
        return
    }

    KeyCommand := "KeyPress: [" . SpecialKeyChoice . KeyPressCount . "]"

    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%
    newContent := ""
    foundPreset := false
    inPreset := false  ; Track whether we're currently in the right preset block
    presetHasLines := false  ; Track if the preset already contains lines

    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        if (line = "") {
            newContent .= line "`n"  ; Preserve empty lines for formatting
            continue
        }

        if (foundPreset && (SubStr(line, 1, 1) = "[" || line = "")) {
            inPreset := false  ; Stop modification when another category starts or content ends
        }

        if (SubStr(line, 1, StrLen(selectedText) + 1) = selectedText . ";") {
            foundPreset := true
            inPreset := true  ; Start modifying when the selected preset is found
        }

        if (inPreset && foundPreset) {
            ; Check if the preset already has lines
            if (!presetHasLines) {
                ; If it's the first line being added, don't add a semicolon before the KeyCommand
                if (line = selectedText . ";") {
                    line .= " " . KeyCommand
                } else {
                    line .= "; " . KeyCommand
                }
                presetHasLines := true
            } else {
                ; For subsequent lines, ensure correct formatting with a semicolon
                line .= "; " . KeyCommand
            }
            foundPreset := false  ; Ensure we only append once
        }

        newContent .= line "`n"
    }

    if (!foundPreset && !inPreset) {
        MsgBox, 48, Error, "Preset `" . selectedText . "` not found in file."
        Gui, KeyCmd:Destroy
        return
    }

    FileDelete, %TxtFile%
    FileAppend, %newContent%, %TxtFile%

    Gui, KeyCmd:Destroy  ; Close the Key Command GUI
    Gui, RPLine:Destroy  ; Close the AddRPtoPreset GUI

    ; Open the PresetRP GUI
    Gosub, PresetRP
return



CancelKeyCommand:
    Gui, KeyCmd:Destroy
return





AddSpecialKeyToLine:
    Gui, Submit, NoHide  ; Update variable values without closing the GUI
    if (SpecialKeyChoice and KeyPressCount) {
        selectedRPLineText .= " {" . SpecialKeyChoice . KeyPressCount . "}"
        TV_Modify(TV_GetSelection(), "Text", selectedRPLineText)  ; Update the display text
    } else {
        MsgBox, 48, Error, "Please select a key and enter a valid number of presses."
    }
return




; Reload the Presets TreeView and expand the last edited preset
ReloadPresetsTreeView:
    global lastEditedPreset, lastEditedRPLine, lastEditedRPLineIndex

    ; Path to the RP lines file
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%

    ; Clear the existing TreeView
    GuiControl, -Redraw, PresetTreeView  ; Temporarily suspend redrawing for performance
    TV_Delete("PresetTreeView")  ; Clear the TreeView

    lastEditedItemID := 0  ; Initialize variable to store the last edited item ID
    lastEditedRPLineID := 0  ; Initialize variable to store the last edited RP line ID

    ; Rebuild the TreeView
    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        if (line = "" || SubStr(line, 1, 1) = ";")
            continue  ; Skip empty lines and comments

        ; Handle the [Presets] section separately
        if (SubStr(line, 1, 9) = "[Presets]") {
            ; Begin processing presets under the [Presets] section
            continue
        }

        SplitPos := InStr(line, ";")
        if (SplitPos > 0) {
            presetName := SubStr(line, 1, SplitPos - 1)
            details := SubStr(line, SplitPos + 1)
            parentItem := TV_Add(presetName, "")  ; Add preset name as a parent item
            if (presetName = lastEditedPreset) {
                lastEditedItemID := parentItem  ; Store the ID of the last edited item
            }
            RPLineIndex := 1  ; Initialize the RP line index for numbering
            Loop, Parse, details, `;
            {
                numberedLine := RPLineIndex . ". " . Trim(A_LoopField)  ; Add numbering to each RP line
                childID := TV_Add(numberedLine, parentItem)
                if (presetName = lastEditedPreset && RPLineIndex = lastEditedRPLineIndex) {
                    lastEditedRPLineID := childID
                }
                RPLineIndex++  ; Increment the RP line index
            }
        }
    }

    ; Re-highlight the last edited preset or RP line
    if (lastEditedRPLineID) {
        TV_Modify(lastEditedRPLineID, "Select")  ; Select the last edited RP line
        TV_Modify(lastEditedItemID, "Expand")  ; Expand only if an RP line was selected
        TV_Modify(lastEditedRPLineID, "Focus")  ; Ensure focus is set for proper highlighting
    } else if (lastEditedItemID) {
        TV_Modify(lastEditedItemID, "Select")  ; Select the last edited preset
        TV_Modify(lastEditedItemID, "Focus")  ; Ensure focus is set for proper highlighting
    }

    ; Set focus to the TreeView control
    GuiControl, Focus, PresetTreeView
    ; Ensure the selected item is in view
    TV_Modify(TV_GetSelection(), "EnsureVisible")
    GuiControl, +Redraw, PresetTreeView  ; Resume redrawing
return





DeleteSelected:
    global vRPLines, lastEditedPreset, lastEditedRPLine, lastEditedRPLineIndex, expandCategory

    selectedID := TV_GetSelection()
    if (selectedID = 0) {
        MsgBox, 48, Error, Please select a category or RP line to delete.
        return
    }

    TV_GetText(selectedItem, selectedID)
    parentID := TV_GetParent(selectedID)

    if (parentID = 0) {
        ; Deleting a category
        if (selectedItem = "Default Variable Values") {
            ; Special behavior for Default Variable Values category
            MsgBox, 4, Default Variable Values Required, Default Variable Values category required. Delete all default variables?
            IfMsgBox, No
                return

            ; Delete all lines within Default Variable Values category
            TxtFile := A_ScriptDir "\" vRPLines
            FileRead, content, %TxtFile%
            newContent := ""
            inDefaultVarsSection := false

            Loop, Parse, content, `n, `r
            {
                line := Trim(A_LoopField)
                
                ; Track when we enter and exit the Default Variable Values section
                if (line = "[Default Variable Values]") {
                    inDefaultVarsSection := true
                    newContent .= line "`n"  ; Keep the section header
                    continue
                }
                if (inDefaultVarsSection and SubStr(line, 1, 1) = "[") {
                    inDefaultVarsSection := false
                }
                
                ; Skip lines within the Default Variable Values section
                if (!inDefaultVarsSection) {
                    newContent .= line "`n"
                }
            }

            ; Write the sanitized content back to the file
            FileDelete, %TxtFile%
            FileAppend, %newContent%, %TxtFile%
        } else {
            ; Standard category deletion
            MsgBox, 4, Confirm Delete, Are you sure you want to delete the category "%selectedItem%" and all its RP lines?
            IfMsgBox, No
                return

            ; Delete the category and its RP lines from the file
            TxtFile := A_ScriptDir "\" vRPLines
            FileRead, content, %TxtFile%
            newContent := ""
            isDeleting := false

            Loop, Parse, content, `n, `r
            {
                line := Trim(A_LoopField)
                if (line = "[" . Trim(selectedItem) . "]") {
                    isDeleting := true
                    continue
                }
                if (isDeleting and SubStr(line, 1, 1) = "[") {
                    isDeleting := false
                }
                if (!isDeleting) {
                    newContent .= line "`n"
                }
            }

            FileDelete, %TxtFile%
            FileAppend, %newContent%, %TxtFile%
        }
    } else {
        ; Deleting an RP line
        TV_GetText(parentCategory, parentID)
        MsgBox, 4, Confirm Delete, Are you sure you want to delete the RP line "%selectedItem%"?
        IfMsgBox, No
            return

        ; Delete the RP line from the file
        TxtFile := A_ScriptDir "\" vRPLines
        FileRead, content, %TxtFile%
        newContent := ""
        isUpdated := false

        Loop, Parse, content, `n, `r
        {
            line := Trim(A_LoopField)
            if (line = selectedItem) {
                isUpdated := true
                continue
            }
            newContent .= line "`n"
        }

        if (!isUpdated) {
            MsgBox, 48, Error, "Failed to delete the RP line."
            return
        }

        FileDelete, %TxtFile%
        FileAppend, %newContent%, %TxtFile%

        ; Store the parent category to expand it after deletion
        lastEditedPreset := parentCategory
    }

    ; Reload the tree view to reflect the changes
    lastEditedRPLine := ""
    expandCategory := true  ; Ensure the category is expanded after deleting
    Gosub SanitizeFile
    Gosub ReloadRPLinesTreeView
return



AddRPLine:
    global vRPLines, lastEditedPreset, lastEditedRPLine, lastEditedRPLineIndex, expandCategory

    selectedID := TV_GetSelection()
    if (selectedID = 0) {
        MsgBox, 48, Error, Please select a category to add an RP line.
        return
    }

    ; Check if the selected item is an RP line by seeing if it has a parent
    parentID := TV_GetParent(selectedID)
    if (parentID != 0) {
        ; If selected on an RP line, move up to the parent category
        selectedID := parentID
    }

    TV_GetText(selectedCategory, selectedID)  ; Get the text of the selected category

    ; Check if the selected category is "Default Variable Values"
    if (selectedCategory = "Default Variable Values") {
        ; Create a custom GUI for adding a default variable with two inputs
        Gui, AddRPLine:New, +OwnDialogs 
        Gui, Font, s11, Segoe UI Semibold
        Gui, Color, C0C0C0

        ; Add GroupBox for organization
        Gui, Add, GroupBox, x10 y10 w360 h132, Add Default Variable Value

        ; Label and input for Variable Name
        Gui, Add, Text, x20 y40 w160, Variable Name:
        Gui, Add, Edit, vCustomVarName x20 y60 w160 h26 -Wrap

        ; Label and input for Default Value
        Gui, Add, Text, x190 y40 w160, Default Value:
        Gui, Add, Edit, vCustomVarValue x190 y60 w160 h26 -Wrap

        ; Centered Submit button below inputs
        Gui, Add, Button, x114 y100 w140 h30 Default gSubmitAddRPLine, Submit

        ; Show the custom GUI window
        Gui, Show, w380 h150, Add Default Variable Value
        return
    }

    ; Standard Add RP Line GUI for other categories
    Gui, AddRPLine:New, +OwnDialogs 
    Gui, Font, s10, Segoe UI
    Gui, Color, C0C0C0

    ; Label for typing instructions
    Gui, Add, Text, x10 y10 w700, Type your RP Line below. Multiple lines can be added and each line will be added into the Category.

    ; RP line input field
    Gui, Add, Edit, vNewRPLine x10 y40 w740 h110 -Wrap HScroll

    ; Buttons on the right side, similar to TreeEditRPLineEdit
    Gui, Add, Button, x760 y40 w150 h30 gInsertCustomVariable, Add Custom Variable
    Gui, Add, Button, x760 y80 w150 h30 gSpecialVarsRPLine, Special Variables
    Gui, Add, Button, x760 y120 w150 h30 Default gSubmitAddRPLine, Submit

    ; Show the GUI with the same width and height as TreeEditRPLineEdit
    GuiTitle := "Add RP Line to '" . selectedCategory . "'"
    Gui, Show, w920 h170, %GuiTitle%
return








InsertCustomVariable:
    InputBox, CustomVar, Add Custom Variable, Please enter the custom variable name:, , 220, 130
    if (ErrorLevel = 0 && CustomVar != "") {
        GuiControlGet, newRPLine, , NewRPLine
        GuiControl, , NewRPLine, %newRPLine%{%CustomVar%}
        GuiControl, Focus, NewRPLine
        SendInput {End}
    }
return








SubmitNewRPLine:
    Gui, Submit, NoHide  ; Save the input from the user
    GuiControlGet, NewRPLine
    if (NewRPLine = "") {
        MsgBox, 48, Error, "RP line cannot be empty."
        return
    }

    ; Add the new RP line to the selected category in the file
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%
    newContent := ""
    isUpdated := false

    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        newContent .= line "`n"
        if (line = "[" . Trim(selectedCategory) . "]") {
            newContent .= NewRPLine "`n"
            isUpdated := true
        }
    }

    if (!isUpdated) {
        MsgBox, 48, Error, "Failed to add the RP line."
        return
    }

    FileDelete, %TxtFile%
    FileAppend, %newContent%, %TxtFile%

    ; Store the last edited preset/category and RP line
    lastEditedPreset := selectedCategory
    lastEditedRPLine := NewRPLine
    lastEditedRPLineIndex := selectedID
    expandCategory := true  ; Ensure the category is expanded after adding
    Gui, AddRPLine:Destroy
    Gosub SanitizeFile
    Gosub ReloadRPLinesTreeView
return

CancelAddRPLine:
    Gui, AddRPLine:Destroy
return



AddCategory:
    global vRPLines, lastEditedPreset, expandCategory

    InputBox, newCategoryName, Add Category, Please enter the new category name:, , 400, 150
    if (ErrorLevel) {
        return  ; User cancelled input
    }

    if (newCategoryName = "") {
        MsgBox, 48, Error, "Category name cannot be empty."
        return
    }

    ; Sanitize the category name
    newCategoryName := StrReplace(newCategoryName, "[", "")
    newCategoryName := StrReplace(newCategoryName, "]", "")
    categoryName := newCategoryName  ; Store the sanitized category name without brackets
    newCategoryName := "[" . newCategoryName . "]"

    ; Add the new category to the file
    TxtFile := A_ScriptDir "\" vRPLines
    FileAppend, `n%newCategoryName%`n, %TxtFile%

    ; Store the last edited preset/category without brackets
    lastEditedPreset := categoryName
    lastEditedRPLine := ""
    expandCategory := false  ; Do not expand the category after adding
    Gosub SanitizeFile
    Gosub ReloadRPLinesTreeView
return





MoveRPLineUp:
    global lastEditedPreset, lastEditedRPLine, lastEditedRPLineIndex
    selectedID := TV_GetSelection()
    if (selectedID = 0) {
        MsgBox, 48, Error, "Please select an RP line to move."
        return
    }
    if (TV_GetParent(selectedID) = 0) {
        MoveCategory(selectedID, -1)
    } else {
        MoveRPLine(selectedID, -1)
    }
;    Gosub ReloadRPLinesTreeView
return

MoveRPLineDown:
    global lastEditedPreset, lastEditedRPLine, lastEditedRPLineIndex
    selectedID := TV_GetSelection()
    if (selectedID = 0) {
        MsgBox, 48, Error, "Please select an RP line to move."
        return
    }
    if (TV_GetParent(selectedID) = 0) {
        MoveCategory(selectedID, 1)
    } else {
        MoveRPLine(selectedID, 1)
    }
;    Gosub ReloadRPLinesTreeView
return

MoveCategory(selectedID, direction) {
    global vRPLines, lastEditedPreset, lastEditedRPLine, lastEditedRPLineIndex, expandCategory
    TV_GetText(selectedItem, selectedID)
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%

    ; Convert content to an array of lines
    lines := StrSplit(content, "`n", "`r")

    ; Create a list of categories and their RP lines
    categories := []
    currentCategory := ""
    currentRP := []
    presetsIndex := -1  ; Track the index of the [Presets] category

    for index, line in lines {
        if (SubStr(Trim(line), 1, 1) = "[") {
            if (currentCategory != "") {
                categories.Push({Category: currentCategory, Lines: currentRP})
            }
            currentCategory := line
            currentRP := []
            if (currentCategory = "[Presets]") {
                presetsIndex := categories.MaxIndex() + 1  ; Set the index of the [Presets] category
            }
        } else {
            currentRP.Push(line)
        }
    }

    if (currentCategory != "") {
        categories.Push({Category: currentCategory, Lines: currentRP})
    }

    ; Find the selected category index
    selectedIndex := -1
    for index, category in categories {
        if (Trim(category.Category) = "[" . Trim(selectedItem) . "]") {
            selectedIndex := index
            break
        }
    }

    if (selectedIndex = -1) {
        MsgBox, 48, Error, "Selected category not found."
        return
    }

    ; Determine the target index
    targetIndex := selectedIndex + direction

    ; Skip over the [Presets] category if encountered
    if (targetIndex = presetsIndex) {
        targetIndex += direction  ; Move twice to skip over the [Presets] category
    }

    ; Check boundaries after moving
    if (targetIndex < 1 or targetIndex > categories.MaxIndex()) {
        return  ; Out of bounds
    }

    ; Swap the categories
    temp := categories[selectedIndex]
    categories[selectedIndex] := categories[targetIndex]
    categories[targetIndex] := temp

    ; Rebuild the content
    newContent := ""
    for index, category in categories {
        newContent .= category.Category . "`n"
        for _, rpLine in category.Lines {
            newContent .= rpLine . "`n"
        }
    }

    ; Write the updated content back to the file
    FileDelete, %TxtFile%
    FileAppend, %newContent%, %TxtFile%

    ; Store the last edited preset/category
    lastEditedPreset := selectedItem
    lastEditedRPLine := ""
    lastEditedRPLineIndex := selectedID
    expandCategory := false  ; Do not expand the category
    Gosub ReloadRPLinesTreeViewForMove  ; Use the optimized reload function for moving
}


MoveRPLine(selectedID, direction) {
    global vRPLines, lastEditedPreset, lastEditedRPLine, lastEditedRPLineIndex, expandCategory
    parentID := TV_GetParent(selectedID)
    TV_GetText(selectedItem, selectedID)
    TV_GetText(parentItem, parentID)
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%

    ; Convert content to an array of lines
    lines := StrSplit(content, "`n", "`r")

    ; Find the parent category in the file
    parentIndex := -1
    for index, line in lines {
        if (Trim(line) = "[" . Trim(parentItem) . "]") {
            parentIndex := index
            break
        }
    }
    if (parentIndex = -1) {
        MsgBox, 48, Error, "Parent category not found in file."
        return
    }

    ; Find the RP line within the parent category
    rpIndex := -1
    startIndex := parentIndex + 1
    endIndex := lines.MaxIndex()
    for index, line in lines {
        if (index < startIndex) {
            continue
        }
        if (Trim(line) = "" or SubStr(Trim(line), 1, 1) = "[") {
            break
        }
        if (Trim(line) = Trim(selectedItem)) {
            rpIndex := index
            break
        }
    }
    if (rpIndex = -1) {
        MsgBox, 48, Error, "Selected RP line not found in file."
        return
    }

    ; Calculate the target index
    targetIndex := rpIndex + direction
    if (targetIndex < startIndex or targetIndex > endIndex or Trim(lines[targetIndex]) = "" or SubStr(Trim(lines[targetIndex]), 1, 1) = "[") {
        return  ; Out of bounds or empty line or next category
    }

    ; Swap the lines in the array
    temp := lines[targetIndex]
    lines[targetIndex] := lines[rpIndex]
    lines[rpIndex] := temp

    ; Write the updated content back to the file
    newContent := StrJoin("`n", lines)
    FileDelete, %TxtFile%
    FileAppend, %newContent%, %TxtFile%

    ; Store the last edited preset/category and RP line
    lastEditedPreset := parentItem
    lastEditedRPLine := selectedItem
    lastEditedRPLineIndex := selectedID
    expandCategory := true  ; Expand the category
;    Gosub SanitizeFile
    Gosub ReloadRPLinesTreeViewForMove  ; Use the optimized reload function for moving
}


TreeEditRPLines:
    global selectedText, originalRPLine, editing, selectedRPLineIndex, lastEditedPreset  ; Declare variables as global
    Gosub, CheckTickBoxAndClose ; Check the checkbox state and close the GUI if needed
    Gui, TreeEditRPLine:New, +OwnDialogs
    Gui, Add, TreeView, vRPLineTreeView w800 h434 gRPLineTreeViewSelect  ; Adjust height to allow space for buttons at the bottom
    Gui, Add, Button, x820 y4 w150 h30 gAddCategory, Add Category  ; Add Add Category button
    Gui, Add, Button, x820 y44 w150 h30 gAddRPLine, Add RP Line  ; Add Add RP Line button
    Gui, Add, Button, x820 y200 w150 h30 gDeleteSelected, Delete  ; Add Delete button
    Gui, Add, Button, x820 y310 w150 h30 gMoveRPLineUp, Move Up  ; Add Move Up button
    Gui, Add, Button, x820 y350 w150 h30 gMoveRPLineDown, Move Down  ; Add Move Down button
    Gui, Add, Button, x820 y160 w150 h30 gTreeEditRPLineEdit, Edit  ; Add Edit button
    Gui, Add, Button, x820 y410 w150 h30 gCloseTreeEditRPLineGUI, Done  ; Add Done button to close the GUI
    ; Load RP lines into the TreeView with children
    LoadRPLinesToTreeView(true, true, false)
    Gosub SanitizeFile
    GuiTitle := "Edit RP Lines and Categories"
    Gui, TreeEditRPLine:Show, w980 h450, %GuiTitle%
return

TreeEditRPLineEdit:
    global vRPLines, lastEditedPreset, lastEditedRPLine, lastEditedRPLineIndex, expandCategory, selectedText, originalRPLine, editing, selectedRPLineIndex

    Gui, TreeEditRPLine:Submit, NoHide
    selectedID := TV_GetSelection()
    if (selectedID = 0) {
        MsgBox, 48, Error, "Please select an RP line or category to edit."
        return
    }

    TV_GetText(selectedItem, selectedID)
    parentID := TV_GetParent(selectedID)

    if (parentID = 0) {
        ; Check if the selected category is "Default Variable Values"
        if (selectedItem = "Default Variable Values") {
            MsgBox, 48, Error, "Default Variable Value category name cannot be changed."
            return
        }

        ; Editing a category
        InputBox, newCategoryName, Edit Category, Please edit the category name below:, , 400, 150,,,, , %selectedItem%
        if (ErrorLevel) {
            return  ; User cancelled input
        }

        if (newCategoryName = "") {
            MsgBox, 48, Error, "Category name cannot be empty."
            return
        }

        ; Update the category name in the file
        TxtFile := A_ScriptDir "\" vRPLines
        FileRead, content, %TxtFile%
        newContent := ""
        isUpdated := false

        Loop, Parse, content, `n, `r
        {
            line := Trim(A_LoopField)
            if (line = "[" . Trim(selectedItem) . "]") {
                line := "[" . newCategoryName . "]"
                isUpdated := true
            }
            newContent .= line "`n"
        }

        if (!isUpdated) {
            MsgBox, 48, Error, "Failed to update the category."
            return
        }

        FileDelete, %TxtFile%
        FileAppend, %newContent%, %TxtFile%
        lastEditedPreset := newCategoryName  ; Store the last edited category
        lastEditedRPLine := ""
        lastEditedRPLineIndex := selectedID
        expandCategory := false  ; Do not expand the category after editing
        Gosub ReloadRPLinesTreeView
    } else {
        ; Editing an RP line
        TV_GetText(selectedRPLine, selectedID)
        TV_GetText(selectedText, parentID)  ; Get the name of the parent category
        originalRPLine := selectedRPLine

        ; Check if the parent category is "Default Variable Values"
        if (selectedText = "Default Variable Values") {
            ; Extract variable name and default value from selectedRPLine
            RegExMatch(selectedRPLine, "^\{(.+?)\} = (.+)$", match)
            CustomVarName := match1
            CustomVarValue := match2

            ; Create the custom GUI for editing default variable values
            Gui, EditRPLine:New, +OwnDialogs +AlwaysOnTop
            Gui, Font, s11, Segoe UI Semibold
            Gui, Color, C0C0C0

            ; Add GroupBox for organization
            Gui, Add, GroupBox, x10 y10 w360 h132, Edit Default Variable Value

            ; Label and input for Variable Name
            Gui, Add, Text, x20 y40 w160, Variable Name:
            Gui, Add, Edit, vCustomVarName x20 y60 w160 h26 -Wrap, %CustomVarName%

            ; Label and input for Default Value
            Gui, Add, Text, x190 y40 w160, Default Value:
            Gui, Add, Edit, vCustomVarValue x190 y60 w160 h26 -Wrap, %CustomVarValue%

            ; Centered Submit button below inputs
            Gui, Add, Button, x114 y100 w140 h30 Default gSubmitEditRPLine, Submit

            ; Show the custom GUI window
            Gui, Show, w380 h150, Edit Default Variable Value
        } else {
            ; Standard RP line edit for other categories
            Gui, EditRPLine:New, +OwnDialogs
            Gui, Font, s10, Segoe UI  ; Set a modern font with a decent size
            
            ; Add a label for instruction on the left side
            Gui, Add, Text, x10 y10 w400, Please edit the RP line below:
            
            ; Add a single-line edit control for the RP line input on the left side
            Gui, Add, Edit, vEditedRPLine x10 y40 w740 h110 -Wrap HScroll, %selectedRPLine%
            
            ; Add buttons vertically on the right side
            Gui, Add, Button, x760 y40 w150 h30 gInsertCustomVariableEdit, Add Custom Variable
            Gui, Add, Button, x760 y80 w150 h30 gSpecialVarsEditLine, Special Variables
            Gui, Add, Button, x760 y120 w150 h30 Default gSubmitEditRPLine, Submit

            ; Adjust the window size and set the title dynamically
            GuiTitle := "Edit RP Line in '" . selectedText . "'"
            Gui, Show, w920 h170, %GuiTitle%
        }
    }
return









InsertCustomVariableEdit:
    InputBox, CustomVar, Add Custom Variable, Please enter the custom variable name:, , 220, 130
    if (ErrorLevel = 0 && CustomVar != "") {
        GuiControlGet, editedRPLine, , EditedRPLine
        GuiControl, , EditedRPLine, %editedRPLine%{%CustomVar%}
        GuiControl, Focus, EditedRPLine
        SendInput {End}
    }
return






SubmitEditRPLine:
    Gui, Submit, NoHide ; Submit changes made in the Edit RP line GUI

    ; Check if we are editing a line in the Default Variable Values category
    if (selectedText = "Default Variable Values") {
        ; Combine the variable name and value into the correct format
        EditedRPLine := "{" . CustomVarName . "} = " . CustomVarValue
    } else {
        ; Standard RP line input - merge multiple lines into one
        EditedRPLine := Trim(EditedRPLine)
        EditedRPLine := StrReplace(EditedRPLine, "`n", " ") ; Replace newlines with spaces
    }

    ; Read the entire TXT file containing the RP lines
    FileRead, txtData, %vRPLines%

    ; Locate the section corresponding to the selected category
    sectionStart := InStr(txtData, "[" . selectedText . "]")
    if (sectionStart = 0) {
        MsgBox, 48, Error, "Failed to locate the category in the file."
        return
    }

    ; Determine where the section ends
    sectionEnd := InStr(txtData, "`n[", false, sectionStart + StrLen(selectedText) + 2)
    if (sectionEnd = 0) {
        sectionEnd := StrLen(txtData) + 1 ; End of the file
    }

    ; Extract the section's content
    sectionContent := SubStr(txtData, sectionStart, sectionEnd - sectionStart)

    ; Locate and replace the original RP line only within the section
    sectionContent := StrReplace(sectionContent, "`n" . originalRPLine, "`n" . EditedRPLine)

    ; Reconstruct the updated file content
    txtData := SubStr(txtData, 1, sectionStart - 1) . sectionContent . SubStr(txtData, sectionEnd)

    ; Write the updated data back to the TXT file
    FileDelete, %vRPLines% ; Delete the original TXT file
    FileAppend, %txtData%, %vRPLines% ; Append the updated data to a new TXT file

    ; Store the last edited preset/category and RP line
    lastEditedPreset := selectedText
    lastEditedRPLine := EditedRPLine
    lastEditedRPLineIndex := selectedID
    expandCategory := true  ; Ensure the category is expanded after editing

    ; Close the Edit RP line GUI
    Gui, EditRPLine:Destroy

    ; Update the TreeView to reflect the changes
    Gosub ReloadRPLinesTreeView

    ; Reopen the Edit Preset GUI to reflect the changes
    Gui, RPLine:Destroy  ; Close the RP line addition GUI
return




CancelEditRPLine:
    Gui, EditRPLine:Destroy
return

; Function to reload RP lines and refresh the GUI
ReloadRPLinesTreeView:
    Gui, TreeEditRPLine:Destroy  ; Close the current TreeEditRPLine GUI
    Gosub TreeEditRPLines  ; Reopen the TreeEditRPLine GUI
    LoadDefaultVariableValues()

    ; Find the last edited category and optionally expand it
    if (lastEditedPreset != "") {
        parentItem := TV_GetChildByName(vRPLineTreeView, lastEditedPreset)
        if (parentItem) {
            if (expandCategory) {
                TV_Modify(parentItem, "Expand")
                ; Find and select the last edited RP line within the expanded category
                childID := TV_GetChild(parentItem)
                while (childID) {
                    TV_GetText(childText, childID)
                    if (Trim(childText) = Trim(lastEditedRPLine)) {
                        TV_Modify(childID, "Select")
                        break
                    }
                    childID := TV_GetNext(childID)
                }
            }
            ; If no specific RP line was selected, or if not expanding, select the category itself
            if (lastEditedRPLine = "" or !expandCategory) {
                TV_Modify(parentItem, "Select")
            }
        }
    }
return

ReloadRPLinesTreeViewForMove:
    ; Path to the RP lines file
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%

    ; Clear the existing TreeView
    GuiControl, -Redraw, RPLineTreeView  ; Temporarily suspend redrawing for performance
    TV_Delete("RPLineTreeView")  ; Clear the TreeView

    ; Rebuild the TreeView
    currentParent := ""
    lastEditedPresetID := ""
    lastEditedRPLineID := ""

    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        if (line = "" || SubStr(line, 1, 1) = ";")
            continue  ; Skip empty lines and comments

        ; Exclude the [Presets] category from being added to the TreeView
        if (SubStr(line, 1, 9) = "[Presets]") {
            currentParent := ""  ; Ensure that no RP lines under [Presets] are added
            continue
        }

        if (SubStr(line, 1, 1) = "[") {
            ; Remove brackets when adding category name to TreeView
            categoryName := SubStr(line, 2, -1)
            currentParent := TV_Add(categoryName, "")  ; Add category as parent item
            if (categoryName = lastEditedPreset) {
                lastEditedPresetID := currentParent  ; Store the ID of the last edited category
            }
            continue
        }

        ; Add the RP lines as children of the current category
        if (currentParent != "") {
            childItem := TV_Add(line, currentParent)
            if (Trim(line) = Trim(lastEditedRPLine)) {
                lastEditedRPLineID := childItem  ; Store the ID of the last edited RP line
            }
        }
    }

    ; Re-highlight the last edited category or RP line
    if (lastEditedRPLineID) {
        TV_Modify(lastEditedRPLineID, "Select")  ; Select the last edited RP line
        TV_Modify(lastEditedPresetID, "Expand")  ; Expand only if an RP line was selected
        TV_Modify(lastEditedRPLineID, "Focus")  ; Ensure focus is set for proper highlighting
    } else if (lastEditedPresetID) {
        TV_Modify(lastEditedPresetID, "Select")  ; Select the last edited category
        TV_Modify(lastEditedPresetID, "Focus")  ; Ensure focus is set for proper highlighting
    }

    ; Set focus to the TreeView control
    GuiControl, Focus, RPLineTreeView
    ; Ensure the selected item is in view
    TV_Modify(TV_GetSelection(), "EnsureVisible")
    GuiControl, +Redraw, RPLineTreeView  ; Resume redrawing
return




; Function to close the TreeEditRPLine GUI
CloseTreeEditRPLineGUI:
    Gui, TreeEditRPLine:Destroy
    GoSub, RecreateGUI
return


CreatePreset:
    ; Open a new GUI to create a new preset
    Gui, CreatePreset:New, +AlwaysOnTop -SysMenu
    Gui, Add, Text, , Enter Preset Name:
    Gui, Add, Edit, vPresetName w130
    Gui, Add, Button, Default gSaveNewPreset x10 y+10, Save Preset
    Gui, Add, Button, gCancelNewPreset x+12 yp, Cancel  ; Place Cancel button next to Save button using x+ and yp
    Gui, Show, w150 h90, Create New Preset
return


SaveNewPreset:
    Gui, Submit, NoHide  ; Get data from GUI fields
    if (PresetName = "") {
        MsgBox, 48, Error, "Please enter a valid preset name."
        return
    }

    ; Path to the RP lines file
    TxtFile := A_ScriptDir "\" vRPLines

    ; Read the entire content of the text file
    FileRead, content, %TxtFile%

    ; Find the [Presets] section and append the new preset name
    position := InStr(content, "[Presets]")
    if (position = 0) {  ; If the [Presets] section does not exist, append it at the end
        content .= "`n[Presets]`n" . PresetName . ";"
    } else {  ; Otherwise, insert the new preset
        sectionEnd := InStr(content, "`n", true, position)
        part1 := SubStr(content, 1, sectionEnd)
        part2 := SubStr(content, sectionEnd + 1)
        content := part1 . PresetName . ";`n" . part2
    }

    ; Write the modified content back to the file
    FileDelete, %TxtFile%  ; Delete the old file to avoid appending
    FileAppend, %content%, %TxtFile%  ; Write the new content

    Gui, CreatePreset:Destroy

    ; Explicitly call the reload function to refresh the TreeView
    Gosub ReloadPresetsTreeView
    Gosub PresetRP  ; Reopen the PresetRP GUI and expand the last edited preset

return

; Handler for the Cancel button in CreatePreset GUI
CancelNewPreset:
    Gui, CreatePreset:Destroy
return



InitTestGui() {
    global TestGui := "TestTypingGui"  ; Name of the test GUI
    global TestEdit  ; Declare TestEdit as global

    ; Destroy any existing instance of the Test GUI to avoid conflicts
    Gui, %TestGui%:Destroy
    
    ; Create a new instance of the Test GUI
    Gui, %TestGui%:New, +AlwaysOnTop +Resize +ToolWindow -MaximizeBox, Test Mode
    Gui, Add, Edit, x10 y10 w580 h180 vTestEdit
    Gui, %TestGui%:Show, w600 h200, Test Mode Window
}

UpdateTestGui(TextToAppend) {
    global TestEdit
    ; Ensure the control exists before attempting to update it
    if (TestEdit != "")
        GuiControl, , %TestEdit%, %TextToAppend%`n
}







GetRandomLineFromCategory(category, content) {
    global stopSending  ; Ensure stopSending is globally accessible
    lineFound := false
    cleanedLines := []
    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        if (line = "[" . category . "]") {
            lineFound := true
            continue
        }
        if (lineFound && SubStr(line, 1, 1) = "[")  ; Encountered the start of the next category
            break
        if (lineFound && line != "" && SubStr(line, 1, 1) != ";") {
            cleanedLines.Push(line)
        }
    }

    if (cleanedLines.MaxIndex() > 0) {
        Random, rand, 1, cleanedLines.MaxIndex()
        return cleanedLines[rand]
    } else {
        ; Show a message box if no matching category name or lines are found
        MsgBox, 48, Category Not Found, Category "%category%" could not be found. Please verify the category name and try again.
        
        ; Trigger stopSending and call StopTypingFunction to cancel ongoing actions
        stopSending := 1
        StopTypingFunction()
        
        return ""  ; Return an empty string to prevent further actions
    }
}





; This function handles the recreation of the GUI, allowing changes to be reflected immediately in the interface.
RecreateGUI:
    ; The existing GUI are destroyed to make room for the new GUI.

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


WM_EXITSIZEMOVE(wParam, lParam, msg, hwnd) {
    global floatingGuiHwnds, floatingGuiPositions, fullSizeGuiX, fullSizeGuiY, fullSizeGuiW, fullSizeGuiH
    global compactGuiX, compactGuiY, compactGuiW, compactGuiH

    ; Check if the moved window is the FullSize GUI
    if (hwnd = WinExist("RP Menu")) { 
        ; Get the new position and update the stored position
        WinGetPos, newX, newY,,, A
        fullSizeGuiX := newX
        fullSizeGuiY := newY

        ; Get the new size and update stored size
        WinGetPos, , , newW, newH, A
        fullSizeGuiW := newW
        fullSizeGuiH := newH

        ; Update controls within the FullSize GUI as needed
        listViewMainW := newW - 20
        listViewMainH := newH - 90
        resizeBoxMainY := newH - 4
        GuiControl, Move, RPLines, w%listViewMainW% h%listViewMainH%
        GuiControl, Move, ResizeBox, y%resizeBoxMainY%
        GuiControl, Move, HandleDragOrResizeText, y%resizeBoxMainY%

    ; Check if the moved window is the Compact GUI
    } else if (hwnd = WinExist("Compact RP Menu")) { 
        ; Get new position and size and update stored values
        WinGetPos, newX, newY, newW, newH, A
        compactGuiX := newX
        compactGuiY := newY
        compactGuiW := newW
        compactGuiH := newH

        ; Update controls within the Compact GUI as needed
        listViewW := newW - 19
        listViewH := newH - 68
        resizeBoxY := newH - 4
        GuiControl, Move, RPLines, w%listViewW% h%listViewH%
        GuiControl, Move, ResizeBox, y%resizeBoxY%
        GuiControl, Move, HandleDragOrResizeText, y%resizeBoxY%

    ; Check if the moved window is one of the floating GUIs
    } else if floatingGuiHwnds.HasKey(hwnd) {
        ; Get the associated GUI name
        guiName := floatingGuiHwnds[hwnd]
        
        ; Get the new position of the floating GUI and update stored position
        WinGetPos, newX, newY,,, ahk_id %hwnd%
        floatingGuiPositions[guiName] := { "X": newX, "Y": newY }
    }
}


; This function alters the 'closeOnSelectState' variable. The closeOnSelectState dictates whether the GUI will close after a RP Line has been selected.
ToggleCloseOnSelect:
    closeOnSelectState := !closeOnSelectState ; Flip the state of 'closeOnSelectState'
    Gosub, UpdateAlwaysOnTopState ; Update the 'Always On Top' state according to the new 'closeOnSelectState'
return


; This function switches the GUI between full size and compact modes.
ToggleCompactMode:
    global activeGuiName, fullSizeGuiX, fullSizeGuiY, compactGuiX, compactGuiY, floatingGuis

    GuiControlGet, tickboxStateCompact, , CheckboxVar2 ; Fetch the current state of the compact mode toggle

    ; If compact mode is currently enabled
    if (tickboxStateCompact) {
        ; Check that the active GUI is the main GUI, not a floating GUI
        if (activeGuiName = "FullSizeGui") {
            ; Set the active GUI to the main GUI and record its position
            Gui, FullSizeGui:+LastFound
            WinGetPos, FullSizeGuiX, FullSizeGuiY
            fullSizeGuiX := FullSizeGuiX
            fullSizeGuiY := FullSizeGuiY

            ; Destroy the main GUI and switch to compact mode
            Gui, FullSizeGui:Destroy
        }

        ; Open the compact GUI
        CompactGui()
    } 
    else {
        ; Check that the active GUI is the compact GUI, not a floating GUI
        if (activeGuiName = "CompactGui") {
            ; Set the active GUI to the compact GUI and record its position
            Gui, CompactGui:+LastFound
            WinGetPos, CompactGuiX, CompactGuiY
            compactGuiX := CompactGuiX
            compactGuiY := CompactGuiY

            ; Destroy the compact GUI and switch back to full-size mode
            Gui, CompactGui:Destroy
        }

        ; Open the main GUI
        Gosub, FullSizeGui

        ; Reset the 'tickboxStateCompact' variable when transitioning from CompactGUI to FullSizeGui
        tickboxStateCompact := 0
    }
return




; Main GUI for the Compact RP Menu
CompactGui() {
    ; Setup of the Compact GUI: AlwaysOnTop attribute is determined by the state of closeOnSelectState
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

    ; Add a query input field to search
    Gui, Add, Edit, x8 y8 w140 h20 vQuery gSearchAllCompact +WantReturn

    ; Replace ListView with TreeView control for displaying RP Sections and RP Lines
    Gui, Add, TreeView, x%listViewX% y%listViewY% w%listViewW% h%listViewH% vRPLines gSelectRPFromTreeViewCompact BackgroundE0FFFC,

    ; Add Compact Mode and "Always On Top" toggles
    Gui, Add, CheckBox, x260 y42 vCheckboxVar2 gToggleCompactMode Checked%tickboxStateCompact%, Compact
 
    ; Add an additional input box (with its font and label)
    Gui, CompactGui:Font, s8, Microsoft Sans Serif
    Gui, CompactGui:Font, s8, Segoe UI Semibold

    ; Add a checkbox for keeping the GUI open after a RP Line is selected
    Gui, Add, CheckBox, x178 y42 vCloseOnSelectVar gToggleCloseOnSelect Checked%closeOnSelectState%, Keep Open

    ; Add the Test Mode checkbox
    Gui, Add, CheckBox, x114 y42 vTestModeCheckbox gToggleTestMode Checked%TestModeEnabled%, Testing

    ; Conditionally show or hide the input box and label based on tickboxState
    if (!tickboxState) {
        GuiControl, Hide, SpeakerLabel
        GuiControl, Hide, AdditionalInput
    }

    Gui, Add, Slider, x246 y3 w80 h18 vTransparencySlider Range50-255 gAdjustTransparency Thick18 +gShowCustomTooltip Invert
    GuiControl, , TransparencySlider, %GUITransparency%
    Gui, Add, Text, x180 y6, Transparent :

    ; Add controls for RP Line manipulation and GUI resize
    Gui, Add, Progress, x%resizeBoxX% y%resizeBoxY% w360 h4 Background000000 Disabled vResizeBox,
    Gui, Add, Text, xp yp wp hp BackgroundTrans 0x201 vHandleDragOrResizeText gHandleDragOrResize,

    ; Add the GUI border
    DRAW_OUTLINE("CompactGui", 0, 0, 335, 153)

    Gui, CompactGui:Font, Bold s11, Microsoft Sans Serif 

    ; Edit button
    Gui, Add, GroupBox, x10 y38 w18 h18 Border c000000, ; This is the border around the progress bar
    Gui, Add, Button, x11 y39 w16 h16 gTreeEditRPLines vEditRPButton, E

    ; Rrandom button
    Gui, Add, GroupBox, x30 y38 w18 h18 Border c000000, ; This is the border around the progress bar
    Gui, Add, Button, x31 y39 w16 h16 vRandomRPButton gRandomRP, R

    ; Presets button
    Gui, Add, GroupBox, x70 y38 w18 h18 Border c000000, ; This is the border around the progress bar
    Gui, Add, Button, x71 y39 w16 h16 gOpenPresetRP vPresetRPButton, P

    ; Help button
    Gui, Add, GroupBox, x90 y38 w18 h18 Border c000000, ; This is the border around the progress bar
    Gui, Add, Button, x91 y39 w16 h16 gOpenHelpGUI vHelpMenuButton, H

    Gui, CompactGui:Font, s18, Times New Roman
    Gui, CompactGui:Font, s8, Segoe UI Semibold

    ; Set the initial transparency for the compact GUI
    SetGuiTransparency("CompactGui", GUITransparency)

    ; Set the active GUI to CompactGui and update the AlwaysOnTop state
    SetActiveGuiName("CompactGui")
    Gosub, UpdateAlwaysOnTopState

    ; Load RP lines into the TreeView with children
    LoadRPLinesToTreeView(true, true, true)

    ; Displaying the compact GUI
    if (compactGuiX = 0 and compactGuiY = 0) {
        Gui, Show, w335 h153, Compact RP Menu
        Gosub, StoreCompactGuiValues
    } else {
        compactGuiW := (compactGuiW = 0) ? 335 : compactGuiW
        compactGuiH := (compactGuiH = 0) ? 153 : compactGuiH
        Gui, Show, x%compactGuiX% y%compactGuiY% w%compactGuiW% h%compactGuiH%, Compact RP Menu
    }

    ; Set the transparency for the compact GUI again after it has been shown
    SetGuiTransparency("CompactGui", GUITransparency)

    ; Sets the cursor on the search bar by default
    GuiControl, Focus, Query
    Hotkey, IfWinActive, Compact RP Menu
    Hotkey, Enter, ButtonOKCompact, UseErrorLevel
}



; Detect Enter key press in TreeView and call SelectRPFromTreeViewCompact function
ButtonOKCompact:
    ; Get the control that currently has keyboard focus
    Gui, %activeGuiName%:Default
    GuiControlGet, FocusedControl, FocusV

    ; If Enter is pressed in the search box, expand all categories in the TreeView
    if (FocusedControl = "Query") {
        ExpandAllTreeViewCompact()
    } else if (FocusedControl = "RPLines") {
        ; Call the SelectRPFromTreeViewCompact function and pass "Enter" as an argument
        SelectRPFromTreeViewCompact("Enter")
    }
return

; Function to expand all nodes in the TreeView for CompactGui
ExpandAllTreeViewCompact() {
    Gui, %activeGuiName%:Default
    itemID := TV_GetNext(0)
    While (itemID) {
        TV_Modify(itemID, "Expand")  ; Expand each item in the TreeView
        itemID := TV_GetNext(itemID)
    }
}


; Function to handle the selection of an RP line from the TreeView in CompactGui
SelectRPFromTreeViewCompact(eventType := "") {
    if (eventType != "Enter" && A_GuiEvent != "DoubleClick") {
        return
    }

    selectedID := TV_GetSelection()
    if (!selectedID) ; No item selected
        return

    ; Check if the user double-clicked on the expand/collapse arrow
    if (A_GuiEvent = "DoubleClick" && TV_GetChild(selectedID)) {
        return  ; Exit if the selected item is a category with children
    }

    ; Get the text of the selected item (RP line) and its parent (category)
    TV_GetText(RPToSend, selectedID)
    parentID := TV_GetParent(selectedID)
    TV_GetText(sectionNameForRP, parentID)

    ; Skip if the selection is a category or if the RP line is empty
    if (parentID = 0 || RPToSend = "")
        return

    ; Replace variables in the RP text
    RPToSend := ReplaceVariables(RPToSend, sectionNameForRP)
    RPToSend := ReplaceDateTime(RPToSend)
    if (RPToSend = "")
        return

    Gui, CompactGui:Submit, NoHide
    Gosub, CheckTickBoxAndClose

    ; Use the same process as in RunPreset to handle Test GUI mode
    if (TestModeEnabled) {
        InitTestGui()
    }

    RPToSend := ProcessSpecialCommands(RPToSend)
    SendMessagewithDelayFunction(RPToSend)
    if (TestModeEnabled) {
        UpdateTestGui(RPToSend)
    }
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
     if (CurrControl = "HelpMenuButton") {
        ToolTip, Help Menu
    } else if (CurrControl = "RandomRPButton") {
        ToolTip, Random RP Line
    } else if (CurrControl = "EditRPButton") {
        ToolTip, Edit RP Line
    } else if (CurrControl = "DeleteRPButton") {
        ToolTip, Delete RP Line
    } else if (CurrControl = "PresetRPButton") {
        ToolTip, Preset RP
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


; Display tooltip when HelpButtonRandomRP is pressed
DisplayToolTipForHelpButtonRandomRP:
    ToolTip,
    (LTrim
        Select a Category and submit for a random line from that category. 
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


; Detect Enter key press in TreeView and expand all categories if Enter is pressed
ButtonOK:
    ; Get the control that currently has keyboard focus
    Gui, %activeGuiName%:Default
    GuiControlGet, FocusedControl, FocusV

    ; If Enter is pressed in the search box, expand all categories in the TreeView
    if (FocusedControl = "Query") {
        ExpandAllTreeView()
    } else if (FocusedControl = "RPLines") {
        ; Call the appropriate SelectRPFromTreeView function and pass "Enter" as an argument
        if (activeGuiName = "FullSizeGui") {
            SelectRPFromTreeView("Enter")
        } else if (activeGuiName = "CompactGui") {
            SelectRPFromTreeViewCompact("Enter")
        }
    }
return

; Function to expand all nodes in the TreeView
ExpandAllTreeView() {
    Gui, %activeGuiName%:Default
    itemID := TV_GetNext(0)
    While (itemID) {
        TV_Modify(itemID, "Expand")  ; Expand each item in the TreeView
        itemID := TV_GetNext(itemID)
    }
}




SearchAll:
    ; Submit the current search query without hiding the GUI
    Gui, Submit, NoHide

    ; Clear the TreeView completely to prepare for fresh search results
    TV_Delete()  ; Deletes all items in the TreeView

    ; Full path to the TXT file
    TxtFile := A_ScriptDir "\" vRPLines

    ; Variables to track categories and filtering
    inPresetsSection := false  ; Flag to check if we are in the presets section
    parentItems := {}          ; Dictionary to keep track of added categories
    category := ""

    ; Read the TXT file line by line
    Loop, Read, %TxtFile%
    {
        currentLine := Trim(A_LoopReadLine)

        ; Handle category (section) headers
        if (SubStr(currentLine, 1, 1) = "[") {
            category := SubStr(currentLine, 2, StrLen(currentLine) - 2)  ; Extract category name
            inPresetsSection := (category = "Presets")  ; Skip Presets section
            continue
        }

        ; Skip presets, empty lines, and comments
        if (inPresetsSection || currentLine = "" || SubStr(currentLine, 1, 1) = ";")
            continue

        ; Check if the category or RP line matches the search query
        if (Query = "" || InStr(category, Query) || InStr(currentLine, Query)) {
            ; Add category if it hasn't been added already
            if (!parentItems.HasKey(category)) {
                parentItems[category] := TV_Add(category)  ; Add category as a parent and store its ID
                ; Collapse the category if the query is empty
                if (Query = "") {
                    TV_Modify(parentItems[category], "-Expand")
                }
            }
            ; Add the RP line as a child of the current category
            TV_Add(currentLine, parentItems[category])

        }
    }

return




SearchAllCompact:
    ; Submit the current search query without hiding the GUI
    Gui, CompactGui:Submit, NoHide

    ; Clear the TreeView completely to prepare for fresh search results
    TV_Delete()  ; Deletes all items in the TreeView

    ; Full path to the TXT file
    TxtFile := A_ScriptDir "\" vRPLines

    ; Variables to track categories and filtering
    inPresetsSection := false  ; Flag to check if we are in the presets section
    parentItems := {}          ; Dictionary to keep track of added categories
    category := ""

    ; Read the TXT file line by line
    Loop, Read, %TxtFile%
    {
        currentLine := Trim(A_LoopReadLine)

        ; Handle category (section) headers
        if (SubStr(currentLine, 1, 1) = "[") {
            category := SubStr(currentLine, 2, StrLen(currentLine) - 2)  ; Extract category name
            inPresetsSection := (category = "Presets")  ; Skip Presets section
            continue
        }

        ; Skip presets, empty lines, and comments
        if (inPresetsSection || currentLine = "" || SubStr(currentLine, 1, 1) = ";")
            continue

        ; Check if the category or RP line matches the search query
        if (Query = "" || InStr(category, Query) || InStr(currentLine, Query)) {
            ; Add category if it hasn't been added already
            if (!parentItems.HasKey(category)) {
                parentItems[category] := TV_Add(category)  ; Add category as a parent and store its ID
                ; Collapse the category if the query is empty
                if (Query = "") {
                    TV_Modify(parentItems[category], "-Expand")
                }
            }
            ; Add the RP line as a child of the current category if it matches or no query is provided
            TV_Add(currentLine, parentItems[category])

        }
    }

return



; Main function that orchestrates the variable replacement
ReplaceVariables(RPToSend, sectionName) {
    global WrappedText, guiOpen, GuiCanceled, variableValues, listGroupsGlobal
    GuiCanceled := false

    Gosub, CheckTickBoxAndClose
    
    ; Initialize totals for math operations
    totalAverage := 0
    averageCount := 0

    ; Step 1: Process special commands
    RPToSend := ProcessSpecialCommands(RPToSend)

    ; Step 2: Extract variables from the text
    variableList := ExtractVariables(RPToSend)

    ; Step 3: Show GUI for variable input if necessary
    ; Check if there are any variables or list groups to prompt
    if (variableList.Length() > 0 || listGroupsGlobal.Count() > 0) {
        userInputs := ShowVariableInputGUI(variableList, sectionName, RPToSend)
        if (GuiCanceled) {
            return ""
        }
    }

    ; Step 4: Process user inputs and replace variables in the text
    RPToSend := ProcessUserInputs(RPToSend, variableList, userInputs)

    ; Step 5: Final clean-up and return the modified text
    Gosub, UpdateAlwaysOnTopState
    return RPToSend
}

; Function to process user inputs and replace variables in the text
ProcessUserInputs(RPToSend, variableList, userInputs) {
    global variableValues, listGroupsGlobal

    ; Check if the line contains the {FormatNumbers} special variable
    FormatNumbersFlag := InStr(RPToSend, "{FormatNumbers}")

    ; Check if the line contains the {RoundNumbers} special variable
    RoundNumbersFlag := InStr(RPToSend, "{RoundNumbers}")

    ; Store user inputs into variableValues for easy replacement
    for variableName, userInput in userInputs {
        ; Replace actual newline characters with a space
        userInput := StrReplace(userInput, "`n", " ")

        ; Process NumberOfWeeksFromToday variable
        if (variableName = "NumberOfWeeksFromToday") {
            weeks := userInput
            if (IsNumber(weeks)) {
                NumberOfWeeksFromToday := A_Now
                NumberOfWeeksFromToday += weeks * 7, days
                FormatTime, formattedDate, %NumberOfWeeksFromToday%, MMMM d, yyyy
                userInput := formattedDate
            }
        }

        ; Process Loop variable and remove it from the text
        if (variableName = "Loop") {
            if IsNumber(userInput) {
                variableValues["Loop"] := userInput
            } else {
                variableValues["Loop"] := 1 ; Default to 1 if not a valid number
            }
            RPToSend := StrReplace(RPToSend, "{Loop}", "")  ; Remove {Loop} from the message
        }

        ; Store the processed userInput back to variableValues
        variableValues[variableName] := userInput
    }

    ; Handle List and Slider variable replacements using regular expressions
    ; Prepare a mapping of list/slider variables to their replacement values
    listVariableReplacements := {}

    for normalizedOptions, group in listGroupsGlobal {
        userSelection := group.userSelection

        ; For each occurrence of this group
        for index, occurrence in group.occurrences {
            variableName := occurrence.variableName
            optionsString := ""
            if (RegExMatch(variableName, "^\s*(List|Slider):\s*(.*)$", listMatch)) {
                optionsString := listMatch2
            }

            customOutputs := {}
            ; Parse options to get custom outputs
            loop, Parse, optionsString, `,
            {
                item := Trim(A_LoopField)
                if (RegExMatch(item, "^(.*?)\s*\(\s*(.*?)\s*\)\s*$", itemMatch)) {
                    displayName := Trim(itemMatch1)
                    customOutput := Trim(itemMatch2)
                } else {
                    displayName := item
                    customOutput := displayName  ; Default to display name if no custom output
                }
                customOutputs[displayName] := customOutput
            }

            ; Get the replacement text based on user's selection
            if (customOutputs.HasKey(userSelection)) {
                replacementText := customOutputs[userSelection]
            } else {
                replacementText := userSelection  ; Fallback to selection if no custom output
            }

            ; Map the variableName to the replacementText
            listVariableReplacements["{" variableName "}"] := replacementText
        }
    }

    ; Replace all list and slider variables in RPToSend
    for varPattern, replacementText in listVariableReplacements {
        ; Replace all occurrences of the list/slider variable pattern
        RPToSend := StrReplace(RPToSend, varPattern, replacementText)
    }

    ; Handle double curly bracket expressions
    while (Pos := RegExMatch(RPToSend, "\{\{\s*(.*?)\s*\}\}", exprMatch)) {
        expr := exprMatch1

        ; Check if the expression includes an equals sign, indicating an assignment
        if (InStr(expr, "=")) {
            ; Split the expression into the math part and the output assignment part
            StringSplit, parts, expr, =
            mathExpr := RTrim(parts1)
            outputVar := LTrim(parts2)

            ; Replace all variables within the math expression
            for variableName, variableValue in variableValues {
                mathExpr := StrReplace(mathExpr, "{" . variableName . "}", variableValue)
            }

            ; Evaluate the math expression
            result := EvaluateMathExpression(mathExpr)

            ; Apply rounding if {RoundNumbers} is present
            if (RoundNumbersFlag) {
                result := Round(result)
            }

            ; Save the result to MathOutputX if applicable
            if (RegExMatch(outputVar, "MathOutput(\d*)", match)) {
                mathOutputVar := (match1 != "" ? "MathOutput" match1 : "MathOutput")
                variableValues[mathOutputVar] := result  ; Update MathOutputX with the new value
            }

            ; Apply comma formatting to the result if {FormatNumbers} is present
            if (FormatNumbersFlag) {
                formattedResult := FormatNumberWithCommas(result)
            } else {
                formattedResult := result  ; No formatting needed
            }

            ; Replace the entire double curly bracket expression with the formatted result
            RPToSend := SubStr(RPToSend, 1, Pos - 1) . formattedResult . SubStr(RPToSend, Pos + StrLen(exprMatch))
        } else {
            ; No equals sign: Just evaluate and replace the expression without assigning to MathOutputX
            ; Replace all variables within the math expression
            for variableName, variableValue in variableValues {
                expr := StrReplace(expr, "{" . variableName . "}", variableValue)
            }

            ; Evaluate the math expression
            result := EvaluateMathExpression(expr)

            ; Apply rounding if {RoundNumbers} is present
            if (RoundNumbersFlag) {
                result := Round(result)
            }

            ; Apply comma formatting if needed
            if (FormatNumbersFlag) {
                formattedResult := FormatNumberWithCommas(result)
            } else {
                formattedResult := result  ; No formatting needed
            }

            ; Replace the entire double curly bracket expression with the formatted result
            RPToSend := SubStr(RPToSend, 1, Pos - 1) . formattedResult . SubStr(RPToSend, Pos + StrLen(exprMatch))
        }
    }

    ; Replace and process variables in the text
    for variableName, variableValue in variableValues {
        ; Apply rounding if {RoundNumbers} is present and variable is numeric
        if (RoundNumbersFlag && IsNumber(variableValue)) {
            variableValue := Round(variableValue)
        }

        ; Apply comma formatting if {FormatNumbers} is present and variable is numeric
        if (FormatNumbersFlag && IsNumber(variableValue)) {
            variableValue := FormatNumberWithCommas(variableValue)
        }

        ; Replace user input variables in the text
        RPToSend := StrReplace(RPToSend, "{" . variableName . "}", variableValue)
    }

    ; Finally, replace MathOutputX variables in the text with their saved values
    for key, value in variableValues {
        if (RegExMatch(key, "^MathOutput\d*$")) {
            ; Apply rounding if {RoundNumbers} is present
            if (RoundNumbersFlag) {
                value := Round(value)
            }

            ; Apply number formatting if {FormatNumbers} is present
            if (FormatNumbersFlag) {
                value := FormatNumberWithCommas(value)
            }

            RPToSend := StrReplace(RPToSend, "{" . key . "}", value)
        }
    }

    ; Remove {RoundNumbers} after it is applied
    RPToSend := StrReplace(RPToSend, "{RoundNumbers}", "")
    ; Remove {FormatNumbers} after it is applied
    RPToSend := StrReplace(RPToSend, "{FormatNumbers}", "")

    return RPToSend
}




ExtractVariables(RPToSend) {
    global listGroupsGlobal, listGroupOrder
    listGroupsGlobal := {}    ; Reset for the current line
    listGroupOrder := []      ; Reset the order list
    uniqueVariables := {}
    orderedVariables := []    ; To store variables in order
    skipTo := 0
    listGroups := {}          ; To store groups of List or Slider variables
    uniqueListGroupKeys := {}

    while (Pos := RegExMatch(RPToSend, "\{([^{}]+)\}", var, skipTo + 1)) {
        variableName := var1

        ; Ignore {Comment=} variables
        if (InStr(variableName, "Comment=")) {
            skipTo := Pos + StrLen(var0)
            continue
        }

        ; Skip special variables that do not require user input
        if !(variableName ~= "^(Average|AltHome|DoNotEnter|SendWithoutDelay|SendInstantly|FormatNumbers|SkipChatOpen|RandomNumber|RoundNumbers)$") {
            ; Handle List or Slider variables
            if (RegExMatch(variableName, "^\s*(List|Slider):\s*(.*?)\s*$", listMatch)) {
                varType := listMatch1
                optionsString := Trim(listMatch2)

                optionsArray := []  ; Array to store options for List/Slider
                normalizedOptions := ""
                label := ""         ; Optional label for Sliders or Lists

                ; Attempt to extract label from optionsString
                if (RegExMatch(optionsString, "^(.*?):\s*(.*)$", labelMatch)) {
                    label := Trim(labelMatch1)
                    optionsString := Trim(labelMatch2)
                }

                ; Now check for range
                if (RegExMatch(optionsString, "^\s*<([\d\.]+)-([\d\.]+)>$", rangeMatch)) {
                    startNum := rangeMatch1
                    endNum := rangeMatch2

                    ; Determine increment type (tenths for decimals)
                    increment := (InStr(startNum, ".") || InStr(endNum, ".")) ? 0.1 : 1

                    ; Generate the range of numbers as options
                    step := 0
                    While (startNum + step * increment <= endNum) {
                        optionValue := Round(startNum + step * increment, (increment < 1 ? 1 : 0)) ; Round appropriately
                        displayText := optionValue
                        option := { displayName: optionValue, outputValue: optionValue, displayText: displayText }
                        optionsArray.Push(option)
                        normalizedOptions .= (step = 0 ? "" : "|") . optionValue
                        step++
                    }
                } else {
                    ; Handle comma-separated options
                    Loop, Parse, optionsString, `,
                    {
                        item := Trim(A_LoopField)
                        displayName := ""
                        outputValue := ""

                        ; Check if the option includes optional output
                        if (RegExMatch(item, "^(.*?)\s*\(\s*(.*?)\s*\)\s*$", match)) {
                            displayName := Trim(match1)
                            outputValue := Trim(match2)
                        } else {
                            displayName := item
                            outputValue := displayName  ; Default to display name if no optional output
                        }

                        ; Build displayText
                        if (outputValue != displayName) {
                            displayText := displayName . " (" . outputValue . ")"
                        } else {
                            displayText := displayName
                        }

                        ; Store each option as an object with displayName, outputValue, and displayText
                        option := { displayName: displayName, outputValue: outputValue, displayText: displayText }
                        optionsArray.Push(option)

                        ; Build normalized options string for grouping
                        normalizedOptions .= (A_Index = 1 ? "" : "|") . displayName
                    }
                }

                ; Use normalizedOptions, varType, and label as the key for grouping
                key := varType . ":" . label . ":" . normalizedOptions

                ; Store the occurrence with its position and variable name
                occurrence := {}
                occurrence.position := Pos - StrLen(var0)
                occurrence.length := StrLen(var0)
                occurrence.variableName := variableName

                ; Check if this listGroup has been processed before
                if (!uniqueListGroupKeys.HasKey(key)) {
                    uniqueListGroupKeys[key] := true

                    ; Add to listGroups
                    listGroups[key] := { occurrences: [occurrence], options: optionsArray, type: varType, label: label }
                    listGroupOrder.Push(key)  ; Preserve order

                    ; Add to orderedVariables
                    orderedVariables.Push({ type: "listGroup", key: key, position: occurrence.position })
                } else {
                    ; Add occurrence to existing listGroup
                    listGroups[key].occurrences.Push(occurrence)
                }

                skipTo := Pos + StrLen(var0)
                continue
            }

            ; Skip any MathOutputX variables
            if (RegExMatch(variableName, "^MathOutput\d*$")) {
                skipTo := Pos + StrLen(var0)
                continue
            }

            ; For regular variables
            if (!uniqueVariables.HasKey(variableName)) {
                uniqueVariables[variableName] := true

                ; Add to orderedVariables
                orderedVariables.Push({ type: "variable", name: variableName, position: Pos - StrLen(var0) })
            }
        }

        ; Move to the next position after the current variable
        skipTo := Pos + StrLen(var0)
    }

    ; Sort orderedVariables based on position
    orderedVariables.Sort("a.position - b.position")

    ; Merge listGroups into listGroupsGlobal for the current run
    for key, group in listGroups {
        if (!listGroupsGlobal.HasKey(key)) {
            listGroupsGlobal[key] := { occurrences: group.occurrences, options: group.options, userSelection: "", type: group.type, label: group.label }
        } else {
            for index, occurrence in group.occurrences {
                listGroupsGlobal[key].occurrences.Push(occurrence)
            }
        }
    }

    return orderedVariables
}






; Function to evaluate mathematical expressions in strict sequence order
EvaluateMathExpression(expr, isListVar := false) {
    try {
        ; Replace commas with dots to ensure correct decimal handling
        expr := StrReplace(expr, ",", ".")

        ; Initialize variables
        total := 0.0
        operator := ""
        sum := 0.0
        count := 0

        ; Tokenize the expression and process it from left to right
        Loop {
            if !RegExMatch(expr, "^\s*(\d+(\.\d+)?|\{[^}]+\})(.*)", match) {
                break
            }
            number := match1
            expr := match3

            ; Handle the number, which can be a variable or a hard-coded value
            if (InStr(number, "{")) {
                number := StrReplace(number, "{", "")
                number := StrReplace(number, "}", "")
                number := variableValues[number]
            }

            ; Convert the number to a float to ensure accurate calculations
            number := StrReplace(number, ",", "") ; Remove any potential commas for thousands
            number := number + 0.0 ; Forces the conversion to a float

            if (operator = "") {
                total := number
            } else {
                ; Apply the operator to the running total
                if (operator = "+") {
                    total := total + number
                } else if (operator = "-") {
                    total := total - number
                } else if (operator = "*" || operator = "x") { 
                    total := total * number
                } else if (operator = "/") {
                    total := total / number
                } else if (operator = "%") {
                    total := (total * number) / 100
                } else if (operator = "@") {
                    sum := sum + number
                    count := count + 1
                    total := sum / count
                }
            }

            ; Check for the next operator
            if !RegExMatch(expr, "^\s*([\+\-\*/x%@])(.*)", match) { 
                break
            }
            operator := match1
            expr := match2
        }

        ; Round the result to 2 decimal places
        total := Round(total, 2)

        ; If the total is a whole number, return it without decimals, otherwise return with 2 decimals
        if (Mod(total, 1) = 0) {
            total := Floor(total)  ; Remove the decimal places if it's a whole number
        }

        ; Return the result without formatting (commas) unless specified later
        return total
    } catch {
        return "Error"
    }
}








; Function to dynamically execute an expression string
DynaRun(exec) {
    try {
        ; Execute the dynamically created command string
        return %exec%
    } catch {
        return false
    }
}


ShowVariableInputGUI(orderedVariables, sectionName, RPToSend) {
    global WrappedText, variableValues, guiOpen, GuiCanceled, stopTyping, stopSending, listGroupsGlobal
    global previousSelections
    global controlVars  ; Declare controlVars as global

    guiOpen := true
    userInputs := {}

    ; Temporarily disable AlwaysOnTop for main GUI
    Gui, RandomRP:-AlwaysOnTop

    ; Calculate how many columns we'll have
    numVariables := orderedVariables.Length()
    maxRows := 10  ; Maximum number of rows before starting a new column
    numColumns := Ceil(numVariables / maxRows)
    wrapWidth := 400 + (numColumns - 1) * 430  ; Adjusted wrapWidth based on columns

    ; Prepare variables GUI with styling
    Gui, VariablesGUI:New, +AlwaysOnTop -SysMenu
    Gui, Font, s10, Segoe UI bold
    Gui, Color, C0C0C0
    Gui, VariablesGUI:Add, Text,, % "Entering variables for: " sectionName

    ; Truncate the "Selected Line" if it exceeds 200 characters
    MaxSelectedLineLength := 414
    if (StrLen(RPToSend) > MaxSelectedLineLength) {
        displaySelectedLine := SubStr(RPToSend, 1, MaxSelectedLineLength) . "..."
    } else {
        displaySelectedLine := RPToSend
    }

    ; Set the width of the Selected line and let it wrap naturally
    Gui, VariablesGUI:Add, Text, w%wrapWidth% vWrappedText, % "Selected line: " displaySelectedLine

    ; Adjust layout based on wrapped text height
    GuiControlGet, WrappedText, VariablesGUI:
    lines := Ceil(StrLen(WrappedText) / (wrapWidth / 10))
    lineHeight := 10
    additionalOffset := lines * lineHeight
    leftPadding := 12
    xOffset := leftPadding
    baseYOffset := 60 + additionalOffset
    yTextOffset := baseYOffset

    ; Initialize variable index for GUI controls
    guiVarIndex := 1

    controlVars := {}  ; Map to store control variable names and associated data

    ; Keep track of which variables have been prompted to avoid duplicates
    promptedVariables := {}

    ; Now, create the GUI controls, arranging them into columns
    maxRows := 10  ; Maximum number of rows per column
    column := 0
    row := 0
    xOffset := leftPadding
    yTextOffset := baseYOffset

    for index, variableData in orderedVariables {
        if (row >= maxRows) {
            row := 0
            column += 1
            xOffset := leftPadding + column * 430  ; Adjust xOffset for new column
            yTextOffset := baseYOffset
        }
    
        groupBoxWidth := 420
        groupBoxX := xOffset
        groupBoxY := yTextOffset
        groupBoxHeight := 80
    
        Gui, VariablesGUI:Add, GroupBox, x%groupBoxX% y%groupBoxY% w%groupBoxWidth% h%groupBoxHeight%,
    
        controlVarName := "ListControlVar" . guiVarIndex
    
        if (variableData.type = "variable") {
            variableName := variableData.name
    
            ; Check if we already prompted for this variable
            if (promptedVariables.HasKey(variableName)) {
                continue
            }
            promptedVariables[variableName] := true
    
            ; Adjust elements for variable input
            innerElementX := groupBoxX + (groupBoxWidth - 400) / 2 ; Center the 400-width elements
            yInnerTextOffset := groupBoxY + 20
            yInnerEditOffset := groupBoxY + 40
    
            Gui, VariablesGUI:Add, Text, x%innerElementX% y%yInnerTextOffset%, % "Enter " variableName ":"
            defaultValue := variableValues.HasKey(variableName) ? variableValues[variableName] : ""
            Gui, VariablesGUI:Add, Edit, x%innerElementX% y%yInnerEditOffset% w400 h30 v%controlVarName%, % defaultValue
    
            ; Store the control variable name and associated variable name
            controlVars[controlVarName] := { "type": "variable", "name": variableName }
        } else if (variableData.type = "listGroup") {
            key := variableData.key
    
            ; Check if we already prompted for this listGroup
            if (promptedVariables.HasKey(key)) {
                continue
            }
            promptedVariables[key] := true
    
            group := listGroupsGlobal[key]
    
            if (group.type = "List") {
                ; Adjust elements for List control
                innerElementX := groupBoxX + 10  ; Align to the left edge with padding
                yInnerTextOffset := groupBoxY + 10
                yInnerEditOffset := groupBoxY + 40
    
                ; Prepare the dropdown items
                dropdownItems := ""
                optionsArray := group.options
                previousSelectionIndex := 1  ; Default to the first item
    
                ; Check if a previous selection exists
                if (previousSelections.HasKey(key)) {
                    previousSelection := previousSelections[key]
                    ; Find the index of previousSelection in optionsArray
                    Loop, % optionsArray.Length() {
                        if (optionsArray[A_Index].displayName = previousSelection) {
                            previousSelectionIndex := A_Index
                            break
                        }
                    }
                }
    
                Loop, % optionsArray.Length() {
                    option := optionsArray[A_Index]
                    dropdownItems .= (A_Index = 1 ? "" : "|") . option.displayText
                }
    
                ; Use label if available, otherwise use a default prompt
                displayVariableText := group.label != "" ? group.label : "Select an option"
    
                ; Display the List dropdown
                Gui, VariablesGUI:Add, Text, x%innerElementX% y%yInnerTextOffset%, % displayVariableText ":"
                Gui, VariablesGUI:Add, DropDownList, x%innerElementX% y%yInnerEditOffset% w400 h300 v%controlVarName% Choose%previousSelectionIndex%, % dropdownItems
    
                ; Store the control variable name and associated list group key
                controlVars[controlVarName] := { "type": "listGroup", "key": key }
            } else if (group.type = "Slider") {
                ; Adjust elements for Slider control
                innerElementX := groupBoxX + 10  ; Align display text to the left edge with padding
                centeredTextX := groupBoxX + (groupBoxWidth - 400) / 2  ; Center current value text
                yInnerTextOffset := groupBoxY + 10
                yCurrentValueOffset := groupBoxY + 30
                yInnerEditOffset := groupBoxY + 45
    
                ; Prepare the Slider options and display
                numOptions := group.options.Length()
    
                ; Get the initial value of the slider (default to previous selection or middle value)
                if (previousSelections.HasKey(key)) {
                    previousSelection := previousSelections[key]
                    selectedIndex := 1
                    Loop, % group.options.Length() {
                        if (group.options[A_Index].displayName = previousSelection) {
                            selectedIndex := A_Index
                            break
                        }
                    }
                } else {
                    selectedIndex := Ceil(numOptions / 2)
                }
                selectedOption := group.options[selectedIndex]
                selectedDisplayText := selectedOption.displayText
    
                ; Use label if available, otherwise display only the current value
                displayText := group.label != "" ? group.label : "Slider Value"
    
                ; Add the text control for the label
                Gui, VariablesGUI:Add, Text, x%innerElementX% y%yInnerTextOffset% w400, % displayText ":"
    
                ; Add the text control for the current value, centered
                Gui, VariablesGUI:Add, Text, x%centeredTextX% y%yCurrentValueOffset% w400 Center hwndDisplayHwnd, % selectedDisplayText
    
                ; Add the slider
                Gui, VariablesGUI:Add, Slider, x%innerElementX% y%yInnerEditOffset% w400 v%controlVarName% Range1-%numOptions% AltSubmit TickInterval1 gUpdateSlider
    
                ; Set the slider to the previous position
                GuiControl,, %controlVarName%, %selectedIndex%
    
                ; Store the control variable name and associated slider group key, including the hwnd of the display text
                controlVars[controlVarName] := { "type": "sliderGroup", "key": key, "options": group.options, "displayHwnd": DisplayHwnd, "label": group.label }
            }
        }
    
        yTextOffset += 80  ; Adjust to allow space for GroupBox
        row += 1
        guiVarIndex++
    }
    

    ; Detect when Enter is pressed in the Edit controls
    OnMessage(0x100, "HandleEnterKey")

    ; Add Accept and Cancel buttons
    ButtonWidth := 70
    ; Position buttons at the bottom of the GUI
    ButtonY := yTextOffset + 10
    Gui, VariablesGUI:Add, Button, x90 y%ButtonY% w%ButtonWidth% gVariableAccept, Accept
    Gui, VariablesGUI:Add, Button, x+100 w%ButtonWidth% gVariableCancel, Cancel

    ; Show the GUI
    Gui, VariablesGUI:Show, Center, Enter Variables

    ; Loop to keep the GUI open
    While, guiOpen {
        ; Check if cancel has been triggered, and if so, break the loop
        if (GuiCanceled) {
            stopTyping := true  ; Stop typing if in progress
            stopSending := 1    ; Prevent sending of future lines
            break
        }
        Sleep, 100
    }

    ; If canceled, return immediately without processing inputs
    if (GuiCanceled) {
        return
    }

    ; Retrieve user inputs from controls
    for controlVarName, controlData in controlVars {
        if (controlData.type = "variable") {
            variableName := controlData.name
            userInput := %controlVarName%
            userInputs[variableName] := userInput
        } else if (controlData.type = "listGroup") {
            key := controlData.key
            userSelection := %controlVarName%
            group := listGroupsGlobal[key]
            ; Find the selected index
            selectedIndex := 1
            Loop, % group.options.Length() {
                if (group.options[A_Index].displayText = userSelection) {
                    selectedIndex := A_Index
                    break
                }
            }
            ; Get the output value
            selectedOption := group.options[selectedIndex]
            outputValue := selectedOption.outputValue

            listGroupsGlobal[key].userSelection := outputValue
            ; Store the selection as previous selection
            previousSelections[key] := selectedOption.displayName

        } else if (controlData.type = "sliderGroup") {
            ; Retrieve the selected slider position and map it to the corresponding option
            key := controlData.key
            selectedIndex := %controlVarName%  ; Slider position selected by user
            group := listGroupsGlobal[key]
            selectedOption := group.options[selectedIndex]
            outputValue := selectedOption.outputValue

            listGroupsGlobal[key].userSelection := outputValue
            previousSelections[key] := selectedOption.displayName
        }
    }

    ; Remove the OnMessage function
    OnMessage(0x100, "")

    return userInputs
}




; Function to update slider display when the slider value changes
UpdateSlider() {
    global controlVars
    GuiControlGet, sliderValue, , %A_GuiControl%
    controlData := controlVars[A_GuiControl]
    if (controlData.type = "sliderGroup") {
        selectedIndex := sliderValue
        selectedOption := controlData.options[selectedIndex]
        selectedDisplayText := selectedOption.displayText
        ; Update the current value text, centered
        GuiControl,, % controlData["displayHwnd"], %selectedDisplayText%
    }
}



; Function to replace special variables like date, time, and random number
ReplaceSpecialVariables(RPLine) {
    if (InStr(RPLine, "{UTCDateTime}")) {
        FormatTime, date, %A_NowUTC%, dd/MMM
        FormatTime, time, %A_NowUTC%, HH:mm
        StringUpper, date, date
        CurrentDateTime = %time% %date%
        RPLine := StrReplace(RPLine, "{UTCDateTime}", CurrentDateTime)
    }
    if (InStr(RPLine, "{TodaysDate}")) {
        FormatTime, todaysDate,, MMMM d, yyyy
        RPLine := StrReplace(RPLine, "{TodaysDate}", todaysDate)
    }
    return RPLine
}

; Function to replace key press commands in the RP line
ReplaceKeyPressCommands(RPLine) {
    NewRPLine := RPLine
    while RegExMatch(NewRPLine, "\{(AltHome|CtrlHome|ShiftHome)(\d*)\}", match) {
        SendCombinedKey(match1, match2)
        NewRPLine := StrReplace(NewRPLine, "{" . match1 . match2 . "}", "")
    }
    while RegExMatch(NewRPLine, "\{(LeftArrow|RightArrow|UpArrow|DownArrow|Enter|Backspace|Escape)(\d*)\}", match) {
        SendArrowKey(match1, match2)
        NewRPLine := StrReplace(NewRPLine, "{" . match1 . match2 . "}", "")
    }
    while RegExMatch(NewRPLine, "KeyPress: \[(.*?)\]", match) {
        keyCmd := match1
        if (RegExMatch(keyCmd, "(LeftArrow|RightArrow|UpArrow|DownArrow|Enter|Backspace|Escape)(\d*)", keyMatch)) {
            SendArrowKey(keyMatch1, keyMatch2)
        }
        NewRPLine := StrReplace(NewRPLine, "KeyPress: [" . keyCmd . "]", "")
    }
    return NewRPLine
}


; General function to format numbers, avoiding trailing decimals
FormatNumberWithCommas(num) {
    num := Format("{:.10g}", num)  ; Strip unnecessary trailing zeros
    return AddCommas(num)  ; Add commas to the integer part
}

; Function to add commas to numbers
AddCommas(num) {
    ; Separate the number into integer and decimal parts if any
    decimalPointPos := InStr(num, ".")
    integerPart := num
    decimalPart := ""

    if (decimalPointPos > 0) {
        integerPart := SubStr(num, 1, decimalPointPos - 1)  ; Get the integer part
        decimalPart := SubStr(num, decimalPointPos)  ; Get the decimal part including the point
    }

    ; Add commas to the integer part
    formattedInteger := ""
    digitsCount := StrLen(integerPart)
    loop, %digitsCount%
    {
        digit := SubStr(integerPart, digitsCount + 1 - A_Index, 1)
        if (A_Index > 1 && Mod(A_Index, 3) = 1)
            formattedInteger := "," . formattedInteger
        formattedInteger := digit . formattedInteger
    }

    ; Reassemble the number with the decimal part if it exists
    return formattedInteger . decimalPart
}



; Special variables that are set up for special functionality.
ProcessSpecialCommands(RPLine) {
    ; Handle the CurrentDateTimeUTC special command
    if (InStr(RPLine, "{UTCDateTime}")) {
        FormatTime, date, %A_NowUTC%, dd/MMM  ; Formats the current UTC date into 'dd/MMM' format.
        FormatTime, time, %A_NowUTC%, HH:mm  ; Formats the current UTC time into 'HH:mm' format in 24-hour representation.
        StringUpper, date, date  ; Converts the date to uppercase.
        CurrentDateTime = %time% %date%  ; Combines the time and date into a single variable.
        RPLine := StrReplace(RPLine, "{UTCDateTime}", CurrentDateTime)
    }

    ; Handle the TodayDate special command
    if (InStr(RPLine, "{TodaysDate}")) {
        FormatTime, todaysDate,, MMMM d, yyyy  ; Formats today's date as 'MMMM d, yyyy'.
        RPLine := StrReplace(RPLine, "{TodaysDate}", todaysDate)
    }


    NewRPLine := RPLine

    ; Handle combined key presses
    while RegExMatch(NewRPLine, "\{(AltHome|CtrlHome|ShiftHome)(\d*)\}", match) {
        SendCombinedKey(match1, match2)
        NewRPLine := StrReplace(NewRPLine, "{" . match1 . match2 . "}", "")
    }
    ; Handle single arrow and other keys
    while RegExMatch(NewRPLine, "\{(LeftArrow|RightArrow|UpArrow|DownArrow|Enter|Backspace|Escape)(\d*)\}", match) {
        SendArrowKey(match1, match2)
        NewRPLine := StrReplace(NewRPLine, "{" . match1 . match2 . "}", "")
    }
    ; Handle KeyPress commands
    while RegExMatch(NewRPLine, "KeyPress: \[(.*?)\]", match) {
        keyCmd := match1
        if (RegExMatch(keyCmd, "(LeftArrow|RightArrow|UpArrow|DownArrow|Enter|Backspace|Escape)(\d*)", keyMatch)) {
            SendArrowKey(keyMatch1, keyMatch2)
        }
        NewRPLine := StrReplace(NewRPLine, "KeyPress: [" . keyCmd . "]", "")
    }

    return NewRPLine
}

SendArrowKey(keyType, pressCount) {
    keyToSend := ""
    switch keyType {
        case "LeftArrow":
            keyToSend := "Left"
        case "RightArrow":
            keyToSend := "Right"
        case "UpArrow":
            keyToSend := "Up"
        case "DownArrow":
            keyToSend := "Down"
        case "Enter":
            keyToSend := "Enter"
        case "Backspace":
            keyToSend := "Backspace"
        case "Escape":
            keyToSend := "Esc"
    }

    ; Activate the target application before sending commands
;    WinActivate, ahk_exe %Application%

    Loop, % pressCount {
        ; Check the state of multiple hotkeys frequently within each command
        Loop, 5 {  ; Divide the 250ms into smaller chunks for frequent checks
            Sleep, 75  ; Sleep for 50 ms each time to total around 250 ms
            if (checkStopHotkeys()) {
                stopSending := 1
                return
            }
        }
        Send, {%keyToSend%}
    }
}


SendCombinedKey(keyType, pressCount) {
    modifier := ""
    keyToSend := ""
    if (keyType = "AltHome") {
        modifier := "!"
        keyToSend := "Home"
    } else if (keyType = "CtrlHome") {
        modifier := "^"
        keyToSend := "Home"
    } else if (keyType = "ShiftHome") {
        modifier := "+"
        keyToSend := "Home"
    }

    ; Ensure we convert pressCount to a number
    pressCount := (pressCount = "") ? 1 : pressCount  ; Default to 1 if not specified

;    WinActivate, ahk_exe %Application%

    Loop, % pressCount {
        ; Check the state of multiple hotkeys frequently within each command
        Loop, 5 {
            Sleep, 50  ; Check for stop conditions more frequently
            if (checkStopHotkeys()) {
                stopSending := 1
                return
            }
        }
        Send, %modifier%{%keyToSend%}
    }
}


; Helper function to check state of multiple hotkeys
checkStopHotkeys() {
    ; List of hotkeys to check, excluding F5 and F11
    hotkeys := ["F1", "F2", "F3", "F4", "F6", "F7", "F8", "F9", "F10", "Enter", "Alt", "Tab", "LWin"]
    for index, key in hotkeys {
        if (GetKeyState(key, "P"))  ; Check if any of the keys is pressed
            return true
    }
    return false
}


; Helper function to check if a string is numeric
IsNumber(value) {
    return RegExMatch(value, "^\d+(\.\d+)?$")
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
    global guiOpen, GuiCanceled, stopTyping, stopSending, isTypingActive
    GuiCanceled := true
    guiOpen := false
    stopTyping := true  ; Stop typing if in progress
    stopSending := 1    ; Prevent sending of future lines
    Gui, VariablesGUI:Destroy
Return



; Function to handle the selection of an RP line from the ListView either by pressing Enter or double-clicking
; Executes the corresponding RP line by activating the window, saving the GUI state, checking a checkbox, and sending the RP line with a delay
SelectRPFromListView(eventType := "") {
    if (eventType != "Enter" && A_GuiEvent != "DoubleClick") {
        return
    }

    if (eventType == "Enter") {
        focusedRow := LV_GetNext(0, "Focused")
        LV_GetText(RPToSend, focusedRow, 2)
        LV_GetText(sectionNameForRP, focusedRow, 1)
    } else if (A_GuiEvent = "DoubleClick") {
        focusedRow := A_EventInfo
        LV_GetText(RPToSend, focusedRow, 2)
        LV_GetText(sectionNameForRP, focusedRow, 1)
    }

    if (RPToSend = "" || RPToSend = "RP Line") {
        return
    }

    RPToSend := ReplaceVariables(RPToSend, sectionNameForRP)
    RPToSend := ReplaceDateTime(RPToSend)
    if (RPToSend = "")
        return

    Gui, FullSizeGui:Submit, NoHide
    Gosub, CheckTickBoxAndClose

    ; Use the same process as in RunPreset to handle Test GUI mode
    if (TestModeEnabled) {
        InitTestGui()
    }

    RPToSend := ProcessSpecialCommands(RPToSend)
    SendMessagewithDelayFunction(RPToSend)
    if (TestModeEnabled) {
        UpdateTestGui(RPToSend)
    }
}



; Subroutine to check if the GUI should be closed after a selection and destroy it if needed
CheckTickBoxAndClose:
    global TestModeEnabled, floatingGuis ; Global flag and floating GUI list

    ; If Test Mode is enabled, keep the GUI open
    if (TestModeEnabled) {
        return
    }

    ; Check if the active GUI is a floating preset GUI
    guiName := A_Gui
    if (floatingGuis.HasKey(guiName)) {
        return  ; Exit without closing if it's a floating preset GUI
    }

    ; Destroy the GUI if the closeOnSelectState variable is false and Test Mode is not enabled
    if (!closeOnSelectState) {
        Gui, Destroy
    }
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


SubmitAddRPLine:
    Gui, Submit, NoHide

    ; Check if we are adding to Default Variable Values and use two inputs if so
    if (selectedCategory = "Default Variable Values") {
        CustomVarName := Trim(CustomVarName)
        CustomVarValue := Trim(CustomVarValue)

        ; Validate inputs
        if (CustomVarName = "" || CustomVarValue = "") {
            MsgBox, 48, Error, "Please ensure both variable name and default value are filled in."
            return
        }

        ; Format the line as "Variable Name = Default Value"
        NewRPLine := "{" . CustomVarName . "} = " . CustomVarValue
        LinesToAdd := [NewRPLine] ; Create a single-entry array for consistency
    } else {
        ; For other categories, split input into multiple lines
        NewRPLine := Trim(NewRPLine)
        if (NewRPLine = "") {
            MsgBox, 48, Error, "Please enter an RP line."
            return
        }

        ; Split the input by newlines into an array of lines
        LinesToAdd := StrSplit(NewRPLine, "`n")
    }

    ; Read the entire TXT file
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, txtData, %TxtFile%

    ; Locate the section in the file
    sectionStart := InStr(txtData, "[" . selectedCategory . "]")
    if (sectionStart = 0) {
        ; If the section does not exist, add it with the lines
        txtData := txtData "`n`n[" . selectedCategory . "]`n"
        sectionStart := StrLen(txtData)
    }

    ; Determine where the section ends
    sectionEnd := InStr(txtData, "`n[", false, sectionStart + StrLen(selectedCategory) + 2)
    if (sectionEnd = 0) {
        sectionEnd := StrLen(txtData) + 1 ; End of the file
    }

    ; Extract the section content
    sectionContent := SubStr(txtData, sectionStart, sectionEnd - sectionStart)

    ; Append each line to the section if not already present
    for index, line in LinesToAdd {
        line := Trim(line)
        if (line != "" && !InStr(sectionContent, "`n" . line)) {
            sectionContent .= "`n" . line
        }
    }

    ; Reconstruct the updated file content
    txtData := SubStr(txtData, 1, sectionStart - 1) . sectionContent . SubStr(txtData, sectionEnd)

    ; Write the updated content to the file
    FileDelete, %TxtFile%
    FileAppend, %txtData%, %TxtFile%
    Gosub, SanitizeFile

    ; Close the GUI and update the TreeView
    Gui, AddRPLine:Destroy
    Gosub, ReloadRPLinesTreeView
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
        displayText := "Delete the line """ . selectedRPLine . """ in category """ . selectedCategory . """?"
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

    ; Process the text data to find and remove the selected RP line
    newTextData := ""
    insideSelectedCategory := false
    Loop, Parse, txtData, `n, `r
    {
        line := A_LoopField

        if (line = "[" . selectedCategory . "]")
            insideSelectedCategory := true
        else if (SubStr(line, 1, 1) = "[" && insideSelectedCategory)
            insideSelectedCategory := false
        
        if (insideSelectedCategory && line = selectedRPLine)
            continue  ; Skip adding this line to keep it deleted

        newTextData .= line . "`n"
    }

    ; Rewrite the modified data back to the file
    FileDelete, %vRPLines%
    FileAppend, %newTextData%, %vRPLines%

    ; Sanitize the file and recreate the GUI
    Gosub, SanitizeFile
    Gosub, RecreateGUI
return




; Sanitizes the given text file by removing unnecessary empty lines, formatting category sections, and removing duplicates
SanitizeFile:
    ; Read the entire file into memory
    FileRead, txtData, %TxtFile%

    ; Remove all consecutive empty lines, leaving only single line breaks
    txtData := RegExReplace(txtData, "`n\s*`n+", "`n")

    ; Ensure there's exactly one empty line above each category, except at the start of the file
    txtData := RegExReplace(txtData, "(?<!^)(?<!`n)`n(\[.*?\])", "`n`n$1")

    ; Remove any leading empty lines before the first category
    txtData := RegExReplace(txtData, "^\s*`n+", "")

    ; Remove duplicate categories and their RP lines
    txtData := RemoveDuplicates(txtData)

    ; Ensure there's exactly one empty line between categories again after removing duplicates
    txtData := RegExReplace(txtData, "`n\s*`n+", "`n")
    txtData := RegExReplace(txtData, "(?<!^)(?<!`n)`n(\[.*?\])", "`n`n$1")
    txtData := RegExReplace(txtData, "^\s*`n+", "")

    ; Write the sanitized data back to the file
    FileDelete, %TxtFile%
    FileAppend, %txtData%, %TxtFile%

    ; Fix the location of the [Presets] section
;    Gosub FixPresetLocation
return

; Removes duplicate categories and their RP lines from the text data
RemoveDuplicates(txtData) {
    ; Split the data into lines
    lines := StrSplit(txtData, "`n")
    ; Create a map to track seen categories and their RP lines
    seen := {}

    ; Initialize variables
    currentCategory := ""
    result := []

    ; Process each line
    Loop, % lines.MaxIndex() {
        line := lines[A_Index]

        ; Check if the line is a category
        if (SubStr(line, 1, 1) = "[") {
            currentCategory := line
            if !seen.HasKey(currentCategory) {
                seen[currentCategory] := {}
                result.Push(line)
            }
        }
        else if (currentCategory != "" && line != "" && currentCategory != "[Presets]") {
            if !seen[currentCategory].HasKey(line) {
                seen[currentCategory][line] := true
                result.Push(line)
            }
        }
    }

    ; Join the result array back into a single string
    return StrJoin("`n", result)
}


; Initialize the RandomRP GUI with the updated layout
RandomRP:
    ; Close the currently active GUI if it's open
    if (activeGuiName != "") {
        Gui, %activeGuiName%:Destroy
    }

    ; Initialize sections array and read from the TXT file
    sections := []
    FileRead, txtData, %vRPLines%
    Loop, Parse, txtData, n, r
    {
        line := Trim(A_LoopField)
        if (SubStr(line, 1, 1) = "[") {
            sectionName := SubStr(line, 2, StrLen(line) - 2)
            if (sectionName != "Presets")
                sections.Push(sectionName)
        }
    }

    ; Set the active GUI name to "RandomRP" for future reference
    activeGuiName := "RandomRP"

    ; Create a new GUI with TreeView and ListView side by side
    Gui, RandomRP:New, +AlwaysOnTop 
    Gui, Font, s11, Segoe UI Semibold
    Gui, Color, C0C0C0

    ; Add instructional text for double-click action
    Gui, Add, Text, x10 y5 w480 Center, Double-Click to add/remove random categories

    ; Add a GroupBox around the TreeView labeled "Categories"
    Gui, Add, GroupBox, x10 y28 w240 h300, Categories

    ; Add the TreeView within the GroupBox boundaries
    Gui, Add, TreeView, x20 y50 w220 h270 gOnTreeViewDoubleClick vRPLineTreeView

    ; Add a GroupBox around the ListView labeled "Queue | Category"
    Gui, Add, GroupBox, x260 y28 w240 h300

    ; Add the ListView within the GroupBox boundaries
    Gui, Add, ListView, x270 y50 w220 h270 vSequenceListView gOnListViewDoubleClick, Queue|Category
    LV_ModifyCol(1, 58) ; Set the width of the 'Sequence' column
    LV_ModifyCol(2, 180) ; Set the width of the 'Category' column

    ; Initialize sequence number for the list
    sequenceNumber := 0

    ; Center the Submit button under the TreeView and the Cancel button under the ListView
    Gui, Add, Button, x328 y340 w100 h30 gSubmitRandomRP Default, Submit
    Gui, Add, Button, x80 y340 w100 h30 gCloseRandomRP, Cancel

    ; Load only parent categories
    LoadRPLinesToTreeView(false, true, true)

    Gui, Show, w510 h380, Select Random Categories
return




; Handle double-click on TreeView item to add to Sequence List
OnTreeViewDoubleClick:
    if (A_GuiEvent != "DoubleClick")
        return

    selectedID := TV_GetSelection()
    if !selectedID
        return

    ; Get the name of the selected category
    TV_GetText(categoryName, selectedID)
    
    ; Add the selected category to the Sequence List
    AddCategoryToSequenceList(categoryName)
return

; Add a category to the Sequence ListView with a sequence number
AddCategoryToSequenceList(categoryName) {
    global sequenceNumber
    sequenceNumber++
    LV_Add("", sequenceNumber, categoryName)
}

; Handle double-click on ListView item to remove from Sequence List and re-sequence
OnListViewDoubleClick:
    if (A_GuiEvent != "DoubleClick")
        return

    ; Get the selected row in the ListView
    selectedRow := LV_GetNext(0, "Focused")
    if !selectedRow
        return

    ; Remove the selected item from the ListView
    LV_Delete(selectedRow)
    
    ; Re-sequence the remaining items in the ListView
    ReSequenceListView()
return

; Re-number the Sequence column in the ListView
ReSequenceListView() {
    global sequenceNumber
    sequenceNumber := 0
    Loop, % LV_GetCount()
    {
        sequenceNumber++
        LV_Modify(A_Index, "Col1", sequenceNumber) ; Update the Sequence column
    }
}


SubmitRandomRP:
    ; Collect selected categories from the SequenceListView
    sectionNames := []
    Loop, % LV_GetCount()
    {
        LV_GetText(sectionName, A_Index, 2)
        sectionNames.Push(sectionName)
    }

    ; Check if at least one category is selected
    if (sectionNames.MaxIndex() = 0) {
        MsgBox, Please select at least one category.
        return
    }

    ; Destroy the RandomRP GUI before proceeding
    Gui, RandomRP:Destroy

    ; Initialize an array to hold the RP lines to send
    RPToSendList := []
    chosenTextLines := []  ; Store selected text lines for display

    ; Process each selected category to find a random RP line
    for index, sectionName in sectionNames {
        ; Read the section data from the TXT file
        sectionStart := InStr(txtData, "[" . sectionName . "]") + StrLen(sectionName) + 2
        sectionEnd := InStr(txtData, "`n[", false, sectionStart)
        sectionData := (sectionEnd = 0) ? SubStr(txtData, sectionStart) : SubStr(txtData, sectionStart, sectionEnd - sectionStart)

        ; Split lines and add valid lines to the cleanedLines array
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
            while (cleanedLines.MaxIndex() > 1 && previousLine.HasKey(sectionName) && cleanedLines[rand] = previousLine[sectionName]) {
                Random, rand, 1, cleanedLines.MaxIndex()
            }
            previousLine[sectionName] := cleanedLines[rand]
            chosenTextLines.Push(sectionName . ": " . cleanedLines[rand])
            RPToSendList.Push(cleanedLines[rand])
        }
    }

    ; Process the RP lines with variable replacements
    for index, RPLine in RPToSendList {
        RPToSendList[index] := ReplaceVariables(RPLine, sectionNames[index])
        if (RPToSendList[index] = "") {
            return
        }
    }

    ; Prepare to send each RP line and activate the application
    if (TestModeEnabled) {
        InitTestGui()
    } else {
        WinActivate, ahk_exe %Application%
    }

    ; Send each RP line with delay
    stopSending := 0
    for _, RPToSend in RPToSendList {
        if (stopSending) {
            stopSending := 0
            return
        }
        ResetRandomGui()
        SendMessagewithDelayFunction(RPToSend)
        if (TestModeEnabled) {
            UpdateTestGui(RPToSend)
        }
    }
return


; Close the RandomRP GUI
CloseRandomRP:
    Gui, RandomRP:Destroy
return







; Function to extract specific section data cleanly and more reliably
ExtractSectionData(txtData, sectionName) {
    sectionStart := InStr(txtData, "`n[" . sectionName . "]")
    if (sectionStart = 0)
        sectionStart := InStr(txtData, "[" . sectionName . "]")  ; Check if it's at the start of the file
    if (sectionStart = 0)
        return ""  ; If the section isn't found, return an empty string

    sectionStart += StrLen("[" . sectionName . "]") + 1  ; Adjust past the header

    sectionEnd := InStr(txtData, "`n[", false, sectionStart)
    if (sectionEnd = 0)
        return SubStr(txtData, sectionStart)  ; Take till end of file if no next section
    return SubStr(txtData, sectionStart, sectionEnd - sectionStart)
}





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

; Function to move the [Presets] section to the bottom of the RPLines.txt file
FixPresetLocation:
    TxtFile := A_ScriptDir "\" vRPLines
    FileRead, content, %TxtFile%

    ; Find the [Presets] section
    presetSection := ""
    foundPresetSection := false
    newContent := ""

    Loop, Parse, content, `n, `r
    {
        line := Trim(A_LoopField)
        if (line = "[Presets]") {
            foundPresetSection := true
            presetSection .= line "`n"
        } else if (foundPresetSection) {
            if (SubStr(line, 1, 1) = "[") {
                foundPresetSection := false
                newContent .= line "`n"
            } else {
                presetSection .= line "`n"
                continue
            }
        } else {
            newContent .= line "`n"
        }
    }

    ; Append the [Presets] section to the bottom if found
    if (presetSection != "") {
        ; Ensure only one empty line above the [Presets] section
        newContent := RegExReplace(newContent, "`n$", "")  ; Remove any trailing newlines from the main content
        newContent := Trim(newContent) "`n" presetSection  ; Ensure exactly one empty line above [Presets]
    }

    ; Write back to the file
    FileDelete, %TxtFile%
    FileAppend, %newContent%, %TxtFile%
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

SendMessagewithDelayFunction(TextToSend, SendEnter=True) {
    if (TextToSend = "")  ; Skip if there's no text
        return
    global stopTyping, stopSending, isTypingActive, TestModeEnabled, Application, ChatOpenKey, variableValues

    if (!IsObject(TextToSend)) {
        TextToSend := [TextToSend]  ; Convert single string to array
    }

    isTypingActive := 1 ; Set the typing active flag

    ; Reset the stopTyping and stopSending flags
    stopTyping := false
    stopSending := 0

    ; Determine the target window and activate it
    if (!TestModeEnabled) {
        WinActivate, ahk_exe %Application%
        Sleep, 50 ; Short delay after activating the window
    }

    ; Initialize loop count (default is 1)
    loopCount := 1
    if (variableValues.HasKey("Loop") && IsNumber(variableValues["Loop"])) {
        loopCount := variableValues["Loop"]
    }

    ; Process {SkipChatOpen} before entering the loop
    skipChatOpen := false
    if (InStr(TextToSend[1], "{SkipChatOpen}")) {
        skipChatOpen := true
        TextToSend[1] := StrReplace(TextToSend[1], "{SkipChatOpen}", "")
    }

    ; Define sleep time per character (adjust as needed)
    sleepTimePerCharacter := 50 ; In milliseconds
    sleepBetweenLines := 750  ; Delay between lines (adjust this value as needed)

    ; Loop for the specified number of times
    Loop, %loopCount% {

        ; Check if stopTyping or stopSending was triggered
        if (stopTyping || stopSending) {
            isTypingActive := 0
            return
        }

        ; Check if {SkipChatOpen} is true and skip opening the chat
        if (!skipChatOpen && !TestModeEnabled) {
            ; Activate the window again before each message
            WinActivate, ahk_exe %Application%
            Sleep, 100 ; Short delay after activating the window

            ; Send the ChatOpenKey
            SendInput, %ChatOpenKey%
            Sleep, 100 ; Short delay after pressing the chat open key and before typing starts
        }

        ; Process each line in the array
        for lineIndex, CurrentLine in TextToSend {

            ; Check if stopTyping or stopSending was triggered
            if (stopTyping || stopSending) {
                isTypingActive := 0
                return
            }

            ; Initialize flags for SendWithoutDelay and RoundNumbers
            SendWithoutDelay := false
            RoundNumbersFlag := false

            ; Check if {DoNotEnter} is present in the CurrentLine
            if (InStr(CurrentLine, "{DoNotEnter}")) {
                CurrentLine := StrReplace(CurrentLine, "{DoNotEnter}", "")
                currentLineEnter := false
                CurrentLine := RTrim(CurrentLine)  ; Remove trailing spaces
            } else {
                currentLineEnter := (lineIndex < TextToSend.Length() || SendEnter)
            }

            ; Check if {SendWithoutDelay} or {SendInstantly} is present in the CurrentLine
            if (InStr(CurrentLine, "{SendWithoutDelay}") || InStr(CurrentLine, "{SendInstantly}")) {
                CurrentLine := StrReplace(CurrentLine, "{SendWithoutDelay}", "")
                CurrentLine := StrReplace(CurrentLine, "{SendInstantly}", "")
                SendWithoutDelay := true
            }
            
            ; Check if {RoundNumbers} is present in the CurrentLine
            if (InStr(CurrentLine, "{RoundNumbers}")) {
                RoundNumbersFlag := true
            }

            ; Process special variables and commands
            CurrentLine := ProcessSpecialCommands(CurrentLine)

            ; Handle Math expressions enclosed in double curly braces
            while (Pos := RegExMatch(CurrentLine, "\{\{\s*(.*?)\s*\}\}", exprMatch)) {
                expr := exprMatch1
                ; Replace variables inside the math expression
                for variableName, variableValue in variableValues {
                    expr := StrReplace(expr, "{" . variableName . "}", variableValue)
                }

                ; Evaluate the math expression
                result := EvaluateMathExpression(expr)

                ; Store the result in MathOutputX variable if applicable
                if (RegExMatch(expr, "MathOutput(\d*)", match)) {
                    mathOutputVar := (match1 != "" ? "MathOutput" match1 : "MathOutput")
                    variableValues[mathOutputVar] := result
                }

                ; Apply rounding if {RoundNumbers} is found
                if (RoundNumbersFlag) {
                    result := Round(result)
                }

                ; Apply formatting if {FormatNumbers} is found
                if (InStr(CurrentLine, "{FormatNumbers}")) {
                    formattedResult := FormatNumberWithCommas(result)
                } else {
                    formattedResult := result
                }

                ; Replace the math expression with the formatted result
                CurrentLine := StrReplace(CurrentLine, exprMatch, formattedResult)
            }

            ; Generate a new random number for each iteration if {RandomNumber} is found
            if (InStr(CurrentLine, "{RandomNumber}")) {
                Random, randomNumber, 1, 999 ; Generates a random number between 1 and 999.
                CurrentLine := StrReplace(CurrentLine, "{RandomNumber}", randomNumber)
            }

            ; Remove all {Comment=} variables from the text
            while (Pos := RegExMatch(CurrentLine, "\{Comment=[^{}]+\}", var)) {
                CurrentLine := StrReplace(CurrentLine, var, "")
            }

            ; Replace MathOutputX variables with their values
            for key, value in variableValues {
                if (RegExMatch(key, "^MathOutput\d*$")) {
                    ; Apply rounding if {RoundNumbers} is present
                    if (RoundNumbersFlag) {
                        value := Round(value)
                    }
                    ; Apply number formatting if {FormatNumbers} is present
                    if (InStr(CurrentLine, "{FormatNumbers}")) {
                        value := FormatNumberWithCommas(value)
                    }
                    CurrentLine := StrReplace(CurrentLine, "{" . key . "}", value)
                }
            }

            ; Remove {RoundNumbers} after it is applied
            if (RoundNumbersFlag) {
                CurrentLine := StrReplace(CurrentLine, "{RoundNumbers}", "")
            }

            ; Remove {FormatNumbers} after it is applied
            if (InStr(CurrentLine, "{FormatNumbers}")) {
                CurrentLine := StrReplace(CurrentLine, "{FormatNumbers}", "")
            }

            ; Escape curly braces in CurrentLine for {Raw} mode
            CurrentLine := StrReplace(CurrentLine, "{", "{{}")
            CurrentLine := StrReplace(CurrentLine, "}", "{}}")

            ; Loop through each character in the text and send one by one
            if (SendWithoutDelay) {
                ; Send the whole line without delay
                SendInput, {Raw}%CurrentLine%
            } else {
                ; Send each character with a delay
                Loop, Parse, CurrentLine
                {
                    if (stopTyping || stopSending) {
                        isTypingActive := 0
                        return  ; Exit the function to stop typing
                    }

                    ; Send each character as raw text
                    SendInput, {Raw}%A_LoopField%
                    Sleep, %sleepTimePerCharacter%
                }
            }

            ; If currentLineEnter is True and stopTyping is not set, send Enter key
            if (currentLineEnter && !stopTyping && !stopSending) {
                Sleep, 15
                SendInput, {Enter}
            }

            ; Add the sleep between lines regardless of SendWithoutDelay
            if (currentLineEnter && !stopTyping && !stopSending) {
                Sleep, %sleepBetweenLines%
            }
        }

        ; Reduce sleep time between loop iterations for speed (if SendWithoutDelay is true)
        if (!SendWithoutDelay) {
            Sleep, 100  ; Shorter sleep between iterations
        }
    }

    ; Reset the loop value back to 1 after execution
    variableValues["Loop"] := 1

    ; Reset the typing active flag
    isTypingActive := 0

    ; If in Test Mode, update the Test GUI
    if (TestModeEnabled) {
        global TestEdit
        UpdateTestGui(TextToSend.Join("`n"))
    }
}





; Function to stop the typing operation made by SendMessagewithDelayFunction
StopTypingFunction() {
    global stopTyping, stopSending, variableValues ; Global flags and variables
    stopTyping := true  ; Set the stopTyping flag
    stopSending := 1    ; Set the stopSending flag
    variableValues["Loop"] := 1  ; Reset the loop amount to 1
}



; Created by Bassna, aka "Jonathan Willowick" on GTA 5 Eclipse RP server
; For updates and support: https://github.com/Bassna/Roleplaying-Menu
; https://twitch.tv/bassna
; Discord: Bassna
