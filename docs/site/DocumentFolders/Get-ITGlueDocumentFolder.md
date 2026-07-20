---
external help file: Celerium.ITGlue-help.xml
grand_parent: DocumentFolders
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/Get-ITGlueDocumentFolder.html
parent: GET
schema: 2.0.0
title: Get-ITGlueDocumentFolder
---

# Get-ITGlueDocumentFolder

## SYNOPSIS
Returns a list of document folders

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueDocumentFolder -OrganizationID <Int64> [-FilterId <Int64>] [-FilterParentId <Int64>] [-Sort <String>]
 [-PageNumber <Int64>] [-PageSize <Int32>] [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueDocumentFolder -OrganizationID <Int64> -ID <Int64> [-Include <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueDocumentFolder cmdlet returns a list of
document folders

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueDocumentFolder -OrganizationID 8675309
```

Returns the first 50 document folder results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueDocumentFolder -OrganizationID 8675309 -ID 8765309
```

Returns the document folder with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueDocumentFolder -OrganizationID 8675309 -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for document folders
in your ITGlue account

## PARAMETERS

### -OrganizationID
A valid organization Id in your account

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

### -FilterParentId
Filter document folder parent id

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
Sort results by a defined value

Allowed values:
'name', 'created_at', 'updated_at'
'-name', '-created_at', '-updated_at'

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
Get a document folder by id

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

### -Include
Include additional values

Allowed values:
'user_resource_accesses', 'group_resource_accesses', 'authorized_users', 'ancestors'

```yaml
Type: String
Parameter Sets: Show
Aliases:

Required: False
Position: Named
Default value: None
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

[https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/Get-ITGlueDocumentFolder.html](https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/Get-ITGlueDocumentFolder.html)

[https://api.itglue.com/developer/#document-folders](https://api.itglue.com/developer/#document-folders)

