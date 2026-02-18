---
external help file: Celerium.ITGlue-help.xml
grand_parent: PasswordFolders
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/New-ITGluePasswordFolder.html
parent: POST
schema: 2.0.0
title: New-ITGluePasswordFolder
---

# New-ITGluePasswordFolder

## SYNOPSIS
Creates a new password folder

## SYNTAX

### Create (Default)
```powershell
New-ITGluePasswordFolder -OrganizationID <Int64> -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### CreateSimple
```powershell
New-ITGluePasswordFolder -OrganizationID <Int64> -Name <String> [-Restricted] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-ITGluePasswordFolder cmdlet creates a new password folder
under the organization specified in the ID parameter.

Returns the created object if successful.

## EXAMPLES

### EXAMPLE 1
```powershell
New-ITGluePasswordFolder -OrganizationID 12345 -Name "New Folder" -Restricted
```

Creates a new password folder with the defined name with restricted access

### EXAMPLE 2
```powershell
New-ITGluePasswordFolder -OrganizationID 12345 -Data $JsonBody
```

Creates a new password folder with the defined JSON object

## PARAMETERS

### -OrganizationID
A valid organization Id in your account

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
The name of the new password folder

```yaml
Type: String
Parameter Sets: CreateSimple
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Restricted
Restrict access to the password folder

```yaml
Type: SwitchParameter
Parameter Sets: CreateSimple
Aliases:

Required: False
Position: Named
Default value: False
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

[https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/New-ITGluePasswordFolder.html](https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/New-ITGluePasswordFolder.html)

[https://api.itglue.com/developer/#password-folders](https://api.itglue.com/developer/#password-folders)

