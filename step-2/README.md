# Step 2 — Modularyzacja kodu

## Cel

Refaktoryzacja monolitu ze step-1 na strukturę modularną. Kod podzielony na moduły Bicep.

## Co tworzymy

- Resource Group (via Azure CLI)
- Virtual Network + Subnet
- Network Interface
- Storage Account
- Struktura modułowa (każdy zasób = osobny moduł Bicep)

## Deployment

### 1. Logowanie do Azure

```bash
az login
```

### 2. Utworzenie Resource Group

```bash
az group create --name rg-workshop-step2-dev-we-001 --location westeurope
```

### 3. Walidacja szablonu (what-if)

```bash
az deployment group what-if \
  --resource-group rg-workshop-step2-dev-we-001 \
  --template-file main.bicep \
  --parameters main.bicepparam
```

### 4. Deployment

```bash
az deployment group create \
  --resource-group rg-workshop-step2-dev-we-001 \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --name "rg-step-2-$(date +%Y%m%d%H%M%S)"
```

> **Best Practice:** Zawsze używaj `--name` z unikalnym identyfikatorem (np. timestamp). Ułatwia to:
> - Śledzenie historii deploymentów w Azure Portal
> - Debugowanie problemów (który deployment wprowadził zmianę)
> - Rollback do konkretnej wersji
>
> Naming convention: `{scope}-{step}-{timestamp}` np. `rg-step-2-20260222143052`

### 5. Weryfikacja

```bash
az resource list --resource-group rg-workshop-step2-dev-we-001 --output table
az network vnet show --name vnet-workshop-step2-dev-we-001 --resource-group rg-workshop-step2-dev-we-001
```

## Struktura

```text
step-2/
  main.bicep                      # Wywołania modułów (bez default values)
  main.bicepparam                 # Wartości parametrów
  modules/
    virtual-network/
      main.bicep                  # Moduł VNet
    subnet/
      main.bicep                  # Moduł Subnet
    network-interface/
      main.bicep                  # Moduł NIC
    storage-account/
      main.bicep                  # Moduł Storage
```

## Zasoby

- Resource Group: `rg-workshop-step2-dev-we-001`
- VNet: `vnet-workshop-step2-dev-we-001` (10.0.0.0/16)
- Subnet: `snet-workshop-step2-dev-we-001` (10.0.1.0/24)
- NIC: `nic-workshop-step2-dev-we-001`
- Storage: `stworkshopstep2dev001`

## Cleanup

```bash
az group delete --name rg-workshop-step2-dev-we-001 --yes --no-wait
```
