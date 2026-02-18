---
external help file: Celerium.ITGlue-help.xml
grand_parent: UserMetrics
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/UserMetrics/Get-ITGlueUserMetric.html
parent: GET
schema: 2.0.0
title: Get-ITGlueUserMetric
---

# Get-ITGlueUserMetric

## SYNOPSIS
Lists all user metrics

## SYNTAX

```powershell
Get-ITGlueUserMetric [-FilterUserID <Int64>] [-FilterOrganizationID <Int64>] [-FilterResourceType <String>]
 [-FilterDate <String>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>] [-AllResults]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueUserMetric cmdlet lists all user metrics

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueUserMetric
```

Returns the first 50 user metric results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueUserMetric -FilterUserID 12345
```

Returns the user metric for the user with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueUserMetric -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for user metrics
in your ITGlue account

## PARAMETERS

### -FilterUserID
Filter by user id

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

### -FilterOrganizationID
Filter for users metrics by organization id

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

### -FilterResourceType
Filter for user metrics by resource type

Example:
    'Configurations','Passwords','Active Directory'

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

### -FilterDate
Filter for users metrics by a date range

The dates are UTC

The specified string must be a date range and comma-separated start_date, end_date

Use * for unspecified start_date or end_date

Date ranges longer than a week may be disallowed for performance reasons

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

### -Sort
Sort results by a defined value

Allowed values:
'id', 'created', 'viewed', 'edited', 'deleted', 'date',
'-id', '-created', '-viewed', '-edited', '-deleted', '-date'

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

### -PageNumber
Return results starting from the defined number

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

### -PageSize
Number of results to return per page

The maximum number of page results that can be
requested is 1000

```yaml
Type: Int32
Parameter Sets: (All)
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
Parameter Sets: (All)
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

[https://celerium.github.io/Celerium.ITGlue/site/UserMetrics/Get-ITGlueUserMetric.html](https://celerium.github.io/Celerium.ITGlue/site/UserMetrics/Get-ITGlueUserMetric.html)

[https://api.itglue.com/developer/#accounts-user-metrics-daily](https://api.itglue.com/developer/#accounts-user-metrics-daily)

