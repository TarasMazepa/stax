$ErrorActionPreference = "Stop"

$toolsDir = "$( Split-Path -Parent $MyInvocation.MyCommand.Definition )"

$tag = '0.9.35'

Install-ChocolateyZipPackage `
    -PackageName 'stax' `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum 26D00E2CCE5C81DE2B43EC090366DBF3EFBCD21D8AA0444D322E1AFAEB5B2BEA `
    -ChecksumType SHA256 `
    -UnzipLocation "$toolsDir"

$unzipLocation = "$toolsDir\stax-$tag"
$cliPath = "$unzipLocation\cli"

& dart pub --directory="$cliPath" get
& dart compile exe -o "$toolsDir\stax.exe" "-Dversion=$tag" "$cliPath\bin\cli.dart"

Remove-Item -r -Force "$unzipLocation"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
