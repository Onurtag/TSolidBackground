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
Version := "v2.3.0"
TSolidBackgroundKey := "+T"
OnTopKey := "+Y"
CenterKey := "+G"
TaskbarKey := "+F"
OptionsKey := "+U"
SuspendKey := "F8"
CustomWidthLeft := 0
CustomWidthRight := 0
CustomHeightTop := 0
CustomHeightBottom := 0
StartupWindow := 1

Menu, Tray, Icon,,, 1
Menu, Tray, NoStandard
Menu, Tray, Add, About TSolidBackground, Abouted
Menu, Tray, Add, Reload, Reloaded
Menu, Tray, Add, Exit, Exited
Menu, Tray, Tip, TSolidBackground

IfExist, TSolidBackground.ini
{
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
}
    if(StartupWindow)
	{
		Gui, start: Color, 292929
		Gui, start: Font, s14 c836DFF bold
		Gui, start: Add, Text,, TSolidBackground %Version%
		Gui, start: Font, s8 c836DFF bold
		Gui, start: Font, s10 cDCDCCC norm
		Gui, start: Add, Text, x18 y42, Current Hotkeys: `n------------------------`nTSolidBackground: %TSolidBackgroundKey% `nAlways On Top: %OnTopKey% `nShow Hide Taskbar: %TaskbarKey% `nCenter Window: %CenterKey% `nAdvanced Options: %OptionsKey% `nSuspend other hotkeys: %SuspendKey%`n------------------------ `nOn AutoHotkey [+] means [Shift]. `nIf no hotkeys work on selected window, run TSolidBackground as admin.`n`nIf you can't understand anything above, `nor just want to check for updates visit the project page: 
		Gui, start: Font, s10 c3257BF underline
		Gui, start: Add, Text, x18 y272 gGotoSite, https://onurtag.github.io/TSolidBackground/
		Gui, start: Font, s10 cBlack norm
		Gui, start: Add, Button, x243 y302 w64 h36 , Ok
		Gui, start: Show, w550 h351, Start TSolidBackground
	}
Return

