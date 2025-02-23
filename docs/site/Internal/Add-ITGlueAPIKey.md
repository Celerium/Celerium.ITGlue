---
external help file: Celerium.ITGlue-help.xml
grand_parent: Internal
Module Name: Celerium.ITGlue
online version: https://celerium.github.io/Celerium.ITGlue/site/Internal/Add-ITGlueAPIKey.html
parent: POST
schema: 2.0.0
title: Add-ITGlueAPIKey
---

# Add-ITGlueAPIKey

## SYNOPSIS
Sets your API key used to authenticate all API calls

## SYNTAX

### PlainText (Default)
```powershell
Add-ITGlueAPIKey [-ApiKey <String>] [<CommonParameters>]
```

### SecureString
```powershell
Add-ITGlueAPIKey [-ApiKeySecureString <SecureString>] [<CommonParameters>]
```

### EncryptedByFile
```powershell
Add-ITGlueAPIKey [-EncryptedStandardAPIKeyPath <String>] -EncryptedStandardAESKeyPath <String>
 [<CommonParameters>]
```

## DESCRIPTION
The Add-ITGlueAPIKey cmdlet sets your API key which is used to
authenticate all API calls made to ITGlue

ITGlue API keys can be generated via the ITGlue web interface
    Account \> API Keys

## EXAMPLES

### EXAMPLE 1
```powershell
Add-ITGlueAPIKey
```

Prompts to enter in the API key which will be stored as a SecureString

### EXAMPLE 2
```powershell
Add-ITGlueAPIKey -ApiKey 'some_api_key'
```

Converts the string to a SecureString and stores it in the global variable

### EXAMPLE 3
```
'12345' | Add-ITGlueAPIKey
```

Converts the string to a SecureString and stores it in the global variable

### EXAMPLE 4
```powershell
Add-ITGlueAPIKey -EncryptedStandardAPIKeyFilePath 'C:\path\to\encrypted\key.txt' -EncryptedStandardAESKeyPath 'C:\path\to\decipher\key.txt'
```

Decrypts the AES API key and stores it in the global variable

## PARAMETERS

### -ApiKey
Plain text API key

If not defined the cmdlet will prompt you to enter the API key which
will be stored as a SecureString

```yaml
Type: String
Parameter Sets: PlainText
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ApiKeySecureString
Input a SecureString object containing the API key

```yaml
Type: SecureString
Parameter Sets: SecureString
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -EncryptedStandardAPIKeyPath
Path to the AES standard encrypted API key file

```yaml
Type: String
Parameter Sets: EncryptedByFile
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EncryptedStandardAESKeyPath
Path to the AES key file

```yaml
Type: String
Parameter Sets: EncryptedByFile
Aliases:

Required: True
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

[https://celerium.github.io/Celerium.ITGlue/site/Internal/Add-ITGlueAPIKey.html](https://celerium.github.io/Celerium.ITGlue/site/Internal/Add-ITGlueAPIKey.html)

[https://github.com/Celerium/Celerium.ITGlue](https://github.com/Celerium/Celerium.ITGlue)

