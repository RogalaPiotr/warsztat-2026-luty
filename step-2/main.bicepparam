using 'main.bicep'

// ===========================================
// WARTOŚCI PARAMETRÓW
// ===========================================

param location = 'westeurope'

param vnetName = 'vnet-workshop-step2-dev-we-001'

param vnetAddressPrefix = '10.0.0.0/16'

param subnetName = 'snet-workshop-step2-dev-we-001'

param subnetAddressPrefix = '10.0.1.0/24'

param nicName = 'nic-workshop-step2-dev-we-001'

param storageAccountName = 'stworkshopstep2dev001'

param tags = {
  project: 'bicep-workshop'
  deployedBy: 'url|name|tool'
  envType: 'dev'
  owner: 'platform-team'
  costCenter: 'CC1000'
}
