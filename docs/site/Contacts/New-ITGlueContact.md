---
external help file: Celerium.ITGlue-help.xml
grand_parent: Contacts
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Contacts/New-ITGlueContact.html
parent: POST
schema: 2.0.0
title: New-ITGlueContact
---

# New-ITGlueContact

## SYNOPSIS
Creates one or more contacts

## SYNTAX

```powershell
New-ITGlueContact [[-OrganizationID] <Int64>] [-Data] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-ITGlueContact cmdlet creates one or more contacts
under the organization specified

Can also be used create multiple new contacts in bulk

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
New-ITGlueContact -OrganizationID 8675309 -Data $JsonObject
```

Create a new contact in the defined organization with the structured
JSON object

## PARAMETERS

### -OrganizationID
The organization id to create the contact(s) in

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

[https://celerium.github.io/Celerium.ITGlue/site/Contacts/New-ITGlueContact.html](https://celerium.github.io/Celerium.ITGlue/site/Contacts/New-ITGlueContact.html)

[https://api.itglue.com/developer/#contacts-create](https://api.itglue.com/developer/#contacts-create)

