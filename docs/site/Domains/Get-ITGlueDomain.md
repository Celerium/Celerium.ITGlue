---
external help file: Celerium.ITGlue-help.xml
grand_parent: Domains
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Domains/Get-ITGlueDomain.html
parent: GET
schema: 2.0.0
title: Get-ITGlueDomain
---

# Get-ITGlueDomain

## SYNOPSIS
List or show all domains

## SYNTAX

```powershell
Get-ITGlueDomain [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterOrganizationID <Int64>] [-Sort <String>]
 [-PageNumber <Int64>] [-PageSize <Int32>] [-Include <String>] [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueDomain cmdlet list or show all domains in
your account or from a specified organization

This function can call the following endpoints:
    Index = /domains
            /organizations/:organization_id/relationships/domains

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueDomain
```

Returns the first 50 results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueDomain -OrganizationID 12345
```

Returns the domains from the defined organization id

### EXAMPLE 3
```powershell
Get-ITGlueDomain -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for domains
in your ITGlue account

## PARAMETERS

### -OrganizationID
A valid organization Id in your Account

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
The domain id to filter for

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
The organization id to filter for

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

### -Sort
Sort results by a defined value

Allowed values:
'created_at', 'updated_at'
'-created_at', '-updated_at'

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

### -Include
Include specified assets

Allowed values:
'passwords', 'attachments', 'user_resource_accesses', 'group_resource_accesses'

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

[https://celerium.github.io/Celerium.ITGlue/site/Domains/Get-ITGlueDomain.html](https://celerium.github.io/Celerium.ITGlue/site/Domains/Get-ITGlueDomain.html)

[https://api.itglue.com/developer/#domains-index](https://api.itglue.com/developer/#domains-index)

