#SingleInstance Force
#NoEnv
SendMode Input
SetBatchLines, 10000
SetWinDelay, 0
SetControlDelay, 0        ;Mostly useless.
FileEncoding, UTF-16      ;Use UCS-2 Little Endian BOM for the ini, but not for the .bat file.

Version := "v2.9.16"
IniVersion := "v1.0"

;#Warn, All, StdOut

/*
TSolidBackground
An AIO Autohotkey script that can make any window pseudo-fullscreen using padding over window borders and background. It can also move/resize windows and make them always on top.
https://github.com/Onurtag/TSolidBackground

To anyone reading the code,
This script contains many globals and hacks that are unoptimal which I can't really recommend.
They all work well and it would be a waste of time (also I don't care enough too) so they will stay like this until they break or bother me.

If you have any good suggestions, feel free to contact me or open an issue.

TODO:
-Fix GUI tab orderings or FULLY REMAKE the gui (Maybe with a tool or a template) https://www.autohotkey.com/boards/viewtopic.php?f=6&t=3851  https://github.com/G33kDude/Neutron.ahk/
-group parts of the ui to make them more clear, or use something like tabs tabs ^^^Related  
-Rename advanced options to settings  
-Add named presets for move/resize menu. Maybe for the custom tsb sizes as well. Can save window title as well and show it as a tooltip maybe.
-"Minimized" instead of -32000 x and y  
-hotkeys should be manually added to start labels instead.
-fix ini long variable names with or without spaces. Long variables might be fine but no spaces?
-default autosave everything possible to ini option, disable "saved" popups except for the first time
-tooltips for permanent/temprorary positions
-ini autosave+autobackup(s)
-seperate ini categories for hooker etc
-dont use hotkeys as a label, enable them manually. (like the MoveKey s)
-loop while loading ini and check for errors maybe
-add scale + button that enlarges/shrinks the window
-add toggle clickthrough button to move/resize menu


TEMP HACKS:   
[CHECK1]  
[CHECK2]  

*/

OnExit("Exiting")
bgcolor := 250000
TSolidBackgroundKey := "!T"
OnTopKey := "!Y"
CenterKey := "!G"
TaskbarKey := "!F"
OptionsKey := "!U"
SuspendKey := "!F8"
Iniexists := "No"
MoveKey1 := ""
MoveKey2 := ""
MoveKey3 := ""
CustomWidthLeft := 0
CustomWidthRight := 0
CustomHeightTop := 0
CustomHeightBottom := 0
startupWindow := 1
protectVNR := 1
hookPartialTitle := 1
excludeSystemWindows := 1
Hooking := 0
TitleOne := "Main Window Title"
TitleTwo := "Hooked Window Title"
Vmove := 5
Vresize := 5
MoveBy := 2
preventSend := 1
Debug := 0
Checking := 0
CheckForUpdates := 0
useKeyboardHook := 0
Arrs := Object()
;These titles are excluded from move/resize menu
;You don't have to edit these manually.
;Use the edit menu under advanced options to add more titles or remove these.
excludedTitles := Object("TSolidBackground Advanced Features", ""
                        ,"TSolidBackground Splash Text", ""
                        ,"Stacked Pleasant Notification", ""
                        ,"TSolidBackground Move/Resize Window", ""
                        ,"Windows Shell Experience Host", ""
                        ,"Program Manager", "")

;--------------------------------------------------------------------
;----------- Advanced settings for Window Hooker (Alpha) ------------
;--------------------------------------------------------------------
;Window containing this string in its title does not minimize the hooked window (similar to the main window or the alt+tab menu)  
hookerExcludeWindow := "Clipboard Inserter"
;Window with a title that matches this regex string gets activated when the hooked window is restored (when you activate the main window). This one is a Regular Expression.
hookerTopOfWindowTwoRegex := "Clipboard Inserter.*(Overlay Mode)"
;The hooker KILLS window two instead of minimizing it.
hookerKillWindowTwoInstead := 0
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------

Menu, Tray, Icon,,, 0
Menu, Tray, NoStandard
Menu, Tray, Add, About TSolidBackground, Abouted
Menu, Tray, Add, Advanced Features, Advanced
Menu, Tray, Add, Edit TSolidBackground.ini, Editini
Menu, Tray, Add, Stop Window Hooker, StopHook
Menu, Tray, Disable, Stop Window Hooker
Menu, Tray, Add, Restart, Restarted
Menu, Tray, Add, Exit, Exited
Menu, Tray, Default, Advanced Features
Menu, Tray, Tip, TSolidBackground

IfExist, %A_ScriptDir%\TSolidBackground.ini
{
    Iniexists := "Yes"
    Readini(WrittenIniVersion, "Settings", "Ini Version")
    if ((WrittenIniVersion == "ERROR") || (WrittenIniVersion != IniVersion)) {
        if (WrittenIniVersion == "ERROR") {
            new StackingPleasantNotify("TSolidBackground", "Your TSolidBackground.ini is likely corrupt.`nIt was automatically renamed and recreated.", "", 400, "auto", 15000, "0x292929", "0x836DFF", "0xF34242 wBold", "0xDCDCCC wBold")
        } else if (WrittenIniVersion != IniVersion) {
            new StackingPleasantNotify("TSolidBackground", "Your TSolidBackground.ini needs to be updated.`nIt was automatically renamed and recreated.", "", 400, "auto", 15000, "0x292929", "0x836DFF", "0xF34242 wBold", "0xDCDCCC wBold")
        }
        FileMove, %A_ScriptDir%\TSolidBackground.ini, TSolidBackground_OLD_%A_DD%-%A_MM%-%A_YYYY%.ini
        CreateSaveini(0)
        new StackingPleasantNotify("TSolidBackground", "Restarting TSolidBackground in 10 seconds...", "", 400, "auto", 15000, "0x292929", "0x836DFF", "0xb8b8ac wBold", "0xDCDCCC wBold")
        Sleep, 15000
        Reload
    }
    Readini(TSolidBackgroundKey, "Hotkeys", "TSolidBackground Key")
    Readini(OnTopKey, "Hotkeys", "On Top Key")
    Readini(CenterKey, "Hotkeys", "Center Window Key")
    Readini(TaskbarKey, "Hotkeys", "Show Hide Taskbar Key")
    Readini(OptionsKey, "Hotkeys", "Advanced Features Key")
    Readini(SuspendKey, "Hotkeys", "Suspend Hotkeys Key")
    Readini(MoveKey1, "Hotkeys", "Move Key 1")
    Readini(MoveKey2, "Hotkeys", "Move Key 2")
    Readini(MoveKey3, "Hotkeys", "Move Key 3")
    Readini(bgcolor, "Settings", "Background Color")
    Readini(CustomWidthLeft, "Settings", "Custom Width Left")
    Readini(CustomWidthRight, "Settings", "Custom Width Right")
    Readini(CustomHeightTop, "Settings", "Custom Height Top")
    Readini(CustomHeightBottom, "Settings", "Custom Height Bottom")
    Readini(startupWindow, "Settings", "Enable Startup Window")
    Readini(excludeSystemWindows, "Settings", "Exclude system windows from dropdown")
    Readini(CheckForUpdates, "Settings", "Check for Updates on Startup")
    Readini(useKeyboardHook, "Settings", "Use Keyboard Hook")
    Readini(TitleOne, "Settings", "Hooker Main Window")
    Readini(TitleTwo, "Settings", "Hooker Hooked Window")
    Readini(hookPartialTitle, "Settings", "Hook Partial Main Window Title")
    Readini(MoveBy, "Settings", "Mouse Mover Move By")
    Readini(Debug, "Settings", "Debug")
    ReadTitlesFromIni()

    if (TSolidBackgroundKey != "!T") {
        if (TSolidBackgroundKey != "") {
            Hotkey, %TSolidBackgroundKey%, !T
        }
        Hotkey, !T, Off
    }
    if (OnTopKey != "!Y") {
        if (OnTopKey != "") {
            Hotkey, %OnTopKey%, !Y
        }
        Hotkey, !Y, Off
    }
    if (CenterKey != "!G") {
        if (CenterKey != "") {
            Hotkey, %CenterKey%, !G
        }
        Hotkey, !G, Off
    }
    if (TaskbarKey != "!F") {
        if (TaskbarKey != "") {
            Hotkey, %TaskbarKey%, !F
        }
        Hotkey, !F, Off
    }
    if (OptionsKey != "!U") {
        if (OptionsKey != "") {
            Hotkey, %OptionsKey%, !U
        }
        Hotkey, !U, Off
    }
    if (SuspendKey != "!F8") {
        if (SuspendKey != "") {
            Hotkey, %SuspendKey%, ~!F8
        }
        Hotkey, !F8, Off
    }


    if (MoveKey1 == "ERROR") {
        MoveKey1 := ""
    }
    if (MoveKey2 == "ERROR") {
        MoveKey2 := ""
    }
    if (MoveKey3 == "ERROR") {
        MoveKey3 := ""
    }
    
    if (MoveKey1 != "") {
        Hotkey, %MoveKey1%, LoadHotkey1
    }

    if (MoveKey2 != "") {
        Hotkey, %MoveKey2%, LoadHotkey2
    }

    if (MoveKey3 != "") {
        Hotkey, %MoveKey3%, LoadHotkey3
    }



    If (useKeyboardHook == 1) {
        if (TSolidBackgroundKey != "")
            Hotkey, $%TSolidBackgroundKey%
        if (OnTopKey != "!Y")
            Hotkey, $%OnTopKey%
        if (CenterKey != "")
            Hotkey, $%CenterKey%
        if (TaskbarKey != "")
            Hotkey, $%TaskbarKey%
        if (OptionsKey != "")
            Hotkey, $%OptionsKey%
        if (SuspendKey != "")
            Hotkey, $%SuspendKey%
    }

    ;Re-save the ini to write the new ini options? Might break things in the future.
    CreateSaveini(0)
}

if (startupWindow == 1) {
    Gui, start: Color, 292929
    Gui, start: Font, s14 c836DFF Bold, Segoe UI
    Gui, start: Add, Text,, TSolidBackground %Version%
    Gui, start: Font, s8 c836DFF Bold
    Gui, start: Font, s10 cDCDCCC norm
    Gui, start: Add, Text, x18 y42, Current Hotkeys and Options: `n------------------------`nTSolidBackground: %TSolidBackgroundKey% `nAlways On Top: %OnTopKey% `nShow Hide Taskbar: %TaskbarKey% `nCenter Window: %CenterKey% `nAdvanced Features: %OptionsKey% `nSuspend other hotkeys: %SuspendKey%`nTSolidBackground.ini file exists: %Iniexists%`n------------------------ `nOn AutoHotkey [!] means [Alt]. `nIf no hotkeys work on selected window, run TSolidBackground as admin.`n`nIf you have any problems, want to change the hotkeys, want to check for updates `nor just can't understand anything above visit the project page:
    Gui, start: Font, s10 c3257BF underline
    Gui, start: Add, Text, x18 y303 gGotoSite, https://github.com/Onurtag/TSolidBackground
    Gui, start: Font, s10 cBlack norm Bold
    Gui, start: Add, Button, x243 y338 w64 h36, Ok
    Gui, start: Show, w550 h393, TSolidBackground Startup
}

if (CheckForUpdates == 1) {
    CheckUpdate(0)
}
Return

!Y::
    WinGet, currentWindow, ID, A
    WinGetTitle, currentTitle, A
    if (currentTitle == "Kagami") {
        if (protectVNR) {
            new StackingPleasantNotify("TSolidBackground", "Window [" . currentTitle . "] is protected.", "Check advanced options to disable it.", 400, "auto", 5000, "0x292929", "0x836DFF", "0xb8b8ac", "0xDCDCCC wBold")
            Return
        }
    }
    WinStack(currentWindow)
    WinGet, WindowExStyle, ExStyle, ahk_id %currentWindow%
    if (WindowExStyle & 0x8) { 
        WinSet, AlwaysOnTop, off, ahk_id %currentWindow%
        new StackingPleasantNotify("TSolidBackground", "Window [" . currentTitle . "]", "Always on top status: OFF", 400, "auto", 5000, "0x292929", "0x836DFF", "0xb8b8ac", "0xDCDCCC wBold")
    } else {
        WinSet, AlwaysOnTop, on, ahk_id %currentWindow%
        new StackingPleasantNotify("TSolidBackground", "Window [" . currentTitle . "]", "Always on top status: ON", 400, "auto", 5000, "0x292929", "0x836DFF", "0xb8b8ac", "0xDCDCCC wBold")
    }
Return

!T::
    RunTSB()
Return

!G::
    WinGetPos,,, WWWidth, HHHeight, A
    GetMonitorIndexFromWindow(WinExist("A"))
    mHeight := monitorBottom-monitorTop
    mWidth := monitorRight-monitorLeft
    WinMove, A,, (mWidth-WWWidth)/2+monitorLeft, (mHeight-HHHeight)/2+monitorTop
Return

!F::
    if (TBtoggle == "") {
        VarSetCapacity( APPBARDATA, 36, 0 )
        NumPut( 36, APPBARDATA, 0, "UInt" )
        NumPut( WinExist( "ahk_class Shell_TrayWnd" ), APPBARDATA, 4, "UInt" )
        TBtoggle := 0
    }
    if (TBtoggle == 0) {
        NumPut( ( ABS_ALWAYSONTOP := 0x2 )|( ABS_AUTOHIDE := 0x1 ), APPBARDATA, 32, "UInt" )
        DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
        Sleep, 100
        WinHide, ahk_class Shell_TrayWnd
        WinHide, Start ahk_class Button
        Sleep, 500
        WinHide, ahk_class Shell_TrayWnd    ;Do these again as they bug a lot.
        WinHide, Start ahk_class Button
        TBtoggle := 1
    } else {
        WinShow, ahk_class Shell_TrayWnd
        WinShow, Start ahk_class Button
        NumPut( ( ABS_ALWAYSONTOP := 0x2 ), APPBARDATA, 32, "UInt" )
        DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
        Sleep, 100
        WinShow, ahk_class Shell_TrayWnd    ;Do these again as they bug a lot.
        WinShow, Start ahk_class Button
        DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
        TBtoggle := 0
    }
Return

