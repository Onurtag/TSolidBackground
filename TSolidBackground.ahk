#SingleInstance Force
#NoEnv

/*
TSolidBackground
By Onurtag
https://onurtag.github.io/TSolidBackground/

If you have any good suggestions, feel free to contact me.
*/

Arrs := Object()
OnExit, Exited
bgcolor := 051523 
firsttime := 1
Version := "v2.5.0"
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
monitorIndex := 1
protectVNR := 1
Resizerunning := 0
Hooking := 0
TitleOne := "Main Window Title"
TitleTwo := "Hooked Window Title"

Menu, Tray, Icon,,, 1
Menu, Tray, NoStandard
Menu, Tray, Add, About TSolidBackground, Abouted
Menu, Tray, Add, Stop Window Hooker, StopHook
Menu, Tray, Disable, Stop Window Hooker
Menu, Tray, Add, Reload, Reloaded
Menu, Tray, Add, Exit, Exited
Menu, Tray, Tip, TSolidBackground

IfExist, TSolidBackground.ini
{
	Iniexists := "Yes"
	IniRead, bgcolor, TSolidBackground.ini, TSolidBackground Settings, Background Color 
	IniRead, TSolidBackgroundKey, TSolidBackground.ini, TSolidBackground Settings, TSolidBackground Key 
	IniRead, OnTopKey, TSolidBackground.ini, TSolidBackground Settings, On Top Key 
	IniRead, CenterKey, TSolidBackground.ini, TSolidBackground Settings, Center Window Key 
	IniRead, TaskbarKey, TSolidBackground.ini, TSolidBackground Settings, Show Hide Taskbar Key 
	IniRead, OptionsKey, TSolidBackground.ini, TSolidBackground Settings, Advanced Features Key 
	IniRead, SuspendKey, TSolidBackground.ini, TSolidBackground Settings, Suspend Hotkeys Key 
	IniRead, CustomWidthLeft, TSolidBackground.ini, TSolidBackground Settings, Custom Width Left
	IniRead, CustomWidthRight, TSolidBackground.ini, TSolidBackground Settings, Custom Width Right
	IniRead, CustomHeightTop, TSolidBackground.ini, TSolidBackground Settings, Custom Height Top
	IniRead, CustomHeightBottom, TSolidBackground.ini, TSolidBackground Settings, Custom Height Bottom
	IniRead, StartupWindow, TSolidBackground.ini, TSolidBackground Settings, Enable Startup Window 
	IniRead, TitleOne, TSolidBackground.ini, TSolidBackground Settings, Hooker Main Window
	IniRead, TitleTwo, TSolidBackground.ini, TSolidBackground Settings, Hooker Hooked Window
	Hotkey, %OnTopKey%, +Y
	Hotkey, %CenterKey%, +G
	Hotkey, %TaskbarKey%, +F
	Hotkey, %TSolidBackgroundKey%, +T
	Hotkey, %OptionsKey%, +U
	Hotkey, %SuspendKey%, F8
	if (OnTopKey != "+Y") { 
		Hotkey, +Y, Off
	}
	if (CenterKey != "+G") { 
		Hotkey, +G, Off
	}
	if (TaskbarKey != "+F") { 
		Hotkey, +F, Off
	}
	if (TSolidBackgroundKey != "+T") { 
		Hotkey, +T, Off
	}
	if (OptionsKey != "+U") { 
		Hotkey, +U, Off
	}
	if (SuspendKey != "F8") { 
		Hotkey, F8, Off
	}
}
    if(StartupWindow)
	{
		Gui, start: Color, 292929
		Gui, start: Font, s14 c836DFF bold, Segoe UI
		Gui, start: Add, Text,, TSolidBackground %Version%
		Gui, start: Font, s8 c836DFF bold
		Gui, start: Font, s10 cDCDCCC norm
		Gui, start: Add, Text, x18 y42, Current Hotkeys and Options: `n------------------------`nTSolidBackground: %TSolidBackgroundKey% `nAlways On Top: %OnTopKey% `nShow Hide Taskbar: %TaskbarKey% `nCenter Window: %CenterKey% `nAdvanced Features: %OptionsKey% `nSuspend other hotkeys: %SuspendKey%`nTSolidBackground.ini file exists: %Iniexists%`n------------------------ `nOn AutoHotkey [+] means [Shift]. `nIf no hotkeys work on selected window, run TSolidBackground as admin.`n`nIf you can't understand anything above, `nor just want to check for updates visit the project page: 
		Gui, start: Font, s10 c3257BF underline
		Gui, start: Add, Text, x18 y303 gGotoSite, https://onurtag.github.io/TSolidBackground/
		Gui, start: Font, s10 cBlack norm Bold
		Gui, start: Add, Button, x243 y338 w64 h36, Ok
		Gui, start: Show, w550 h393, Start TSolidBackground
	}
