// =============================================================================
// Step-4: Key Vault - Subscription-Scope Deployment
// =============================================================================
// Key Vault z:
// - RBAC Authorization (zamiast Access Policies)
// - Network ACLs z IP whitelist
// - Soft delete i purge protection
// =============================================================================
targetScope = 'subscription'

// -----------------------------------------------------------------------------
// Parameters (wartości w .bicepparam)
// -----------------------------------------------------------------------------
@description('Azure region')
param location string

@description('Resource Group name')
param resourceGroupName string

@description('Key Vault name (globally unique)')
param keyVaultName string

@description('Enable purge protection')
param enablePurgeProtection bool

@description('Soft delete retention in days')
@minValue(7)
@maxValue(90)
param softDeleteRetentionDays int

@description('Enable network rules')
param enableNetworkRules bool

@description('Allowed IP addresses for Key Vault access')
param allowedIpAddresses array

@description('Azure tenant ID')
param tenantId string

@description('Resource tags')
param tags object

@description('Timestamp dla unikalności deploymentów.')
param timestamp string = utcNow('yyyyMMddHHmmss')

// -----------------------------------------------------------------------------
// Modules
// -----------------------------------------------------------------------------

// Resource Group
module rg 'modules/resource-group/main.bicep' = {
  name: 'rg-step4-${timestamp}'
  params: {
    name: resourceGroupName
    location: location
    tags: tags
  }
}

// Key Vault
module kv 'modules/key-vault/main.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'kv-step4-${timestamp}'
  params: {
    name: keyVaultName
    location: location
    tenantId: tenantId
    enablePurgeProtection: enablePurgeProtection
    softDeleteRetentionDays: softDeleteRetentionDays
    enableNetworkRules: enableNetworkRules
    allowedIpAddresses: allowedIpAddresses
    tags: tags
  }
  dependsOn: [
    rg
  ]
}

// -----------------------------------------------------------------------------
// Outputs
// -----------------------------------------------------------------------------
output resourceGroupName string = rg.outputs.name
output resourceGroupId string = rg.outputs.id
output keyVaultName string = kv.outputs.name
output keyVaultId string = kv.outputs.id
output keyVaultUri string = kv.outputs.vaultUri
