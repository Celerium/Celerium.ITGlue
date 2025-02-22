---
external help file: Celerium.ITGlue-help.xml
grand_parent: FlexibleAssets
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Get-ITGlueFlexibleAsset.html
parent: GET
schema: 2.0.0
title: Get-ITGlueFlexibleAsset
---

# Get-ITGlueFlexibleAsset

## SYNOPSIS
List or show all flexible assets

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueFlexibleAsset -FilterFlexibleAssetTypeID <Int64> [-FilterName <String>]
 [-FilterOrganizationID <Int64>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>] [-Include <String>]
 [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueFlexibleAsset [-Include <String>] -ID <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueFlexibleAsset cmdlet returns a list of flexible assets or
the details of a single flexible assets based on the unique ID of the
flexible asset type

This function can call the following endpoints:
    Index = /flexible_assets

    Show =  /flexible_assets/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueFlexibleAsset -FilterFlexibleAssetTypeID 8765309
```

Returns the first 50 results for the defined flexible asset

### EXAMPLE 2
```powershell
Get-ITGlueFlexibleAsset -FilterFlexibleAssetTypeID 8765309 -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for the defined
flexible asset

## PARAMETERS

### -FilterFlexibleAssetTypeID
Filter by a flexible asset id

This is the flexible assets id number you see in the URL under an organizations

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

### -FilterOrganizationID
Filter by a organization id

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
'name', 'created_at', 'updated_at',
'-name', '-created_at', '-updated_at'

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

Allowed values (Shared):
adapters_resources, attachments, distinct_remote_assets, group_resource_accesses
passwords, user_resource_accesses

Allowed values (Index-Unique):
N/A

Allowed values (Show-Unique):
authorized_users, recent_versions, related_items

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
Get a flexible asset id

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

[https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Get-ITGlueFlexibleAsset.html](https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Get-ITGlueFlexibleAsset.html)

[https://api.itglue.com/developer/#flexible-assets-index](https://api.itglue.com/developer/#flexible-assets-index)

