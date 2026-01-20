# Azure Infrastructure as Code - Alberta Platform

## Overview

This document provides Bicep templates for deploying the Alberta Platform infrastructure following Azure best practices.

---

## Directory Structure

```
infrastructure/
├── bicep/
│   ├── main.bicep                    # Main deployment orchestrator
│   ├── modules/
│   │   ├── resource-groups.bicep     # Resource group definitions
│   │   ├── identity.bicep            # Key Vault, managed identities
│   │   ├── networking.bicep          # VNet, subnets, NSGs
│   │   ├── monitoring.bicep          # Log Analytics, App Insights
│   │   ├── storage.bicep             # Storage accounts
│   │   ├── ai.bicep                  # AI Foundry, OpenAI, AI Search
│   │   ├── api.bicep                 # Function App, API Management
│   │   └── web.bicep                 # Static Web App
│   ├── parameters/
│   │   ├── dev.parameters.json       # Development environment
│   │   └── prod.parameters.json      # Production environment
│   └── scripts/
│       ├── deploy.sh                 # Deployment script
│       └── destroy.sh                # Teardown script
└── README.md
```

---

## Main Deployment Template

```bicep
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

@description('Enable networking (VNet, private endpoints)')
param enableNetworking bool = false

@description('Enable API Management')
param enableApiManagement bool = false

// ========================================
// Variables
// ========================================

var tags = {
  project: projectName
  environment: environment
  owner: ownerEmail
  createdBy: 'bicep'
  createdDate: utcNow('yyyy-MM-dd')
}

var resourceGroupNames = {
  identity: 'rg-${projectName}-identity-${environment}'
  network: 'rg-${projectName}-network-${environment}'
  data: 'rg-${projectName}-data-${environment}'
  ai: 'rg-${projectName}-ai-${environment}'
  governance: 'rg-${projectName}-governance-${environment}'
  api: 'rg-${projectName}-api-${environment}'
  web: 'rg-${projectName}-web-${environment}'
}

// ========================================
// Resource Groups
// ========================================

resource rgIdentity 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupNames.identity
  location: location
  tags: union(tags, { workload: 'identity' })
}

resource rgNetwork 'Microsoft.Resources/resourceGroups@2023-07-01' = if (enableNetworking) {
  name: resourceGroupNames.network
  location: location
  tags: union(tags, { workload: 'network' })
}

resource rgData 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupNames.data
  location: location
  tags: union(tags, { workload: 'data' })
}

resource rgAi 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupNames.ai
  location: location
  tags: union(tags, { workload: 'ai' })
}

resource rgGovernance 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupNames.governance
  location: location
  tags: union(tags, { workload: 'governance' })
}

resource rgApi 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupNames.api
  location: location
  tags: union(tags, { workload: 'api' })
}

resource rgWeb 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupNames.web
  location: location
  tags: union(tags, { workload: 'web' })
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
    tags: tags
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
    tags: tags
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
    tags: tags
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
    tags: tags
    keyVaultName: identity.outputs.keyVaultName
    logAnalyticsWorkspaceId: monitoring.outputs.logAnalyticsWorkspaceId
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
    tags: tags
    keyVaultName: identity.outputs.keyVaultName
    appInsightsInstrumentationKey: monitoring.outputs.appInsightsInstrumentationKey
    appInsightsConnectionString: monitoring.outputs.appInsightsConnectionString
    enableApiManagement: enableApiManagement
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
    tags: tags
  }
}

// ========================================
// Outputs
// ========================================

output resourceGroups object = resourceGroupNames
output keyVaultName string = identity.outputs.keyVaultName
output keyVaultUri string = identity.outputs.keyVaultUri
output functionAppUrl string = api.outputs.functionAppUrl
output staticWebAppUrl string = web.outputs.staticWebAppUrl
output logAnalyticsWorkspaceId string = monitoring.outputs.logAnalyticsWorkspaceId
```

---

## Identity Module (Key Vault)

