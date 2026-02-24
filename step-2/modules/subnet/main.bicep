// ============================================
// MODUŁ: Subnet
// ============================================

@description('Nazwa Subnet.')
param name string

@description('Nazwa Virtual Network (parent).')
param virtualNetworkName string

@description('CIDR range dla Subnet.')
param addressPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = {
  parent: vnet
  name: name
  properties: {
    addressPrefix: addressPrefix
  }
}

output id string = subnet.id
output name string = subnet.name
