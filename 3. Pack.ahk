; 
; Script by alanfox2000
;

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

if (A_Is64bitOS)
{
    7z = %A_WorkingDir%\Tools\7zip\64\7z.exe
}
else
{
    7z = %A_WorkingDir%\Tools\7zip\32\7z.exe
}

CMD7z = "-mmt=2 -m0=BCJ2 -m1=LZMA2:d128m:pb2:lp0:lc4:fb175 -m2=LZMA2:d19:pb2:lp0:lc4:fb175 -m3=LZMA2:d19:pb2:lp0:lc4:fb175 -mb0:1 -mb0s1:2 -mb0s2:3"
extract_dir = %A_WorkingDir%\Temp\Extract
output_dir = %A_WorkingDir%\Temp\Output

FormatTime, date,, dd-MM-yyyy
Loop, Files, %extract_dir%\*, D
{
    PackageDir = %A_LoopFileName%
    Pos := RegExMatch(PackageDir, "[0-9]+.[0-9]+", packver)
    NvCplSetupInt = %A_LoopFileLongPath%\Display.Driver\NvCplSetupInt.exe
    NvCplSetupInt_Dir = %A_LoopFileLongPath%\NvCplSetupInt
    NvContainerSetup = %A_LoopFileLongPath%\Display.Driver\NvContainerSetup.exe
    NvContainerSetup_Dir = %A_LoopFileLongPath%\NvContainerSetup
    
    FileDelete, %output_dir%\Temp.7z
    FileDelete, %NvCplSetupInt_Dir%\Temp.7z
    FileDelete, %NvContainerSetup_Dir%\Temp.7z
    
    If FileExist(NvCplSetupInt)
    {
        FileDelete, %NvCplSetupInt_Dir%\Temp.7z
        runwait, %7z% a -t7z "%NvCplSetupInt_Dir%\Temp.7z" "%NvCplSetupInt_Dir%\Extract\*" "%CMD7z%"
        runwait, %ComSpec% /c "copy /b "%NvCplSetupInt_Dir%\NvCplSetupInt.sfx" + "%NvCplSetupInt_Dir%\NvCplSetupInt.txt" +"%NvCplSetupInt_Dir%\Temp.7z" "%NvCplSetupInt%""
        FileDelete, %NvCplSetupInt_Dir%\Temp.7z
    }
    
    If FileExist(NvContainerSetup)
    {
        FileDelete, %NvContainerSetup_Dir%\Temp.7z
        runwait, %ComSpec% /c "copy /b "%NvContainerSetup_Dir%\NvContainerSetup.sfx" + "%NvContainerSetup_Dir%\NvContainerSetup.txt" +"%NvContainerSetup_Dir%\Temp.7z" "%NvContainerSetup%""
        FileDelete, %NvContainerSetup_Dir%\Temp.7z
    }
    
    ;  Compress Whole Driver Folder into 7z
    runwait, %7z% a -t7z "%output_dir%\%A_LoopFileName%.7z" "%A_LoopFileLongPath%\*" -xr!NvCplSetupInt -xr!NvContainerSetup "%CMD7z%"
    
    ;  Combine into EXE
    runwait, %ComSpec% /c "copy /b "%output_dir%\%PackageDir%.exe.sfx" + "%output_dir%\%PackageDir%.exe.txt" + "%output_dir%\Temp.7z" "%output_dir%\%PackageDir%-%date%.exe""
    
    FileDelete, %output_dir%\Temp.7z
}
ExitApp
