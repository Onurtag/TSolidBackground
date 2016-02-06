# **TSolidBackground**  

TSolidBackground allows you to immerse in a window completely by creating a solid background and hiding window borders.  
In a different saying, it tries to mimic fullscreen for any window without resizing it.  

At first I made TSolidBackground to stop distracting myself when playing VNs and Eroge 
and later added more features that were useful for me.

    Default Hotkeys & Options (can be changed in the .ini):  
    TSolidBackground hotkey: Shift+T
    Always On Top: Shift+Y
    Center window: Shift+G
    Show/Hide taskbar: Shift+F
    Advanced Ooptions: Shift+U
    Suspend all other hotkeys: F8
    Default Color: 051523 (hex)
	Custom rectangle width left: 0
	Custom rectangle width right: 0
	Custom rectangle height top: 0
	Custom rectangle height bottom: 0
	Enable Startup Window: 1

###[Webm Preview (v2)](https://raw.githubusercontent.com/Onurtag/TSolidBackground/gh-pages/Preview/TSolidBackground%20Preview.webm)
###[Get latest relese*](https://github.com/Onurtag/TSolidBackground/releases)  

*Compiled using latest Ahk2Exe  


**Current Version 2.4.0**  

Finally got my hands on a second monitor and now everything works in multiple monitors.
Added an [O] button to +U for moving to original position.
Added U,D,L,R buttons to easily move windows.
	
*Do not forget to generate a new TSolidBackground.ini if you are updating.*  

--------------------  
## Things To Know  

* You have to select the window before using most hotkeys.
* You can change the background color using the Shift+U option window.
Change the color to a red hue if you want a softer experience.
* TSolidBackground.ini file will be created when you create a .ini using the Advanced Options.
After creating the .ini file you can open it using a text editor to change the hotkeys.  
[HOTKEY EDITING GUIDE](http://www.autohotkey.com/docs/Hotkeys.htm)  
* Always on top mode can be used for multiple windows at the same time  
Exiting or reloading using the notification icon (right click - exit) will fix your windows if you left them in always on top mode.  
* TSolidBackground function will disable always on top if the selected window is always on top.  
You can use the always on top hotkey afterwards if you really want the window on top. 

--------------------  
**Known Bugs:**  

* Hiding taskbar might not work right away, try it again.  
* Explorer.exe might crash and restart if you spam the hotkeys too much. (Especially Show Hide taskbar key)  

If you have any other problems, let me know. I'll try to fix it.  


--------------------  
##Old Updates (DD.MM.YY)  

*Do not forget to generate a new TSolidBackground.ini if you are updating.* 

* **Version 2.3.0:**  

Removed old options, moved to (+U)  
Added .ini option to disable startup window.  
Seperated custom width and height, made new temprorary options in (+U).  

* **Version 2.2.2:**  

Added custom sizing option to the .ini and did some other stuff too.

* **Version 2.2.1:**  

Removed useless stuff and added useful stuff.


* **Version 2.2.0:**  

Added features to Move/Resize (Shift+U)


* **Version 2.1.4:**  

Added window client area to resizer


* **Version 2.1.3:**  

Removed useless info.  
Now less casual.  


* **Version 2.1.2:**  

Added resize window function.


* **Version 2.1.1:**  

Fixed bug when using with VNR.


* **Version 2.1:**  

Taskbar hide revamp.  
Added notes to start popup  
Fixed huge bugs.  
New dark color scheme.  


* **Version 2:**  

TSolidBackground revamp, now the window borders are gone too! (Thanks biggest_decision for the heads up.)  
Added show/hide taskbar key, removed the command that was included in TSolidBackground key.  
This is probably the final version unless I go bug hunting or get a new feature request.  


* **Version 1.1:**  

Fixed timing issues with slower PC.  
Fixed the bug where the window sometimes went background when using TSolidBackground  
Added tray menu: Reload, About  
Added opening popup with hotkey information.  
Added Suspend hotkeys and Center window functions
