// Bicep template to deploy an Azure Storage Account

// Parameters

@description('The location for the storage account')
param location string = resourceGroup().location

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
@description('The SKU of the storage account')
param skuName string = 'Standard_LRS'

@description('Timestamp for the deployment')
param deploymentTimestamp string = utcNow()

// Variables

var storageAccountName = toLower('sa${uniqueString(resourceGroup().id)}')
var tags = union(resourceGroup().tags, {
  CreatedBy: 'Bicep Template'
  CreatedOn: deploymentTimestamp
})

// Resources
module storageAccount 'br/public:avm/res/storage/storage-account:0.32.0' = {
  params: {
    // Required parameters
    name: storageAccountName
    // Non-required parameters
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    managedIdentities: {
      systemAssigned: true
    }
    skuName: skuName
    tags: tags
  }
}
