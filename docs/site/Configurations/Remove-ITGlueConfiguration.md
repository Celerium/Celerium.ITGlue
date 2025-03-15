---
external help file: Celerium.ITGlue-help.xml
grand_parent: Configurations
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Configurations/Remove-ITGlueConfiguration.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueConfiguration
---

# Remove-ITGlueConfiguration

## SYNOPSIS
Deletes one or more configurations

## SYNTAX

### BulkDestroy (Default)
```powershell
Remove-ITGlueConfiguration -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Destroy
```powershell
Remove-ITGlueConfiguration -ID <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### BulkDestroyRMMPSA
```powershell
Remove-ITGlueConfiguration [-FilterID <Int64>] [-FilterName <String>] [-FilterOrganizationID <Int64>]
 [-FilterConfigurationTypeID <Int64>] [-FilterConfigurationStatusID <Int64>] [-FilterContactID <Int64>]
 [-FilterSerialNumber <String>] [-FilterMacAddress <String>] [-FilterAssetTag <String>] [-FilterPsaID <String>]
 -FilterPsaIntegrationType <String> [-FilterRmmID <String>] -FilterRmmIntegrationType <String>
 [-FilterArchived <String>] -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### BulkDestroyPSA
```powershell
Remove-ITGlueConfiguration [-FilterID <Int64>] [-FilterName <String>] [-FilterOrganizationID <Int64>]
 [-FilterConfigurationTypeID <Int64>] [-FilterConfigurationStatusID <Int64>] [-FilterContactID <Int64>]
 [-FilterSerialNumber <String>] [-FilterMacAddress <String>] [-FilterAssetTag <String>] [-FilterPsaID <String>]
 -FilterPsaIntegrationType <String> [-FilterRmmIntegrationType <String>] [-FilterArchived <String>]
 -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### BulkDestroyRMM
```powershell
Remove-ITGlueConfiguration [-FilterID <Int64>] [-FilterName <String>] [-FilterOrganizationID <Int64>]
 [-FilterConfigurationTypeID <Int64>] [-FilterConfigurationStatusID <Int64>] [-FilterContactID <Int64>]
 [-FilterSerialNumber <String>] [-FilterMacAddress <String>] [-FilterAssetTag <String>]
 [-FilterPsaIntegrationType <String>] [-FilterRmmID <String>] -FilterRmmIntegrationType <String>
 [-FilterArchived <String>] -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueConfiguration cmdlet deletes one or
more specified configurations

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueConfiguration -ID 8765309 -Data $JsonBody
```

Deletes a defined configuration with the specified JSON body

## PARAMETERS

### -ID
A valid configuration Id

```yaml
Type: Int64
Parameter Sets: Destroy
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterID
Filter by configuration id

```yaml
Type: Int64
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyPSA, BulkDestroyRMM
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyPSA, BulkDestroyRMM
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyPSA, BulkDestroyRMM
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyPSA, BulkDestroyRMM
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyPSA, BulkDestroyRMM
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyPSA, BulkDestroyRMM
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyPSA, BulkDestroyRMM
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyPSA, BulkDestroyRMM
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyPSA, BulkDestroyRMM
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyPSA
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyPSA
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: BulkDestroyRMM
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyRMM
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyRMM
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: BulkDestroyPSA
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
Parameter Sets: BulkDestroyRMMPSA, BulkDestroyPSA, BulkDestroyRMM
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
Parameter Sets: BulkDestroy, BulkDestroyRMMPSA, BulkDestroyPSA, BulkDestroyRMM
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

[https://celerium.github.io/Celerium.ITGlue/site/Configurations/Remove-ITGlueConfiguration.html](https://celerium.github.io/Celerium.ITGlue/site/Configurations/Remove-ITGlueConfiguration.html)

[https://api.itglue.com/developer/#configurations-bulk-destroy](https://api.itglue.com/developer/#configurations-bulk-destroy)

