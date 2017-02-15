#SingleInstance Force
#NoEnv

/*
TSolidBackground
https://github.com/Onurtag/TSolidBackground

To anyone reading the code,
This script contains many unrecommended globals and hacks.
It would be a waste of time and I don't care enough to fix them all so they will stay like this until they bother me.

If you have any good suggestions, feel free to contact me or open an issue.
*/

;TD: ADD MORE [DANGEROUS] EXCEPTIONS or something?

Arrs := Object()
OnExit, Exited
Version := "v2.8.2"
IniVersion := "v1.0"
bgcolor := 051523
TSolidBackgroundKey := "+T"
OnTopKey := "+Y"
CenterKey := "+G"
TaskbarKey := "+F"
OptionsKey := "+U"
SuspendKey := "F8"
Iniexists := "No"
CustomWidthLeft := 0
CustomWidthRight := 0
CustomHeightTop := 0
CustomHeightBottom := 0
StartupWindow := 1
protectVNR := 1
Hooking := 0
TitleOne := "Main Window Title"
TitleTwo := "Hooked Window Title"
Vmove := 5
Vresize := 5
MoveBy := 1
Debug := 0
Checking := 0
CheckForUpdates := 0

;-----EXPERIMENTAL-----
SetWinDelay, 0
SetControlDelay, 0      ;Probably useless.
SetBatchLines, 2000

Menu, Tray, Icon,,, 0
Menu, Tray, NoStandard
Menu, Tray, Add, About TSolidBackground, Abouted
Menu, Tray, Add, Advanced Features, Advanced
Menu, Tray, Add, Make a Dummy Window, StartDummyWindow
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
    Readini(StartupWindow, "Settings", "Enable Startup Window ")
    Readini(CheckForUpdates, "Settings", "Check for Updates on Startup")
    Readini(Debug, "Settings", "Debug")
    Readini(TitleOne, "Settings", "Hooker Main Window")
    Readini(TitleTwo, "Settings", "Hooker Hooked Window")
    if (TSolidBackgroundKey != "+T") {
        if (TSolidBackgroundKey != "") {
            Hotkey, %TSolidBackgroundKey%, +T
        }
        Hotkey, +T, Off
    }
    if (OnTopKey != "+Y") {
        if (OnTopKey != "") {
            Hotkey, %OnTopKey%, +Y
        }
        Hotkey, +Y, Off
    }
    if (CenterKey != "+G") {
        if (CenterKey != "") {
            Hotkey, %CenterKey%, +G
        }
        Hotkey, +G, Off
    }
    if (TaskbarKey != "+F") {
        if (TaskbarKey != "") {
            Hotkey, %TaskbarKey%, +F
        }
        Hotkey, +F, Off
    }
    if (OptionsKey != "+U") {
        if (OptionsKey != "") {
            Hotkey, %OptionsKey%, +U
        }
        Hotkey, +U, Off
    }
    if (SuspendKey != "F8") {
        if (SuspendKey != "") {
            Hotkey, %SuspendKey%, F8
        }
        Hotkey, F8, Off
    }
}

