---
external help file: Celerium.ITGlue-help.xml
grand_parent: Checklists
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Checklists/Get-ITGlueChecklist.html
parent: GET
schema: 2.0.0
title: Get-ITGlueChecklist
---

# Get-ITGlueChecklist

## SYNOPSIS
List or show all checklists in your account

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueChecklist [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterOrganizationID <Int64>]
 [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>] [-Include <String>] [-AllResults]
 [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueChecklist [-OrganizationID <Int64>] -ID <Int64> [-Include <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueChecklist cmdlet returns a list and or
shows all checklists in your account or a specific organization

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueChecklist
```

Returns the first 50 checklists results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueChecklist -ID 8765309
```

Returns the checklists with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueChecklist -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for checklists
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

### -ID
A valid checklist id

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

### -FilterID
Filter by checklists id

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

### -FilterOrganizationID
Filter organization by id

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
'completed', 'created_at', 'updated_at',
'-completed', '-created_at', '-updated_at'

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

### -Include
Include additional items from a checklist

Allowed values: Index endpoint
attachments, checklist_tasks, user_resource_accesses, group_resource_accesses

Allowed values: Show endpoint
attachments, checklist_tasks, user_resource_accesses, group_resource_accesses,
recent_versions, related_items, authorized_users

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

[https://celerium.github.io/Celerium.ITGlue/site/Checklists/Get-ITGlueChecklist.html](https://celerium.github.io/Celerium.ITGlue/site/Checklists/Get-ITGlueChecklist.html)

[https://api.itglue.com/developer/#checklists](https://api.itglue.com/developer/#checklists)

