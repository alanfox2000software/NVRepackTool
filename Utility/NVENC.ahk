; 
;   NVENC Patch Installer 1.0 (27-07-2020)
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
NVENC = %A_WorkingDir%\NVENC

Title = NVENC Patcher Installer
Ask =
(
NVENC patch removes restriction on maximum number of simultaneous NVENC video encoding sessions imposed by Nvidia to consumer-grade GPUs.

Do you want to apply NVENC patch on installation files?
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
FileRead, NVI_DisplayDriver, %NVI%
NVI_DisplayDriver2 := RegExReplace(NVI_DisplayDriver, "<file name(.*)nvencodeapi64.dl_(.*)>", "<file name=""nvencodeapi64.dll""/>")
NVI_DisplayDriver3 := RegExReplace(NVI_DisplayDriver2, "<file name(.*)nvencodeapi.dl_(.*)>", "<file name=""nvencodeapi.dll""/>")
FileDelete, %NVI%
FileAppend, %NVI_DisplayDriver3%, %NVI%, UTF-8-RAW
FileDelete, %DD%\nvencodeapi64.dl_
FileDelete, %DD%\nvencodeapi.dl_
FileCopy, %NVENC%\nvencodeapi64.dll, %DD%, 1
FileCopy, %NVENC%\nvencodeapi.dll, %DD%, 1
SplashTextOff
MsgBox, 0x2020, %Title%, NVENC patch have been applied on installation files.`r`rTo undo changes`, delete the extracted driver folder then extract from the driver package again.
Return