if (StartupWindow) {
    Gui, start: Color, 292929
    Gui, start: Font, s14 c836DFF Bold, Segoe UI
    Gui, start: Add, Text,, TSolidBackground %Version%
    Gui, start: Font, s8 c836DFF Bold
    Gui, start: Font, s10 cDCDCCC norm
    Gui, start: Add, Text, x18 y42, Current Hotkeys and Options: `n------------------------`nTSolidBackground: %TSolidBackgroundKey% `nAlways On Top: %OnTopKey% `nShow Hide Taskbar: %TaskbarKey% `nCenter Window: %CenterKey% `nAdvanced Features: %OptionsKey% `nSuspend other hotkeys: %SuspendKey%`nTSolidBackground.ini file exists: %Iniexists%`n------------------------ `nOn AutoHotkey [+] means [Shift]. `nIf no hotkeys work on selected window, run TSolidBackground as admin.`n`nIf you need to change the hotkeys, want to check for updates `nor just can't understand anything above visit the project page:
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

+Y::
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

+T::
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

+G::
    WinGetPos,,, WWWidth, HHHeight, A
    GetMonitorIndexFromWindow(WinExist("A"))
    mHeight := monitorBottom-monitorTop
    mWidth := monitorRight-monitorLeft
    WinMove, A,, (mWidth-WWWidth)/2+monitorLeft, (mHeight-HHHeight)/2+monitorTop-12        ;-12 For new Win10 borders and stuff.
Return

+F::
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

+U::
    if (WinExist("A") != TBResized) {
        DrawHUD("Got a new window to move/resize.", "y160", "c836DFF", "s11", "1350")
        TBResized := WinExist("A")
        WinGetPos, Xorig, Yorig, Worig, Horig, ahk_id %TBResized%
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
    if (nmX == "") {
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
        WinGetTitle, currentTitle, ahk_id %Activewin%
        if (currentTitle != "Kagami") {    ;VNR fix
            WinSet, AlwaysOnTop, off, ahk_id %Activewin%
            TrayTip, Window [%currentTitle%], Always on top status: OFF
        }
    }

    if ((WinStyle & 0x40000) == 0) {        ;Unresizable windows have smaller borders?
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

GetMonitorIndexFromWindow(windowHandle) {           ;Pre-made function by Shinywong. Many thanks.
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

DrawHUD(hudtext, xyvalue, hudtextcolor := "c836DFF", hudtextsize := "s11", hudtimer := 1350) {
    Gui, hud: Destroy
    Gui, hud: +AlwaysOnTop -Caption +ToolWindow +Border
    Gui, hud: Color, 292929
    Gui, hud: Font, %hudtextsize% %hudtextcolor% Bold, Segoe UI
    Gui, hud: Add, Text,, %hudtext%
    Gui, hud: Show, NoActivate %xyvalue%
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
    Gui, options: Add, Text, x202 y75, Custom Width Left:
    Gui, options: Add, Text, x202 y96, Custom Width Right:
    Gui, options: Add, Text, x202 y117, Custom Height Top:
    Gui, options: Add, Text, x202 y138, Custom Height Bottom:
    Gui, options: Add, Text, x202 y205, TSolidBackground Color:
    Gui, options: Add, Text, x486 y80, Permanent `nSave/Load
    Gui, options: Font, s10 c836DFF Bold
    Gui, options: Add, Button, x174 y515 w290 h24, Close
    Gui, options: Add, Button, x10 y10 w44 h24 gBackGui, Back
    Gui, options: Add, Edit, x360 y73 w70 h20 Number vCustomWidthLeft, %CustomWidthLeft%
    Gui, options: Add, Edit, x360 y94 w70 h20 Number vCustomWidthRight, %CustomWidthRight%
    Gui, options: Add, Edit, x360 y115 w70 h20 Number vCustomHeightTop, %CustomHeightTop%
    Gui, options: Add, Edit, x360 y136 w70 h20 Number vCustomHeightBottom, %CustomHeightBottom%
    Gui, options: Add, Edit, x360 y203  w70 h20 vbgcolor, %bgcolor%
    Gui, options: Add, Progress, x360 y225 w70 h20 c%bgcolor% Background%bgcolor% vbarcolored, 100
    Gui, options: Font, norm Underline
    Gui, options: Add, Text, x219 y435, Create .ini for permanent options
    Gui, options: Font, s9 cDCDCCC norm
    Gui, options: Add, Button, x434 y75 w16 h16 gResetcwh, R
    Gui, options: Add, Button, x480 y120 w21 h16 gSaveCustom1, S1
    Gui, options: Add, Button, x508 y120 w21 h16 gSaveCustom2, S2
    Gui, options: Add, Button, x536 y120 w21 h16 gSaveCustom3, S3
    Gui, options: Add, Button, x480 y141 w21 h16 gLoadCustom1, L1
    Gui, options: Add, Button, x508 y141 w21 h16 gLoadCustom2, L2
    Gui, options: Add, Button, x536 y141 w21 h16 gLoadCustom3, L3
    Gui, options: Add, Button, x434 y205 w16 h16 gResetcolor, R
    Gui, options: Add, Button, x361 y161 w68 h18 gSetnow, Set CWH
    Gui, options: Add, Button, x361 y249 w68 h18 gSetcolor, Set Color
    Gui, options: Font, s10 cDCDCCC norm
    Gui, options: Add, Button, x254 y460 w130 h28 gRunCreateSaveini, Create/Save .ini
    Gui, options: Add, Checkbox, x202 y280 Checked%protectVNR% vprotectVNR gSetnow, Protect VNR ("Kagami" titled window)
    Gui, options: Add, Checkbox, x202 y302 Checked%StartupWindow% vStartupWindow gSetnow, Show info window on startup
    Gui, options: Add, Checkbox, x202 y324 Checked%CheckForUpdates% vCheckForUpdates gSetnow, Check for updates on startup (Save to ini required)
    WinGetPos, optX, optY, optW, optH, TSolidBackground Advanced Features
    if (optX == "") {
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
        Gui, update: Font, s14 c27A100
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
        Gui, update: Font, s14 cDCDCCC
        Gui, update: Add, Text,, `nYour TSolidBackground is up to date.
        Gui, update: Font, s14 c836DFF, Segoe UI
        Gui, update: Add, Text,, Latest version: %NewVersion%  (Current version: %Version%)
        Gui, update: Font, s10 cDCDCCC
        Gui, update: Add, Text,, Click the link below if you want to download it again.
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
    Hclient := Hofwin - 2*Border_Size2 - Caption_Size
    Wclient := Wofwin - 2*Border_Size
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
    Gui, resizer: Add, DropDownList, x70 y53 w450 Choose%DropDownCurrent% vDropDownCurrent gDropDownSelected AltSubmit, Select a Window`n%DropDownAll%
    Gui, resizer: Add, Button, x527 y55 w54 h21 gReloadDropDown, Reload
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
        Wofwin := 00000            ;Fix for some tiny gui bug(?).
        Hofwin := 00000
        Xofwin := 00000
        Yofwin := 00000
        Gui, resizer: Add, Text, x150 y125 vCurrentWH, W: %Wofwin%, H: %Hofwin%
        Gui, resizer: Add, Text, x426 y125 vCurrentXY, X: %Xofwin%, Y: %Yofwin%
        Gui, resizer: Font, s10 c836DFF norm
        Gui, resizer: Add, Text, x150 y165, W: %Wclient%, H: %Hclient%
        Gui, resizer: Add, Text, x150 y145, W: %Worig%, H: %Horig%
        Gui, resizer: Add, Text, x426 y145, X: %Xorig%, Y: %Yorig%
        Gui, resizer: Add, Button, x254 y460 w130 h28 gRunCreateSaveini, Create/Save .ini
        Gui, resizer: Font, s10 c836DFF Bold
        Gui, resizer: Add, Edit, x158 y278 w64 h20 Number vWnew, %Wnew%
        Gui, resizer: Add, UpDown, 0x80 Range-90000-90000, %Wnew%
        Gui, resizer: Add, Edit, x158 y301 w64 h20 Number vHnew, %Hnew%
        Gui, resizer: Add, UpDown, 0x80 Range-90000-90000, %Hnew%
        Gui, resizer: Add, Edit, x424 y278 w64 h20 Number vXnew, %Xnew%
        Gui, resizer: Add, UpDown, 0x80 Range-90000-90000, %Xnew%
        Gui, resizer: Add, Edit, x424 y301 w64 h20 Number vYnew, %Ynew%
        Gui, resizer: Add, UpDown, 0x80 Range-90000-90000, %Ynew%
        Gui, resizer: Font, norm Underline
        Gui, resizer: Add, Text, x218 y338, Quick save/load size and position
        Gui, resizer: Add, Text, x219 y435, Create .ini for permanent options
        Gui, resizer: Font, s9 c836DFF norm Bold
        Gui, resizer: Add, Edit, x517 y249 w40 h20 Number vVmove, %Vmove%
        Gui, resizer: Add, UpDown, 0x80 Range1-90000, %Vmove%
        Gui, resizer: Add, Edit, x167 y247 w40 h20 Number vVresize, %Vresize%
        Gui, resizer: Add, UpDown, 0x80 Range1-90000, %Vresize%
        Gui, resizer: Font, s9 cDCDCCC norm
        Gui, resizer: Add, Button, x350 y147 w15 h15 gOrigxy, R
        Gui, resizer: Add, Button, x55 y147 w15 h15 gOrigwh, R
        Gui, resizer: Add, Button, x521 y189 w16 h16 gWup, U
        Gui, resizer: Add, Button, x521 y225 w16 h16 gWdown, D
        Gui, resizer: Add, Button, x503 y207 w16 h16 gWleft, L
        Gui, resizer: Add, Button, x539 y207 w16 h16 gWright, R
        Gui, resizer: Add, Button, x203 y362 w27 h21 gSavetemp1, T1
        Gui, resizer: Add, Button, x203 y390 w27 h21 gLoadtemp1, T1
        Gui, resizer: Add, Button, x235 y362 w27 h21 gSavetemp2, T2
        Gui, resizer: Add, Button, x235 y390 w27 h21 gLoadtemp2, T2
        Gui, resizer: Add, Button, x270 y362 w27 h21 gSave1, P1
        Gui, resizer: Add, Button, x270 y390 w27 h21 gLoad1, P1
        Gui, resizer: Add, Button, x302 y362 w27 h21 gSave2, P2
        Gui, resizer: Add, Button, x302 y390 w27 h21 gLoad2, P2
        Gui, resizer: Add, Button, x334 y362 w27 h21 gSave3, P3
        Gui, resizer: Add, Button, x334 y390 w27 h21 gLoad3, P3
        Gui, resizer: Add, Button, x366 y362 w27 h21 gSave4, P4
        Gui, resizer: Add, Button, x366 y390 w27 h21 gLoad4, P4
        Gui, resizer: Add, Button, x398 y362 w27 h21 gSave5, P5
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
    if (resX != "") {
        Gui, resizer: Show, w640 h560 x%resX% y%resY%, TSolidBackground Move/Resize Window
    } else if (optX != "") {
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

GetAllWindows() {       ;ahk_id's are in WinIDAll, titles are in WinTitleAll. 'Pseudo-arrays' were just easier to debug.
    Global
    Loop, %WinIDAll%        ;Sadly they are not perfect.
    {
        VarSetCapacity(WinIDAll%A_Index%, 0)
    }
    Loop, %WinTitleAll%
    {
        VarSetCapacity(WinTitleAll%A_Index%, 0)
    }
    DropDownAll := ""
    ;DetectHiddenWindows, On                    ;Detect hidden windows.
    WinGet, WinIDAll, List
    Loop, %WinIDAll%
    {
        CurrID := WinIDAll%A_Index%
        if (TBResized == CurrID) {
            DropDownCurrent := A_Index + 1
        }
        WinGetTitle, LoopTitle, ahk_id %CurrID%
        ;StringReplace, LoopTitle, LoopTitle,`n,,All            ;If window titles had new lines.
        if (!LoopTitle) {
            WinGetClass, LoopClass, ahk_id %CurrID%
            LoopTitle := "[DANGEROUS]  Untitled (Class:" . LoopClass . ") Window"
            if (!LoopClass) {
                LoopTitle := "[DANGEROUS]  Untitled " . A_Index . " .th Window"
            }
        }
        WinTitleAll%A_Index% := A_Index . " - " . LoopTitle
        DropDownAll .= LoopTitle . "`n"
    }
    StringTrimRight, DropDownAll, DropDownAll, 1
    ;DetectHiddenWindows, Off
}

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

DropDownSelected:
    Gui, Submit, NoHide
    VarIndex := DropDownCurrent - 1
    if (VarIndex != 0) {
        if (TBResized != WinIDAll%VarIndex%) {
            DrawHUD("Got a new window to move/resize.", "y160", "c836DFF", "s11", "1350")
            TBResized := WinIDAll%VarIndex%
            WinGetPos, Xorig, Yorig, Worig, Horig, ahk_id %TBResized%
            if (Xorig == -32000) {      ;Minimized windows
                Xorig := 100
                Yorig := 100
            }
        }
        ShowResizer()
    }
Return

ReloadDropDown:
    ShowResizer()
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
    Gui, hook: Font, s9
    Gui, hook: Add, Text, x500 y275, Tip: You can `nalso stop the `nwindow hooker `nusing the `ntray menu.
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
    if (optX == "") {
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
    WinGet, isNotMin, MinMax, %TitleTwo%
    WinGet, WindowExStyle, ExStyle, %TitleTwo%
    ;CurrActiveID := WinExist("A")
    ;WinGetTitle, CurrActiveTitle, ahk_id %CurrActiveID%
    WinGetTitle, CurrActiveTitle, A
    if (CurrActiveTitle == TitleOne) {
        if (isNotMin == -1) {
            WinRestore, %TitleTwo%
        }
        if (WindowExStyle & 0x8) {

        } else {
            WinSet, AlwaysOnTop, on, %TitleTwo%
        }
    } else {
        if ((WindowExStyle & 0x8) && (CurrActiveTitle != TitleTwo)) {
            WinSet, AlwaysOnTop, off, %TitleTwo%
        }
        IfWinNotExist, %TitleOne%
        {
            if (isNotMin != -1) {
                WinMinimize, %TitleTwo%
            }
        }
    }
    if (Hooking) {
        SetTimer, Hooker, 150
    } else {
        WinSet, AlwaysOnTop, off, %TitleTwo%
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
    Gui, Dummy: Add, Button, x35 y60 w164 h26 gSaveDummy, Save && Close
    Gui, Dummy: Font, cDCDCCC
    Gui, Dummy: Add, Text, x43 y100, Move 
    Gui, Dummy: Add, Text, x147 y100, Resize 
    Gui, Dummy: Add, Text, x26 y188, By: 
    Gui, Dummy: Add, Text, x129 y188, By: 
    Gui, Dummy: Add, Text, x55 y235, Center:
    Gui, Dummy: Font, s9 c836DFF norm Bold
    Gui, Dummy: Add, Edit, x47 y188 w40 h20 Number vVmove, %Vmove%
    Gui, Dummy: Add, UpDown, 0x80 Range1-90000, %Vmove%
    Gui, Dummy: Add, Edit, x150 y188 w40 h20 Number vVresize, %Vresize%
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
    SavedDummy := 0
    IfExist, TSolidBackground.ini
    {
        Readini(DummyX, "Dummy Window", "Dummy X")
        Readini(DummyY, "Dummy Window", "Dummy Y")
        Readini(DummyW, "Dummy Window", "Dummy W")
        Readini(DummyH, "Dummy Window", "Dummy H")
        SavedDummy := 1
    } else {
        DrawHUD("You must create the ini in advanced options before editing it.", "y160", "cE60000", "s11", "5000")
    }
    if (SavedDummy && DummyX != "ERROR") {
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
    Gui, mmover: Font, s9
    Gui, mmover: Add, Text, x260 y335, I can also add clicks later.
    Gui, mmover: Font, s9 c836DFF norm Bold
    Gui, mmover: Add, Edit, x290 y257 w40 h20 Number vMoveBy, %MoveBy%
    Gui, mmover: Add, UpDown, 0x80 Range1-90000, %MoveBy%
    Gui, mmover: Font, s9 cBlack norm
    Gui, mmover: Add, Button, x340 y258 w34 h18 gSetnow, Set
    Gui, mmover: Font, s10 Bold
    Gui, mmover: Add, Button, x174 y515 w290 h24, Close
    Gui, mmover: Add, Button, x10 y10 w44 h24 gBackGui, Back
    Gui, mmover: Font, s10 cDCDCCC norm
    Gui, mmover: Add, Text, x270 y256, By:
    Gui, mmover: Font, s13
    Gui, mmover: Add, Text, x220 y147, When this window is open,
    Gui, mmover: Add, Text, x140 y177, Use arrow keys to move the mouse pixel by pixel.
    Gui, mmover: Font, s10 c836DFF norm Underline
    Gui, mmover: Add, Text, x219 y435, Create .ini for permanent options
    Gui, mmover: Font, s10 cDCDCCC norm
    Gui, mmover: Add, Button, x254 y460 w130 h28 gRunCreateSaveini, Create/Save .ini
    WinGetPos, optX, optY, optW, optH, TSolidBackground Advanced Features
    if (optX == "") {
        Gui, mmover: Show, w640 h560, TSolidBackground Window Hooker (Alpha)
    } else {
        Gui, mmover: Show, w640 h560 x%optX% y%optY%, TSolidBackground Window Hooker (Alpha)
    }
    Gui, newmenu: Destroy
    mouseMoving := 1
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
~Left::
    MouseMove, -%MoveBy%, 0,, R
Return

~Right::
    MouseMove, %MoveBy%, 0,, R
Return

~Up::
    MouseMove, 0, -%MoveBy%,, R
Return

~Down::
    MouseMove, 0, %MoveBy%,, R
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
        bgcolor := 051523
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
    Writeini(StartupWindow, "Settings", "Enable Startup Window")
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
