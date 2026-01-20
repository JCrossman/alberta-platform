// modules/web.bicep
// Azure Static Web App

param location string // Not used - Static Web Apps use fixed regions
param projectName string
param environment string
param tags object

// Static Web Apps not available in Canada Central - use East US 2
var staticWebAppLocation = 'eastus2'

// Static Web App
resource staticWebApp 'Microsoft.Web/staticSites@2023-01-01' = {
  name: 'swa-${projectName}-portal-${environment}'
  location: staticWebAppLocation
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

output staticWebAppUrl string = 'https://${staticWebApp.properties.defaultHostname}'
output staticWebAppName string = staticWebApp.name
output staticWebAppId string = staticWebApp.id
