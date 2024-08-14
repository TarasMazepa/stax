$ErrorActionPreference = "Stop"

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$tag = '0.9.8'

Install-ChocolateyZipPackage `
    -PackageName 'stax' `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum 432661E8A636BC58A9ED267C6D30C0BD30829F59CA673F1839269E4C1C6F3441 `
    -ChecksumType SHA256 `
    -UnzipLocation "$toolsDir"

$cliPath = "$toolsDir\stax-$tag\cli"

& dart pub --directory="$cliPath" get
& dart compile exe "$cliPath\bin\cli.dart" -o "$toolsDir\stax.exe"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
