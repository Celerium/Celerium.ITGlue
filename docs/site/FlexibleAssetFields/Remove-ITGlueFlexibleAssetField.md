---
external help file: Celerium.ITGlue-help.xml
grand_parent: FlexibleAssetFields
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/Remove-ITGlueFlexibleAssetField.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueFlexibleAssetField
---

# Remove-ITGlueFlexibleAssetField

## SYNOPSIS
Delete a flexible asset field

## SYNTAX

```powershell
Remove-ITGlueFlexibleAssetField [[-FlexibleAssetTypeID] <Int64>] [-ID] <Int64> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueFlexibleAssetField cmdlet deletes a flexible asset field

Note that this action will cause data loss if the field is already in use

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueFlexibleAssetField -id 8675309
```

Deletes a defined flexible asset field and any data associated to that
field

## PARAMETERS

### -FlexibleAssetTypeID
A flexible asset type Id in your Account

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

### -ID
Id of a flexible asset field

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
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

[https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/Remove-ITGlueFlexibleAssetField.html](https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/Remove-ITGlueFlexibleAssetField.html)

[https://api.itglue.com/developer/#flexible-asset-fields-destroy](https://api.itglue.com/developer/#flexible-asset-fields-destroy)

