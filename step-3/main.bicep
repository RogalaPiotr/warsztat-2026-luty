// ============================================
// SUBSCRIPTION-SCOPE DEPLOYMENT + MULTI-ENV
// ============================================
targetScope = 'subscription'

// ===========================================
// PARAMETRY
// ===========================================

@description('Nazwa środowiska (dev, test, prod).')
@allowed(['dev', 'test', 'prod'])
param environment string

@description('Lokalizacja zasobów.')
param location string

@description('Nazwa Resource Group.')
param resourceGroupName string

@description('Nazwa Virtual Network.')
param vnetName string

@description('CIDR range dla Virtual Network.')
param vnetAddressPrefix string

@description('Nazwa Subnet.')
param subnetName string

@description('CIDR range dla Subnet.')
param subnetAddressPrefix string

@description('Nazwa Storage Account (globalnie unikalna).')
param storageAccountName string

@description('SKU dla Storage Account.')
@allowed(['Standard_LRS', 'Standard_GRS', 'Standard_ZRS', 'Premium_LRS'])
param storageSkuName string

@description('Tagi stosowane do zasobów.')
param tags object

@description('Timestamp dla unikalności deploymentów.')
param timestamp string = utcNow('yyyyMMddHHmmss')

// ===========================================
// 1. RESOURCE GROUP (subscription scope)
// ===========================================
module rg 'modules/resource-group/main.bicep' = {
  name: 'rg-step3-${environment}-${timestamp}'
  params: {
    name: resourceGroupName
    location: location
    tags: tags
  }
}

// ===========================================
// 2. VIRTUAL NETWORK (resource group scope)
// ===========================================
module vnet 'modules/virtual-network/main.bicep' = {
  name: 'vnet-step3-${environment}-${timestamp}'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: vnetName
    location: location
    addressPrefix: vnetAddressPrefix
    subnetName: subnetName
    subnetAddressPrefix: subnetAddressPrefix
    tags: tags
  }
  dependsOn: [rg]
}

// ===========================================
// 3. STORAGE ACCOUNT (resource group scope)
// ===========================================
module storage 'modules/storage-account/main.bicep' = {
  name: 'st-step3-${environment}-${timestamp}'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: storageAccountName
    location: location
    skuName: storageSkuName
    tags: tags
  }
  dependsOn: [rg]
}

// ===========================================
// OUTPUTS
// ===========================================
output resourceGroupId string = rg.outputs.id
output resourceGroupName string = rg.outputs.name
output vnetId string = vnet.outputs.id
output subnetId string = vnet.outputs.subnetId
output storageAccountId string = storage.outputs.id
output storageAccountName string = storage.outputs.name
