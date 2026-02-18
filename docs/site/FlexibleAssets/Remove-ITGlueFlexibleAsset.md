---
external help file: Celerium.ITGlue-help.xml
grand_parent: FlexibleAssets
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Remove-ITGlueFlexibleAsset.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueFlexibleAsset
---

# Remove-ITGlueFlexibleAsset

## SYNOPSIS
Deletes one or more a flexible assets

## SYNTAX

### Destroy (Default)
```powershell
Remove-ITGlueFlexibleAsset -ID <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### BulkDestroy
```powershell
Remove-ITGlueFlexibleAsset -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueFlexibleAsset cmdlet destroys multiple or a single
flexible asset

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueFlexibleAsset -id 8675309
```

Deletes the defined flexible asset

### EXAMPLE 2
```powershell
Remove-ITGlueFlexibleAsset -Data $JsonBody
```

Deletes flexible asset defined in the structured JSON object

## PARAMETERS

### -ID
The flexible asset id to update

```yaml
Type: Int64
Parameter Sets: Destroy
Aliases:

Required: True
Position: Named
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
Parameter Sets: BulkDestroy
Aliases:

Required: True
Position: Named
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

[https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Remove-ITGlueFlexibleAsset.html](https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Remove-ITGlueFlexibleAsset.html)

[https://api.itglue.com/developer/#flexible-assets](https://api.itglue.com/developer/#flexible-assets)

