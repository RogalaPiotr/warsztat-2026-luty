// ============================================
// MODUŁ: Key Vault (Security Hardened)
// ============================================
// Best practices:
// - RBAC authorization (nie Access Policies)
// - Soft delete enabled
// - Purge protection (opcjonalne)
// - Network ACLs z IP whitelist
// - TLS 1.2 minimum
// ============================================

@description('Nazwa Key Vault (globalnie unikalna, 3-24 znaki).')
@minLength(3)
@maxLength(24)
param name string

@description('Lokalizacja zasobu.')
param location string

@description('Tenant ID dla Key Vault.')
param tenantId string

@description('SKU dla Key Vault.')
@allowed(['standard', 'premium'])
param skuName string = 'standard'

@description('Włącz purge protection (nie można wyłączyć po włączeniu).')
param enablePurgeProtection bool = false

@description('Dni retencji dla soft delete (7-90).')
@minValue(7)
@maxValue(90)
param softDeleteRetentionDays int = 7

@description('Włącz network ACLs (default deny + IP whitelist).')
param enableNetworkRules bool = true

@description('Lista dozwolonych adresów IP.')
param allowedIpAddresses array = []

@description('Tagi stosowane do zasobu.')
param tags object

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: skuName
    }

    // === SECURITY: RBAC authorization (best practice) ===
    enableRbacAuthorization: true

    // === DEPLOYMENT: Allow ARM to retrieve secrets ===
    enabledForTemplateDeployment: true

    // === SECURITY: Soft delete & Purge protection ===
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionDays
    enablePurgeProtection: enablePurgeProtection ? true : null // null = nie ustawiaj (domyślnie false)

    // === SECURITY: Network ACLs ===
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: enableNetworkRules ? 'Deny' : 'Allow'
      ipRules: [
        for ip in allowedIpAddresses: {
          value: ip
        }
      ]
    }
  }
}

output id string = keyVault.id
output name string = keyVault.name
output vaultUri string = keyVault.properties.vaultUri
