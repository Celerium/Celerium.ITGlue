---
external help file: Celerium.ITGlue-help.xml
grand_parent: Documents
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Documents/Publish-ITGlueDocument.html
parent: PATCH
schema: 2.0.0
title: Publish-ITGlueDocument
---

# Publish-ITGlueDocument

## SYNOPSIS
Publishes a document

## SYNTAX

```powershell
Publish-ITGlueDocument [-OrganizationID <Int64>] -ID <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Publish-ITGlueDocument cmdlet publishes a document

## EXAMPLES

### EXAMPLE 1
```powershell
Publish-ITGlueDocument -ID 8675309
```

Publishes the defined document

## PARAMETERS

### -OrganizationID
The organization id to create the document in

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
Document ID

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
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

[https://celerium.github.io/Celerium.ITGlue/site/Documents/Publish-ITGlueDocument.html](https://celerium.github.io/Celerium.ITGlue/site/Documents/Publish-ITGlueDocument.html)

[https://api.itglue.com/developer/#documents](https://api.itglue.com/developer/#documents)

