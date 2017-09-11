# MSBuild.OutputPathExtension
This MSBuild extension allows changing the output paths when building a solution or a project using Visual Studio or the command line. It replaces the default relative directories Obj and Bin with user-defined paths at build time, without changing the project files. This is designed to be used for speeding up the build process by using a different drive for MSBuild output, i.e. a RAM drive.

## How it works
The extension sets well-known properties such as `IntermediateOutputPath` and `OutputPath`. If these paths are relative (which is by default) then they are updated to begin with a user-defined path known as the **root output path**, followed by the drive where the project directory is located and the unrooted full path of the project directory.
I.e. given the project directory is `E:\Path\To\Projects\MyProject` and the build configuration is `Debug`, then:
- the intermediate path will be set to `$(RootOutputPath)\E\Path\To\Projects\MyProject\obj\Debug`
- the final output path will be set to `$(RootOutputPath)\E\Path\To\Projects\MyProject\bin\Debug`

## Features

#### Configure the root output path
The root output path can be configured in two ways:
- by setting the environment variable `MSBuildRootOutputPath`, which is the preferred way when using the IDE
- by setting the MSBuild property `RootOutputPath`
Note: the root output path does not have effect for user-defined output paths (intermediate and/or final) that are not relative.

#### Change build behavior when the root output path is not available at build time
The MSBuild property `FailIfRootOutputPathNotAvailable` can be set to `true` in order to fail the build in this case. 
When the property is set to `false`, the build will issue a warning and it will proceed using the default output paths.

#### Use links in output path
The MSBuild property `UseLinksInOutputPath` can be set to `true` to create symbolic links in the output path. This is used to minimize the disk space used by the project output.
Creating symbolic links require _SeCreateSymbolicLinkPrivilege_. If this is not available at build time then a warning is issued to indicate the process needs to be elevated.

## Installation
The extension can be installed and uninstalled using PowerShell scripts available in the Setup directory.
When installed, the extension is automatically imported by MSBuild via `Microsoft.Common.Props` and `Microsoft.Common.Targets`.

## MSBuild support
- The extension is supported in MSBuild 15.0.
- .NET Core projects are not supported.