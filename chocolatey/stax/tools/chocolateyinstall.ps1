$toolsDir = "$( Split-Path -parent $MyInvocation.MyCommand.Definition )"

$repoZipFile = "$toolsDir\repo.zip"

$tag = '0.7.35'

Get-ChocolateyWebFile `
    -PackageName 'stax' `
    -FileFullPath $repoZipFile `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum a125c6cef8e8553538daf60e83f42e46b7336a279f1a56c082155e122ff61d4d `
    -ChecksumType SHA256

Get-ChocolateyUnzip `
    -FileFullPath $repoZipFile `
    -Destination $toolsDir

& dart pub --directory="$toolsDir\stax-$tag\cli" get
& dart compile exe "$toolsDir\stax-$tag\cli\bin\cli.dart" -o "$toolsDir\stax.exe"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
