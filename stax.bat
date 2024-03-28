set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.

dart run "%DIRNAME%\cli\bin\cli.dart" %*
