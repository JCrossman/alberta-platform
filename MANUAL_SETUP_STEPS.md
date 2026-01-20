# Manual Setup Steps - Fabric & Copilot Studio

## Overview

The Azure CLI has limitations with Microsoft Fabric and Copilot Studio. These services require setup through their respective portals.

---

## 1. Microsoft Fabric Capacity Setup

### Option A: Create Fabric Capacity (Paid - You chose this)

**Location**: Azure Portal  
**Estimated Cost**: ~$770/month for F2, $8,671/month for F64

#### Steps:

1. **Navigate to Azure Portal**
   - Go to: https://portal.azure.com
   - Search for "Microsoft Fabric"

2. **Create Fabric Capacity**
   ```
   Resource Group: rg-alberta-platform-data-dev
   Capacity Name: fabric-alberta-dev
   Region: Canada Central
   SKU: F2 (smallest, 2 CUs) OR F64 (recommended for demos, 64 CUs)
   Admin: Your email address
   Tags:
     - project: alberta-platform
     - environment: dev
     - workload: data
   ```

3. **Configure Auto-Pause** (to save costs)
   - After creation, go to capacity settings
   - Enable auto-pause for off-hours
   - Schedule: Pause at 8:00 PM, Resume at 6:00 AM weekdays

4. **Create Fabric Workspaces**
   
   Navigate to: https://app.fabric.microsoft.com
   
   Create these workspaces:
   - `alberta-healthcare` (for healthcare data)
   - `alberta-justice` (for courts/justice data)
   - `alberta-energy` (for energy data)
   - `alberta-agriculture` (for agriculture data)
   - `alberta-pensions` (for pension data)
   - `alberta-coordination` (for MCP migration data)

5. **Configure OneLake Structure**
   
   In each workspace, create a Lakehouse with this structure:
   ```
   Lakehouse: <workspace-name>-lakehouse
   ├── Files/
   │   ├── bronze/    (raw data)
   │   ├── silver/    (cleansed data)
   │   └── gold/      (analytics-ready)
   └── Tables/
       └── (managed Delta tables)
   ```

---

## 2. Microsoft Purview Setup (Completed via CLI ✅)

**Status**: Purview account created in East US 2  
**Name**: `pv-alberta-platform`  
**Catalog URL**: https://800feb3a-1f2f-4e58-b181-b6f9f5472f8c-api.purview-service.microsoft.com/catalog

### Post-Creation Steps:

1. **Navigate to Purview Governance Portal**
   - Go to: https://web.purview.azure.com/
   - Sign in and select `pv-alberta-platform`

2. **Register Fabric Data Sources**
   - Data Map → Sources → Register
   - Select "Microsoft Fabric"
   - Connect each Fabric workspace created above

3. **Configure Automated Scanning**
   - For each registered source
   - Create scan rule set
   - Schedule: Daily at 2:00 AM

4. **Create Business Glossary**
   - Data Catalog → Glossary
   - Import terms from: `docs/purview-glossary-government.yaml` (from migration plan)
   - Key terms: Ministry, Coordination Gap, Pathway, Protected B, FOIP

5. **Set Up Data Classifications**
   - Data Map → Classifications
   - Create custom classifications:
     - "Public" (Alberta Open Data)
     - "Protected A" (simulated)
     - "Protected B" (simulated)

---

## 3. Copilot Studio Setup

### Option A: Use Existing M365 Tenant

**Prerequisites**: Microsoft 365 subscription with Power Platform access

#### Steps:

1. **Navigate to Copilot Studio**
   - Go to: https://copilotstudio.microsoft.com/
   - Sign in with your M365 credentials

2. **Create Environment**
   ```
   Environment Name: alberta-platform-dev
   Region: Canada
   Type: Production (or Sandbox for testing)
   ```

3. **Create New Copilot**
   ```
   Name: Alberta Services Assistant
   Description: AI assistant for Alberta government services and data
   Language: English (Canada)
   Schema: Classic
   ```

4. **Configure Copilot Settings**
   - Enable Generative AI features
   - Set boosting level: High
   - Enable conversation starters:
     - "What's the ER wait time?"
     - "How do I apply for guardianship?"
     - "Find programs for my situation"
     - "Show me air quality data"

