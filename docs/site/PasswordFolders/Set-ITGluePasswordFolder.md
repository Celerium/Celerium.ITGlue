---
external help file: Celerium.ITGlue-help.xml
grand_parent: PasswordFolders
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/Set-ITGluePasswordFolder.html
parent: PATCH
schema: 2.0.0
title: Set-ITGluePasswordFolder
---

# Set-ITGluePasswordFolder

## SYNOPSIS
Updates the details of an existing or list of password folders

## SYNTAX

### BulkUpdate (Default)
```powershell
Set-ITGluePasswordFolder -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-ITGluePasswordFolder -OrganizationID <Int64> -Id <Int64> -Data <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGluePasswordFolder cmdlet updates the details of an existing
or list of password folders

Bulk updates using a nested relationships route are NOT supported

It will accept a partial representation of objects, as long as the required
parameters are present.

Any attributes you don't specify will remain unchanged

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGluePasswordFolder -OrganizationID 12345 -Id 8765309 -Data $JsonBody
```

Updates an existing password folder with the defined JSON object

### EXAMPLE 2
```powershell
Set-ITGluePasswordFolder -Data $JsonBody
```

Updates an existing password folder with the defined JSON object

## PARAMETERS

### -OrganizationID
A valid organization Id in your account

```yaml
Type: Int64
Parameter Sets: Update
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Id
Password folder id

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

[https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/Set-ITGluePasswordFolder.html](https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/Set-ITGluePasswordFolder.html)

[https://api.itglue.com/developer/#password-folders](https://api.itglue.com/developer/#password-folders)

