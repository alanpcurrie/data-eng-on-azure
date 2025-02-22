@description('The name of the storage account')
param storageAccountName string

@description('The location for the storage account')
param location string = resourceGroup().location

@description('The SKU name for the storage account')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param storageSku string = 'Standard_LRS'

@description('Enable hierarchical namespace for ADLS Gen2')
param enableHierarchicalNamespace bool = true

@description('Tags for the storage account')
param tags object = {}

// Storage Account resource
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: storageSku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    isHnsEnabled: enableHierarchicalNamespace
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}

// Create a default container for data
resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
}

resource defaultContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServices
  name: 'data'
  properties: {
    publicAccess: 'None'
  }
}

// Outputs
output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
