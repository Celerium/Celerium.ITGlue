---
external help file: Celerium.ITGlue-help.xml
grand_parent: ConfigurationStatuses
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/ConfigurationStatuses/New-ITGlueConfigurationStatus.html
parent: POST
schema: 2.0.0
title: New-ITGlueConfigurationStatus
---

# New-ITGlueConfigurationStatus

## SYNOPSIS
Creates a configuration status

## SYNTAX

```powershell
New-ITGlueConfigurationStatus [-Data] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-ITGlueConfigurationStatus cmdlet creates a new configuration
status in your account

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
New-ITGlueConfigurationStatus -Data $JsonBody
```

Creates a new configuration status with the specified JSON body

## PARAMETERS

### -Data
JSON body depending on bulk changes or not

Do NOT include the "Data" property in the JSON object as this is handled
by the Invoke-ITGlueRequest function

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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

[https://celerium.github.io/Celerium.ITGlue/site/ConfigurationStatuses/New-ITGlueConfigurationStatus.html](https://celerium.github.io/Celerium.ITGlue/site/ConfigurationStatuses/New-ITGlueConfigurationStatus.html)

[https://api.itglue.com/developer/#configuration-statuses-create](https://api.itglue.com/developer/#configuration-statuses-create)

