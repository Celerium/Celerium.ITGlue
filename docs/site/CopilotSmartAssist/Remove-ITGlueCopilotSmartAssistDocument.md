---
external help file: Celerium.ITGlue-help.xml
grand_parent: CopilotSmartAssist
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/CopilotSmartAssist/Remove-ITGlueCopilotSmartAssistDocument.html
parent: DELETE
schema: 2.0.0
title: Remove-ITGlueCopilotSmartAssistDocument
---

# Remove-ITGlueCopilotSmartAssistDocument

## SYNOPSIS
Deletes one or more documents found in the ITGlue Copilot Smart Assist

## SYNTAX

```powershell
Remove-ITGlueCopilotSmartAssistDocument [-FilterType <String>] [-FilterOrganizationID <Int64>] -Data <Object>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-ITGlueCopilotSmartAssistDocument cmdlet deletes one or more documents
found in the ITGlue Copilot Smart Assist

Any attributes you don't specify will remain unchanged

This function can call the following endpoints:
    Bulk_Destroy =  /copilot_smart_assist/documents
                    /organizations/:organization_id/copilot_smart_assist/documents

Examples of JSON objects can be found under ITGlues developer documentation
    https://api.itglue.com/developer

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-ITGlueCopilotSmartAssistDocument -Data $JsonBody
```

Deletes the defined document with the specified JSON body

## PARAMETERS

### -FilterType
Filter by type

Allowed values:
'stale', 'not_viewed', 'expired'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterOrganizationID
Filter by an organization ID

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

[https://celerium.github.io/Celerium.ITGlue/site/CopilotSmartAssist/Remove-ITGlueCopilotSmartAssistDocument.html](https://celerium.github.io/Celerium.ITGlue/site/CopilotSmartAssist/Remove-ITGlueCopilotSmartAssistDocument.html)

[https://api.itglue.com/developer#copilot-smart-assist-bulk-destroy](https://api.itglue.com/developer#copilot-smart-assist-bulk-destroy)

