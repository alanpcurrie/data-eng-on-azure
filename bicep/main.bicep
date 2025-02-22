@description('The environment name (dev, test, prod)')
param env string

@description('The location for all resources')
param location string = resourceGroup().location

@description('The storage account SKU')
param storageSku string = 'Standard_LRS'

module storageAccount 'modules/storage.bicep' = {
  name: 'storage-deployment'
  params: {
    storageAccountName: 'stdata${env}${uniqueString(resourceGroup().id)}'
    location: location
    storageSku: storageSku
    tags: {
      environment: env
      purpose: 'data lake storage'
    }
  }
}

module adxCluster 'modules/adx.bicep' = {
  name: 'adx-deployment'
  params: {
    suffix: env
    location: location
  }
}

output clusterName string = adxCluster.outputs.clusterName
output clusterUri string = adxCluster.outputs.clusterUri
output storageAccountName string = storageAccount.outputs.storageAccountName
