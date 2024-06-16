# $ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir = "$( Split-Path -parent $MyInvocation.MyCommand.Definition )"
$appFolder = "$toolsDir\stax"

$appRepoUrl = "https://github.com/TarasMazepa/stax/archive/master.zip"
$repoZipFile = "$appFolder\repo.zip"

# Create temporary directory for Dart SDK
if (!(Test-Path $appFolder))
{
  New-Item -ItemType Directory -Path $appFolder | Out-Null
}

# Clone App Repository
Invoke-WebRequest -Uri $appRepoUrl -OutFile $repoZipFile

# Extract
Expand-Archive -Path $repoZipFile -DestinationPath $appFolder

# Navigate to App Folder
Set-Location "$appFolder\stax-main\cli"

# Install dart
& choco install dart-sdk -y
& choco upgrade dart-sdk -y

# Build Dart App
& dart pub get
& dart compile exe bin/cli.dart -o stax.exe

# Move binary to user folder
$userStaxFolder = "$toolsDir\bin"
if (!(Test-Path $userStaxFolder))
{
  New-Item -ItemType Directory -Path $userStaxFolder | Out-Null
}
Move-Item -Path "$appFolder\stax-main\cli\stax.exe" -Destination $userStaxFolder -Force

# Cleanup files
Set-Location $toolsDir
# Cleanup
Remove-Item $appFolder -Recurse -Force
