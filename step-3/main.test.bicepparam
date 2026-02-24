using 'main.bicep'

// ===========================================
// ŚRODOWISKO: TEST
// ===========================================

param environment = 'test'

param location = 'westeurope'

param resourceGroupName = 'rg-workshop-step3-test-we-001'

param vnetName = 'vnet-workshop-step3-test-we-001'

param vnetAddressPrefix = '10.1.0.0/16'

param subnetName = 'snet-workshop-step3-test-we-001'

param subnetAddressPrefix = '10.1.1.0/24'

param storageAccountName = 'stworkshopstep3test001'

param storageSkuName = 'Standard_GRS'

param tags = {
  project: 'bicep-workshop'
  deployedBy: 'url|name|tool'
  envType: 'test'
  owner: 'platform-team'
  costCenter: 'CC1000'
}
