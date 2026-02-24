using 'main.bicep'

// ============================================
// DEV Environment
// ============================================

param environment = 'dev'
param location = 'polandcentral'

// Resource names
param resourceGroupName = 'rg-workshop-step5-dev-we-001'
param sqlServerName = 'sql-workshop-step5-dev-001'
param sqlDatabaseName = 'sqldb-workshop-step5-dev'

// Key Vault (step-4) - tylko dla sekretu
param keyVaultResourceGroup = 'rg-workshop-step4-dev-we-001'
param keyVaultName = 'kv-ws-step4-dev-001'
param sqlAdminPasswordSecretName = 'database-password'

// SQL Configuration
param sqlAdminLogin = 'sqladmin'
param sqlDatabaseSkuName = 'Basic'
param sqlDatabaseSkuTier = 'Basic'

// Allowed IPs (dev - more permissive)
param allowedIpAddresses = [
  '0.0.0.0' // Placeholder - zmień na swoje IP
]

param tags = {
  Environment: 'dev'
  Project: 'workshop'
  Step: 'step-5'
  ManagedBy: 'Bicep'
}
