// modules/identity.bicep
// Key Vault and Managed Identities

param location string
param projectName string
param environment string
param tags object

// Key Vault name (must be globally unique, 3-24 chars)
var keyVaultName = 'kv-${projectName}-${environment}'

// User-assigned managed identity for platform services
resource platformIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-${projectName}-platform-${environment}'
  location: location
  tags: tags
}

// Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enablePurgeProtection: true
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}

// Grant platform identity access to Key Vault secrets
resource keyVaultSecretUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, platformIdentity.id, 'Key Vault Secrets User')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
    principalId: platformIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

output keyVaultName string = keyVault.name
output keyVaultUri string = keyVault.properties.vaultUri
output keyVaultId string = keyVault.id
output platformIdentityId string = platformIdentity.id
output platformIdentityPrincipalId string = platformIdentity.properties.principalId