Return

+Y::
	WinGet, currentWindow, ID, A
	WinGetTitle, currentTitle, A
	if (currentTitle == "Kagami") 
	{
		if (protectVNR) 
		{
			TrayTip, Window [%currentTitle%] is protected., Check advanced options to disable it.
			Return
		}
	}
	Winstack(currentWindow)
	WinGet, WindowExStyle, ExStyle, ahk_id %currentWindow%
	if (WindowExStyle & 0x8) 
	{ 
		WinSet, AlwaysOnTop, off, ahk_id %currentWindow%
		TrayTip, Window [%currentTitle%], Always on top status: OFF
	} else {
		WinSet, AlwaysOnTop, on, ahk_id %currentWindow%
		TrayTip, Window [%currentTitle%], Always on top status: ON
	}
Return

+T::
	if (firsttime = 1) 
	{
		Activewin := WinExist("A")
		firsttime := 0
	}

	toggle := !toggle

	if (toggle = "1") 
	{
		if (WinExist("A") != Activewin) 
		{	
			Drawhud("Got a new window for TSolidBackground.","")
			Activewin := WinExist("A")
		}
		TSolidBackground()
	} else {
		DestroyTSolidBackground()
	}
Return

+G::
	WinGetPos,,, WWWidth, HHHeight, A
	GetMonitorIndexFromWindow(Activewin)
	mHeight := monitorBottom-monitorTop
	mWidth := monitorRight-monitorLeft
	if(monitorIndex!=1){
		WinMove, A,, (mWidth/2)-(WWWidth/2)+monitorLeft, (mHeight/2)-(HHHeight/2)+monitorTop-12
	} else {
		WinMove, A,, (A_ScreenWidth/2)-(WWWidth/2), (A_ScreenHeight/2)-(HHHeight/2)-12		;For new Win10 borders and stuff.
	}
	if (toggle = "1") 
	{
		TSolidBackground()
	}
Return

+F::
	if (TBtoggle = "") 
	{
		VarSetCapacity( APPBARDATA, 36, 0 )
		NumPut( 36, APPBARDATA, 0, "UInt" ) 
		NumPut( WinExist( "ahk_class Shell_TrayWnd" ), APPBARDATA, 4, "UInt" ) 
		TBtoggle := 0
	} 
	if (TBtoggle = 0) 
	{
		NumPut( ( ABS_ALWAYSONTOP := 0x2 )|( ABS_AUTOHIDE := 0x1 ), APPBARDATA, 32, "UInt" )
		DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
		Sleep, 100
		WinHide, ahk_class Shell_TrayWnd
		WinHide, Start ahk_class Button
		Sleep, 500
		WinHide, ahk_class Shell_TrayWnd	;Might as well do these again. They bug a lot.
		WinHide, Start ahk_class Button
		TBtoggle := 1
	} else {
		WinShow, ahk_class Shell_TrayWnd
		WinShow, Start ahk_class Button
		NumPut( ( ABS_ALWAYSONTOP := 0x2 ), APPBARDATA, 32, "UInt" )
		DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
		Sleep, 100
		WinShow, ahk_class Shell_TrayWnd	;Might as well do these again. They bug a lot.
		WinShow, Start ahk_class Button
		DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
		TBtoggle := 0
	}
Return

+U::
	if (Resizerunning) 
	{ 
		if (WinExist("A") != TBResized) 
		{	
			Drawhud("Got a new window to move/resize.","y200")
			TBResized := WinExist("A")
			WinGetPos, Xorig, Yorig, Worig, Horig, ahk_id %TBResized%
		}
		WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
	} else {
		ShowNewMenu()
	}
Return

