@if "%DEBUG%" == "" @echo off

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.

dart run "%DIRNAME%\bin\stax.dill" %*
