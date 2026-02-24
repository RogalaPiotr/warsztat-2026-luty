# Step 3 — Subscription-Scope Deployment z Multi-Environment

## Cel
Wdrożenie infrastruktury na poziomie subskrypcji z obsługą wielu środowisk (dev/test/prod).

## Czego się nauczysz
- `targetScope = 'subscription'` — deployment na poziomie subskrypcji
- Tworzenie Resource Group przez Bicep (nie manualnie przez `az group create`)
- `scope:` — kierowanie modułów do utworzonej Resource Group
- Pliki `.bicepparam` per środowisko — ten sam kod, różne konfiguracje
- `az deployment sub create` zamiast `az deployment group create`

## Co tworzymy
- Resource Group (tworzona przez Bicep!)
- Virtual Network z Subnet
- Storage Account (różne SKU per środowisko)

## Deployment

### 1. Logowanie do Azure
```bash
az login
az account set --subscription "<twoja-subskrypcja>"
```

### 2. Deployment per środowisko

> **Best Practice:** Zawsze używaj `--name` z unikalnym identyfikatorem. Ułatwia to śledzenie historii deploymentów, debugowanie i rollback.
>
> Naming convention: `{scope}-{step}-{env}-{timestamp}` np. `sub-step-3-dev-20260222143052`

**DEV:**
```bash
az deployment sub create \
  --location westeurope \
  --template-file main.bicep \
  --parameters main.dev.bicepparam \
  --name "sub-step-3-dev-$(date +%Y%m%d%H%M%S)"
```

**TEST:**
```bash
az deployment sub create \
  --location westeurope \
  --template-file main.bicep \
  --parameters main.test.bicepparam \
  --name "sub-step-3-test-$(date +%Y%m%d%H%M%S)"
```

**PROD:**
```bash
az deployment sub create \
  --location westeurope \
  --template-file main.bicep \
  --parameters main.prod.bicepparam \
  --name "sub-step-3-prod-$(date +%Y%m%d%H%M%S)"
```

### 3. Weryfikacja
```bash
# Lista Resource Groups
az group list --query "[?contains(name, 'workshop-step3')]" -o table

# Storage Account
az storage account show --name stworkshopstep3dev001 --resource-group rg-workshop-step3-dev-we-001
```

### 4. Czyszczenie (opcjonalne)
```bash
az group delete --name rg-workshop-step3-dev-we-001 --yes --no-wait
az group delete --name rg-workshop-step3-test-we-001 --yes --no-wait
az group delete --name rg-workshop-step3-prod-we-001 --yes --no-wait
```

## Struktura
```
step-3/
  main.bicep                 # Subscription-scope deployment
  main.dev.bicepparam        # Parametry DEV (Standard_LRS)
  main.test.bicepparam       # Parametry TEST (Standard_GRS)
  main.prod.bicepparam       # Parametry PROD (Standard_ZRS)
  modules/
    resource-group/
      main.bicep             # targetScope = 'subscription'
    virtual-network/
      main.bicep             # VNet + Subnet
    storage-account/
      main.bicep             # Storage z konfigurowalnym SKU
```

## Różnice między środowiskami

| Parametr | DEV | TEST | PROD |
|----------|-----|------|------|
| `vnetAddressPrefix` | 10.0.0.0/16 | 10.1.0.0/16 | 10.2.0.0/16 |
| `storageSkuName` | Standard_LRS | Standard_GRS | Standard_ZRS |
| `costCenter` | CC1000 | CC2000 | CC3000 |

## Kluczowe koncepcje

### targetScope = 'subscription'
```bicep
targetScope = 'subscription'  // Deployment na poziomie subskrypcji
```

### Scope dla modułów
```bicep
module vnet 'modules/virtual-network/main.bicep' = {
  name: 'vnet-deployment'
  scope: resourceGroup(resourceGroupName)  // Kieruj do RG
  params: { ... }
  dependsOn: [rg]  // Poczekaj na utworzenie RG
}
```

### Jeden kod, wiele środowisk
```bash
# Ten sam main.bicep, różne parametry
az deployment sub create --parameters main.dev.bicepparam
az deployment sub create --parameters main.prod.bicepparam
```
