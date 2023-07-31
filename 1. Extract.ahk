; 
; Script by alanfox2000
;

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
if A_Is64bitOS = 1 
{
    7z = %A_WorkingDir%\Tools\7zip\64\7z.exe
}
else
{
    7z = %A_WorkingDir%\Tools\7zip\32\7z.exe
}

sfxsplit =  %A_WorkingDir%\Tools\SfxSplit\SfxSplit.exe
input_dir = %A_WorkingDir%\Temp\Input
output_dir = %A_WorkingDir%\Temp\Output
extract_dir = %A_WorkingDir%\Temp\Extract
config = %A_WorkingDir%\config.ini

iniread, v_nvfbc, %config%, Settings, pi_nvfbc
iniread, v_nvifr, %config%, Settings, pi_nvifr
Para_Array := []
if v_nvfbc = 0
{
  Para_Array.Push("-x!Display.Driver\nvfbc.dll")
  Para_Array.Push("-x!Display.Driver\nvfbc64.dll")
  Para_Array.Push("-x!Display.Driver\NvFBCPlugin.dll")
  Para_Array.Push("-x!Display.Driver\NvFBCPlugin64.dll")
}
if v_nvifr = 0
{
  Para_Array.Push("-x!Display.Driver\nvifr.dll")
  Para_Array.Push("-x!Display.Driver\nvifr64.dll")
}
if v_nvifropengl = 0
{
  Para_Array.Push("-x!Display.Driver\nvifropengl32.dll")
  Para_Array.Push("-x!Display.Driver\nvifropengl64.dll")
}
Loop % Para_Array.Length()
{
    if A_Index = 1
    {
        SavedPara := % Para_Array[1]
    }
    else
    {
        SavedPara := % SavedPara " " Para_Array[A_Index]
    }
}

Loop, Files, %input_dir%\*.exe, F
{

    FileNameNoExt := StrReplace(A_LoopFileName, "." . A_LoopFileExt)
    DisplayDir = %extract_dir%\%FileNameNoExt%\Display.Driver
    NvCplSetupInt = %DisplayDir%\NvCplSetupInt.exe
    NvCplSetupIntDir = %extract_dir%\%FileNameNoExt%\NvCplSetupInt
    NvContainerSetup = %DisplayDir%\NvContainerSetup.exe
    NvContainerSetupDir = %extract_dir%\%FileNameNoExt%\NvContainerSetup


    ; SFX Extract
    runwait, "%Sign64%" remove /s "%A_LoopFileFullPath%"
    runwait, %ComSpec% /c ""%sfxsplit%" "%A_LoopFileFullPath%" -m "%output_dir%\%A_LoopFileName%.sfx" -c "%output_dir%\%A_LoopFileName%.txt" -a "%output_dir%\%A_LoopFileName%.7z" -b"

    ; Driver Archive Extract
    runwait, "%7z%" x "%output_dir%\%A_LoopFileName%.7z" -y -o"%extract_dir%\%FileNameNoExt%" setup.exe setup.cfg ListDevices.txt license.txt EULA.txt -r Display.Driver\* HDAudio\* NVI2\* PhysX\* PPC\* NGXCore\* -xr@exclude.lst %SavedPara%


Loop, Files, %DisplayDir%\*.*_, F
{
    runwait, "%7z%" x "%A_LoopFileFullPath%" -y -o"%DisplayDir%",, min
    FileDelete, %A_LoopFileFullPath%
}

Loop, Files, %DisplayDir%\*.ic, F
{
    SplitPath, A_LoopFileFullPath,,ic_dir,, ic_name
    FileMove, %A_LoopFileFullPath%, %ic_dir%\%ic_name%.icm
}

;    runwait, %7z% x "%output_dir%\%A_LoopFileName%.7z" -y -o"%extract_dir%\%FileNameNoExt%" setup.exe setup.cfg ListDevices.txt license.txt EULA.txt -r Display.Driver\* HDAudio\* NVI2\* PhysX\* PPC\* NGXCore\* -x!GFExperience\EULA.txt -x!GFExperience\license.txt -x!NVI2\NVNetworkService.exe -x!NVI2\NVNetworkServiceAPI.dll -x!NVI2\NvInstallerUtil.dll -x!FrameViewSDK\EULA.txt -x!Update.Core\NvTmMon.exe -x!Update.Core\NvTmRep.exe -x!Display.Driver\DisplayDriverRAS.dll -x!Display.Driver\NvTelemetry64.dll -x!Display.Driver\Display.NvContainer\plugins\LocalSystem\_DisplayDriverRAS.dll -x!Display.Driver\NvProfileUpdaterPlugin.dll -x!Display.Driver\Display.NvContainer\plugins\Session\NvProfileUpdaterPlugin.dll -x!Display.Driver\nvtopps.dll -x!Display.Driver\Display.NvContainer\plugins\Session\_nvtopps.dll -x!Display.Driver\nvgwls.exe

    If FileExist(NvCplSetupInt)
    {
        FileCreateDir, %NvCplSetupIntDir%
    
        ; NvCplSetupInt SFX Extract
        runwait, "%Sign64%" remove /s "%NvCplSetupInt%"
        runwait, %ComSpec% /c ""%sfxsplit%" "%NvCplSetupInt%" -m "%NvCplSetupIntDir%\NvCplSetupInt.sfx" -c "%NvCplSetupIntDir%\NvCplSetupInt.txt" -a "%NvCplSetupIntDir%\NvCplSetupInt.7z" -b"
        
        ; NvCplSetupInt Archive Extract
        runwait, %7z% x "%NvCplSetupInt%" -y -o"%NvCplSetupIntDir%\Extract" -xr!*.chm
    }
    
    If FileExist(NvContainerSetup)
    {
        FileCreateDir, %NvContainerSetupDir%
    
        ; NvContainerSetup SFX Extract
        runwait, "%Sign64%" remove /s "%NvContainerSetup%"
        runwait, %ComSpec% /c ""%sfxsplit%" "%NvContainerSetup%" -m "%NvContainerSetupDir%\NvContainerSetup.sfx" -c "%NvContainerSetupDir%\NvContainerSetup.txt" -a "%NvContainerSetupDir%\NvContainerSetup.7z" -b"
        
        ; NvContainerSetup Archive Extract
        runwait, %7z% x "%NvContainerSetup%" -y -o"%NvContainerSetupDir%\Extract" -x!x86_64\MessageBus.dll -x!x86_64\messagebus.conf -x!x86_64\NvMsgBusBroadcast.dll -x!NVDisplayMessageBus.nvi
    }

}

ExitApp