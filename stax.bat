@if "%DEBUG%" == "" @echo off

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.

"%DIRNAME%dev\stax.bat" %*
