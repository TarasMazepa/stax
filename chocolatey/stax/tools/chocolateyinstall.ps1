$toolsDir = "$( Split-Path -parent $MyInvocation.MyCommand.Definition )"

$tag = '0.6.3'

Install-ChocolateyZipPackage `
    -PackageName 'stax' `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum B4C2E8246EA5662D88009085AEFA1FD6957485369ACE872FBB84261FEE47010A `
    -ChecksumType SHA256 `
    -UnzipLocation "$toolsDir"

& dart pub --directory="$toolsDir\stax-$tag\cli" get
& dart compile exe "$toolsDir\stax-$tag\cli\bin\cli.dart" -o "$toolsDir\stax.exe"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
