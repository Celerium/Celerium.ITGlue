---
external help file: Celerium.ITGlue-help.xml
grand_parent: ConfigurationInterfaces
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/ConfigurationInterfaces/Set-ITGlueConfigurationInterface.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueConfigurationInterface
---

# Set-ITGlueConfigurationInterface

## SYNOPSIS
Update one or more configuration interfaces

## SYNTAX

### BulkUpdate (Default)
```powershell
Set-ITGlueConfigurationInterface [-FilterID <Int64>] [-FilterIPAddress <String>] -Data <Object> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-ITGlueConfigurationInterface [-ConfigurationID <Int64>] -ID <Int64> -Data <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueConfigurationInterface cmdlet updates one
or more configuration interfaces

Any attributes you don't specify will remain unchanged

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueConfigurationInterface -ID 8765309 -Data $JsonBody
```

Updates an interface for the defined configuration with the structured
JSON object

### EXAMPLE 2
```powershell
Set-ITGlueConfigurationInterface -FilterID 8765309 -Data $JsonBody
```

Bulk updates interfaces associated to the defined configuration filter
with the specified JSON body

## PARAMETERS

### -ConfigurationID
A valid configuration ID in your account

```yaml
Type: Int64
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
A valid configuration interface ID in your account

Example: 12345

```yaml
Type: Int64
Parameter Sets: Update
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterID
Configuration id to filter by

```yaml
Type: Int64
Parameter Sets: BulkUpdate
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterIPAddress
Filter by an IP4 or IP6 address

```yaml
Type: String
Parameter Sets: BulkUpdate
Aliases:

Required: False
Position: Named
Default value: None
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
Position: Named
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

[https://celerium.github.io/Celerium.ITGlue/site/ConfigurationInterfaces/Set-ITGlueConfigurationInterface.html](https://celerium.github.io/Celerium.ITGlue/site/ConfigurationInterfaces/Set-ITGlueConfigurationInterface.html)

[https://api.itglue.com/developer/#configuration-interfaces](https://api.itglue.com/developer/#configuration-interfaces)

