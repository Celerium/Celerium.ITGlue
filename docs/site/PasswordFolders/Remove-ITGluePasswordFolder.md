---
external help file: Celerium.ITGlue-help.xml
grand_parent: PasswordFolders
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/Remove-ITGluePasswordFolder.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGluePasswordFolder
---

# Remove-ITGluePasswordFolder

## SYNOPSIS
Delete multiple password folders for a particular organization

## SYNTAX

```powershell
Remove-ITGluePasswordFolder -OrganizationID <Int64> -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGluePasswordFolder cmdlet deletes one or more
specified password folders

Returns the deleted password folders and a 200 status code if successful
Returns 422 Unprocessable Entity error if trying to delete a password folder
that has dependent folders or passwords.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGluePasswordFolder -OrganizationID 12345 -Data $JsonBody
```

Deletes one or more specified password folders with the defined JSON object

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

[https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/Remove-ITGluePasswordFolder.html](https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/Remove-ITGluePasswordFolder.html)

[https://api.itglue.com/developer/#password-folders](https://api.itglue.com/developer/#password-folders)

