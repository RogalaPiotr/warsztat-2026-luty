// ============================================
// MODUŁ: Storage Account
// ============================================

@description('Nazwa Storage Account (globalnie unikalna, 3-24 lowercase alphanumeric).')
param name string

@description('Lokalizacja zasobu.')
param location string

@description('Tagi stosowane do zasobu.')
param tags object

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
  }
}

output id string = storageAccount.id
output name string = storageAccount.name