!U::
    if (WinExist("A") != TBResized) {
        TBResized := WinExist("A")
        WinGetTitle, titleTBResized, ahk_id %TBResized%
        if ((protectVNR) && (titleTBResized == "Kagami")) {
            TBResized := ""
        } else {
            ;DrawHUD("Got a new window to move/resize.", "y160", "c836DFF", "s11", "1350")
            WinGetPos, Xorig, Yorig, Worig, Horig, ahk_id %TBResized%
        }
    }
    if (WinExist("TSolidBackground Move/Resize Window")) {
        ShowResizer()
    } else {
        ShowNewMenu("","")
    }
Return

ShowNewMenu(nmX, nmY) {
    Global
    Gui, newmenu: Destroy
    Gui, newmenu: +AlwaysOnTop
    Gui, newmenu: Color, 292929
    Gui, newmenu: Font, s14 c836DFF Bold, Segoe UI
    Gui, newmenu: Add, Text, x236 y15, Advanced Features
    Gui, newmenu: Font, s10 c836DFF norm Underline
    Gui, newmenu: Add, Text, x219 y435, Create .ini for permanent options
    Gui, newmenu: Font, s10 cDCDCCC norm
    Gui, newmenu: Add, Button, x254 y460 w130 h28 gRunCreateSaveini, Create/Save .ini
    Gui, newmenu: Font, s12 c836DFF Bold
    Gui, newmenu: Add, Button, x198 y70 w242 h38 gStartResizeGui, &Move/Resize Window
    Gui, newmenu: Add, Button, x198 y125 w242 h38 gStartOptionsGui, &Advanced Options
    Gui, newmenu: Add, Button, x198 y180 w242 h38 gStartHookGui, &Window Hooker (Alpha)
    Gui, newmenu: Add, Button, x198 y235 w242 h38 gStartMouseMoveGui, Mouse Mo&ver
    Gui, newmenu: Font, s10 c836DFF Bold
    Gui, newmenu: Add, Button, x198 y320 w242 h26 gStartDummyWindow, Ma&ke a Dummy Window
    Gui, newmenu: Add, Button, x198 y355 w242 h26 gRunCheckUpdate, &Check For Updates
    Gui, newmenu: Add, Button, x174 y515 w290 h24, Close
    if ((nmX == "") || (nmX == -32000)) {
        Gui, newmenu: Show, w640 h560, TSolidBackground Advanced Features
    } else {
        Gui, newmenu: Show, w640 h560 x%nmX% y%nmY%, TSolidBackground Advanced Features
    }
    SetTimer, KillCheat, 30
}

~!F8::
    Suspend
    if (A_IsSuspended) {
        new StackingPleasantNotify("TSolidBackground", "Suspended all other hotkeys.", "To enable hotkeys press " . SuspendKey . ".", 400, "auto", 5000, "0x292929", "0x836DFF", "0xb8b8ac", "0xDCDCCC wBold")
        Menu, Tray, Tip, TSolidBackground Suspended
    } else {
        new StackingPleasantNotify("TSolidBackground", "Enabled all hotkeys.", "", 400, "auto", 5000, "0x292929", "0x836DFF", "0xb8b8ac", "0xDCDCCC wBold")
        Menu, Tray, Tip, TSolidBackground
    }
Return

Advanced:
    ShowNewMenu("","")
Return

;Debug Vars with F10 if debug is enabled
#If Debug
~F10::
    ListVars
Return
#If

Abouted:
    Gui, about: +AlwaysOnTop
    Gui, about: Destroy
    Gui, about: Color, 292929
    Gui, about: Font, s14 c836DFF, Segoe UI
    Gui, about: Add, Text,, TSolidBackground %Version%
    Gui, about: Font, s10 cDCDCCC
    Gui, about: Add, Text,, For readme, updates and more `ncheck out the project page:
    Gui, about: Font, s10 c3257BF underline
    Gui, about: Add, Text, x18 y100 gGotoSite, https://github.com/Onurtag/TSolidBackground/
    Gui, about: Font, s10 cBlack norm Bold
    Gui, about: Add, Button, x118 y136 w64 h36, Ok
    Gui, about: Show, w300 h192, About TSolidBackground
Return

RunTSB(windowtoTSB := "") {
    Global
    if (Activewin == "") {
        Activewin := WinExist("A")
    }
    Toggle := !Toggle
    if (Toggle == "1") {
        old_Activewin := Activewin
        if (windowtoTSB == "") {
            Activewin := WinExist("A")
            WinGetTitle, Activewintitle, ahk_id %Activewin%
            if (Hooking) {
                if (hookPartialTitle) {
                    checkTitleOne := InStr(Activewintitle, TitleOne)
                } else {
                    checkTitleOne := (Activewintitle == TitleOne)
                }
                if (checkTitleOne > 0) {
                    Activewin := WinExist(TitleTwo)
                }
            }
        } else {
            Activewin := windowtoTSB
        }
        /* 
        if (old_Activewin != Activewin) {
            DrawHUD("Got a new window for TSolidBackground.", "", "c836DFF", "s11", "1350")
        }
        */
        TSolidBackground()
    } else {
        DestroyTSolidBackground()
    }
}

TSolidBackground() {
    Global
    WinGetPos, wX, wY, WWidth, HHeight, ahk_id %Activewin%
    GetMonitorIndexFromWindow(Activewin)
    mHeight := monitorBottom-monitorTop
    mWidth := monitorRight-monitorLeft

    WI := 0
    WI := Object()
    WI := API_GetWindowInfo(Activewin)
    Border_SizeW := WI.Client.Left - WI.Window.Left
    Border_SizeH := WI.Window.Bottom - WI.Client.Bottom
    Caption_Size := WI.Client.Top - WI.Window.Top - Border_SizeH
    
    if (Caption_Size < -7) {   ;[CHECK1] Some bug with the top of the window (1pixel border stays visible on top)
        Caption_Size++
    }

    bg1FY := wY
    bg2FX := wX
    bg3SY := wY+HHeight
    bg4SX := wX+WWidth

    bg1FY += Border_SizeH+Caption_Size
    bg2FX += Border_SizeW
    bg3SY -= Border_SizeH
    bg4SX -= Border_SizeW
    
    WinGet, WinExStyle, ExStyle, ahk_id %Activewin%
    WinGet, WinStyle, Style, ahk_id %Activewin%
    if (WinExStyle & 0x8) { 
        WinGetTitle, currTitle, ahk_id %Activewin%
        if (currTitle != "Kagami") {    ;VNR fix
            WinSet, AlwaysOnTop, off, ahk_id %Activewin%
            new StackingPleasantNotify("TSolidBackground", "Window [" . currTitle . "]", "Always on top status: OFF", 400, "auto", 5000, "0x292929", "0x836DFF", "0xb8b8ac", "0xDCDCCC wBold")
        }
    }

    bg1FY -= %CustomHeightTop%
    bg2FX -= %CustomWidthLeft%
    bg3SY += %CustomHeightBottom%
    bg4SX += %CustomWidthRight%

    bg2FX -= monitorLeft
    bg1FY -= monitorTop
    bg3H := monitorBottom-bg3SY
    bg4W := monitorRight-bg4SX
    
    Gui, bg1: +AlwaysOnTop -Caption +ToolWindow -DPIScale
    Gui, bg1: Color, %bgcolor%
    Gui, bg2: +AlwaysOnTop -Caption +ToolWindow -DPIScale
    Gui, bg2: Color, %bgcolor%
    Gui, bg3: +AlwaysOnTop -Caption +ToolWindow -DPIScale
    Gui, bg3: Color, %bgcolor%
    Gui, bg4: +AlwaysOnTop -Caption +ToolWindow -DPIScale
    Gui, bg4: Color, %bgcolor%
    WinSet, Top,, ahk_id %Activewin%
    if (wX < 0) {
        bg4W := Abs(bg4SX)+monitorRight
        Gui, bg2: Show, NoActivate x%monitorLeft% y%monitorTop% h%mHeight% w%bg2FX%, TSolidBackground BG2 (RIGHT)
        Gui, bg4: Show, NoActivate x%bg4SX% y%monitorTop% h%mHeight% w%bg4W%, TSolidBackground BG4 (LEFT)
    } else {
        Gui, bg2: Show, NoActivate x%monitorLeft% y%monitorTop% h%mHeight% w%bg2FX%, TSolidBackground BG2 (LEFT)
        Gui, bg4: Show, NoActivate x%bg4SX% y%monitorTop% h%mHeight% w%bg4W%, TSolidBackground BG4 (RIGHT)
    }
    if (wY < 0) {
        bg3H := Abs(bg3SY)+monitorBottom
        Gui, bg3: Show, NoActivate x%monitorLeft% y%bg3SY% h%bg3H% w%mWidth%, TSolidBackground BG3 (TOP)
        Gui, bg1: Show, NoActivate x%monitorLeft% y%monitorTop% h%bg1FY% w%mWidth%, TSolidBackground BG1 (BOTTOM)
    } else {
        Gui, bg3: Show, NoActivate x%monitorLeft% y%bg3SY% h%bg3H% w%mWidth%, TSolidBackground BG3 (BOTTOM)
        Gui, bg1: Show, NoActivate x%monitorLeft% y%monitorTop% h%bg1FY% w%mWidth%, TSolidBackground BG1 (TOP)
    }
    Return
}

DestroyTSolidBackground() {
    Gui, bg1: Destroy
    Gui, bg2: Destroy
    Gui, bg3: Destroy
    Gui, bg4: Destroy
    Return
}

;Draws splash text (currently using StackingPleasantNotify instead)
/* 
DrawHUD(hudtext, xyvalue, hudtextcolor := "c836DFF", hudtextsize := "s11", hudtimer := 1350) {
    Gui, hud: Destroy
    Gui, hud: +AlwaysOnTop -Caption +ToolWindow +Border
    Gui, hud: Color, 292929
    Gui, hud: Font, %hudtextsize% %hudtextcolor% Bold, Segoe UI
    Gui, hud: Add, Text,, %hudtext%
    Gui, hud: Show, NoActivate %xyvalue%, TSolidBackground Splash Text
    SetTimer, Deletehud, %hudtimer%
    Return
}
*/

Deletehud:
    SetTimer, Deletehud, off
    Gui, hud: Destroy
Return

GotoSite:
    Run, %A_GuiControl%
Return

startButtonOk:
startGuiEscape:
    Gui, start: Destroy
Return

aboutButtonOk:
aboutGuiEscape:
    Gui, about: Destroy
Return

newmenuGuiEscape:
newmenuButtonClose:
    Gui, newmenu: Destroy
Return

updateButtonOk:
updateButtonClose:
updateGuiEscape:
    Gui, update: Destroy
Return

DummyGuiEscape:
    Gui, Dummy: Destroy
Return

BackGui:          ;Not planning to make the gui tabbed etc yet.
    WinGetPos, aX, aY, aW, aH, A
    Gui, cheat: Color, 292929
    Gui, cheat: Show, w640 h560 x%aX% y%aY%, TSolidBackground Advanced Features
    Gui, Destroy
    ShowNewMenu(aX,aY)
    ;SetTimer, KillCheat, 30
Return

KillCheat:
    Gui, cheat: Destroy
    SetTimer, KillCheat, Off
Return

;Advanced Options Start
StartOptionsGui:
    ShowOptions()
Return

ShowOptions() {
    Global
    Gui, options: Destroy
    Gui, options: +AlwaysOnTop
    Gui, options: Font, s14 c836DFF Bold, Segoe UI
    Gui, options: Add, Text, x238 y15, Advanced Options
    Gui, options: Color, 292929
    Gui, options: Font, s10 cDCDCCC norm
    Gui, options: Add, Text, x152 y75, Custom Width Left:
    Gui, options: Add, Text, x152 y97, Custom Width Right:
    Gui, options: Add, Text, x152 y119, Custom Height Top:
    Gui, options: Add, Text, x152 y141, Custom Height Bottom:
    Gui, options: Add, Text, x152 y205, TSolidBackground Color:
    Gui, options: Add, Text, x436 y80, Permanent `nSave/Load
    Gui, options: Font, s10 c836DFF Bold
    Gui, options: Add, Button, x174 y515 w290 h24, Close
    Gui, options: Add, Button, x10 y10 w44 h24 gBackGui, Back
    Gui, options: Add, Edit, x310 y73 w70 h20 vCustomWidthLeft, %CustomWidthLeft%
    Gui, options: Add, UpDown, 0x80 Range-90000-90000, %CustomWidthLeft%
    Gui, options: Add, Edit, x310 y95 w70 h20 vCustomWidthRight, %CustomWidthRight%
    Gui, options: Add, UpDown, 0x80 Range-90000-90000, %CustomWidthRight%
    Gui, options: Add, Edit, x310 y117 w70 h20 vCustomHeightTop, %CustomHeightTop%
    Gui, options: Add, UpDown, 0x80 Range-90000-90000, %CustomHeightTop%
    Gui, options: Add, Edit, x310 y139 w70 h20 vCustomHeightBottom, %CustomHeightBottom%
    Gui, options: Add, UpDown, 0x80 Range-90000-90000, %CustomHeightBottom%
    Gui, options: Add, Edit, x310 y203  w70 h20 vbgcolor, %bgcolor%
    Gui, options: Add, Progress, x310 y225 w70 h20 c%bgcolor% Background%bgcolor% vbarcolored, 100
    Gui, options: Font, norm Underline
    Gui, options: Add, Text, x219 y435, Create .ini for permanent options
    Gui, options: Font, s9 cDCDCCC norm
    Gui, options: Add, Button, x384 y75 w15 h15 hwndhResetcwh gResetcwh, R
    Gui, options: Add, Button, x540 y302 w50 h20 gShowExcluded, Edit
    AddTooltip(hResetcwh, "Reset Custom Width and Height")
    Gui, options: Add, Button, x430 y120 w21 h17 gSaveCustom1, S1
    Gui, options: Add, Button, x457 y120 w21 h17 gSaveCustom2, S2
    Gui, options: Add, Button, x484 y120 w21 h17 gSaveCustom3, S3
    Gui, options: Add, Button, x430 y142 w21 h17 gLoadCustom1, L1
    Gui, options: Add, Button, x457 y142 w21 h17 gLoadCustom2, L2
    Gui, options: Add, Button, x484 y142 w21 h17 gLoadCustom3, L3
    Gui, options: Add, Button, x384 y205 w15 h15 hwndhResetcolor gResetcolor, R
    AddTooltip(hResetcolor, "Switch between Red and Blue")
    Gui, options: Add, Button, x311 y164 w68 h18 hwndhSetCWH gSetnow, Set CWH
    AddTooltip(hSetcwh, "Set Custom Width and Height")
    Gui, options: Add, Button, x311 y249 w68 h18 gSetcolor, Set Color
    Gui, options: Font, s10 cDCDCCC norm
    Gui, options: Add, Button, x254 y460 w130 h28 gRunCreateSaveini, Create/Save .ini
    Gui, options: Add, Checkbox, x152 y280 Checked%protectVNR% vprotectVNR gSetnow, Protect VNR ("Kagami" titled window)
    Gui, options: Add, Checkbox, x152 y302 Checked%excludeSystemWindows% vexcludeSystemWindows gSetnow, Exclude specified windows from the Move/Resize dropdown.
    Gui, options: Add, Checkbox, x152 y324 Checked%startupWindow% vstartupWindow gSetnow, Show info window on startup
    Gui, options: Add, Checkbox, x152 y346 Checked%CheckForUpdates% vCheckForUpdates gSetSaveini, Check for updates on startup (Save to ini required)
    Gui, options: Add, Checkbox, x152 y368 Checked%useKeyboardHook% vuseKeyboardHook gSetKBhook, Use Keyboard Hook to force hotkeys to work (Save to ini required)
    WinGetPos, optX, optY, optW, optH, TSolidBackground Advanced Features
    if ((optX == "") || (optX == -32000)) {
        Gui, options: Show, w640 h560, TSolidBackground Advanced Options
    } else {
        Gui, options: Show, w640 h560 x%optX% y%optY%, TSolidBackground Advanced Options
    }
    Gui, newmenu: Destroy
    Return
}

