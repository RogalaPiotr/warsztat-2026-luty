// =============================================================================
// Step-4: Key Vault - PROD Environment Parameters
// =============================================================================
using 'main.bicep'

param location = 'polandcentral'
param resourceGroupName = 'rg-workshop-step4-prod-we-001'
param keyVaultName = 'kv-ws-step4-prod-001'
param tenantId = '00000000-0000-0000-0000-000000000000'

// Bezpieczeństwo - PRODUKCJA
param enablePurgeProtection = true // PROD: włączone!
param softDeleteRetentionDays = 90 // PROD: maksymalny retention

// Network Rules - PRODUKCJA
param enableNetworkRules = true
param allowedIpAddresses = [
  // Dodaj tutaj swoje dozwolone adresy IP
  // '203.0.113.0/24'
  // '198.51.100.50'
]

// Tagi
param tags = {
  Environment: 'prod'
  Project: 'Workshop'
  ManagedBy: 'Bicep'
  Step: '4'
  CostCenter: 'PROD-001'
}
