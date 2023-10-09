
# **TSolidBackground**  

TSolidBackground allows you to immerse in a window completely by creating a solid overlay over the window borders and around the window.  
In a different saying, it tries to mimic fullscreen for any window without resizing it.  

At first, I made TSolidBackground to prevent myself from getting distracted while playing VNs and later added more features that were useful for me.  

**Default Hotkeys:** *(All hotkeys and many more options can be changed in the .ini)*  

    TSolidBackground hotkey: !T (! represents the Alt key on your keyboard. Read the hotkey guide below.)
    Always On Top: !Y
    Center window: !G
    Show/Hide taskbar: !F
    Advanced Options: !U
    Suspend all other hotkeys: !F8
    Default Color: 250000 (hex value without the #)

**✅ If you are planning to use TSolidBackground, you should also read 'Things to Know' below.**  

### [Webm Preview](https://raw.githubusercontent.com/Onurtag/TSolidBackground/gh-pages/Preview/TSolidBackground%20Preview.webm)  
### [Get latest relese*](https://github.com/Onurtag/TSolidBackground/releases)  

*Compiled using the latest Ahk2Exe. The file is not compressed so you can check the source code easily.  

--------------------  
## 🌟 Things To Know  

* If no hotkeys work on the active/selected window, run TSolidBackground as admin.  
If they still don't work try enabling Keyboard Hook on the Advanced Options menu.  

* TSolidBackground.ini file will be created when you create a .ini using the Advanced Options (default **Alt+U** key).  
After creating the .ini file you can edit it using a text editor to change the hotkeys and many more options.  
You can also quickly edit the .ini by using the "Edit TSolidBackground.ini" button in the tray menu.  
**[QUICK HOTKEY EDITING GUIDE.png](https://github.com/Onurtag/TSolidBackground/raw/gh-pages/images/Hotkey%20Guide.png)**  
[Advanced hotkey Guide 1](https://autohotkey.com/docs/Hotkeys.htm), [Guide 2](https://www.autohotkey.com/docs/KeyList.htm)

* If you want to disable a hotkey you can do it by leaving the related variable empty in the TSolidBackground.ini.  

* You have to select the window (make it active) before using most hotkeys.  

* You can change the background color using the Advanced Options menu in the Advanced Features menu (default hotkey: Alt+U).  
You can press the **[R]** button to switch between red and blue.  

* When you are on the Move/Resize Window menu, you can use the Advanced Features (default: Alt+U) hotkey to get a new window to move/resize.  

* If your window doesn't show up on the Move/Resize dropdown menu, you can try editing the excluded windows list using the **Edit** button in the Advanced Options menu.  
When this option is enabled, the TSolidBackground Move/Resize menu dropdown will not list all the windows that don't have a title in addition to all the windows that are listed in the above menu.  

* Always on top mode can be used for multiple windows at the same time.  
Exiting or reloading in any way like using the notification icon menu (right click - exit) will fix your windows if you left them in the always on top mode.  

* Using the TSolidBackground function will disable always on top if the selected window is always on top.  
You can use the always on top hotkey afterwards if you really want the window on top.  

* Experimental window hooking currently works like this:  
After Hooking Main Window(or browser tab) to the Hooked window, the hooked window will stay always on top when that tab/window is currently active. When you change tabs/go to a different window it will minimize and when you go back it will be on top again. You can also stop the window hooker using the tray icon menu.  

* You can use [this script](https://pastebin.com/DdTkfjdM) to make a window transparent or clickthrough.  

--------------------  
**Known Issues:**  

* Hiding taskbar sometimes might not work right away on slow computers, try it again.  
* Explorer.exe might crash and restart if you spam the hotkeys too much (Especially Show Hide taskbar key).  
It might also crash if you try to resize a window smaller than allowed etc.  

If you have any other problems, [open an issue](https://github.com/Onurtag/TSolidBackground/issues). I'll try to fix it.  


## Changelog

***Moved to [Changelog.md](https://github.com/Onurtag/TSolidBackground/blob/master/README.md)***  

## 📦 Included Functions/Libraries

AddTooltip by Various authors  
From https://autohotkey.com/boards/viewtopic.php?&t=30079  

GetMonitorIndexFromWindow() by Shinywong.  
From https://autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355  

GetWindowInfo by "just me"  
From https://autohotkey.com/board/topic/69254-func-api-getwindowinfo-ahk-l/  

StackingPleasantNotify by Onurtag  
A mod of the original PleasantNotify by Soft which was later modded by evilC   
From https://www.autohotkey.com/boards/viewtopic.php?f=6&t=6056#p35696  
