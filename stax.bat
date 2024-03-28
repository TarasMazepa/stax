@if "%DEBUG%" == "" @echo off

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.

cd "%DIRNAME%cli"

dart pub get >NUL

dart run "%DIRNAME%cli\bin\cli.dart" %*