OptionsButtonClose:
    Gui, options: Destroy
Return

OptionsGuiEscape:
    Gosub, BackGui
Return

ShowExcluded:
    ShowExcludedTitles()    
Return

ShowExcludedTitles() {
    Gui, titles: Destroy
    Gui, titles: Default 
    Gui, titles: +AlwaysOnTop
    Gui, titles: Color, 292929
    Gui, titles: Font, s12 cDCDCCC norm
    Gui, titles: Add, ListView, x35 y15 r11 w435 NoSort NoSortHdr -ReadOnly Background292929 cDCDCCC, Window Title (Untitled windows will be blocked too.)
    Gui, titles: Font, s10 c836DFF
    Gui, titles: Add, Button, x485 y98 w90 h24 gRemoveLV, Remove
    Gui, titles: Add, Button, x485 y65 w90 h24 gAddLV, Add
    Gui, titles: Font, Bold
    Gui, titles: Add, Button, x175 y385 w250 h24, Close
    Gui, titles: Font, s12
    Gui, titles: Add, Button, x175 y325 w250 h44 gSaveTitles, Save to .ini
    Gui, titles: Show, w600 h430, TSolidBackground Edit Excluded Titles
    PopulateTitles()
}

PopulateTitles() {
    Global
    For titleKey, value in excludedTitles {
        LV_Add("", titleKey)
    }
}

SaveTitles:
    SaveTitlesToIni()
    ReadTitlesFromIni()
Return

SaveTitlesToIni() {
    Global
    rowsText := ""
    rowCounter := LV_GetCount()
    Loop {
        If (rowCounter == 0) {
            Break
        }
        LV_GetText(thisRow, rowCounter)
        rowsArray := StrSplit(rowsText, "<|TSB|>")
        alreadyExists := 0
        Loop % rowsArray.MaxIndex()
        {
            thisOne := rowsArray[A_Index]
            If (thisRow == thisOne) {
                alreadyExists := 1
            }
        }
        If (!alreadyExists) {
            rowsText .= thisRow . "<|TSB|>"
        }
        rowCounter--
    }
    IfNotExist, %A_ScriptDir%\TSolidBackground.ini 
    {
        CreateSaveini(1)
    }
    Writeini(rowsText, "Settings", "Excluded Titles")
}

ReadTitlesFromIni() {
    Global
    Readini(iniTitles, "Settings", "Excluded Titles")
    If (iniTitles != "ERROR") {
        excludedTitles := 0
        excludedTitles := Object()
        iniTitlesArray := StrSplit(iniTitles, "<|TSB|>")
        Loop % iniTitlesArray.MaxIndex()
        {
            thisTitle := iniTitlesArray[A_Index]
            If (thisTitle != "") {
                excludedTitles[thisTitle] := ""
            }
        }
    }
}

RemoveLV:
    RowNumber := 0
    Loop
    {
        RowNumber := LV_GetNext(RowNumber-1)
        if not RowNumber
            break
        LV_Delete(RowNumber)
    }
Return

AddLV:
    LV_Add("", "Window Title")
Return

TitlesGuiEscape:
TitlesButtonClose:
    Gui, titles: Destroy
Return

Setnow:
    Gui, Submit, NoHide
Return

SetKBhook:
    Gui, Submit, NoHide
    CreateSaveini(1)
    If (useKeyboardHook == 1) {
        if (TSolidBackgroundKey != "")
            Hotkey, $%TSolidBackgroundKey%
        if (OnTopKey != "!Y")
            Hotkey, $%OnTopKey%
        if (CenterKey != "")
            Hotkey, $%CenterKey%
        if (TaskbarKey != "")
            Hotkey, $%TaskbarKey%
        if (OptionsKey != "")
            Hotkey, $%OptionsKey%
        if (SuspendKey != "")
            Hotkey, $%SuspendKey%
    } else {
        MsgBox, 4097, TSolidBackground, Restarting TSolidBackground to disable the hooks.
        IfMsgBox, OK 
        {
            Reload
        }
    }
Return

SetSaveini:
    Gui, Submit, NoHide
    CreateSaveini(1)
Return

Resetcwh:
    GuiControl, options:, CustomHeightBottom, 0
    GuiControl, options:, CustomHeightTop, 0
    GuiControl, options:, CustomWidthRight, 0
    GuiControl, options:, CustomWidthLeft, 0
    Gui, Submit, NoHide
Return

Setcolor:
    Gui, Submit, NoHide
    RefresherOptions()
Return

Resetcolor:
    if (bgcolor == 051523) {
        GuiControl, options:, bgcolor, 250000
    } else {
        GuiControl, options:, bgcolor, 051523
    }
    Gui, Submit, NoHide
    RefresherOptions()
Return

RefresherOptions() {
    Global
    GuiControl,+c%bgcolor% +Background%bgcolor%, barcolored
    Return
}

SaveCustom1:
    SaveCustom(1)
Return

LoadCustom1:
    LoadCustom(1)
Return

SaveCustom2:
    SaveCustom(2)
Return

LoadCustom2:
    LoadCustom(2)
Return

SaveCustom3:
    SaveCustom(3)
Return

LoadCustom3:
    LoadCustom(3)
Return

SaveCustom(thenr) {
    Global
    IfNotExist, %A_ScriptDir%\TSolidBackground.ini 
    {
        CreateSaveini(1)
    }
    Writeini(CustomWidthLeft, "Custom TSB Sizes " . thenr, "Custom Width Left")
    Writeini(CustomWidthRight, "Custom TSB Sizes " . thenr, "Custom Width Right")
    Writeini(CustomHeightTop, "Custom TSB Sizes " . thenr, "Custom Height Top")
    Writeini(CustomHeightBottom, "Custom TSB Sizes " . thenr, "Custom Height Bottom")
    Return
}

LoadCustom(thenr) {
    Global
    Readini(PermWL, "Custom TSB Sizes " . thenr, "Custom Width Left")
    Readini(PermWR, "Custom TSB Sizes " . thenr, "Custom Width Right")
    Readini(PermHT, "Custom TSB Sizes " . thenr, "Custom Height Top")
    Readini(PermHB, "Custom TSB Sizes " . thenr, "Custom Height Bottom")
    if (PermWL == "ERROR") {
        new StackingPleasantNotify("TSolidBackground", "Requested save or the .ini file does not exist.", "", 400, "auto", 7000, "0x292929", "0x836DFF", "0xF34242 wBold", "0xDCDCCC wBold")
    } else {
        CustomWidthLeft := PermWL
        CustomWidthRight := PermWR
        CustomHeightTop := PermHT
        CustomHeightBottom := PermHB
    }
    GuiControl, options:, CustomHeightBottom, %CustomHeightBottom%
    GuiControl, options:, CustomHeightTop, %CustomHeightTop%
    GuiControl, options:, CustomWidthRight, %CustomWidthRight%
    GuiControl, options:, CustomWidthLeft, %CustomWidthLeft%
    Gui, Submit, NoHide
    Return
}

Editini:
    IfExist, %A_ScriptDir%\TSolidBackground.ini
    {
        Run, %A_ScriptDir%\TSolidBackground.ini,,UseErrorLevel
        if ErrorLevel == ERROR
        {
            Run, notepad %A_ScriptDir%\TSolidBackground.ini,,UseErrorLevel
        }
    } else {
        new StackingPleasantNotify("TSolidBackground", "You must first create an ini in the Advanced Features menu before being able to edit it.", "", 400, "auto", 8000, "0x292929", "0x836DFF", "0xF34242 wBold", "0xDCDCCC wBold")
    }
Return

RunCheckUpdate:
    if (Checking == 0) {
        CheckUpdate(1)
    }
Return

