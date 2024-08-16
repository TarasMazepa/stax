$ErrorActionPreference = "Stop"

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$tag = '0.9.9'

Install-ChocolateyZipPackage `
    -PackageName 'stax' `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum 438564F353548EFAA8ECA2E1030BC49DEED04D86DDDF06CD7832B63560874EB7 `
    -ChecksumType SHA256 `
    -UnzipLocation "$toolsDir"

$cliPath = "$toolsDir\stax-$tag\cli"

& dart pub --directory="$cliPath" get
& dart compile exe "$cliPath\bin\cli.dart" -o "$toolsDir\stax.exe"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
