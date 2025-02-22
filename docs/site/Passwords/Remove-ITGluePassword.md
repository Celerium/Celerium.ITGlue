---
external help file: Celerium.ITGlue-help.xml
grand_parent: Passwords
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Passwords/Remove-ITGluePassword.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGluePassword
---

# Remove-ITGluePassword

## SYNOPSIS
Deletes one or more passwords

## SYNTAX

### Destroy (Default)
```powershell
Remove-ITGluePassword -ID <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Bulk_Destroy
```powershell
Remove-ITGluePassword [-ID <Int64>] [-OrganizationID <Int64>] [-FilterID <Int64>] [-FilterName <String>]
 [-FilterOrganizationID <Int64>] [-FilterPasswordCategoryID <Int64>] [-FilterUrl <String>]
 [-FilterCachedResourceName <String>] [-FilterArchived <String>] -Data <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGluePassword cmdlet destroys one or more
passwords specified by ID

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGluePassword -id 8675309
```

Deletes the defined password

## PARAMETERS

### -ID
Delete a password by id

```yaml
Type: Int64
Parameter Sets: Destroy
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Int64
Parameter Sets: Bulk_Destroy
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrganizationID
A valid organization Id in your account

```yaml
Type: Int64
Parameter Sets: Bulk_Destroy
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterID
Filter by password id

```yaml
Type: Int64
Parameter Sets: Bulk_Destroy
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterName
Filter by password name

```yaml
Type: String
Parameter Sets: Bulk_Destroy
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterOrganizationID
Filter for passwords by organization id

```yaml
Type: Int64
Parameter Sets: Bulk_Destroy
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterPasswordCategoryID
Filter by passwords category id

```yaml
Type: Int64
Parameter Sets: Bulk_Destroy
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterUrl
Filter by password url

```yaml
Type: String
Parameter Sets: Bulk_Destroy
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterCachedResourceName
Filter by a passwords cached resource name

```yaml
Type: String
Parameter Sets: Bulk_Destroy
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterArchived
Filter for archived

Allowed values: (case-sensitive)
'true', 'false', '0', '1'

```yaml
Type: String
Parameter Sets: Bulk_Destroy
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
Parameter Sets: Bulk_Destroy
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

[https://celerium.github.io/Celerium.ITGlue/site/Passwords/Remove-ITGluePassword.html](https://celerium.github.io/Celerium.ITGlue/site/Passwords/Remove-ITGluePassword.html)

[https://api.itglue.com/developer/#passwords-destroy](https://api.itglue.com/developer/#passwords-destroy)