ShowNewMenu(){
	Global
	Gui, newmenu: Destroy
	if (WinExist("A") != TBResized) 
	{	
		Drawhud("Got a new window to move/resize.","y200")
		TBResized := WinExist("A")
		WinGetPos, Xorig, Yorig, Worig, Horig, ahk_id %TBResized%
	}
	WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
	Gui, newmenu: +AlwaysOnTop
	Gui, newmenu: Color, 292929
	Gui, newmenu: Font, s14 c836DFF bold, Segoe UI
	Gui, newmenu: Add, Text, x236 y15 h13, Advanced Features
	Gui, newmenu: Font, s10 c836DFF norm Underline
	Gui, newmenu: Add, Text, x219 y355, Create .ini for permanent options
	Gui, newmenu: Font, s10 cDCDCCC norm
	Gui, newmenu: Add, Button, x254 y380 w130 h28 gCreateini, Create/Save .ini
	Gui, newmenu: Font, s12 c836DFF bold
	Gui, newmenu: Add, Button, x198 y100 w242 h38 gStartResizeGui, &Move/Resize Window
	Gui, newmenu: Add, Button, x198 y160 w242 h38 gStartHookGui, &Window Hooker (Alpha)
	Gui, newmenu: Add, Button, x198 y220 w242 h38 gStartOptionsGui, &Advanced Options
	Gui, newmenu: Font, s10 c836DFF bold
	Gui, newmenu: Add, Button, x174 y439 w290 h24, Close
	Gui, newmenu: Show, w640 h480, TSolidBackground Advanced Features
}

F8::
	Suspend
	if (A_IsSuspended) {
		Traytip, TSolidBackground, Suspended all other hotkeys. `nTo enable hotkeys press %SuspendKey%
		Menu, Tray, Tip, TSolidBackground Suspended
	} else {
		Traytip, TSolidBackground, Enabled all hotkeys.
		Menu, Tray, Tip, TSolidBackground
	}
Return

/*
F11::
	ListVars			;Variable debugging
Return
*/

Abouted:
	Gui, about: Destroy
	Gui, about: Color, 292929
	Gui, about: Font, s14 c836DFF, Segoe UI
	Gui, about: Add, Text,, TSolidBackground %Version%
	Gui, about: Font, s10 cDCDCCC
	Gui, about: Add, Text,, For readme, updates and more `ncheck out the project page:  
	Gui, about: Font, s10 c3257BF underline
	Gui, about: Add, Text, x18 y100 gGotoSite, https://onurtag.github.io/TSolidBackground/
	Gui, about: Font, s10 cBlack norm Bold
	Gui, about: Add, Button, x113 y136 w64 h36, Ok
	Gui, about: Show, w300 h192, About TSolidBackground
Return

TSolidBackground()
{
	Global
	WinGetPos, wX, wY, WWidth, HHeight, ahk_id %Activewin%
	GetMonitorIndexFromWindow(Activewin)
	mHeight := monitorBottom-monitorTop
	mWidth := monitorRight-monitorLeft
	SysGet, Border_Size, 32
	SysGet, Border_Size2, 33
	SysGet, Caption_Size, 4
	bg1FY := wY+Border_Size2+Caption_Size
	bg2FX := wX+Border_Size
	bg3SY := wY+HHeight-Border_Size2
	bg4SX := wX+WWidth-Border_Size
	
	WinGet, WinExStyle, ExStyle, ahk_id %Activewin%
	WinGet, WinStyle, Style, ahk_id %Activewin%
	if (WinExStyle & 0x8) 
	{ 
		WinGetTitle, currentTitle, ahk_id %Activewin%
		if (currentTitle != "Kagami") ;VNR fix
		{		
			WinSet, AlwaysOnTop, off, ahk_id %Activewin%
			TrayTip, Window [%currentTitle%], Always on top status: OFF
		}
	}

	if ((WinStyle & 0x40000) = 0) ;Unresizable window fix
	{		
		bg1FY -= 5
		bg2FX -= 5
		bg3SY += 5
		bg4SX += 5
	}

	bg1FY -= %CustomHeightTop%
	bg2FX -= %CustomWidthLeft%
	bg3SY += %CustomHeightBottom%
	bg4SX += %CustomWidthRight%
	
	SysGet, Allwidth, 78
	SysGet, Allheight, 79 
	if(monitorIndex!=1){
		bg2FX -= monitorLeft
		bg1FY -= monitorTop
		bg3H := Allheight-bg3SY
		bg4W := Allwidth-bg4SX
	} else {
		bg3H := A_ScreenHeight-bg3SY
		bg4W := A_ScreenWidth-bg4SX
	}
	
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
	if(monitorIndex!=1){
		if(wX<0) {
			bg4W := Abs(bg4SX)+monitorRight
			Gui, bg2: Show, NoActivate x%monitorLeft% y%monitorTop% h%mHeight% w%bg2FX%, TSolidBackground	
			Gui, bg4: Show, NoActivate x%bg4SX% y%monitorTop% h%mHeight% w%bg4W%, TSolidBackground
		} else {
			Gui, bg2: Show, NoActivate x%monitorLeft% y%monitorTop% h%mHeight% w%bg2FX%, TSolidBackground	
			Gui, bg4: Show, NoActivate x%bg4SX% y%monitorTop% h%mHeight% w%bg4W%, TSolidBackground	
		}
		if(wY<0){
			bg3H := Abs(bg3SY)+monitorBottom
			Gui, bg3: Show, NoActivate x%monitorLeft% y%bg3SY% h%bg3H% w%mWidth%, TSolidBackground
			Gui, bg1: Show, NoActivate x%monitorLeft% y%monitorTop% h%bg1FY% w%mWidth%, TSolidBackground	
		} else {
			Gui, bg3: Show, NoActivate x%monitorLeft% y%bg3SY% h%bg3H% w%mWidth%, TSolidBackground	
			Gui, bg1: Show, NoActivate x%monitorLeft% y%monitorTop% h%bg1FY% w%mWidth%, TSolidBackground	
		}
	} else {
		Gui, bg3: Show, NoActivate x0 y%bg3SY% h%bg3H% w%A_ScreenWidth%, TSolidBackground
		Gui, bg2: Show, NoActivate x0 y0 h%A_ScreenHeight% w%bg2FX%, TSolidBackground
		Gui, bg4: Show, NoActivate x%bg4SX% y0 h%A_ScreenHeight% w%bg4W%, TSolidBackground
		Gui, bg1: Show, NoActivate x0 y0 h%bg1FY% w%A_ScreenWidth%, TSolidBackground
	}
	Return
}

DestroyTSolidBackground()
{
	Gui, bg1: Destroy
	Gui, bg2: Destroy
	Gui, bg3: Destroy
	Gui, bg4: Destroy
	Return
}

Drawhud(Hudtext,xyvalue)
{
	Gui, hud: +AlwaysOnTop -Caption +ToolWindow +Border
	Gui, hud: Color, 292929
	Gui, hud: Font, s11 cBF3232 Bold Verdana
	Gui, hud: Add, Text,, %Hudtext%
	Gui, hud: Show, NoActivate %xyvalue%
	SetTimer, Deletehud, 1350
	Return
}

GetMonitorIndexFromWindow(windowHandle)		;Pre-made function by shinywong, thank you.
{
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

			if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
				and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom))
			{
				monitorIndex := A_Index
				break
			}
		}
	}
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

