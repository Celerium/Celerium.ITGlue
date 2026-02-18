---
external help file: Celerium.ITGlue-help.xml
grand_parent: Documents
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Documents/Get-ITGlueDocument.html
parent: GET
schema: 2.0.0
title: Get-ITGlueDocument
---

# Get-ITGlueDocument

## SYNOPSIS
Returns a list of documents

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueDocument -OrganizationID <Int64> [-FilterDocumentFolderId <Int64>] [-PageNumber <Int64>]
 [-PageSize <Int32>] [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueDocument [-OrganizationID <Int64>] -ID <Int64> [-Include <Int64>] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueDocument cmdlet returns a list of documents
or return complete information of a document including its sections

Index
Returns only root level documents when document_folder_id is not specified

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueDocument
```

Returns the first 50 document results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueDocument -ID 8765309
```

Returns the document with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueDocument -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for documents
in your ITGlue account

## PARAMETERS

### -OrganizationID
A valid organization Id in your account

```yaml
Type: Int64
Parameter Sets: Index
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

```yaml
Type: Int64
Parameter Sets: Show
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -FilterDocumentFolderId
Filter document folder id

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

### -PageNumber
Return results starting from the defined number

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

### -PageSize
Number of results to return per page

The maximum number of page results that can be
requested is 1000

```yaml
Type: Int32
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
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

### -Include
Include additional values

Allowed values:
'attachments', 'related_items'

```yaml
Type: Int64
Parameter Sets: Show
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllResults
Returns all items from an endpoint

This can be used in unison with -PageSize to limit the number of
sequential requests to the API

```yaml
Type: SwitchParameter
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: False
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

[https://celerium.github.io/Celerium.ITGlue/site/Documents/Get-ITGlueDocument.html](https://celerium.github.io/Celerium.ITGlue/site/Documents/Get-ITGlueDocument.html)

[https://api.itglue.com/developer/#documents](https://api.itglue.com/developer/#documents)

