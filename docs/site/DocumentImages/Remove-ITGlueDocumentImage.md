---
external help file: Celerium.ITGlue-help.xml
grand_parent: DocumentImages
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/DocumentImages/Remove-ITGlueDocumentImage.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueDocumentImage
---

# Remove-ITGlueDocumentImage

## SYNOPSIS
Deletes the specified document image and all its size variants

## SYNTAX

```powershell
Remove-ITGlueDocumentImage -Id <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueDocumentImage cmdlet deletes the specified document image
and all its size variants

Deleting an image that is referenced in document content (as an inline image) will not
automatically remove the \<img\> tags from the content
The inline image validation will remove broken image references on the next content save

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueDocumentImage -ID 12345
```

Deletes the image with the specified ID

## PARAMETERS

### -Id
Image id

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

[https://celerium.github.io/Celerium.ITGlue/site/DocumentImages/Remove-ITGlueDocumentImage.html](https://celerium.github.io/Celerium.ITGlue/site/DocumentImages/Remove-ITGlueDocumentImage.html)

[https://api.itglue.com/developer/#documentimages](https://api.itglue.com/developer/#documentimages)

