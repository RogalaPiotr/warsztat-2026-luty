using 'main.bicep'

// ===========================================
// ŚRODOWISKO: DEV
// ===========================================

param environment = 'dev'

param location = 'westeurope'

param resourceGroupName = 'rg-workshop-step3-dev-we-001'

param vnetName = 'vnet-workshop-step3-dev-we-001'

param vnetAddressPrefix = '10.0.0.0/16'

param subnetName = 'snet-workshop-step3-dev-we-001'

param subnetAddressPrefix = '10.0.1.0/24'

param storageAccountName = 'stworkshopstep3dev001'

param storageSkuName = 'Standard_LRS'

param tags = {
  project: 'bicep-workshop'
  deployedBy: 'url|name|tool'
  envType: 'dev'
  owner: 'platform-team'
  costCenter: 'CC1000'
}
