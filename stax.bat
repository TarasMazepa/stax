@if "%DEBUG%" == "" @echo off

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.

echo Using live stax
"%DIRNAME%dev\stax.bat" %*
