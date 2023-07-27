; 
;   NvFBC patch Installer 1.2 (27-07-2023)
;   Author: alanfox2000
;
#NoTrayIcon
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
FileEncoding, UTF-8-RAW

Title = NvFBC Patcher Installer
display_dir = %A_WorkingDir%\Display.Driver
display_nvi = %display_dir%\DisplayDriver.nvi
fbcwrp_dir = %A_WorkingDir%\NvFBC
fbc_ = %display_dir%\nvfbc_.dll
fbc64_ = %display_dir%\nvfbc64_.dll

if (A_Is64bitOS) {
    if (FileExist(fbc_) && FileExist(fbc64_)) {
        MsgBox, 0x2030, %Title%, Already patched!`rMake sure to tick the NVFBCEnable checkbox.
		ExitApp
    }
}
else {
    if (FileExist(fbc_)) {
        MsgBox, 0x2030, %Title%, Already patched!`rMake sure to tick the NVFBCEnable checkbox.
		ExitApp
    }
}

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
content =
(
NvFBC64_.dll,,,0x00004000
)
content2 =
(
NvFBC_.dll,,,0x00004000
)
SplashTextOn,,, Please wait...
FileRead, NVI_DisplayDriver, %NVI%
NVI_DisplayDriver2 := RegExReplace(NVI_DisplayDriver, "<file name(.*)nvfbc64.dll(.*)>", "<file name=""nvfbc64.dll""/>`r`n`t`t<file name=""nvfbc64_.dll""/>")
NVI_DisplayDriver3 := RegExReplace(NVI_DisplayDriver2, "<file name(.*)nvfbc.dll(.*)>", "<file name=""nvfbc.dll""/>`r`n`t`t<file name=""nvfbc_.dll""/>")
FileDelete, %NVI%
FileAppend, %NVI_DisplayDriver3%, %NVI%, UTF-8-RAW
if (A_Is64bitOS) {
FileMove, %display_dir%\nvfbc64.dll, %fbc64_%
FileMove, %display_dir%\nvfbc.dll, %fbc_%
FileMove, %fbcwrp_dir%\nvfbcwrp64.dll, %display_dir%\nvfbc64.dll 
FileMove, %fbcwrp_dir%\nvfbcwrp32.dll, %display_dir%\nvfbc.dll 
}
else {
FileMove, %display_dir%\nvfbc.dll, %fbc_%
FileMove, %fbcwrp_dir%\nvfbcwrp32.dll, %display_dir%\nvfbc.dll 
}
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
MsgBox, 0x2020, %Title%, NvFBC patch have been applied to the installation files.`r`rTo undo changes`, delete the extracted driver folder then extract from the driver package again. Make sure to tick the NVFBCEnable checkbox.
Return