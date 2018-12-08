# install extension to MSBuild 15.0

Function EnsureProcessNotRunning($processName) {
    $process = Get-Process $processName -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "$processName is already running. Please close all instances first."
        Exit
    }
}

Write-Host "Uninstalling extension from MSBuild 15.0"
# fail if MSBuild is running
EnsureProcessNotRunning("MSBuild")
$msbuildExtensionPath = "${Env:ProgramFiles(x86)}\MSBuild\15.0"

# delete the Import targets
$path = "$msbuildExtensionPath\Microsoft.Common.Targets\ImportBefore\OutputPathExtension.ImportBefore.targets"
if (Test-Path $path) {
    Remove-Item $path -Force
    $deleted = $true
}
$path = "$msbuildExtensionPath\Microsoft.Common.Targets\ImportAfter\OutputPathExtension.ImportAfter.targets"
if (Test-Path $path) {
    Remove-Item $path -Force
    $deleted = $true
}
if ($deleted) {
    Write-Host "Removed integration with Microsoft.Common.Targets"
}

# delete the extension directory
$path = "$msbuildExtensionPath\OutputPathExtension"
if (Test-Path $path) {
    Remove-Item $path -Recurse -Force
    Write-Host "Deleted OutputPathExtension directory"
}