$ErrorActionPreference = "Stop"

$toolsDir = "$( Split-Path -Parent $MyInvocation.MyCommand.Definition )"

$tag = '0.9.36'

Install-ChocolateyZipPackage `
    -PackageName 'stax' `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum AF846C5FF7D58926658E80F481038ED2AA1C57E194C358EBF9308C7EF8FCB528 `
    -ChecksumType SHA256 `
    -UnzipLocation "$toolsDir"

$unzipLocation = "$toolsDir\stax-$tag"
$cliPath = "$unzipLocation\cli"

& dart pub --directory="$cliPath" get
& dart compile exe -o "$toolsDir\stax.exe" "-Dversion=$tag" "$cliPath\bin\cli.dart"

Remove-Item -r -Force "$unzipLocation"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
