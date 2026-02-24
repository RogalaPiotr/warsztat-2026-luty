// ============================================
// MODUŁ: Network Interface
// ============================================

@description('Nazwa Network Interface.')
param name string

@description('Lokalizacja zasobu.')
param location string

@description('ID subnet dla NIC.')
param subnetId string

@description('Tagi stosowane do zasobu.')
param tags object

resource nic 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

output id string = nic.id
output name string = nic.name
