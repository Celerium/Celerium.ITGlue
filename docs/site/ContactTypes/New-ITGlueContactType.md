---
external help file: Celerium.ITGlue-help.xml
grand_parent: ContactTypes
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/ContactTypes/New-ITGlueContactType.html
parent: POST
schema: 2.0.0
title: New-ITGlueContactType
---

# New-ITGlueContactType

## SYNOPSIS
Create a new contact type

## SYNTAX

```powershell
New-ITGlueContactType [-Data] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-ITGlueContactType cmdlet creates a new contact type in
your account

## EXAMPLES

### EXAMPLE 1
```powershell
New-ITGlueContactType -Data $JsonBody
```

Creates a new contact type with the specified JSON body

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

[https://celerium.github.io/Celerium.ITGlue/site/ContactTypes/New-ITGlueContactType.html](https://celerium.github.io/Celerium.ITGlue/site/ContactTypes/New-ITGlueContactType.html)

[https://api.itglue.com/developer/#contact-types](https://api.itglue.com/developer/#contact-types)

