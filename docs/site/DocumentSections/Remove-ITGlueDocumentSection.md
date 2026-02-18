---
external help file: Celerium.ITGlue-help.xml
grand_parent: DocumentSections
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/Remove-ITGlueDocumentSection.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueDocumentSection
---

# Remove-ITGlueDocumentSection

## SYNOPSIS
Deletes the specified section and its associated polymorphic resource

## SYNTAX

```powershell
Remove-ITGlueDocumentSection -DocumentId <Int64> -Id <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueDocumentSection cmdlet deletes the specified section
and its associated polymorphic resource

Deleting a Gallery or Step section will also delete all associated images

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueDocumentSection -DocumentId 8675309 -Id 12345 -Data $JsonBody
```

Deletes the specified section in the defined document

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

[https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/Remove-ITGlueDocumentSection.html](https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/Remove-ITGlueDocumentSection.html)

[https://api.itglue.com/developer/#documentsections](https://api.itglue.com/developer/#documentsections)

