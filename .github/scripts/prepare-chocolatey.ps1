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

# Create LICENSE.txt file with proper Chocolatey format (CPMR0005 requirement)
Write-Host "Creating LICENSE.txt in $ToolsPath"
$licenseContent = Get-Content "LICENSE" -Raw
$formattedLicense = @"
From: https://github.com/TarasMazepa/stax/blob/main/LICENSE

LICENSE

$licenseContent
"@
$formattedLicense | Out-File -FilePath "$ToolsPath\LICENSE.txt" -Encoding UTF8

# Create VERIFICATION.txt file (CPMR0006 requirement)
Write-Host "Creating VERIFICATION.txt in $ToolsPath"
$verificationContent = @"
VERIFICATION

Verification is intended to assist the Chocolatey moderators and community
in verifying that this package's contents are trustworthy.

Package can be verified like this:

1. Download the binary from the official GitHub release:
   $downloadUrl

2. You can use one of the following methods to obtain the checksum:
   - Use powershell function 'Get-FileHash'
   - Use Chocolatey utility 'checksum.exe'

   checksum type: sha256
   checksum: [CHECKSUM_PLACEHOLDER]

File 'LICENSE.txt' is obtained from:
   https://github.com/TarasMazepa/stax/blob/main/LICENSE
"@

# Calculate checksum of the downloaded zip file
$checksum = Get-FileHash -Path $outputZip -Algorithm SHA256
$verificationContent = $verificationContent -replace '\[CHECKSUM_PLACEHOLDER\]', $checksum.Hash

# Write verification file
$verificationContent | Out-File -FilePath "$ToolsPath\VERIFICATION.txt" -Encoding UTF8
