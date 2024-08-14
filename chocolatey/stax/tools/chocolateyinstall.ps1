$ErrorActionPreference = "Stop"

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$tag = '0.9.6'

Install-ChocolateyZipPackage `
    -PackageName 'stax' `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum 7D14192BB0256A871788C5AAF3888B9DB8BF3834E964C63C955AA74656CE2441 `
    -ChecksumType SHA256 `
    -UnzipLocation "$toolsDir"

$cliPath = "$toolsDir\stax-$tag\cli"

& dart pub --directory="$cliPath" get
& dart compile exe "$cliPath\bin\cli.dart" -o "$toolsDir\stax.exe"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
