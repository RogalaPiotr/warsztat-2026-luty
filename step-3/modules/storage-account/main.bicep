// ============================================
// MODUŁ: Storage Account (Security Hardened)
// ============================================
// Best practices:
// - TLS 1.2 enforced (API max)
// - HTTPS only
// - Anonymous blob access disabled
// - Shared key access disabled (Entra ID only)
// - Infrastructure encryption enabled
// - Default OAuth authentication
// - Blob versioning enabled
// - Soft delete 30 days (blobs + containers)
// - Change feed enabled
// ============================================

@description('Nazwa Storage Account (globalnie unikalna, 3-24 lowercase alphanumeric).')
param name string

@description('Lokalizacja zasobu.')
param location string

@description('SKU dla Storage Account.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param skuName string = 'Standard_LRS'

@description('Tagi stosowane do zasobu.')
param tags object

@description('Wyłącz dostęp przez Shared Key (wymusza Entra ID).')
param disableSharedKeyAccess bool = true

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'

    // === SECURITY: Transport ===
    minimumTlsVersion: 'TLS1_2' // TLS 1.3 not yet supported in Bicep API, TLS1_2 is current max
    supportsHttpsTrafficOnly: true

    // === SECURITY: Access Control ===
    allowBlobPublicAccess: false // Blokuje anonimowy dostęp do blobów
    allowSharedKeyAccess: !disableSharedKeyAccess // false = tylko Entra ID
    defaultToOAuthAuthentication: true // Portal domyślnie używa Entra ID

    // === SECURITY: Encryption ===
    encryption: {
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
        table: {
          enabled: true
          keyType: 'Account'
        }
        queue: {
          enabled: true
          keyType: 'Account'
        }
      }
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption: true // Double encryption at rest
    }

    // === SECURITY: Network (public but secured) ===
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Allow' // Publiczny dostęp
      bypass: 'AzureServices' // Zezwól trusted Azure services
    }

    // === SECURITY: Cross-tenant replication ===
    allowCrossTenantReplication: false
  }
}

// === DATA PROTECTION: Versioning & Retention ===
resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    // Wersjonowanie blobów
    isVersioningEnabled: true

    // Soft delete dla blobów - 30 dni
    deleteRetentionPolicy: {
      enabled: true
      days: 30
    }

    // Soft delete dla kontenerów - 30 dni
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 30
    }

    // Change feed dla audytu zmian
    changeFeed: {
      enabled: true
      retentionInDays: 30
    }
  }
}

output id string = storageAccount.id
output name string = storageAccount.name
output primaryEndpoints object = storageAccount.properties.primaryEndpoints
