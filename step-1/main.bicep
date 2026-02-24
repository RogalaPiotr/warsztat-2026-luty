// ============================================
// MONOLIT: Wszystkie zasoby w jednym pliku
// ============================================

// ===========================================
// PARAMETRY
// ===========================================

@description('Lokalizacja zasobów.')
param location string = resourceGroup().location

@description('Nazwa Virtual Network.')
param vnetName string = 'vnet-workshop-step1-dev-we-001'

@description('CIDR range dla Virtual Network.')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Nazwa Subnet.')
param subnetName string = 'snet-workshop-step1-dev-we-001'

@description('CIDR range dla Subnet.')
param subnetAddressPrefix string = '10.0.1.0/24'

@description('Nazwa Network Interface.')
param nicName string = 'nic-workshop-step1-dev-we-001'

@description('Nazwa Storage Account (globalnie unikalna, 3-24 lowercase alphanumeric).')
param storageAccountName string = 'stworkshopstep1dev001'

@description('Tagi stosowane do zasobów.')
param tags object = {
  project: 'bicep-workshop'
  deployedBy: 'url|name|tool'
  envType: 'dev'
  owner: 'platform-team'
  costCenter: 'CC1000'
}

// ===========================================
// 1. Virtual Network
// ===========================================
resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [vnetAddressPrefix]
    }
  }
}

// ===========================================
// 2. Subnet
// ===========================================
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: subnetAddressPrefix
  }
}

// ===========================================
// 3. Network Interface (NIC)
// ===========================================
resource nic 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: nicName
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}

// ===========================================
// 4. Storage Account
// ===========================================
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

// ===========================================
// OUTPUTS
// ===========================================
output vnetId string = vnet.id
output subnetId string = subnet.id
output nicId string = nic.id
output storageAccountId string = storageAccount.id
