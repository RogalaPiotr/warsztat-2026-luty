// ============================================
// MODUŁ: SQL Server (Security Hardened)
// ============================================
// Best practices:
// - TLS 1.2 minimum
// - Firewall rules z IP whitelist
// - Azure Services allowed
// ============================================

@description('Nazwa SQL Server (globalnie unikalna).')
@minLength(1)
@maxLength(63)
param name string

@description('Lokalizacja zasobu.')
param location string

@description('Login administratora SQL.')
param administratorLogin string

@description('Hasło administratora SQL.')
@secure()
param administratorLoginPassword string

@description('Włącz publiczny dostęp sieciowy.')
param publicNetworkAccessEnabled bool = true

@description('Lista dozwolonych adresów IP.')
param allowedIpAddresses array = []

@description('Tagi stosowane do zasobu.')
param tags object

// SQL Server
resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: publicNetworkAccessEnabled ? 'Enabled' : 'Disabled'
  }
}

// Firewall rule: Allow Azure Services
resource firewallAllowAzure 'Microsoft.Sql/servers/firewallRules@2023-08-01-preview' = {
  parent: sqlServer
  name: 'AllowAzureServices'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

// Firewall rules: Allowed IP addresses
resource firewallAllowedIps 'Microsoft.Sql/servers/firewallRules@2023-08-01-preview' = [
  for (ip, idx) in allowedIpAddresses: {
    parent: sqlServer
    name: 'AllowIP-${idx}'
    properties: {
      startIpAddress: ip
      endIpAddress: ip
    }
  }
]

output id string = sqlServer.id
output name string = sqlServer.name
output fqdn string = sqlServer.properties.fullyQualifiedDomainName
