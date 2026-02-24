using 'main.bicep'

// ============================================
// PROD Environment
// ============================================

param environment = 'prod'
param location = 'polandcentral'

// Resource names
param resourceGroupName = 'rg-workshop-step5-prod-we-001'
param sqlServerName = 'sql-workshop-step5-prod-001'
param sqlDatabaseName = 'sqldb-workshop-step5-prod'

// Key Vault (step-4) - tylko dla sekretu
param keyVaultResourceGroup = 'rg-workshop-step4-prod-we-001'
param keyVaultName = 'kv-ws-step4-prod-001'
param sqlAdminPasswordSecretName = 'database-password'

// SQL Configuration
param sqlAdminLogin = 'sqladmin'
param sqlDatabaseSkuName = 'S0'
param sqlDatabaseSkuTier = 'Standard'

// Allowed IPs (prod - strict whitelist)
param allowedIpAddresses = []

param tags = {
  Environment: 'prod'
  Project: 'workshop'
  Step: 'step-5'
  ManagedBy: 'Bicep'
}
