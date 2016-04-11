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
Version := "v2.4.4"
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

Menu, Tray, Icon,,, 1
Menu, Tray, NoStandard
Menu, Tray, Add, About TSolidBackground, Abouted
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
	IniRead, OptionsKey, TSolidBackground.ini, TSolidBackground Settings, Options Key 
	IniRead, SuspendKey, TSolidBackground.ini, TSolidBackground Settings, Suspend Hotkeys Key 
	IniRead, CustomWidthLeft, TSolidBackground.ini, TSolidBackground Settings, Custom Width Left
	IniRead, CustomWidthRight, TSolidBackground.ini, TSolidBackground Settings, Custom Width Right
	IniRead, CustomHeightTop, TSolidBackground.ini, TSolidBackground Settings, Custom Height Top
	IniRead, CustomHeightBottom, TSolidBackground.ini, TSolidBackground Settings, Custom Height Bottom
	IniRead, StartupWindow, TSolidBackground.ini, TSolidBackground Settings, Enable Startup Window 
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
		Gui, start: Font, s14 c836DFF bold
		Gui, start: Add, Text,, TSolidBackground %Version%
		Gui, start: Font, s8 c836DFF bold
		Gui, start: Font, s10 cDCDCCC norm
		Gui, start: Add, Text, x18 y42, Current Hotkeys and Options: `n------------------------`nTSolidBackground: %TSolidBackgroundKey% `nAlways On Top: %OnTopKey% `nShow Hide Taskbar: %TaskbarKey% `nCenter Window: %CenterKey% `nAdvanced Options: %OptionsKey% `nSuspend other hotkeys: %SuspendKey%`nTSolidBackground.ini file exists: %Iniexists%`n------------------------ `nOn AutoHotkey [+] means [Shift]. `nIf no hotkeys work on selected window, run TSolidBackground as admin.`n`nIf you can't understand anything above, `nor just want to check for updates visit the project page: 
		Gui, start: Font, s10 c3257BF underline
		Gui, start: Add, Text, x18 y283 gGotoSite, https://onurtag.github.io/TSolidBackground/
		Gui, start: Font, s10 cBlack norm
		Gui, start: Add, Button, x243 y313 w64 h36 , Ok
		Gui, start: Show, w550 h364, Start TSolidBackground
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
		WinMove, A,, (mWidth/2)-(WWWidth/2)+monitorLeft, (mHeight/2)-(HHHeight/2)+monitorTop-18
	} else {
		WinMove, A,, (A_ScreenWidth/2)-(WWWidth/2), (A_ScreenHeight/2)-(HHHeight/2)-18		;For new Win10 borders and stuff.
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
	Gui, resize: Destroy
	if (WinExist("A") != TBResized) 
	{	
		Drawhud("Got a new window to move/resize.","y220")
		TBResized := WinExist("A")
		WinGetPos,Xorig,Yorig,Worig,Horig,ahk_id %TBResized%
	}
	WinGetPos,Xofwin,Yofwin,Wofwin,Hofwin,ahk_id %TBResized%
	SysGet, Border_Size, 32
	SysGet, Border_Size2, 33
	SysGet, Caption_Size, 4
	Wnew := Wofwin
	Hnew := Hofwin
	Xnew := Xofwin
	Ynew := Yofwin
	Hclient := Hofwin - 2*Border_Size2 - Caption_Size
	Wclient := Wofwin - 2*Border_Size
	Gui, resize: +AlwaysOnTop
	Gui, resize: Font, s14 c836DFF bold
	Gui, resize: Add,Text,x90 y15 h13,Resize Window
	Gui, resize: Add,Text,x360 y15 h13,Move Window
	Gui, resize: Add,Text,x640 y15 h13,Settings
	Gui, resize: Color, 292929
	Gui, resize: Font, s10 cDCDCCC norm
	Gui, resize: Add,Text,x60 y55 h13,Current:
	Gui, resize: Add,Text,x60 y75 h13,Original:
	Gui, resize: Add,Text,x60 y95 h13,Client area:
	Gui, resize: Add,Text,x60 y184,New Width:
	Gui, resize: Add,Text,x60 y204,New Height:
	Gui, resize: Add,Text,x325 y55 h13,Current:
	Gui, resize: Add,Text,x325 y75 h13,Original:
	Gui, resize: Add,Text,x325 y184,New X:
	Gui, resize: Add,Text,x325 y204,New Y:
	Gui, resize: Add,Text,x325 y95,Center:
	Gui, resize: Add,Text,x560 y55 h13,Custom Width Left:
	Gui, resize: Add,Text,x560 y75 h13,Custom Width Right:
	Gui, resize: Add,Text,x560 y95 h13,Custom Height Top:
	Gui, resize: Add,Text,x560 y115 h13,Custom Height Bottom:
	Gui, resize: Add,Text,x560 y171,TSB Color:
	Gui, resize: Add,Text,x473 y148 h13,By: 
	Gui, resize: Add,Text,x194 y274 h13,Temp/Perm Save: 
	Gui, resize: Add,Text,x194 y303 h13,Load Saved Pos: 
	Gui, resize: Font, s10 cb396ff norm
	Wofwin := 0000		;Ahk gui bug temp fix.
	Hofwin := 0000 
	Xofwin := 0000 
	Yofwin := 0000
	Gui, resize: Add,Text,x150 y55 h13 vCurrentWH,W: %Wofwin%,  H: %Hofwin%
	Gui, resize: Add,Text,x396 y55 h13 vCurrentXY,X: %Xofwin%,  Y: %Yofwin%
	Gui, resize: Font, s10 c836DFF norm
	Gui, resize: Add,Text,x150 y95 h13,W: %Wclient%,  H: %Hclient%
	Gui, resize: Add,Text,x150 y75 h13,W: %Worig%,  H: %Horig%
	Gui, resize: Add,Text,x396 y75 h13,X: %Xorig%,  Y: %Yorig%
	Gui, resize: Font, s9 c836DFF bold
	Gui, resize: Add,Edit,x496 y147 w24 h19 vVmove,1
	Gui, resize: Font, s10 c836DFF bold
	Gui, resize: Add,Edit,x150 y183 w70 h19 vWnew,%Worig%
	Gui, resize: Add,Edit,x150 y203 w70 h19 vHnew,%Horig%
	Gui, resize: Add,Edit,x390 y183 w70 h19 vXnew,%Xorig%
	Gui, resize: Add,Edit,x390 y203 w70 h19 vYnew,%Yorig%
	Gui, resize: Add,Edit,x712 y53 w70 h19 vCustomWidthLeft,%CustomWidthLeft%
	Gui, resize: Add,Edit,x712 y73 w70 h19 vCustomWidthRight,%CustomWidthRight%
	Gui, resize: Add,Edit,x712 y93 w70 h19 vCustomHeightTop,%CustomHeightTop%
	Gui, resize: Add,Edit,x712 y113 w70 h19 vCustomHeightBottom,%CustomHeightBottom%
	Gui, resize: Add,Edit,x635 y170 w70 h19 vbgcolor,%bgcolor%
	Gui, resize: Add,Progress,x712 y170 w70 h19 c%bgcolor% Background%bgcolor% vbarcolored, 100
	Gui, resize: Add,Button,x124 y409 w600 h22,Close
	Gui, resize: Font, Underline
	Gui, resize: Add,Text,x315 y338,Create .ini for permanent options
	Gui, resize: Add,Text,x312 y248,Quick save/load size and position
	Gui, resize: Font, cDCDCCC norm
	Gui, resize: Add,Button,x230 y193 w52 h18 gResizenow,Resize
	Gui, resize: Add,Button,x470 y193 w52 h18 gMovenow,Move
	Gui, resize: Add,Button,x394 y95 w64 h18 gHcenter,H-Center
	Gui, resize: Add,Button,x394 y117 w64 h18 gVcenter,V-Center
	Gui, resize: Add,Button,x486 y89 w16 h16 gWup,U
	Gui, resize: Add,Button,x486 y125 w16 h16 gWdown,D
	Gui, resize: Add,Button,x468 y107 w16 h16 gWleft,L
	Gui, resize: Add,Button,x504 y107 w16 h16 gWright,R
	Gui, resize: Add,Button,x713 y138 w68 h18 gSetnow,Set CWH
	Gui, resize: Add,Button,x789 y54 w14 h17 gResetcwh,R
	Gui, resize: Add,Button,x713 y195 w68 h18 gSetcolor,Set Color
	Gui, resize: Add,Button,x789 y171 w14 h17 gResetcolor,R
	Gui, resize: Add,Button,x378 y364 w90 h28 gCreateini,Make/Edit .ini
	Gui, resize: Add,Button,x316  y272 w27 h22 gSavetemp1,T1
	Gui, resize: Add,Button,x316 y301 w27 h22 gLoadtemp1,T1
	Gui, resize: Add,Button,x348 y272 w27 h22 gSavetemp2,T2
	Gui, resize: Add,Button,x348 y301 w27 h22 gLoadtemp2,T2
	Gui, resize: Add,Button,x384 y272 w27 h22 gSave1,P1
	Gui, resize: Add,Button,x384 y301 w27 h22 gLoad1,P1
	Gui, resize: Add,Button,x416 y272 w27 h22 gSave2,P2
	Gui, resize: Add,Button,x416 y301 w27 h22 gLoad2,P2
	Gui, resize: Add,Button,x448 y272 w27 h22 gSave3,P3
	Gui, resize: Add,Button,x448 y301 w27 h22 gLoad3,P3
	Gui, resize: Add,Button,x480 y272 w27 h22 gSave4,P4
	Gui, resize: Add,Button,x480 y301 w27 h22 gLoad4,P4
	Gui, resize: Add,Button,x512 y272 w27 h22 gSave5,P5
	Gui, resize: Add,Button,x512 y301 w27 h22 gLoad5,P5
	Gui, resize: Add,Button,x306 y74 w14 h18 gOrigxy,O
	Gui, resize: Add,Button,x41 y74 w14 h18 gOrigwh,O
	Gui, resize: Add,Checkbox,x562 y222 Checked%protectVNR% vprotectVNR gSetnow, Protect VNR (Kagami)
	Gui, resize: Show,w850 h447, Resize / Move and Custom Sizes
	Refresher()
Return

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
	ListVars
Return
*/

Winstack(winid) 
{
    global Arrs
    if (!Arrs.hasKey(winid))
		Arrs[winid] := true
}

Abouted:
	Gui, about: Destroy
	Gui, about: Color, 292929
	Gui, about: Font, s14 c836DFF
	Gui, about: Add, Text,, TSolidBackground %Version%
	Gui, about: Font, s10 cDCDCCC
	Gui, about: Add, Text,, For readme, updates and more `ncheck out the project page:  
	Gui, about: Font, s10 c3257BF underline
	Gui, about: Add, Text, gGotoSite, https://onurtag.github.io/TSolidBackground/
	Gui, about: Font, s10 cBlack norm
	Gui, about: Add, Button, x113 y140 w74 h36 , Ok
	Gui, about: Show, w300 h198, About TSolidBackground
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

DestroyTSolidBackground()
{
	Gui, bg1: Destroy
	Gui, bg2: Destroy
	Gui, bg3: Destroy
	Gui, bg4: Destroy
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

Refresher()
{
	Global
	WinGetPos,Xofwin,Yofwin,Wofwin,Hofwin,ahk_id %TBResized%
	GuiControl, resize:,CurrentWH,W: %Wofwin%,  H: %Hofwin%
	GuiControl, resize:,CurrentXY,X: %Xofwin%,  Y: %Yofwin%
	SetTimer, Refresher, 50
	Return
}

RefresherEdit()
{
	Global
	WinGetPos,Xofwin,Yofwin,Wofwin,Hofwin,ahk_id %TBResized%
	GuiControl, resize:,Wnew,%Wofwin%
	GuiControl, resize:,Hnew,%Hofwin%
	GuiControl, resize:,Xnew,%Xofwin%
	GuiControl, resize:,Ynew,%Yofwin%
	GuiControl,+c%bgcolor% +Background%bgcolor%, barcolored
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
aboutButtonOk:
aboutGuiEscape:
	Gui, start: Destroy
	Gui, about: Destroy
Return

resizeGuiClose:
resizeButtonClose:
resizeGuiEscape:
	SetTimer, Refresher, Off
	Gui, resize: Destroy
Return

Resizenow:
	Gui, Submit, NoHide
	WinMove,ahk_id %TBResized%,,,,%Wnew%,%Hnew%
	RefresherEdit()
Return	

Movenow:
	Gui, Submit, NoHide
	WinMove,ahk_id %TBResized%,,%Xnew%,%Ynew%
	RefresherEdit()
Return

Setnow:
	Gui, Submit, NoHide
Return

Resetcwh:
	GuiControl, resize:,CustomHeightBottom,0
	GuiControl, resize:,CustomHeightTop,0
	GuiControl, resize:,CustomWidthRight,0
	GuiControl, resize:,CustomWidthLeft,0
	Gui, Submit, NoHide
Return


Setcolor:
	Gui, Submit, NoHide
	RefresherEdit()
Return

Resetcolor:
	if(bgcolor==051523){
		GuiControl, resize:,bgcolor,250000
	} else {
		GuiControl, resize:,bgcolor,051523
	}
	Gui, Submit, NoHide
	RefresherEdit()
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
	IniWrite, %OptionsKey%, TSolidBackground.ini, TSolidBackground Settings, Options Key 
	IniWrite, %SuspendKey%, TSolidBackground.ini, TSolidBackground Settings, Suspend Hotkeys Key 
	IniWrite, %CustomWidthLeft%, TSolidBackground.ini, TSolidBackground Settings, Custom Width Left
	IniWrite, %CustomWidthRight%, TSolidBackground.ini, TSolidBackground Settings, Custom Width Right
	IniWrite, %CustomHeightTop%, TSolidBackground.ini, TSolidBackground Settings, Custom Height Top
	IniWrite, %CustomHeightBottom%, TSolidBackground.ini, TSolidBackground Settings, Custom Height Bottom
	IniWrite, %bgcolor%, TSolidBackground.ini, TSolidBackground Settings, Background Color 
	Drawhud("TSolidBackground.ini file was created/edited.","")
	Return
}

Vcenter:	
	GetMonitorIndexFromWindow(Activewin)
	mHeight := monitorBottom-monitorTop
	mWidth := monitorRight-monitorLeft
	if(monitorIndex!=1){
		WinMove,ahk_id %TBResized%,,,(mHeight/2)-(Hofwin/2)+monitorTop-18
	} else {
		WinMove,ahk_id %TBResized%,,,(A_ScreenHeight/2)-(Hofwin/2)-18
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

Reloaded:
	Reload
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
	WinMove,ahk_id %TBResized%,,%PermX%,%PermY%,%PermW%,%PermH%
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

Exited:
	for currentWindow, b in Arrs 
	{
		WinSet, AlwaysOnTop, off, ahk_id %currentWindow%
    }
	WinShow, ahk_class Shell_TrayWnd
	WinShow, Start ahk_class Button
ExitApp
