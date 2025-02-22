---
external help file: Celerium.ITGlue-help.xml
grand_parent: Expirations
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Expirations/Get-ITGlueExpiration.html
parent: GET
schema: 2.0.0
title: Get-ITGlueExpiration
---

# Get-ITGlueExpiration

## SYNOPSIS
List or show all expirations

## SYNTAX

### Index (Default)
```powershell
Get-ITGlueExpiration [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterResourceID <Int64>]
 [-FilterResourceName <String>] [-FilterResourceTypeName <String>] [-FilterDescription <String>]
 [-FilterExpirationDate <String>] [-FilterOrganizationID <Int64>] [-FilterRange <String>]
 [-FilterRangeExpirationDate <String>] [-Sort <String>] [-PageNumber <Int64>] [-PageSize <Int32>] [-AllResults]
 [<CommonParameters>]
```

### Show
```powershell
Get-ITGlueExpiration [-OrganizationID <Int64>] -ID <Int64> [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueExpiration cmdlet returns a list of expirations
for all organizations or for a specified organization

This function can call the following endpoints:
    Index = /expirations
            /organizations/:organization_id/relationships/expirations

    Show =  /expirations/:id
            /organizations/:organization_id/relationships/expirations/:id

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueExpiration
```

Returns the first 50 results from your ITGlue account

### EXAMPLE 2
```powershell
Get-ITGlueExpiration -ID 8765309
```

Returns the expiration with the defined id

### EXAMPLE 3
```powershell
Get-ITGlueExpiration -PageNumber 2 -PageSize 10
```

Returns the first 10 results from the second page for expirations
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
Filter by expiration id

```yaml
Type: Int64
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterResourceID
Filter by a resource id

```yaml
Type: Int64
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterResourceName
Filter by a resource name

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

### -FilterResourceTypeName
Filter by a resource type name

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

### -FilterDescription
Filter expiration description

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

### -FilterExpirationDate
Filter expiration date

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

### -FilterOrganizationID
Filter by organization name

```yaml
Type: Int64
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterRange
Filter by expiration range

To filter on a specific range, supply two comma-separated values
Example:
    "2, 10" is filtering for all that are greater than or equal to 2
    and less than or equal to 10

Or, an asterisk ( * ) can filter on values either greater than or equal to
    Example:
        "2, *", or less than or equal to ("*, 10")

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

### -FilterRangeExpirationDate
Filter by expiration date range

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

### -Sort
Sort results by a defined value

Allowed values:
'id', 'organization_id', 'expiration_date', 'created_at', 'updated_at',
'-id', '-organization_id', '-expiration_date', '-created_at', '-updated_at'

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

### -PageNumber
Return results starting from the defined number

```yaml
Type: Int64
Parameter Sets: Index
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
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
A valid expiration ID

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

### -AllResults
Returns all items from an endpoint

This can be used in unison with -PageSize to limit the number of
sequential requests to the API

```yaml
Type: SwitchParameter
Parameter Sets: Index
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

[https://celerium.github.io/Celerium.ITGlue/site/Expirations/Get-ITGlueExpiration.html](https://celerium.github.io/Celerium.ITGlue/site/Expirations/Get-ITGlueExpiration.html)

[https://api.itglue.com/developer/#expirations-index](https://api.itglue.com/developer/#expirations-index)

