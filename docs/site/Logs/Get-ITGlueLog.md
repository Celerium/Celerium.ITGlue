---
external help file: Celerium.ITGlue-help.xml
grand_parent: Logs
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Logs/Get-ITGlueLog.html
parent: GET
schema: 2.0.0
title: Get-ITGlueLog
---

# Get-ITGlueLog

## SYNOPSIS
Get all activity logs of the account for the most recent 30 days

## SYNTAX

```powershell
Get-ITGlueLog [-FilterCreatedAt <String>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>]
 [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueLog cmdlet gets all activity logs of the account for
the most recent 30 days

IMPORTANT - This endpoint can ONLY get logs from the past 30 days!

This endpoint is limited to 5 pages of results.
If more results are desired,
setting a larger page \[size\] will increase the number of results per page

To iterate over even more results, use filter \[created_at\] (with created_at Sort)
to fetch a subset of results based on timestamp, then use the last timestamp
in the last page the start date in the filter for the next request

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueLog
```

Pulls the first 50 activity logs from the last 30 days with data
being Sorted newest to oldest

### EXAMPLE 2
```powershell
Get-ITGlueLog -sort -created_at
```

Pulls the first 50 activity logs from the last 30 days with data
being Sorted oldest to newest

### EXAMPLE 3
```powershell
Get-ITGlueLog -PageNumber 2
```

Pulls the first 50 activity logs starting from page 2 from the last 30 days
with data being Sorted newest to oldest

## PARAMETERS

### -FilterCreatedAt
Filter logs by a UTC start & end date

Use \`*\` for unspecified start_date\` or \`end_date

The specified string must be a date range and comma-separated as start_date, end_date

Example:
2024-09-23, 2024-09-27

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
'created_at','-created_at'

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

This endpoint is limited to 5 pages of results

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

[https://celerium.github.io/Celerium.ITGlue/site/Logs/Get-ITGlueLog.html](https://celerium.github.io/Celerium.ITGlue/site/Logs/Get-ITGlueLog.html)

[https://api.itglue.com/developer/#logs](https://api.itglue.com/developer/#logs)