```bicep
// modules/identity.bicep
// Key Vault and Managed Identities

param location string
param projectName string
param environment string
param tags object

// Key Vault name (must be globally unique, 3-24 chars, alphanumeric and hyphens)
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
    enableRbacAuthorization: true  // Use RBAC instead of access policies
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enablePurgeProtection: true
    publicNetworkAccess: 'Enabled'  // Set to 'Disabled' for prod with private endpoints
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'  // Set to 'Deny' for prod
    }
  }
}

// Grant platform identity access to Key Vault secrets
resource keyVaultSecretUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, platformIdentity.id, 'Key Vault Secrets User')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6') // Key Vault Secrets User
    principalId: platformIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Diagnostic settings for Key Vault
resource keyVaultDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-${keyVaultName}'
  scope: keyVault
  properties: {
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 90
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 90
        }
      }
    ]
  }
}

output keyVaultName string = keyVault.name
output keyVaultUri string = keyVault.properties.vaultUri
output platformIdentityId string = platformIdentity.id
output platformIdentityPrincipalId string = platformIdentity.properties.principalId
```

---

## Monitoring Module

```bicep
// modules/monitoring.bicep
// Log Analytics and Application Insights

param location string
param projectName string
param environment string
param tags object

// Log Analytics Workspace
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'log-${projectName}-${environment}'
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 90
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// Application Insights (for API and Web)
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-${projectName}-${environment}'
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// Action Group for alerts
resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: 'ag-${projectName}-${environment}'
  location: 'global'
  tags: tags
  properties: {
    groupShortName: 'Alberta'
    enabled: true
    emailReceivers: [
      {
        name: 'Owner'
        emailAddress: tags.owner
        useCommonAlertSchema: true
      }
    ]
  }
}

// Budget alert (using consumption API)
// Note: Budget creation via Bicep requires subscription-level deployment

output logAnalyticsWorkspaceId string = logAnalytics.id
output logAnalyticsWorkspaceName string = logAnalytics.name
output appInsightsId string = appInsights.id
output appInsightsInstrumentationKey string = appInsights.properties.InstrumentationKey
output appInsightsConnectionString string = appInsights.properties.ConnectionString
output actionGroupId string = actionGroup.id
```

---

## Storage Module

```bicep
// modules/storage.bicep
// Storage Account for data and backups

param location string
param projectName string
param environment string
param tags object
param logAnalyticsWorkspaceId string

// Storage account name (must be globally unique, 3-24 chars, lowercase alphanumeric only)
var storageAccountName = replace('st${projectName}${environment}', '-', '')

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: take(storageAccountName, 24)  // Max 24 chars
  location: location
  tags: tags
  sku: {
    name: environment == 'prod' ? 'Standard_GRS' : 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false  // Force Azure AD auth
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: environment == 'prod' ? 'Deny' : 'Allow'
    }
  }
}

// Blob service
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    deleteRetentionPolicy: {
      enabled: true
      days: 30
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 30
    }
  }
}

// Containers
resource dataContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobService
  name: 'data'
  properties: {
    publicAccess: 'None'
  }
}

resource backupContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobService
  name: 'backup'
  properties: {
    publicAccess: 'None'
  }
}

// Diagnostic settings
resource storageDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-${storageAccount.name}'
  scope: storageAccount
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 90
        }
      }
    ]
  }
}

output storageAccountName string = storageAccount.name
output storageAccountId string = storageAccount.id
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob
```

---

## AI Module

```bicep
// modules/ai.bicep
// Azure AI Foundry, OpenAI, and AI Search

param location string
param projectName string
param environment string
param tags object
param keyVaultName string
param logAnalyticsWorkspaceId string

// Azure OpenAI Service
resource openAi 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' = {
  name: 'oai-${projectName}-${environment}'
  location: location
  tags: tags
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
resource gpt4oDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = {
  parent: openAi
  name: 'gpt-4o'
  sku: {
    name: 'Standard'
    capacity: 10  // Tokens per minute in thousands
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4o'
      version: '2024-08-06'
    }
    raiPolicyName: 'Microsoft.Default'
  }
}

// Embedding deployment
resource embeddingDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = {
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
  dependsOn: [gpt4oDeployment]  // Deploy sequentially
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

// AI Foundry Hub (Machine Learning workspace)
resource aiHub 'Microsoft.MachineLearningServices/workspaces@2024-04-01' = {
  name: 'ai-${projectName}-${environment}'
  location: location
  tags: tags
  kind: 'Hub'
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    friendlyName: 'Alberta Platform AI Hub'
    description: 'AI Foundry hub for Alberta Platform'
    publicNetworkAccess: 'Enabled'
    v1LegacyMode: false
  }
}

// Store OpenAI key in Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource openAiKeySecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'openai-api-key'
  properties: {
    value: openAi.listKeys().key1
  }
}

resource aiSearchKeySecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'aisearch-api-key'
  properties: {
    value: aiSearch.listAdminKeys().primaryKey
  }
}

// Diagnostic settings for OpenAI
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
output aiHubId string = aiHub.id
output aiHubName string = aiHub.name
```