CheckUpdate(notify) {
    Global
    
    ;----- [CHECK2] TEMP HACK. Checking for updates while the hooker is on crashes the application and deletes the exe!? Probably an av false-positive.
    if (Hooking) {
        Hooking := 0
        SetTimer, Hooker, Off
        Menu, Tray, Disable, Stop Window Hooker
        new StackingPleasantNotify("TSolidBackground", "Window hooker was disabled.", "", 400, "auto", 5000, "0x292929", "0x836DFF", "0xb8b8ac wBold", "0xDCDCCC wBold")
    }
    ;-----

    Checking := 1
    updater := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    updater.Open("GET", "https://github.com/Onurtag/TSolidBackground/releases/latest", true)
    updater.Send()
    updater.WaitForResponse()
    NewVersion := StrSplit(updater.Option(1),"/releases/tag/")[2]
    if (NewVersion != Version) {
        Gui, update: Destroy
        Gui, update: +AlwaysOnTop
        Gui, update: Color, 292929
        Gui, update: Font, s14 cBB002D
        Gui, update: Add, Text,, A TSolidBackground update is available.
        Gui, update: Font, s14 c836DFF, Segoe UI
        Gui, update: Add, Text,, Latest version: %NewVersion%  (Current version: %Version%)
        Gui, update: Font, s9 cDCDCCC
        Gui, update: Add, Text, x15 y90, Note: If your TSolidBackground.exe is currently in a system protected folder`n(eg. C:\Program Files\TSolidBackground)`nyou need to run TSolidBackground as admin if you want to update.
        Gui, update: Add, Text, x15 y150, Check out the changelog to see what has changed:
        Gui, update: Font, s10 c3257BF underline
        Gui, update: Add, Text, x15 y165 gGotoSite, https://github.com/Onurtag/TSolidBackground#changelog
        Gui, update: Font, s12 cBlack norm Bold
        Gui, update: Add, Button, x110 y200 w230 h48 gRunAutoUpdateNow, Update and Restart Now
        Gui, update: Font, s10 cBlack norm Bold
        Gui, update: Add, Button, x193 y270 w64 h30, Close
        Gui, update: Show, w450 h320, TSolidBackground Update Available!
    } else if (notify) {
        Gui, update: Destroy
        Gui, update: +AlwaysOnTop
        Gui, update: Color, 292929
        Gui, update: Font, s14 c2EA319
        Gui, update: Add, Text,, `nYour TSolidBackground is up to date.
        Gui, update: Font, s14 c836DFF, Segoe UI
        Gui, update: Add, Text,, Latest version: %NewVersion%  (Current version: %Version%)
        Gui, update: Font, s10 cDCDCCC
        Gui, update: Add, Text,, Visit the link below if you want to download it again.
        Gui, update: Font, s11 c3257BF underline
        Gui, update: Add, Text, gGotoSite, https://github.com/Onurtag/TSolidBackground/releases/latest
        Gui, update: Font, s10 cBlack norm Bold
        Gui, update: Add, Button, x193 y190 w64 h36, Ok
        Gui, update: Show, w450 h240, TSolidBackground is Up to Date!
    }
    Checking := 0
}

RunAutoUpdateNow:
    if (A_IsCompiled) {
        AutoUpdateNow(NewVersion)
    } else {
        Run, "https://github.com/Onurtag/TSolidBackground/releases/latest"
    }
Return

AutoUpdateNow(NewVersion) {
    new StackingPleasantNotify("TSolidBackground", "TSolidBackground will now update and restart.`nJust hold on a second...", "", 400, "auto", 120000, "0x292929", "0x836DFF", "0x27A100", "0xDCDCCC wBold")
    UrlDownloadToFile, https://github.com/Onurtag/TSolidBackground/releases/download/%NewVersion%/TSolidBackground.exe, TSolidBackground_NEWVER.exe
    FileEncoding,       ;Batch files don't work on UTF-16
    FileDelete, TSolidBackgroundUpdater.bat
    FileAppend, del TSolidBackground.exe`n, TSolidBackgroundUpdater.bat
    FileAppend, ren TSolidBackground_NEWVER.exe TSolidBackground.exe`n, TSolidBackgroundUpdater.bat
    FileAppend, start TSolidBackground.exe`n, TSolidBackgroundUpdater.bat
    FileAppend, del TSolidBackgroundUpdater.bat`n, TSolidBackgroundUpdater.bat
    FileEncoding, UTF-16
    Run, TSolidBackgroundUpdater.bat,, Hide
    ExitApp
}

;Advanced Options End


;Move/Resize Start
StartResizeGui:
    ShowResizer()
Return

;Might need a re-design soon.
ShowResizer() {
    Global
    GetAllWindows()
    BlockResizer := 0
    WinGetPos, resX, resY, resW, resH, TSolidBackground Move/Resize Window
    Gui, resizer: Destroy
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    WI := 0
    WI := Object()
    WI := API_GetWindowInfo(TBResized)
    Border_SizeW := WI.Client.Left - WI.Window.Left
    Border_SizeH := WI.Window.Bottom - WI.Client.Bottom
    Caption_Size := WI.Client.Top - WI.Window.Top - Border_SizeH
    Wnew := Wofwin
    Hnew := Hofwin
    Xnew := Xofwin
    Ynew := Yofwin
    if (Xofwin == -32000) {      ;We don't want bad original values for minimized windows.
        Xorig := 200
        Yorig := 200
        Wnew := 1296
        Hnew := 759
        Xnew := 200
        Ynew := 200
    }
    HclientDif := 2*Border_SizeH + Caption_Size
    WclientDif := 2*Border_SizeW
    WinGet, ResizedStyle, Style, ahk_id %TBResized%
    Hclient := Hofwin - HclientDif
    Wclient := Wofwin - WclientDif
    Gui, resizer: +AlwaysOnTop +Delimiter`n
    Gui, resizer: Font, s14 c836DFF Bold, Segoe UI
    Gui, resizer: Add, Text, x77 y18, Selected Window:
    IfWinNotExist, ahk_id %TBResized%
    {
        Gui, resizer: Font, cC12626, Segoe UI
        Gui, resizer: Add, Text, x125 y60, `n          Use the advanced features hotkey `nor the dropdown menu to select a window.
        BlockResizer := 1
        DropDownCurrent := 1
    } else {
        Gui, resizer: Add, Text, x103 y93, Resize Window
        Gui, resizer: Add, Text, x403 y93, Move Window
    }
    Gui, resizer: Color, 292929
    Gui, resizer: Font, s10 cDCDCCC
    Gui, resizer: Add, Button, x174 y515 w290 h24, Close
    Gui, resizer: Add, Button, x10 y10 w44 h24 gBackGui, Back
    Gui, resizer: Font, norm
    Gui, resizer: Add, DropDownList, x95 y53 w450 Choose%DropDownCurrent% vDropDownCurrent gDropDownSelected AltSubmit, Select a Window (If it's not here, check Advanced Options)`n%DropDownAll%
    Gui, resizer: Add, Button, x551 y55 w54 h21 hwndhReload gReloadDropDown, Reload
    AddTooltip(hReload, "Reload the list of windows.")
    Gui, resizer: Add, Text, x520 y445, Tip: You can use `nyour advanced `nfeatures (%OptionsKey%) `nhotkey to select `na new window.
    if (!BlockResizer) {
        Gui, resizer: Add, Text, x75 y125, Current:
        Gui, resizer: Add, Text, x75 y145, Original:
        Gui, resizer: Add, Text, x75 y165, Client area:
        Gui, resizer: Add, Text, x75 y280, New Width:
        Gui, resizer: Add, Text, x75 y302, New Height:
        Gui, resizer: Add, Text, x370 y125, Current:
        Gui, resizer: Add, Text, x370 y145, Original:
        Gui, resizer: Add, Text, x370 y280, New X:
        Gui, resizer: Add, Text, x370 y302, New Y:
        Gui, resizer: Add, Text, x370 y206, Center:
        Gui, resizer: Add, Text, x497 y248, By:
        Gui, resizer: Add, Text, x147 y248, By:
        Gui, resizer: Add, Text, x40 y363, Temp/Perm Save:
        Gui, resizer: Add, Text, x40 y391, Load Saved Pos:
        Gui, resizer: Font, s9 cDCDCCC norm
        Gui, resizer: Font, s10 cb396ff norm
        Wofwin := 000000            ;Fix for some tiny gui bug(?).
        Hofwin := 000000
        Xofwin := 000000
        Yofwin := 000000
        Wclient := 000000
        Hclient := 000000
        Gui, resizer: Add, Text, x150 y125 vCurrentWH, W: %Wofwin%, H: %Hofwin%
        Gui, resizer: Add, Text, x426 y125 vCurrentXY, X: %Xofwin%, Y: %Yofwin%
        Gui, resizer: Font, s10 c836DFF norm
        Gui, resizer: Add, Text, x150 y165 vCurrentClient, W: %Wclient%, H: %Hclient%
        Gui, resizer: Add, Text, x150 y145, W: %Worig%, H: %Horig%
        Gui, resizer: Add, Text, x426 y145, X: %Xorig%, Y: %Yorig%
        Gui, resizer: Add, Button, x254 y460 w130 h28 gRunCreateSaveini, Create/Save .ini
        Gui, resizer: Font, s10 c836DFF Bold
        Gui, resizer: Add, Edit, x158 y278 w64 h20 vWnew, %Wnew%
        Gui, resizer: Add, UpDown, 0x80 Range-90000-90000, %Wnew%
        Gui, resizer: Add, Edit, x158 y301 w64 h20 vHnew, %Hnew%
        Gui, resizer: Add, UpDown, 0x80 Range-90000-90000, %Hnew%
        Gui, resizer: Add, Edit, x424 y278 w64 h20 vXnew, %Xnew%
        Gui, resizer: Add, UpDown, 0x80 Range-90000-90000, %Xnew%
        Gui, resizer: Add, Edit, x424 y301 w64 h20 vYnew, %Ynew%
        Gui, resizer: Add, UpDown, 0x80 Range-90000-90000, %Ynew%
        Gui, resizer: Font, norm Underline
        Gui, resizer: Add, Text, x168 y338, Quick save/load size and position
        Gui, resizer: Add, Text, x428 y338, Save for the Move Hotkeys`n(Read the Tooltip)
        Gui, resizer: Add, Text, x219 y435, Create .ini for permanent options
        Gui, resizer: Font, s9 c836DFF norm Bold
        Gui, resizer: Add, Edit, x517 y249 w50 h20 Number vVmove, %Vmove%
        Gui, resizer: Add, UpDown, 0x80 Range1-90000, %Vmove%
        Gui, resizer: Add, Edit, x167 y247 w50 h20 Number vVresize, %Vresize%
        Gui, resizer: Add, UpDown, 0x80 Range1-90000, %Vresize%
        Gui, resizer: Font, s13 cDCDCCC norm
        Gui, resizer: Add, Button, x285 y96 w21 h19 hwndhMinWin gMinWin, ⎼⎼         ;Line
        AddTooltip(hMinWin, "Minimize/Restore Window")
        Gui, resizer: Add, Button, x311 y96 w21 h19 hwndhMaxWin gMaxWin, ◻          ;Square (◻ or ⬜ or ◻)
        AddTooltip(hMaxWin, "Maximize/Restore Window")
        Gui, resizer: Font, s9.5
        Gui, resizer: Add, Button, x337 y96 w21 h19 hwndhCloseWin gCloseWin, ❌      ;Cross ❌
        AddTooltip(hCloseWin, "Close Window")
        Gui, resizer: Add, Button, x285 y120 w33 h21 hwndhTSBWin gTSBWin, TSB
        AddTooltip(hTSBWin, "Toggle TSolidBackground on This Window")
        Gui, resizer: Font, s9
        Gui, resizer: Add, Button, x350 y147 w15 h15 hwndhOrigxy gOrigxy, R
        AddTooltip(hOrigxy, "Reset Window Position")
        Gui, resizer: Add, Button, x55 y147 w15 h15 hwndhOrigwh gOrigwh, R
        AddTooltip(hOrigwh, "Reset Window Size")
        Gui, resizer: Add, Button, x73 y57 w16 h17 hwndhCopyTitle gCopyTitle, C
        AddTooltip(hCopyTitle, "Copy Window Title")
        Gui, resizer: Add, Button, x521 y189 w16 h16 gWup, U
        Gui, resizer: Add, Button, x521 y225 w16 h16 gWdown, D
        Gui, resizer: Add, Button, x503 y207 w16 h16 gWleft, L
        Gui, resizer: Add, Button, x539 y207 w16 h16 gWright, R
        Gui, resizer: Add, Button, x153 y362 w27 h21 hwndhSavetemp1 gSavetemp1, T1
        AddTooltip(hSavetemp1, "Temprorary values are lost when you quit TSolidBackground.")
        Gui, resizer: Add, Button, x153 y390 w27 h21 gLoadtemp1, T1
        Gui, resizer: Add, Button, x185 y362 w27 h21 hwndhSavetemp2 gSavetemp2, T2
        AddTooltip(hSavetemp2, "Temprorary values are lost when you quit TSolidBackground.")
        Gui, resizer: Add, Button, x185 y390 w27 h21 gLoadtemp2, T2
        Gui, resizer: Add, Button, x220 y362 w27 h21 hwndhSave1 gSave1, P1
        AddTooltip(hSave1, "Permanently saves the window size/position to .ini")
        Gui, resizer: Add, Button, x220 y390 w27 h21 gLoad1, P1
        Gui, resizer: Add, Button, x252 y362 w27 h21 hwndhSave2 gSave2, P2
        AddTooltip(hSave2, "Permanently saves the window size/position to .ini")
        Gui, resizer: Add, Button, x252 y390 w27 h21 gLoad2, P2
        Gui, resizer: Add, Button, x284 y362 w27 h21 hwndhSave3 gSave3, P3
        AddTooltip(hSave3, "Permanently saves the window size/position to .ini")
        Gui, resizer: Add, Button, x284 y390 w27 h21 gLoad3, P3
        Gui, resizer: Add, Button, x316 y362 w27 h21 hwndhSave4 gSave4, P4
        AddTooltip(hSave4, "Permanently saves the window size/position to .ini")
        Gui, resizer: Add, Button, x316 y390 w27 h21 gLoad4, P4
        Gui, resizer: Add, Button, x348 y362 w27 h21 hwndhSave5 gSave5, P5
        AddTooltip(hSave5, "Permanently saves the window size/position to .ini")
        Gui, resizer: Add, Button, x348 y390 w27 h21 gLoad5, P5

        Gui, resizer: Add, Button, x460 y380 w27 h21 hwndhSaveHotkey1 gSaveHotkey1, P1
        AddTooltip(hSaveHotkey1, "Permanently save the window size/position to .ini for the hotkey.`nThe Window Title (look above) is saved as well so it will only work on the saved window.`nYou will have to choose and enable the hotkeys manually in the .ini. Check out the project page to learn how to do that.")
        Gui, resizer: Add, Button, x492 y380 w27 h21 hwndhSaveHotkey2 gSaveHotkey2, P2
        AddTooltip(hSaveHotkey2, "Permanently save the window size/position to .ini for the hotkey.`nThe Window Title (look above) is saved as well so it will only work on the saved window.`nYou will have to choose and enable the hotkeys manually in the .ini. Check out the project page to learn how to do that.")
        Gui, resizer: Add, Button, x524 y380 w27 h21 hwndhSaveHotkey3 gSaveHotkey3, P3
        AddTooltip(hSaveHotkey3, "Permanently save the window size/position to .ini for the hotkey.`nThe Window Title (look above) is saved as well so it will only work on the saved window.`nYou will have to choose and enable the hotkeys manually in the .ini. Check out the project page to learn how to do that.")

        Gui, resizer: Add, Button, x231 y289 w52 h18 gResizenow, Resize
        Gui, resizer: Add, Button, x496 y289 w52 h18 gMovenow, Move
        Gui, resizer: Add, Button, x424 y196 w64 h18 gHcenter, H-Center
        Gui, resizer: Add, Button, x424 y217 w64 h18 gVcenter, V-Center
        Gui, resizer: Add, Button, x164 y210 w26 h16 gWplus, +W
        Gui, resizer: Add, Button, x134 y210 w26 h16 gWminus, -W
        Gui, resizer: Add, Button, x197 y201 w26 h16 gHplus, +H
        Gui, resizer: Add, Button, x197 y221 w26 h16 gHminus, -H
    }
    WinGetPos, optX, optY, optW, optH, TSolidBackground Advanced Features
    if ((resX != "") && (resX != -32000)) {
        Gui, resizer: Show, w640 h560 x%resX% y%resY%, TSolidBackground Move/Resize Window
    } else if ((optX != "") && (optX != -32000)) {
        Gui, resizer: Show, w640 h560 x%optX% y%optY%, TSolidBackground Move/Resize Window
    } else {
        Gui, resizer: Show, w640 h560, TSolidBackground Move/Resize Window
    }
    SetTimer, KillCheat, 30
    Gui, newmenu: Destroy
    Refresher()
    Return
}

resizerGuiClose:
resizerButtonClose:
    SetTimer, Refresher, Off
    Gui, resizer: Destroy
Return

resizerGuiEscape:
    SetTimer, Refresher, Off
    Gosub, BackGui
Return

Refresher() {
    Global
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    GuiControl, resizer:, CurrentWH, W: %Wofwin%, H: %Hofwin%
    GuiControl, resizer:, CurrentXY, X: %Xofwin%, Y: %Yofwin%
    Hclient := Hofwin - HclientDif
    Wclient := Wofwin - WclientDif
    GuiControl, resizer:, CurrentClient, W: %Wclient%, H: %Hclient%
    SetTimer, Refresher, 100
    Return
}

RefresherEdit() {
    Global
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    GuiControl, resizer:, Wnew, %Wofwin%
    GuiControl, resizer:, Hnew, %Hofwin%
    GuiControl, resizer:, Xnew, %Xofwin%
    GuiControl, resizer:, Ynew, %Yofwin%
    Return
}

GetAllWindows() {
    Global
    Loop, %WinIDPseudoAll%           ;Clean up
    {
        VarSetCapacity(WinIDPseudoAll%A_Index%, 0)
    }
    WinIDAll := 0
    WinIDAll := Object()
    DropDownAll := ""
    ;DetectHiddenWindows, On                    ;Detect hidden windows if needed.
    WinGet, WinIDPseudoAll, List
    Loop, %WinIDPseudoAll%              ;Copy pseudo-array to the real array
    {
        WinIDAll.InsertAt(A_Index, WinIDPseudoAll%A_Index%)
    }
    currentIndex := 1
    Loop                                ;for-loop index can't be modified.
    {
        if (currentIndex > WinIDAll.Length()) {
            Break
        }
        thisWasRemoved := 0
        currentID := WinIDAll[currentIndex]
        WinGetTitle, LoopTitle, ahk_id %currentID%
        ;StringReplace, LoopTitle, LoopTitle,`n,,All            ;If window titles had new lines.
        if (!LoopTitle) {
            if (excludeSystemWindows == 1) {
                WinIDAll.RemoveAt(currentIndex)
                currentIndex--
                thisWasRemoved := 1
            } else {
                WinGetClass, LoopClass, ahk_id %currentID%
                LoopTitle := "[UNTITLED] (Class:" . LoopClass . ") Window"
                if (!LoopClass) {
                    LoopTitle := "[UNTITLED][WITHOUT CLASS] " . currentIndex . ".th Window"
                }
                DropDownAll .= LoopTitle . "`n"
            }
        } else {
            if ((excludeSystemWindows == 1) && (excludedTitles.HasKey(LoopTitle))) {        ;.HasKey(): Best alternative to .indexOf etc. 
                WinIDAll.RemoveAt(currentIndex)
                currentIndex--
                thisWasRemoved := 1
            } else if ((protectVNR) && (LoopTitle == "Kagami")) {
                WinIDAll.RemoveAt(currentIndex)
                currentIndex--
                thisWasRemoved := 1
            } else {
                DropDownAll .= LoopTitle . "`n"
            }
        }
        if (TBResized == currentID) {
            DropDownCurrent := currentIndex + 1
            if (thisWasRemoved) {
                DropDownCurrent := 1
            }
        }
        currentIndex++
    }
    StringTrimRight, DropDownAll, DropDownAll, 1
    ;DetectHiddenWindows, Off
}

DropDownSelected:
    Gui, Submit, NoHide
    VarIndex := DropDownCurrent - 1
    if (VarIndex != 0) {
        if (TBResized != WinIDAll[VarIndex]) {
            ;DrawHUD("Got a new window to move/resize.", "y160", "c836DFF", "s11", "1350")
            TBResized := WinIDAll[VarIndex]
            WinGetPos, Xorig, Yorig, Worig, Horig, ahk_id %TBResized%
        }
        WinGetPos, aX, aY, aW, aH, A
        Gui, cheat: Color, 292929
        Gui, cheat: Show, w640 h560 x%aX% y%aY%, TSolidBackground Move/Resize Window
        ShowResizer()
        ;SetTimer, KillCheat, 30
    }
Return

Resizenow:
    Gui, Submit, NoHide
    WinMove, ahk_id %TBResized%,,,, %Wnew%, %Hnew%
    RefresherEdit()
Return    

Movenow:
    Gui, Submit, NoHide
    WinMove, ahk_id %TBResized%,, %Xnew%, %Ynew%
    RefresherEdit()
Return

Vcenter:    
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    GetMonitorIndexFromWindow(TBResized)
    mHeight := monitorBottom-monitorTop
    mWidth := monitorRight-monitorLeft
    WinMove, ahk_id %TBResized%,,, (mHeight-Hofwin)/2+monitorTop
    RefresherEdit()
Return

Hcenter:
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    GetMonitorIndexFromWindow(TBResized)
    mHeight := monitorBottom-monitorTop
    mWidth := monitorRight-monitorLeft
    WinMove, ahk_id %TBResized%,, (mWidth-Wofwin)/2+monitorLeft,
    RefresherEdit()
Return

Wup:
    Gui, Submit, NoHide
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    newthing := Yofwin-Vmove
    WinMove, ahk_id %TBResized%,,, %newthing%
    RefresherEdit()
Return

Wdown:
    Gui, Submit, NoHide
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    newthing := Yofwin+Vmove
    WinMove, ahk_id %TBResized%,,, %newthing%
    RefresherEdit()
Return

Wleft:
    Gui, Submit, NoHide
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    newthing := Xofwin-Vmove
    WinMove, ahk_id %TBResized%,, %newthing%,
    RefresherEdit()
Return

Wright:
    Gui, Submit, NoHide
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    newthing := Xofwin+Vmove
    WinMove, ahk_id %TBResized%,, %newthing%,
    RefresherEdit()
Return

Wplus:
    Gui, Submit, NoHide
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    newthing := Wofwin+Vresize
    WinMove, ahk_id %TBResized%,,,, %newthing%
    RefresherEdit()
Return

Wminus:
    Gui, Submit, NoHide
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    newthing := Wofwin-Vresize
    WinMove, ahk_id %TBResized%,,,, %newthing%
    RefresherEdit()
Return

Hplus:
    Gui, Submit, NoHide
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    newthing := Hofwin+Vresize
    WinMove, ahk_id %TBResized%,,,,, %newthing%
    RefresherEdit()
Return

Hminus:
    Gui, Submit, NoHide
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    newthing := Hofwin-Vresize
    WinMove, ahk_id %TBResized%,,,,, %newthing%
    RefresherEdit()
Return

MinWin:
    Gui, Submit, NoHide
    WinGet, isWinMin, MinMax, ahk_id %TBResized%
    if (isWinMin == -1) {
        WinRestore, ahk_id %TBResized%
    } else {
        WinMinimize, ahk_id %TBResized%
    }
Return

MaxWin:
    Gui, Submit, NoHide
    WinGet, isWinMax, MinMax, ahk_id %TBResized%
    if (isWinMax == 1) {
        WinRestore, ahk_id %TBResized%
    } else {
        WinMaximize, ahk_id %TBResized%
    }
Return

TSBWin:
    Gui, Submit, NoHide
    if (TBResized) {
        RunTSB(TBResized)  
    }
Return

CloseWin:
    Gui, Submit, NoHide
    WinClose, ahk_id %TBResized%
Return

Origxy:
    WinMove, ahk_id %TBResized%,, %Xorig%, %Yorig%
Return

Origwh:
    WinMove, ahk_id %TBResized%,,,, %Worig%, %Horig%
Return

Savetemp1:
    WinGetPos, Temp1X, Temp1Y, Temp1W, Temp1H, ahk_id %TBResized%
Return

Loadtemp1:
    WinMove, ahk_id %TBResized%,, %Temp1X%, %Temp1Y%, %Temp1W%, %Temp1H%
Return

Savetemp2:
    WinGetPos, Temp2X, Temp2Y, Temp2W, Temp2H, ahk_id %TBResized%
Return

Loadtemp2:
    WinMove, ahk_id %TBResized%,, %Temp2X%, %Temp2Y%, %Temp2W%, %Temp2H%
Return

Save1:
    Savepos(1)
Return

Load1:
    Loadpos(1)
Return

Save2:
    Savepos(2)
Return

Load2:
    Loadpos(2)
Return

Save3:
    Savepos(3)
Return

Load3:
    Loadpos(3)
Return

Save4:
    Savepos(4)
Return

Load4:
    Loadpos(4)
Return

Save5:
    Savepos(5)
Return

Load5:
    Loadpos(5)
Return

Loadpos(posnr) {
    Global
    Readini(PermX, "Saved Position " . posnr, "X")
    Readini(PermY, "Saved Position " . posnr, "Y")
    Readini(PermW, "Saved Position " . posnr, "W")
    Readini(PermH, "Saved Position " . posnr, "H")
    if (PermX == "ERROR") {
        new StackingPleasantNotify("TSolidBackground", "Saved position or .ini file doesn't exist.", "", 400, "auto", 7000, "0x292929", "0x836DFF", "0xF34242 wBold", "0xDCDCCC wBold")
    } else {
        WinMove, ahk_id %TBResized%,, %PermX%, %PermY%, %PermW%, %PermH%
    }
    Return
}

Savepos(posnr) {
    Global
    IfNotExist, %A_ScriptDir%\TSolidBackground.ini
    {
        CreateSaveini(1)
    }
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    Writeini(Xofwin, "Saved Position " . posnr, "X")
    Writeini(Yofwin, "Saved Position " . posnr, "Y")
    Writeini(Wofwin, "Saved Position " . posnr, "W")
    Writeini(Hofwin, "Saved Position " . posnr, "H")
    Return
}


SaveHotkey1:
    SaveHotkeypos(1)
Return

SaveHotkey2:
    SaveHotkeypos(2)
Return

SaveHotkey3:
    SaveHotkeypos(3)
Return

LoadHotkey1:
    LoadHotkeypos(1)
Return

LoadHotkey2:
    LoadHotkeypos(2)
Return

LoadHotkey3:
    LoadHotkeypos(3)
Return

SaveHotkeypos(posnr) {
    Global
    IfNotExist, %A_ScriptDir%\TSolidBackground.ini 
    {
        CreateSaveini(1)
    }
    WinGetTitle, titleTBResized, ahk_id %TBResized%
    WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
    Writeini(Xofwin, "Hotkey Position " . posnr, "X")
    Writeini(Yofwin, "Hotkey Position " . posnr, "Y")
    Writeini(Wofwin, "Hotkey Position " . posnr, "W")
    Writeini(Hofwin, "Hotkey Position " . posnr, "H")
    Writeini(titleTBResized, "Hotkey Position " . posnr, "Title")
    Return
}

LoadHotkeypos(posnr) {
    Global
    Readini(PermX, "Hotkey Position " . posnr, "X")
    Readini(PermY, "Hotkey Position " . posnr, "Y")
    Readini(PermW, "Hotkey Position " . posnr, "W")
    Readini(PermH, "Hotkey Position " . posnr, "H")
    Readini(titleTBResized, "Hotkey Position " . posnr, "Title")
    if (PermX == "ERROR") {
        new StackingPleasantNotify("TSolidBackground", "Saved hotkey position or .ini file doesn't exist.", "", 400, "auto", 7000, "0x292929", "0x836DFF", "0xF34242 wBold", "0xDCDCCC wBold")
    } else {
        WinMove, %titleTBResized%,, %PermX%, %PermY%, %PermW%, %PermH%
    }
    Return
}


ReloadDropDown:
    WinGetPos, aX, aY, aW, aH, A
    Gui, cheat: Color, 292929
    Gui, cheat: Show, w640 h560 x%aX% y%aY%, TSolidBackground Move/Resize Window
    ShowResizer()
    ;SetTimer, KillCheat, 30
Return

CopyTitle:
    WinGetTitle, titleTBResized, ahk_id %TBResized%
    Clipboard := titleTBResized
Return
;Move/Resize End

;Hooker Start
ShowHooker() {
    Global
    Gui, hook: Destroy
    Gui, hook: +AlwaysOnTop
    Gui, hook: Color, 292929
    Gui, hook: Font, s14 c836DFF Bold, Segoe UI
    Gui, hook: Add, Text, x238 y15, Window Hooker (Alpha)
    Gui, hook: Font, s10 c836DFF norm Underline
    Gui, hook: Add, Text, x219 y435, Create .ini for permanent options
    Gui, hook: Font, s10 cDCDCCC norm
    Gui, hook: Add, Button, x254 y460 w130 h28 gRunCreateSaveini, Create/Save .ini
    Gui, hook: Add, Text, x112 y112, Main Window:  
    Gui, hook: Add, Text, x112 y152, Hooked Window:  
    Gui, hook: Add, Text, x60 y47 , Window Hooker currently only works for minimizing windows/switching tabs on browsers.`nFor now it can't make the windows move together. The .ini file will save the window titles too.
    Gui, hook: Add, Checkbox, x112 y280 Checked%hookPartialTitle% vhookPartialTitle gSetnow, `nHook anything that contains the Main Window Title `n(off: Hooks only when the titles are identical)
    Gui, hook: Font, s10
    Gui, hook: Add, Text, x500 y355, Tip: You can `nalso stop the `nwindow hooker `nusing the `ntray menu.
    Gui, hook: Font, s10 cBlack norm
    Gui, hook: Add, Edit, x234 y111 w170 h20 vTitleOne, %TitleOne%
    Gui, hook: Add, Edit, x234 y151 w170 h20 vTitleTwo, %TitleTwo%
    Gui, hook: Add, Button, x421 y109 h23 gGetactiveOne, Get last active window
    Gui, hook: Add, Button, x421 y149 h23 gGetactiveTwo, Get last active window
    if (!Hooking) {
        Gui, hook: Add, Button, x237 y192 w164 h66 gStartHook, Start Hook
    } else {
        Gui, hook: Add, Button, x237 y192 w164 h66 gStopHook, Stop Hook
    }
    Gui, hook: Font, s10 cBlack norm Bold
    Gui, hook: Add, Button, x174 y515 w290 h24, Close
    Gui, hook: Add, Button, x10 y10 w44 h24 gBackGui, Back
    WinGetPos, optX, optY, optW, optH, TSolidBackground Advanced Features
    if ((optX == "") || (optX == -32000)) {
        Gui, hook: Show, w640 h560, TSolidBackground Window Hooker (Alpha)
    } else {
        Gui, hook: Show, w640 h560 x%optX% y%optY%, TSolidBackground Window Hooker (Alpha)
    }
    Gui, newmenu: Destroy
    Return
}

StartHookGui:
    ShowHooker()
Return

hookButtonClose:
    Gui, hook: Destroy
Return

hookGuiEscape:
    Gosub, BackGui
Return

GetactiveOne:
    Gui, hook: Destroy
    Sleep, 75
    WinGetTitle, TitleOne, A
    ShowHooker()
Return

GetactiveTwo:
    Gui, hook: Destroy
    Sleep, 75
    WinGetTitle, TitleTwo, A
    ShowHooker()
Return

StartHook:
    Gui, Submit, NoHide
    Hooking := 1
    Gui, hook: Destroy
    Hooker()
    Menu, Tray, Enable, Stop Window Hooker
Return

StopHook:
    Gui, hook: Destroy
    KillHooker()
Return

;TitleOne: Base Window, TitleTwo: Hooked Window
Hooker() {
    Global
    ;WinGet, OneisNotMin, MinMax, %TitleTwo%
    ;CurrActiveID := WinExist("A")
    ;WinGetTitle, CurrActiveTitle, ahk_id %CurrActiveID%
    oldMatchMode := A_TitleMatchMode
    ;Set title mode and check for TitleOne
    if (hookPartialTitle) {
        SetTitleMatchMode, 2
        WinGetTitle, CurrActiveTitle, A
        checkTitleOne := InStr(CurrActiveTitle, TitleOne)
    } else {
        SetTitleMatchMode, 1
        WinGetTitle, CurrActiveTitle, A
        checkTitleOne := (CurrActiveTitle == TitleOne)
    }
    WinGet, TwoisNotMin, MinMax, %TitleTwo%
    WinGet, TwoWindowExStyle, ExStyle, %TitleTwo%
    ;If TitleOne was found
    if (checkTitleOne > 0) {
        ;if we are using kill mode, wait for window two to exist
        if (hookerKillWindowTwoInstead) {
            WinWait, %TitleTwo%,, 3
        }
        ;restore window two if it is minimized
        if (TwoisNotMin == -1) {
            ;Restore WindowTwo
            WinRestore, %TitleTwo%
        }

        if (TwoWindowExStyle & 0x8) {
            ;do nothing if TitleTwo is always on top
        } else {
            ;Enable always on top for TitleTwo
            WinSet, AlwaysOnTop, on, %TitleTwo%
        }
        
        ;Handle hookerTopOfWindowTwoRegex
        ;Enable RegEx TitleMatchMode temprorarily
        oldMatchModeRX := A_TitleMatchMode
        SetTitleMatchMode, RegEx
        ;restore TopOfWindowTwo and move it to the top 
        WinRestore, % hookerTopOfWindowTwoRegex
        WinSet, Top,, % hookerTopOfWindowTwoRegex
        SetTitleMatchMode, %oldMatchModeRX%

    } else {
        ;check if active title is not equal to titletwo; if partial is disabled
        ;OR check if active title does not include titletwo; if partial is enabled
        if ((!hookPartialTitle && (CurrActiveTitle != TitleTwo)) || (hookPartialTitle && !InStr(CurrActiveTitle, TitleTwo))) {
                ;Check if the title is empty
            if ((CurrActiveTitle != "")
                ;and Check for VNR
                && (protectVNR && (CurrActiveTitle != "Kagami"))
                ;and Check for the four hidden TSolidBackground windows
                && (InStr(CurrActiveTitle, "TSolidBackground BG") == 0)
                ;and Check for the alt+tab menu
                && (InStr(CurrActiveTitle, "Task Switching") == 0)
                ;and Check for the custom title. (Can be improved if necessary)
                && (InStr(CurrActiveTitle, hookerExcludeWindow) == 0))
            {
                ;check if title two is always on top
                if (TwoWindowExStyle & 0x8) {
                    WinSet, AlwaysOnTop, off, %TitleTwo%
                } else {
                    ;do nothing if TitleTwo is NOT always on top
                }

                ;if TitleTwo is not minimized, minimize it.
                if (TwoisNotMin != -1) {
                    ;kill it or minimize it
                    if (hookerKillWindowTwoInstead) {
                        WinClose, %TitleTwo%
                    } else {
                        WinMinimize, %TitleTwo%
                    }
                }
            }
        }
        /*
        IfWinNotExist, %TitleOne%
        {
            if (TwoisNotMin != -1) {
                WinMinimize, %TitleTwo%
            }
        }
        */
    }
    if (Hooking) {
        SetTimer, Hooker, 200
    } else {
        ;if disabled, turn always on top off for TitleTwo
        if (TwoWindowExStyle & 0x8) {
            WinSet, AlwaysOnTop, off, %TitleTwo%
        }
    }
    ;Restore title match mode
    SetTitleMatchMode, %oldMatchMode%
    Return
}

KillHooker() {
    Global
    Hooking := 0
    SetTimer, Hooker, Off
    ShowHooker()
    Menu, Tray, Disable, Stop Window Hooker
    Return
}
;Hooker End

;Dummy Start
StartDummyWindow:
    Gui, Destroy
    Gui, Dummy: Destroy
    Gui, Dummy: +Resize +AlwaysOnTop
    Gui, Dummy: Color, 292929
    Gui, Dummy: Font, s10 c836DFF, Segoe UI
    Gui, Dummy: Add, Button, x35 y25 w164 h26 gCloseDummy, Close Dummy Window
    Gui, Dummy: Add, Button, x35 y60 w164 h26 gSaveDummy, Save to .ini && Close
    Gui, Dummy: Font, cDCDCCC
    Gui, Dummy: Add, Text, x43 y100, Move 
    Gui, Dummy: Add, Text, x147 y100, Resize 
    Gui, Dummy: Add, Text, x26 y188, By: 
    Gui, Dummy: Add, Text, x129 y188, By: 
    Gui, Dummy: Add, Text, x55 y235, Center:
    Gui, Dummy: Font, s9 c836DFF norm Bold
    Gui, Dummy: Add, Edit, x47 y188 w50 h20 Number vVmove, %Vmove%
    Gui, Dummy: Add, UpDown, 0x80 Range1-90000, %Vmove%
    Gui, Dummy: Add, Edit, x150 y188 w50 h20 Number vVresize, %Vresize%
    Gui, Dummy: Add, UpDown, 0x80 Range1-90000, %Vresize%
    Gui, Dummy: Font, s9 c836DFF norm
    Gui, Dummy: Add, Button, x51 y124 w16 h16 gWup, U
    Gui, Dummy: Add, Button, x51 y160 w16 h16 gWdown, D
    Gui, Dummy: Add, Button, x33 y142 w16 h16 gWleft, L
    Gui, Dummy: Add, Button, x69 y142 w16 h16 gWright, R
    Gui, Dummy: Add, Button, x147 y143 w28 h16 gWplus, +W
    Gui, Dummy: Add, Button, x181 y133 w28 h16 gHplus, +H
    Gui, Dummy: Add, Button, x115 y143 w28 h16 gWminus, -W
    Gui, Dummy: Add, Button, x181 y153 w28 h16 gHminus, -H
    Gui, Dummy: Add, Button, x103 y227 w64 h18 gHcenter, H-Center
    Gui, Dummy: Add, Button, x103 y248 w64 h18 gVcenter, V-Center
    Gui, Dummy: Font, s10 cDCDCCC
    Gui, Dummy: Add, Text, x242 y90, Tip: You might not`nwant to use this`ntogether with the`nMove/Resize menu`nas they use the`nsame functions.
    SavedDummy := 0
    IfExist, %A_ScriptDir%\TSolidBackground.ini
    {
        Readini(DummyX, "Dummy Window", "Dummy X")
        Readini(DummyY, "Dummy Window", "Dummy Y")
        Readini(DummyW, "Dummy Window", "Dummy W")
        Readini(DummyH, "Dummy Window", "Dummy H")
        SavedDummy := 1
    }
    if ((SavedDummy) && (DummyX != "ERROR")) {
        Gui, Dummy: Show, x%DummyX% y%DummyY% w%DummyW% h%DummyH%, TSolidBackground Dummy Window
    } else {
        Gui, Dummy: Show, w640 h560, TSolidBackground Dummy Window
    }

    TBResized := WinExist("A")
Return

CloseDummy:
    Gui, Dummy: Destroy
Return

SaveDummy:
    WinGetPos, DummyX, DummyY, DummyW, DummyH, A
    SysGet, Border_SizeW, 32
    SysGet, Border_SizeH, 33
    SysGet, Caption_Size, 4
    DummyH := DummyH - 2*Border_SizeH - Caption_Size
    DummyW := DummyW - 2*Border_SizeW
    IfNotExist, %A_ScriptDir%\TSolidBackground.ini 
    {
        CreateSaveini(1)
    }
    Writeini(DummyX, "Dummy Window", "Dummy X")
    Writeini(DummyY, "Dummy Window", "Dummy Y")
    Writeini(DummyW, "Dummy Window", "Dummy W")
    Writeini(DummyH, "Dummy Window", "Dummy H")
    SavedDummy := 1
    Gui, Dummy: Destroy
Return
;Dummy End

;Mouse Mover Start
MouseMover() {
    Global
    Gui, mmover: Destroy
    ;Gui, mmover: +AlwaysOnTop
    Gui, mmover: Color, 292929
    Gui, mmover: Font, s14 c836DFF Bold, Segoe UI
    Gui, mmover: Add, Text, x258 y15, Mouse Mover
    Gui, mmover: Font, s9 c836DFF norm Bold
    Gui, mmover: Add, Edit, x305 y312 w50 h20 Number vMoveBy, %MoveBy%
    Gui, mmover: Add, UpDown, 0x80 Range1-90000, %MoveBy%
    Gui, mmover: Font, s9 cBlack norm
    Gui, mmover: Add, Button, x355 y313 w34 h18 gSetnow, Set
    Gui, mmover: Font, s10 Bold
    Gui, mmover: Add, Button, x174 y515 w290 h24, Close
    Gui, mmover: Add, Button, x10 y10 w44 h24 gmmoverGuiEscape, Back
    Gui, mmover: Font, s10 cDCDCCC norm
    Gui, mmover: Add, Button, x254 y460 w130 h28 gRunCreateSaveini, Create/Save .ini
    Gui, mmover: Add, Checkbox, x230 y342 Checked%preventSend% hwndhPreventSending vpreventSend gSetnow, Also prevent hotkeys from working
    AddTooltip(hPreventSending, "Prevents Left Arrow from moving left etc.")
    Gui, mmover: Add, Text, x245 y311, Move by:
    Gui, mmover: Font, s13
    Gui, mmover: Add, Text, x220 y147, While this window is open,
    Gui, mmover: Add, Text, x132 y177,   Use arrow keys to move the mouse pixel by pixel.`nHold Shift to move at half speed, Hold Ctrl for triple speed.
    Gui, mmover: Add, Text, x132 y227, Press [Numpad 1] or [Numpad End] for left click `nPress [Numpad 2] or [Numpad Down] for right click `nPress [Numpad 3] or [Numpad PgDn] for middle click.
    Gui, mmover: Font, s10 c836DFF norm Underline
    Gui, mmover: Add, Text, x219 y435, Create .ini for permanent options
    Gui, mmover: Font, s10 cDCDCCC norm
    WinGetPos, optX, optY, optW, optH, TSolidBackground Advanced Features
    if ((optX == "") || (optX == -32000)) {
        Gui, mmover: Show, w640 h560, TSolidBackground Mouse Mover
    } else {
        Gui, mmover: Show, w640 h560 x%optX% y%optY%, TSolidBackground Mouse Mover
    }
    Gui, newmenu: Destroy
    mouseMoving := 1
    SetMouseDelay, 0
    Return
}

StartMouseMoveGui:
    MouseMover()
Return

mmoverGuiClose:
mmoverButtonClose:
    mouseMoving := 0
    Gui, mmover: Destroy
Return

mmoverGuiEscape:
    mouseMoving := 0
    Gosub, BackGui
Return



getMouseSpeed() {
    Global
    ;Shift is half speed, ctrl is triple
    if GetKeyState("Shift") {
        return MoveBy / 2
    } else if GetKeyState("Ctrl") {
        return MoveBy * 3
    } else {
        return MoveBy
    }
}

#If mouseMoving

*Left::
    MovingBy := getMouseSpeed()
    MouseMove, -%MovingBy%, 0,, R
    if (!preventSend)
        Send, {Left} 
Return

*Right::
    MovingBy := getMouseSpeed()
    MouseMove, %MovingBy%, 0,, R
    if (!preventSend)
        Send, {Right}
Return

*Up::
    MovingBy := getMouseSpeed()
    MouseMove, 0, -%MovingBy%,, R
    if (!preventSend)
        Send, {Up}
Return

*Down::
    MovingBy := getMouseSpeed()
    MouseMove, 0, %MovingBy%,, R
    if (!preventSend)
        Send, {Down}
Return

Numpad1::
    Click, Down
    if (!preventSend)
        Send, {Numpad1}
Return

Numpad1 Up::
    Click, Up
Return

Numpad2::
    Click, Down, Right
    if (!preventSend)
        Send, {Numpad2}
Return

Numpad2 Up::
    Click, Up, Right
Return

Numpad3::
    Click, Down, Middle
    if (!preventSend)
        Send, {Numpad3}
Return

Numpad3 Up::
    Click, Up, Middle
Return

NumpadEnd::
    Click, Down
    if (!preventSend)
        Send, {NumpadEnd}
Return

NumpadEnd Up::
    Click, Up
Return

NumpadDown::
    Click, Down, Right
    if (!preventSend)
        Send, {NumpadDown}
Return

NumpadDown Up::
    Click, Up, Right
Return

NumpadPgdn::
    Click, Down, Middle
    if (!preventSend)
        Send, {NumpadPgdn}
Return

NumpadPgdn Up::
    Click, Up, Middle
Return
#If
;Mouse Mover End

;ini handling
RunCreateSaveini:    
    Gui, Submit, NoHide
    CreateSaveini(1)
Return

CreateSaveini(showit) {
    Global
    if (bgcolor == "") {
        bgcolor := 250000
    }
    if ((Iniexists == "No") && (CheckForUpdates != 1)) {
        MsgBox, 4100, TSolidBackground, Would you like to automatically check for updates on startup?
        IfMsgBox, Yes
        {
            CheckForUpdates := 1
        }
    }
    ;Try to keep the ini in order.
    IfNotExist, %A_ScriptDir%\TSolidBackground.ini
    {
        FileAppend, [Help]`n, %A_ScriptDir%\TSolidBackground.ini
        FileAppend, [Hotkeys]`n, %A_ScriptDir%\TSolidBackground.ini
        FileAppend, [Settings]`n, %A_ScriptDir%\TSolidBackground.ini
        FileAppend, [Dummy Window], %A_ScriptDir%\TSolidBackground.ini
        FileAppend, [Custom TSB Sizes 1]`n, %A_ScriptDir%\TSolidBackground.ini
        FileAppend, [Custom TSB Sizes 2]`n, %A_ScriptDir%\TSolidBackground.ini
        FileAppend, [Custom TSB Sizes 3]`n, %A_ScriptDir%\TSolidBackground.ini
        FileAppend, [Saved Position 1]`n, %A_ScriptDir%\TSolidBackground.ini
        FileAppend, [Saved Position 2]`n, %A_ScriptDir%\TSolidBackground.ini
        FileAppend, [Saved Position 3]`n, %A_ScriptDir%\TSolidBackground.ini
        FileAppend, [Saved Position 4]`n, %A_ScriptDir%\TSolidBackground.ini
        FileAppend, [Saved Position 5]`n, %A_ScriptDir%\TSolidBackground.ini
    }
    Writeini(" https://github.com/Onurtag/TSolidBackground/#tsolidbackground", "Help", "#For help, check out the readme")
    Writeini(TSolidBackgroundKey, "Hotkeys", "TSolidBackground Key")
    Writeini(OnTopKey, "Hotkeys", "On Top Key")
    Writeini(CenterKey, "Hotkeys", "Center Window Key")
    Writeini(TaskbarKey, "Hotkeys", "Show Hide Taskbar Key")
    Writeini(OptionsKey, "Hotkeys", "Advanced Features Key")
    Writeini(SuspendKey, "Hotkeys", "Suspend Hotkeys Key")
    Writeini(MoveKey1, "Hotkeys", "Move Key 1")
    Writeini(MoveKey2, "Hotkeys", "Move Key 2")
    Writeini(MoveKey3, "Hotkeys", "Move Key 3")
    Writeini(IniVersion, "Settings", "Ini Version")
    Writeini(bgcolor, "Settings", "Background Color")
    Writeini(CustomWidthLeft, "Settings", "Custom Width Left")
    Writeini(CustomWidthRight, "Settings", "Custom Width Right")
    Writeini(CustomHeightTop, "Settings", "Custom Height Top")
    Writeini(CustomHeightBottom, "Settings", "Custom Height Bottom")
    Writeini(startupWindow, "Settings", "Enable Startup Window")
    Writeini(excludeSystemWindows, "Settings", "Exclude system windows from dropdown")
    Writeini(CheckForUpdates, "Settings", "Check for Updates on Startup")
    Writeini(useKeyboardHook, "Settings", "Use Keyboard Hook")
    Writeini(TitleOne, "Settings", "Hooker Main Window")
    Writeini(TitleTwo, "Settings", "Hooker Hooked Window")
    Writeini(hookPartialTitle, "Settings", "Hook Partial Main Window Title")
    Writeini(MoveBy, "Settings", "Mouse Mover Move By")
    Writeini(Debug, "Settings", "Debug")
    if (showit) {
        new StackingPleasantNotify("TSolidBackground", "TSolidBackground.ini file was created/saved.", "", 400, "auto", 3000, "0x292929", "0x836DFF", "0xb8b8ac wBold", "0xDCDCCC wBold")
    }
    Return
}
;Use functions instead of the default syntax to save/load the ini values. Definitely useless.
Writeini(value, section, key) {
    IniWrite, %value%, %A_ScriptDir%\TSolidBackground.ini, %section%, %key%
}

Readini(ByRef outvalue, section, key) {
    IniRead, outvalue, %A_ScriptDir%\TSolidBackground.ini, %section%, %key%
}
;ini handling end

Restarted:
    Reload
Return

WinStack(winid) {
    Global
    if (!Arrs.hasKey(winid)) {
        Arrs[winid] := true
    }
}

Exited:    
    ExitApp
Return

Exiting(ExitReason, ExitCode) {
    Global
    for currentWindow, b in Arrs
    {
        WinSet, AlwaysOnTop, off, ahk_id %currentWindow%
    }
    WinShow, ahk_class Shell_TrayWnd
    WinShow, Start ahk_class Button
    ExitApp
}


;---Pre-made functions & libraries---

;GetMonitorIndexFromWindow() by Shinywong.
;Used to get the width/height of the current monitor.
;From https://autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355
;-------------------------------------------------------------------------------
GetMonitorIndexFromWindow(windowHandle) {
    Global
    monitorIndex := 1
    VarSetCapacity(monitorInfo, 40)
    NumPut(40, monitorInfo)
    if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2)) 
        && DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) 
    {
        monitorLeft   := NumGet(monitorInfo,  4, "Int")
        monitorTop    := NumGet(monitorInfo,  8, "Int")
        monitorRight  := NumGet(monitorInfo, 12, "Int")
        monitorBottom := NumGet(monitorInfo, 16, "Int")
        ;workLeft      := NumGet(monitorInfo, 20, "Int")
        ;workTop       := NumGet(monitorInfo, 24, "Int")
        ;workRight     := NumGet(monitorInfo, 28, "Int")
        ;workBottom    := NumGet(monitorInfo, 32, "Int")
        ;isPrimary     := NumGet(monitorInfo, 36, "Int") & 1
        SysGet, monitorCount, MonitorCount
        Loop, %monitorCount%
        {
            SysGet, tempMon, Monitor, %A_Index%
            if ((monitorLeft == tempMonLeft) and (monitorTop == tempMonTop)
                and (monitorRight == tempMonRight) and (monitorBottom == tempMonBottom))
            {
                monitorIndex := A_Index
                break
            }
        }
    }
    Return
}

