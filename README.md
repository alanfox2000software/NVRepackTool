# NVIDIA Driver Repack Tool

 1. Install AutoHotkey([Link](https://www.autohotkey.com/download/ahk-v2.exe)).
 2. Place the downloaded .exe driver files in the Temp\Input folder.
 3. Run '1. Extract.ahk', all drivers will be extracted to the Temp\Extract folder.
 4. Run '2. Patch.ahk', it will cleanup .inf and nvi files.
   - [Optional] Follow [this guide](https://github.com/keylase/nvidia-patch/tree/master/win) if you want NVENC patch. Select nvencodeapi64.dll and nvencodeapi.dll located at Temp\Extract\{driver folder}\NVENC for patching.
   - [Optional] Replace Temp\Extract\{driver folder}\HDAudio folder if you want [Dolby Digital Live](https://github.com/alanfox2000software/NVRepackTool/tree/ddl/hdaudio).
 7. "Run '3. Pack.ahk'. An .exe repack file will be created once the compression is finished.

[More info](https://puresoftapps-nvidia.blogspot.com/)

