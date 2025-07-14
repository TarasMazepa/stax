@echo off

set "SCRIPT_PATH=%~dp0"

if "%SCRIPT_PATH%"=="" set "SCRIPT_PATH=."

"%SCRIPT_PATH%\staxlive" %*
