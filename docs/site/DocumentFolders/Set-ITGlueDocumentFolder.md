---
external help file: Celerium.ITGlue-help.xml
grand_parent: DocumentFolders
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/Set-ITGlueDocumentFolder.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueDocumentFolder
---

# Set-ITGlueDocumentFolder

## SYNOPSIS
Updates one or more document folders

## SYNTAX

### BulkUpdate (Default)
```powershell
Set-ITGlueDocumentFolder -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-ITGlueDocumentFolder -OrganizationID <Int64> -ID <Int64> [-NewName <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueDocumentFolder cmdlet updates one or
more existing document folders

Any attributes you don't specify will remain unchanged

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueDocumentFolder -ID 8675309 -Data $JsonBody
```

Updates the defined document folder with the specified JSON body

## PARAMETERS

### -OrganizationID
A valid organization Id in your Account

```yaml
Type: Int64
Parameter Sets: Update
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ID
The document folder id to update

```yaml
Type: Int64
Parameter Sets: Update
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
The new name of the document folder

```yaml
Type: String
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Data
JSON body depending on bulk changes or not

Do NOT include the "Data" property in the JSON object as this is handled
by the Invoke-ITGlueRequest function

```yaml
Type: Object
Parameter Sets: BulkUpdate
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

[https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/Set-ITGlueDocumentFolder.html](https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/Set-ITGlueDocumentFolder.html)

[https://api.itglue.com/developer/#document-folders](https://api.itglue.com/developer/#document-folders)

