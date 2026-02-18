---
external help file: Celerium.ITGlue-help.xml
grand_parent: DocumentSections
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/Get-ITGlueDocumentSection.html
parent: GET
schema: 2.0.0
title: Get-ITGlueDocumentSection
---

# Get-ITGlueDocumentSection

## SYNOPSIS
Returns a list of sections for the specified document

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueDocumentSection -DocumentId <Int64> [-FilterId <Int64>] [-FilterResourceType <String>]
 [-FilterDocumentID <Int64>] [-Sort <String>] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueDocumentSection -DocumentId <Int64> -Id <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueDocumentSection cmdlet returns a list of sections
for the specified document, ordered by sort

Sections are polymorphic and contain different attributes based on resource_type

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueDocumentSection -DocumentId 8765309
```

Returns all the document sections for the document with the defined id

### EXAMPLE 2
```powershell
Get-ITGlueDocumentSection -DocumentId 123456 -ID 8765309
```

Returns the defined document sections for the document with the defined id

## PARAMETERS

### -DocumentId
A document ID

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

### -FilterId
Filter section ID

```yaml
Type: Int64
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterResourceType
Filter document ID

Document::Text - Rich text content
Document::Heading - Heading with level (1-6)
Document::Gallery - Image gallery container
Document::Step - Procedural step with optional duration and gallery

```yaml
Type: String
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterDocumentID
Filter document ID

```yaml
Type: Int64
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sort
Sort sections

Allowed values:
'sort', 'id', 'created_at', 'updated_at'
'-sort', '-id', '-created_at', '-updated_at'

```yaml
Type: String
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Get a document by id

```yaml
Type: Int64
Parameter Sets: Show
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/Get-ITGlueDocumentSection.html](https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/Get-ITGlueDocumentSection.html)

[https://api.itglue.com/developer/#documentsections](https://api.itglue.com/developer/#documentsections)

