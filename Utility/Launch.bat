@echo off
cd /d "%~dp0"
chcp 65001
net.exe session 1>NUL 2>NUL || (Echo This script requires elevated rights. & pause & goto :eof)
for %%a in ("%~dp0") do set parent=%%~dpa
takeown /f "%parent%." /r /d n
cacls "%parent%." /t /e /p administrators:f
cacls "%parent%." /t /e /p users:f
start "" /d "%~dp0" AutoHotkey.exe "%~dp0Utility.ahk"
exit