Createini:	
	Gui, Submit, NoHide
	Makeini()
Return

Makeini()
{
	Global
	if (bgcolor = "") 
	{
		bgcolor := 051523 
	}
	IniWrite, https://onurtag.github.io/TSolidBackground/, TSolidBackground.ini, Help, #For help go to 
	IniWrite, %TSolidBackgroundKey%, TSolidBackground.ini, TSolidBackground Settings, TSolidBackground Key 
	IniWrite, %OnTopKey%, TSolidBackground.ini, TSolidBackground Settings, On Top Key 
	IniWrite, %CenterKey%, TSolidBackground.ini, TSolidBackground Settings, Center Window Key 
	IniWrite, %TaskbarKey%, TSolidBackground.ini, TSolidBackground Settings, Show Hide Taskbar Key 
	IniWrite, %OptionsKey%, TSolidBackground.ini, TSolidBackground Settings, Advanced Features Key 
	IniWrite, %SuspendKey%, TSolidBackground.ini, TSolidBackground Settings, Suspend Hotkeys Key 
	IniWrite, %CustomWidthLeft%, TSolidBackground.ini, TSolidBackground Settings, Custom Width Left
	IniWrite, %CustomWidthRight%, TSolidBackground.ini, TSolidBackground Settings, Custom Width Right
	IniWrite, %CustomHeightTop%, TSolidBackground.ini, TSolidBackground Settings, Custom Height Top
	IniWrite, %CustomHeightBottom%, TSolidBackground.ini, TSolidBackground Settings, Custom Height Bottom
	IniWrite, %StartupWindow%, TSolidBackground.ini, TSolidBackground Settings, Enable Startup Window 
	IniWrite, %TitleOne%, TSolidBackground.ini, TSolidBackground Settings, Hooker Main Window
	IniWrite, %TitleTwo%, TSolidBackground.ini, TSolidBackground Settings, Hooker Hooked Window
	IniWrite, %bgcolor%, TSolidBackground.ini, TSolidBackground Settings, Background Color 
	Drawhud("TSolidBackground.ini file was created/edited.","y180")
	Return
}

;Advanced Options Start
StartOptionsGui:
	ShowOptions()
