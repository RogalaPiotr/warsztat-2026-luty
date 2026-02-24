using 'main.bicep'

// ===========================================
// ŚRODOWISKO: PROD
// ===========================================

param environment = 'prod'

param location = 'westeurope'

param resourceGroupName = 'rg-workshop-step3-prod-we-001'

param vnetName = 'vnet-workshop-step3-prod-we-001'

param vnetAddressPrefix = '10.2.0.0/16'

param subnetName = 'snet-workshop-step3-prod-we-001'

param subnetAddressPrefix = '10.2.1.0/24'

param storageAccountName = 'stworkshopstep3prod001'

param storageSkuName = 'Standard_ZRS'

param tags = {
  project: 'bicep-workshop'
  deployedBy: 'url|name|tool'
  envType: 'prod'
  owner: 'platform-team'
  costCenter: 'CC1000'
  criticality: 'high'
}
