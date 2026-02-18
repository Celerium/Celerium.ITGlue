---
external help file: Celerium.ITGlue-help.xml
grand_parent: Exports
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Exports/Remove-ITGlueExport.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueExport
---

# Remove-ITGlueExport

## SYNOPSIS
Deletes an export

## SYNTAX

```powershell
Remove-ITGlueExport [-ID] <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueExport cmdlet deletes an export

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueExport -ID 8675309
```

Deletes the export with the defined id

## PARAMETERS

### -ID
ID of export to delete

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

[https://celerium.github.io/Celerium.ITGlue/site/Exports/Remove-ITGlueExport.html](https://celerium.github.io/Celerium.ITGlue/site/Exports/Remove-ITGlueExport.html)

[https://api.itglue.com/developer/#exports](https://api.itglue.com/developer/#exports)

