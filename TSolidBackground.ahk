#SingleInstance Force
#NoEnv
SendMode Input
;#Warn, All, StdOut

/*
TSolidBackground
AIO Autohotkey script that can make any window pseudo-fullscreen using padding over window borders and background. It can also move/resize windows and make them always on top.
https://github.com/Onurtag/TSolidBackground

To anyone reading the code,
This script contains many globals and hacks that are unoptimal which I can't really recommend.
They all work well and it would be a waste of time (also I don't care enough too) so they will stay like this until they break or bother me.

If you have any good suggestions, feel free to contact me or open an issue.

TD: Named presets for move/resize menu.
*/


OnExit, Exited
Arrs := Object()
Version := "v2.9.1"
IniVersion := "v1.0"
bgcolor := 250000
TSolidBackgroundKey := "!T"
OnTopKey := "!Y"
CenterKey := "!G"
TaskbarKey := "!F"
OptionsKey := "!U"
SuspendKey := "F8"
Iniexists := "No"
CustomWidthLeft := 0
CustomWidthRight := 0
CustomHeightTop := 0
CustomHeightBottom := 0
startupWindow := 1
protectVNR := 1
preventSend := 1
excludeSystemWindows := 1
Hooking := 0
TitleOne := "Main Window Title"
TitleTwo := "Hooked Window Title"
Vmove := 5
Vresize := 5
MoveBy := 1
Debug := 0
Checking := 0
CheckForUpdates := 0
excludedTitles := Object("TSolidBackground Advanced Features", ""    ;You can use the edit menu under advanced options to add more titles or remove these.
                        ,"TSolidBackground Splash Text", ""
                        ,"TSolidBackground Move/Resize Window", ""
                        ,"Windows Shell Experience Host", ""
                        ,"Program Manager", "")

SetWinDelay, 0
SetControlDelay, 0      ;Mostly useless.
SetBatchLines, 2000

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

IfExist, TSolidBackground.ini
{
    Iniexists := "Yes"
    Readini(WrittenIniVersion, "Settings", "Ini Version")
    if ((WrittenIniVersion == "ERROR") || (WrittenIniVersion != IniVersion)) {
        if (WrittenIniVersion == "ERROR") {
            DrawHUD("Your TSolidBackground.ini is likely corrupt.`nIt was automatically renamed and replaced with a new one.", "y160", "cE60000", "s11", "10000")
        } else if (WrittenIniVersion != IniVersion) {
            DrawHUD("Your TSolidBackground.ini needs to be updated.`nIt was automatically renamed and replaced with a new one.", "y160", "cE60000", "s11", "10000")
        }
        FileMove, TSolidBackground.ini, TSolidBackground_OLD_%A_DD%-%A_MM%-%A_YYYY%.ini
        CreateSaveini(0)
    }
    Readini(TSolidBackgroundKey, "Hotkeys", "TSolidBackground Key")
    Readini(OnTopKey, "Hotkeys", "On Top Key")
    Readini(CenterKey, "Hotkeys", "Center Window Key")
    Readini(TaskbarKey, "Hotkeys", "Show Hide Taskbar Key")
    Readini(OptionsKey, "Hotkeys", "Advanced Features Key")
    Readini(SuspendKey, "Hotkeys", "Suspend Hotkeys Key")
    Readini(bgcolor, "Settings", "Background Color")
    Readini(CustomWidthLeft, "Settings", "Custom Width Left")
    Readini(CustomWidthRight, "Settings", "Custom Width Right")
    Readini(CustomHeightTop, "Settings", "Custom Height Top")
    Readini(CustomHeightBottom, "Settings", "Custom Height Bottom")
    Readini(startupWindow, "Settings", "Enable Startup Window")
    Readini(excludeSystemWindows, "Settings", "Exclude system windows from dropdown")
    Readini(CheckForUpdates, "Settings", "Check for Updates on Startup")
    Readini(TitleOne, "Settings", "Hooker Main Window")
    Readini(TitleTwo, "Settings", "Hooker Hooked Window")
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
    if (SuspendKey != "F8") {
        if (SuspendKey != "") {
            Hotkey, %SuspendKey%, F8
        }
        Hotkey, F8, Off
    }
}

