$ErrorActionPreference = "Stop"

$toolsDir = "$( Split-Path -Parent $MyInvocation.MyCommand.Definition )"

$tag = '0.9.39'

Install-ChocolateyZipPackage `
    -PackageName 'stax' `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum 2B80B7E3C3F6DCAE1718097E73E30EE454E95894A368C0906F649372CFF41898 `
    -ChecksumType SHA256 `
    -UnzipLocation "$toolsDir"

$unzipLocation = "$toolsDir\stax-$tag"
$cliPath = "$unzipLocation\cli"

& dart pub --directory="$cliPath" get
& dart compile exe -o "$toolsDir\stax.exe" "-Dversion=$tag" "$cliPath\bin\cli.dart"

Remove-Item -r -Force "$unzipLocation"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
