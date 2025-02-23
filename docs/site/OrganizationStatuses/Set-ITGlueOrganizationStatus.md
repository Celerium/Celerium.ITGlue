---
external help file: Celerium.ITGlue-help.xml
grand_parent: OrganizationStatuses
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/OrganizationStatuses/Set-ITGlueOrganizationStatus.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueOrganizationStatus
---

# Set-ITGlueOrganizationStatus

## SYNOPSIS
Updates an organization status

## SYNTAX

```powershell
Set-ITGlueOrganizationStatus [-ID] <Int64> [-Data] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueOrganizationStatus cmdlet updates an organization status
in your account

Returns 422 Bad Request error if trying to update an externally synced record

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueOrganizationStatus -id 8675309 -Data $JsonBody
```

Using the defined body this creates an attachment to a password with the structured
JSON object

## PARAMETERS

### -ID
Update an organization status by id

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
Position: 2
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

[https://celerium.github.io/Celerium.ITGlue/site/OrganizationStatuses/Set-ITGlueOrganizationStatus.html](https://celerium.github.io/Celerium.ITGlue/site/OrganizationStatuses/Set-ITGlueOrganizationStatus.html)

[https://api.itglue.com/developer/#organization-statuses-update](https://api.itglue.com/developer/#organization-statuses-update)

