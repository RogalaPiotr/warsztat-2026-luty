// ============================================
// MODUŁ: Resource Group (subscription scope)
// ============================================
targetScope = 'subscription'

@description('Nazwa Resource Group.')
param name string

@description('Lokalizacja Resource Group.')
param location string

@description('Tagi stosowane do zasobu.')
param tags object

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: name
  location: location
  tags: tags
}

output id string = rg.id
output name string = rg.name
output location string = rg.location
