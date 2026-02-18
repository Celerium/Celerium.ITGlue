---
external help file: Celerium.ITGlue-help.xml
grand_parent: Passwords
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Passwords/Set-ITGluePassword.html
parent: PATCH
schema: 2.0.0
title: Set-ITGluePassword
---

# Set-ITGluePassword

## SYNOPSIS
Updates one or more passwords

## SYNTAX

### BulkUpdate (Default)
```powershell
Set-ITGluePassword -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-ITGluePassword [-OrganizationID <Int64>] -ID <Int64> [-ShowPassword <String>] -Data <Object> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGluePassword cmdlet updates the details of an
existing password or the details of multiple passwords

To show passwords your API key needs to have the "Password Access" permission

Any attributes you don't specify will remain unchanged

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGluePassword -id 8675309 -Data $JsonBody
```

Updates the password in the defined organization with the specified JSON body

The password is NOT returned in the results

### EXAMPLE 2
```powershell
Set-ITGluePassword -id 8675309 -ShowPassword $true -Data $JsonBody
```

Updates the password in the defined organization with the specified JSON body

The password IS returned in the results

## PARAMETERS

### -OrganizationID
A valid organization Id in your account

```yaml
Type: Int64
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
Update a password by id

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

### -ShowPassword
Define if the password should be shown or not

By default ITGlue hides the passwords from the returned data

Allowed values: (case-sensitive)
'true', 'false'

```yaml
Type: String
Parameter Sets: Update
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

[https://celerium.github.io/Celerium.ITGlue/site/Passwords/Set-ITGluePassword.html](https://celerium.github.io/Celerium.ITGlue/site/Passwords/Set-ITGluePassword.html)

[https://api.itglue.com/developer/#passwords](https://api.itglue.com/developer/#passwords)

