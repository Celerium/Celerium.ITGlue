---
external help file: Celerium.ITGlue-help.xml
grand_parent: Attachments
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Attachments/Set-ITGlueAttachment.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueAttachment
---

# Set-ITGlueAttachment

## SYNOPSIS
Updates the details of an existing attachment

## SYNTAX

```powershell
Set-ITGlueAttachment [-ResourceType] <String> [-ResourceID] <Int64> [-ID] <Int64> [-Data] <Object> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueAttachment cmdlet updates the details of
an existing attachment

Only the attachment name that is displayed on the asset view
screen can be changed

The original file_name can't be changed

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueAttachment -ResourceType passwords -ResourceID 8675309 -id 8675309 -Data $JsonObject
```

Updates an attachment to a password with the defined id using the structured JSON object

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

### -ID
The resource id of the existing attachment

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
Position: 4
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

[https://celerium.github.io/Celerium.ITGlue/site/Attachments/Set-ITGlueAttachment.html](https://celerium.github.io/Celerium.ITGlue/site/Attachments/Set-ITGlueAttachment.html)

[https://api.itglue.com/developer/#attachments-update](https://api.itglue.com/developer/#attachments-update)

