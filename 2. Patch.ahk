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
        FileRead, InfContents, %A_LoopFileFullPath%
        InfContents1 := RegExReplace(InfContents, ",nvst3\*\.chm") ;both
        InfContents2 := RegExReplace(InfContents1, ",nvWmi\.chm") ;both
        InfContents3 := RegExReplace(InfContents2, "\r\n(.*)\.chm") ;both
        InfContents4 := RegExReplace(InfContents3, "NvSupportTelemetry = 1", "NvSupportTelemetry = 0") ;both
        InfContents5 := RegExReplace(InfContents4, ",NvInstallerUtil\.dll") ;both
        InfContents6 := RegExReplace(InfContents5, "\r\nNvTelemetry64\.dll = 1") ;both
        InfContents7 := RegExReplace(InfContents6, "\r\nCopyFiles = nv_telemetry(.*)_copyfiles(.*)") ;both
        InfContents8 := RegExReplace(InfContents7, "\r\nnv_telemetry(.*)_copyfiles(.*)") ;both
        InfContents9 := RegExReplace(InfContents8, "\r\n_DisplayDriverRAS\.dll(.*)") ;dch
        InfContents10 := RegExReplace(InfContents9, "\r\nDisplayDriverRAS\.dll(.*)") ;legacy
        InfContents11 := RegExReplace(InfContents10, "\r\nDisplayDriverRAS\.dll,,,0x00000010") ;legacy
        InfContents12 := RegExReplace(InfContents11, "\r\nDisplayDriverRAS\.dll,,,") ;legacy
        InfContents13 := RegExReplace(InfContents12, "\r\n(.*)nvprofileupdaterplugin\.dll(.*)") ;both
        InfContents14 := RegExReplace(InfContents13, "\r\n(.*)nvgwls\.exe(.*)") ;both
        InfContents15 := RegExReplace(InfContents14, "\r\n(.*)nvtopps\.db3(.*)") ;both
        InfContents16 := RegExReplace(InfContents15, "\r\n_nvtopps\.dll(.*)") ;dch
        InfContents17 := RegExReplace(InfContents16, "\r\n(.*)nvtopps\.dll(.*)") ;legacy
        InfContents18 := RegExReplace(InfContents17, "\r\n(.*)nvgwls\.exe(.*)") ;both
        InfContents19 := RegExReplace(InfContents18, "\r\n(.*)dlsargs\.xml(.*)") ;both
        InfContents20 := RegExReplace(InfContents19, "\r\n(.*)dlsnetparams\.csv(.*)") ;both
        InfContents21 := RegExReplace(InfContents20, "\r\nnvPerfProvider\.man = 1,NVWMI") ;dch
        InfContents22 := RegExReplace(InfContents21, "\r\nnvWmi\.mof = 1,NVWMI") ;dch
        InfContents23 := RegExReplace(InfContents22, "\r\nnvWmi64\.exe = 1,NVWMI") ;dch
        InfContents24 := RegExReplace(InfContents23, "\r\nAddService = NVWMI, 0x00000800, nv_nvwmi_serviceInstall") ;dch
        InfContents25 := RegExReplace(InfContents24, "\r\nAddReg = nv_nvcamera_service_addreg") ;dch
        InfContents26 := RegExReplace(InfContents25, "\r\nDisplay\.Driver\NVWMI = \*\.\*") ;dch
        InfContents27 := RegExReplace(InfContents26, "\r\nDisplay\.Driver\NvCamera = \*\.\*") ;dch
        InfContents28 := RegExReplace(InfContents27, "\r\n(.*)\,NvCamera") ;dch
        InfContents29 := RegExReplace(InfContents28, "\r\nNVWMI_InstallDir = 13,NVWMI") ;dch
        InfContents30 := RegExReplace(InfContents29, "\r\n(.*)_NvGSTPlugin\.dll(.*)")
        InfContents31 := RegExReplace(InfContents30, "\r\n(.*)_NvMsgBusBroadcast\.dll(.*)")
        InfContents32 := RegExReplace(InfContents31, "\r\n(.*)wksServicePluginZ\.dll(.*)")
        InfContents33 := RegExReplace(InfContents32, "\r\n(.*)wksServicePlugin\.dll(.*)")
        InfContents34 := RegExReplace(InfContents33, "\r\n(.*)_NvMsgBusBroadcast\.dll(.*)")
        InfContents35 := RegExReplace(InfContents34, "\r\n(.*)messagebus\.conf(.*)")
        InfContents36 := RegExReplace(InfContents35, "\r\n(.*)messagebus_client\.conf(.*)")
        InfContents37 := RegExReplace(InfContents36, "\r\n(.*)MessageBus\.dll(.*)")
        InfContents38 := RegExReplace(InfContents37, "\r\nNvTelemetry.dll = 1") ;both
        InfContents39 := RegExReplace(InfContents38, "\r\nnvWmi\.exe = 1,NVWMI") ;dch
        if (v_nvfbc = 0)
        {
          InfContents40 := RegExReplace(InfContents39, "\r\nNvFBC.dll = 1")
          InfContents41 := RegExReplace(InfContents40, "\r\nNvFBC64.dll = 1")
          InfContents42 := RegExReplace(InfContents41, "\r\n(.*)DriverSupportModules(.*)NvFBC.dll(.*)")
          InfContents43 := RegExReplace(InfContents42, "\r\n(.*)DriverSupportModules(.*)NvFBC64.dll(.*)")
          InfContents44 := RegExReplace(InfContents43, "\r\nNvFBC64\.dll,,,0x00004000")
          InfContents45 := RegExReplace(InfContents44, "\r\nNvFBC\.dll,,,0x00004000")
        }
        else
        {
          InfContents45 := InfContents39
        }
        if v_nvifr = 0
        {
          InfContents46 := RegExReplace(InfContents45, "\r\nNvIFR.dll = 1")
          InfContents47 := RegExReplace(InfContents46, "\r\nNvIFR64.dll = 1")
          InfContents48 := RegExReplace(InfContents47, "\r\n(.*)DriverSupportModules(.*)NvIFRC.dll(.*)")
          InfContents49 := RegExReplace(InfContents48, "\r\n(.*)DriverSupportModules(.*)NvIFR64.dll(.*)")
          InfContents50 := RegExReplace(InfContents49, "\r\nNvIFR64\.dll,,,0x00004000")
          InfContents51 := RegExReplace(InfContents50, "\r\nNvIFR\.dll,,,0x00004000")
        }
        else
        {
          InfContents51 := InfContents45
        }
        FileDelete,  %A_LoopFileFullPath%
        FileAppend , %InfContents51%, %A_LoopFileFullPath%, UTF-8-RAW
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
        FileRead, NVI_DisplayDriver, %A_LoopFileFullPath%
        NVI_DisplayDriver2 := RegExReplace(NVI_DisplayDriver, "></manifest>", ">`r`n`t</manifest>")
        NVI_DisplayDriver3 := RegExReplace(NVI_DisplayDriver2, "/><file name", "/>`r`n`t`t<file name")
        NVI_DisplayDriver4 := RegExReplace(NVI_DisplayDriver3, "\r\n(.*)<file name(.*)DisplayDriverRAS\.dll(.*)>")
        NVI_DisplayDriver5 := RegExReplace(NVI_DisplayDriver4, "\r\n(.*)<file name(.*)NvProfileUpdaterPlugin\.dll(.*)>")
        NVI_DisplayDriver6 := RegExReplace(NVI_DisplayDriver5, "\r\n(.*)<file name(.*)NvTelemetry64\.dll(.*)>")
        NVI_DisplayDriver7 := RegExReplace(NVI_DisplayDriver6, "\r\n(.*)<(.*)Feature.NvTelemetry(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>")
        NVI_DisplayDriver8 := RegExReplace(NVI_DisplayDriver7, "<string name=""preserveCache"" value=""true""/>","<string name=""preserveCache"" value=""false""/>")
        NVI_DisplayDriver9 := RegExReplace(NVI_DisplayDriver8, "<bool name=""UsesDisplayDriverRASSymLink"" value=""true""/>","<bool name=""UsesDisplayDriverRASSymLink"" value=""false""/>")
        NVI_DisplayDriver10 := RegExReplace(NVI_DisplayDriver9, "\r\n(.*)<(.*)installNvProfileUpdaterPlugin(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>")
        NVI_DisplayDriver11 := RegExReplace(NVI_DisplayDriver10, "\r\n(.*)<(.*)createNvProfileUpdaterJunctionPoint(.*)\r\n(.*)\r\n(.*)</standard>")
        NVI_DisplayDriver12 := RegExReplace(NVI_DisplayDriver11, "\.inf(.*)sizeKB(.*)>", ".inf""/>")
        NVI_DisplayDriver13 := RegExReplace(NVI_DisplayDriver12, "\r\n(.*)<(.*)installNvToppsPlugins(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>")
        NVI_DisplayDriver14 := RegExReplace(NVI_DisplayDriver13, "\r\n(.*)<file name(.*)nvtopps\.db3(.*)>")
        NVI_DisplayDriver15 := RegExReplace(NVI_DisplayDriver14, "\r\n(.*)<file name(.*)nvgwls\.exe(.*)>")
        NVI_DisplayDriver16 := RegExReplace(NVI_DisplayDriver15, "\r\n(.*)<file name(.*)dlsargs\.xml(.*)>")
        NVI_DisplayDriver17 := RegExReplace(NVI_DisplayDriver16, "\r\n(.*)<file name(.*)nvtopps\.dll(.*)>") ;dch & legacy
        NVI_DisplayDriver18 := RegExReplace(NVI_DisplayDriver17, "\r\n(.*)<file name(.*)dlsnetparams\.csv(.*)>")
        NVI_DisplayDriver19 := RegExReplace(NVI_DisplayDriver18, "\r\n(.*)<file name(.*)NVWMI(.*)>")
        NVI_DisplayDriver20 := RegExReplace(NVI_DisplayDriver19, "\r\n(.*)<file name(.*)NvCamera(.*)>")
        NVI_DisplayDriver21 := RegExReplace(NVI_DisplayDriver20, "\r\n(.*)<(.*)startNVWMIService(.*)\r\n(.*)\r\n(.*)</standard>")
        NVI_DisplayDriver22 := RegExReplace(NVI_DisplayDriver21, "\r\n(.*)<(.*)installNvToppsPlugins(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>")
        NVI_DisplayDriver23 := RegExReplace(NVI_DisplayDriver22, "\r\n(.*)<file name(.*)_NvGSTPlugin\.dll(.*)>") ;win10
        NVI_DisplayDriver24 := RegExReplace(NVI_DisplayDriver23, "\r\n(.*)<(.*)installGSTPlugin(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>") ;win10
        NVI_DisplayDriver25 := RegExReplace(NVI_DisplayDriver24, "\r\n(.*)<(.*)if(.*)isDeclarative(.*)\r\n(.*)if(.*)minWin10(.*)\r\n(.*)if(.*)\r\n(.*)if>") ;win10
        NVI_DisplayDriver26 := RegExReplace(NVI_DisplayDriver25, "\r\n(.*)<(.*)installWksServicePlugin(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>") ;win10
        NVI_DisplayDriver27 := RegExReplace(NVI_DisplayDriver26, "\r\n(.*)<(.*)installWksServicePluginZero(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>") ;win10
        NVI_DisplayDriver28 := RegExReplace(NVI_DisplayDriver27, "\r\n(.*)<file name(.*)wksServicePlugin\.dll(.*)>") ;win10
        NVI_DisplayDriver29 := RegExReplace(NVI_DisplayDriver28, "\r\n(.*)<file name(.*)wksServicePluginZ\.dll(.*)>") ;win10
        NVI_DisplayDriver30 := RegExReplace(NVI_DisplayDriver29, "\r\n(.*)<file name(.*)_NvMsgBusBroadcast\.dll(.*)>") ;win10
        NVI_DisplayDriver31 := RegExReplace(NVI_DisplayDriver30, "\r\n(.*)<file name(.*)MessageBus\.dll(.*)>") ;win10
        NVI_DisplayDriver32 := RegExReplace(NVI_DisplayDriver31, "\r\n(.*)<file name(.*)messagebus\.conf(.*)>")  ;win10
        NVI_DisplayDriver33 := RegExReplace(NVI_DisplayDriver32, "\r\n(.*)<file name(.*)messagebus_client\.conf(.*)>") ;win10
        NVI_DisplayDriver34 := RegExReplace(NVI_DisplayDriver33, "\r\n(.*)<file name(.*)NvTelemetry\.dll(.*)>")
        NVI_DisplayDriver35 := RegExReplace(NVI_DisplayDriver34, "nvencodeapi64\.dl_(.*)>","nvencodeapi64\.dll"">")
        NVI_DisplayDriver36 := RegExReplace(NVI_DisplayDriver35, "nvencodeapi\.dl_(.*)>","nvencodeapi\.dll"">")
        NVI_DisplayDriver37 := RegExReplace(NVI_DisplayDriver36, "nvfbc64\.dl_(.*)>","nvfbc64\.dll"">")
        NVI_DisplayDriver38 := RegExReplace(NVI_DisplayDriver37, "nvfbc\.dl_(.*)>","nvfbc\.dll"">")
        NVI_DisplayDriver39 := RegExReplace(NVI_DisplayDriver38, "nvifr64\.dl_(.*)>","nvifr64\.dll"">")
        NVI_DisplayDriver40 := RegExReplace(NVI_DisplayDriver39, "nvifr\.dl_(.*)>","nvifr\.dll"">")
        if v_nvfbc = 0
        {
          NVI_DisplayDriver41 := RegExReplace(NVI_DisplayDriver40, "\r\n(.*)<file name(.*)nvfbc\.dll(.*)>")
          NVI_DisplayDriver42 := RegExReplace(NVI_DisplayDriver41, "\r\n(.*)<file name(.*)nvfbc\64.dll(.*)>")
          NVI_DisplayDriver43 := RegExReplace(NVI_DisplayDriver42, "\r\n(.*)<(.*)installNvFBCPlugins(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)</standard>")
        }
        else
        {
          NVI_DisplayDriver43 := NVI_DisplayDriver40
        }
        if v_nvifr = 0
        {
          NVI_DisplayDriver44 := RegExReplace(NVI_DisplayDriver43, "\r\n(.*)<file name(.*)nvifr\.dll(.*)>")
          NVI_DisplayDriver45 := RegExReplace(NVI_DisplayDriver44, "\r\n(.*)<file name(.*)nvifr64\.dll(.*)>")
        }
        else
        {
          NVI_DisplayDriver45 := NVI_DisplayDriver43
        }
        FileDelete, %A_LoopFileFullPath%
        FileAppend, %NVI_DisplayDriver45%, %A_LoopFileFullPath%, UTF-8-RAW
    }
    
    ;; setup.cfg inside NvContainer
    Loop, Files, %extract_dir%\%PackageDir%\NvContainerSetup\Extract\setup.cfg, F
    {
        FileRead, NVIContainer_setupcfg, %A_LoopFileFullPath%
        NVIContainer_setupcfg2 := RegExReplace(NVIContainer_setupcfg, "\r\n(.*)select(.*)NVDisplayMessageBus(.*)>")
        NVIContainer_setupcfg3 := RegExReplace(NVIContainer_setupcfg2, "\r\n(.*)sub-package(.*)MessageBus(.*)>")
        FileDelete, %A_LoopFileFullPath%
        FileAppend, %NVIContainer_setupcfg3%, %A_LoopFileFullPath%, UTF-8-RAW
    }
    
    ;; UpdateCore.nvi
    ;Loop, Files, %extract_dir%\%PackageDir%\Update.Core\UpdateCore.nvi, F
    ;{
    ;    FileRead, NVI_UpdateCore, %A_LoopFileFullPath%
    ;    NVI_UpdateCore2 := RegExReplace(NVI_UpdateCore, "hidden=""true""","hidden=""false""")
    ;    NVI_UpdateCore3 := RegExReplace(NVI_UpdateCore2, "disposition=""demand""","disposition=""default""")
    ;    FileDelete, %A_LoopFileFullPath%
    ;    FileAppend, %NVI_UpdateCore3%, %A_LoopFileFullPath%, UTF-8-RAW
    ;}
    
    ;; presentations.cfg
    Loop, Files, %extract_dir%\%PackageDir%\NVI2\presentations.cfg, F
    {
        FileRead, NVI_presentations, %extract_dir%\%PackageDir%\NVI2\presentations.cfg
        NVI_presentations2 := RegExReplace(NVI_presentations, "<string name=""ProgressPresentationUrl(.*)","<string name=""ProgressPresentationUrl"" value=""localhost""/>")
        NVI_presentations3 := RegExReplace(NVI_presentations2, "<string name=""ProgressPresentationSelectedPackageUrl(.*)","<string name=""ProgressPresentationSelectedPackageUrl"" value=""localhost""/>")
        FileDelete, %A_LoopFileFullPath%
        FileAppend, %NVI_presentations3%, %A_LoopFileFullPath%, UTF-8-RAW
    }
    
    ;; DisplayControlPanel.nvi
    Loop, Files, %extract_dir%\%PackageDir%\NvCplSetupInt\Extract\DisplayControlPanel.nvi, F
    {
        FileRead, NVI_ControlPanel, %A_LoopFileFullPath%
        NVI_ControlPanel2 := RegExReplace(NVI_ControlPanel, "></manifest>", ">`r`n`t</manifest>")
        NVI_ControlPanel3 := RegExReplace(NVI_ControlPanel2, "/><file name", "/>`r`n`t`t<file name")
        NVI_ControlPanel4 := RegExReplace(NVI_ControlPanel3, "\r\n\t\t<file name(.*)\.chm(.*)")
        NVI_ControlPanel5 := RegExReplace(NVI_ControlPanel4, "\r\n\t\t\t\t(.*)copyFile(.*)\.chm(.*)")
        NVI_ControlPanel6 := RegExReplace(NVI_ControlPanel5, "\r\n\t\t\t\t(.*)copyFile(.*)\.hlp(.*)")
        FileDelete, %A_LoopFileFullPath%
        FileAppend, %NVI_ControlPanel6%, %A_LoopFileFullPath%, UTF-8-RAW
    }
   
    ;; DisplayControlPanel.nvi
    Loop, Files, %extract_dir%\%PackageDir%\NvContainerSetup\Extract\NVDisplayMessageBus.nvi, F
    {
        FileRead, NVI_ControlPanel, %A_LoopFileFullPath%
        NVI_ControlPanel2 := RegExReplace(NVI_ControlPanel, "></manifest>", ">`r`n`t</manifest>")
        NVI_ControlPanel3 := RegExReplace(NVI_ControlPanel2, "/><file name", "/>`r`n`t`t<file name")
        NVI_ControlPanel4 := RegExReplace(NVI_ControlPanel3, "\r\n\t\t<file name(.*)\.chm(.*)")
        NVI_ControlPanel5 := RegExReplace(NVI_ControlPanel4, "\r\n\t\t\t\t(.*)copyFile(.*)\.chm(.*)")
        NVI_ControlPanel6 := RegExReplace(NVI_ControlPanel5, "\r\n\t\t\t\t(.*)copyFile(.*)\.hlp(.*)")
        FileDelete, %A_LoopFileFullPath%
        FileAppend, %NVI_ControlPanel6%, %A_LoopFileFullPath%, UTF-8-RAW
    }
     
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
