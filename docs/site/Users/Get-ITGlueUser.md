---
external help file: Celerium.ITGlue-help.xml
grand_parent: Users
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Users/Get-ITGlueUser.html
parent: GET
schema: 2.0.0
title: Get-ITGlueUser
---

# Get-ITGlueUser

## SYNOPSIS
List or show all users

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueUser [-FilterID <Int64>] [-FilterName <String>] [-FilterEmail <String>] [-FilterRoleName <String>]
 [-FilterSalesForceID <Int64>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>] [-AllResults]
 [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueUser -ID <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueUser cmdlet returns a list of the users
or the details of a single user in your account

This function can call the following endpoints:
    Index = /users

    Show =  /users/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueUser
```

Returns the first 50 user results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueUser -ID 8765309
```

Returns the user with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueUser -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for users
in your ITGlue account

## PARAMETERS

### -FilterID
Filter by user ID

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
Filter by user name

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

### -FilterEmail
Filter by user email address

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

### -FilterRoleName
Filter by a users role

Allowed values:
    'Administrator', 'Manager', 'Editor', 'Creator', 'Lite', 'Read-only'

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

### -FilterSalesForceID
Filter by Salesforce ID

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
'name', 'email', 'reputation', 'id', 'created_at', 'updated-at',
'-name', '-email', '-reputation', '-id', '-created_at', '-updated-at'

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
Get a user by id

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

[https://celerium.github.io/Celerium.ITGlue/site/Users/Get-ITGlueUser.html](https://celerium.github.io/Celerium.ITGlue/site/Users/Get-ITGlueUser.html)

[https://api.itglue.com/developer/#accounts-users-index](https://api.itglue.com/developer/#accounts-users-index)