Return

ShowOptions(){
	Global
	Gui, options: Destroy
	Gui, options: +AlwaysOnTop
	Gui, options: Font, s14 c836DFF bold, Segoe UI
	Gui, options: Add, Text,x240 y15 h13, Advanced Options
	Gui, options: Color, 292929
	Gui, options: Font, s10 cDCDCCC norm
	Gui, options: Add, Text, x202 y75 h13, Custom Width Left:
	Gui, options: Add, Text, x202 y96 h13, Custom Width Right:
	Gui, options: Add, Text, x202 y117 h13, Custom Height Top:
	Gui, options: Add, Text, x202 y138 h13, Custom Height Bottom:
	Gui, options: Add, Text, x202 y205, TSolidBackground Color:
	Gui, options: Font, s10 c836DFF bold
	Gui, options: Add, Button, x174 y439 w290 h24, Close
	Gui, options: Add, Edit, x360 y73 w70 h20 vCustomWidthLeft,%CustomWidthLeft%
	Gui, options: Add, Edit, x360 y94 w70 h20 vCustomWidthRight,%CustomWidthRight%
	Gui, options: Add, Edit, x360 y115 w70 h20 vCustomHeightTop,%CustomHeightTop%
	Gui, options: Add, Edit, x360 y136 w70 h20 vCustomHeightBottom,%CustomHeightBottom%
	Gui, options: Add, Edit, x360 y203  w70 h20 vbgcolor,%bgcolor%
	Gui, options: Add, Progress, x360 y225 w70 h20 c%bgcolor% Background%bgcolor% vbarcolored, 100
	Gui, options: Font, norm Underline
	Gui, options: Add, Text, x219 y355, Create .ini for permanent options
	Gui, options: Font, s9 cDCDCCC norm
	Gui, options: Add, Button, x434 y75 w16 h16 gResetcwh, R
	Gui, options: Add, Button, x434 y205 w16 h16 gResetcolor, R
	Gui, options: Add, Button, x361 y161 w68 h18 gSetnow, Set CWH
	Gui, options: Add, Button, x361 y249 w68 h18 gSetcolor, Set Color
	Gui, options: Font, s10 cDCDCCC norm
	Gui, options: Add, Button, x254 y380 w130 h28 gCreateini, Create/Save .ini
	Gui, options: Add, Checkbox, x202 y290 Checked%protectVNR% vprotectVNR gSetnow, Protect VNR (Kagami Titled Window)
	Gui, options: Show, w640 h480, Advanced Options
	Gui, newmenu: Destroy
	Return
}

OptionsButtonClose:
OptionsGuiEscape:
	Gui, options: Destroy
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
	if(bgcolor==051523){
		GuiControl, options:,bgcolor,250000
	} else {
		GuiControl, options:,bgcolor,051523
	}
	Gui, Submit, NoHide
	RefresherOptions()
Return

RefresherOptions()
{
	Global
	GuiControl,+c%bgcolor% +Background%bgcolor%, barcolored
	Return
}
;Advanced Options End


;Move/Resize Start
StartResizeGui:
	ShowResizer()
Return

