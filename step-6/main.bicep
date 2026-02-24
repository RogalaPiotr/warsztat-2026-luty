// ============================================
// STEP 6: SQL Server + Database (AVM Modules)
// ============================================
// Deployment: az deployment sub create
// Multi-env: dev, test, prod
// Key Vault integration: hasło SQL z step-4
// AVM: br/public:avm/res/sql/server:0.21.1
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
// VARIABLES
// ============================================
var allowedIpFirewallRules = [
  for (ip, idx) in allowedIpAddresses: {
    name: 'AllowIP-${idx}'
    startIpAddress: ip
    endIpAddress: ip
  }
]

var allFirewallRules = concat(
  [
    {
      name: 'AllowAzureServices'
      startIpAddress: '0.0.0.0'
      endIpAddress: '0.0.0.0'
    }
  ],
  allowedIpFirewallRules
)

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

// SQL Server + Database (AVM)
module sqlServer 'br/public:avm/res/sql/server:0.21.1' = {
  scope: resourceGroup(resourceGroupName)
  name: 'sql-server-step5-${environment}-${timestamp}'
  params: {
    name: sqlServerName
    location: location
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: keyVault.getSecret(sqlAdminPasswordSecretName)
    publicNetworkAccess: 'Enabled'
    minimalTlsVersion: '1.2'
    firewallRules: allFirewallRules
    databases: [
      {
        name: sqlDatabaseName
        availabilityZone: -1
        sku: {
          name: sqlDatabaseSkuName
          tier: sqlDatabaseSkuTier
        }
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        maxSizeBytes: 2147483648
        preferredEnclaveType: 'VBS'
        tags: tags
      }
    ]
    tags: tags
  }
  dependsOn: [rg]
}

// ============================================
// OUTPUTS
// ============================================
output resourceGroupName string = rg.outputs.name
output sqlServerName string = sqlServer.outputs.name
output sqlServerFqdn string = sqlServer.outputs.fullyQualifiedDomainName
output sqlDatabaseName string = sqlDatabaseName
