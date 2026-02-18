---
external help file: Celerium.ITGlue-help.xml
grand_parent: Documents
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Documents/Remove-ITGlueDocument.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueDocument
---

# Remove-ITGlueDocument

## SYNOPSIS
Deletes a new document

## SYNTAX

### Bulk_Destroy (Default)
```powershell
Remove-ITGlueDocument [-OrganizationID <Int64>] -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Destroy
```powershell
Remove-ITGlueDocument -ID <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueDocument cmdlet deletes a new document

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueDocument -ID 8675309
```

Deletes the defined document

### EXAMPLE 2
```powershell
Remove-ITGlueDocument -OrganizationID 8675309 -Data $JsonBody
```

Deletes the defined document in the specified organization with the structured
JSON object

## PARAMETERS

### -OrganizationID
The organization id to create the document in

```yaml
Type: Int64
Parameter Sets: Bulk_Destroy
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

[https://celerium.github.io/Celerium.ITGlue/site/Documents/Remove-ITGlueDocument.html](https://celerium.github.io/Celerium.ITGlue/site/Documents/Remove-ITGlueDocument.html)

[https://api.itglue.com/developer/#documents](https://api.itglue.com/developer/#documents)