---

## API Module (Function App)

```bicep
// modules/api.bicep
// Azure Function App and optional API Management

param location string
param projectName string
param environment string
param tags object
param keyVaultName string
param appInsightsInstrumentationKey string
param appInsightsConnectionString string
param enableApiManagement bool

// Storage for Function App
var funcStorageName = replace('stfunc${projectName}${environment}', '-', '')

resource funcStorage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: take(funcStorageName, 24)
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
  }
}

// App Service Plan (Consumption for dev, Premium for prod)
resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: 'asp-${projectName}-${environment}'
  location: location
  tags: tags
  sku: {
    name: environment == 'prod' ? 'EP1' : 'Y1'
    tier: environment == 'prod' ? 'ElasticPremium' : 'Dynamic'
  }
  properties: {
    reserved: true  // Linux
  }
}

// Function App
resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: 'func-${projectName}-api-${environment}'
  location: location
  tags: tags
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
    siteConfig: {
      linuxFxVersion: 'NODE|20'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${funcStorage.name};EndpointSuffix=core.windows.net;AccountKey=${funcStorage.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${funcStorage.name};EndpointSuffix=core.windows.net;AccountKey=${funcStorage.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: 'func-${projectName}-api-${environment}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsInstrumentationKey
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
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
          'https://*.staticwebapps.net'
          'http://localhost:3000'
          'http://localhost:5173'
        ]
        supportCredentials: true
      }
      minTlsVersion: '1.2'
    }
  }
}

// Grant Function App access to Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource funcKeyVaultAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, functionApp.id, 'Key Vault Secrets User')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
    principalId: functionApp.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

// API Management (optional)
resource apiManagement 'Microsoft.ApiManagement/service@2023-03-01-preview' = if (enableApiManagement) {
  name: 'apim-${projectName}-${environment}'
  location: location
  tags: tags
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    publisherEmail: tags.owner
    publisherName: 'Alberta Platform'
  }
}

output functionAppUrl string = 'https://${functionApp.properties.defaultHostName}'
output functionAppName string = functionApp.name
output functionAppPrincipalId string = functionApp.identity.principalId
output apiManagementUrl string = enableApiManagement ? 'https://${apiManagement.properties.gatewayUrl}' : ''
```

---

## Web Module (Static Web App)

```bicep
// modules/web.bicep
// Azure Static Web App

param location string
param projectName string
param environment string
param tags object

// Static Web App
resource staticWebApp 'Microsoft.Web/staticSites@2023-01-01' = {
  name: 'swa-${projectName}-portal-${environment}'
  location: location
  tags: tags
  sku: {
    name: environment == 'prod' ? 'Standard' : 'Free'
    tier: environment == 'prod' ? 'Standard' : 'Free'
  }
  properties: {
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    buildProperties: {
      appLocation: '/'
      apiLocation: 'api'
      outputLocation: 'dist'
    }
  }
}

// Custom domain (optional, configure manually)
// resource customDomain 'Microsoft.Web/staticSites/customDomains@2023-01-01' = {
//   parent: staticWebApp
//   name: 'portal.alberta.example.com'
//   properties: {}
// }

output staticWebAppUrl string = 'https://${staticWebApp.properties.defaultHostname}'
output staticWebAppName string = staticWebApp.name
output staticWebAppId string = staticWebApp.id
```

---

## Parameter Files

### Development Parameters

```json
// parameters/dev.parameters.json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environment": {
      "value": "dev"
    },
    "location": {
      "value": "canadacentral"
    },
    "projectName": {
      "value": "alberta-platform"
    },
    "ownerEmail": {
      "value": "jcrossman@microsoft.com"
    },
    "enableNetworking": {
      "value": false
    },
    "enableApiManagement": {
      "value": false
    }
  }
}
```

