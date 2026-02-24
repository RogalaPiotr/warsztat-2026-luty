// ============================================
// STEP 5: SQL Server + Database (Subscription Scope)
// ============================================
// Deployment: az deployment sub create
// Multi-env: dev, test, prod
// Key Vault integration: hasło SQL z step-4
// ============================================
targetScope = 'subscription'

// ============================================
// PARAMETERS
// ============================================

@description('Środowisko wdrożenia.')
@allowed(['dev', 'test', 'prod'])
param environment string

@description('Lokalizacja zasobów Azure.')
param location string

@description('Nazwa Resource Group z Key Vault (step-4).')
param keyVaultResourceGroup string

@description('Nazwa Key Vault z step-4.')
param keyVaultName string

@description('Nazwa sekretu z hasłem SQL admin.')
param sqlAdminPasswordSecretName string

@description('Login administratora SQL.')
param sqlAdminLogin string

@description('SKU Name dla SQL Database.')
param sqlDatabaseSkuName string

@description('SKU Tier dla SQL Database.')
param sqlDatabaseSkuTier string

@description('Lista dozwolonych adresów IP.')
param allowedIpAddresses array

@description('Nazwa Resource Group dla step-5.')
param resourceGroupName string

@description('Nazwa SQL Server (globalnie unikalna).')
param sqlServerName string

@description('Nazwa SQL Database.')
param sqlDatabaseName string

@description('Tagi dla wszystkich zasobów.')
param tags object

@description('Timestamp dla unikalności deploymentów.')
param timestamp string = utcNow('yyyyMMddHHmmss')

// ============================================
// EXISTING KEY VAULT (from step-4)
// ============================================
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
  scope: resourceGroup(keyVaultResourceGroup)
}

// ============================================
// MODULES
// ============================================

// Resource Group
module rg 'modules/resource-group/main.bicep' = {
  name: 'rg-step5-${environment}-${timestamp}'
  params: {
    name: resourceGroupName
    location: location
    tags: tags
  }
}

// SQL Server
module sqlServer 'modules/sql-server/main.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'sql-server-step5-${environment}-${timestamp}'
  params: {
    name: sqlServerName
    location: location
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: keyVault.getSecret(sqlAdminPasswordSecretName)
    publicNetworkAccessEnabled: true
    allowedIpAddresses: allowedIpAddresses
    tags: tags
  }
  dependsOn: [rg]
}

// SQL Database
module sqlDatabase 'modules/sql-database/main.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'sql-database-step5-${environment}-${timestamp}'
  params: {
    name: sqlDatabaseName
    location: location
    sqlServerName: sqlServer.outputs.name
    skuName: sqlDatabaseSkuName
    skuTier: sqlDatabaseSkuTier
    tags: tags
  }
}

// ============================================
// OUTPUTS
// ============================================
output resourceGroupName string = rg.outputs.name
output sqlServerName string = sqlServer.outputs.name
output sqlServerFqdn string = sqlServer.outputs.fqdn
output sqlDatabaseName string = sqlDatabase.outputs.name
