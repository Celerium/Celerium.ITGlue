---
external help file: Celerium.ITGlue-help.xml
grand_parent: Internal
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Internal/New-ITGlueAESSecret.html
parent: POST
schema: 2.0.0
title: New-ITGlueAESSecret
---

# New-ITGlueAESSecret

## SYNOPSIS
Creates a AES encrypted API key and decipher key

## SYNTAX

```powershell
New-ITGlueAESSecret [[-KeyLength] <Int32>] [[-Path] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-ITGlueAESSecret cmdlet creates a AES encrypted API key and decipher key

This allows the key to be exported for use on other systems without
relying on Windows DPAPI

Do NOT share the decipher key with anyone as this will allow them to decrypt
the encrypted API key

## EXAMPLES

### EXAMPLE 1
```powershell
New-ITGlueAESSecret
```

Prompts to enter in the API key which will be encrypted using a randomly generated 256-bit AES key

## PARAMETERS

### -KeyLength
The length of the AES key to generate

By default a 256-bit key (32) is generated

Allowed values:
16, 24, 32

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 32
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The path to save the encrypted API key and decipher key

By default keys are only stored in memory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $(Get-Location).Path
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

[https://celerium.github.io/Celerium.ITGlue/site/Internal/New-ITGlueAESSecret.html](https://celerium.github.io/Celerium.ITGlue/site/Internal/New-ITGlueAESSecret.html)

[https://github.com/Celerium/Celerium.ITGlue](https://github.com/Celerium/Celerium.ITGlue)

