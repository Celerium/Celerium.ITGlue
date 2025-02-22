---
external help file: Celerium.ITGlue-help.xml
grand_parent: Exports
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Exports/New-ITGlueExport.html
parent: POST
schema: 2.0.0
title: New-ITGlueExport
---

# New-ITGlueExport

## SYNOPSIS
Creates a new export

## SYNTAX

### Create (Default)
```powershell
New-ITGlueExport -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Custom_Create
```powershell
New-ITGlueExport [-OrganizationID <Int64>] [-IncludeLogs] [-ZipPassword <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-ITGlueExport cmdlet creates a new export
in your account

The new export will be for a single organization if organization_id is specified;
otherwise the new export will be for all organizations of the current account

The actual export attachment will be created later after the export record is created
Please check back using show endpoint, you will see a downloadable url when the record shows done

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
New-ITGlueExport -Data $JsonObject
```

Creates a new export with the specified JSON object

## PARAMETERS

### -OrganizationID
A valid organization Id in your account

If not defined then the entire ITGlue account is exported

```yaml
Type: Int64
Parameter Sets: Custom_Create
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeLogs
Define if logs should be included in the export

```yaml
Type: SwitchParameter
Parameter Sets: Custom_Create
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ZipPassword
Password protect the export

```yaml
Type: String
Parameter Sets: Custom_Create
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
Parameter Sets: Create
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

[https://celerium.github.io/Celerium.ITGlue/site/Exports/New-ITGlueExport.html](https://celerium.github.io/Celerium.ITGlue/site/Exports/New-ITGlueExport.html)

[https://api.itglue.com/developer/#exports-create](https://api.itglue.com/developer/#exports-create)

