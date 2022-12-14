param iotcApiKey string
param iotcAppUrl string

param identity object

param sqlEndpoint string
param sqlDatabase string
param sqlUserName string
@secure()
param sqlPassword string
param functionName string
param functionUrl string
param eventHubName string

param grafanaEndpoint string

param dpsResourceName string

param projectName string = 'contoso'

@secure()
param storageAccountKey string
param storageAccountName string

resource SetupScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  kind: 'AzureCLI'
  location: resourceGroup().location
  name: '${projectName}-configscript'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identity.Id}': {}
    }
  }
  properties: {
    storageAccountSettings: {
      storageAccountKey: storageAccountKey
      storageAccountName: storageAccountName
    }
    azCliVersion: '2.42.0'
    cleanupPreference: 'OnExpiration'
    timeout: 'PT2H'
    retentionInterval: 'P1D'
    primaryScriptUri: 'https://raw.githubusercontent.com/lucadruda/iotc-solution-migrator/main/deployments/scripts/config.sh'
    environmentVariables: [
      {
        name: 'SUBSCRIPTION_ID'
        value: subscription().subscriptionId
      }
      {
        name: 'FUNCTIONAPP_NAME'
        value: functionName
      }
      {
        name: 'FUNCTIONAPP_URL'
        value: functionUrl
      }
      {
        name: 'RESOURCE_GROUP'
        value: resourceGroup().name
      }
      {
        name: 'REPO_URL'
        value: 'https://github.com/lucadruda/iotc-solution-migrator'
      }
      {
        name: 'REPO_BRANCH'
        value: 'main'
      }
      {
        name: 'IOTC_API_KEY'
        value: iotcApiKey
      }
      {
        name: 'IOTC_APP_URL'
        value: iotcAppUrl
      }
      {
        name: 'DPS_RESOURCE_NAME'
        value: dpsResourceName
      }
      {
        name: 'DPS_ENROLLMENT_NAME'
        value: uniqueString(projectName, 'saskeys', resourceGroup().name)
      }
      {
        name: 'IDENTITY_NAME'
        value: identity.name
      }
      {
        name: 'SQL_ENDPOINT'
        value: sqlEndpoint
      }
      {
        name: 'SQL_DATABASE'
        value: sqlDatabase
      }
      {
        name: 'SQL_USERNAME'
        value: sqlUserName
      }
      {
        name: 'SQL_PASSWORD'
        value: sqlPassword
      }
      {
        name: 'EVENTHUB_NAME'
        value: eventHubName
      }
      {
        name: 'GRAFANA_ENDPOINT'
        value: grafanaEndpoint
      }
    ]
  }
}
