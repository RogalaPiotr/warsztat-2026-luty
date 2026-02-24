// =============================================================================
// Step-4: Key Vault - TEST Environment Parameters
// =============================================================================
using 'main.bicep'

param location = 'polandcentral'
param resourceGroupName = 'rg-workshop-step4-test-we-001'
param keyVaultName = 'kv-ws-step4-test-001'
param tenantId = '00000000-0000-0000-0000-000000000000'

// Bezpieczeństwo
param enablePurgeProtection = false // TEST: wyłączone dla łatwiejszego cleanup
param softDeleteRetentionDays = 14

// Network Rules
param enableNetworkRules = true
param allowedIpAddresses = [
  '0.0.0.0/0' // TEST: wszystkie IP (w produkcji ogranicz!)
]

// Tagi
param tags = {
  Environment: 'test'
  Project: 'Workshop'
  ManagedBy: 'Bicep'
  Step: '4'
}
