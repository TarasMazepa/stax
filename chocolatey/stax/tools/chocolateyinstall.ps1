$ErrorActionPreference = "Stop"

$toolsDir = "$( Split-Path -Parent $MyInvocation.MyCommand.Definition )"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
