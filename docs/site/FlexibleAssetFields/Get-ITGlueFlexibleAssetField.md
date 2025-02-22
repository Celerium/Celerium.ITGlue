---
external help file: Celerium.ITGlue-help.xml
grand_parent: FlexibleAssetFields
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/Get-ITGlueFlexibleAssetField.html
parent: GET
schema: 2.0.0
title: Get-ITGlueFlexibleAssetField
---

# Get-ITGlueFlexibleAssetField

## SYNOPSIS
List or show all flexible assets fields

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueFlexibleAssetField -FlexibleAssetTypeID <Int64> [-FilterID <Int64>] [-Sort <String>]
 [-PageNumber <Int64>] [-PageSize <Int32>] [-Include <String>] [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueFlexibleAssetField [-FlexibleAssetTypeID <Int64>] -ID <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueFlexibleAssetField cmdlet lists or shows all flexible asset fields
for a particular flexible asset type

This function can call the following endpoints:
    Index = /flexible_asset_types/:flexible_asset_type_id/relationships/flexible_asset_fields

    Show =  /flexible_asset_fields/:id
            /flexible_asset_types/:flexible_asset_type_id/relationships/flexible_asset_fields/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueFlexibleAssetField -FlexibleAssetTypeID 12345
```

Returns all the fields in a flexible asset with the defined id

### EXAMPLE 2
```powershell
Get-ITGlueFlexibleAssetField -ID 8765309
```

Returns single field in a flexible asset with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueFlexibleAssetField -FlexibleAssetTypeID 12345 -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for flexible asset fields
from the defined id

## PARAMETERS

### -FlexibleAssetTypeID
A valid Flexible asset Id in your Account

```yaml
Type: Int64
Parameter Sets: Index
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Int64
Parameter Sets: Show
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterID
Filter by a flexible asset field id

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
'created_at', 'updated_at',
'-created_at', '-updated_at'

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
A valid Flexible asset type Id in your Account

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

### -Include
Include specified assets

Allowed values:
remote_asset_field

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

[https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/Get-ITGlueFlexibleAssetField.html](https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/Get-ITGlueFlexibleAssetField.html)

[https://api.itglue.com/developer/#flexible-asset-fields-index](https://api.itglue.com/developer/#flexible-asset-fields-index)

