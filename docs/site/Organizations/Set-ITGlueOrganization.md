---
external help file: Celerium.ITGlue-help.xml
grand_parent: Organizations
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Organizations/Set-ITGlueOrganization.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueOrganization
---

# Set-ITGlueOrganization

## SYNOPSIS
Updates one or more organizations

## SYNTAX

### Bulk_Update (Default)
```powershell
Set-ITGlueOrganization [-FilterID <Int64>] [-FilterName <String>] [-FilterOrganizationTypeID <Int64>]
 [-FilterOrganizationStatusID <Int64>] [-FilterCreatedAt <String>] [-FilterUpdatedAt <String>]
 [-FilterMyGlueAccountID <Int64>] [-FilterPsaIntegrationType <String>] [-FilterGroupID <Int64>]
 [-FilterPrimary <String>] [-FilterExcludeID <Int64>] [-FilterExcludeName <String>]
 [-FilterExcludeOrganizationTypeID <Int64>] [-FilterExcludeOrganizationStatusID <Int64>] -Data <Object>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-ITGlueOrganization -ID <Int64> -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Bulk_Update_PSA
```powershell
Set-ITGlueOrganization [-FilterID <Int64>] [-FilterName <String>] [-FilterOrganizationTypeID <Int64>]
 [-FilterOrganizationStatusID <Int64>] [-FilterCreatedAt <String>] [-FilterUpdatedAt <String>]
 [-FilterMyGlueAccountID <Int64>] [-FilterPsaID <String>] -FilterPsaIntegrationType <String>
 [-FilterGroupID <Int64>] [-FilterPrimary <String>] [-FilterExcludeID <Int64>] [-FilterExcludeName <String>]
 [-FilterExcludeOrganizationTypeID <Int64>] [-FilterExcludeOrganizationStatusID <Int64>] -Data <Object>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueOrganization cmdlet updates the details of an
existing organization or multiple organizations

Any attributes you don't specify will remain unchanged

Returns 422 Bad Request error if trying to update an externally synced record on
attributes other than: alert, description, quick_notes

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueOrganization -id 8765309 -Data $JsonBody
```

Updates an organization with the specified JSON body

### EXAMPLE 2
```powershell
Set-ITGlueOrganization -FilterOrganizationStatusID 12345 -Data $JsonBody
```

Updates all defined organization with the specified JSON body

## PARAMETERS

### -ID
Update an organization by id

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

### -FilterID
Filter by an organization id

```yaml
Type: Int64
Parameter Sets: Bulk_Update, Bulk_Update_PSA
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
Parameter Sets: Bulk_Update, Bulk_Update_PSA
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
Parameter Sets: Bulk_Update, Bulk_Update_PSA
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
Parameter Sets: Bulk_Update, Bulk_Update_PSA
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
Parameter Sets: Bulk_Update, Bulk_Update_PSA
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
Parameter Sets: Bulk_Update, Bulk_Update_PSA
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
Parameter Sets: Bulk_Update, Bulk_Update_PSA
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
Parameter Sets: Bulk_Update_PSA
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
Parameter Sets: Bulk_Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Bulk_Update_PSA
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
Parameter Sets: Bulk_Update, Bulk_Update_PSA
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
Parameter Sets: Bulk_Update, Bulk_Update_PSA
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
Parameter Sets: Bulk_Update, Bulk_Update_PSA
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
Parameter Sets: Bulk_Update, Bulk_Update_PSA
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
Parameter Sets: Bulk_Update, Bulk_Update_PSA
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
Parameter Sets: Bulk_Update, Bulk_Update_PSA
Aliases:

Required: False
Position: Named
Default value: 0
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

[https://celerium.github.io/Celerium.ITGlue/site/Organizations/Set-ITGlueOrganization.html](https://celerium.github.io/Celerium.ITGlue/site/Organizations/Set-ITGlueOrganization.html)

[https://api.itglue.com/developer/#organizations-update](https://api.itglue.com/developer/#organizations-update)

