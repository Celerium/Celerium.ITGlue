---
external help file: Celerium.ITGlue-help.xml
grand_parent: OrganizationStatuses
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/OrganizationStatuses/Remove-ITGlueOrganizationStatus.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueOrganizationStatus
---

# Remove-ITGlueOrganizationStatus

## SYNOPSIS
Deletes an organization status

## SYNTAX

```powershell
Remove-ITGlueOrganizationStatus [-ID] <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueOrganizationStatus cmdlet deletes an
organization status

Statuses like ('Active', 'Inactive') cannot be deleted
Statuses actively synced with an adapter cannot be deleted (423)
Statuses referenced by one or more organizations cannot be deleted

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueOrganizationStatus -ID 8765309
```

Deletes the organization status with the specified ID

## PARAMETERS

### -ID
Status ID to delete

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

[https://celerium.github.io/Celerium.ITGlue/site/OrganizationStatuses/Remove-ITGlueOrganizationStatus.html](https://celerium.github.io/Celerium.ITGlue/site/OrganizationStatuses/Remove-ITGlueOrganizationStatus.html)

[https://api.itglue.com/developer/#organization-statuses](https://api.itglue.com/developer/#organization-statuses)

