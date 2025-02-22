---
external help file: Celerium.ITGlue-help.xml
grand_parent: Configurations
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Configurations/Get-ITGlueConfiguration.html
parent: GET
schema: 2.0.0
title: Get-ITGlueConfiguration
---

# Get-ITGlueConfiguration

## SYNOPSIS
List all configurations in an account or organization

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueConfiguration [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterName <String>]
 [-FilterOrganizationID <Int64>] [-FilterConfigurationTypeID <Int64>] [-FilterConfigurationStatusID <Int64>]
 [-FilterContactID <Int64>] [-FilterSerialNumber <String>] [-FilterMacAddress <String>]
 [-FilterAssetTag <String>] [-FilterPsaIntegrationType <String>] [-FilterRmmIntegrationType <String>]
 [-FilterArchived <String>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>] [-Include <String>]
 [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueConfiguration [-OrganizationID <Int64>] -ID <Int64> [-Include <String>] [<CommonParameters>]
```

### Index_RMM_PSA
```powershell
Get-ITGlueConfiguration [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterName <String>]
 [-FilterOrganizationID <Int64>] [-FilterConfigurationTypeID <Int64>] [-FilterConfigurationStatusID <Int64>]
 [-FilterContactID <Int64>] [-FilterSerialNumber <String>] [-FilterMacAddress <String>]
 [-FilterAssetTag <String>] [-FilterPsaID <String>] -FilterPsaIntegrationType <String> [-FilterRmmID <String>]
 -FilterRmmIntegrationType <String> [-FilterArchived <String>] [-Sort <String>] [-PageNumber <Int64>]
 [-PageSize <Int32>] [-Include <String>] [-AllResults] [<CommonParameters>]
```

### Index_PSA
```powershell
Get-ITGlueConfiguration [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterName <String>]
 [-FilterOrganizationID <Int64>] [-FilterConfigurationTypeID <Int64>] [-FilterConfigurationStatusID <Int64>]
 [-FilterContactID <Int64>] [-FilterSerialNumber <String>] [-FilterMacAddress <String>]
 [-FilterAssetTag <String>] [-FilterPsaID <String>] -FilterPsaIntegrationType <String>
 [-FilterRmmIntegrationType <String>] [-FilterArchived <String>] [-Sort <String>] [-PageNumber <Int64>]
 [-PageSize <Int32>] [-Include <String>] [-AllResults] [<CommonParameters>]
```

### Index_RMM
```powershell
Get-ITGlueConfiguration [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterName <String>]
 [-FilterOrganizationID <Int64>] [-FilterConfigurationTypeID <Int64>] [-FilterConfigurationStatusID <Int64>]
 [-FilterContactID <Int64>] [-FilterSerialNumber <String>] [-FilterMacAddress <String>]
 [-FilterAssetTag <String>] [-FilterPsaIntegrationType <String>] [-FilterRmmID <String>]
 -FilterRmmIntegrationType <String> [-FilterArchived <String>] [-Sort <String>] [-PageNumber <Int64>]
 [-PageSize <Int32>] [-Include <String>] [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueConfiguration cmdlet lists all configurations
in an account or organization

This function can call the following endpoints:
    Index = /configurations
            /organizations/:organization_id/relationships/configurations

    Show =  /configurations/:id
            /organizations/:organization_id/relationships/configurations/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueConfigurations
```

Returns the first 50 configurations from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueConfiguration -FilterOrganizationID 8765309
```

Returns the first 50 configurations from the defined organization

### EXAMPLE 3
```powershell
Get-ITGlueConfiguration -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for configurations
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
A valid configuration Id

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
Filter by configuration id

```yaml
Type: Int64
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterName
Filter by configuration name

```yaml
Type: String
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterOrganizationID
Filter by organization name

```yaml
Type: Int64
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterConfigurationTypeID
Filter by configuration type id

```yaml
Type: Int64
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterConfigurationStatusID
Filter by configuration status id

```yaml
Type: Int64
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterContactID
Filter by contact id

```yaml
Type: Int64
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterSerialNumber
Filter by a configurations serial number

```yaml
Type: String
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterMacAddress
Filter by a configurations mac address

```yaml
Type: String
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterAssetTag
Filter by a configurations asset tag

```yaml
Type: String
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterPsaID
Filter by a PSA id

```yaml
Type: String
Parameter Sets: Index_RMM_PSA, Index_PSA
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
Parameter Sets: Index, Index_RMM
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Index_RMM_PSA, Index_PSA
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterRmmID
Filter by a RMM id

```yaml
Type: String
Parameter Sets: Index_RMM_PSA, Index_RMM
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterRmmIntegrationType
Filter by a RMM integration type

Allowed values:
'addigy', 'aem', 'atera', 'auvik', 'managed-workplace',
'continuum', 'jamf-pro', 'kaseya-vsa', 'automate', 'log-me-in',
'msp-rmm', 'meraki', 'msp-n-central', 'ninja-rmm', 'panorama9',
'pulseway-rmm', 'syncro', 'watchman-monitoring','office365','vsa-x'

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

```yaml
Type: String
Parameter Sets: Index_RMM_PSA, Index_RMM
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterArchived
Filter for archived

Allowed values: (case-sensitive)
'true', 'false', '0', '1'

```yaml
Type: String
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
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
'name', 'id', 'created_at', 'updated-at',
'-name', '-id', '-created_at', '-updated-at'

```yaml
Type: String
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
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
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
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
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Include
Include specified assets

Include specified assets

Allowed values (Shared):
adapters_resources, attachments, tickets ,configuration_interfaces,
dnet_fa_remote_assets, group_resource_accesses ,rmm_records, passwords,
user_resource_accesses

Allowed values (Index-Unique):
N/A

Allowed values (Show-Unique):
active_network_glue_network_devices ,adapters_resources_errors ,authorized_users
from_configuration_connections, recent_versions, related_items ,rmm_adapters_resources
rmm_adapters_resources_errors, to_configuration_connections

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
Parameter Sets: Index, Index_RMM_PSA, Index_PSA, Index_RMM
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

[https://celerium.github.io/Celerium.ITGlue/site/Configurations/Get-ITGlueConfiguration.html](https://celerium.github.io/Celerium.ITGlue/site/Configurations/Get-ITGlueConfiguration.html)

[https://api.itglue.com/developer/#configurations-index](https://api.itglue.com/developer/#configurations-index)