+Y::
	WinGet, currentWindow, ID, A
	WinGetTitle, currentTitle, A
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
    WinMove, A,, (A_ScreenWidth/2)-(WWWidth/2), (A_ScreenHeight/2)-(HHHeight/2)-18		;For new Win10 borders.
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
		Drawhud("Got a new window to move/resize.","y310")
		TBResized := WinExist("A")
		WinGetPos,X,Y,W,H,ahk_id %TBResized%
		Worig := W
		Horig := H
		Xorig := X
		Yorig := Y
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
	Gui, resize: Add,Text,x350 y15 h13,Move Window
	Gui, resize: Add,Text,x590 y15 h13,TSolidBackground
	Gui, resize: Color, 292929
	Gui, resize: Font, s10 cDCDCCC norm
	Gui, resize: Add,Button,x230 y193 w50 h18 gResizenow,Resize
	Gui, resize: Add,Button,x470 y193 w50 h18 gMovenow,Move
	Gui, resize: Add,Button,x390 y95 w60 h18 gHcenter,H-Center
	Gui, resize: Add,Button,x390 y117 w60 h18 gVcenter,V-Center
	Gui, resize: Add,Button,x713 y137 w68 h18 gSetnow,Set CWH
	Gui, resize: Add,Button,x713 y207 w68 h18 gSetcolor,Set Color
	Gui, resize: Add,Button,x378 y274 w90 h28 gCreateini,Make/Edit .ini
	Gui, resize: Add,Button,x789 y183 w14 h18 gResetcolor,R
	Gui, resize: Add,Text,x60 y55 h13,Current:
	Gui, resize: Add,Text,x60 y75 h13,Original:
	Gui, resize: Add,Text,x60 y95 h13,Client area:
	;Gui, resize: Add,Text,x60 y130 h13,HD Client:
	Gui, resize: Add,Text,x60 y184,New Width:
	Gui, resize: Add,Text,x60 y204,New Height:
	Gui, resize: Add,Text,x325 y55 h13,Current:
	Gui, resize: Add,Text,x325 y75 h13,Original:
	Gui, resize: Add,Text,x325 y184,New X:
	Gui, resize: Add,Text,x325 y204,New Y:
	Gui, resize: Add,Text,x325 y95,Center:
	Gui, resize: Add,Text,x560 y55 h13,CustomWidthLeft:
	Gui, resize: Add,Text,x560 y75 h13,CustomWidthRight:
	Gui, resize: Add,Text,x560 y95 h13,CustomHeightTop:
	Gui, resize: Add,Text,x560 y115 h13,CustomHeightBottom:
	Gui, resize: Add,Text,x560 y184,New Color:
	Gui, resize: Font, s10 cb396ff norm
	Wofwin := 0000	;Ahk gui bug temp fix.
	Hofwin := 0000 
	Xofwin := 0000 
	Yofwin := 0000
	Gui, resize: Add,Text,x150 y55 h13 vCurrentWH,W: %Wofwin%,  H: %Hofwin%
	Gui, resize: Add,Text,x390 y55 h13 vCurrentXY,X: %Xofwin%,  Y: %Yofwin%
	Gui, resize: Font, s10 c836DFF norm
	Gui, resize: Add,Text,x150 y95 h13,W: %Wclient%,  H: %Hclient%
	Gui, resize: Add,Text,x150 y75 h13,W: %Worig%,  H: %Horig%
	Gui, resize: Add,Text,x390 y75 h13,X: %Xorig%,  Y: %Yorig%
	;editdefH := Round(1280/(Wclient/Hclient)) + 2*Border_Size2 + Caption_Size
	;editdefW := 1280 + 2*Border_Size
	;Gui, resize: Add,Text,x150 y130 h13,W: %editdefW%,  H: %editdefH%
	Gui, resize: Font, s10 c836DFF bold
	Gui, resize: Add,Edit,x150 y183 w70 h19 vWnew,%Worig%
	Gui, resize: Add,Edit,x150 y203 w70 h19 vHnew,%Horig%
	Gui, resize: Add,Edit,x390 y183 w70 h19 vXnew,%Xorig%
	Gui, resize: Add,Edit,x390 y203 w70 h19 vYnew,%Yorig%
	Gui, resize: Add,Edit,x712 y53 w70 h19 vCustomWidthLeft,%CustomWidthLeft%
	Gui, resize: Add,Edit,x712 y73 w70 h19 vCustomWidthRight,%CustomWidthRight%
	Gui, resize: Add,Edit,x712 y93 w70 h19 vCustomHeightTop,%CustomHeightTop%
	Gui, resize: Add,Edit,x712 y113 w70 h19 vCustomHeightBottom,%CustomHeightBottom%
	Gui, resize: Add,Edit,x635 y183 w70 h19 vbgcolor,%bgcolor%
	Gui, resize: Add,Progress,x712 y183 w70 h19 c%bgcolor% Background%bgcolor% vbarcolored, 100
	Gui, resize: Add,Button,x125 y320 w600 h22,Close
	Gui, resize: Font, Underline
	Gui, resize: Add,Text,x314 y248,Create .ini for permanent options
	Gui, resize: Show,w850 h357, Resize / Move and Custom Sizes
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
	Gui, about: Color, 292929
	Gui, about: Font, s14 c836DFF
	Gui, about: Add, Text,, TSolidBackground %Version%
	Gui, about: Font, s10 cDCDCCC
	Gui, about: Add, Text,, `nFor readme, updates and more check out the project page:  
	Gui, about: Font, s10 c3257BF underline
	Gui, about: Add, Text, gGotoSite, https://onurtag.github.io/TSolidBackground/
	Gui, about: Font, s10 cBlack norm
	Gui, about: Add, Button, x168 y170 w64 h36 , Ok
	Gui, about: Show, h225 w400, About TSolidBackground
Return


TSolidBackground()
{
	Global
	WinGetPos, wX, wY, WWidth, HHeight, ahk_id %Activewin%
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
	
	bg3H := A_ScreenHeight-bg3SY
	bg4W := A_ScreenWidth-bg4SX
	
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
	Gui, bg3: Show, NoActivate x0 y%bg3SY% h%bg3H% w%A_ScreenWidth%, TSolidBackground
	Gui, bg2: Show, NoActivate x0 y0 h%A_ScreenHeight% w%bg2FX%, TSolidBackground
	Gui, bg4: Show, NoActivate x%bg4SX% y0 h%A_ScreenHeight% w%bg4W%, TSolidBackground
	Gui, bg1: Show, NoActivate x0 y0 h%bg1FY% w%A_ScreenWidth%, TSolidBackground
	Return
}

Drawhud(Hudtext,xyvalue)
{
	Gui, hud: +AlwaysOnTop -Caption +Border +ToolWindow
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
	GuiControl, resize:,Wnew,%Worig%
	GuiControl, resize:,Hnew,%Horig%
	GuiControl, resize:,Xnew,%Xorig%
	GuiControl, resize:,Ynew,%Yorig%
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

Setcolor:
	Gui, Submit, NoHide
	RefresherEdit()
Return

Resetcolor:
	GuiControl, resize:,bgcolor,051523
	Gui, Submit, NoHide
	RefresherEdit()
Return

Createini:	
	Gui, Submit, NoHide
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
	Reload
Return

Vcenter:
	WinMove,ahk_id %TBResized%,,,(A_ScreenHeight/2)-(Hofwin/2)-12
	RefresherEdit()
Return

Hcenter:
	WinMove,ahk_id %TBResized%,,(A_ScreenWidth/2)-(Wofwin/2),
	RefresherEdit()
Return

Reloaded:
	Reload
Return

Exited:
	for currentWindow, b in Arrs 
	{
		WinSet, AlwaysOnTop, off, ahk_id %currentWindow%
    }
	WinShow, ahk_class Shell_TrayWnd
	WinShow, Start ahk_class Button
ExitApp
