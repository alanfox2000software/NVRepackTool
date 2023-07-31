; 
; Script by alanfox2000
;

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
FileEncoding, UTF-8-RAW

output_dir = %A_WorkingDir%\Temp\Output
extract_dir = %A_WorkingDir%\Temp\Extract
hdw11 = %A_WorkingDir%\hdaudio\w11
config = %A_WorkingDir%\config.ini

iniread, v_nvfbcwrp, %config%, Settings, pi_nvfbcwrp
iniread, v_nvfbc, %config%, Settings, pi_nvfbc
iniread, v_nvifr, %config%, Settings, pi_nvifr
iniread, v_nvifropengl, %config%, Settings, pi_nvifropengl

Loop, Files, %extract_dir%\*, D
{
    PackageDir = %A_LoopFileName%
    SetupCfg = %extract_dir%\%PackageDir%\setup.cfg
    64bitcheck = %extract_dir%\%PackageDir%\Display.Driver\nvencodeapi64.dll
	
    ;; INF
    Loop, Files, %extract_dir%\%PackageDir%\Display.Driver\*.inf, F
    {
        inidelete, %A_LoopFileFullPath%, nv_nvwmi_serviceInstall
        inidelete, %A_LoopFileFullPath%, NVWMI_InstallDir
        inidelete, %A_LoopFileFullPath%, nv_nvcamera_copyfiles
        inidelete, %A_LoopFileFullPath%, nv_nvcamera_service_addreg
        FileRead, c_inf, %A_LoopFileFullPath%
        c_inf := RegExReplace(c_inf, ",nvst3\*\.chm") ;both
        c_inf := RegExReplace(c_inf, ",nvWmi\.chm") ;both
        c_inf := RegExReplace(c_inf, "\r\n(.*)\.chm") ;both
        c_inf := RegExReplace(c_inf, "NvSupportTelemetry = 1", "NvSupportTelemetry = 0") ;both
        c_inf := RegExReplace(c_inf, ",NvInstallerUtil\.dll") ;both
        c_inf := RegExReplace(c_inf, "\r\nNvTelemetry64\.dll = 1") ;both
        c_inf := RegExReplace(c_inf, "\r\nCopyFiles = nv_telemetry(.*)_copyfiles(.*)") ;both
        c_inf := RegExReplace(c_inf, "\r\nnv_telemetry(.*)_copyfiles(.*)") ;both
        c_inf := RegExReplace(c_inf, "\r\n_DisplayDriverRAS\.dll(.*)") ;dch
        c_inf := RegExReplace(c_inf, "\r\nDisplayDriverRAS\.dll(.*)") ;legacy
        c_inf := RegExReplace(c_inf, "\r\nDisplayDriverRAS\.dll,,,0x00000010") ;legacy
        c_inf := RegExReplace(c_inf, "\r\nDisplayDriverRAS\.dll,,,") ;legacy
        c_inf := RegExReplace(c_inf, "\r\n(.*)nvprofileupdaterplugin\.dll(.*)") ;both
        c_inf := RegExReplace(c_inf, "\r\n(.*)nvgwls\.exe(.*)") ;both
        c_inf := RegExReplace(c_inf, "\r\n(.*)nvtopps\.db3(.*)") ;both
        c_inf := RegExReplace(c_inf, "\r\n_nvtopps\.dll(.*)") ;dch
        c_inf := RegExReplace(c_inf, "\r\n(.*)nvtopps\.dll(.*)") ;legacy
        c_inf := RegExReplace(c_inf, "\r\n(.*)nvgwls\.exe(.*)") ;both
        c_inf := RegExReplace(c_inf, "\r\n(.*)dlsargs\.xml(.*)") ;both
        c_inf := RegExReplace(c_inf, "\r\n(.*)dlsnetparams\.csv(.*)") ;both
        c_inf := RegExReplace(c_inf, "\r\nnvPerfProvider\.man = 1,NVWMI") ;dch
        c_inf := RegExReplace(c_inf, "\r\nnvWmi\.mof = 1,NVWMI") ;dch
        c_inf := RegExReplace(c_inf, "\r\nnvWmi64\.exe = 1,NVWMI") ;dch
        c_inf := RegExReplace(c_inf, "\r\nAddService = NVWMI, 0x00000800, nv_nvwmi_serviceInstall") ;dch
        c_inf := RegExReplace(c_inf, "\r\nAddReg = nv_nvcamera_service_addreg") ;dch
        c_inf := RegExReplace(c_inf, "\r\nDisplay\.Driver\NVWMI = \*\.\*") ;dch
        c_inf := RegExReplace(c_inf, "\r\nDisplay\.Driver\NvCamera = \*\.\*") ;dch
        c_inf := RegExReplace(c_inf, "\r\n(.*)\,NvCamera") ;dch
        c_inf := RegExReplace(c_inf, "\r\nNVWMI_InstallDir = 13,NVWMI") ;dch
        c_inf := RegExReplace(c_inf, "\r\n(.*)_NvGSTPlugin\.dll(.*)")
        c_inf := RegExReplace(c_inf, "\r\n(.*)_NvMsgBusBroadcast\.dll(.*)")
        c_inf := RegExReplace(c_inf, "\r\n(.*)wksServicePluginZ\.dll(.*)")
        c_inf := RegExReplace(c_inf, "\r\n(.*)wksServicePlugin\.dll(.*)")
        c_inf := RegExReplace(c_inf, "\r\n(.*)_NvMsgBusBroadcast\.dll(.*)")
        c_inf := RegExReplace(c_inf, "\r\n(.*)messagebus\.conf(.*)")
        c_inf := RegExReplace(c_inf, "\r\n(.*)messagebus_client\.conf(.*)")
        c_inf := RegExReplace(c_inf, "\r\n(.*)MessageBus\.dll(.*)")
        c_inf := RegExReplace(c_inf, "\r\nNvTelemetry.dll = 1") ;both
        c_inf := RegExReplace(c_inf, "\r\nnvWmi\.exe = 1,NVWMI") ;dch
        if (v_nvfbc = 0)
        {
          c_inf := RegExReplace(c_inf, "\r\nNvFBC.dll = 1")
          c_inf := RegExReplace(c_inf, "\r\nNvFBC64.dll = 1")
          c_inf := RegExReplace(c_inf, "\r\n(.*)DriverSupportModules(.*)NvFBC.dll(.*)")
          c_inf := RegExReplace(c_inf, "\r\n(.*)DriverSupportModules(.*)NvFBC64.dll(.*)")
          c_inf := RegExReplace(c_inf, "\r\nNvFBC64\.dll,,,0x00004000")
          c_inf := RegExReplace(c_inf, "\r\nNvFBC\.dll,,,0x00004000")
        }
        if v_nvifr = 0
        {
          c_inf := RegExReplace(c_inf, "\r\nNvIFR.dll = 1")
          c_inf := RegExReplace(c_inf, "\r\nNvIFR64.dll = 1")
          c_inf := RegExReplace(c_inf, "\r\n(.*)DriverSupportModules(.*)NvIFRC.dll(.*)")
          c_inf := RegExReplace(c_inf, "\r\n(.*)DriverSupportModules(.*)NvIFR64.dll(.*)")
          c_inf := RegExReplace(c_inf, "\r\nNvIFR64\.dll,,,0x00004000")
          c_inf := RegExReplace(c_inf, "\r\nNvIFR\.dll,,,0x00004000")
        }
        if v_nvifropengl = 0
        {
          c_inf := RegExReplace(c_inf, "\r\nNvIFROpenGL32.dll = 1")
          c_inf := RegExReplace(c_inf, "\r\nNvIFROpenGL64.dll = 1")
          c_inf := RegExReplace(c_inf, "\r\n(.*)DriverSupportModules(.*)NvIFROpenGL.dll(.*)")
          c_inf := RegExReplace(c_inf, "\r\nNvIFROpenGL\.dll,NvIFROpenGL64\.dll,,0x00004000")
          c_inf := RegExReplace(c_inf, "\r\nNvIFROpenGL.dll,,,0x00004000")
        }
        FileDelete,  %A_LoopFileFullPath%
        FileAppend, %c_inf%, %A_LoopFileFullPath%, UTF-8-RAW
        IniRead, SectionNames, %A_LoopFileFullPath%
        Loop, Parse, SectionNames,`n
        {
            thissection := A_LoopField
            if thissection contains nv_telemetry_
            {
                inidelete, %A_LoopFileFullPath%, %thissection%
            }
        }
    }
    
    ;; DisplayDriver.nvi
    Loop, Files, %extract_dir%\%PackageDir%\Display.Driver\DisplayDriver.nvi, F
    {
        FileRead, c_displaydriver_nvi, %A_LoopFileFullPath%
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "></manifest>", ">`r`n`t</manifest>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "/><file name", "/>`r`n`t`t<file name")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\.ex_(.*)>",".exe""/>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\.dl_(.*)>",".dll""/>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\.sy_(.*)>",".sys""/>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\.ic_(.*)>",".icm""/>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\.bi_(.*)>",".bin""/>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)DisplayDriverRAS\.dll(.*)>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)NvProfileUpdaterPlugin\.dll(.*)>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)NvTelemetry\.dll(.*)>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)NvTelemetry64\.dll(.*)>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<(.*)Feature.NvTelemetry(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "<string name=""preserveCache"" value=""true""/>","<string name=""preserveCache"" value=""false""/>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "<bool name=""UsesDisplayDriverRASSymLink"" value=""true""/>","<bool name=""UsesDisplayDriverRASSymLink"" value=""false""/>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<(.*)installNvProfileUpdaterPlugin(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<(.*)createNvProfileUpdaterJunctionPoint(.*)\r\n(.*)\r\n(.*)</standard>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\.inf(.*)sizeKB(.*)>", ".inf""/>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<(.*)installNvToppsPlugins(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)nvtopps\.db3(.*)>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)nvgwls\.exe(.*)>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)dlsargs\.xml(.*)>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)nvtopps\.dll(.*)>") ;dch & legacy
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)dlsnetparams\.csv(.*)>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)NVWMI(.*)>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)NvCamera(.*)>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<(.*)startNVWMIService(.*)\r\n(.*)\r\n(.*)</standard>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<(.*)installNvToppsPlugins(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>")
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)_NvGSTPlugin\.dll(.*)>") ;win10
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<(.*)installGSTPlugin(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>") ;win10
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<(.*)if(.*)isDeclarative(.*)\r\n(.*)if(.*)minWin10(.*)\r\n(.*)if(.*)\r\n(.*)if>") ;win10
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<(.*)installWksServicePlugin(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>") ;win10
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<(.*)installWksServicePluginZero(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>") ;win10
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)wksServicePlugin\.dll(.*)>") ;win10
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)wksServicePluginZ\.dll(.*)>") ;win10
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)_NvMsgBusBroadcast\.dll(.*)>") ;win10
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)MessageBus\.dll(.*)>") ;win10
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)messagebus\.conf(.*)>")  ;win10
        c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)messagebus_client\.conf(.*)>") ;win10
        if v_nvfbc = 0
        {
          c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)nvfbc\.dll(.*)>")
          c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)nvfbc64\.dll(.*)>")
          c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)NvFBCPlugin\.dll(.*)>")
          c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)NvFBCPlugin64\.dll(.*)>")
          c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<(.*)installNvFBCPlugins(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>")
        }
        if v_nvifr = 0
        {
          c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)nvifr\.dll(.*)>")
          c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)nvifr64\.dll(.*)>")
        }
        if v_nvifropengl = 0
        {
          c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)nvifropengl32\.dll(.*)>")
          c_displaydriver_nvi := RegExReplace(c_displaydriver_nvi, "\r\n(.*)<file name(.*)nvifropengl64\.dll(.*)>")
        }
        FileDelete, %A_LoopFileFullPath%
        FileAppend, %c_displaydriver_nvi%, %A_LoopFileFullPath%, UTF-8-RAW
    }
   
    
    ;; UpdateCore.nvi
    ;Loop, Files, %extract_dir%\%PackageDir%\Update.Core\UpdateCore.nvi, F
    ;{
    ;    FileRead, c_updatecore_nvi, %A_LoopFileFullPath%
    ;    c_updatecore_nvi := RegExReplace(c_updatecore_nvi, "hidden=""true""","hidden=""false""")
    ;    c_updatecore_nvi := RegExReplace(c_updatecore_nvi, "disposition=""demand""","disposition=""default""")
    ;    FileDelete, %A_LoopFileFullPath%
    ;    FileAppend, %c_updatecore_nvi%, %A_LoopFileFullPath%, UTF-8-RAW
    ;}
    
    ;; presentations.cfg
    Loop, Files, %extract_dir%\%PackageDir%\NVI2\presentations.cfg, F
    {
        FileRead, c_presentations_nvi, %extract_dir%\%PackageDir%\NVI2\presentations.cfg
        c_presentations_nvi := RegExReplace(c_presentations_nvi, "<string name=""ProgressPresentationUrl(.*)","<string name=""ProgressPresentationUrl"" value=""localhost""/>")
        c_presentations_nvi := RegExReplace(c_presentations_nvi, "<string name=""ProgressPresentationSelectedPackageUrl(.*)","<string name=""ProgressPresentationSelectedPackageUrl"" value=""localhost""/>")
        FileDelete, %A_LoopFileFullPath%
        FileAppend, %c_presentations_nvi%, %A_LoopFileFullPath%, UTF-8-RAW
    }
    
    ;; DisplayControlPanel.nvi
    Loop, Files, %extract_dir%\%PackageDir%\NvCplSetupInt\Extract\DisplayControlPanel.nvi, F
    {
        FileRead, c_controlpanel_nvi, %A_LoopFileFullPath%
        c_controlpanel_nvi:= RegExReplace(c_controlpanel_nvi, "></manifest>", ">`r`n`t</manifest>")
        c_controlpanel_nvi := RegExReplace(c_controlpanel_nvi, "/><file name", "/>`r`n`t`t<file name")
        c_controlpanel_nvi := RegExReplace(c_controlpanel_nvi, "\r\n\t\t<file name(.*)\.chm(.*)")
        c_controlpanel_nvi := RegExReplace(c_controlpanel_nvi, "\r\n\t\t\t\t(.*)copyFile(.*)\.chm(.*)")
        c_controlpanel_nvi := RegExReplace(c_controlpanel_nvi, "\r\n\t\t\t\t(.*)copyFile(.*)\.hlp(.*)")
        FileDelete, %A_LoopFileFullPath%
        FileAppend, %c_controlpanel_nvi%, %A_LoopFileFullPath%, UTF-8-RAW
    }
    
    ;; setup.cfg inside NvContainerSetup.exe
    Loop, Files, %extract_dir%\%PackageDir%\NvContainerSetup\Extract\setup.cfg, F
    {
        FileRead, c_nvcontainer_setupcfg, %A_LoopFileFullPath%
        c_nvcontainer_setupcfg := RegExReplace(c_nvcontainer_setupcfg, "\r\n(.*)select(.*)NVDisplayMessageBus(.*)>")
        c_nvcontainer_setupcfg := RegExReplace(c_nvcontainer_setupcfg, "\r\n(.*)sub-package(.*)MessageBus(.*)>")
        FileDelete, %A_LoopFileFullPath%
        FileAppend, %c_nvcontainer_setupcfg%, %A_LoopFileFullPath%, UTF-8-RAW
    }
    
    ;; NVDisplayMessageBus.nvi
    ;Loop, Files, %extract_dir%\%PackageDir%\NvContainerSetup\Extract\NVDisplayMessageBus.nvi, F
    ;{
    ;   FileRead, c_messagebus_nvi, %A_LoopFileFullPath%
    ;   c_messagebus_nvi := RegExReplace(c_messagebus_nvi, "></manifest>", ">`r`n`t</manifest>")
    ;   c_messagebus_nvi := RegExReplace(c_messagebus_nvi, "/><file name", "/>`r`n`t`t<file name")
    ;   c_messagebus_nvi := RegExReplace(c_messagebus_nvi, "\r\n\t\t<file name(.*)\.chm(.*)")
    ;   c_messagebus_nvi := RegExReplace(c_messagebus_nvi, "\r\n\t\t\t\t(.*)copyFile(.*)\.chm(.*)")
    ;   c_messagebus_nvi := RegExReplace(c_messagebus_nvi, "\r\n\t\t\t\t(.*)copyFile(.*)\.hlp(.*)")
    ;   FileDelete, %A_LoopFileFullPath%
    ;   FileAppend, %c_messagebus_nvi%, %A_LoopFileFullPath%, UTF-8-RAW
    ;}
     
    FileCopy, Utility\AutoClick.ahk, %extract_dir%\%PackageDir%, 1
    FileCopy, Utility\Utility.ahk, %extract_dir%\%PackageDir%, 1
    FileCopy, Utility\Utility_INF.ahk, %extract_dir%\%PackageDir%, 1
    FileCopy, Utility\XtremeG.ahk, %extract_dir%\%PackageDir%, 1
    FileCopy, Utility\NVENC.ahk, %extract_dir%\%PackageDir%, 1
    FileCopy, Utility\NvFBC.ahk, %extract_dir%\%PackageDir%, 1
    FileCopy, Utility\Launch.bat, %extract_dir%\%PackageDir%, 1
    FileCreateDir, %extract_dir%\%PackageDir%\NVENC
    if v_nvfbcwrp = 1
    {
        FileCreateDir, %extract_dir%\%PackageDir%\NvFBC
        FileCopy, NvFBC\nvfbcwrp32.dll, %extract_dir%\%PackageDir%\NvFBC\nvfbcwrp32.dll,1
    }
    ;FileCopy, NVENC\nvencodeapi.dll, %extract_dir%\%PackageDir%\NVENC,1
    If FileExist(64bitcheck)
    {
      if v_nvfbcwrp = 1
      {
        FileCopy, NvFBC\nvfbcwrp64.dll, %extract_dir%\%PackageDir%\NvFBC\nvfbcwrp64.dll,1
      }
      ;FileCopy, NVENC\nvencodeapi64.dll, %extract_dir%\%PackageDir%\NVENC,1
      FileCopy, Utility\AutoHotkeyU64.exe, %extract_dir%\%PackageDir%\AutoHotkey.exe, 1
    }
    else
    {
     FileCopy, Utility\AutoHotkeyU32.exe, %extract_dir%\%PackageDir%\AutoHotkey.exe, 1
    }
    ;; Cfg Patch
    ;;Check which setup.cfg to use
    ;;
    ;; Product Type
    ;;
    ;; 100 ???
    ;; 103 Data Center Driver / RTX Enterprise Production Branch
    ;; 300 Game Ready Dirver win7/8
    ;; 301 Studio Driver nsd 4xx
    ;; 303 Game Ready Driver Win10/11
    ;; 304 Studio Driver nsd
    ;; 
    FileEncoding, UTF-8
    FileRead, setupcfg_content, %SetupCfg%
    Pos := RegExMatch(setupcfg_content, "ProductType(.*)[0-9]+.[0-9]+", tmp2)
    ProductType := StrReplace(tmp2, "ProductType"" value=""")
    CfgUse = %A_WorkingDir%\setupcfg\%ProductType%\Setup.cfg
    ;patch <setup title="${{ProductTitle}}" version="xxxxxx"
    Pos := RegExMatch(PackageDir, "[0-9]+.[0-9]+", packver)
    FileRead, CfgUse_content, %CfgUse%
    CfgUse_content2 := RegExReplace(CfgUse_content, "[0-9][0-9][0-9].[0-9][0-9]", packver,,1)
    FileDelete, %SetupCfg%
    FileAppend, %CfgUse_content2%, %SetupCfg%, UTF-8
}

; 7z Config Patch
Loop, Files, %output_dir%\*.txt, F
{
    drvfoldername := StrReplace(A_LoopFileName, ".exe.txt")
    FileRead, ConfigTXT, %A_LoopFileFullPath%
    ConfigTXT2 := RegExReplace(ConfigTXT, "%systemdrive(.*)International", "%%S\\" drvfoldername "\\")
    ConfigTXT3 := RegExReplace(ConfigTXT2, "RunProgram=""\.\\\\\\\\setup.exe""", "RunProgram=""hidcon:\""%%T\\Launch.bat\""""")
    FileDelete, %A_LoopFileFullPath%
    FileAppend, %ConfigTXT3%, %A_LoopFileFullPath%, UTF-8
}
ExitApp
