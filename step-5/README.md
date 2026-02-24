# Step 5 — SQL Server + Database (Key Vault Integration)

## Cel
Deployment Azure SQL Server i SQL Database z hasłem administratora pobieranym z Key Vault (step-4) przy użyciu `existing` + `getSecret()`.

## Co tworzymy
- Resource Group (`rg-workshop-step5-{env}`)
- Azure SQL Server (TLS 1.2, firewall rules)
- Azure SQL Database (konfigurowalne SKU)
- Hasło SQL admina z Key Vault (step-4) via `getSecret()`
- Firewall rules (Azure Services + opcjonalne IP whitelist)

## Wymagania
⚠️ **Przed rozpoczęciem upewnij się że:**
1. Step-4 został wdrożony (Key Vault z sekretami)
2. W Key Vault istnieje sekret `sql-admin-password`
3. Masz uprawnienia RBAC do odczytu sekretów z Key Vault

## Struktura
```
step-5/
├── main.bicep              # Główna logika (subscription scope)
├── main.dev.bicepparam     # Parametry DEV
├── main.test.bicepparam    # Parametry TEST
├── main.prod.bicepparam    # Parametry PROD
├── runbook.ipynb           # Jupyter notebook z deploymentem
└── modules/
    ├── resource-group/     # Moduł Resource Group
    ├── sql-server/         # Moduł SQL Server
    └── sql-database/       # Moduł SQL Database
```

## Parametry

| Parametr | Opis |
|----------|------|
| `environment` | Środowisko (dev/test/prod) |
| `location` | Lokalizacja Azure |
| `projectName` | Nazwa projektu |
| `keyVaultResourceGroup` | RG z Key Vault (step-4) |
| `keyVaultName` | Nazwa Key Vault ze step-4 |
| `sqlAdminPasswordSecretName` | Nazwa sekretu z hasłem SQL |
| `sqlAdminLogin` | Login administratora SQL |
| `sqlDatabaseSkuName` | SKU Name (Basic, S0, S1) |
| `sqlDatabaseSkuTier` | SKU Tier (Basic, Standard) |
| `allowedIpAddresses` | Lista dozwolonych IP |

## Deployment

### 1. Walidacja Bicep
```bash
az bicep build --file main.bicep
```

### 2. What-If (preview zmian)
```bash
az deployment sub what-if \
  --location polandcentral \
  --template-file main.bicep \
  --parameters main.dev.bicepparam
```

### 3. Deploy
```bash
az deployment sub create \
  --name "sub-step5-dev-$(date +%Y%m%d%H%M%S)" \
  --location polandcentral \
  --template-file main.bicep \
  --parameters main.dev.bicepparam
```

## Key Vault Integration (Bicep)

### Existing + getSecret()
```bicep
// Reference istniejącego Key Vault z step-4
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
  scope: resourceGroup(keyVaultResourceGroup)
}

// Przekazanie sekretu do modułu SQL Server
module sqlServer 'modules/sql-server/main.bicep' = {
  params: {
    administratorLoginPassword: keyVault.getSecret(sqlAdminPasswordSecretName)
  }
}
```

## Zasoby

| Środowisko | Resource Group | SQL Server | SQL Database |
|------------|----------------|------------|--------------|
| dev | `rg-workshop-step5-dev` | `sql-workshop-{env}-{unique}` | `sqldb-workshop-dev` |
| test | `rg-workshop-step5-test` | `sql-workshop-{env}-{unique}` | `sqldb-workshop-test` |
| prod | `rg-workshop-step5-prod` | `sql-workshop-{env}-{unique}` | `sqldb-workshop-prod` |

## 💡 Troubleshooting

### Brak uprawnień do Key Vault
```bash
az role assignment create \
  --role "Key Vault Secrets User" \
  --assignee "twoj-email@example.com" \
  --scope "/subscriptions/SUB_ID/resourceGroups/rg-workshop-step4-dev/providers/Microsoft.KeyVault/vaults/kv-workshop-step4-dev-001"
```

### Nie można połączyć się z SQL
```bash
# Dodaj swoje IP do firewall
az sql server firewall-rule create \
  --server sql-workshop-step5-dev-xxx \
  --resource-group rg-workshop-step5-dev \
  --name AllowMyIP \
  --start-ip-address 203.0.113.42 \
  --end-ip-address 203.0.113.42
```

### Brak sekretu w Key Vault
```bash
# Utwórz sekret z hasłem SQL
az keyvault secret set \
  --vault-name kv-workshop-step4-dev-001 \
  --name sql-admin-password \
  --value "TwojeSuper$ecretneHaslo123!"
```
