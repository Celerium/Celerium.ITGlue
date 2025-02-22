---
external help file: Celerium.ITGlue-help.xml
grand_parent: Regions
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Regions/Get-ITGlueRegion.html
parent: GET
schema: 2.0.0
title: Get-ITGlueRegion
---

# Get-ITGlueRegion

## SYNOPSIS
List or show all regions

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueRegion [-CountryID <Int64>] [-FilterName <String>] [-FilterISO <String>] [-FilterCountryID <Int32>]
 [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>] [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueRegion [-CountryID <Int64>] -ID <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueRegion cmdlet returns a list of supported regions
or the details of a single support region

This function can call the following endpoints:
    Index = /regions
            /countries/:id/relationships/regions

    Show =  /regions/:id
            /countries/:country_id/relationships/regions/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueRegion
```

Returns the first 50 region results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueRegion -ID 8765309
```

Returns the region with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueRegion -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for regions
in your ITGlue account

## PARAMETERS

### -CountryID
Get regions by country id

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

### -FilterName
Filter by region name

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

### -FilterISO
Filter by region iso abbreviation

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

### -FilterCountryID
Filter by country id

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
Get a region by id

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
2024-09-26 - Using the "country_id" parameter does not appear to
function at this time for either parameter set

## RELATED LINKS

[https://celerium.github.io/Celerium.ITGlue/site/Regions/Get-ITGlueRegion.html](https://celerium.github.io/Celerium.ITGlue/site/Regions/Get-ITGlueRegion.html)

[https://api.itglue.com/developer/#regions-index](https://api.itglue.com/developer/#regions-index)

