---
external help file: Celerium.ITGlue-help.xml
grand_parent: ContactTypes
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/ContactTypes/Set-ITGlueContactType.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueContactType
---

# Set-ITGlueContactType

## SYNOPSIS
Updates a contact type

## SYNTAX

```powershell
Set-ITGlueContactType [-ID] <Int64> [-Data] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueContactType cmdlet updates a contact type
in your account

Returns 422 Bad Request error if trying to update an externally synced record

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueContactType -id 8675309 -Data $JsonBody
```

Update the defined contact type with the specified JSON body

## PARAMETERS

### -ID
Define the contact type id to update

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

[https://celerium.github.io/Celerium.ITGlue/site/ContactTypes/Set-ITGlueContactType.html](https://celerium.github.io/Celerium.ITGlue/site/ContactTypes/Set-ITGlueContactType.html)

[https://api.itglue.com/developer/#contact-types-update](https://api.itglue.com/developer/#contact-types-update)

