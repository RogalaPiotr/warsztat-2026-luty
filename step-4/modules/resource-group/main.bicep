// ============================================
// MODUŁ: Resource Group (Subscription Scope)
// ============================================

targetScope = 'subscription'

@description('Nazwa Resource Group.')
param name string

@description('Lokalizacja Resource Group.')
param location string

@description('Tagi stosowane do zasobu.')
param tags object

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: name
  location: location
  tags: tags
}

output id string = resourceGroup.id
output name string = resourceGroup.name
output location string = resourceGroup.location
