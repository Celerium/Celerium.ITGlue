---
external help file: Celerium.ITGlue-help.xml
grand_parent: Internal
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Internal/Get-ITGlueModuleSettings.html
parent: GET
schema: 2.0.0
title: Get-ITGlueModuleSettings
---

# Get-ITGlueModuleSettings

## SYNOPSIS
Gets the saved ITGlue configuration settings

## SYNTAX

```powershell
Get-ITGlueModuleSettings [[-ITGlueConfigPath] <String>] [[-ITGlueConfigFile] <String>] [-OpenConfigFile]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueModuleSettings cmdlet gets the saved ITGlue configuration settings
from the local system

By default the configuration file is stored in the following location:
    $env:USERPROFILE\Celerium.ITGlue

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueModuleSettings
```

Gets the contents of the configuration file that was created with the
Export-ITGlueModuleSettings

The default location of the ITGlue configuration file is:
    $env:USERPROFILE\Celerium.ITGlue\config.psd1

### EXAMPLE 2
```powershell
Get-ITGlueModuleSettings -ITGlueConfigPath C:\Celerium.ITGlue -ITGlueConfigFile MyConfig.psd1 -openConfFile
```

Opens the configuration file from the defined location in the default editor

The location of the ITGlue configuration file in this example is:
    C:\Celerium.ITGlue\MyConfig.psd1

## PARAMETERS

### -ITGlueConfigPath
Define the location to store the ITGlue configuration file

By default the configuration file is stored in the following location:
    $env:USERPROFILE\Celerium.ITGlue

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.ITGlue"}else{".Celerium.ITGlue"}) )
Accept pipeline input: False
Accept wildcard characters: False
```

### -ITGlueConfigFile
Define the name of the ITGlue configuration file

By default the configuration file is named:
    config.psd1

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Config.psd1
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpenConfigFile
Opens the ITGlue configuration file

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[https://celerium.github.io/Celerium.ITGlue/site/Internal/Get-ITGlueModuleSettings.html](https://celerium.github.io/Celerium.ITGlue/site/Internal/Get-ITGlueModuleSettings.html)

