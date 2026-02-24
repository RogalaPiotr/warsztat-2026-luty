// =============================================================================
// Step-4: Key Vault - DEV Environment Parameters
// =============================================================================
using 'main.bicep'

param location = 'polandcentral'
param resourceGroupName = 'rg-workshop-step4-dev-we-001'
param keyVaultName = 'kv-ws-step4-dev-001'
param tenantId = '00000000-0000-0000-0000-000000000000'

// Bezpieczeństwo
param enablePurgeProtection = false // DEV: wyłączone dla łatwiejszego cleanup
param softDeleteRetentionDays = 7

// Network Rules
param enableNetworkRules = false // DEV: wyłączone dla testów
param allowedIpAddresses = []

// Tagi
param tags = {
  Environment: 'dev'
  Project: 'Workshop'
  ManagedBy: 'Bicep'
  Step: '4'
}