ShowResizer(){
	Global
	Gui, resizer: Destroy
	WinGetPos,Xofwin,Yofwin,Wofwin,Hofwin, ahk_id %TBResized%
	SysGet, Border_Size, 32
	SysGet, Border_Size2, 33
	SysGet, Caption_Size, 4
	Wnew := Wofwin
	Hnew := Hofwin
	Xnew := Xofwin
	Ynew := Yofwin
	Hclient := Hofwin - 2*Border_Size2 - Caption_Size
	Wclient := Wofwin - 2*Border_Size
	Gui, resizer: +AlwaysOnTop
	Gui, resizer: Font, s14 c836DFF bold, Segoe UI
	Gui, resizer: Add, Text, x110 y15 h13, Resize Window
	Gui, resizer: Add, Text, x400 y15 h13, Move Window
	Gui, resizer: Color, 292929
	Gui, resizer: Font, s10 cDCDCCC norm
	Gui, resizer: Add, Text, x75 y55 h13, Current:
	Gui, resizer: Add, Text, x75 y75 h13, Original:
	Gui, resizer: Add, Text, x75 y95 h13, Client area:
	Gui, resizer: Add, Text, x75 y184, New Width:
	Gui, resizer: Add, Text, x75 y206, New Height:
	Gui, resizer: Add, Text, x370 y55 h13, Current:
	Gui, resizer: Add, Text, x370 y75 h13, Original:
	Gui, resizer: Add, Text, x370 y184, New X:
	Gui, resizer: Add, Text, x370 y206, New Y:
	Gui, resizer: Add, Text, x370 y95, Center:
	Gui, resizer: Add, Text, x498 y148 h13, By: 
	Gui, resizer: Add, Text, x90 y273 h13, Temp/Perm Save: 
	Gui, resizer: Add, Text, x90 y301 h13, Load Saved Pos: 
	Gui, resizer: Font, s9 cDCDCCC norm
	Gui, resizer: Add, Text, x500 y275, Tip: You can use `nyour advanced `noptions (%OptionsKey%) `nhotkey to select `na new window.
	Gui, resizer: Font, s10 cb396ff norm
	Wofwin := 0000		;Ahk gui bug temp fix.
	Hofwin := 0000 
	Xofwin := 0000 
	Yofwin := 0000
	Gui, resizer: Add, Text, x150 y55 h13 vCurrentWH, W: %Wofwin%, H: %Hofwin%
	Gui, resizer: Add, Text, x426 y55 h13 vCurrentXY, X: %Xofwin%, Y: %Yofwin%
	Gui, resizer: Font, s10 c836DFF norm
	Gui, resizer: Add, Text, x150 y95 h13, W: %Wclient%, H: %Hclient%
	Gui, resizer: Add, Text, x150 y75 h13, W: %Worig%, H: %Horig%
	Gui, resizer: Add, Text, x426 y75 h13, X: %Xorig%, Y: %Yorig%
	Gui, resizer: Add, Button, x254 y380 w130 h28 gCreateini, Create/Save .ini
	Gui, resizer: Font, s10 c836DFF bold
	Gui, resizer: Add, Edit, x158 y183 w64 h20 vWnew, %Wnew%
	Gui, resizer: Add, Edit, x158 y205 w64 h20 vHnew, %Hnew%
	Gui, resizer: Add, Edit, x424 y183 w64 h20 vXnew, %Xnew%
	Gui, resizer: Add, Edit, x424 y205 w64 h20 vYnew, %Ynew%
	Gui, resizer: Add, Button, x174 y439 w290 h24, Close
	Gui, resizer: Font, norm Underline
	Gui, resizer: Add, Text, x218 y248, Quick save/load size and position
	Gui, resizer: Add, Text, x219 y355, Create .ini for permanent options
	Gui, resizer: Font, s9 c836DFF norm bold
	Gui, resizer: Add, Edit, x517 y147 w24 h20 vVmove,1
	Gui, resizer: Font, s9 cDCDCCC norm
	Gui, resizer: Add, Button, x351 y77 w15 h15 gOrigxy, R
	Gui, resizer: Add, Button, x56 y77 w15 h15 gOrigwh, R
	Gui, resizer: Add, Button, x521 y89 w16 h16 gWup, U
	Gui, resizer: Add, Button, x521 y125 w16 h16 gWdown, D
	Gui, resizer: Add, Button, x503 y107 w16 h16 gWleft, L
	Gui, resizer: Add, Button, x539 y107 w16 h16 gWright, R
	Gui, resizer: Add, Button, x203 y272 w27 h21 gSavetemp1, T1
	Gui, resizer: Add, Button, x203 y300 w27 h21 gLoadtemp1, T1
	Gui, resizer: Add, Button, x235 y272 w27 h21 gSavetemp2, T2
	Gui, resizer: Add, Button, x235 y300 w27 h21 gLoadtemp2, T2
	Gui, resizer: Add, Button, x270 y272 w27 h21 gSave1, P1
	Gui, resizer: Add, Button, x270 y300 w27 h21 gLoad1, P1
	Gui, resizer: Add, Button, x302 y272 w27 h21 gSave2, P2
	Gui, resizer: Add, Button, x302 y300 w27 h21 gLoad2, P2
	Gui, resizer: Add, Button, x334 y272 w27 h21 gSave3, P3
	Gui, resizer: Add, Button, x334 y300 w27 h21 gLoad3, P3
	Gui, resizer: Add, Button, x366 y272 w27 h21 gSave4, P4
	Gui, resizer: Add, Button, x366 y300 w27 h21 gLoad4, P4
	Gui, resizer: Add, Button, x398 y272 w27 h21 gSave5, P5
	Gui, resizer: Add, Button, x398 y300 w27 h21  gLoad5, P5
	Gui, resizer: Add, Button, x231 y194 w52 h18 gResizenow, Resize
	Gui, resizer: Add, Button, x496 y194 w52 h18 gMovenow, Move
	Gui, resizer: Add, Button, x424 y96 w64 h18 gHcenter, H-Center
	Gui, resizer: Add, Button, x424 y118 w64 h18 gVcenter, V-Center
	Gui, resizer: Show, w640 h480, Move/Resize Window
	Gui, newmenu: Destroy
	Refresher()
	Resizerunning := 1
	Return
}

