---
external help file: Celerium.ITGlue-help.xml
grand_parent: DocumentFolders
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/Remove-ITGlueDocumentFolder.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueDocumentFolder
---

# Remove-ITGlueDocumentFolder

## SYNOPSIS
Deletes a document folder

## SYNTAX

### Bulk_Destroy (Default)
```powershell
Remove-ITGlueDocumentFolder -OrganizationID <Int64> -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Destroy
```powershell
Remove-ITGlueDocumentFolder -OrganizationID <Int64> -ID <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueDocumentFolder cmdlet
deletes a document folder

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueDocumentFolder -ID 8675309
```

Deletes the defined document folder

### EXAMPLE 2
```powershell
Remove-ITGlueDocumentFolder -OrganizationID 8675309 -Data $JsonBody
```

Deletes the defined document folder in the specified organization with the structured
JSON object

## PARAMETERS

### -OrganizationID
The organization id to create the document in

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

### -ID
Document ID

```yaml
Type: Int64
Parameter Sets: Destroy
Aliases:

Required: True
Position: Named
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
Parameter Sets: Bulk_Destroy
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

[https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/Remove-ITGlueDocumentFolder.html](https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/Remove-ITGlueDocumentFolder.html)

[https://api.itglue.com/developer/#document-folders](https://api.itglue.com/developer/#document-folders)

