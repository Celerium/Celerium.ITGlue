---
external help file: Celerium.ITGlue-help.xml
grand_parent: Contacts
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Contacts/Remove-ITGlueContact.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueContact
---

# Remove-ITGlueContact

## SYNOPSIS
Deletes one or more contacts

## SYNTAX

### Bulk_Destroy (Default)
```powershell
Remove-ITGlueContact [-OrganizationID <Int64>] -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Bulk_Destroy_ByFilter_PSA
```powershell
Remove-ITGlueContact [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterFirstName <String>]
 [-FilterLastName <String>] [-FilterTitle <String>] [-FilterContactTypeID <Int64>] [-FilterImportant]
 [-FilterPrimaryEmail <String>] [-FilterOrganizationID <String>] [-FilterPsaID <String>]
 -FilterPsaIntegrationType <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Bulk_Destroy_ByFilter
```powershell
Remove-ITGlueContact [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterFirstName <String>]
 [-FilterLastName <String>] [-FilterTitle <String>] [-FilterContactTypeID <Int64>] [-FilterImportant]
 [-FilterPrimaryEmail <String>] [-FilterOrganizationID <String>] [-FilterPsaIntegrationType <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueContact cmdlet deletes one or more specified contacts

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueContact -Data $JsonBody
```

Deletes contacts with the defined in structured
JSON object

### EXAMPLE 2
```powershell
Remove-ITGlueContact -FilterID 8675309
```

Deletes contacts with the defined id

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

### -FilterID
Filter by contact id

```yaml
Type: Int64
Parameter Sets: Bulk_Destroy_ByFilter_PSA, Bulk_Destroy_ByFilter
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterFirstName
Filter by contact first name

```yaml
Type: String
Parameter Sets: Bulk_Destroy_ByFilter_PSA, Bulk_Destroy_ByFilter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterLastName
Filter by contact last name

```yaml
Type: String
Parameter Sets: Bulk_Destroy_ByFilter_PSA, Bulk_Destroy_ByFilter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterTitle
Filter by contact title

```yaml
Type: String
Parameter Sets: Bulk_Destroy_ByFilter_PSA, Bulk_Destroy_ByFilter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterContactTypeID
Filter by contact type id

```yaml
Type: Int64
Parameter Sets: Bulk_Destroy_ByFilter_PSA, Bulk_Destroy_ByFilter
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterImportant
Filter by if contact is important

```yaml
Type: SwitchParameter
Parameter Sets: Bulk_Destroy_ByFilter_PSA, Bulk_Destroy_ByFilter
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterPrimaryEmail
Filter by contact primary email address

```yaml
Type: String
Parameter Sets: Bulk_Destroy_ByFilter_PSA, Bulk_Destroy_ByFilter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterOrganizationID
Filter by an organization ID

```yaml
Type: String
Parameter Sets: Bulk_Destroy_ByFilter_PSA, Bulk_Destroy_ByFilter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterPsaID
Filter by a PSA id

This must be accompanied by the filter for FilterPsaIntegrationType

```yaml
Type: String
Parameter Sets: Bulk_Destroy_ByFilter_PSA
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
Parameter Sets: Bulk_Destroy_ByFilter_PSA
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Bulk_Destroy_ByFilter
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
Parameter Sets: Bulk_Destroy
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

[https://celerium.github.io/Celerium.ITGlue/site/Contacts/Remove-ITGlueContact.html](https://celerium.github.io/Celerium.ITGlue/site/Contacts/Remove-ITGlueContact.html)

[https://api.itglue.com/developer/#contacts-bulk-destroy](https://api.itglue.com/developer/#contacts-bulk-destroy)