### Production Parameters

```json
// parameters/prod.parameters.json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environment": {
      "value": "prod"
    },
    "location": {
      "value": "canadacentral"
    },
    "projectName": {
      "value": "alberta-platform"
    },
    "ownerEmail": {
      "value": "jcrossman@microsoft.com"
    },
    "enableNetworking": {
      "value": true
    },
    "enableApiManagement": {
      "value": true
    }
  }
}
```

---

## Deployment Scripts

### Deploy Script

```bash
#!/bin/bash
# scripts/deploy.sh
# Deploy Alberta Platform infrastructure

set -e

# Configuration
ENVIRONMENT=${1:-dev}
LOCATION="canadacentral"
DEPLOYMENT_NAME="alberta-platform-${ENVIRONMENT}-$(date +%Y%m%d%H%M%S)"

echo "🚀 Deploying Alberta Platform - ${ENVIRONMENT}"
echo "   Location: ${LOCATION}"
echo "   Deployment: ${DEPLOYMENT_NAME}"

# Validate template
echo "📋 Validating Bicep template..."
az deployment sub validate \
  --location $LOCATION \
  --template-file main.bicep \
  --parameters @parameters/${ENVIRONMENT}.parameters.json

# Deploy
echo "🏗️ Deploying infrastructure..."
az deployment sub create \
  --name $DEPLOYMENT_NAME \
  --location $LOCATION \
  --template-file main.bicep \
  --parameters @parameters/${ENVIRONMENT}.parameters.json \
  --verbose

# Get outputs
echo "📤 Deployment outputs:"
az deployment sub show \
  --name $DEPLOYMENT_NAME \
  --query properties.outputs

echo "✅ Deployment complete!"
```

### Destroy Script

```bash
#!/bin/bash
# scripts/destroy.sh
# Destroy Alberta Platform infrastructure

set -e

ENVIRONMENT=${1:-dev}
PROJECT="alberta-platform"

echo "⚠️ WARNING: This will delete all resources for ${PROJECT}-${ENVIRONMENT}"
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
  echo "Aborted."
  exit 1
fi

# List of resource groups
RGS=(
  "rg-${PROJECT}-identity-${ENVIRONMENT}"
  "rg-${PROJECT}-network-${ENVIRONMENT}"
  "rg-${PROJECT}-data-${ENVIRONMENT}"
  "rg-${PROJECT}-ai-${ENVIRONMENT}"
  "rg-${PROJECT}-governance-${ENVIRONMENT}"
  "rg-${PROJECT}-api-${ENVIRONMENT}"
  "rg-${PROJECT}-web-${ENVIRONMENT}"
)

for RG in "${RGS[@]}"; do
  echo "🗑️ Deleting ${RG}..."
  az group delete --name $RG --yes --no-wait 2>/dev/null || echo "   (not found)"
done

echo "✅ Deletion initiated (async). Check Azure portal for status."
```

---

## Quick Start

```bash
# 1. Clone repository
cd ~/projects/FoundryPurview

# 2. Navigate to infrastructure
cd infrastructure/bicep

# 3. Login to Azure
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# 4. Deploy dev environment
chmod +x scripts/deploy.sh
./scripts/deploy.sh dev

# 5. Verify deployment
az group list --query "[?starts_with(name, 'rg-alberta-platform')]" -o table
```

---

## Notes

### What's NOT in Bicep (Manual Setup Required)

1. **Microsoft Fabric** - No Bicep support yet, use Azure Portal
2. **Microsoft Purview** - Limited Bicep support, use Azure Portal
3. **Copilot Studio** - Power Platform, use Power Platform Admin Center
4. **Power BI** - Use Power BI service portal

### Post-Deployment Steps

1. Enable Microsoft Fabric trial in Azure Portal
2. Create Purview account in Azure Portal
3. Connect Fabric workspaces to Purview
4. Configure Copilot Studio environment
5. Set up Power BI workspace and connect to Fabric

### Cost Management

- Set up budget alerts before deploying
- Use auto-pause for Fabric capacity
- Delete dev resources when not in use
- Monitor costs daily in first month

---

**Document Version**: 1.0  
**Last Updated**: January 2026  
**Owner**: Jeremy Crossman (jcrossman@microsoft.com)
