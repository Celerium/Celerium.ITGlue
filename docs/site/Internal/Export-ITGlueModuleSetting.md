---
external help file: Celerium.ITGlue-help.xml
grand_parent: Internal
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Internal/Export-ITGlueModuleSetting.html
parent: PATCH
schema: 2.0.0
title: Export-ITGlueModuleSetting
---

# Export-ITGlueModuleSetting

## SYNOPSIS
Exports the ITGlue BaseURI, API, & JSON configuration information to file

## SYNTAX

```powershell
Export-ITGlueModuleSetting [[-ITGlueConfigPath] <String>] [[-ITGlueConfigFile] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Export-ITGlueModuleSetting cmdlet exports the ITGlue BaseURI, API, & JSON configuration information to file

Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
that can only be unencrypted with the your Windows account as this encryption is tied to your user principal
This means that you cannot copy your configuration file to another computer or user account and expect it to work

## EXAMPLES

### EXAMPLE 1
```powershell
Export-ITGlueModuleSetting
```

Validates that the BaseURI, API, and JSON depth are set then exports their values
to the current user's ITGlue configuration file located at:
    $env:USERPROFILE\Celerium.ITGlue\config.psd1

### EXAMPLE 2
```powershell
Export-ITGlueModuleSetting -ITGlueConfigPath C:\Celerium.ITGlue -ITGlueConfigFile MyConfig.psd1
```

Validates that the BaseURI, API, and JSON depth are set then exports their values
to the current user's ITGlue configuration file located at:
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[https://celerium.github.io/Celerium.ITGlue/site/Internal/Export-ITGlueModuleSetting.html](https://celerium.github.io/Celerium.ITGlue/site/Internal/Export-ITGlueModuleSetting.html)

[https://github.com/Celerium/Celerium.ITGlue](https://github.com/Celerium/Celerium.ITGlue)

