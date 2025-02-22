---
external help file: Celerium.ITGlue-help.xml
grand_parent: Organizations
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Organizations/Remove-ITGlueOrganization.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueOrganization
---

# Remove-ITGlueOrganization

## SYNOPSIS
Deletes one or more organizations

## SYNTAX

### Bulk_Destroy (Default)
```powershell
Remove-ITGlueOrganization [-FilterID <Int64>] [-FilterName <String>] [-FilterOrganizationTypeID <Int64>]
 [-FilterOrganizationStatusID <Int64>] [-FilterCreatedAt <String>] [-FilterUpdatedAt <String>]
 [-FilterMyGlueAccountID <Int64>] [-FilterPsaIntegrationType <String>] [-FilterGroupID <Int64>]
 [-FilterPrimary <String>] [-FilterExcludeID <Int64>] [-FilterExcludeName <String>]
 [-FilterExcludeOrganizationTypeID <Int64>] [-FilterExcludeOrganizationStatusID <Int64>] -Data <Object>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Bulk_Destroy_PSA
```powershell
Remove-ITGlueOrganization [-FilterID <Int64>] [-FilterName <String>] [-FilterOrganizationTypeID <Int64>]
 [-FilterOrganizationStatusID <Int64>] [-FilterCreatedAt <String>] [-FilterUpdatedAt <String>]
 [-FilterMyGlueAccountID <Int64>] [-FilterPsaID <String>] -FilterPsaIntegrationType <String>
 [-FilterGroupID <Int64>] [-FilterPrimary <String>] [-FilterExcludeID <Int64>] [-FilterExcludeName <String>]
 [-FilterExcludeOrganizationTypeID <Int64>] [-FilterExcludeOrganizationStatusID <Int64>] -Data <Object>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueOrganization cmdlet marks organizations identified by the
specified organization IDs for deletion

Because it can be a long procedure to delete organizations,
removal from the system may not happen immediately

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueOrganization -Data $JsonObject
```

Deletes all defined organization with the specified JSON object

## PARAMETERS

### -FilterID
Filter by an organization id

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
Filter by an organization name

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

### -FilterOrganizationTypeID
Filter by an organization type id

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

### -FilterOrganizationStatusID
Filter by an organization status id

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

### -FilterCreatedAt
Filter by when an organization created

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

### -FilterUpdatedAt
Filter by when an organization updated

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

### -FilterMyGlueAccountID
Filter by a MyGlue id

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
Filter by a PSA id

```yaml
Type: String
Parameter Sets: Bulk_Destroy_PSA
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
Parameter Sets: Bulk_Destroy
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Bulk_Destroy_PSA
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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

[https://celerium.github.io/Celerium.ITGlue/site/Organizations/Remove-ITGlueOrganization.html](https://celerium.github.io/Celerium.ITGlue/site/Organizations/Remove-ITGlueOrganization.html)

[https://api.itglue.com/developer/#organizations-bulk-destroy](https://api.itglue.com/developer/#organizations-bulk-destroy)

