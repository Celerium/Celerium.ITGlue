---
external help file: Celerium.ITGlue-help.xml
grand_parent: Organizations
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Organizations/Get-ITGlueOrganization.html
parent: GET
schema: 2.0.0
title: Get-ITGlueOrganization
---

# Get-ITGlueOrganization

## SYNOPSIS
List or show all organizations

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueOrganization [-FilterID <Int64>] [-FilterName <String>] [-FilterOrganizationTypeID <Int64>]
 [-FilterOrganizationStatusID <Int64>] [-FilterCreatedAt <String>] [-FilterUpdatedAt <String>]
 [-FilterMyGlueAccountID <Int64>] [-FilterPsaIntegrationType <String>] [-FilterGroupID <Int64>]
 [-FilterPrimary <String>] [-FilterExcludeID <Int64>] [-FilterExcludeName <String>]
 [-FilterExcludeOrganizationTypeID <Int64>] [-FilterExcludeOrganizationStatusID <Int64>]
 [-FilterRange <String>] [-FilterRangeMyGlueAccountID <Int64>] [-Sort <String>] [-PageNumber <Int64>]
 [-PageSize <Int32>] [-Include <String>] [-AllResults] [<CommonParameters>]
```

### Index_PSA
```powershell
Get-ITGlueOrganization [-FilterID <Int64>] [-FilterName <String>] [-FilterOrganizationTypeID <Int64>]
 [-FilterOrganizationStatusID <Int64>] [-FilterCreatedAt <String>] [-FilterUpdatedAt <String>]
 [-FilterMyGlueAccountID <Int64>] [-FilterPsaID <String>] -FilterPsaIntegrationType <String>
 [-FilterGroupID <Int64>] [-FilterPrimary <String>] [-FilterExcludeID <Int64>] [-FilterExcludeName <String>]
 [-FilterExcludeOrganizationTypeID <Int64>] [-FilterExcludeOrganizationStatusID <Int64>]
 [-FilterRange <String>] [-FilterRangeMyGlueAccountID <Int64>] [-Sort <String>] [-PageNumber <Int64>]
 [-PageSize <Int32>] [-Include <String>] [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueOrganization -ID <Int64> [-Include <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueOrganization cmdlet returns a list of organizations
or details for a single organization in your account

This function can call the following endpoints:
    Index = /organizations

    Show =  /organizations/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueOrganization
```

Returns the first 50 organizations results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueOrganization -ID 8765309
```

Returns the organization with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueOrganization -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for organizations
in your ITGlue account

## PARAMETERS

### -FilterID
Filter by an organization id

```yaml
Type: Int64
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterName
Filter by an organization name

```yaml
Type: String
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterOrganizationTypeID
Filter by an organization type id

```yaml
Type: Int64
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterOrganizationStatusID
Filter by an organization status id

```yaml
Type: Int64
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterCreatedAt
Filter by when an organization created

```yaml
Type: String
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterUpdatedAt
Filter by when an organization updated

```yaml
Type: String
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterMyGlueAccountID
Filter by a MyGlue id

```yaml
Type: Int64
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterPsaID
Filter by a PSA id

```yaml
Type: String
Parameter Sets: Index_PSA
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterPsaIntegrationType
Filter by a PSA integration type

Allowed values:
'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

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

```yaml
Type: String
Parameter Sets: Index_PSA
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterGroupID
Filter by a group id

```yaml
Type: Int64
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterPrimary
Filter for primary organization

Allowed values:
'true', 'false'

```yaml
Type: String
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterExcludeID
Filter to excluded a certain organization id

```yaml
Type: Int64
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterExcludeName
Filter to excluded a certain organization name

```yaml
Type: String
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterExcludeOrganizationTypeID
Filter to excluded a certain organization type id

```yaml
Type: Int64
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterExcludeOrganizationStatusID
Filter to excluded a certain organization status id

```yaml
Type: Int64
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterRange
Filter organizations by range

```yaml
Type: String
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterRangeMyGlueAccountID
Filter MyGLue organization id range

```yaml
Type: Int64
Parameter Sets: Index, Index_PSA
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
'name', 'id', 'updated_at', 'organization_status_name', 'organization_type_name',
'created_at', 'short_name', 'my_glue_account_id', '-name', '-id', '-updated_at',
'-organization_status_name', '-organization_type_name', '-created_at',
'-short_name', '-my_glue_account_id'

```yaml
Type: String
Parameter Sets: Index, Index_PSA
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
Parameter Sets: Index, Index_PSA
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
Parameter Sets: Index, Index_PSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
Get an organization by id

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
Include specified assets

Allowed values (Shared):
adapters_resources, attachments, rmm_companies

Allowed values (Index-Unique):
N/A

Allowed values (Show-Unique):
N/A

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
Parameter Sets: Index, Index_PSA
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

[https://celerium.github.io/Celerium.ITGlue/site/Organizations/Get-ITGlueOrganization.html](https://celerium.github.io/Celerium.ITGlue/site/Organizations/Get-ITGlueOrganization.html)

[https://api.itglue.com/developer/#organizations-index](https://api.itglue.com/developer/#organizations-index)

