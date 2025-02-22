---
external help file: Celerium.ITGlue-help.xml
grand_parent: Models
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Models/New-ITGlueModel.html
parent: POST
schema: 2.0.0
title: New-ITGlueModel
---

# New-ITGlueModel

## SYNOPSIS
Creates one or more models

## SYNTAX

```powershell
New-ITGlueModel [[-ManufacturerID] <Int64>] [-Data] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-ITGlueModel cmdlet creates one or more models
in your account or for a particular manufacturer

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
New-ITGlueModel -Data $JsonObject
```

Creates a new model with the specified JSON object

### EXAMPLE 2
```powershell
New-ITGlueModel -ManufacturerID 8675309 -Data $JsonObject
```

Creates a new model associated to the defined model with the
structured JSON object

## PARAMETERS

### -ManufacturerID
The manufacturer id to create the model under

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

[https://celerium.github.io/Celerium.ITGlue/site/Models/Get-ITGlueModel.html](https://celerium.github.io/Celerium.ITGlue/site/Models/Get-ITGlueModel.html)

[https://api.itglue.com/developer/#models-create](https://api.itglue.com/developer/#models-create)

