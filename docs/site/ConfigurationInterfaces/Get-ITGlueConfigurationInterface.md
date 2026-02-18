---
external help file: Celerium.ITGlue-help.xml
grand_parent: ConfigurationInterfaces
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/ConfigurationInterfaces/Get-ITGlueConfigurationInterface.html
parent: GET
schema: 2.0.0
title: Get-ITGlueConfigurationInterface
---

# Get-ITGlueConfigurationInterface

## SYNOPSIS
Retrieve a configuration(s) interface(s)

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueConfigurationInterface [-ConfigurationID <Int64>] [-FilterID <Int64>] [-FilterIPAddress <String>]
 [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>] [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueConfigurationInterface [-ConfigurationID <Int64>] -ID <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueConfigurationInterface cmdlet retrieves a
configuration(s) interface(s)

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueConfigurationInterface -ConfigurationID 8765309
```

Gets an index of all the defined configurations interfaces

### EXAMPLE 2
```powershell
Get-ITGlueConfigurationInterface -ConfigurationID 8765309 -ID 8765309
```

Gets an a defined interface from a defined configuration

### EXAMPLE 3
```powershell
Get-ITGlueConfigurationInterface -ConfigurationID 8765309 -ID 8765309
```

Gets a defined interface from a defined configuration

### EXAMPLE 4
```powershell
Get-ITGlueConfigurationInterface -ID 8765309
```

Gets a defined interface

## PARAMETERS

### -ConfigurationID
A valid configuration ID in your account

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
A valid configuration interface ID in your account

```yaml
Type: Int64
Parameter Sets: Show
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -FilterID
Configuration id to filter by

```yaml
Type: Int64
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterIPAddress
IP address to filter by

```yaml
Type: String
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sort
Sort results by a defined value

Allowed values:
'created_at', 'updated_at', '-created_at', '-updated_at'

```yaml
Type: String
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageNumber
Return results starting from the defined number

```yaml
Type: Int64
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Number of results to return per page

The maximum number of page results that can be
requested is 1000

```yaml
Type: Int32
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllResults
Returns all items from an endpoint

This can be used in unison with -PageSize to limit the number of
sequential requests to the API

```yaml
Type: SwitchParameter
Parameter Sets: Index
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

[https://celerium.github.io/Celerium.ITGlue/site/ConfigurationInterfaces/Get-ITGlueConfigurationInterface.html](https://celerium.github.io/Celerium.ITGlue/site/ConfigurationInterfaces/Get-ITGlueConfigurationInterface.html)

[https://api.itglue.com/developer/#configuration-interfaces](https://api.itglue.com/developer/#configuration-interfaces)

