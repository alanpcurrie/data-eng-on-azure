@description('The name suffix for the Purview account')
param suffix string

@description('The location for the Purview account')
param location string

resource purviewAccount 'Microsoft.Purview/accounts@2021-07-01' = {
  name: 'purview${suffix}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    managedResourceGroupName: 'mrg-purview-${suffix}'
  }
}

output purviewId string = purviewAccount.id
output purviewName string = purviewAccount.name
