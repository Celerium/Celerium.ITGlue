---
external help file: Celerium.ITGlue-help.xml
grand_parent: Attachments
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Attachments/New-ITGlueAttachment.html
parent: POST
schema: 2.0.0
title: New-ITGlueAttachment
---

# New-ITGlueAttachment

## SYNOPSIS
Adds an attachment to one or more assets

## SYNTAX

```powershell
New-ITGlueAttachment [-ResourceType] <String> [-ResourceID] <Int64> [-Data] <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-ITGlueAttachment cmdlet adds an attachment
to one or more assets

Attachments are uploaded by including media data on the asset the attachment
is associated with.
Attachments can be encoded and passed in JSON format for
direct upload, in which case the file has to be strict encoded

Note that the name of the attachment will be taken from the file_name attribute
placed in the JSON body

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
New-ITGlueAttachment -ResourceType passwords -ResourceID 8675309 -Data $JsonBody
```

Creates an attachment to a password with the defined id using the structured JSON object

## PARAMETERS

### -ResourceType
The resource type of the parent resource

Allowed values:
'checklists', 'checklist_templates', 'configurations', 'contacts', 'documents',
'domains', 'locations', 'passwords', 'ssl_certificates', 'flexible_assets', 'tickets'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceID
The resource id of the parent resource

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

### -Data
JSON body depending on bulk changes or not

Do NOT include the "Data" property in the JSON object as this is handled
by the Invoke-ITGlueRequest function

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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

[https://celerium.github.io/Celerium.ITGlue/site/Attachments/New-ITGlueAttachment.html](https://celerium.github.io/Celerium.ITGlue/site/Attachments/New-ITGlueAttachment.html)

[https://api.itglue.com/developer/#attachments-create](https://api.itglue.com/developer/#attachments-create)

