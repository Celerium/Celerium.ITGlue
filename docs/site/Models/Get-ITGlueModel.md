---
external help file: Celerium.ITGlue-help.xml
grand_parent: Models
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Models/Get-ITGlueModel.html
parent: GET
schema: 2.0.0
title: Get-ITGlueModel
---

# Get-ITGlueModel

## SYNOPSIS
List or show all models

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueModel [-ManufacturerID <Int64>] [-FilterID <Int64>] [-Sort <String>] [-PageNumber <Int64>]
 [-PageSize <Int32>] [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueModel [-ManufacturerID <Int64>] -ID <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueModel cmdlet returns a list of model names for all
manufacturers or for a specified manufacturer

This function can call the following endpoints:
    Index = /models

    Show =  /manufacturers/:id/relationships/models

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueModel
```

Returns the first 50 model results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueModel -ID 8765309
```

Returns the model with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueModel -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for models
in your ITGlue account

## PARAMETERS

### -ManufacturerID
Get models under the defined manufacturer id

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

### -FilterID
Filter models by id

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

### -Sort
Sort results by a defined value

Allowed values:
'id', 'name', 'manufacturer_id', 'created_at', 'updated_at',
'-id', '-name', '-manufacturer_id', '-created_at', '-updated_at'

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
Get a model by id

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

[https://celerium.github.io/Celerium.ITGlue/site/Models/Get-ITGlueModel.html](https://celerium.github.io/Celerium.ITGlue/site/Models/Get-ITGlueModel.html)

[https://api.itglue.com/developer/#models-index](https://api.itglue.com/developer/#models-index)

