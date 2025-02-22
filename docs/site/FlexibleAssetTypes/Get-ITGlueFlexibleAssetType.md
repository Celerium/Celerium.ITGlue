---
external help file: Celerium.ITGlue-help.xml
grand_parent: FlexibleAssetTypes
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetTypes/Get-ITGlueFlexibleAssetType.html
parent: GET
schema: 2.0.0
title: Get-ITGlueFlexibleAssetType
---

# Get-ITGlueFlexibleAssetType

## SYNOPSIS
List or show all flexible asset types

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueFlexibleAssetType [-FilterID <Int64>] [-FilterName <String>] [-FilterIcon <String>]
 [-FilterEnabled <String>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>] [-Include <String>]
 [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueFlexibleAssetType -ID <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueFlexibleAssetType cmdlet returns details on a flexible asset type
or a list of flexible asset types in your account

This function can call the following endpoints:
    Index = /flexible_asset_types

    Show =  /flexible_asset_types/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueFlexibleAssetType
```

Returns the first 50 flexible asset results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueFlexibleAssetType -ID 8765309
```

Returns the defined flexible asset with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueFlexibleAssetType -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for flexible assets
in your ITGlue account

## PARAMETERS

### -FilterID
Filter by a flexible asset id

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

### -FilterName
Filter by a flexible asset name

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

### -FilterIcon
Filter by a flexible asset icon

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

### -FilterEnabled
Filter if a flexible asset is enabled

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

### -Include
Include specified assets

Allowed values:
'flexible_asset_fields'

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

### -ID
A valid flexible asset id in your account

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

[https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetTypes/Get-ITGlueFlexibleAssetType.html](https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetTypes/Get-ITGlueFlexibleAssetType.html)

[https://api.itglue.com/developer/#flexible-asset-types-index](https://api.itglue.com/developer/#flexible-asset-types-index)