;-------------------------------------------------------------------------------


;AddTooltip by Various authors
;From https://autohotkey.com/boards/viewtopic.php?&t=30079

;-------------------------------------------------------------------------------
;
; Function: AddTooltip v2.0
;
; Description:
;
;   Add/Update tooltips to GUI controls.
;
; Credit and History:
;
;   Original author: Superfraggle
;   * Post: <http://www.autohotkey.com/board/topic/27670-add-tooltips-to-controls/>
;
;   Updated to support Unicode: art
;   * Post: <http://www.autohotkey.com/board/topic/27670-add-tooltips-to-controls/page-2#entry431059>
;
;   Additional: jballi.
;   Bug fixes.  Added support for x64.  Removed Modify parameter.  Added
;   additional functionality, constants, and documentation.
;
;-------------------------------------------------------------------------------
AddTooltip(p1,p2:="",p3="")
    {
    Static hTT

          ;-- Misc. constants
          ,CW_USEDEFAULT:=0x80000000
          ,HWND_DESKTOP :=0

          ;-- Tooltip delay time constants
          ,TTDT_AUTOPOP:=2
                ;-- Set the amount of time a tooltip window remains visible if
                ;   the pointer is stationary within a tool's bounding
                ;   rectangle.

          ;-- Tooltip styles
          ,TTS_ALWAYSTIP:=0x1
                ;-- Indicates that the tooltip control appears when the cursor
                ;   is on a tool, even if the tooltip control's owner window is
                ;   inactive.  Without this style, the tooltip appears only when
                ;   the tool's owner window is active.

          ,TTS_NOPREFIX:=0x2
                ;-- Prevents the system from stripping ampersand characters from
                ;   a string or terminating a string at a tab character.
                ;   Without this style, the system automatically strips
                ;   ampersand characters and terminates a string at the first
                ;   tab character.  This allows an application to use the same
                ;   string as both a menu item and as text in a tooltip control.

          ;-- TOOLINFO uFlags
          ,TTF_IDISHWND:=0x1
                ;-- Indicates that the uId member is the window handle to the
                ;   tool.  If this flag is not set, uId is the identifier of the
                ;   tool.

          ,TTF_SUBCLASS:=0x10
                ;-- Indicates that the tooltip control should subclass the
                ;   window for the tool in order to intercept messages, such
                ;   as WM_MOUSEMOVE.  If this flag is not used, use the
                ;   TTM_RELAYEVENT message to forward messages to the tooltip
                ;   control.  For a list of messages that a tooltip control
                ;   processes, see TTM_RELAYEVENT.

          ;-- Tooltip icons
          ,TTI_NONE         :=0
          ,TTI_INFO         :=1
          ,TTI_WARNING      :=2
          ,TTI_ERROR        :=3
          ,TTI_INFO_LARGE   :=4
          ,TTI_WARNING_LARGE:=5
          ,TTI_ERROR_LARGE  :=6

          ;-- Extended styles
          ,WS_EX_TOPMOST:=0x8

          ;-- Messages
          ,TTM_ACTIVATE      :=0x401                    ;-- WM_USER + 1
          ,TTM_ADDTOOLA      :=0x404                    ;-- WM_USER + 4
          ,TTM_ADDTOOLW      :=0x432                    ;-- WM_USER + 50
          ,TTM_DELTOOLA      :=0x405                    ;-- WM_USER + 5
          ,TTM_DELTOOLW      :=0x433                    ;-- WM_USER + 51
          ,TTM_GETTOOLINFOA  :=0x408                    ;-- WM_USER + 8
          ,TTM_GETTOOLINFOW  :=0x435                    ;-- WM_USER + 53
          ,TTM_SETDELAYTIME  :=0x403                    ;-- WM_USER + 3
          ,TTM_SETMAXTIPWIDTH:=0x418                    ;-- WM_USER + 24
          ,TTM_SETTITLEA     :=0x420                    ;-- WM_USER + 32
          ,TTM_SETTITLEW     :=0x421                    ;-- WM_USER + 33
          ,TTM_UPDATETIPTEXTA:=0x40C                    ;-- WM_USER + 12
          ,TTM_UPDATETIPTEXTW:=0x439                    ;-- WM_USER + 57

    ;-- Save/Set DetectHiddenWindows
    l_DetectHiddenWindows:=A_DetectHiddenWindows
    DetectHiddenWindows On

    ;-- Tooltip control exists?
    if not hTT
        {
        ;-- Create Tooltip window
        hTT:=DllCall("CreateWindowEx"
            ,"UInt",WS_EX_TOPMOST                       ;-- dwExStyle
            ,"Str","TOOLTIPS_CLASS32"                   ;-- lpClassName
            ,"Ptr",0                                    ;-- lpWindowName
            ,"UInt",TTS_ALWAYSTIP|TTS_NOPREFIX          ;-- dwStyle
            ,"UInt",CW_USEDEFAULT                       ;-- x
            ,"UInt",CW_USEDEFAULT                       ;-- y
            ,"UInt",CW_USEDEFAULT                       ;-- nWidth
            ,"UInt",CW_USEDEFAULT                       ;-- nHeight
            ,"Ptr",HWND_DESKTOP                         ;-- hWndParent
            ,"Ptr",0                                    ;-- hMenu
            ,"Ptr",0                                    ;-- hInstance
            ,"Ptr",0                                    ;-- lpParam
            ,"Ptr")                                     ;-- Return type

        ;-- Disable visual style
        ;   Note: Uncomment the following to disable the visual style, i.e.
        ;   remove the window theme, from the tooltip control.  Since this
        ;   function only uses one tooltip control, all tooltips created by this
        ;   function will be affected.
;;;;;        DllCall("uxtheme\SetWindowTheme","Ptr",hTT,"Ptr",0,"UIntP",0)

        ;-- Set the maximum width for the tooltip window
        ;   Note: This message makes multi-line tooltips possible
        SendMessage TTM_SETMAXTIPWIDTH,0,A_ScreenWidth,,ahk_id %hTT%
        }

    ;-- Other commands
    if p1 is not Integer
        {
        if (p1="Activate")
            SendMessage TTM_ACTIVATE,True,0,,ahk_id %hTT%

        if (p1="Deactivate")
            SendMessage TTM_ACTIVATE,False,0,,ahk_id %hTT%

        if (InStr(p1,"AutoPop")=1)  ;-- Starts with "AutoPop"
            SendMessage TTM_SETDELAYTIME,TTDT_AUTOPOP,p2*1000,,ahk_id %hTT%
        
        if (p1="Title")
            {
            ;-- If needed, truncate the title
            if (StrLen(p2)>99)
                p2:=SubStr(p2,1,99)

            ;-- Icon
            if p3 is not Integer
                p3:=TTI_NONE

            ;-- Set title
            SendMessage A_IsUnicode ? TTM_SETTITLEW:TTM_SETTITLEA,p3,&p2,,ahk_id %hTT%
            }

        ;-- Restore DetectHiddenWindows
        DetectHiddenWindows %l_DetectHiddenWindows%
    
        ;-- Return the handle to the tooltip control
        Return hTT
        }

    ;-- Create/Populate the TOOLINFO structure
    uFlags:=TTF_IDISHWND|TTF_SUBCLASS
    cbSize:=VarSetCapacity(TOOLINFO,(A_PtrSize=8) ? 64:44,0)
    NumPut(cbSize,      TOOLINFO,0,"UInt")              ;-- cbSize
    NumPut(uFlags,      TOOLINFO,4,"UInt")              ;-- uFlags
    NumPut(HWND_DESKTOP,TOOLINFO,8,"Ptr")               ;-- hwnd
    NumPut(p1,          TOOLINFO,(A_PtrSize=8) ? 16:12,"Ptr")
        ;-- uId

    ;-- Check to see if tool has already been registered for the control
    SendMessage
        ,A_IsUnicode ? TTM_GETTOOLINFOW:TTM_GETTOOLINFOA
        ,0
        ,&TOOLINFO
        ,,ahk_id %hTT%

    l_RegisteredTool:=ErrorLevel

    ;-- Update the TOOLTIP structure
    NumPut(&p2,TOOLINFO,(A_PtrSize=8) ? 48:36,"Ptr")
        ;-- lpszText

    ;-- Add, Update, or Delete tool
    if l_RegisteredTool
        {
        if StrLen(p2)
            SendMessage
                ,A_IsUnicode ? TTM_UPDATETIPTEXTW:TTM_UPDATETIPTEXTA
                ,0
                ,&TOOLINFO
                ,,ahk_id %hTT%
         else
            SendMessage
                ,A_IsUnicode ? TTM_DELTOOLW:TTM_DELTOOLA
                ,0
                ,&TOOLINFO
                ,,ahk_id %hTT%
        }
    else
        if StrLen(p2)
            SendMessage
                ,A_IsUnicode ? TTM_ADDTOOLW:TTM_ADDTOOLA
                ,0
                ,&TOOLINFO
                ,,ahk_id %hTT%

    ;-- Restore DetectHiddenWindows
    DetectHiddenWindows %l_DetectHiddenWindows%

    ;-- Return the handle to the tooltip control
    Return hTT
    }
