---
external help file: Celerium.ITGlue-help.xml
grand_parent: Manufacturers
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Manufacturers/Get-ITGlueManufacturer.html
parent: GET
schema: 2.0.0
title: Get-ITGlueManufacturer
---

# Get-ITGlueManufacturer

## SYNOPSIS
List or show all manufacturers

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueManufacturer [-FilterName <String>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>]
 [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueManufacturer -ID <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueManufacturer cmdlet returns a manufacturer name
or a list of manufacturers in your account

This function can call the following endpoints:
    Index = /manufacturers

    Show =  /manufacturers/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueManufacturer
```

Returns the first 50 manufacturer results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueManufacturer -ID 8765309
```

Returns the manufacturer with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueManufacturer -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for manufacturers
in your ITGlue account

## PARAMETERS

### -FilterName
Filter by a manufacturers name

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
Get a manufacturer by id

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

[https://celerium.github.io/Celerium.ITGlue/site/Manufacturers/Get-ITGlueManufacturer.html](https://celerium.github.io/Celerium.ITGlue/site/Manufacturers/Get-ITGlueManufacturer.html)

[https://api.itglue.com/developer/#manufacturers-index](https://api.itglue.com/developer/#manufacturers-index)

