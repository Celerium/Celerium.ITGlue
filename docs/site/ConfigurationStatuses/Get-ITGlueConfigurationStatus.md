---
external help file: Celerium.ITGlue-help.xml
grand_parent: ConfigurationStatuses
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/ConfigurationStatuses/Get-ITGlueConfigurationStatus.html
parent: GET
schema: 2.0.0
title: Get-ITGlueConfigurationStatus
---

# Get-ITGlueConfigurationStatus

## SYNOPSIS
List or show all configuration(s) statuses

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueConfigurationStatus [-FilterName <String>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>]
 [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueConfigurationStatus -ID <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueConfigurationStatus cmdlet lists all or shows a
defined configuration(s) status

This function can call the following endpoints:
    Index = /configuration_statuses

    Show =  /configuration_statuses/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueConfigurationStatus
```

Returns the first 50 results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueConfigurationStatus -ID 8765309
```

Returns the configuration status with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueConfigurationStatus -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for configuration status
in your ITGlue account

## PARAMETERS

### -FilterName
Filter by configuration status name

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
'name', 'id', 'created_at', 'updated_at',
'-name', '-id', '-created_at', '-updated_at'

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

### -ID
Get a configuration status by id

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

[https://celerium.github.io/Celerium.ITGlue/site/ConfigurationStatuses/Get-ITGlueConfigurationStatus.html](https://celerium.github.io/Celerium.ITGlue/site/ConfigurationStatuses/Get-ITGlueConfigurationStatus.html)

[https://api.itglue.com/developer/#configuration-statuses-index](https://api.itglue.com/developer/#configuration-statuses-index)

