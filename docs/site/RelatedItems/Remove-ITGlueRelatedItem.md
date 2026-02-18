---
external help file: Celerium.ITGlue-help.xml
grand_parent: RelatedItems
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/RelatedItems/Remove-ITGlueRelatedItem.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueRelatedItem
---

# Remove-ITGlueRelatedItem

## SYNOPSIS
Deletes one or more related items

## SYNTAX

```powershell
Remove-ITGlueRelatedItem [-ResourceType] <String> [-ResourceID] <Int64> [-Data] <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueRelatedItem cmdlet deletes one or more specified
related items

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueRelatedItem -ResourceType passwords -ResourceID 8675309 -Data $JsonBody
```

Deletes the defined related item on the defined resource with the structured
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
The id of the related item

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

[https://celerium.github.io/Celerium.ITGlue/site/RelatedItems/Remove-ITGlueRelatedItem.html](https://celerium.github.io/Celerium.ITGlue/site/RelatedItems/Remove-ITGlueRelatedItem.html)

[https://api.itglue.com/developer/#related-items](https://api.itglue.com/developer/#related-items)