if (startupWindow) {
    Gui, start: Color, 292929
    Gui, start: Font, s14 c836DFF Bold, Segoe UI
    Gui, start: Add, Text,, TSolidBackground %Version%
    Gui, start: Font, s8 c836DFF Bold
    Gui, start: Font, s10 cDCDCCC norm
    Gui, start: Add, Text, x18 y42, Current Hotkeys and Options: `n------------------------`nTSolidBackground: %TSolidBackgroundKey% `nAlways On Top: %OnTopKey% `nShow Hide Taskbar: %TaskbarKey% `nCenter Window: %CenterKey% `nAdvanced Features: %OptionsKey% `nSuspend other hotkeys: %SuspendKey%`nTSolidBackground.ini file exists: %Iniexists%`n------------------------ `nOn AutoHotkey [!] means [Alt]. `nIf no hotkeys work on selected window, run TSolidBackground as admin.`n`nIf you need to change the hotkeys, want to check for updates `nor just can't understand anything above visit the project page:
    Gui, start: Font, s10 c3257BF underline
    Gui, start: Add, Text, x18 y303 gGotoSite, https://github.com/Onurtag/TSolidBackground
    Gui, start: Font, s10 cBlack norm Bold
    Gui, start: Add, Button, x243 y338 w64 h36, Ok
    Gui, start: Show, w550 h393, TSolidBackground Startup
}

if (CheckForUpdates) {
    CheckUpdate(0)
}
Return

!Y::
    WinGet, currentWindow, ID, A
    WinGetTitle, currentTitle, A
    if (currentTitle == "Kagami") {
        if (protectVNR) {
            TrayTip, Window [%currentTitle%] is protected., Check advanced options to disable it.
            Return
        }
    }
    WinStack(currentWindow)
    WinGet, WindowExStyle, ExStyle, ahk_id %currentWindow%
    if (WindowExStyle & 0x8) { 
        WinSet, AlwaysOnTop, off, ahk_id %currentWindow%
        TrayTip, Window [%currentTitle%], Always on top status: OFF
    } else {
        WinSet, AlwaysOnTop, on, ahk_id %currentWindow%
        TrayTip, Window [%currentTitle%], Always on top status: ON
    }
Return

!T::
    if (Activewin == "") {
        Activewin := WinExist("A")
    }
    Toggle := !Toggle
    if (Toggle == "1") {
        if (WinExist("A") != Activewin) {
            DrawHUD("Got a new window for TSolidBackground.", "", "c836DFF", "s11", "1350")
            Activewin := WinExist("A")
        }
        TSolidBackground()
    } else {
        DestroyTSolidBackground()
    }
Return

!G::
    WinGetPos,,, WWWidth, HHHeight, A
    GetMonitorIndexFromWindow(WinExist("A"))
    mHeight := monitorBottom-monitorTop
    mWidth := monitorRight-monitorLeft
    WinMove, A,, (mWidth-WWWidth)/2+monitorLeft, (mHeight-HHHeight)/2+monitorTop-12        ;-12 For new Win10 borders and stuff.
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
            DrawHUD("Got a new window to move/resize.", "y160", "c836DFF", "s11", "1350")
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
}

