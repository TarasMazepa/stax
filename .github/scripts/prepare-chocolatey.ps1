param (
    [string]$NuspecPath = "chocolatey/stax/stax.nuspec",
    [string]$ToolsPath = "chocolatey/stax/tools"
)

Write-Host "Extracting version from $NuspecPath"
[xml]$xml = Get-Content -Path $NuspecPath
$version = $xml.package.metadata.version
Write-Host "Found version: $version"

$downloadUrl = "https://github.com/TarasMazepa/stax/releases/download/$version/windows-x64.zip"
$outputZip = "windows-x64.zip"

Write-Host "Downloading from: $downloadUrl"
Invoke-WebRequest -Uri $downloadUrl -OutFile $outputZip

Write-Host "Extracting stax.exe to $ToolsPath"
Expand-Archive -Path $outputZip -DestinationPath temp_extract -Force
New-Item -ItemType Directory -Path $ToolsPath -Force -ErrorAction SilentlyContinue | Out-Null
Copy-Item -Path "temp_extract/stax.exe" -Destination "$ToolsPath/stax.exe" -Force

Remove-Item -Path temp_extract -Recurse -Force
Remove-Item -Path $outputZip -Force

