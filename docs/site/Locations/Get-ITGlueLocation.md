---
external help file: Celerium.ITGlue-help.xml
grand_parent: Locations
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Locations/Get-ITGlueLocation.html
parent: GET
schema: 2.0.0
title: Get-ITGlueLocation
---

# Get-ITGlueLocation

## SYNOPSIS
List or show all location

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueLocation [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterName <String>] [-FilterCity <String>]
 [-FilterRegionID <Int64>] [-FilterCountryID <Int64>] [-FilterOrganizationID <Int64>]
 [-FilterPsaIntegrationType <String>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int64>]
 [-Include <String>] [-AllResults] [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueLocation [-OrganizationID <Int64>] [-FilterOrganizationID <Int64>] -ID <Int64> [-Include <String>]
 [<CommonParameters>]
```

### IndexPSA
```powershell
Get-ITGlueLocation [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterName <String>] [-FilterCity <String>]
 [-FilterRegionID <Int64>] [-FilterCountryID <Int64>] [-FilterOrganizationID <Int64>] [-FilterPsaID <String>]
 -FilterPsaIntegrationType <String> [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int64>]
 [-Include <String>] [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueLocation cmdlet returns a list of locations for
all organizations or for a specified organization

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueLocation
```

Returns the first 50 location results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueLocation -ID 8765309
```

Returns the location with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueLocation -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for locations
in your ITGlue account

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

### -FilterID
Filter by a location id

```yaml
Type: Int64
Parameter Sets: Index, IndexPSA
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
Parameter Sets: Index, IndexPSA
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
Parameter Sets: Index, IndexPSA
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
Parameter Sets: Index, IndexPSA
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
Parameter Sets: Index, IndexPSA
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
Parameter Sets: IndexPSA
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
Parameter Sets: IndexPSA
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sort
Sort results by a defined value

Allowed values:
'name', 'id', 'created_at', 'updated_at',
'-name', '-id', '-created_at', '-updated_at'

```yaml
Type: String
Parameter Sets: Index, IndexPSA
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
Parameter Sets: Index, IndexPSA
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
Type: Int64
Parameter Sets: Index, IndexPSA
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
Get a location by id

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
adapters_resources, attachments, group_resource_accesses,
passwords ,user_resource_accesses

Allowed values (Index-Unique):
N/A

Allowed values (Show-Unique):
recent_versions ,related_items ,authorized_users

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
Parameter Sets: Index, IndexPSA
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

[https://celerium.github.io/Celerium.ITGlue/site/Locations/Get-ITGlueLocation.html](https://celerium.github.io/Celerium.ITGlue/site/Locations/Get-ITGlueLocation.html)

[https://api.itglue.com/developer/#locations](https://api.itglue.com/developer/#locations)