resizerGuiClose:
resizerButtonClose:
resizerGuiEscape:
	SetTimer, Refresher, Off
	Gui, resizer: Destroy
	Resizerunning := 0
Return

Refresher()
{
	Global
	WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
	GuiControl, resizer:, CurrentWH, W: %Wofwin%, H: %Hofwin%
	GuiControl, resizer:, CurrentXY, X: %Xofwin%, Y: %Yofwin%
	SetTimer, Refresher, 50
	Return
}

RefresherEdit()
{
	Global
	WinGetPos, Xofwin, Yofwin, Wofwin, Hofwin, ahk_id %TBResized%
	GuiControl, resizer:, Wnew, %Wofwin%
	GuiControl, resizer:, Hnew, %Hofwin%
	GuiControl, resizer:, Xnew, %Xofwin%
	GuiControl, resizer:, Ynew, %Yofwin%
	Return
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
	GetMonitorIndexFromWindow(Activewin)
	mHeight := monitorBottom-monitorTop
	mWidth := monitorRight-monitorLeft
	if(monitorIndex!=1){
		WinMove,ahk_id %TBResized%,,,(mHeight/2)-(Hofwin/2)+monitorTop-12
	} else {
		WinMove,ahk_id %TBResized%,,,(A_ScreenHeight/2)-(Hofwin/2)-12
	}
	RefresherEdit()
Return

Hcenter:
	GetMonitorIndexFromWindow(Activewin)
	mHeight := monitorBottom-monitorTop
	mWidth := monitorRight-monitorLeft
	if(monitorIndex!=1){
		WinMove,ahk_id %TBResized%,,(mWidth/2)-(Wofwin/2)+monitorLeft,
	} else {
		WinMove,ahk_id %TBResized%,,(A_ScreenWidth/2)-(Wofwin/2),
	}
	RefresherEdit()
Return

Wup:
	Gui, Submit, NoHide
	newcrap := Yofwin-Vmove
	WinMove,ahk_id %TBResized%,,,%newcrap%
	RefresherEdit()
Return

Wdown:
	Gui, Submit, NoHide
	newcrap := Yofwin+Vmove
	WinMove,ahk_id %TBResized%,,,%newcrap%
	RefresherEdit()
Return

Wleft:
	Gui, Submit, NoHide
	newcrap := Xofwin-Vmove
	WinMove,ahk_id %TBResized%,,%newcrap%,
	RefresherEdit()
Return

Wright:
	Gui, Submit, NoHide
	newcrap := Xofwin+Vmove
	WinMove,ahk_id %TBResized%,,%newcrap%,
	RefresherEdit()
Return

Origxy:
	WinMove,ahk_id %TBResized%,,%Xorig%,%Yorig%
Return

Origwh:
	WinMove,ahk_id %TBResized%,,,,%Worig%,%Horig%
Return

Savetemp1:
	WinGetPos,Temp1X,Temp1Y,Temp1W,Temp1H,ahk_id %TBResized%
Return

Loadtemp1:
	WinMove,ahk_id %TBResized%,,%Temp1X%,%Temp1Y%,%Temp1W%,%Temp1H%
Return

Savetemp2:
	WinGetPos,Temp2X,Temp2Y,Temp2W,Temp2H,ahk_id %TBResized%
Return

Loadtemp2:
	WinMove,ahk_id %TBResized%,,%Temp2X%,%Temp2Y%,%Temp2W%,%Temp2H%
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

Loadpos(posnr)
{
	Global
	IniRead, PermX, TSolidBackground.ini, Saved %posnr%, X
	IniRead, PermY, TSolidBackground.ini, Saved %posnr%, Y
	IniRead, PermW, TSolidBackground.ini, Saved %posnr%, W
	IniRead, PermH, TSolidBackground.ini, Saved %posnr%, H
	if (PermX == "ERROR") 
	{
		DrawHud("Saved position or .ini file doesn't exist.","y180")
	} else {
		WinMove,ahk_id %TBResized%,, %PermX%, %PermY%, %PermW%, %PermH%
	}
	Return
}

Savepos(posnr)
{
	Global
	IfNotExist, TSolidBackground.ini
	{
		Makeini()
	}
	WinGetPos,Xofwin,Yofwin,Wofwin,Hofwin,ahk_id %TBResized%
	IniWrite, %Xofwin%, TSolidBackground.ini, Saved %posnr%, X
	IniWrite, %Yofwin%, TSolidBackground.ini, Saved %posnr%, Y
	IniWrite, %Wofwin%, TSolidBackground.ini, Saved %posnr%, W
	IniWrite, %Hofwin%, TSolidBackground.ini, Saved %posnr%, H
}
;Move/Resize End

;Hooker Start
ShowHooker(){
	Global
	Gui, hook: Destroy
	Gui, hook: +AlwaysOnTop
	Gui, hook: Color, 292929
	Gui, hook: Font, s14 c836DFF bold, Segoe UI
	Gui, hook: Add, Text, x242 y12, Window Hooker (Alpha)
	Gui, hook: Font, s10 c836DFF norm Underline
	Gui, hook: Add, Text, x219 y355, Create .ini for permanent options
	Gui, hook: Font, s10 cDCDCCC norm
	Gui, hook: Add, Button, x254 y380 w130 h28 gCreateini, Create/Save .ini
	Gui, hook: Add, Text, x112 y112, Main Window:  
	Gui, hook: Add, Text, x112 y152, Hooked Window:  
	Gui, hook: Add, Text, x60 y47 , Window Hooker currently only works for minimizing/switching tabs on browsers.`nFor now it can't make them move together. The .ini file will save the window titles too.
	Gui, hook: Font, s9
	Gui, hook: Add, Text, x500 y275, Tip: You can `nalso stop the `nwindow hooker `nusing the tray `nicon menu.
	Gui, hook: Font, s10 cBlack norm
	Gui, hook: Add, Edit, x234 y111 w170 h20 vTitleOne, %TitleOne%
	Gui, hook: Add, Edit, x234 y151 w170 h20 vTitleTwo, %TitleTwo%
	Gui, hook: Add, Button, x421 y109 h23 gGetactiveOne, Get last active window
	Gui, hook: Add, Button, x421 y149 h23 gGetactiveTwo, Get last active window
	if(Hooking == 0) {
		Gui, hook: Add, Button, x237 y192 w164 h66 gStartHook, Start Hook
	} else {
		Gui, hook: Add, Button, x237 y192 w164 h66 gStopHook, Stop Hook
	}
	Gui, hook: Font, s10 cBlack norm Bold
	Gui, hook: Add, Button, x174 y439 w290 h24, Close
	Gui, hook: Show, w640 h480, Window Hooker (Alpha)
	Gui, newmenu: Destroy
	Return
}

StartHookGui:
	ShowHooker()
Return

hookButtonClose:
hookGuiEscape:
	Gui, hook: Destroy
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

Hooker(){
	Global
	;WinGet, isNotMin, MinMax, %TitleOne%
	WinGet, WindowExStyle, ExStyle, %TitleTwo%
	CurrActiveID := WinExist("A")
	WinGetTitle, CurrActiveTitle, ahk_id %CurrActiveID%
	if ((CurrActiveTitle == TitleOne) || (CurrActiveTitle == TitleTwo))
	{
		if (WindowExStyle & 0x8) 
		{ 
			/*
			if ((isNotMin != 1) && (isNotMin != 0)) 
			{
				
			}
			*/
		} else {
			WinRestore, %TitleTwo%
			Sleep, 30
			WinSet, AlwaysOnTop, on, %TitleTwo%
		}
	} else {
		if (WindowExStyle & 0x8) 
		{ 
			WinSet, AlwaysOnTop, off, %TitleTwo%
			Sleep, 30
			WinMinimize, %TitleTwo%
		}
	}
	if (Hooking)
	{
		SetTimer, Hooker, 70
	} else {
		WinSet, AlwaysOnTop, off, %TitleTwo%
	}
	Return
}

KillHooker(){
	Global
	Hooking := 0
	SetTimer, Hooker, Off
	ShowHooker()
	Menu, Tray, Disable, Stop Window Hooker
	Return
}
;Hooker End

Reloaded:
	Reload
Return

Winstack(winid) 
{
    global Arrs
    if (!Arrs.hasKey(winid))
		Arrs[winid] := true
}

Exited:
	for currentWindow, b in Arrs 
	{
		WinSet, AlwaysOnTop, off, ahk_id %currentWindow%
    }
	WinShow, ahk_class Shell_TrayWnd
	WinShow, Start ahk_class Button
ExitApp
