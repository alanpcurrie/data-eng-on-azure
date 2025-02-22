@description('The environment name (dev, test, prod)')
param env string

@description('The location for all resources')
param location string = resourceGroup().location

module adxCluster 'modules/adx.bicep' = {
  name: 'adx-deployment'
  params: {
    suffix: env
    location: location
  }
}

output clusterName string = adxCluster.outputs.clusterName
output clusterUri string = adxCluster.outputs.clusterUri
