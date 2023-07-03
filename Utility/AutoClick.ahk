#NoTrayIcon
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
SetControlDelay -1
AhkPath = %A_WorkingDir%\AutoHotkey.exe
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
Loop,
{
    WinWait,ahk_class #32770 ahk_exe rundll32.exe
    WinActivate,ahk_class #32770 ahk_exe rundll32.exe
    ControlClick,Button2,ahk_class #32770 ahk_exe rundll32.exe,,,4
}