#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Some Predetermined variables, at least until I find another way of doing it
robocopy :="robocopy"
Source :=""
Dest :=""
FileCards :=""
SubDir :=""
RestartMode :=""
CopyAll :=""
Mirror :=""
FileCards :=""

;Everything GUI
;##############################################################

;Shown on all tabs
Gui, Add, GroupBox, x22 y290 w430 h90 , Batch output
Gui, Add, Edit, ReadOnly x32 y305 w410 h70 vOutput, 
Gui, Add, Button, gRunScript x22 y380 w100 h30 , Run Script
;Gui, Add, Button, gTestSomething x240 y319 w100 h30 , Test 
Gui, Add, Button, gGenerateFile x352 y380 w100 h30 , Generate
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
Gui, Add, CheckBox, x42 y149 w130 h30 vCopyAll gCheckboxes , Copy all file information
Gui, Add, CheckBox, x42 y189 w130 h30 vMirror gCheckboxes , Mirror
Gui, Add, GroupBox, x202 y69 w230 h50 , Restart amount
Gui, Add, GroupBox, x202 y129 w230 h50 , Wait amount
Gui, Add, Edit, x212 y149 w210 h20 , 
Gui, Add, Edit, x212 y89 w210 h20 , 
;Output Tab
Gui, Tab, Output
Gui, Add, CheckBox, x32 y219 w100 h40 , Create logfile
Gui, Add, Edit, x142 y229 w290 h20 , 
Gui, Add, GroupBox, x22 y199 w430 h70 , Logging
;Help Tab
Gui, Tab, Help
Gui, Add, GroupBox, x22 y39 w430 h230 , About
Gui, Add, Link, x32 y59, Check the <a href="https://github.com/Pyrree/Robocopy-generator">GitHub page</a>
;Other
Gui, Show, w479 h430, Robocopy Generator v0.2.2
OnMessage(0x200, "Help")
return

Help(wParam, lParam, Msg) {

MouseGetPos,,,, CheckboxHelperVar

If CheckboxHelperVar = Button8
{
	Help := "This is subdirs"
}

If CheckboxHelperVar = Button9
{
	Help := "This is Restartable mode"
}

If CheckboxHelperVar = Button10
{
	Help := "Copy all file information"
}

If CheckboxHelperVar = Button11
{
	Help := "Mirror folders"
}

ToolTip % Help

}

GuiClose:
ExitApp

;All functions and buttons
;##############################################################

Source:
GuiControlGet, Source
GuiControl,, Output, %robocopy% %Source% %Dest% %SubDir%%RestartMode%%CopyAll%%Mirror%`r`n
return

Dest:
GuiControlGet, Dest
GuiControl,, Output, %robocopy% %Source% %Dest% %SubDir%%RestartMode%%CopyAll%%Mirror%`r`n
return

FileCards:
GuiControlGet, FileCards
return

Checkboxes:
;Gui, Submit, NoHide
GuiControlGet, SubDir
GuiControlGet, RestartMode
GuiControlGet, CopyAll
GuiControlGet, Mirror

if SubDir = 1
	SubDir :=" /S"
if Subdir = 0
	SubDir :=""

if RestartMode = 1
	RestartMode :=" /ZB"
if RestartMode = 0
	RestartMode :=""

if CopyAll = 1
	CopyAll :=" /COPYALL"
if CopyAll = 0
	CopyAll :=""

if Mirror = 1
	Mirror :=" /MIR"
if Mirror = 0
	Mirror :=""

GuiControl,, Output, %robocopy% %Source% %Dest% %SubDir%%RestartMode%%CopyAll%%Mirror%`r`n
return



;Run and Generate batch file
;##############################################################

RunScript:
if FileExist(A_ScriptDir "\batch-temp.bat")
	FileDelete, %A_ScriptDir%\Batch-temp.bat

FileAppend,
(
robocopy %Source% %Dest% %FileCards%%SubDir%%RestartMode%%CopyAll%%Mirror%

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
robocopy %Source% %Dest% %FileCards%%SubDir%%RestartMode%%CopyAll%%Mirror%

pause
exit
), %A_ScriptDir%\Batch-temp.bat

msgbox, 0, Done!,
(
Successfully generated file "Batch-temp.bat".

Location:
%A_ScriptDir%\Batch-temp.bat
)
return

;Robocopy C:\temp C:\Test \s \zb \copyall \mir \unilog<Logfile> \r: \w:
