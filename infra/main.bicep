@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Globally unique Azure App Service app name.')
param appName string

@description('App Service Plan name.')
param appServicePlanName string = '${appName}-plan'

@description('App Service Plan SKU. B1 is a small paid Linux tier suitable for simple validation.')
param skuName string = 'B1'

@description('Tags applied to all resources.')
param tags object = {
  project: 'migration-ado-sample'
}

resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource app 'Microsoft.Web/sites@2023-12-01' = {
  name: appName
  location: location
  tags: tags
  kind: 'app,linux'
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|10.0'
      alwaysOn: true
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      healthCheckPath: '/health'
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Production'
        }
      ]
    }
  }
}

output appName string = app.name
output appUrl string = 'https://${app.properties.defaultHostName}'
