---
external help file: Celerium.ITGlue-help.xml
grand_parent: Checklists
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Checklists/Set-ITGlueChecklist.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueChecklist
---

# Set-ITGlueChecklist

## SYNOPSIS
Update a single checklist or multiple checklists

## SYNTAX

### BulkUpdate (Default)
```powershell
Set-ITGlueChecklist [-OrganizationID <Int64>] -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-ITGlueChecklist [-OrganizationID <Int64>] -ID <Int64> -Data <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueChecklist cmdlet updates one or
more specified checklists

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueChecklist -id 8675309 -Data $JsonBody
```

Updates the defined checklist with the specified JSON body

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

### -ID
A valid checklist id

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

[https://celerium.github.io/Celerium.ITGlue/site/Checklists/Set-ITGlueChecklist.html](https://celerium.github.io/Celerium.ITGlue/site/Checklists/Set-ITGlueChecklist.html)

[https://api.itglue.com/developer/#checklists](https://api.itglue.com/developer/#checklists)

