---
external help file: Celerium.ITGlue-help.xml
grand_parent: DocumentSections
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/Set-ITGlueDocumentSection.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueDocumentSection
---

# Set-ITGlueDocumentSection

## SYNOPSIS
Updates an existing section

## SYNTAX

```powershell
Set-ITGlueDocumentSection -DocumentId <Int64> -Id <Int64> -Data <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueDocumentSection cmdlet updates an existing section

Only attributes specific to the section's resource_type can be updated.
The resource_type itself cannot be changed

A PATCH request does not require all attributes - only those you want to update.
Any attributes you don't specify will remain unchanged

IMPORTANT: The "rendered-content" attribute is READ-ONLY and automatically generated.
Do not attempt to include it in your update requests - it will be ignored.
When updating content,
use only the "content" attribute with your HTML, and the "rendered-content" will be automatically
regenerated with processed inline image URLs

The resource_type attribute determines which type of section is created and
which additional attributes are required

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueDocumentSection -DocumentId 8675309 -Id 12345 -Data $JsonBody
```

Creates a new section in the defined document with the structured
JSON object

## PARAMETERS

### -DocumentId
The document id

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
The id of the section

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

### -Data
JSON body depending on bulk changes or not

Do NOT include the "Data" property in the JSON object as this is handled
by the Invoke-ITGlueRequest function

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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

[https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/Set-ITGlueDocumentSection.html](https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/Set-ITGlueDocumentSection.html)

[https://api.itglue.com/developer/#documentsections](https://api.itglue.com/developer/#documentsections)

