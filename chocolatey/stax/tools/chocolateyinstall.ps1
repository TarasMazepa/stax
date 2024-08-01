$toolsDir = "$( Split-Path -parent $MyInvocation.MyCommand.Definition )"

$repoZipFile = "$toolsDir\repo.zip"

$tag = '0.9.2'

Get-ChocolateyWebFile `
    -PackageName 'stax' `
    -FileFullPath $repoZipFile `
    -Url "https://github.com/TarasMazepa/stax/archive/$tag.zip" `
    -Checksum 0f4691f84c7c4655e8f5a1cd276899277cad0a1f4c16844a215483fed44a019f `
    -ChecksumType SHA256

Get-ChocolateyUnzip `
    -FileFullPath $repoZipFile `
    -Destination $toolsDir

& dart pub --directory="$toolsDir\stax-$tag\cli" get
& dart compile exe "$toolsDir\stax-$tag\cli\bin\cli.dart" -o "$toolsDir\stax.exe"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
