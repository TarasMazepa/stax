[xml]$xml = Get-Content -Path "chocolatey/stax/stax.nuspec"
$version = $xml.package.metadata.version
Write-Host "Found version: $version"

$downloadUrl = "https://github.com/TarasMazepa/stax/releases/download/$version/windows-x64.zip"
$outputZip = "windows-x64.zip"

Write-Host "Downloading from: $downloadUrl"
Invoke-WebRequest -Uri $downloadUrl -OutFile $outputZip

$ToolsPath = "chocolatey/stax/tools"
Write-Host "Extracting stax.exe to $ToolsPath"
Expand-Archive -Path $outputZip -DestinationPath "$ToolsPath" -Force
Copy-Item "LICENSE" -Destination $ToolsPath