;-------------------------------------------------------------------------------



;GetWindowInfo by "just me"
;Used to calculate window border sizes per window.
;From https://autohotkey.com/board/topic/69254-func-api-getwindowinfo-ahk-l/

; ================================================================================================================================
; Function:         API_GetWindowInfo() 
;                   Get an object containing the values of the WINDOWINFO structure from DllCall("GetWindowInfo")
; AHK version:      L 1.1.00.00 (U 32)
; Language:         English
; Tested on:        Win XPSP3, Win VistaSP2 (32 Bit)
; Version:          0.0.00.01/2011-07-17/just me
; Parameters:       HWND        - HWND of a window or control
; Return values:    On success  - Object containing structure's values (see Remarks)
;                   On failure  - False,
;                                 ErrorLevel = 1 -> Invalid HWND
;                                 ErrorLevel = 2 -> DllCall("GetWindowInfo") caused an error
; Remarks:          The returned object contains all keys defined in WINDOWINFO exept "Size".
;                   The keys "Window" and "Client" contain objects with keynames defined in [5].
;                   For more details see http://msdn.microsoft.com/en-us/library/ms633516%28VS.85%29.aspx and
;                   http://msdn.microsoft.com/en-us/library/ms632610%28VS.85%29.aspx
; ================================================================================================================================
API_GetWindowInfo(HWND) {
   ; [1] = Offset, [2] = Length, [3] = Occurrences, [4] = Type, [5] = Key array
   Static WINDOWINFO := { Size: [0, 4, 1, "UInt", ""]
                        , Window: [4, 4, 4, "Int", ["Left", "Top", "Right", "Bottom"]]
                        , Client: [20, 4, 4, "Int", ["Left", "Top", "Right", "Bottom"]]
                        , Styles: [36, 4, 1, "UInt", ""]
                        , ExStyles: [40, 4, 1, "UInt", ""]
                        , Status: [44, 4, 1, "UInt", ""]
                        , XBorders: [48, 4, 1, "UInt", ""]
                        , YBorders: [52, 4, 1, "UInt", ""]
                        , Type: [56, 2, 1, "UShort", ""]
                        , Version: [58, 2, 1, "UShort", ""] }
   Static WI_Size := 0
   If (WI_Size = 0) {
      For Key, Value In WINDOWINFO
         WI_Size += (Value[2] * Value[3])
   }
   If !DllCall("User32.dll\IsWindow", "Ptr", HWND) {
      ErrorLevel := 1
      Return False
   }
   struct_WI := ""
   NumPut(VarSetCapacity(struct_WI, WI_Size, 0), struct_WI, 0, "UInt")
   If !(DllCall("User32.dll\GetWindowInfo", "Ptr", HWND, "Ptr", &struct_WI)) {
      ErrorLevel := 2
      Return False
   }
   obj_WI := {}
   For Key, Value In WINDOWINFO {
      If (Key = "Size")
         Continue
      Offset := Value[1]
      If (Value[3] > 1) { ; more than one occurrence
         If IsObject(Value[5]) { ; use keys defined in Value[5] to store the values in
            obj_ := {}
            Loop, % Value[3] {
               obj_.Insert(Value[5][A_Index], NumGet(struct_WI, Offset, Value[4]))
               Offset += Value[2]
            }
            obj_WI[Key] := obj_
         } Else { ; use simple array to store the values in
            arr_ := []
            Loop, % Value[3] {
               arr_[A_Index] := NumGet(struct_WI, Offset, Value[4])
               Offset += Value[2]
            }
            obj_WI[Key] := arr_
         }
      } Else { ; just one item
         obj_WI[Key] := NumGet(struct_WI, Offset, Value[4])
      }
   }
   Return obj_WI
}
; ================================================================================================================================

