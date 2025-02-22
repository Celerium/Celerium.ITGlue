---
external help file: Celerium.ITGlue-help.xml
grand_parent: Groups
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Groups/Get-ITGlueGroup.html
parent: GET
schema: 2.0.0
title: Get-ITGlueGroup
---

# Get-ITGlueGroup

## SYNOPSIS
List or show all groups

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueGroup [-FilterName <String>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>]
 [-Include <String>] [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueGroup -ID <Int64> [-Include <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueGroup cmdlet returns a list of groups or the
details of a single group in your account

This function can call the following endpoints:
    Index = /groups

    Show =  /groups/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueGroup
```

Returns the first 50 group results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueGroup -ID 8765309
```

Returns the group with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueGroup -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for groups
in your ITGlue account

## PARAMETERS

### -FilterName
Filter by a group name

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
Get a group by id

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
Include other items with groups

Allowed values:
'users'

```yaml
Type: String
Parameter Sets: (All)
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

[https://celerium.github.io/Celerium.ITGlue/site/Groups/Get-ITGlueGroup.html](https://celerium.github.io/Celerium.ITGlue/site/Groups/Get-ITGlueGroup.html)

[https://api.itglue.com/developer/#groups-index](https://api.itglue.com/developer/#groups-index)

