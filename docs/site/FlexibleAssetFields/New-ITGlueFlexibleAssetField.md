---
external help file: Celerium.ITGlue-help.xml
grand_parent: FlexibleAssetFields
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/New-ITGlueFlexibleAssetField.html
parent: POST
schema: 2.0.0
title: New-ITGlueFlexibleAssetField
---

# New-ITGlueFlexibleAssetField

## SYNOPSIS
Creates one or more flexible asset fields

## SYNTAX

```powershell
New-ITGlueFlexibleAssetField [[-FlexibleAssetTypeID] <Int64>] [-Data] <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-ITGlueFlexibleAssetField cmdlet creates one or more
flexible asset field for a particular flexible asset type

## EXAMPLES

### EXAMPLE 1
```powershell
New-ITGlueFlexibleAssetField -FlexibleAssetTypeID 8675309 -Data $JsonBody
```

Creates a new flexible asset field for the defined id with the structured
JSON object

## PARAMETERS

### -FlexibleAssetTypeID
The flexible asset type id to create a new field in

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
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

[https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/New-ITGlueFlexibleAssetField.html](https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/New-ITGlueFlexibleAssetField.html)

[https://api.itglue.com/developer/#flexible-asset-fields](https://api.itglue.com/developer/#flexible-asset-fields)

