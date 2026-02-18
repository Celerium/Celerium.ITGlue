---
external help file: Celerium.ITGlue-help.xml
grand_parent: PasswordFolders
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/Get-ITGluePasswordFolder.html
parent: GET
schema: 2.0.0
title: Get-ITGluePasswordFolder
---

# Get-ITGluePasswordFolder

## SYNOPSIS
List or show password folders

## SYNTAX

### Index (Default)
```powershell
Get-ITGluePasswordFolder -OrganizationID <Int64> [-FilterID <Int64>] [-Sort <String>] [-PageNumber <Int64>]
 [-PageSize <Int64>] [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGluePasswordFolder -OrganizationID <Int64> -ID <Int64> [-Include <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGluePasswordFolder cmdlet returns list of password folders

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGluePasswordFolder -OrganizationID 12345
```

Returns the first 50 password folder results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGluePasswordFolder -OrganizationID 12345 -ID 8765309
```

Returns the password folder with the defined id

### EXAMPLE 3
```powershell
Get-ITGluePasswordFolder -OrganizationID 12345 -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for password folders
for the defined organization in your ITGlue account

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
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterID
Filter by password folder id

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
'created_at', 'updated-at',
'-created_at', '-updated-at'

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
Type: Int64
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
Get a password folder by id

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
Include specified assets

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

[https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/Get-ITGluePasswordFolder.html](https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/Get-ITGluePasswordFolder.html)

[https://api.itglue.com/developer/#password-folders](https://api.itglue.com/developer/#password-folders)

