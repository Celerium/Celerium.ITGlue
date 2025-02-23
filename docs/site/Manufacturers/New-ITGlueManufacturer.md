---
external help file: Celerium.ITGlue-help.xml
grand_parent: Manufacturers
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Manufacturers/New-ITGlueManufacturer.html
parent: POST
schema: 2.0.0
title: New-ITGlueManufacturer
---

# New-ITGlueManufacturer

## SYNOPSIS
Create a new manufacturer

## SYNTAX

```powershell
New-ITGlueManufacturer [-Data] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-ITGlueManufacturer cmdlet creates a new manufacturer

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
New-ITGlueManufacturer -Data $JsonBody
```

Creates a new manufacturers with the specified JSON body

## PARAMETERS

### -Data
JSON body depending on bulk changes or not

Do NOT include the "Data" property in the JSON object as this is handled
by the Invoke-ITGlueRequest function

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

[https://celerium.github.io/Celerium.ITGlue/site/Manufacturers/New-ITGlueManufacturer.html](https://celerium.github.io/Celerium.ITGlue/site/Manufacturers/New-ITGlueManufacturer.html)

[https://api.itglue.com/developer/#manufacturers-create](https://api.itglue.com/developer/#manufacturers-create)

