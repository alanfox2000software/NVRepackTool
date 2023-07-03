@echo off
cd /d "%~dp0"
if "%~1"=="" (goto blank)
SfxSplit.exe "%~1" -m  "%~1.sfx" -c "%~1.txt" -a "%~1.7z" -b
pause
exit

:blank
echo Drag and drop file 
pause