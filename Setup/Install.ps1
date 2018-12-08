# install extension to MSBuild 15.0

Function CreateDirectoryIfNeeded($path) {
    If(!(Test-Path $path)) {
        New-Item -ItemType Directory -Force -Path $path | Out-Null
    }
}
Function EnsureProcessNotRunning($processName) {
    $process = Get-Process $processName -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "$processName is already running. Please close all instances first."
        Exit
    }
}

Write-Host "Installing extension in MSBuild 15.0"
# fail if MSBuild is running
EnsureProcessNotRunning("MSBuild");
$msbuildExtensionPath = "${Env:ProgramFiles(x86)}\MSBuild\15.0"
CreateDirectoryIfNeeded($msbuildExtensionPath)

# copy content to extension directory
$source = "$PSScriptRoot\..\MSBuild"
$destination = "$msbuildExtensionPath\..\OutputPathExtension"
CreateDirectoryIfNeeded($destination)
Copy-Item "$source\*.*" $destination -Exclude "MSBuild\Imports" -Recurse -Force
Write-Host "Copied OutputPathExtension directory"

# copy .props and .targets to Import directories
$destination = "$msbuildExtensionPath\Imports\Microsoft.Common.props\ImportBefore"
CreateDirectoryIfNeeded($destination)
Copy-Item "$source\Imports\Props\OutputPathExtension.ImportBefore.props" $destination -Force

$destination = "$msbuildExtensionPath\Microsoft.Common.Targets\ImportBefore"
CreateDirectoryIfNeeded($destination)
Copy-Item "$source\Imports\Targets\OutputPathExtension.ImportBefore.props" $destination -Force
Copy-Item "$source\Imports\Targets\OutputPathExtension.ImportBefore.targets" $destination -Force

$destination = "$msbuildExtensionPath\Microsoft.Common.Targets\ImportAfter"
CreateDirectoryIfNeeded($destination)
Copy-Item "$source\Imports\Targets\OutputPathExtension.ImportAfter.targets" $destination -Force

Write-Host "Integrated with Microsoft.Common.Targets"