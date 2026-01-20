// main.bicep
// Alberta Platform - Main Deployment Orchestrator
// Deploy with: az deployment sub create --location canadacentral --template-file main.bicep --parameters @parameters/dev.parameters.json

targetScope = 'subscription'

// ========================================
// Parameters
// ========================================

@description('Environment name (dev, test, prod)')
@allowed(['dev', 'test', 'prod'])
param environment string

@description('Primary Azure region')
param location string = 'canadacentral'

@description('Project name for resource naming')
param projectName string = 'alberta-platform'

@description('Owner email for tagging')
param ownerEmail string

@description('Deployment timestamp')
param deploymentTime string = utcNow('yyyy-MM-dd')

@description('Enable OpenAI model deployments')
param deployOpenAIModels bool = true

// ========================================
// Variables
// ========================================

var commonTags = {
  project: projectName
  environment: environment
  owner: ownerEmail
  createdBy: 'bicep'
  createdDate: deploymentTime
}

var resourceGroupNames = {
  identity: 'rg-${projectName}-identity-prod'
  data: 'rg-${projectName}-data-${environment}'
  ai: 'rg-${projectName}-ai-${environment}'
  governance: 'rg-${projectName}-governance-prod'
  api: 'rg-${projectName}-api-${environment}'
  web: 'rg-${projectName}-web-${environment}'
}

// ========================================
// Resource Groups
// ========================================

resource rgIdentity 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupNames.identity
  location: location
  tags: union(commonTags, { workload: 'identity' })
}

resource rgData 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupNames.data
  location: location
  tags: union(commonTags, { workload: 'data' })
}

resource rgAi 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupNames.ai
  location: location
  tags: union(commonTags, { workload: 'ai' })
}

resource rgGovernance 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupNames.governance
  location: location
  tags: union(commonTags, { workload: 'governance' })
}

resource rgApi 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupNames.api
  location: location
  tags: union(commonTags, { workload: 'api' })
}

resource rgWeb 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupNames.web
  location: location
  tags: union(commonTags, { workload: 'web' })
}

// ========================================
// Module Deployments
// ========================================

// Identity (Key Vault, Managed Identities)
module identity 'modules/identity.bicep' = {
  name: 'identity-deployment'
  scope: rgIdentity
  params: {
    location: location
    projectName: projectName
    environment: environment
    tags: commonTags
  }
}

// Monitoring (Log Analytics, App Insights)
module monitoring 'modules/monitoring.bicep' = {
  name: 'monitoring-deployment'
  scope: rgIdentity
  params: {
    location: location
    projectName: projectName
    environment: environment
    tags: commonTags
  }
}

// Storage (Data Lake, Backup)
module storage 'modules/storage.bicep' = {
  name: 'storage-deployment'
  scope: rgData
  params: {
    location: location
    projectName: projectName
    environment: environment
    tags: commonTags
    logAnalyticsWorkspaceId: monitoring.outputs.logAnalyticsWorkspaceId
  }
}

// AI Services (AI Foundry, OpenAI, AI Search)
module ai 'modules/ai.bicep' = {
  name: 'ai-deployment'
  scope: rgAi
  params: {
    location: location
    projectName: projectName
    environment: environment
    tags: commonTags
    identityResourceGroupName: resourceGroupNames.identity
    keyVaultName: identity.outputs.keyVaultName
    logAnalyticsWorkspaceId: monitoring.outputs.logAnalyticsWorkspaceId
    deployModels: deployOpenAIModels
  }
}

// API (Function App)
module api 'modules/api.bicep' = {
  name: 'api-deployment'
  scope: rgApi
  params: {
    location: location
    projectName: projectName
    environment: environment
    tags: commonTags
    identityResourceGroupName: resourceGroupNames.identity
    keyVaultName: identity.outputs.keyVaultName
    appInsightsConnectionString: monitoring.outputs.appInsightsConnectionString
  }
}

// Web (Static Web App)
module web 'modules/web.bicep' = {
  name: 'web-deployment'
  scope: rgWeb
  params: {
    location: location
    projectName: projectName
    environment: environment
    tags: commonTags
  }
}

// ========================================
// Outputs
// ========================================

output resourceGroups object = resourceGroupNames
output keyVaultName string = identity.outputs.keyVaultName
output keyVaultUri string = identity.outputs.keyVaultUri
output openAiEndpoint string = ai.outputs.openAiEndpoint
output aiSearchEndpoint string = ai.outputs.aiSearchEndpoint
output functionAppUrl string = api.outputs.functionAppUrl
output staticWebAppUrl string = web.outputs.staticWebAppUrl
output logAnalyticsWorkspaceId string = monitoring.outputs.logAnalyticsWorkspaceId