5. **Connect to Azure AI Services**
   
   Under Settings → Generative AI:
   ```
   Azure OpenAI Connection:
     - Endpoint: https://oai-alberta-platform-eastus-dev.openai.azure.com/
     - Deployment: gpt-4o
     - API Key: (from Key Vault: kv-alberta-platform-dev)
   ```

6. **Add Topics** (conversation flows)
   
   Create these topics:
   - Healthcare Wait Times
   - Guardianship Application
   - Student Aid Assistance
   - Cross-Ministry Coordination
   - Data Catalog Search

7. **Connect to Function App API**
   
   Under Settings → Cloud Flows:
   ```
   Create new Power Automate flow:
     - Trigger: From Copilot
     - Action: HTTP request to Function App
     - URL: https://func-alberta-api-dev.azurewebsites.net/api/v2/
   ```

---

## 4. Connect Purview to Fabric

Once both Fabric and Purview are set up:

1. **Navigate to Purview Portal**
   - https://web.purview.azure.com/

2. **Register Fabric Workspaces**
   - Data Map → Register sources
   - Source type: Microsoft Fabric
   - For each workspace:
     ```
     Workspace: alberta-healthcare
     Connection: Use managed identity
     Collection: Root
     ```

3. **Create Scan**
   - Scan name: `scan-fabric-<workspace-name>`
   - Scan rule set: Fabric default
   - Schedule: Daily
   - Scope: Full workspace

4. **Verify Data Lineage**
   - After first scan completes
   - Navigate to Data Catalog
   - Search for any Fabric table
   - View lineage diagram

---

## 5. Verification Checklist

After completing manual setup:

- [ ] Fabric capacity is running
- [ ] 6 Fabric workspaces created
- [ ] OneLake structure configured
- [ ] Purview scanning Fabric workspaces
- [ ] Business glossary populated
- [ ] Copilot Studio environment created
- [ ] Copilot connected to Azure OpenAI
- [ ] Copilot connected to Function App
- [ ] Basic topics configured

---

## 6. Cost Management

### Daily Monitoring

```bash
# Check today's costs
az consumption usage list \
  --start-date $(date -v-1d +%Y-%m-%d) \
  --end-date $(date +%Y-%m-%d) \
  --query "[?contains(instanceName, 'alberta')].{name:instanceName, cost:pretaxCost, currency:currency}" \
  -o table
```

### Current Estimated Costs

| Service | Monthly Cost |
|---------|-------------|
| Fabric F2 (if chosen) | $770 |
| Fabric F64 (if chosen) | $8,671 |
| Purview | $250-400 |
| Azure OpenAI (GPT-4o) | $200-400 |
| AI Search | $75 (basic tier) |
| Function App | $50 (consumption) |
| Storage | $20 |
| Monitoring | $50 |
| **Total (with F2)** | **~$1,415-1,765/month** |
| **Total (with F64)** | **~$9,316-9,666/month** |

### Recommendations

1. **Start with F2** for development ($770/month)
2. **Enable auto-pause** to cut costs by 60%
3. **Upgrade to F64** only for customer demos ($8,671/month)
4. **Delete dev resources** when not actively developing

---

## Next Steps After Manual Setup

Once Fabric, Purview, and Copilot are configured:

1. **Clone alberta-mcp repository**
   ```bash
   cd ~/projects
   git clone https://github.com/JCrossman/alberta-mcp.git
   ```

2. **Begin data migration** (Phase 1, Week 3)
   - Migrate MCP program data from CosmosDB → Fabric
   - See: `docs/MIGRATION_PLAN.md`

3. **Start data ingestion** (Phase 1, Week 4)
   - Healthcare data from Alberta Open Data
   - Justice/Courts data
   - Energy data

4. **Configure Purview governance** (Phase 2, Week 6-8)
   - Set up data quality rules
   - Configure access policies
   - Create compliance reports

---

## Helpful Links

- **Fabric Portal**: https://app.fabric.microsoft.com
- **Purview Portal**: https://web.purview.azure.com/
- **Copilot Studio**: https://copilotstudio.microsoft.com/
- **Azure Portal**: https://portal.azure.com
- **Fabric Documentation**: https://learn.microsoft.com/fabric/
- **Purview Documentation**: https://learn.microsoft.com/purview/
- **Copilot Studio Documentation**: https://learn.microsoft.com/copilot-studio/

---

**Document Version**: 1.0  
**Last Updated**: January 19, 2026  
**Owner**: Jeremy Crossman (jcrossman@microsoft.com)
