using 'main.bicep'

// ============================================
// TEST Environment
// ============================================

param environment = 'test'
param location = 'polandcentral'

// Resource names
param resourceGroupName = 'rg-workshop-step6-test-we-001'
param sqlServerName = 'sql-workshop-step6-test-001'
param sqlDatabaseName = 'sqldb-workshop-step6-test'

// Key Vault (step-4) - tylko dla sekretu
param keyVaultResourceGroup = 'rg-workshop-step4-test-we-001'
param keyVaultName = 'kv-ws-step4-test-001'
param sqlAdminPasswordSecretName = 'database-password'

// SQL Configuration
param sqlAdminLogin = 'sqladmin'
param sqlDatabaseSkuName = 'Basic'
param sqlDatabaseSkuTier = 'Basic'

// Allowed IPs (test - restricted)
param allowedIpAddresses = []

param tags = {
  Environment: 'test'
  Project: 'workshop'
  Step: 'step-6'
  ManagedBy: 'Bicep'
}
