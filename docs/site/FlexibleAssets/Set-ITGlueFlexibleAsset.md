---
external help file: Celerium.ITGlue-help.xml
grand_parent: FlexibleAssets
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Set-ITGlueFlexibleAsset.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueFlexibleAsset
---

# Set-ITGlueFlexibleAsset

## SYNOPSIS
Updates one or more flexible assets

## SYNTAX

### Bulk_Update (Default)
```powershell
Set-ITGlueFlexibleAsset -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-ITGlueFlexibleAsset -ID <Int64> -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueFlexibleAsset cmdlet updates one or more flexible assets

Any traits you don't specify will be deleted
Passing a null value will also delete a trait's value

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueFlexibleAsset -id 8675309 -Data $JsonBody
```

Updates a defined flexible asset with the specified JSON body

## PARAMETERS

### -ID
The flexible asset id to update

```yaml
Type: Int64
Parameter Sets: Update
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
Parameter Sets: (All)
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

[https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Set-ITGlueFlexibleAsset.html](https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Set-ITGlueFlexibleAsset.html)

[https://api.itglue.com/developer/#flexible-assets-update](https://api.itglue.com/developer/#flexible-assets-update)

