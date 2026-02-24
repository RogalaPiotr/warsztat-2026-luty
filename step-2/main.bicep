// ============================================
// MODULARYZACJA: Wywołania modułów
// ============================================

// ===========================================
// PARAMETRY
// ===========================================

@description('Lokalizacja zasobów.')
param location string

@description('Nazwa Virtual Network.')
param vnetName string

@description('CIDR range dla Virtual Network.')
param vnetAddressPrefix string

@description('Nazwa Subnet.')
param subnetName string

@description('CIDR range dla Subnet.')
param subnetAddressPrefix string

@description('Nazwa Network Interface.')
param nicName string

@description('Nazwa Storage Account (globalnie unikalna, 3-24 lowercase alphanumeric).')
param storageAccountName string

@description('Tagi stosowane do zasobów.')
param tags object

@description('Timestamp dla unikalności deploymentów.')
param timestamp string = utcNow('yyyyMMddHHmmss')

// ===========================================
// MODUŁY
// ===========================================

// 1. Virtual Network
module vnet 'modules/virtual-network/main.bicep' = {
  name: 'vnet-step2-${timestamp}'
  params: {
    name: vnetName
    location: location
    addressPrefix: vnetAddressPrefix
    tags: tags
  }
}

// 2. Subnet (depends on VNet)
module subnet 'modules/subnet/main.bicep' = {
  name: 'subnet-step2-${timestamp}'
  params: {
    name: subnetName
    virtualNetworkName: vnet.outputs.name
    addressPrefix: subnetAddressPrefix
  }
}

// 3. Network Interface (depends on Subnet)
module nic 'modules/network-interface/main.bicep' = {
  name: 'nic-step2-${timestamp}'
  params: {
    name: nicName
    location: location
    subnetId: subnet.outputs.id
    tags: tags
  }
}

// 4. Storage Account (independent)
module storageAccount 'modules/storage-account/main.bicep' = {
  name: 'st-step2-${timestamp}'
  params: {
    name: storageAccountName
    location: location
    tags: tags
  }
}

// ===========================================
// OUTPUTS
// ===========================================
output vnetId string = vnet.outputs.id
output subnetId string = subnet.outputs.id
output nicId string = nic.outputs.id
output storageAccountId string = storageAccount.outputs.id
