# NVIDIA Driver Repack Tool

 1. Install [AutoHotkey](https://www.autohotkey.com/download/ahk-v2.exe) and download [this repository](https://github.com/alanfox2000software/NVRepackTool/archive/refs/heads/main.zip).
 2. Place the downloaded .exe driver files in the Temp\Input folder.
 3. Edit the `config.ini` file and modify the following variables. Set them to 0 to remove the corresponding file(s), or set them to 1 to add/keep those file(s).
   - `pi_nvfbcwrp` [nvfbcwrp32.dll, nvfbcwrp64.dll](https://github.com/keylase/nvidia-patch/tree/master/win/nvfbcwrp)
   - `pi_nvfbc` nNvFBC.dll, nNvFBC64.dll
   - `pi_nvifr` nNvIFR.dll, nNvIFR64.dll
 4. Run `1. Extract.ahk`, all drivers will be extracted to the Temp\Extract folder.
 5. Run `2. Patch.ahk`, it will cleanup .inf and nvi files.
   - [Optional] Follow [this guide](https://github.com/keylase/nvidia-patch/tree/master/win) if you want NVENC patch. Copy `nvencodeapi64.dll` and `nvencodeapi.dll` located at `Temp\Extract\{driver folder}\Disaply.Driver` folder to `Temp\Extract\{driver folder}\NVENC`. Select those files under the `NVENC` folder for patching.
   - [Optional] Replace `Temp\Extract\{driver folder}\HDAudio` folder if you want [Dolby Digital Live](https://github.com/alanfox2000software/NVRepackTool/tree/ddl/hdaudio).
 6. "Run '3. Pack.ahk'. An .exe repack file will be created once the compression is finished.

[More info](https://puresoftapps-nvidia.blogspot.com/)
