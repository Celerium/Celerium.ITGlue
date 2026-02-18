---
external help file: Celerium.ITGlue-help.xml
grand_parent: ConfigurationStatuses
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/ConfigurationStatuses/Set-ITGlueConfigurationStatus.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueConfigurationStatus
---

# Set-ITGlueConfigurationStatus

## SYNOPSIS
Updates a configuration status

## SYNTAX

```powershell
Set-ITGlueConfigurationStatus [-ID] <Int64> [-Data] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueConfigurationStatus cmdlet updates a configuration
status in your account

Returns 422 Bad Request error if trying to update an externally synced record

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueConfigurationStatus -id 8675309 -Data $JsonBody
```

Updates the defined configuration status with the specified JSON body

## PARAMETERS

### -ID
Get a configuration status by id

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Data
JSON body depending on bulk changes or not

Do NOT include the "Data" property in the JSON object as this is handled
by the Invoke-ITGlueRequest function

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

[https://celerium.github.io/Celerium.ITGlue/site/ConfigurationStatuses/Set-ITGlueConfigurationStatus.html](https://celerium.github.io/Celerium.ITGlue/site/ConfigurationStatuses/Set-ITGlueConfigurationStatus.html)

[https://api.itglue.com/developer/#configuration-statuses](https://api.itglue.com/developer/#configuration-statuses)

