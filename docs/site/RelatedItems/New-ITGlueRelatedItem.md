---
external help file: Celerium.ITGlue-help.xml
grand_parent: RelatedItems
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/RelatedItems/New-ITGlueRelatedItem.html
parent: POST
schema: 2.0.0
title: New-ITGlueRelatedItem
---

# New-ITGlueRelatedItem

## SYNOPSIS
Creates one or more related items

## SYNTAX

```powershell
New-ITGlueRelatedItem [-ResourceType] <String> [-ResourceID] <Int64> [-Data] <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-ITGlueRelatedItem cmdlet creates one or more related items

The create action is directional from source item to destination item(s)

The source item is the item that matches the resource_type and resource_id in the URL

The destination item(s) are the items that match the destination_type
and destination_id in the JSON object

## EXAMPLES

### EXAMPLE 1
```powershell
New-ITGlueRelatedItem -ResourceType passwords -ResourceID 8675309 -Data $JsonBody
```

Creates a new related password to the defined resource id with the structured
JSON object

## PARAMETERS

### -ResourceType
The resource type of the parent resource

Allowed values:
'checklists', 'checklist_templates', 'configurations', 'contacts',
'documents', 'domains', 'folders', 'locations', 'passwords', 'ssl_certificates',
'flexible_assets', 'tickets'

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

[https://celerium.github.io/Celerium.ITGlue/site/RelatedItems/New-ITGlueRelatedItem.html](https://celerium.github.io/Celerium.ITGlue/site/RelatedItems/New-ITGlueRelatedItem.html)

[https://api.itglue.com/developer/#related-items](https://api.itglue.com/developer/#related-items)

