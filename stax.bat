@if "%DEBUG%" == "" @echo off

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.

IF EXIST "%DIRNAME%usedev" (
    echo Using live stax
    "%DIRNAME%dev\stax.bat" %*
) ELSE (
    "%DIRNAME%bin\windows-x64\stax" %*
)
