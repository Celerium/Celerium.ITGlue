---
external help file: Celerium.ITGlue-help.xml
grand_parent: Internal
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Internal/Get-ITGlueAPIKey.html
parent: GET
schema: 2.0.0
title: Get-ITGlueAPIKey
---

# Get-ITGlueAPIKey

## SYNOPSIS
Gets the ITGlue API key

## SYNTAX

```powershell
Get-ITGlueAPIKey [-PlainText] [<CommonParameters>]
```

## DESCRIPTION
The Get-ITGlueAPIKey cmdlet gets the ITGlue API key from
the global variable and returns it as a SecureString

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ITGlueAPIKey
```

Gets the ITGlue API secret key global variable and returns an object
with the secret key as a SecureString

### EXAMPLE 2
```powershell
Get-ITGlueAPIKey -PlainText
```

Gets the ITGlue API secret key global variable and returns an object
with the secret key as plain text

## PARAMETERS

### -PlainText
Decrypt and return the API key in plain text

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

[https://celerium.github.io/Celerium.ITGlue/site/Internal/Get-ITGlueAPIKey.html](https://celerium.github.io/Celerium.ITGlue/site/Internal/Get-ITGlueAPIKey.html)

[https://github.com/Celerium/Celerium.ITGlue](https://github.com/Celerium/Celerium.ITGlue)

