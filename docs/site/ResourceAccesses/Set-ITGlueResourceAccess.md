---
external help file: Celerium.ITGlue-help.xml
grand_parent: ResourceAccesses
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/ResourceAccesses/Set-ITGlueResourceAccess.html
parent: PATCH
schema: 2.0.0
title: Set-ITGlueResourceAccess
---

# Set-ITGlueResourceAccess

## SYNOPSIS
Updates resource accesses for a defined resource

## SYNTAX

### BulkUpdate (Default)
```powershell
Set-ITGlueResourceAccess -ResourceType <String> -ResourceID <Int64> -Data <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Update
```powershell
Set-ITGlueResourceAccess -ResourceType <String> -ResourceID <Int64> [-Type <String>] -AccessorType <String>
 -AccessorID <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-ITGlueResourceAccess cmdlet updates one or
more existing resource accesses

All resource-accesses are replaced by the supplied payload, and any
pre-existing resource-accesses not included by the new collection are deleted

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ITGlueResourceAccess -ResourceType 'documents' -ResourceID 8675309 -AccessorType 'User' -AccessorID 1234567
```

Updates the resource access for the specified document with the specified user

## PARAMETERS

### -ResourceType
The resource type of the parent resource

Allowed values:
'checklists', 'configurations', 'contacts', 'documents', 'document_folders', 'domains',
'locations', 'password_folders', 'passwords', 'ssl_certificates', 'flexible_assets'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceID
The resource id of the parent resource

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The resource type of the parent resource

Allowed values:
'resource-accesses'

```yaml
Type: String
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: Resource-accesses
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessorType
The resource type of the accessor

Allowed values:
'User', 'Group'

```yaml
Type: String
Parameter Sets: Update
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessorID
The ID of the accessor

Allowed values:
'User', 'Group'

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
Parameter Sets: BulkUpdate
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

[https://celerium.github.io/Celerium.ITGlue/site/ResourceAccesses/Set-ITGlueResourceAccess.html](https://celerium.github.io/Celerium.ITGlue/site/ResourceAccesses/Set-ITGlueResourceAccess.html)

[https://api.itglue.com/developer#resource-accesses](https://api.itglue.com/developer#resource-accesses)

