; 
;   NvFBC patch Installer 1.0 (27-07-2020)
;   Author: alanfox2000
;
#NoTrayIcon
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
FileEncoding, UTF-8-RAW

DD = %A_WorkingDir%\Display.Driver
NVI = %DD%\DisplayDriver.nvi
NvFBC = %A_WorkingDir%\NvFBC
64dl_ = %DD%\nvfbc64.dl_
dl_ = %DD%\nvfbc.dl_
content =
(
NvFBC64_.dll,,,0x00004000
)
content2 =
(
NvFBC_.dll,,,0x00004000
)
Title = NvFBC Patcher Installer
Ask =
(
NvFBC patch (wrapper) allows to use NvFBC on consumer-grade GPUs.

Do you want to apply NvFBC patch on installation files?
)

MsgBox, 0x2024, %Title%, %Ask%
IfMsgBox, No
    ExitApp
IfMsgBox, Yes
{
    gosub Patch
    ExitApp
}

Patch:
SplashTextOn,,, Please wait...
if FileExist(64dl_) and FileExist(dl_)
{
    Runwait, %ComSpec% /c "expand "%64dl_%" "%DD%\nvfbc64_.dll"",, Hide
    Runwait, %ComSpec% /c "expand "%dl_%" "%DD%\nvfbc_.dll"",, Hide
    FileDelete, %64dl_%
    FileDelete, %dl_%
}
FileRead, NVI_DisplayDriver, %NVI%
NVI_DisplayDriver2 := RegExReplace(NVI_DisplayDriver, "<file name(.*)nvfbc64.dl_(.*)>", "<file name=""nvfbc64.dll""/>`r`n`t`t<file name=""nvfbc64_.dll""/>")
NVI_DisplayDriver3 := RegExReplace(NVI_DisplayDriver2, "<file name(.*)nvfbc.dl_(.*)>", "<file name=""nvfbc.dll""/>`r`n`t`t<file name=""nvfbc_.dll""/>")
FileDelete, %NVI%
FileAppend, %NVI_DisplayDriver3%, %NVI%, UTF-8-RAW
FileCopy, %NvFBC%\nvfbcwrp64.dll, %DD%\nvfbc64.dll, 1
FileCopy, %NvFBC%\nvfbcwrp32.dll, %DD%\nvfbc.dll, 1
Loop, Files, %DD%\*.inf, F
{
    iniwrite, 1, %A_LoopFileFullPath%, SourceDisksFiles, NvFBC64_.dll
    iniwrite, 1, %A_LoopFileFullPath%, SourceDisksFiles, NvFBC_.dll
    iniread, SectionNames, %A_LoopFileFullPath%
    Loop, Parse, SectionNames,`n
    {
        thissection := A_LoopField
        if thissection contains nv_system32_copyfiles
        {
            iniread, copyfilessection_content, %A_LoopFileFullPath%, %thissection%
            if copyfilessection_content not contains NvFBC64_.dll
            {
                iniwrite, %content%, %A_LoopFileFullPath%, %thissection%
            }
        }
        if thissection contains nv_syswow64_copyfiles
        {
            iniread, copyfilessection_content, %A_LoopFileFullPath%, %thissection%
            if copyfilessection_content not contains NvFBC_.dll
            {
                iniwrite, %content2%, %A_LoopFileFullPath%, %thissection%
            }
        }
    }

}
SplashTextOff
MsgBox, 0x2020, %Title%, NvFBC patch have been applied on installation files.`r`rTo undo changes`, delete the extracted driver folder then extract from the driver package again.
Return