// ============================================
// MODUŁ: Virtual Network + Subnet
// ============================================

@description('Nazwa Virtual Network.')
param name string

@description('Lokalizacja zasobu.')
param location string

@description('CIDR range dla Virtual Network.')
param addressPrefix string

@description('Nazwa Subnet.')
param subnetName string

@description('CIDR range dla Subnet.')
param subnetAddressPrefix string

@description('Tagi stosowane do zasobu.')
param tags object

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [addressPrefix]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }
}

output id string = vnet.id
output name string = vnet.name
output subnetId string = vnet.properties.subnets[0].id