;StackingPleasantNotify by Onurtag
;Used to create stacking notifications
;Original PleasantNotify function by Soft, and mod by evilC: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=6056#p35696

; ================================================================================================================================
;
; StackingPleasantNotify v1.0 by Onurtag
;
; Original PleasantNotify function by Soft, and mod by evilC: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=6056#p35696
;
; Modifications: 
; - Added auto height detection. Explanation is below. To enable; set the height parameter (5th parameter) to "auto" 
;      - For the message (second parameter): Detects if the text will take 1 or 2 lines.
;	   - For the Second text (third parameter): If this parameter is empty (set to ""), reduces height.
;      - If you modify the notification window (font size etc.) this functionality might break.
; - Added StackingPleasantNotify function and global pn_stackedNotifications object (enables notification stacking) 
; - Allow text color and style(wBold/wRegular) specification for the text color parameters. 
; - Added click to dismiss
; - Personal styling: faster fade in/out, brought back window corners, Added Second text line, modified fonts etc.
; - Removed obsolete methods (manual binding etc.)
;
; Usage examples: 
; new StackingPleasantNotify("StackingPleasantNotify", "Short text that only needs a single line." , "Second Text1" , 300, "auto", 2000, "0x292929", "0x836DFF", "0xb8b8ac", "0xDCDCCC wBold")
; new StackingPleasantNotify("StackingPleasantNotify2", "Long text that needs two lines. Long text that needs two lines. " , "Second Text2" , 300, "auto", 5000, "0x292929", "0x836DFF", "0xb8b8ac", "0xDCDCCC wBold")
; new StackingPleasantNotify("StackingPleasantNotify3", "Message without Second text.", "", 300, "auto", 3000, "0x292929", "0x836DFF", "0xb8b8ac", "0xDCDCCC wBold")
; new StackingPleasantNotify("StackingPleasantNotify4 not bold", "Message with static height. BOLD." , "Second Text3. This is NOT BOLD." , 300, 90, 7000, "0x292929", "0x836DFF wRegular", "0xb8b8ac wBold", "0xDCDCCC wRegular")
;
; ================================================================================================================================

