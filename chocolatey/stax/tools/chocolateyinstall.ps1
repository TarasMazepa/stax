$ErrorActionPreference = "Stop"

$toolsDir = "$( Split-Path -Parent $MyInvocation.MyCommand.Definition )"

$tag = '0.9.15'

Install-ChocolateyZipPackage `
    -PackageName 'stax' `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum 2B78E4A05E35C7871E093B5D1693EA645EA4A5EEF4F0883D7171336BB660FFFF `
    -ChecksumType SHA256 `
    -UnzipLocation "$toolsDir"

$cliPath = "$toolsDir\stax-$tag\cli"

& dart pub --directory="$cliPath" get
& dart compile exe -o "$toolsDir\stax.exe" "-Dversion=$tag" "$cliPath\bin\cli.dart"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
