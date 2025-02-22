---
external help file: Celerium.ITGlue-help.xml
grand_parent: Passwords
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Passwords/Get-ITGluePassword.html
parent: GET
schema: 2.0.0
title: Get-ITGluePassword
---

# Get-ITGluePassword

## SYNOPSIS
List or show all passwords

## SYNTAX

### Index (Default)
```powershell
Get-ITGluePassword [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterName <String>]
 [-FilterOrganizationID <Int64>] [-FilterPasswordCategoryID <Int64>] [-FilterUrl <String>]
 [-FilterCachedResourceName <String>] [-FilterArchived <String>] [-Sort <String>] [-PageNumber <Int64>]
 [-PageSize <Int64>] [-Include <Object>] [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGluePassword [-OrganizationID <Int64>] [-Include <Object>] -ID <Int64> [-ShowPassword <String>]
 [-VersionID <Int64>] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGluePassword cmdlet returns a list of passwords for all organizations,
a specified organization, or the details of a single password

To show passwords, your API key needs to have "Password Access" permission

This function can call the following endpoints:
    Index = /passwords
            /organizations/:organization_id/relationships/passwords

    Show =  /passwords/:id
            /organizations/:organization_id/relationships/passwords/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGluePassword
```

Returns the first 50 password results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGluePassword -ID 8765309
```

Returns the password with the defined id

### EXAMPLE 3
```powershell
Get-ITGluePassword -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for passwords
in your ITGlue account

## PARAMETERS

### -OrganizationID
A valid organization Id in your account

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

### -FilterID
Filter by password id

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

### -FilterName
Filter by password name

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

### -FilterOrganizationID
Filter for passwords by organization id

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

### -FilterPasswordCategoryID
Filter by passwords category id

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

### -FilterUrl
Filter by password url

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

### -FilterCachedResourceName
Filter by a passwords cached resource name

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

### -FilterArchived
Filter for archived

Allowed values: (case-sensitive)
'true', 'false', '0', '1'

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

### -Sort
Sort results by a defined value

Allowed values:
'name', 'username', 'id', 'created_at', 'updated-at',
'-name', '-username', '-id', '-created_at', '-updated-at'

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

### -Include
Include specified assets

Allowed values (Shared):
attachments, group_resource_accesses, network_glue_networks,
rotatable_password,updater,user_resource_accesses

Allowed values (Index-Unique):
N/A

Allowed values (Show-Unique):
recent_versions, related_items, authorized_users

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
Get a password by id

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

### -ShowPassword
Define if the password should be shown or not

By default ITGlue hides the passwords from the returned data

Allowed values: (case-sensitive)
'true', 'false'

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

### -VersionID
Set the password's version ID to return it's revision

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

[https://celerium.github.io/Celerium.ITGlue/site/Passwords/Get-ITGluePassword.html](https://celerium.github.io/Celerium.ITGlue/site/Passwords/Get-ITGluePassword.html)

[https://api.itglue.com/developer/#passwords-index](https://api.itglue.com/developer/#passwords-index)

