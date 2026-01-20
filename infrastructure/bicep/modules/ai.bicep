// modules/ai.bicep
// Azure AI Services (OpenAI, AI Search)

param location string
param projectName string
param environment string
param tags object
param identityResourceGroupName string
param keyVaultName string
param logAnalyticsWorkspaceId string
param deployModels bool = true

// Azure OpenAI Service (deployed in East US for model availability)
resource openAi 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' = {
  name: 'oai-${projectName}-${environment}'
  location: 'eastus'  // Model availability
  tags: union(tags, { note: 'deployed-in-eastus-for-model-availability' })
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  properties: {
    customSubDomainName: 'oai-${projectName}-${environment}'
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
}

// GPT-4o deployment
resource gpt4oDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = if (deployModels) {
  parent: openAi
  name: 'gpt-4o'
  sku: {
    name: 'Standard'
    capacity: 10
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4o'
      version: '2024-08-06'
    }
  }
}

// Embedding deployment
resource embeddingDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = if (deployModels) {
  parent: openAi
  name: 'text-embedding-3-small'
  sku: {
    name: 'Standard'
    capacity: 120
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'text-embedding-3-small'
      version: '1'
    }
  }
  dependsOn: [gpt4oDeployment]
}

// Azure AI Search
resource aiSearch 'Microsoft.Search/searchServices@2023-11-01' = {
  name: 'srch-${projectName}-${environment}'
  location: location
  tags: tags
  sku: {
    name: environment == 'prod' ? 'standard' : 'basic'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    publicNetworkAccess: 'enabled'
    semanticSearch: 'free'
  }
}

// Store secrets in Key Vault (via module deploying to identity resource group)
module aiSecrets './keyvault-secrets.bicep' = {
  name: 'ai-secrets'
  scope: resourceGroup(identityResourceGroupName)
  params: {
    keyVaultName: keyVaultName
    secrets: [
      {
        name: 'openai-api-key'
        value: openAi.listKeys().key1
      }
      {
        name: 'aisearch-api-key'
        value: aiSearch.listAdminKeys().primaryKey
      }
    ]
  }
}

// Diagnostic settings
resource openAiDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-${openAi.name}'
  scope: openAi
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'Audit'
        enabled: true
      }
      {
        category: 'RequestResponse'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output openAiEndpoint string = openAi.properties.endpoint
output openAiName string = openAi.name
output aiSearchEndpoint string = 'https://${aiSearch.name}.search.windows.net'
output aiSearchName string = aiSearch.name
