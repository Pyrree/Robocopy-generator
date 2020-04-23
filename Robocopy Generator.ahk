#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


SubDir :=8

;Everything GUI
;##############################################################

;Shown on all tabs
Gui, Add, Button, gRunScript x22 y319 w100 h30 , Run Script
Gui, Add, Button, gTestSomething x240 y319 w100 h30 , Test
Gui, Add, Button, gGenerateFile x352 y319 w100 h30 , Generate
;Tabs Properties
Gui, Add, Tab2, x12 y9 w450 h280 , Path|Options|Output|Help
;Path tab
Gui, Add, GroupBox, x22 y39 w430 h50 , Source
Gui, Add, Edit, x32 y59 w410 h20 vSource gSource 
Gui, Add, GroupBox, x22 y99 w430 h50 , Destination
Gui, Add, GroupBox, x22 y159 w430 h50 , File(s) and Wildcard(s)
Gui, Add, Edit, x32 y119 w410 h20 vDest gDest 
Gui, Add, Edit, x32 y179 w410 h20 vFileCards gFileCards, 
;Options Tab
Gui, Tab, Options
Gui, Add, GroupBox, x32 y49 w150 h180 , Group 1
Gui, Add, GroupBox, x192 y49 w250 h140 , Group 2
Gui, Add, CheckBox, x42 y69 w130 h30 vSubDir gCheckboxes , Subdirectories
Gui, Add, CheckBox, x42 y109 w130 h30 vRestartMode gCheckboxes , Restartable mode
Gui, Add, CheckBox, x42 y149 w130 h30 , Copy all file information
Gui, Add, CheckBox, x42 y189 w130 h30 , Mirror
Gui, Add, GroupBox, x202 y69 w230 h50 , Restart amount
Gui, Add, GroupBox, x202 y129 w230 h50 , Wait amount
Gui, Add, Edit, x212 y149 w210 h20 , 
Gui, Add, Edit, x212 y89 w210 h20 , 
;Output Tab
Gui, Tab, Output
Gui, Add, CheckBox, x32 y219 w100 h40 , Create logfile
Gui, Add, Edit, x142 y229 w290 h20 , 
Gui, Add, GroupBox, x22 y199 w420 h70 , Logging
;Help Tab
Gui, Tab, Help
Gui, Add, GroupBox, x22 y39 w430 h230 , About
;Gui, Add, Text, x24 y41 w420 h220 , About
;Other
Gui, Show, w479 h379, Robocopy Generator v0.0.1
return

GuiClose:
ExitApp

;All functions and buttons
;##############################################################

Source:
Gui, Submit, NoHide		; <- GuiControlGet would work here too
NewVarSource := Source 
GuiControl,, NewVarSource, %NewVarSource%
return

Dest:
Gui, Submit, NoHide
NewVarDest := Dest 
GuiControl,, NewVarDest, %NewVarDest%
return

FileCards:
Gui, Submit, NoHide
NewVarFileCards := FileCards 
GuiControl,, NewVarFileCards, %NewVarFileCards%
return

Checkboxes:
Gui, Submit, NoHide
if SubDir = 1
	SubDir :="/S"
if Subdir = 0
	SubDir :=""
if RestartMode = 1
	RestartMode :="/ZB"
if RestartMode = 0
	RestartMode :=""
return

TestSomething:
MsgBox ("Subdir=%SubDir% Restartablemode=%RestartMode%")
Return

;Run and Generate batch file
;##############################################################

RunScript:
if FileExist(A_ScriptDir "\batch-temp.bat")
	FileDelete, %A_ScriptDir%\Batch-temp.bat

FileAppend,
(
robocopy %Source% %Dest% %FileCards% %SubDir%

pause
exit
), %A_ScriptDir%\Batch-temp.bat

Sleep, 200

run, %A_ScriptDir%\Batch-temp.bat
return

GenerateFile:
if FileExist(A_ScriptDir "\batch-temp.bat")
	FileDelete, %A_ScriptDir%\Batch-temp.bat

FileAppend,
(
robocopy %Source% %Dest% %FileCards% %SubDir% %RestartMode%

pause
exit
), %A_ScriptDir%\Batch-temp.bat
return

;Robocopy C:\temp C:\Test \s \zb \copyall \mir \unilog<Logfile> \r: \w:
