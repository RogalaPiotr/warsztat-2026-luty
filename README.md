# Bicep Fundamenty Enterprise

Darmowy warsztat online (Q1 2026) – JustCloud.pl

🎓 **100% praktyki, zero slajdów** | Live Coding + Q&A
---

## 📋 O warsztacie

### Filozofia warsztatu

Zamiast pokazywać 6 różnych rzeczy po kolei, pokazujemy **ewolucję jednego zestawu zasobów** przez 6 perspektyw Enterprise:

```
Step 1: Monolit (prosty kod, single-file)
   ↓
Step 2: Modularyzacja (organizacja, struktura)
   ↓
Step 3: Parametryzacja (dev/test/prod environments)
   ↓
Step 4: Secrets Management (Key Vault, RBAC, auto-generated passwords)
   ↓
Step 5: Integracja (SQL + Key Vault reference via 'existing' keyword)
   ↓
Step 6: AVM (Azure Verified Modules, lifecycle management)
```

### Co się nauczysz?

- ✅ **Bicep Essentials** - syntax, struktura, modulacja
- ✅ **Struktura Enterprise** - jak organizować kod Bicep dla skalowalności
- ✅ **Bezpieczeństwo** - secrets w Key Vault, network ACLs, RBAC
- ✅ **Parametryzacja** - bicepparam files, wieloświatowość (dev/test/prod)
- ✅ **Best Practices** - konwencje nazewnictwa CAF, modularyzacja, tagowanie
- ✅ **AVM Modules** - Azure Verified Modules, reuse od Microsoft
- ✅ **Azure CLI** - deployment via `az deployment`
- ✅ **100% praktyki** - zero slajdów, live coding w VS Code + Jupyter Notebooks

### Dla kogo?

- ✅ Masz podstawy Azure (Resource Groups, concepts) i chcesz nauczyć się IaC
- ✅ Znasz Bicep lub chcesz go opanować (od podstaw do advanced)
- ✅ Pracujesz w zespole i szukasz standardów do Bicep deploymentów
- ✅ Chcesz zareść Azure Verified Modules (AVM) w praktyce
- ✅ Chcesz znać best practices dla enterprise Azure
- ❌ Dopiero zaczynasz z Azure (zacznij od [Azure Learn](https://learn.microsoft.com/azure/))
- ❌ Szukasz Terraform (zamiast tego użyj [terraform-vm-pilot](../terraform-vm-pilot/))

---

## 📚 Struktura warsztatów

Warsztat składa się z 6 etapów pokazujących ewolucję infrastruktury:

### [Step 1](step-1/) - Monolit Bicep (~30 min)
**Cel:** Deployment podstawowych zasobów w jednym pliku, pokazanie antywzorca

**Co tworzymy:**
- Virtual Network + Subnet
- Network Interface
- Storage Account
- Wszystko w `main.bicep`, single-file monolit

**Fokus:** Dlaczego monolit jest problemem w pracy zespołowej, Bicep essentials

---

### [Step 2](step-2/) - Modularyzacja Bicep (~40 min)
**Cel:** Refaktoryzacja monolitu na strukturę modularną

**Co tworzymy:**
- Te same zasoby, ale w modułach Bicep
- Podział: modules/, main.bicep, main.bicepparam
- Parametryzacja zmiennych

**Fokus:** Organizacja kodu, reusability, parametryzacja, struktura Enterprise

---

### [Step 3](step-3/) - Subscription Scope z Multi-Environment (~35 min)
**Cel:** Deployment na poziomie subskrypcji zamiast resource group

**Co tworzymy:**
- Resource Group (tworzona przez Bicep!)
- Virtual Network + Subnet
- Storage Account (różne SKU per environment)
- Pliki `.bicepparam` dla dev/test/prod
- `targetScope = 'subscription'` + `scope:` dla kierowania modułów

**Fokus:** Subscription-level deployments, multi-environment configuration, az deployment sub vs az deployment group

---

### [Step 4](step-4/) - Key Vault z RBAC i Auto-Generated Secrets (~30 min)
**Cel:** Deployment Key Vault z bezpiecznym przechowywaniem sekretów

**Co tworzymy:**
- Key Vault z RBAC authorization (role-based access control)
- Network ACLs (default deny + white lista IP)
- Automatycznie generowane sekrety (30-znakowe hasła)
- Microsoft Defender for Key Vault
- Parametryzacja dla dev/test/prod

**Fokus:** Secrets management, RBAC, security best practices, Bicep functions, `uniqueString()`

---

### [Step 5](step-5/) - SQL Server + Database (Lokalne Moduły Bicep) (~25 min)
**Cel:** Deployment SQL Server + Database z integracją Key Vault

**Co tworzymy:**
- Azure SQL Server (TLS 1.2, firewall rules)
- Azure SQL Database (konfigurowalne SKU per environment)
- Hasło SQL admina z Key Vault via `existing` keyword + `getSecret()`
- Firewall rules (Azure Services + IP whitelist configuration)
- Lokalne moduły Bicep (`modules/resource-group/`, `modules/sql-server/`, `modules/sql-database/`)
- Subscription-level deployment (targetScope = 'subscription')

**Fokus:** Cross-step integration, Key Vault reference, Bicep `existing` keyword, modular SQL resources

---

### [Step 6](step-6/) - SQL Server + Database (Azure Verified Modules — AVM) (~25 min)
**Cel:** Identyczna infrastruktura jak step-5, ale używając **Azure Verified Modules** zamiast lokalnych modułów

**Co nowego w step-6:**
- Zamiast lokalnych modułów `modules/sql-server/` i `modules/sql-database/` używamy AVM:
  ```bicep
  module sqlServer 'br/public:avm/res/sql/server:0.21.1'
  ```
- AVM opakowuje SQL Server + Database — database konfigurowany inline przez `databases[]`
- Wszystkie best practices Microsoft wbudowane w moduł
- Wciąż integracja z Key Vault dla hasła admina

**Fokus:** Azure Verified Modules, Microsoft lifecycle management, published modules vs custom, reusability, module versioning

---

## 🧹 Cleanup (Czyszczenie zasobów)

Po warsztacie lub testach, aby uniknąć dodatkowych kosztów:

```bash
# Usuń wszystkie Resource Groups stworzone podczas warsztatu
az group delete --name rg-workshop-step1-dev-we-001 --yes --no-wait
az group delete --name rg-workshop-step2-dev-we-001 --yes --no-wait
az group delete --name rg-keyvault-dev-we-001 --yes --no-wait
az group delete --name rg-sqldb-dev-we-001 --yes --no-wait
```

------

## 🏗️ Konwencje nazewnictwa (Cloud Adoption Framework)

Projekt wykorzystuje konwencje zgodne z [Microsoft CAF](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming):

### Format
```
{resource-type}-{workload}-{step}-{environment}-{region}-{instance}
```

### Przykłady

**Step 1 - Monolit:**
- Resource Group: `rg-workshop-step1-dev-we-001`
- VNet: `vnet-workshop-step1-dev-we-001`
- Storage: `stworkshopstep1dev001`

**Step 4 - Key Vault:**
- Resource Group: `rg-keyvault-dev-we-001`
- Key Vault: `kv-workshop-dev-we-001`

**Step 5/6 - SQL:**
- Resource Group: `rg-sqldb-dev-we-001`
- SQL Server: `sql-workshop-dev-we-001`
- SQL Database: `sqldb-workshop-dev-we-001`

### Standardowe tagi

Wszystkie zasoby używają tagów:
```hcl
resource "azurerm_resource_group" "rg" {
  tags = {
    project    = "bicep-workshop"
    deployedBy = "bicep|azure-cli"
    envType    = "dev"
    owner      = "platform-team"
    costCenter = "CC1000"
  }
}
```

---

## 📋 Wymagania

### Wiedza
- ✅ Podstawy Azure (Resource Groups, concepts, concepts)
- ✅ Komfort z terminal/CLI
- ⚠️ Bicep to będzie klarownie wyjaśniane (nie wymaga wcześniejszej wiedzy)

### Narzędzia
- ✅ Azure CLI (latest)
- ✅ VS Code (opcjonalnie: rozszerzenia Bicep, Azure)
- ✅ Konto Azure (może być free tier) - [Instrukcja](pre-requsieties/README.md)
- ✅ Python 3.9+ (dla Jupyter Notebooks)
- ✅ Git (dla klonowania repo)

---

## 🎯 Plan warsztatu

**Czas trwania:** 2–3 godziny (live online)

**Etap 1: Monolit & Antywzorce** (15 min)
- Deployment prostych zasobów w jednym main.bicep
- Pokazanie problemów monolitu
- Bicep essentials

**Etap 2: Refaktoryzacja & Modularyzacja** (20 min)
- Reorganizacja: modules/, main.bicep, parametryzacja
- Bicep modules, composability, reusability
- Workflow dla teamów

**Etap 3: Subscription Scope & Multi-Environment** (20 min)
- `targetScope = 'subscription'` vs resource group scope
- Bicepparam for dev/test/prod
- `az deployment sub create` vs `az deployment group create`

**Etap 4: Secrets Management** (15 min)
- Key Vault deployment z RBAC
- Auto-generated secrets
- Network ACLs, Microsoft Defender

**Etap 5: Cross-Step Integration** (15 min)
- SQL Server + Database deployment
- Key Vault `existing` + `getSecret()`
- Modular SQL resources

**Etap 6: Azure Verified Modules (AVM)** (15 min)
- Why use AVM vs custom modules
- Published module versioning
- Lifecycle management by Microsoft

**Q&A & Best Practices** (20 min)
- Pytania i dyskusja
- Code review tips
- Production readiness checklist

---

## 👨‍🏫 Prowadzący

**Piotr Rogala**  
Principal Cloud Architect @ Nordcloud | Microsoft MVP | MCT

Pomagam klientom w transformacji cyfrowej i optymalizacji architektur Azure. Pasjonuję się automation, security i dzieleniem się wiedzą poprzez warsztaty, konferencje i społeczność tech.

🔗 [Twitter](https://x.com/RogalaPiotr) | [LinkedIn](https://www.linkedin.com/in/rogalapiotr/) | [Blog](https://blog.justcloud.pl/)

---


- [Pre-requsieties](pre-requsieties/README.md) - Wymagania i konto Azure
- [.devcontainer/README.md](.devcontainer/README.md) - Instrukcja Codespaces
- [Microsoft Learn: Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [Azure Verified Modules (AVM)](https://github.com/Azure/bicep-registry-modules)
- Każdy step zawiera własny README.md z instrukcjami

---

## 📢 JustCloud.pl

Warsztaty i szkolenia cloud dla profesjonalistów. Cykl darmowych spotkań online dla inżynierów, którzy chcą wejść na wyższy poziom.

🔗 [Warsztaty](https://web.justcloud.pl/warsztaty-darmowe.html) | [Blog](https://blog.justcloud.pl/) | [☕ Buy Coffee](https://buycoffee.to/justcloud)

---

## 🆘 Wsparcie

- 📧 Issues w tym repo
- 💬 Discord JustCloud (dostęp po warsztacie)
- 📝 [Blog JustCloud](https://blog.justcloud.pl/)
- 📚 [Bicep Language Reference](https://learn.microsoft.com/azure/azure-resource-manager/bicep/file)
- 🎫 [AVM Issues](https://github.com/Azure/bicep-registry-modules/issues)

---

## 📄 Licencja

Materiały warsztatowe są dostępne na licencji MIT.

---

**Miłego warsztatu! 🚀**
