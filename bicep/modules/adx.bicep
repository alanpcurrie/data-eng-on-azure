@description('The name suffix for the ADX cluster')
param suffix string

@description('The location for the ADX cluster. Consider using eastus2 or westus2 for better pricing. See: https://azure.microsoft.com/en-us/pricing/details/data-explorer/')
param location string

resource adxCluster 'Microsoft.Kusto/clusters@2023-08-15' = {
  name: 'adx${suffix}'
  location: location
  sku: {
    name: 'Dev(No SLA)_Standard_D11_v2'
    tier: 'Basic'
    capacity: 1
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output clusterName string = adxCluster.name
output clusterUri string = adxCluster.properties.uri
