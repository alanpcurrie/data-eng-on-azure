using '../main.bicep'

param env = 'prod'
param location = 'eastus2' // East US 2 typically offers better pricing for ADX
param storageSku = 'Standard_GRS' // Using GRS for production environment for better data redundancy
