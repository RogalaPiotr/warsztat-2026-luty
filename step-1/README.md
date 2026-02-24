# Step 1 — Monolit Bicep

## Cel
Wdrożenie podstawowej infrastruktury w jednym pliku `main.bicep`. Pokazanie antywzorca (monolit) przed refaktoryzacją w step-2.

## Co tworzymy
- Virtual Network + Subnet
- Network Interface
- Storage Account

## Deployment

### 1. Logowanie do Azure
```bash
az login
```

### 2. Utworzenie Resource Group
```bash
az group create --name rg-workshop-step1-dev-we-001 --location westeurope
```

### 3. Walidacja szablonu (what-if)
```bash
cd step-1
az deployment group what-if \
  --resource-group rg-workshop-step1-dev-we-001 \
  --template-file main.bicep
```

### 4. Wdrożenie
```bash
az deployment group create \
  --resource-group rg-workshop-step1-dev-we-001 \
  --template-file main.bicep \
  --name workshop-step1-deployment
```

### 5. Weryfikacja
```bash
az resource list --resource-group rg-workshop-step1-dev-we-001 --output table
```

## Struktura
```
step-1/
  main.bicep           # Wszystkie zasoby w jednym pliku (monolit)
```

## Zasoby
- Resource Group: `rg-workshop-step1-dev-we-001` (tworzona ręcznie)
- VNet: `vnet-workshop-step1-dev-we-001` (10.0.0.0/16)
- Subnet: `snet-workshop-step1-dev-we-001` (10.0.1.0/24)
- NIC: `nic-workshop-step1-dev-we-001`
- Storage: `stworkshopstep1dev001` (unikalna nazwa wymagana)

## Usuwanie zasobów
```bash
az group delete --name rg-workshop-step1-dev-we-001 --yes --no-wait
```