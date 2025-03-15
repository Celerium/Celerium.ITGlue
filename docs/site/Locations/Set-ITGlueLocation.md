---
external help file: Celerium.ITGlue-help.xml
grand_parent: Locations
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Locations/Set-ITGlueLocation.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueLocation
---

# Set-ITGlueLocation

## SYNOPSIS
Updates one or more a locations

## SYNTAX

### BulkUpdate (Default)
```powershell
Set-ITGlueLocation [-FilterID <Int64>] [-FilterName <String>] [-FilterCity <String>] [-FilterRegionID <Int64>]
 [-FilterCountryID <Int64>] [-FilterOrganizationID <Int64>] [-FilterPsaIntegrationType <String>] -Data <Object>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-ITGlueLocation -ID <Int64> [-OrganizationID <Int64>] -Data <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### BulkUpdatePSA
```powershell
Set-ITGlueLocation [-FilterID <Int64>] [-FilterName <String>] [-FilterCity <String>] [-FilterRegionID <Int64>]
 [-FilterCountryID <Int64>] [-FilterOrganizationID <Int64>] [-FilterPsaID <String>]
 -FilterPsaIntegrationType <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueLocation cmdlet updates the details of
an existing location or locations

Any attributes you don't specify will remain unchanged

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueLocation -id 8765309 -Data $JsonBody
```

Updates the defined location with the specified JSON body

## PARAMETERS

### -ID
Get a location by id

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
The valid organization id in your account

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
Filter by a location id

```yaml
Type: Int64
Parameter Sets: BulkUpdate, BulkUpdatePSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterName
Filter by a location name

```yaml
Type: String
Parameter Sets: BulkUpdate, BulkUpdatePSA
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterCity
Filter by a location city

```yaml
Type: String
Parameter Sets: BulkUpdate, BulkUpdatePSA
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterRegionID
Filter by a location region id

```yaml
Type: Int64
Parameter Sets: BulkUpdate, BulkUpdatePSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterCountryID
Filter by a location country id

```yaml
Type: Int64
Parameter Sets: BulkUpdate, BulkUpdatePSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterOrganizationID
Filter by an organization ID

```yaml
Type: Int64
Parameter Sets: BulkUpdate, BulkUpdatePSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterPsaID
Filter by a psa integration id

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

### -FilterPsaIntegrationType
Filter by a psa integration type

Allowed values:
'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

```yaml
Type: String
Parameter Sets: BulkUpdate
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: BulkUpdatePSA
Aliases:

Required: True
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
Parameter Sets: BulkUpdate, Update
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

[https://celerium.github.io/Celerium.ITGlue/site/Locations/Set-ITGlueLocation.html](https://celerium.github.io/Celerium.ITGlue/site/Locations/Set-ITGlueLocation.html)

[https://api.itglue.com/developer/#locations-update](https://api.itglue.com/developer/#locations-update)

