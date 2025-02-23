---
external help file: Celerium.ITGlue-help.xml
grand_parent: CopilotSmartAssist
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/CopilotSmartAssist/Get-ITGlueCopilotSmartAssistDocument.html
parent: GET
schema: 2.0.0
title: Get-ITGlueCopilotSmartAssistDocument
---

# Get-ITGlueCopilotSmartAssistDocument

## SYNOPSIS
Gets one or more documents found in the ITGlue Copilot Smart Assist

## SYNTAX

```powershell
Get-ITGlueCopilotSmartAssistDocument [-FilterType <String>] [-FilterOrganizationID <Int64>]
 [-PageNumber <Int64>] [-PageSize <Int32>] [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueCopilotSmartAssistDocument cmdlet gets one or more documents found
in the ITGlue Copilot Smart Assist such as 'Documents not viewed in X amount of time',
'Documents that were never viewed', 'Documents that are expired', and 'Duplicate documents'

Present a list of 'Most Used' documents to facilitate best practices across organizations
(when filter by type is not provided)

This function can call the following endpoints:
    Index = /copilot_smart_assist/documents

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueCopilotSmartAssistDocument
```

Returns the first 50 documents from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueCopilotSmartAssistDocument -OrganizationID 8765309
```

Returns the first 50 documents from the defined organization

### EXAMPLE 3
```powershell
Get-ITGlueCopilotSmartAssistDocument -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for documents
in your ITGlue account

## PARAMETERS

### -FilterType
Filter by type

Allowed values:
'stale', 'not_viewed', 'expired'

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

### -FilterOrganizationID
Filter by an organization ID

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

[https://celerium.github.io/Celerium.ITGlue/site/CopilotSmartAssist/Get-ITGlueCopilotSmartAssistDocument.html](https://celerium.github.io/Celerium.ITGlue/site/CopilotSmartAssist/Get-ITGlueCopilotSmartAssistDocument.html)

[https://api.itglue.com/developer#copilot-smart-assist-documents](https://api.itglue.com/developer#copilot-smart-assist-documents)

