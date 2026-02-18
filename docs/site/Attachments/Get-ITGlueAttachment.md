---
external help file: Celerium.ITGlue-help.xml
grand_parent: Attachments
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Attachments/Get-ITGlueAttachment.html
parent: GET
schema: 2.0.0
title: Get-ITGlueAttachment
---

# Get-ITGlueAttachment

## SYNOPSIS
List or show attachments for a resource

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueAttachment -ResourceType <String> -ResourceId <Int64> [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueAttachment -ResourceType <String> -ResourceId <Int64> -Id <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueAttachment cmdlet returns a list and or
shows attachments for a resource

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueAttachment -ResourceType 'checklists' -ResourceId 12345
```

Returns the defined attachments for the parent resource

### EXAMPLE 2
```powershell
Get-ITGlueAttachment -ResourceType 'checklists' -ResourceId 12345 -Id 8765309
```

Returns the defined attachment for the parent resource

## PARAMETERS

### -ResourceType
The resource type of the parent resource

Allowed Values:
'checklists', 'checklist_templates', 'configurations', 'contacts',
'documents', 'domains', 'locations', 'passwords', 'ssl_certificates',
'flexible_assets', 'tickets

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceId
The resource id of the parent resource

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Id
Attachment id

```yaml
Type: Int64
Parameter Sets: Show
Aliases:

Required: True
Position: Named
Default value: 0
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

[https://celerium.github.io/Celerium.ITGlue/site/Attachments/Get-ITGlueAttachment.html](https://celerium.github.io/Celerium.ITGlue/site/Attachments/Get-ITGlueAttachment.html)

[https://api.itglue.com/developer/#attachments](https://api.itglue.com/developer/#attachments)

