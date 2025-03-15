---
external help file: Celerium.ITGlue-help.xml
grand_parent: Internal
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Internal/Add-ITGlueBaseURI.html
parent: POST
schema: 2.0.0
title: Add-ITGlueBaseURI
---

# Add-ITGlueBaseURI

## SYNOPSIS
Sets the base URI for the ITGlue API connection

## SYNTAX

```powershell
Add-ITGlueBaseURI [[-BaseUri] <String>] [[-DataCenter] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Add-ITGlueBaseURI cmdlet sets the base URI which is used
to construct the full URI for all API calls

## EXAMPLES

### EXAMPLE 1
```powershell
Add-ITGlueBaseURI
```

The base URI will use https://api.itglue.com

### EXAMPLE 2
```powershell
Add-ITGlueBaseURI -BaseUri 'https://gateway.celerium.org'
```

The base URI will use https://gateway.celerium.org

### EXAMPLE 3
```
'https://gateway.celerium.org' | Add-ITGlueBaseURI
```

The base URI will use https://gateway.celerium.org

### EXAMPLE 4
```powershell
Add-ITGlueBaseURI -DataCenter EU
```

The base URI will use https://api.eu.itglue.com

## PARAMETERS

### -BaseUri
Sets the base URI for the ITGlue API connection.
Helpful
if using a custom API gateway

The default value is 'https://api.itglue.com'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Https://api.itglue.com
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DataCenter
Defines the data center to use which in turn defines which
base API URL is used

Allowed values:
'US', 'EU', 'AU'

    'US' = 'https://api.itglue.com'
    'EU' = 'https://api.eu.itglue.com'
    'AU' = 'https://api.au.itglue.com'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

[https://celerium.github.io/Celerium.ITGlue/site/Internal/Add-ITGlueBaseURI.html](https://celerium.github.io/Celerium.ITGlue/site/Internal/Add-ITGlueBaseURI.html)

