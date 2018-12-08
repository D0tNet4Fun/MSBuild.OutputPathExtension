# MSBuild.OutputPathExtension
This MSBuild extension allows changing the output paths when building a solution or a project from the command line. It replaces the default relative directories Obj and Bin with user-defined paths at build time, without changing the project files. This is designed to be used for speeding up the build process by using a different drive for MSBuild output, i.e. a RAM drive.

## How it works
The extension sets well-known properties such as `IntermediateOutputPath` and `OutputPath`. The values of these properties are set to begin with a user-defined path known as the **root output path**, followed by the drive where the project directory is located and the unrooted full path of the project directory.
I.e. given the project directory is `E:\Path\To\Projects\MyProject` and the build configuration is `Debug`, then:
- the intermediate path will be set to `$(RootOutputPath)\E\Path\To\Projects\MyProject\obj\Debug`
- the final output path will be set to `$(RootOutputPath)\E\Path\To\Projects\MyProject\bin\Debug`

## MSBuild support
The extension is supported in MSBuild 15.0.

## MSBuild integration
When installed, the extension is automatically imported by MSBuild via `Microsoft.Common.targets`'s before and after imports.
If not installed, the extension can be imported manually in MSBuild projects. I.e.
```xml
<Import Project="$(MSBuildExtensionsPath)\OutputPathExtension\OutputPathExtension.ImportBefore.targets" />
<Import Project="$(MSBuildToolsPath)\Microsoft.CSharp.targets" />
```

## Installation
The extension can be installed and uninstalled using PowerShell scripts available in the Setup directory.