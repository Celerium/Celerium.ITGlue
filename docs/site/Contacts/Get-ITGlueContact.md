---
external help file: Celerium.ITGlue-help.xml
grand_parent: Contacts
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Contacts/Get-ITGlueContact.html
parent: GET
schema: 2.0.0
title: Get-ITGlueContact
---

# Get-ITGlueContact

## SYNOPSIS
List or show all contacts

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueContact [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterFirstName <String>]
 [-FilterLastName <String>] [-FilterTitle <String>] [-FilterContactTypeID <Int64>] [-FilterImportant <String>]
 [-FilterPrimaryEmail <String>] [-FilterOrganizationID <Int64>] [-FilterPsaIntegrationType <String>]
 [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>] [-Include <Object>] [-AllResults]
 [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueContact [-OrganizationID <Int64>] [-FilterOrganizationID <Int64>] -ID <Int64> [-Include <Object>]
 [<CommonParameters>]
```

### IndexPSA
```powershell
Get-ITGlueContact [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterFirstName <String>]
 [-FilterLastName <String>] [-FilterTitle <String>] [-FilterContactTypeID <Int64>] [-FilterImportant <String>]
 [-FilterPrimaryEmail <String>] [-FilterOrganizationID <Int64>] [-FilterPsaID <String>]
 -FilterPsaIntegrationType <String> [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>]
 [-Include <Object>] [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueContact cmdlet lists all or a single contact(s)
from your account or a defined organization

This function can call the following endpoints:
    Index = /contacts
            /organizations/:organization_id/relationships/contacts

    Show =   /contacts/:id
            /organizations/:organization_id/relationships/contacts/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueContact
```

Returns the first 50 contacts from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueContact -OrganizationID 8765309
```

Returns the first 50 contacts from the defined organization

### EXAMPLE 3
```powershell
Get-ITGlueContact -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for contacts
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

### -FilterID
Filter by contact id

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

### -FilterFirstName
Filter by contact first name

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

### -FilterLastName
Filter by contact last name

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

### -FilterTitle
Filter by contact title

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

### -FilterContactTypeID
Filter by contact type id

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

### -FilterImportant
Filter by if contact is important

A users important field in ITGlue can sometimes
be null which will cause this parameter to return
incomplete information

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

### -FilterPrimaryEmail
Filter by contact primary email address

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
Filter by a PSA id

This must be accompanied by the filter for FilterPsaIntegrationType

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
Filter by a PSA integration type

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
'first_name', 'last_name', 'id', 'created_at', 'updated_at',
'-first_name', '-last_name', '-id', '-created_at', '-updated_at'

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
Type: Int32
Parameter Sets: Index, IndexPSA
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
adapters_resources, attachments, distinct_remote_contacts, group_resource_accesses,
location, passwords, resource_fields, tickets, user_resource_accesses

Allowed values (Index-Unique):
N/A

Allowed values (Show-Unique):
recent_versions, related_items, authorized_users

```yaml
Type: Object
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

[https://celerium.github.io/Celerium.ITGlue/site/Contacts/Get-ITGlueContact.html](https://celerium.github.io/Celerium.ITGlue/site/Contacts/Get-ITGlueContact.html)

[https://api.itglue.com/developer/#contacts-index](https://api.itglue.com/developer/#contacts-index)

