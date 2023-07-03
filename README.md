# NVIDIA Driver Repack Tool

 1. Install AutoHotkey([Link](https://www.autohotkey.com/download/ahk-v2.exe))
 2. Place the downloaded .exe driver files in the Temp\Input folder
 3. Run '1. Extract.ahk', all drivers will be extracted to the Temp\Extract folder.
 4. Run '2. Patch.ahk', it will cleanup .inf and nvi files.
 6. [Optional] Follow [this guide](https://github.com/keylase/nvidia-patch/tree/master/win) if you NVENC patch. Select nvencodeapi64.dll and nvencodeapi.dll located at Temp\Extract\{driver folder}\NVENC for patching.
8. Run '3. Pack.ahk', it will repack all files into the Temp\Output folder.

[More info](https://puresoftapps-nvidia.blogspot.com/)

```
