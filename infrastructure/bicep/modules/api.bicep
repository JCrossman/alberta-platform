// modules/api.bicep
// Azure Function App

param location string
param projectName string
param environment string
param tags object
param identityResourceGroupName string
param keyVaultName string
param appInsightsConnectionString string

// Storage for Function App (must allow shared key access)
var funcStorageName = take(replace('stfunc${projectName}${environment}', '-', ''), 24)

resource funcStorage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: funcStorageName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true  // Required for Functions
  }
}

// Function App (Flex Consumption)
resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: 'func-${projectName}-api-${environment}'
  location: location
  tags: tags
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
        }
        {
          name: 'KEY_VAULT_NAME'
          value: keyVaultName
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${funcStorage.name};EndpointSuffix=${az.environment().suffixes.storage};AccountKey=${funcStorage.listKeys().keys[0].value}'
        }
      ]
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
          'http://localhost:3000'
          'http://localhost:5173'
        ]
        supportCredentials: true
      }
      minTlsVersion: '1.2'
    }
  }
}

// NOTE: Grant Function App Key Vault access manually after deployment:
// az role assignment create --assignee <functionapp-principal-id> --role "Key Vault Secrets User" --scope <keyvault-id>

output functionAppUrl string = 'https://${functionApp.properties.defaultHostName}'
output functionAppName string = functionApp.name
output functionAppPrincipalId string = functionApp.identity.principalId