~F8::
    Suspend
    if (A_IsSuspended) {
        Traytip, TSolidBackground, Suspended all other hotkeys. `nTo enable hotkeys press %SuspendKey%.
        Menu, Tray, Tip, TSolidBackground Suspended
    } else {
        Traytip, TSolidBackground, Enabled all hotkeys.
        Menu, Tray, Tip, TSolidBackground
    }
Return

Advanced:
    ShowNewMenu("","")
Return

;Debug Vars
~F10::
    if (Debug) {
        ListVars
    }
Return

Abouted:
    Gui, about: +AlwaysOnTop
    Gui, about: Destroy
    Gui, about: Color, 292929
    Gui, about: Font, s14 c836DFF, Segoe UI
    Gui, about: Add, Text,, TSolidBackground %Version%
    Gui, about: Font, s10 cDCDCCC
    Gui, about: Add, Text,, For readme, updates and more `ncheck out the project page:
    Gui, about: Font, s10 c3257BF underline
    Gui, about: Add, Text, x18 y100 gGotoSite, https://onurtag.github.io/TSolidBackground/
    Gui, about: Font, s10 cBlack norm Bold
    Gui, about: Add, Button, x118 y136 w64 h36, Ok
    Gui, about: Show, w300 h192, About TSolidBackground
Return

TSolidBackground() {
    Global
    WinGetPos, wX, wY, WWidth, HHeight, ahk_id %Activewin%
    GetMonitorIndexFromWindow(Activewin)
    mHeight := monitorBottom-monitorTop
    mWidth := monitorRight-monitorLeft
    SysGet, Border_Size, 32
    SysGet, Border_Size2, 33
    SysGet, Caption_Size, 4
    bg1FY := wY
    bg2FX := wX
    bg3SY := wY+HHeight
    bg4SX := wX+WWidth

    bg1FY += Border_Size2+Caption_Size
    bg2FX += Border_Size
    bg3SY -= Border_Size2
    bg4SX -= Border_Size
    
    WinGet, WinExStyle, ExStyle, ahk_id %Activewin%
    WinGet, WinStyle, Style, ahk_id %Activewin%
    if (WinExStyle & 0x8) { 
        WinGetTitle, currTitle, ahk_id %Activewin%
        if (currTitle != "Kagami") {    ;VNR fix
            WinSet, AlwaysOnTop, off, ahk_id %Activewin%
            TrayTip, Window [%currTitle%], Always on top status: OFF
        }
    }

    if ((WinStyle & 0x40000) == 0) {        ;Unresizable windows have smaller borders
        bg1FY -= 5
        bg2FX -= 5
        bg3SY += 5
        bg4SX += 5
    }

    bg1FY -= %CustomHeightTop%
    bg2FX -= %CustomWidthLeft%
    bg3SY += %CustomHeightBottom%
    bg4SX += %CustomWidthRight%

    bg2FX -= monitorLeft
    bg1FY -= monitorTop
    bg3H := monitorBottom-bg3SY
    bg4W := monitorRight-bg4SX
    
    Gui, +Disabled -Caption +ToolWindow
    Gui, bg1: +AlwaysOnTop -Caption +ToolWindow
    Gui, bg1: Color, %bgcolor%
    Gui, bg2: +AlwaysOnTop -Caption +ToolWindow
    Gui, bg2: Color, %bgcolor%
    Gui, bg3: +AlwaysOnTop -Caption +ToolWindow
    Gui, bg3: Color, %bgcolor%
    Gui, bg4: +AlwaysOnTop -Caption +ToolWindow
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
    Gui, cheat: +ToolWindow +AlwaysOnTop
    Gui, cheat: Color, 292929
    Gui, cheat: Show, w640 h560 x%aX% y%aY%, TSolidBackground
    Gui, Destroy
    ShowNewMenu(aX,aY)
    SetTimer, KillCheat, 250
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
    Gui, options: Add, Checkbox, x152 y302 Checked%excludeSystemWindows% vexcludeSystemWindows gSetnow, Exclude specific windows from Move/Resize dropdown menu.
    Gui, options: Add, Checkbox, x152 y324 Checked%startupWindow% vstartupWindow gSetnow, Show info window on startup
    Gui, options: Add, Checkbox, x152 y346 Checked%CheckForUpdates% vCheckForUpdates gSetnow, Check for updates on startup (Save to ini required)
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
    IfNotExist, TSolidBackground.ini 
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
    IfNotExist, TSolidBackground.ini 
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
        DrawHUD("Requested save or .ini file doesn't exist.", "y160", "cE60000", "s11", "5000")
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
    IfExist, TSolidBackground.ini
    {
        Run, %A_ScriptDir%\TSolidBackground.ini,,UseErrorLevel
        if ErrorLevel == ERROR
        {
            Run, notepad %A_ScriptDir%\TSolidBackground.ini,,UseErrorLevel
        }
    } else {
        DrawHUD("You must first create an ini in the advanced features menu before editing it.", "y160", "cE60000", "s11", "5000")
    }
Return

RunCheckUpdate:
    if (Checking == 0) {
        CheckUpdate(1)
    }
Return

CheckUpdate(notify) {
    Global
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
    DrawHUD("TSolidBackground will now update and restart.`nJust hold on a second...", "", "c27A100", "s13", "120000")
    UrlDownloadToFile, https://github.com/Onurtag/TSolidBackground/releases/download/%NewVersion%/TSolidBackground.exe, TSolidBackground_NEWVER.exe
    FileDelete, TSolidBackgroundUpdater.bat
    FileAppend, del TSolidBackground.exe`n, TSolidBackgroundUpdater.bat
    FileAppend, ren TSolidBackground_NEWVER.exe TSolidBackground.exe`n, TSolidBackgroundUpdater.bat
    FileAppend, start TSolidBackground.exe`n, TSolidBackgroundUpdater.bat
    FileAppend, del TSolidBackgroundUpdater.bat`n, TSolidBackgroundUpdater.bat
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
    SysGet, Border_Size, 32
    SysGet, Border_Size2, 33
    SysGet, Caption_Size, 4
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
    HclientDif := 2*Border_Size2 + Caption_Size
    WclientDif := 2*Border_Size
    WinGet, ResizedStyle, Style, ahk_id %TBResized%
    if ((ResizedStyle & 0x40000) == 0) {        ;Unresizable windows have smaller borders
        HclientDif := HclientDif - 10
        WclientDif := WclientDif - 10
    }
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
    Gui, resizer: Add, Text, x500 y355, Tip: You can use `nyour advanced `nfeatures (%OptionsKey%) `nhotkey to select `na new window.
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
        Gui, resizer: Add, Text, x90 y363, Temp/Perm Save:
        Gui, resizer: Add, Text, x90 y391, Load Saved Pos:
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
        Gui, resizer: Add, Text, x218 y338, Quick save/load size and position
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
        Gui, resizer: Add, Button, x203 y362 w27 h21 hwndhSavetemp1 gSavetemp1, T1
        AddTooltip(hSavetemp1, "Temprorary values are lost when you quit TSolidBackground.")
        Gui, resizer: Add, Button, x203 y390 w27 h21 gLoadtemp1, T1
        Gui, resizer: Add, Button, x235 y362 w27 h21 hwndhSavetemp2 gSavetemp2, T2
        AddTooltip(hSavetemp2, "Temprorary values are lost when you quit TSolidBackground.")
        Gui, resizer: Add, Button, x235 y390 w27 h21 gLoadtemp2, T2
        Gui, resizer: Add, Button, x270 y362 w27 h21 hwndhSave1 gSave1, P1
        AddTooltip(hSave1, "Permanently saves the window size/position to .ini")
        Gui, resizer: Add, Button, x270 y390 w27 h21 gLoad1, P1
        Gui, resizer: Add, Button, x302 y362 w27 h21 hwndhSave2 gSave2, P2
        AddTooltip(hSave2, "Permanently saves the window size/position to .ini")
        Gui, resizer: Add, Button, x302 y390 w27 h21 gLoad2, P2
        Gui, resizer: Add, Button, x334 y362 w27 h21 hwndhSave3 gSave3, P3
        AddTooltip(hSave3, "Permanently saves the window size/position to .ini")
        Gui, resizer: Add, Button, x334 y390 w27 h21 gLoad3, P3
        Gui, resizer: Add, Button, x366 y362 w27 h21 hwndhSave4 gSave4, P4
        AddTooltip(hSave4, "Permanently saves the window size/position to .ini")
        Gui, resizer: Add, Button, x366 y390 w27 h21 gLoad4, P4
        Gui, resizer: Add, Button, x398 y362 w27 h21 hwndhSave5 gSave5, P5
        AddTooltip(hSave5, "Permanently saves the window size/position to .ini")
        Gui, resizer: Add, Button, x398 y390 w27 h21 gLoad5, P5
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
            if (excludeSystemWindows) {
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
            if ((excludeSystemWindows) && (excludedTitles.HasKey(LoopTitle))) {        ;.HasKey(): Best alternative to .indexOf etc. 
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
            DrawHUD("Got a new window to move/resize.", "y160", "c836DFF", "s11", "1350")
            TBResized := WinIDAll[VarIndex]
            WinGetPos, Xorig, Yorig, Worig, Horig, ahk_id %TBResized%
        }
        ShowResizer()
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
        DrawHUD("Saved position or .ini file doesn't exist.", "y160", "cE60000", "s11", "5000")
    } else {
        WinMove, ahk_id %TBResized%,, %PermX%, %PermY%, %PermW%, %PermH%
    }
    Return
}

Savepos(posnr) {
    Global
    IfNotExist, TSolidBackground.ini 
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

ReloadDropDown:
    ShowResizer()
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
    Gui, hook: Add, Text, x60 y47 , Window Hooker currently only works for minimizing/switching tabs on browsers.`nFor now it can't make them move together. The .ini file will save the window titles too.
    Gui, hook: Font, s10
    Gui, hook: Add, Text, x500 y355, Tip: You can `nalso stop the `nwindow hooker `nusing the `ntray menu.
    Gui, hook: Font, s10 cBlack norm
    Gui, hook: Add, Edit, x234 y111 w170 h20 vTitleOne, %TitleOne%
    Gui, hook: Add, Edit, x234 y151 w170 h20 vTitleTwo, %TitleTwo%
    Gui, hook: Add, Button, x421 y109 h23 gGetactiveOne, Get last active window
    Gui, hook: Add, Button, x421 y149 h23 gGetactiveTwo, Get last active window
    if (Hooking == 0) {
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
    WinGet, TwoisNotMin, MinMax, %TitleTwo%
    WinGet, TwoWindowExStyle, ExStyle, %TitleTwo%
    ;CurrActiveID := WinExist("A")
    ;WinGetTitle, CurrActiveTitle, ahk_id %CurrActiveID%
    WinGetTitle, CurrActiveTitle, A
    if (CurrActiveTitle == TitleOne) {
        if (TwoisNotMin == -1) {
            WinRestore, %TitleTwo%
        }
        if (TwoWindowExStyle & 0x8) {

        } else {
            WinSet, AlwaysOnTop, on, %TitleTwo%
        }
    } else {
        if ((TwoWindowExStyle & 0x8) && (CurrActiveTitle != TitleTwo)) {
            if (protectVNR && (CurrActiveTitle != "Kagami")) {
                WinSet, AlwaysOnTop, off, %TitleTwo%
                WinMinimize, %TitleTwo%
            }
        }
        IfWinNotExist, %TitleOne%
        {
            if (TwoisNotMin != -1) {
                WinMinimize, %TitleTwo%
            }
        }
    }
    if (Hooking) {
        SetTimer, Hooker, 150
    } else {
        if (TwoWindowExStyle & 0x8) {
            WinSet, AlwaysOnTop, off, %TitleTwo%
        }
    }
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
    IfExist, TSolidBackground.ini
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
    SysGet, Border_Size, 32
    SysGet, Border_Size2, 33
    SysGet, Caption_Size, 4
    DummyH := DummyH - 2*Border_Size2 - Caption_Size
    DummyW := DummyW - 2*Border_Size
    IfNotExist, TSolidBackground.ini 
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
    Gui, mmover: Add, Edit, x305 y292 w50 h20 Number vMoveBy, %MoveBy%
    Gui, mmover: Add, UpDown, 0x80 Range1-90000, %MoveBy%
    Gui, mmover: Font, s9 cBlack norm
    Gui, mmover: Add, Button, x355 y293 w34 h18 gSetnow, Set
    Gui, mmover: Font, s10 Bold
    Gui, mmover: Add, Button, x174 y515 w290 h24, Close
    Gui, mmover: Add, Button, x10 y10 w44 h24 gmmoverGuiEscape, Back
    Gui, mmover: Font, s10 cDCDCCC norm
    Gui, mmover: Add, Checkbox, x210 y322 Checked%preventSend% vpreventSend gSetnow, Also prevent hotkeys from working
    Gui, mmover: Add, Text, x245 y291, Move by:
    Gui, mmover: Font, s13
    Gui, mmover: Add, Text, x220 y147, When this window is open,
    Gui, mmover: Add, Text, x140 y177, Use arrow keys to move the mouse pixel by pixel.
    Gui, mmover: Add, Text, x132 y207, Press [Numpad 1] or [Numpad End] for left click `nPress [Numpad 2] or [Numpad Down] for right click `nPress [Numpad 3] or [Numpad PgDn] for middle click.
    Gui, mmover: Font, s10 c836DFF norm Underline
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

#If mouseMoving
Left::
    MouseMove, -%MoveBy%, 0,, R
    if (!preventSend)
        Send, {Left} 
Return

Right::
    MouseMove, %MoveBy%, 0,, R
    if (!preventSend)
        Send, {Right}
Return

Up::
    MouseMove, 0, -%MoveBy%,, R
    if (!preventSend)
        Send, {Up}
Return

Down::
    MouseMove, 0, %MoveBy%,, R
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
    if ((Iniexists == "No") && (CheckForUpdates == 0)) {
        MsgBox, 4100, TSolidBackground, Would you like to automatically check for updates on startup?
        IfMsgBox, Yes
            CheckForUpdates := 1
    }
    IfNotExist, TSolidBackground.ini            ;Keep the ini in order.
    {
        FileAppend, [Help]`n, TSolidBackground.ini
        FileAppend, [Hotkeys]`n, TSolidBackground.ini
        FileAppend, [Settings]`n, TSolidBackground.ini
        FileAppend, [Custom TSB Sizes 1]`n, TSolidBackground.ini
        FileAppend, [Custom TSB Sizes 2]`n, TSolidBackground.ini
        FileAppend, [Custom TSB Sizes 3]`n, TSolidBackground.ini
        FileAppend, [Saved Position 1]`n, TSolidBackground.ini
        FileAppend, [Saved Position 2]`n, TSolidBackground.ini
        FileAppend, [Saved Position 3]`n, TSolidBackground.ini
        FileAppend, [Saved Position 4]`n, TSolidBackground.ini
        FileAppend, [Saved Position 5]`n, TSolidBackground.ini
        FileAppend, [Dummy Window], TSolidBackground.ini
    }
    Writeini(" https://github.com/Onurtag/TSolidBackground/#tsolidbackground", "Help", "#For help, check out the readme")
    Writeini(TSolidBackgroundKey, "Hotkeys", "TSolidBackground Key")
    Writeini(OnTopKey, "Hotkeys", "On Top Key")
    Writeini(CenterKey, "Hotkeys", "Center Window Key")
    Writeini(TaskbarKey, "Hotkeys", "Show Hide Taskbar Key")
    Writeini(OptionsKey, "Hotkeys", "Advanced Features Key")
    Writeini(SuspendKey, "Hotkeys", "Suspend Hotkeys Key")
    Writeini(IniVersion, "Settings", "Ini Version")
    Writeini(bgcolor, "Settings", "Background Color")
    Writeini(CustomWidthLeft, "Settings", "Custom Width Left")
    Writeini(CustomWidthRight, "Settings", "Custom Width Right")
    Writeini(CustomHeightTop, "Settings", "Custom Height Top")
    Writeini(CustomHeightBottom, "Settings", "Custom Height Bottom")
    Writeini(startupWindow, "Settings", "Enable Startup Window")
    Writeini(excludeSystemWindows, "Settings", "Exclude system windows from dropdown")
    Writeini(CheckForUpdates, "Settings", "Check for Updates on Startup")
    Writeini(TitleOne, "Settings", "Hooker Main Window")
    Writeini(TitleTwo, "Settings", "Hooker Hooked Window")
    Writeini(Debug, "Settings", "Debug")
    if (showit) {
        DrawHUD("TSolidBackground.ini file was created/saved.", "y160", "c836DFF", "s11", "1350")
    }
    Return
}

Writeini(value, section, key) {
    IniWrite, %value%, TSolidBackground.ini, %section%, %key%
}

Readini(ByRef outvalue, section, key) {
    IniRead, outvalue, TSolidBackground.ini, %section%, %key%
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
    for currentWindow, b in Arrs
    {
        WinSet, AlwaysOnTop, off, ahk_id %currentWindow%
    }
    WinShow, ahk_class Shell_TrayWnd
    WinShow, Start ahk_class Button
ExitApp




;---Pre-made functions & libraries---

;GetMonitorIndexFromWindow() by Shinywong.
;From https://autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355
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

;AddTooltip by Various authors
;From https://autohotkey.com/boards/viewtopic.php?&t=30079

;------------------------------
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
