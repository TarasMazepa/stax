$toolsDir = "$( Split-Path -parent $MyInvocation.MyCommand.Definition )"

$repoZipFile = "$toolsDir\repo.zip"

$tag = '0.9.1'

Get-ChocolateyWebFile `
    -PackageName 'stax' `
    -FileFullPath $repoZipFile `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum caff80c7e8834a545b3a1965250d296d22a4b69ec03b68fdf7262c8c1e08d6f8 `
    -ChecksumType SHA256

Get-ChocolateyUnzip `
    -FileFullPath $repoZipFile `
    -Destination $toolsDir

& dart pub --directory="$toolsDir\stax-$tag\cli" get
& dart compile exe "$toolsDir\stax-$tag\cli\bin\cli.dart" -o "$toolsDir\stax.exe"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
