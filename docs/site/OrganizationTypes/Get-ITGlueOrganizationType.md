---
external help file: Celerium.ITGlue-help.xml
grand_parent: OrganizationTypes
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/OrganizationTypes/Get-ITGlueOrganizationType.html
parent: GET
schema: 2.0.0
title: Get-ITGlueOrganizationType
---

# Get-ITGlueOrganizationType

## SYNOPSIS
List or show all organization types

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueOrganizationType [-FilterName <String>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>]
 [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueOrganizationType -ID <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueOrganizationType cmdlet returns a list of organization types
or the details of a single organization type in your account

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueOrganizationType
```

Returns the first 50 organization types from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueOrganizationType -ID 8765309
```

Returns the organization type with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueOrganizationType -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for organization types
in your ITGlue account

## PARAMETERS

### -FilterName
Filter by organization type name

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
'name', 'id', 'created_at', 'updated_at',
'-name', '-id', '-created_at', '-updated_at'

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
Get a organization type by id

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

[https://celerium.github.io/Celerium.ITGlue/site/OrganizationTypes/Get-ITGlueOrganizationType.html](https://celerium.github.io/Celerium.ITGlue/site/OrganizationTypes/Get-ITGlueOrganizationType.html)

[https://api.itglue.com/developer/#organization-types](https://api.itglue.com/developer/#organization-types)

