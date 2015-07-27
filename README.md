# **TSolidBackground**  
------------------  

TSolidBackground allows you to immerse in a window completely by creating a solid background and hiding window borders. 
In a different saying, it mimics fullscreen for any window.  

Reading Visual Novels more comfortably was why I created this but it can also be used in a lot more ways.  


    Default Hotkeys (can be changed in .ini):  
    Shift+T: TSolidBackground key
    Shift+Y: Make window always on top  
    Shift+G: Center Window  
    Shift+U Arrow: Resize Window   
    Shift+F: Show/Hide taskbar
    F8: Suspend Hotkeys  
    Shift+O: Options  
    Default Color: 250000  
	
*Don't forget to delete your TSolidBackground.ini and let it make a new one if you want to change the keybind of a newly added feature.*  


##[Webm Preview (NEW v2)](http://a.1339.cf/jpqrbo.webm)  


##[Download latest .exe here](https://bitbucket.org/Onurtag/tsolidbackground/downloads)  

Compiled using latest Ahk2Exe  


**Current Version 2.1.4 (27.07.15):**  

Added window client area to resizer


--------------------  
## Things To Know  

* You have to select the window before using most hotkeys.  

* You can change the background color using the Shift+O option window.  

* TSolidBackground.ini file will be created when you use the options key (you don't have to enter an input).  
    After creating the .ini file you can open it using a text editor to change the hotkeys.  
    [HOTKEY EDITING GUIDE](http://www.autohotkey.com/docs/Hotkeys.htm)  

* If you never use the options key it will never create the .ini file so you can just carry around the .exe (or the ahk)  

* Exiting using the notification icon (right click - exit) will fix your windows if you left them in "Always On Top" mode.  
    
* Always On Top mode can be used for multiple windows at the same time  


--------------------  
**Known Bugs:**  

* TSolidBackground will disable Always On Top if the selected window is Always On Top.  
You can use the Always On Top hotkey afterwards if you really want the window on top.  

* Hiding taskbar sometimes might not work right away, try it again.  


* Explorer.exe might crash and restart if you spam the hotkeys too much. (Especially Show Hide taskbar key)  


* Currently TSolidBackground only works on the Primary Monitor. (for multiple monitor displays)  

If you have any problems, let me know. I'll try to fix it.  


--------------------  
##Updates (DD.MM.YY)  

Don't forget to delete your TSolidBackground.ini and let it create again if you want to change the keybind of a newly added feature.


**Current Version 2.1.4 (27.07.15):**  

Added window client area to resizer


**Current Version 2.1.3 (27.07.15):**  

Removed useless info.  
Now less casual.  


**Version 2.1.2 (26.07.15):**  

Added resize window function.


**Version 2.1.1 (05.04.15):**  

Fixed bug when using with VNR.


**Version 2.1 (29.03.15):**  

Taskbar hide revamp. Let me know if you encounter a bug.  
Added notes to start popup  
Fixed huge bugs.  
New dark color scheme.  


**Version 2 (29.03.15):**  

TSolidBackground revamp, now the window borders are gone too! (Thanks biggest_decision for the heads up.)  
Added show/hide taskbar key, removed the command that was included in TSolidBackground key.  
This is probably the final version unless I go bug hunting or get a new feature request.  


**Version 1.1 (22.03.15):**  

Fixed timing issues with slower PC.  
Fixed the bug where the window sometimes went background when using TSolidBackground  
Added tray menu: Reload, About  
Added opening popup with hotkey information.  
Added Suspend hotkeys and Center window functions