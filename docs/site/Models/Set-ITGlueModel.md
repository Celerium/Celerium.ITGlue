---
external help file: Celerium.ITGlue-help.xml
grand_parent: Models
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Models/Set-ITGlueModel.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueModel
---

# Set-ITGlueModel

## SYNOPSIS
Updates one or more models

## SYNTAX

### Bulk_Update (Default)
```powershell
Set-ITGlueModel [-FilterID <Int64>] -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-ITGlueModel [-ManufacturerID <Int64>] -ID <Int64> -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueModel cmdlet updates an existing model or
set of models in your account

Bulk updates using a nested relationships route are not supported

Returns 422 Bad Request error if trying to update an externally synced record

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueModel -id 8675309 -Data $JsonObject
```

Updates the defined model with the specified JSON object

## PARAMETERS

### -ManufacturerID
Update models under the defined manufacturer id

```yaml
Type: Int64
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
Update a model by id

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

### -FilterID
Filter models by id

```yaml
Type: Int64
Parameter Sets: Bulk_Update
Aliases:

Required: False
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

[https://celerium.github.io/Celerium.ITGlue/site/Models/Get-ITGlueModel.html](https://celerium.github.io/Celerium.ITGlue/site/Models/Get-ITGlueModel.html)

[https://api.itglue.com/developer/#models-update](https://api.itglue.com/developer/#models-update)

