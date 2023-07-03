; 
;   NVIDIA Graphic Driver INF Utility 1.2 (28-07-2020)
;   Author: alanfox2000
;

#NoTrayIcon
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

AhkPath = %A_WorkingDir%\AutoHotkey.exe
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        Loop % A_Args.Length()
        {
            FullArgs := % FullArgs " "A_Args[A_Index]
        }
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart %FullArgs%
        else
            Run *RunAs "%AhkPath%" /restart "%A_ScriptFullPath%" %FullArgs%
    }
    ExitApp
}

Title = NVIDIA Graphic Driver INF Utility
INFPath=%A_WorkingDir%\Display.Driver


Gui Font, s9 cGray, Arial
Gui, Color, White
Gui Add, Text, x16 y56 w120 h20, OS Version Number
Gui Add, Text, x144 y56 w300 h20, Graphic Card Name [Hardware ID - Section ID]
Gui Add, Text, x16 y116 w80 h20, Hardware ID
Gui Add, Text, x340 y116 w110 h20, OS Version Number
Gui Font
Gui Font,, Arial
Gui Add, Text, x16 y136 w130 h23, PCI\VEN_10DE&&DEV_
Gui Add, Edit, x144 y130 w40 h21 +Center vDEV, AB12
Gui Add, Text, x186 y136 w63 h23, &&SUBSYS_
Gui Add, Edit, x254 y130 w75 h21 +Center vSUBSYS, 34567890
Gui Add, Text, x16 y8 w150 h23, INF need to be modified:
Gui Add, DropDownList, x165 y8 w120 gGetOS vINF
Gui Add, DropDownList, x16 y72 w118 vOS gGetCard
Gui Add, Text, x16 y32 w190 h23, Reference Graphic Card Settings:
Gui Add, Text, x16 y96 w100 h17, Copy Settings to
Gui Add, DropDownList, x340 y130 w118 vOSTarget
Gui Add, Button, x8 y168 w132 h23 gADDID, Add Hardware ID
Gui Font
Gui Font, s8, Verdana
Gui Add, DropDownList, x144 y72 w670 vCard
Gui Font

gosub GetINF
Gui Show, w820 h199, %Title%
Return

GuiEscape:
GuiClose:
    ExitApp

GetINF:
Loop, Files, %INFPath%\*.inf, F
{
    If A_Index = 1
    {
        INFStr := A_LoopFileName
    }
    else
    {
        INFStr := INFStr "|" A_LoopFileName
    }
}
GuiControl,, INF, %INFStr%
GuiControl, Choose, INF, 1
gosub GetOS
return



GetOS:
Gui, Submit, NoHide
OSNum := []
OSTime = 1
IniRead, SectionNames, %INFPath%\%INF%

Loop, Parse, SectionNames,`n
{
    OSsection := A_LoopField
    if OSsection contains NTamd64
    {
        OSNum := StrSplit(A_LoopField, ".",, "3")
        if OSTime = 1
        {
            OSStr := OSNum[3]
            OSTime = 2
        }
        else if OSTime = 2
        {
            OSStr := OSStr "|" OSNum[3]
        }
    }
} 
GuiControl,, OS, |%OSStr%
GuiControl,, OSTarget, |%OSStr%
GuiControl, Choose, OS, 1
GuiControl, Choose, OSTarget, 1
gosub GetCard
Return

GetCard:
Gui, Submit, NoHide
CardTime = 1
IniRead, NTamd64Section, %INFPath%\%INF%, NVIDIA_Devices.NTamd64.%OS%
NTamd64SectionReplaced := StrReplace(NTamd64Section, "%")
NTamd64SectionReplaced2 := StrReplace(NTamd64SectionReplaced, " ")
Loop, Parse, NTamd64SectionReplaced2, `n
{
    NTamd64Line := StrSplit(A_LoopField, "=")
    NTamd64Line2 := StrSplit(NTamd64Line[2], ",")
    NAMEID := NTamd64Line[1]
    SECTIONID := NTamd64Line2[1]
    HWID := NTamd64Line2[2]
    IniRead, Name, %INFPath%\%INF%, Strings, %NAMEID%
    if CardTime = 1
    {
        CardStr := Name " " "[" HWID " - " SECTIONID "]"
        CardTime = 2
    }
    else if CardTime = 2
    {
        CardStr := CardStr "|" Name " " "[" HWID " - " SECTIONID "]"
    }
}
GuiControl,, Card, |%CardStr%
GuiControl, Choose, Card, 1
Return


ADDID:
Gui, Submit, NoHide
SECTIONIDN_POS := RegExMatch(Card, "Section[0-9]+", SECTIONIDN)
CARDNAME_POS := RegExMatch(Card, "(.*)\[", CARDNAME2)
CARDNAME3 := StrReplace(CARDNAME2, " [")
CARDNAME := """" CARDNAME3 """"
HWID_POS := RegExMatch(Card, "PCI(.*) -", HWID)
SUBSYSSplit := StrSplit(SUBSYS)
DEVLength := StrLen(DEV)
Filename := INFPath "\" INF
SectionOS := "NVIDIA_Devices.NTamd64." OSTarget
IniRead, HWIDExist, %Filename%, %SectionOS%
If (DEVLength != "4")
{
    msgbox, 0x2010, %Title%, Device ID Length must be 4 character.
    Return
}
If (SUBSYSSplit.Length() = "8")
{
    SUBSYSID := SUBSYSSplit[1] SUBSYSSplit[2] SUBSYSSplit[3] SUBSYSSplit[4] "." SUBSYSSplit[5] SUBSYSSplit[6] SUBSYSSplit[7] SUBSYSSplit[8]
    Key := "%NVIDIA_DEV." DEV "." SUBSYSID "%"
    Key2 := "NVIDIA_DEV." DEV "." SUBSYSID
    HWID := "PCI\VEN_10DE&DEV_" DEV "&SUBSYS_" SUBSYS
    Value := SECTIONIDN ", " HWID
    If HWIDExist contains %HWID%
    {
        msgbox, 0x2010, %Title%, %HWID% is exist on OS Version %OSTarget%
        Return
    }
}
else if (SUBSYSSplit.Length() = "0")
{
    Key := "%NVIDIA_DEV." DEV "%"
    Key2 := "%NVIDIA_DEV." DEV
    HWID := "PCI\VEN_10DE&DEV_" DEV
    Value := SECTIONIDN ", " HWID
    Loop, Parse, HWIDExist, `r`n
    {
        If A_LoopField not contains SUBSYS
        {
            If A_LoopField contains %HWID%
            {
                msgbox, 0x2010, %Title%, %HWID% is exist on OS Version %OSTarget%
                Return
            }
        }
    }
}
else
{
    msgbox, 0x2010, %Title%, SubSystem ID Length must be 8.
    Return
}
IniWrite, %Value%, %Filename%, %SectionOS%, %Key%
IniWrite, %CARDNAME%, %Filename%, Strings, %Key2%
msgbox, 0x2040, %Title%, Adding Hardware ID %Value% success.
Return