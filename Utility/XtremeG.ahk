; 
;   Xtreme-G INF Patcher 1.1 (27-07-2020)
;   Author: alanfox2000
;   Credit: Dragondale13
;
#NoTrayIcon
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
FileEncoding, UTF-8-RAW

Title = Xtreme-G INF Patcher
content =
(
HKR,,D3D_A6489764,`%REG_DWORD`%,1
HKR,,D3D_12298867,`%REG_BINARY`%,37,90,38,39
HKR,,D3D_16579523,`%REG_BINARY`%,01,00,00,00
HKR,,D3D_16997821,`%REG_BINARY`%,74,72,95,99
HKR,,D3D_18078188,`%REG_BINARY`%,16,49,41,03
HKR,,D3D_20466189,`%REG_BINARY`%,54,91,25,31
HKR,,D3D_22355415,`%REG_BINARY`%,25,12,13,50
HKR,,D3D_23132857,`%REG_BINARY`%,f4,45,88,7c
HKR,,D3D_24464826,`%REG_BINARY`%,65,28,81,23
HKR,,D3D_30913648,`%REG_BINARY`%,01,00,00,00
HKR,,D3D_36759435,`%REG_BINARY`%,01,91,82,24
HKR,,D3D_40792312,`%REG_BINARY`%,01,00,00,00
HKR,,D3D_46205529,`%REG_BINARY`%,55,49,20,88
HKR,,D3D_52971801,`%REG_BINARY`%,00,18,0c,3c
HKR,,D3D_60461791,`%REG_BINARY`%,92,52,92,60
HKR,,D3D_88481200,`%REG_BINARY`%,00,00,00,00
HKR,,D3D_92521178,`%REG_BINARY`%,00,00,00,20
HKR,,D3D_94118636,`%REG_BINARY`%,00,00,00,00
HKR,,D3D_95739038,`%REG_BINARY`%,1f,00,00,00
HKR,,D3D_98764205,`%REG_BINARY`%,03,00,00,00
HKR,,D3D_QualityEnhancements,`%REG_BINARY`%,00,00,00,00
HKR,,D3DOGL_70835937,`%REG_BINARY`%,00,00,02,00
HKR,,D3DOGL_74095213,`%REG_BINARY`%,01,00,00,00
HKR,,D3DOGL_03385531,`%REG_BINARY`%,00,00,00,00
HKR,,D3DOGL_67207556,`%REG_BINARY`%,04,00,00,00
HKR,,D3DOGL_64877940,`%REG_BINARY`%,00,00,00,00
HKR,,D3DOGL_53893160,`%REG_BINARY`%,01,00,00,00
HKR,,D3DOGL_49119164,`%REG_BINARY`%,04,00,00,00
HKR,,D3DOGL_12677978,`%REG_BINARY`%,60,16,62,51
HKR,,OGL_CmdBufMinWords,`%REG_BINARY`%,80,09,00,00
HKR,,OGL_CmdBufSizeWords,`%REG_BINARY`%,00,00,04,00
HKR,,OGL_DefaultSwapInterval,`%REG_BINARY`%,ff,ff,ff,ff
HKR,,OGL_FlippingControl,`%REG_BINARY`%,02,00,00,00
HKR,,OGL_PalettedTexInVidMem,`%REG_BINARY`%,01,00,00,00
HKR,,OGL_QualityEnhancements,`%REG_BINARY`%,14,00,00,00
HKR,,OGL_RenderQualityFlags,`%REG_BINARY`%,08,00,00,00
HKR,,OGL_TargetFlushCount,`%REG_BINARY`%,10,00,00,00
HKR,,OGL_TexClampBehavior,`%REG_BINARY`%,00,00,00,00
HKR,,OGL_TexLODBias,`%REG_BINARY`%,00,00,00,00
HKR,,OGL_TripleBuffer,`%REG_BINARY`%,01,00,00,00
HKR,,OGL_UseCachedPCIMappings,`%REG_BINARY`%,01,00,00,00
HKR,,OGL_01887890,`%REG_BINARY`%,01,00,00,00
HKR,,OGL_1190801a,`%REG_BINARY`%,01,00,00,00
HKR,,OGL_563a95f1,`%REG_BINARY`%,43,bd,3a,41
HKR,,OGL_95282304,`%REG_BINARY`%,1f,00,00,00
HKR,,Ogl_MaxPCITexHeapSize,`%REG_BINARY`%,00,00,00,20
HKR,,Ogl_TexMemorySpaceEnables,`%REG_BINARY`%,03,00,00,00
HKR,,Ogl_DLMemorySpaceEnables,`%REG_BINARY`%,03,00,00,00
HKR,,TexturePrecache,`%REG_BINARY`%,01,00,00,00
HKR,,UMAFastFrameBuffer,`%REG_BINARY`%,01,00,00,00
;
)
Ask =
(
Do you want to apply the following TweakForce Xtreme-G registry modification on INF?

- Paletted Textures In Video Memory
- Render Quality Flags
- Target Flush Count
- Texture Clamp Behavior
- Texture LOD Bias
- Use Cached PCI Mappings
- Texture Memory Space
- Downloaded Memory Space
- Texture Precache
- UMA Fast Frame Buffering
- Main 3D rendering
- Triple Buffering
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
Loop, Files, %A_WorkingDir%\Display.Driver\*.inf, F
{
	IniRead, SectionNames, %A_LoopFileFullPath%
    Loop, Parse, SectionNames,`n
    {
        thissection := A_LoopField
        if thissection contains nv_commonBase_addreg
        {
            iniread, addregsection_content, %A_LoopFileFullPath%, %thissection%
            if addregsection_content not contains D3D_98764205
            {
                iniwrite, %content%, %A_LoopFileFullPath%, %thissection%
            }
        }
    }
}
SplashTextOff
MsgBox, 0x2020, %Title%, INF patched.`r`rTo undo changes`, delete the extracted driver folder then extract from the driver package again.
Return