---
external help file: Celerium.ITGlue-help.xml
grand_parent: Configurations
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Configurations/Set-ITGlueConfiguration.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueConfiguration
---

# Set-ITGlueConfiguration

## SYNOPSIS
Updates one or more configurations

## SYNTAX

### BulkUpdate (Default)
```powershell
Set-ITGlueConfiguration -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-ITGlueConfiguration -ID <Int64> [-OrganizationID <Int64>] -Data <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### BulkUpdateRMMPSA
```powershell
Set-ITGlueConfiguration [-FilterID <Int64>] [-FilterName <String>] [-FilterOrganizationID <Int64>]
 [-FilterConfigurationTypeID <Int64>] [-FilterConfigurationStatusID <Int64>] [-FilterContactID <Int64>]
 [-FilterSerialNumber <String>] [-FilterMacAddress <String>] [-FilterAssetTag <String>] [-FilterPsaID <String>]
 -FilterPsaIntegrationType <String> [-FilterRmmID <String>] -FilterRmmIntegrationType <String>
 [-FilterArchived <String>] -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### BulkUpdatePSA
```powershell
Set-ITGlueConfiguration [-FilterID <Int64>] [-FilterName <String>] [-FilterOrganizationID <Int64>]
 [-FilterConfigurationTypeID <Int64>] [-FilterConfigurationStatusID <Int64>] [-FilterContactID <Int64>]
 [-FilterSerialNumber <String>] [-FilterMacAddress <String>] [-FilterAssetTag <String>] [-FilterPsaID <String>]
 -FilterPsaIntegrationType <String> [-FilterRmmIntegrationType <String>] [-FilterArchived <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### BulkUpdateRMM
```powershell
Set-ITGlueConfiguration [-FilterID <Int64>] [-FilterName <String>] [-FilterOrganizationID <Int64>]
 [-FilterConfigurationTypeID <Int64>] [-FilterConfigurationStatusID <Int64>] [-FilterContactID <Int64>]
 [-FilterSerialNumber <String>] [-FilterMacAddress <String>] [-FilterAssetTag <String>]
 [-FilterPsaIntegrationType <String>] [-FilterRmmID <String>] -FilterRmmIntegrationType <String>
 [-FilterArchived <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### BulkUpdatepsa
```powershell
Set-ITGlueConfiguration -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### BulkUpdatermm
```powershell
Set-ITGlueConfiguration -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueConfiguration cmdlet updates the details
of one or more existing configurations

Any attributes you don't specify will remain unchanged

This function can call the following endpoints:
    Update = /configurations/:id
            /organizations/:organization_id/relationships/configurations/:id

    Bulk_Update =  /configurations

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueConfiguration -ID 8765309 -OrganizationID 8765309 -Data $JsonBody
```

Updates a defined configuration in the defined organization with
the structured JSON object

## PARAMETERS

### -ID
A valid configuration Id

```yaml
Type: Int64
Parameter Sets: Update
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrganizationID
A valid organization Id in your account

```yaml
Type: Int64
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterID
Filter by configuration id

```yaml
Type: Int64
Parameter Sets: BulkUpdateRMMPSA, BulkUpdatePSA, BulkUpdateRMM
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
Parameter Sets: BulkUpdateRMMPSA, BulkUpdatePSA, BulkUpdateRMM
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
Parameter Sets: BulkUpdateRMMPSA, BulkUpdatePSA, BulkUpdateRMM
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
Parameter Sets: BulkUpdateRMMPSA, BulkUpdatePSA, BulkUpdateRMM
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
Parameter Sets: BulkUpdateRMMPSA, BulkUpdatePSA, BulkUpdateRMM
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
Parameter Sets: BulkUpdateRMMPSA, BulkUpdatePSA, BulkUpdateRMM
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
Parameter Sets: BulkUpdateRMMPSA, BulkUpdatePSA, BulkUpdateRMM
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
Parameter Sets: BulkUpdateRMMPSA, BulkUpdatePSA, BulkUpdateRMM
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
Parameter Sets: BulkUpdateRMMPSA, BulkUpdatePSA, BulkUpdateRMM
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
Parameter Sets: BulkUpdateRMMPSA, BulkUpdatePSA
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
Parameter Sets: BulkUpdateRMMPSA, BulkUpdatePSA
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: BulkUpdateRMM
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterRmmID
Filter by a RMM id

```yaml
Type: String
Parameter Sets: BulkUpdateRMMPSA, BulkUpdateRMM
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
'pulseway-rmm', 'syncro', 'watchman-monitoring'

```yaml
Type: String
Parameter Sets: BulkUpdateRMMPSA, BulkUpdateRMM
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: BulkUpdatePSA
Aliases:

Required: False
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
Parameter Sets: BulkUpdateRMMPSA, BulkUpdatePSA, BulkUpdateRMM
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Data
JSON body depending on bulk changes or not

Do NOT include the "Data" property in the JSON object as this is handled
by the Invoke-ITGlueRequest function

```yaml
Type: Object
Parameter Sets: BulkUpdate, Update, BulkUpdateRMMPSA, BulkUpdatepsa, BulkUpdatermm
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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

[https://celerium.github.io/Celerium.ITGlue/site/Configurations/Set-ITGlueConfiguration.html](https://celerium.github.io/Celerium.ITGlue/site/Configurations/Set-ITGlueConfiguration.html)

[https://api.itglue.com/developer/#configurations-update](https://api.itglue.com/developer/#configurations-update)

