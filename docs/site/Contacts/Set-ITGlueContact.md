---
external help file: Celerium.ITGlue-help.xml
grand_parent: Contacts
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Contacts/Set-ITGlueContact.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueContact
---

# Set-ITGlueContact

## SYNOPSIS
Updates one or more contacts

## SYNTAX

### Bulk_Update (Default)
```powershell
Set-ITGlueContact -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-ITGlueContact [-OrganizationID <Int64>] -ID <Int64> -Data <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Bulk_Update_ByFilter_PSA
```powershell
Set-ITGlueContact [-FilterID <Int64>] [-FilterFirstName <String>] [-FilterLastName <String>]
 [-FilterTitle <String>] [-FilterContactTypeID <Int64>] [-FilterImportant] [-FilterPrimaryEmail <String>]
 [-FilterOrganizationID <String>] [-FilterPsaID <String>] -FilterPsaIntegrationType <String> -Data <Object>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Bulk_Update_ByFilter
```powershell
Set-ITGlueContact [-FilterID <Int64>] [-FilterFirstName <String>] [-FilterLastName <String>]
 [-FilterTitle <String>] [-FilterContactTypeID <Int64>] [-FilterImportant] [-FilterPrimaryEmail <String>]
 [-FilterOrganizationID <String>] [-FilterPsaIntegrationType <String>] -Data <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueContact cmdlet updates the details of one
or more specified contacts

Returns 422 Bad Request error if trying to update an externally synced record

Any attributes you don't specify will remain unchanged

This function can call the following endpoints:
    Update = /contacts/:id
            /organizations/:organization_id/relationships/contacts/:id

    Bulk_Update =  /contacts

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueContact -id 8675309 -Data $JsonObject
```

Updates the defined contact with the specified JSON object

## PARAMETERS

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

### -ID
Define a contact id

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
Filter by contact id

```yaml
Type: Int64
Parameter Sets: Bulk_Update_ByFilter_PSA, Bulk_Update_ByFilter
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
Parameter Sets: Bulk_Update_ByFilter_PSA, Bulk_Update_ByFilter
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
Parameter Sets: Bulk_Update_ByFilter_PSA, Bulk_Update_ByFilter
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
Parameter Sets: Bulk_Update_ByFilter_PSA, Bulk_Update_ByFilter
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
Parameter Sets: Bulk_Update_ByFilter_PSA, Bulk_Update_ByFilter
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
Parameter Sets: Bulk_Update_ByFilter_PSA, Bulk_Update_ByFilter
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
Parameter Sets: Bulk_Update_ByFilter_PSA, Bulk_Update_ByFilter
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
Parameter Sets: Bulk_Update_ByFilter_PSA, Bulk_Update_ByFilter
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
Parameter Sets: Bulk_Update_ByFilter_PSA
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
Parameter Sets: Bulk_Update_ByFilter_PSA
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Bulk_Update_ByFilter
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

[https://celerium.github.io/Celerium.ITGlue/site/Contacts/Set-ITGlueContact.html](https://celerium.github.io/Celerium.ITGlue/site/Contacts/Set-ITGlueContact.html)

[https://api.itglue.com/developer/#contacts-update](https://api.itglue.com/developer/#contacts-update)

