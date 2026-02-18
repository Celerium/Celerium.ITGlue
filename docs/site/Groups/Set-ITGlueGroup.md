---
external help file: Celerium.ITGlue-help.xml
grand_parent: Groups
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Groups/Set-ITGlueGroup.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueGroup
---

# Set-ITGlueGroup

## SYNOPSIS
Updates a group or a list of groups in bulk

## SYNTAX

### BulkUpdate (Default)
```powershell
Set-ITGlueGroup -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-ITGlueGroup -Id <Object> -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueGroup cmdlet updates a group or a list of
groups in bulk

It accepts a partial representation of each group-only the
attributes you provide will be updated; all others remain unchanged

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueGroup -Id 12345 -Data $JsonBody
```

Updates the group with the specified id using the structured JSON object

### EXAMPLE 2
```powershell
Set-ITGlueGroup -Data $JsonBody
```

Updates a group or a list of groups with the structured JSON object

## PARAMETERS

### -Id
Group id

```yaml
Type: Object
Parameter Sets: Update
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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

[https://celerium.github.io/Celerium.ITGlue/site/Groups/Set-ITGlueGroup.html](https://celerium.github.io/Celerium.ITGlue/site/Groups/Set-ITGlueGroup.html)

[https://api.itglue.com/developer/#groups](https://api.itglue.com/developer/#groups)

