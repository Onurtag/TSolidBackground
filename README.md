# **TSolidBackground**  

TSolidBackground allows you to immerse in a window completely by creating a solid background and hiding window borders.  
In a different saying, it tries to mimic fullscreen for any window without resizing it.  

At first I made TSolidBackground to stop distracting myself when playing VNs and Eroge 
and later added more features that are useful for me.  

**Default Hotkeys:** (All hotkeys and many more options can be changed in the .ini)  

    TSolidBackground hotkey: +T (NOTE: [+] means Shift. Read the hotkey guide below if you want to customize it.)
    Always On Top: +Y
    Center window: +G
    Show/Hide taskbar: +F
    Advanced Options: +U
    Suspend all other hotkeys: F8
    Default Color: 051523 (hex value without the #)

**If you are planning to use TSolidBackground, you should also read 'Things to Know' below.**  

### [Webm Preview](https://raw.githubusercontent.com/Onurtag/TSolidBackground/gh-pages/Preview/TSolidBackground%20Preview.webm)  
### [Get latest relese*](https://github.com/Onurtag/TSolidBackground/releases)  

*Compiled using latest Ahk2Exe. The exe is not compressed so you can check the source code easily.  

--------------------  
## Things To Know  

* If no hotkeys work on the active/selected window, run TSolidBackground as admin.  

* TSolidBackground.ini file will be created when you create a .ini using the Advanced Options (default Shift+U key).  
After creating the .ini file you can edit it using a text editor to change the hotkeys and many more options.  
You can also quickly edit the .ini by using the "Edit TSolidBackground.ini" button in the tray menu.  
**[QUICK HOTKEY EDITING GUIDE.png](https://github.com/Onurtag/TSolidBackground/raw/gh-pages/images/Hotkey%20Guide.png)**  
[Advanced hotkey Guide 1](https://autohotkey.com/docs/Hotkeys.htm), [Guide 2](https://www.autohotkey.com/docs/KeyList.htm)

* If you want to disable a hotkey you can do it by leaving the related variable empty in the TSolidBackground.ini.  

* You have to select the window (make it active) before using most hotkeys.  

* You can change the background color using the Advanced Options menu in Advanced Features menu (default hotkey: Shift+U).  
Change the color to a red hue if you want a softer experience (it seems red encourages sleep and blue does the opposite). Press that [R] near the color to switch between red and blue.  

* When you are on the Move/Resize Window menu you can use the Advanced Features (default: Shift+U) hotkey to get a new window to move/resize.  

* If your window doesn't show up on the Move/Resize dropdown menu, you can try disabling the "Exclude system windows etc. from Move/Resize dropdown menu." option in the advanced options menu.  
When this option is enabled, TSolidBackground doesn't list untitled windows and some other invisible system windows on the Move/Resize dropdown menu.

* Always on top mode can be used for multiple windows at the same time.  
Exiting or reloading using the notification icon (right click - exit) will fix your windows if you left them in always on top mode.  

* Using the TSolidBackground function will disable always on top if the selected window is always on top.  
You can use the always on top hotkey afterwards if you really want the window on top.  

* Experimental window hooking currently works like this:  
After Hooking Main Window(or browser tab) to the Hooked window, the hooked window will stay always on top when that tab/window is currently active. When you change tabs/go to a different window it will minimize and when you go back it will be on top again. You can also stop the window hooker using the tray icon menu.  


--------------------  
**Known Issues:**  

* Hiding taskbar sometimes might not work right away on slow computers, try it again.  
* Explorer.exe might crash and restart if you spam the hotkeys too much (Especially Show Hide taskbar key).  
It might also crash if you try to resize a window smaller than allowed etc.  

If you have any other problems, [open an issue](https://github.com/Onurtag/TSolidBackground/issues). I'll try to fix it.  


--------------------  
## Changelog

* **Version 2.8.7**  

Added a menu to customize excluded titles.  
Added a C (Copy Window Title) button to move/resize menu to help with above.  
Added middle click to mouse mover.  

* **Version 2.8.6**  

Added more Numeric UpDowns so we can all use our scroll wheels.  
Added Minimize/Restore Window, Maximize Window and Close Window buttons to the Move/Resize menu.  
Added various tooltips using the AddToolTip library.  
Better VNR (Kagami) protection.

* **Version 2.8.5**  

Corrected a mistake.

* **Version 2.8.4**  

Can now exclude system windows & untitled windows from the move/resize dropdown menu. Enabled by default.  
Tiny bug fix.  

* **Version 2.8.3**  

Added clicks to mouse mover.  
Bug fixes.  

* **Version 2.8.2**  

Added mouse mover using keyboard.

* **Version 2.8.1**  

Various bug fixes. (Centering, Multimonitor stuff)

* **Version 2.8.0**  

Full Automatic updater added.  
Ini versions added for easier ini version control. Inis will now last longer.  

* **Version 2.7.2**  

Fixes for the new resize/move selector.  
Esc now goes back to the main menu.  
Named the 4 TSB hidden windows so you can move/resize them using the new resize/move selector.   
Better cheating capabilities.  

* **Version 2.7.1**  

Experimental speed improvements.  
Added a dropdown window selector to resizer menu as an alternative way to select windows. (Thanking xThorpyx for the inspiration)


* **Version 2.7.0**  

Added a way to check for updates in the advanced options menu.  
Added a way to auto check for updates. Make a new .ini and you will see the dialog.  
Added a way to disable a hotkey by leaving the variable empty in the .ini.  
Fixed overlapping checkboxes.  
There are **TSolidBackground.ini changes** in this update. You should delete yours and make a new one.  


* **Version 2.6.4**  

Edit TSolidBackground.ini tray menu button.  
Back button in advanced menus.

* **Version 2.6.3**  

New 3 Permanent custom TSolidBackground size settings.


* **Version 2.6.2**  

Added Debug variable to ini. Setting it to 1 will activate F11 Debug variables hotkey.  
Put some more work into the window hooker (currently Beta).  


* **Version 2.6.0**  

Moving buttons added to advanced move menu.  
"Make a Dummy Window for TSolidBackground" added. Use this to get a custom sized TSolidBackground.  
Ver. 2.6.1: Save dummy to .ini.


* **Version 2.5.1**  

Some cleanup.
Added a different icon for the "Suspended" state (Compiled .exe only). 


* **Version 2.5.0**  

Changed UI fonts to Segoe UI.  
Revamp of Advanced Features (default Shift+U hotkey)  
Added Experimental Window hooking to advanced features (+U).  
*Window hooking currently works like this: After Hooking Main Window(or browser tab) to the Hooked window, the hooked window will stay always on top. When you change tabs/go to a different window it will minimize and when you go back it will be on top again. You can also stop the window hooker using the tray icon menu.* 

* **Version 2.4.4**  

Protect VNR checkbox
	
	
* **Version 2.4.3**  

Fix custom hotkey not changing.
Cleanup useless code

* **Version 2.4.1:**  

Can now save size + position in +U options menu.  
Added reset button for custom TSb.  


* **Version 2.4.0:**  

Finally got my hands on a second monitor and now everything works in multiple monitors.  
Added an [O] button to +U for moving to original position.  
Added U,D,L,R buttons to easily move windows.  

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


* **Version 2.0:**  

TSolidBackground revamp, now the window borders are gone too! (Thanking biggest_decision for the heads up.)  
Added show/hide taskbar key, removed the command that was included in TSolidBackground key.  
This is probably the final version unless I go bug hunting or get a new feature request.  


* **Version 1.1:**  

Fixed timing issues with slower PC.  
Fixed the bug where the window sometimes went background when using TSolidBackground  
Added tray menu: Reload, About  
Added opening popup with hotkey information.  
Added Suspend hotkeys and Center window functions
