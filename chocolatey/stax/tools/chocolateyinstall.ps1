$ErrorActionPreference = "Stop"

$toolsDir = "$( Split-Path -Parent $MyInvocation.MyCommand.Definition )"

$tag = '0.9.38'

Install-ChocolateyZipPackage `
    -PackageName 'stax' `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum 73D13AA53A71C4A99CC149D2372A9E3B84164B6BBCEAA2C5872C7D202B2A58DE `
    -ChecksumType SHA256 `
    -UnzipLocation "$toolsDir"

$unzipLocation = "$toolsDir\stax-$tag"
$cliPath = "$unzipLocation\cli"

& dart pub --directory="$cliPath" get
& dart compile exe -o "$toolsDir\stax.exe" "-Dversion=$tag" "$cliPath\bin\cli.dart"

Remove-Item -r -Force "$unzipLocation"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
