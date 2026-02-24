// ============================================
// MODUŁ: SQL Database
// ============================================
// Best practices:
// - Configurable SKU (Basic, S0, S1, etc.)
// - Zone redundancy config
// - Enclave VBS
// ============================================

@description('Nazwa bazy danych SQL.')
param name string

@description('Lokalizacja zasobu.')
param location string

@description('Nazwa SQL Server.')
param sqlServerName string

@description('SKU Name (np. Basic, S0, S1, GP_Gen5_2).')
param skuName string = 'Basic'

@description('SKU Tier (np. Basic, Standard, GeneralPurpose).')
param skuTier string = 'Basic'

@description('Collation dla bazy danych.')
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Maksymalny rozmiar w bajtach.')
param maxSizeBytes int = 2147483648 // 2 GB

@description('Włącz zone redundancy.')
param zoneRedundant bool = false

@description('Tagi stosowane do zasobu.')
param tags object

// Reference existing SQL Server
resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: sqlServerName
}

// SQL Database
resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-08-01-preview' = {
  parent: sqlServer
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    collation: collation
    maxSizeBytes: maxSizeBytes
    zoneRedundant: zoneRedundant
    preferredEnclaveType: 'VBS'
  }
}

output id string = sqlDatabase.id
output name string = sqlDatabase.name
