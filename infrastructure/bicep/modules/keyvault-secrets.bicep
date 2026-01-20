// modules/keyvault-secrets.bicep
// Helper module to create Key Vault secrets in identity resource group

param keyVaultName string
param secrets array // [{name: string, value: string}]

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource kvSecrets 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = [for secret in secrets: {
  parent: keyVault
  name: secret.name
  properties: {
    value: secret.value
  }
}]
