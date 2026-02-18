---
external help file: Celerium.ITGlue-help.xml
grand_parent: PasswordCategories
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/PasswordCategories/Set-ITGluePasswordCategory.html
parent: PATCH
schema: 2.0.0
title: Set-ITGluePasswordCategory
---

# Set-ITGluePasswordCategory

## SYNOPSIS
Updates a password category

## SYNTAX

```powershell
Set-ITGluePasswordCategory [-ID] <Int64> [-Data] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGluePasswordCategory cmdlet updates a password category
in your account

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGluePasswordCategory -id 8675309 -Data $JsonBody
```

Updates the defined password category with the specified JSON body

## PARAMETERS

### -ID
Update a password category by id

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

[https://celerium.github.io/Celerium.ITGlue/site/PasswordCategories/Set-ITGluePasswordCategory.html](https://celerium.github.io/Celerium.ITGlue/site/PasswordCategories/Set-ITGluePasswordCategory.html)

[https://api.itglue.com/developer/#password-categories](https://api.itglue.com/developer/#password-categories)

