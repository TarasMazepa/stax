$ErrorActionPreference = "Stop"

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$tag = '0.9.12'

Install-ChocolateyZipPackage `
    -PackageName 'stax' `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum D5558CD419C8D46BDC958064CB97F963D1EA793866414C025906EC15033512ED `
    -ChecksumType SHA256 `
    -UnzipLocation "$toolsDir"

$cliPath = "$toolsDir\stax-$tag\cli"

& dart pub --directory="$cliPath" get
& dart compile exe "$cliPath\bin\cli.dart" -o "$toolsDir\stax.exe"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
