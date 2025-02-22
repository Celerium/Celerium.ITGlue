---
external help file: Celerium.ITGlue-help.xml
grand_parent: FlexibleAssetTypes
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetTypes/Set-ITGlueFlexibleAssetType.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueFlexibleAssetType
---

# Set-ITGlueFlexibleAssetType

## SYNOPSIS
Updates a flexible asset type

## SYNTAX

```powershell
Set-ITGlueFlexibleAssetType [-ID] <Int64> [-Data] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueFlexibleAssetType cmdlet updates the details of an
existing flexible asset type in your account

Any attributes you don't specify will remain unchanged

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueFlexibleAssetType -id 8765309 -Data $JsonObject
```

Update a flexible asset type with the specified JSON object

## PARAMETERS

### -ID
A valid flexible asset id in your account

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

[https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetTypes/Set-ITGlueFlexibleAssetType.html](https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetTypes/Set-ITGlueFlexibleAssetType.html)

[https://api.itglue.com/developer/#flexible-asset-types-update](https://api.itglue.com/developer/#flexible-asset-types-update)

