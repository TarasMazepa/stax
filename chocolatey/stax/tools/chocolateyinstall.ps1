$ErrorActionPreference = "Stop"

$toolsDir = "$( Split-Path -Parent $MyInvocation.MyCommand.Definition )"

$tag = '0.9.26'

Install-ChocolateyZipPackage `
    -PackageName 'stax' `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum 5CAA423593F89FD7942573EF144BD92EE80B635AE2CFB36CA6099710677B11DE `
    -ChecksumType SHA256 `
    -UnzipLocation "$toolsDir"

$unzipLocation = "$toolsDir\stax-$tag"
$cliPath = "$unzipLocation\cli"

& dart pub --directory="$cliPath" get
& dart compile exe -o "$toolsDir\stax.exe" "-Dversion=$tag" "$cliPath\bin\cli.dart"

Remove-Item -r -Force "$unzipLocation"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
