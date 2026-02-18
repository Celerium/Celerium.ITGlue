---
external help file: Celerium.ITGlue-help.xml
grand_parent: Exports
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Exports/Get-ITGlueExport.html
parent: GET
schema: 2.0.0
title: Get-ITGlueExport
---

# Get-ITGlueExport

## SYNOPSIS
List or show all exports

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueExport [-FilterID <String>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>] [-AllResults]
 [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueExport -ID <Int64> [-Include <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueExport cmdlet returns a list of exports
or the details of a single export in your account

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueExport
```

Returns the first 50 exports from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueExport -ID 8765309
```

Returns the export with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueExport -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for exports
in your ITGlue account

## PARAMETERS

### -FilterID
Filter by a export id

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
'created_at', 'updated_at',
'-created_at', '-updated_at'

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
Get a export by id

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
Include additional information

Allowed values:
'.'

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

[https://celerium.github.io/Celerium.ITGlue/site/Exports/Get-ITGlueExport.html](https://celerium.github.io/Celerium.ITGlue/site/Exports/Get-ITGlueExport.html)

[https://api.itglue.com/developer/#exports](https://api.itglue.com/developer/#exports)