Class StackingPleasantNotify {

    __New(title, message, messageSecond, pnW=700, pnH=300, time=10, bgColor="0xF2F2F0", titleColor="0x07D82F", textColor="Black", textStyleLight="0x505050") {
        Critical
        lastfound := WinExist()
        
        SysGet, Mon, MonitorWorkArea

        ;Create global stack object if it doesn't exist
        global pn_stackedNotifications
        if (!pn_stackedNotifications) {
            pn_stackedNotifications := Object()
            notifCount := 0
        } else {
            notifCount := pn_stackedNotifications.Count()
        }

        ;Automatic height and message line count detection
        if (pnH == "auto") {
            detectHeight := True
        } else {
            detectHeight := False
        }

        messagelineCount := 1
        messageLen := StrLen(message)
        ;6.50 pixels per character (average), +10 for various gui margins
        messagePixelWidth := (messageLen * 6.50) + 10
        ;If its smaller than width, detect message as single line.
        if (messagePixelWidth < pnW) {
            messagelineCount := 1
            if (detectHeight) {
                pnH := 68
            }
        } else {
            messagelineCount := 2
            if (detectHeight) {
                pnH := 90
                ;Dont increase the number of lines if the specified static height is less than 80 pixels
            } else if (pnH < 80) {
                messagelineCount := 1
            }
        }
        ;If the Second message is empty and the height is automatic, reduce window height.
        if ((messageSecond == "") && (detectHeight)) {
            pnH -= 20
        }

        offsetY := 0
        ;Set notification offset for stacking
        if (notifCount >= 1) {
            For Key, Value in pn_stackedNotifications {
                currlastY := Value.lastY
                if ((MonBottom - currlastY) > offsetY) {
                    offsetY := MonBottom - currlastY
                }
            }
            ;Plus 2 pixel space between notifications
            offsetY += 2
        }
        this.offsetY := offsetY

        this.destroyed := False
        this.notifTitle := title
        timerBoundFN := ObjBindMethod(this, "TimerExpired")
        okclickBoundFN := ObjBindMethod(this, "OKClicked")
        guiclickBoundFN := ObjBindMethod(this, "GUIClicked")
        this.realHeight := pnH + 20

        Gui, New, % "HwndPN_hwnd"
        this.PN_hwnd := PN_hwnd
        Gui, % PN_hwnd ": Default"
        Gui, % PN_hwnd ": +AlwaysOnTop +ToolWindow -SysMenu -Caption +LastFound"
        ;WinSet, ExStyle, +0x20
        WinSet, Transparent, 0
        Gui, % PN_hwnd ": Color", %bgColor%
        Gui, % PN_hwnd ": Font", wBold s14 c%titleColor%, Segoe UI
        Gui, % PN_hwnd ": Add", Text, % " x" 14 " y" 8 " w" pnW-10 " hwndTitleHwnd", % title
        ;This was used to modify the title
        ;this.TitleHwnd := TitleHwnd
        Gui, % PN_hwnd ": Font", wRegular s12 c%textColor%
        Gui, % PN_hwnd ": Add", Text, % " x" 14 " y" 34 " w" pnW-10 " h" pnH-10 " hwndMessageHwnd", % message
        ;This was used to modify the message
        ;this.MessageHwnd := MessageHwnd
        Gui, % PN_hwnd ": Font", wRegular s12 c%textStyleLight%
        Gui, % PN_hwnd ": Add", Text, % " x" 14 " y" 34 + (messagelineCount * 22) " w" pnW-10 " h" pnH-10, % messageSecond
        if (time = "P"){
            Gui, % PN_hwnd ": Add", Button, % " x" pnW - 80 " y" pnH - 50 " w50 h40 ", OK
            ; When OK is clicked, call this instance of the class
            GuiControl +g, OK, %okclickBoundFN%
        }

        RealW := pnW + 20
        RealH := pnH + 20

        ;Make it dismissable with a click (using an invisible text control)
        Gui, Add, Text, x0 y0 W%RealW% H%RealH% hwndGuiFullBG BackgroundTrans hwndInvisibleText, 
        GuiControl +g, %InvisibleText%, %guiclickBoundFN%

        Gui, % PN_hwnd ": Show", W%RealW% H%RealH% NoActivate, Stacked Pleasant Notification
        this.WinMove(PN_hwnd, "b r", offsetY)

        ;Add to pn_stackedNotifications object
        thisWinHwnd := this.PN_Hwnd
        if (!pn_stackedNotifications.hasKey(thisWinHwnd)) {
            pn_stackedNotifications[thisWinHwnd] := {hwnd:PN_hwnd, lastY:MonBottom-RealH-offsetY, count:notifCount}
        }

        ;Gui, % PN_Hwnd ": +Parent" A_ScriptHwnd
        ;Enable Window region (corner smoothing) below
        /* 
        if A_ScreenDPI = 96
            WinSet, Region,0-0 w%pnW% h%pnH% R40-40,%A_ScriptName% 
        */

        /* For Screen text size 125%
        if A_ScreenDPI = 120
            WinSet, Region, 0-0 w800 h230 R40-40, %A_ScriptName%
        */
        Critical Off
        this.winfade("ahk_id " PN_hwnd,240,60)
        if (time != "P")
        {
            SetTimer % timerBoundFN, % -time
        }

        if (WinExist(lastfound)){
            Gui, % lastfound ":Default"
        }
    }

    __Delete(){
        if (!this.destroyed)
            this.Destroy()
    }

    TimerExpired(){
        this.Destroy()
    }

    OKClicked(){
        this.Destroy()
    }

    GUIClicked(){
        this.Destroy(1)
    }

    Destroy(instantly=0){
        oldDelay := A_WinDelay
        SetWinDelay, 0
        global pn_stackedNotifications
        if (this.destroyed) {
            return
        }
        
        fadeSteps := 20
        if (instantly == 1) {
            fadeSteps := 255
        }
        this.destroyed := True

        thisWinHwnd := this.PN_Hwnd
        ;Get the window's position before destroying it
        WinGetPos, thisCurrX, thisCurrY,,, ahk_id %thisWinHwnd%
        this.winfade("ahk_id " thisWinHwnd,0,fadeSteps)
        Gui, % thisWinHwnd ": Destroy"

        ;Remove from stackedNotifications object
        if (pn_stackedNotifications.hasKey(thisWinHwnd)) {
            pn_stackedNotifications.Delete(thisWinHwnd)

        }
        ;If we have any other notifications, move them down.
        if (pn_stackedNotifications.Count() > 0) {
            ;Sort the notifications so we can move them in correct order.
            sortedNotifications := ObjectSort(pn_stackedNotifications, "lastY",,True)
            For Key, Value in sortedNotifications {
                ;valueCount := Value.count
                thisHwnd := Value.hwnd
                WinGetPos, stackCurrX, stackCurrY,,, ahk_id %thisHwnd%
                SysGet, MonVar, MonitorWorkArea
                ;Move notifications above this one down.
                if (thisCurrY > stackCurrY) {
                    ;2 is for the spaces between the notifications.
                    newY := stackCurrY + this.realHeight + 2
                    WinMove, ahk_id %thisHwnd%,, stackCurrX, newY
                    pn_stackedNotifications[thisHwnd].lastY := newY
                }
            }
        }
        SetWinDelay, %oldDelay%
    }

    WinMove(hwnd,position,offsetY=0) {
        SysGet, Mon, MonitorWorkArea
        WinGetPos,ix,iy,w,h, ahk_id %hwnd%
        x := InStr(position,"l") ? MonLeft : InStr(position,"hc") ? (MonRight-w)/2 : InStr(position,"r") ? MonRight - w : ix
        y := InStr(position,"t") ? MonTop : InStr(position,"vc") ? (MonBottom-h)/2 : InStr(position,"b") ? MonBottom - h : iy
        WinMove, ahk_id %hwnd%,,x,y-offsetY
    }

    winfade(w:="",t:=128,i:=1,d:=10) {
        w:=(w="")?("ahk_id " WinActive("A")):w
        t:=(t>255)?255:(t<0)?0:t
        WinGet,s,Transparent,%w%
        s:=(s="")?255:s ;prevent trans unset bug
        WinSet,Transparent,%s%,%w%
        i:=(s<t)?abs(i):-1*abs(i)
        while(k:=(i<0)?(s>t):(s<t)&&WinExist(w)) {
            WinGet,s,Transparent,%w%
            s+=i
            WinSet,Transparent,%s%,%w%
            sleep %d%
        }
    }

    /* 
    ;These do not work with the mod and are not necessary.
    pn_mod_title(title) {
        global pn_title
        GuiControl, Notify: Text,pn_title, % title
    }

    pn_mod_msg(message) {
        global pn_msg
        GuiControl, Notify: Text,pn_msg, % message
    }
    */
}

;ObjectSort() by bichlepa
;https://www.autohotkey.com/boards/viewtopic.php?t=49297
;Part of StackingPleasantNotify

/* ObjectSort() by bichlepa
* 
* Description:
*    Reads content of an object and returns a sorted array
* 
* Parameters:
*    obj:              Object which will be sorted
*    keyName:          [optional] 
*                      Omit it if you want to sort a array of strings, numbers etc.
*                      If you have an array of objects, specify here the key by which contents the object will be sorted.
*    callBackFunction: [optional] Use it if you want to have custom sort rules.
*                      The function will be called once for each value. It must return a number or string.
*    reverse:          [optional] Pass true if the result array should be reversed
*/
ObjectSort(obj, keyName="", callbackFunc="", reverse=false)
{
    temp := Object()
    sorted := Object() ;Return value

    for oneKey, oneValue in obj
    {
        ;Get the value by which it will be sorted
        if keyname
            value := oneValue[keyName]
        else
            value := oneValue

        ;If there is a callback function, call it. The value is the key of the temporary list.
        if (callbackFunc)
            tempKey := %callbackFunc%(value)
        else
            tempKey := value

        ;Insert the value in the temporary object.
        ;It may happen that some values are equal therefore we put the values in an array.
        if not isObject(temp[tempKey])
            temp[tempKey] := []
        temp[tempKey].push(oneValue)
    }

    ;Now loop throuth the temporary list. AutoHotkey sorts them for us.
    for oneTempKey, oneValueList in temp
    {
        for oneValueIndex, oneValue in oneValueList
        {
            ;And add the values to the result list
            if (reverse)
                sorted.insertAt(1,oneValue)
            else
                sorted.push(oneValue)
        }
    }

    return sorted
}