---
external help file: Celerium.ITGlue-help.xml
grand_parent: Locations
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Locations/Remove-ITGlueLocation.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueLocation
---

# Remove-ITGlueLocation

## SYNOPSIS
Deletes one or more locations

## SYNTAX

### BulkDestroy (Default)
```powershell
Remove-ITGlueLocation [-OrganizationID <Int64>] [-ID <Int64>] [-FilterID <Int64>] [-FilterName <String>]
 [-FilterCity <String>] [-FilterRegionID <Int64>] [-FilterCountryID <Int64>] [-FilterOrganizationID <Int64>]
 [-FilterPsaIntegrationType <String>] -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### BulkDestroyPSA
```powershell
Remove-ITGlueLocation [-OrganizationID <Int64>] [-ID <Int64>] [-FilterID <Int64>] [-FilterName <String>]
 [-FilterCity <String>] [-FilterRegionID <Int64>] [-FilterCountryID <Int64>] [-FilterOrganizationID <Int64>]
 [-FilterPsaID <String>] -FilterPsaIntegrationType <String> -Data <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueLocation cmdlet deletes one or more
specified locations

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueLocation -OrganizationID 123456 -ID 8765309 -Data $JsonBody
```

Removes the defined location from the defined organization with the specified JSON body

### EXAMPLE 2
```powershell
Remove-ITGlueLocation -Data $JsonBody
```

Removes location(s) with the specified JSON body

## PARAMETERS

### -OrganizationID
The valid organization id in your account

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
Location id

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
Filter by a location id

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

### -FilterName
Filter by a location name

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

### -FilterCity
Filter by a location city

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

### -FilterRegionID
Filter by a location region id

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

### -FilterCountryID
Filter by a location country id

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

### -FilterPsaID
Filter by a psa integration id

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

### -FilterPsaIntegrationType
Filter by a psa integration type

Allowed values:
'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

```yaml
Type: String
Parameter Sets: BulkDestroy
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: BulkDestroyPSA
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
Parameter Sets: (All)
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

[https://celerium.github.io/Celerium.ITGlue/site/Locations/Remove-ITGlueLocation.html](https://celerium.github.io/Celerium.ITGlue/site/Locations/Remove-ITGlueLocation.html)

[https://api.itglue.com/developer/#locations](https://api.itglue.com/developer/#locations)

