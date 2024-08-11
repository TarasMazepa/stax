$toolsDir = "$( Split-Path -parent $MyInvocation.MyCommand.Definition )"

$repoZipFile = "$toolsDir\repo.zip"

$tag = '0.9.5'

Get-ChocolateyWebFile `
    -PackageName 'stax' `
    -FileFullPath $repoZipFile `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed `
    -ChecksumType SHA256

Get-ChocolateyUnzip `
    -FileFullPath $repoZipFile `
    -Destination $toolsDir

& dart pub --directory="$toolsDir\stax-$tag\cli" get
& dart compile exe "$toolsDir\stax-$tag\cli\bin\cli.dart" -o "$toolsDir\stax.exe"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
