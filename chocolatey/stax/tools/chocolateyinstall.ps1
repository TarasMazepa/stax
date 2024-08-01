$toolsDir = "$( Split-Path -parent $MyInvocation.MyCommand.Definition )"

$repoZipFile = "$toolsDir\repo.zip"

$tag = '0.9.0'

Get-ChocolateyWebFile `
    -PackageName 'stax' `
    -FileFullPath $repoZipFile `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum e932fe874f6580b2c1b53a0bf6a7f7ad84ffd2d50d78f80f7ee20c2ac19827f2 `
    -ChecksumType SHA256

Get-ChocolateyUnzip `
    -FileFullPath $repoZipFile `
    -Destination $toolsDir

& dart pub --directory="$toolsDir\stax-$tag\cli" get
& dart compile exe "$toolsDir\stax-$tag\cli\bin\cli.dart" -o "$toolsDir\stax.exe"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
