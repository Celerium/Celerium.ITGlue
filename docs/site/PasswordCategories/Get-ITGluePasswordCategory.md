---
external help file: Celerium.ITGlue-help.xml
grand_parent: PasswordCategories
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/PasswordCategories/Get-ITGluePasswordCategory.html
parent: GET
schema: 2.0.0
title: Get-ITGluePasswordCategory
---

# Get-ITGluePasswordCategory

## SYNOPSIS
List or show all password categories

## SYNTAX

### Index (Default)
```powershell
Get-ITGluePasswordCategory [-FilterName <String>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>]
 [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGluePasswordCategory -ID <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGluePasswordCategory cmdlet returns a list of password categories
or the details of a single password category in your account

This function can call the following endpoints:
    Index = /password_categories

    Show =  /password_categories/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGluePasswordCategory
```

Returns the first 50 password category results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGluePasswordCategory -ID 8765309
```

Returns the password category with the defined id

### EXAMPLE 3
```powershell
Get-ITGluePasswordCategory -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for password categories
in your ITGlue account

## PARAMETERS

### -FilterName
Filter by a password category name

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
'name', 'created_at', 'updated_at',
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
Get a password category by id

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

[https://celerium.github.io/Celerium.ITGlue/site/PasswordCategories/Get-ITGluePasswordCategory.html](https://celerium.github.io/Celerium.ITGlue/site/PasswordCategories/Get-ITGluePasswordCategory.html)

[https://api.itglue.com/developer/#password-categories-index](https://api.itglue.com/developer/#password-categories-index)

