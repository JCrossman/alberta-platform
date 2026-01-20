# Alberta Platform Migration Plan: MCP to Unified Azure Platform

## Executive Summary

This document outlines the comprehensive plan to migrate the existing **Alberta MCP** (Ministry Coordination Protocol) project to the new **Alberta Open Data Intelligence Platform**, consolidating all services under Microsoft's modern data and AI stack.

**Migration Approach**: Full Platform Migration  
**Duration**: 26 weeks (6.5 months)  
**Estimated Cost**: $2,500-3,500/month (production)

### Key Decisions

| Component | Current (MCP) | Target (Unified Platform) |
|-----------|---------------|---------------------------|
| Program Database | CosmosDB (serverless) | Microsoft Fabric (OneLake) |
| Vector Search | CosmosDB vector search | Azure AI Search |
| AI/LLM | Azure OpenAI (standalone) | Azure AI Foundry (managed) |
| API Layer | Azure Functions | Azure Functions (keep) |
| Form MCPs | TypeScript MCP servers | Copilot Studio + AI Foundry |
| Governance | None | Microsoft Purview |
| Analytics | None | Power BI + Fabric |
| M365 Agent | Declarative agent | Copilot Studio agent |

---

## Azure Best Practices Architecture

### Resource Group Strategy

**Pattern**: Environment + Workload separation

```
alberta-platform/
├── rg-alberta-platform-identity-prod     # Shared identity (Entra ID, Key Vault)
├── rg-alberta-platform-network-prod      # Shared networking
├── rg-alberta-platform-data-dev          # Fabric, Storage (dev)
├── rg-alberta-platform-data-prod         # Fabric, Storage (prod)
├── rg-alberta-platform-ai-dev            # AI Foundry, OpenAI (dev)
├── rg-alberta-platform-ai-prod           # AI Foundry, OpenAI (prod)
├── rg-alberta-platform-governance-prod   # Purview (shared)
├── rg-alberta-platform-api-dev           # Functions, APIM (dev)
├── rg-alberta-platform-api-prod          # Functions, APIM (prod)
├── rg-alberta-platform-web-dev           # Static Web Apps (dev)
└── rg-alberta-platform-web-prod          # Static Web Apps (prod)
```

**Rationale**:
- Separate RBAC per workload (data team vs AI team vs web team)
- Independent lifecycle management (delete dev without touching prod)
- Clear cost allocation per resource group
- Easier compliance auditing

### Naming Convention

**Pattern**: `{service}-{project}-{workload}-{env}-{region}-{instance}`

| Resource Type | Naming Pattern | Example |
|---------------|----------------|---------|
| Resource Group | `rg-{project}-{workload}-{env}` | `rg-alberta-platform-data-dev` |
| Storage Account | `st{project}{workload}{env}` | `stalbertadatadev` |
| Key Vault | `kv-{project}-{env}` | `kv-alberta-platform-dev` |
| Function App | `func-{project}-{workload}-{env}` | `func-alberta-api-dev` |
| AI Foundry | `ai-{project}-{env}` | `ai-alberta-platform-dev` |
| Purview | `pv-{project}` | `pv-alberta-platform` |
| Static Web App | `swa-{project}-{env}` | `swa-alberta-portal-dev` |
| Log Analytics | `log-{project}-{env}` | `log-alberta-platform-dev` |
| App Insights | `appi-{project}-{workload}-{env}` | `appi-alberta-api-dev` |

### Tagging Strategy

**Mandatory Tags** (apply to all resources):

```json
{
  "project": "alberta-platform",
  "environment": "dev|test|prod",
  "owner": "jcrossman@microsoft.com",
  "costCenter": "demo-learning",
  "createdBy": "bicep|manual|terraform",
  "createdDate": "2026-01-19"
}
```

**Workload-Specific Tags**:

```json
{
  "workload": "data|ai|api|web|governance",
  "dataClassification": "public|internal|confidential",
  "complianceScope": "none|foip|pipeda"
}
```

### Azure Regions

**Primary**: Canada Central (canadacentral)  
**Secondary**: Canada East (canadaeast) - DR only

**Rationale**:
- Data sovereignty (Canadian data residency)
- Azure OpenAI availability in Canada Central
- Microsoft Fabric availability
- Low latency for Alberta users

---

## Resource Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          AZURE TENANT                                       │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │  ENTRA ID (Azure AD)                                                   │ │
│  │  - User identities    - Service principals   - Managed identities     │ │
│  │  - App registrations  - Security groups      - Conditional access     │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
┌─────────────────────────────────────┼───────────────────────────────────────┐
│                     AZURE SUBSCRIPTION                                       │
│                                     │                                        │
│  ┌──────────────────────────────────▼──────────────────────────────────┐    │
│  │  rg-alberta-platform-identity-prod                                   │    │
│  │  ┌─────────────────┐  ┌─────────────────────┐                       │    │
│  │  │ Key Vault       │  │ Managed Identities  │                       │    │
│  │  │ (secrets, certs)│  │ (service auth)      │                       │    │
│  │  └─────────────────┘  └─────────────────────┘                       │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐    │
│  │  rg-alberta-platform-network-prod                                    │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │ Virtual Network (vnet-alberta-platform)                      │    │    │
│  │  │ ├── subnet-data (10.0.1.0/24) - Private endpoints           │    │    │
│  │  │ ├── subnet-ai (10.0.2.0/24) - AI services                   │    │    │
│  │  │ ├── subnet-api (10.0.3.0/24) - Functions                    │    │    │
│  │  │ └── subnet-web (10.0.4.0/24) - Web apps                     │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  │  ┌─────────────────────────┐  ┌────────────────────────────────┐   │    │
│  │  │ NSG (network security)  │  │ Private DNS Zones              │   │    │
│  │  └─────────────────────────┘  └────────────────────────────────┘   │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐    │
│  │  rg-alberta-platform-data-prod                                       │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │ Microsoft Fabric Capacity (F64)                              │    │    │
│  │  │ ├── Workspace: alberta-healthcare                            │    │    │
│  │  │ ├── Workspace: alberta-justice                               │    │    │
│  │  │ ├── Workspace: alberta-energy                                │    │    │
│  │  │ ├── Workspace: alberta-agriculture                           │    │    │
│  │  │ ├── Workspace: alberta-pensions                              │    │    │
│  │  │ └── Workspace: alberta-coordination (migrated from MCP)      │    │    │
│  │  │                                                              │    │    │
│  │  │ OneLake                                                      │    │    │
│  │  │ ├── /bronze (raw data)                                       │    │    │
│  │  │ ├── /silver (cleansed)                                       │    │    │
│  │  │ └── /gold (analytics-ready)                                  │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  │  ┌─────────────────────────┐                                        │    │
│  │  │ Storage Account         │  (backup, external data)               │    │
│  │  └─────────────────────────┘                                        │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐    │
│  │  rg-alberta-platform-ai-prod                                         │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │ Azure AI Foundry (ai-alberta-platform-prod)                  │    │    │
│  │  │ ├── Azure OpenAI (gpt-4o, text-embedding-3-small)           │    │    │
│  │  │ ├── Azure AI Search (vector store, RAG)                     │    │    │
│  │  │ ├── Prompt Flow (agent orchestration)                        │    │    │
│  │  │ └── Model Catalog (predictions, classification)              │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  │  ┌─────────────────────────┐  ┌────────────────────────────────┐   │    │
│  │  │ ML Compute (training)   │  │ Inference Endpoints            │   │    │
│  │  └─────────────────────────┘  └────────────────────────────────┘   │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐    │
│  │  rg-alberta-platform-governance-prod                                 │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │ Microsoft Purview (pv-alberta-platform)                      │    │    │
│  │  │ ├── Data Map (all Fabric workspaces registered)             │    │    │
│  │  │ ├── Data Catalog (searchable asset inventory)               │    │    │
│  │  │ ├── Data Lineage (end-to-end tracking)                      │    │    │
│  │  │ ├── Business Glossary (government terms)                    │    │    │
│  │  │ └── Data Quality (rules, profiling)                         │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐    │
│  │  rg-alberta-platform-api-prod                                        │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │ Azure Functions (func-alberta-api-prod)                      │    │    │
│  │  │ ├── /api/v1/programs (from MCP coordination API)            │    │    │
│  │  │ ├── /api/v1/forms (from MCP guardianship/student-aid)       │    │    │
│  │  │ ├── /api/v1/coordination (gaps, pathways, workarounds)      │    │    │
│  │  │ ├── /api/v2/predict (AI Foundry integration)                │    │    │
│  │  │ └── /api/v2/search (Fabric data queries)                    │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  │  ┌─────────────────────────┐  ┌────────────────────────────────┐   │    │
│  │  │ API Management          │  │ App Insights                   │   │    │
│  │  │ (rate limiting, docs)   │  │ (monitoring)                   │   │    │
│  │  └─────────────────────────┘  └────────────────────────────────┘   │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐    │
│  │  rg-alberta-platform-web-prod                                        │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │ Static Web App (swa-alberta-portal-prod)                     │    │    │
│  │  │ ├── React frontend                                          │    │    │
│  │  │ ├── Embedded Power BI                                       │    │    │
│  │  │ ├── Copilot Studio chatbot widget                           │    │    │
│  │  │ └── Azure AD authentication                                 │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  │  ┌─────────────────────────┐                                        │    │
│  │  │ Copilot Studio          │  (citizen services chatbot)            │    │
│  │  └─────────────────────────┘                                        │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐    │
│  │  SHARED MONITORING                                                   │    │
│  │  ┌───────────────────┐  ┌─────────────────┐  ┌──────────────────┐   │    │
│  │  │ Log Analytics     │  │ Azure Monitor   │  │ Cost Management  │   │    │
│  │  │ (centralized logs)│  │ (alerts)        │  │ (budgets)        │   │    │
│  │  └───────────────────┘  └─────────────────┘  └──────────────────┘   │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Migration Phases

### Phase 0: Foundation & Infrastructure (Weeks 1-2)

**Objective**: Set up Azure environment following best practices

#### Week 1: Azure Foundation

| Task | Owner | Deliverable |
|------|-------|-------------|
| Create resource groups per strategy | Platform | 10 resource groups |
| Deploy Key Vault with managed identity | Platform | Secrets management |
| Configure Virtual Network | Platform | VNet + subnets + NSGs |
| Set up Log Analytics workspace | Platform | Centralized logging |
| Configure cost alerts ($500, $1000, $2000) | Platform | Budget alerts |
| Apply mandatory tags to all resources | Platform | Compliance baseline |
| Set up Azure Policy assignments | Platform | Governance enforcement |

#### Week 2: Identity & Security

| Task | Owner | Deliverable |
|------|-------|-------------|
| Configure Entra ID app registrations | Security | Service identities |
| Create managed identities for services | Security | Zero-secret auth |
| Set up RBAC roles per resource group | Security | Access control |
| Enable diagnostic settings (all resources) | Security | Audit logging |
| Configure Azure Security Center | Security | Security posture |
| Document security baseline | Security | Compliance doc |

**Azure CLI Commands (Week 1)**:

```bash
# Set variables
export SUBSCRIPTION_ID="your-subscription-id"
export LOCATION="canadacentral"
export PROJECT="alberta-platform"

# Login and set subscription
az login
az account set --subscription $SUBSCRIPTION_ID

# Create resource groups
az group create --name "rg-${PROJECT}-identity-prod" --location $LOCATION --tags project=$PROJECT environment=prod workload=identity
az group create --name "rg-${PROJECT}-network-prod" --location $LOCATION --tags project=$PROJECT environment=prod workload=network
az group create --name "rg-${PROJECT}-data-dev" --location $LOCATION --tags project=$PROJECT environment=dev workload=data
az group create --name "rg-${PROJECT}-data-prod" --location $LOCATION --tags project=$PROJECT environment=prod workload=data
az group create --name "rg-${PROJECT}-ai-dev" --location $LOCATION --tags project=$PROJECT environment=dev workload=ai
az group create --name "rg-${PROJECT}-ai-prod" --location $LOCATION --tags project=$PROJECT environment=prod workload=ai
az group create --name "rg-${PROJECT}-governance-prod" --location $LOCATION --tags project=$PROJECT environment=prod workload=governance
az group create --name "rg-${PROJECT}-api-dev" --location $LOCATION --tags project=$PROJECT environment=dev workload=api
az group create --name "rg-${PROJECT}-api-prod" --location $LOCATION --tags project=$PROJECT environment=prod workload=api
az group create --name "rg-${PROJECT}-web-dev" --location $LOCATION --tags project=$PROJECT environment=dev workload=web
az group create --name "rg-${PROJECT}-web-prod" --location $LOCATION --tags project=$PROJECT environment=prod workload=web

# Create Key Vault
az keyvault create \
  --name "kv-${PROJECT}-prod" \
  --resource-group "rg-${PROJECT}-identity-prod" \
  --location $LOCATION \
  --enable-rbac-authorization true

# Create Log Analytics workspace
az monitor log-analytics workspace create \
  --workspace-name "log-${PROJECT}-prod" \
  --resource-group "rg-${PROJECT}-identity-prod" \
  --location $LOCATION

# Set up cost alert
az consumption budget create \
  --budget-name "budget-${PROJECT}-monthly" \
  --amount 2000 \
  --category Cost \
  --time-grain Monthly \
  --start-date "2026-01-01" \
  --end-date "2026-12-31"
```

---

### Phase 1: Data Platform with Fabric (Weeks 3-6)

**Objective**: Build unified data platform and migrate MCP program data

#### Week 3-4: Fabric Setup & Initial Data

| Task | Owner | Deliverable |
|------|-------|-------------|
| Provision Microsoft Fabric capacity (F64) | Data | Fabric workspace |
| Create workspaces per use case | Data | 6 workspaces |
| Configure OneLake (bronze/silver/gold) | Data | Data lake structure |
| Migrate MCP programs to Fabric | Data | Programs dataset |
| Migrate MCP gaps/pathways to Fabric | Data | Coordination data |
| Build Power BI semantic model | Data | Analytics layer |

#### Week 5-6: Data Pipelines & Analytics

| Task | Owner | Deliverable |
|------|-------|-------------|
| Create healthcare data pipeline | Data | ER wait times |
| Create justice data pipeline | Data | Court data |
| Create energy data pipeline | Data | Energy stats |
| Create agriculture data pipeline | Data | Crop/weather |
| Build coordination dashboard | Data | Power BI report |
| Build cross-ministry analytics | Data | Unified view |

**MCP Data Migration Script**:

```python
# migrate_mcp_to_fabric.py
"""
Migrates Alberta MCP CosmosDB data to Microsoft Fabric OneLake.
"""
import json
from azure.cosmos import CosmosClient
from azure.identity import DefaultAzureCredential
import pandas as pd

# Source: CosmosDB (existing MCP)
COSMOS_ENDPOINT = "https://alberta-coord-cosmosdb.documents.azure.com"
COSMOS_DATABASE = "coordination"

# Target: Fabric OneLake
ONELAKE_PATH = "abfss://alberta-coordination@onelake.dfs.fabric.microsoft.com"

def migrate_programs():
    """Migrate 91 programs from CosmosDB to Fabric."""
    credential = DefaultAzureCredential()
    client = CosmosClient(COSMOS_ENDPOINT, credential)
    
    database = client.get_database_client(COSMOS_DATABASE)
    container = database.get_container_client("programs")
    
    # Read all programs
    programs = list(container.read_all_items())
    df = pd.DataFrame(programs)
    
    # Write to Fabric OneLake as Delta table
    df.to_parquet(f"{ONELAKE_PATH}/bronze/programs/programs.parquet")
    
    print(f"Migrated {len(programs)} programs to Fabric")
    return df

def migrate_gaps():
    """Migrate coordination gaps."""
    # Similar pattern for gaps
    pass

def migrate_pathways():
    """Migrate referral pathways."""
    # Similar pattern for pathways
    pass

def migrate_workarounds():
    """Migrate workarounds with steps."""
    # Similar pattern for workarounds
    pass

if __name__ == "__main__":
    migrate_programs()
    migrate_gaps()
    migrate_pathways()
    migrate_workarounds()
```

---

### Phase 2: Data Governance with Purview (Weeks 7-9)

**Objective**: Implement comprehensive governance for all data assets

#### Week 7: Purview Setup

| Task | Owner | Deliverable |
|------|-------|-------------|
| Provision Microsoft Purview account | Governance | Purview instance |
| Register Fabric as data source | Governance | Data map |
| Configure automated scanning | Governance | Asset discovery |
| Enable lineage tracking | Governance | Data flows |

#### Week 8: Business Glossary & Classification

| Task | Owner | Deliverable |
|------|-------|-------------|
| Create government glossary terms | Governance | 100+ terms |
| Define data classifications | Governance | Classification scheme |
| Map technical → business terms | Governance | Term mapping |
| Set up sensitivity labels | Governance | PII protection |

#### Week 9: Quality & Policies

| Task | Owner | Deliverable |
|------|-------|-------------|
| Configure data quality rules | Governance | Quality checks |
| Create access policies | Governance | RBAC policies |
| Build governance dashboard | Governance | Metrics view |
| Document compliance procedures | Governance | Compliance guide |

**Purview Glossary Sample**:

```yaml
# purview-glossary-government.yaml
terms:
  - name: "Ministry"
    definition: "A major department of the Government of Alberta responsible for specific policy areas"
    examples: ["Ministry of Health", "Ministry of Justice", "Ministry of Education"]
    
  - name: "Coordination Gap"
    definition: "A documented failure or inefficiency in how government programs work together to serve citizens"
    source: "Alberta Ombudsman Reports"
    related_terms: ["Cross-Ministry Coordination", "Service Gap"]
    
  - name: "Pathway"
    definition: "A recommended sequence of steps for a citizen to navigate government services"
    examples: ["Guardianship Application Pathway", "Student Aid Pathway"]
    
  - name: "Protected B"
    definition: "Information security classification for data that could cause serious injury to an individual, organization or government if disclosed"
    reference: "Government of Canada Information Security Classification"
    
  - name: "FOIP"
    definition: "Freedom of Information and Protection of Privacy - Alberta's legislation governing access to government information and protection of personal privacy"
    reference: "Freedom of Information and Protection of Privacy Act (Alberta)"
```

---

### Phase 3: AI Platform with AI Foundry (Weeks 10-14)

**Objective**: Migrate AI capabilities and build new prediction models

#### Week 10-11: AI Foundry Setup & Migration

| Task | Owner | Deliverable |
|------|-------|-------------|
| Create AI Foundry project | AI | AI workspace |
| Deploy Azure OpenAI models | AI | GPT-4o, embeddings |
| Set up Azure AI Search | AI | Vector store |
| Migrate MCP pathway generation | AI | LLM prompts |
| Migrate vector embeddings | AI | Search index |

#### Week 12-13: Prediction Models

| Task | Owner | Deliverable |
|------|-------|-------------|
| Build ER wait time prediction | AI | ML model |
| Build court case duration model | AI | ML model |
| Build energy demand forecast | AI | ML model |
| Build coordination scoring | AI | ML model |
| Deploy models as endpoints | AI | REST APIs |

#### Week 14: RAG & Agent Orchestration

| Task | Owner | Deliverable |
|------|-------|-------------|
| Build RAG system for government data | AI | Q&A capability |
| Create prompt templates | AI | Agent prompts |
| Implement agent routing | AI | Orchestration |
| Build responsible AI dashboard | AI | Fairness metrics |

**AI Foundry Prompt Flow (Pathway Generation)**:

```yaml
# prompt_flow/pathway_generation.yaml
name: generate_pathway
description: Generate personalized referral pathway for citizen situation

inputs:
  situation:
    type: string
    description: Citizen's described situation
  age:
    type: integer
    description: Age of person needing services
  location:
    type: string
    description: Alberta region

flow:
  - name: search_programs
    type: azure_ai_search
    inputs:
      query: ${inputs.situation}
      index: programs-index
      top_k: 10
    
  - name: get_context
    type: fabric_query
    inputs:
      query: |
        SELECT * FROM gold.programs 
        WHERE ministry_id IN (${search_programs.ministry_ids})
        
  - name: generate_pathway
    type: llm
    model: gpt-4o
    inputs:
      prompt: |
        You are an expert in Alberta government services.
        
        Citizen situation: ${inputs.situation}
        Age: ${inputs.age}
        Location: ${inputs.location}
        
        Available programs:
        ${get_context.results}
        
        Generate a step-by-step pathway for this citizen to access the services they need.
        Include: program names, eligibility, contact info, expected timelines.
        Format as numbered steps.
        
outputs:
  pathway:
    type: string
    source: ${generate_pathway.output}
```

---

### Phase 4: Citizen Services with Copilot Studio (Weeks 15-17)

**Objective**: Replace MCP chatbots with Copilot Studio agents

#### Week 15: Copilot Studio Setup

| Task | Owner | Deliverable |
|------|-------|-------------|
| Create Copilot Studio environment | Bot | Copilot project |
| Configure Azure AD authentication | Bot | SSO |
| Connect to AI Foundry | Bot | AI integration |
| Connect to Fabric | Bot | Data access |

#### Week 16: Migrate MCP Functionality

| Task | Owner | Deliverable |
|------|-------|-------------|
| Recreate guardianship flows | Bot | Form assistance |
| Recreate student aid flows | Bot | Aid guidance |
| Recreate coordination flows | Bot | Program finder |
| Add healthcare queries | Bot | Wait time info |
| Add justice queries | Bot | Court info |

#### Week 17: Multi-Channel Deployment

| Task | Owner | Deliverable |
|------|-------|-------------|
| Deploy to Teams | Bot | Teams channel |
| Create web widget | Bot | Embed code |
| Test M365 Copilot integration | Bot | Copilot agent |
| Add French language support | Bot | Bilingual |

**Copilot Studio Topic (Migrated from MCP)**:

```yaml
# copilot_studio/topics/guardianship_pathway.yaml
name: Guardianship Application Help
trigger_phrases:
  - "I need guardianship"
  - "How do I get guardianship"
  - "Manage finances for parent"
  - "Adult guardianship Alberta"

conversation_flow:
  - message: "I can help you understand the guardianship process in Alberta. Let me ask a few questions to find the right path for you."
  
  - question: "Is this for guardianship (personal decisions) or trusteeship (financial decisions), or both?"
    variable: decision_type
    options:
      - "Guardianship (personal decisions)"
      - "Trusteeship (financial decisions)"
      - "Both guardianship and trusteeship"
  
  - question: "Is the person currently able to make some decisions on their own?"
    variable: partial_capacity
    options:
      - "Yes, some decisions"
      - "No, needs full support"
  
  - action: call_ai_foundry
    endpoint: /api/v2/compute_pathway
    body:
      decision_type: ${decision_type}
      partial_capacity: ${partial_capacity}
    
  - message: |
      Based on your situation, here's your recommended pathway:
      
      ${ai_response.pathway}
      
      **Required Forms:**
      ${ai_response.forms}
      
      **Estimated Timeline:** ${ai_response.timeline}
      
      Would you like me to explain any of these forms in detail?
```

---

### Phase 5: API Layer Migration (Weeks 18-19)

**Objective**: Consolidate APIs and add new Fabric/AI integrations

#### Week 18: API Consolidation

| Task | Owner | Deliverable |
|------|-------|-------------|
| Migrate MCP endpoints to new Functions | API | Consolidated API |
| Add Fabric query endpoints | API | Data API |
| Add AI Foundry prediction endpoints | API | ML API |
| Implement API versioning (v1 → v2) | API | Version strategy |
| Configure API Management | API | Rate limiting |

#### Week 19: Integration Testing

| Task | Owner | Deliverable |
|------|-------|-------------|
| Test Copilot → API → Fabric flow | QA | Integration tests |
| Test Portal → API → AI flow | QA | Integration tests |
| Load test API endpoints | QA | Performance baseline |
| Document all API endpoints | API | OpenAPI spec |

**New API Structure**:

```
/api
├── /v1 (legacy MCP compatibility)
│   ├── /programs          # Existing MCP endpoints
│   ├── /gaps
│   ├── /pathways
│   ├── /workarounds
│   └── /coordination-summary
│
├── /v2 (new unified platform)
│   ├── /programs          # Fabric-backed
│   ├── /coordination      # Fabric-backed
│   ├── /predict
│   │   ├── /waittime      # AI Foundry
│   │   ├── /case-duration # AI Foundry
│   │   └── /demand        # AI Foundry
│   ├── /search
│   │   ├── /programs      # AI Search
│   │   ├── /data          # Fabric
│   │   └── /catalog       # Purview
│   └── /forms
│       ├── /guardianship  # Migrated from MCP
│       └── /student-aid   # Migrated from MCP
│
└── /health
```

---

### Phase 6: Portal Development (Weeks 20-23)

**Objective**: Build unified React portal for demos

#### Week 20-21: Portal Foundation

| Task | Owner | Deliverable |
|------|-------|-------------|
| Create React app with TypeScript | Web | Project setup |
| Implement Azure AD authentication | Web | SSO login |
| Create component library | Web | UI components |
| Set up API client layer | Web | API integration |

#### Week 22-23: Portal Features

| Task | Owner | Deliverable |
|------|-------|-------------|
| Build citizen home page | Web | Landing page |
| Embed Power BI dashboards | Web | Analytics view |
| Embed Copilot Studio chatbot | Web | Chat widget |
| Build data catalog search | Web | Purview UI |
| Build admin dashboard | Web | Staff view |

**Portal Component Structure**:

```
alberta-portal/
├── src/
│   ├── components/
│   │   ├── common/
│   │   │   ├── Header.tsx
│   │   │   ├── Footer.tsx
│   │   │   └── Navigation.tsx
│   │   ├── citizen/
│   │   │   ├── ServiceFinder.tsx
│   │   │   ├── WaitTimeWidget.tsx
│   │   │   └── ChatbotWidget.tsx
│   │   ├── analytics/
│   │   │   ├── PowerBIEmbed.tsx
│   │   │   └── DashboardGrid.tsx
│   │   └── governance/
│   │       ├── CatalogSearch.tsx
│   │       └── LineageViewer.tsx
│   ├── pages/
│   │   ├── citizen/
│   │   │   ├── Home.tsx
│   │   │   ├── Services.tsx
│   │   │   └── MyApplications.tsx
│   │   ├── admin/
│   │   │   ├── Dashboard.tsx
│   │   │   └── Analytics.tsx
│   │   └── governance/
│   │       ├── DataCatalog.tsx
│   │       └── Quality.tsx
│   ├── services/
│   │   ├── api.ts            # API client
│   │   ├── auth.ts           # Azure AD
│   │   └── powerbi.ts        # PBI embed
│   └── App.tsx
├── package.json
└── vite.config.ts
```

---

### Phase 7: Demo Preparation & Handoff (Weeks 24-26)

**Objective**: Finalize demos, documentation, and prepare for customer presentations

#### Week 24: End-to-End Testing

| Task | Owner | Deliverable |
|------|-------|-------------|
| Full integration testing | QA | Test report |
| Demo scenario validation | All | 5 demo scripts |
| Performance optimization | Dev | <2s responses |
| Security review | Security | Security report |

#### Week 25: Documentation & Training

| Task | Owner | Deliverable |
|------|-------|-------------|
| Technical documentation | All | Architecture docs |
| Demo scripts with talking points | PM | Demo guide |
| Video recordings (backup) | PM | Demo videos |
| Handoff documentation | PM | Runbook |

#### Week 26: Launch Preparation

| Task | Owner | Deliverable |
|------|-------|-------------|
| Final demo rehearsals | All | Polished demos |
| Customer-facing materials | PM | Slide deck |
| Feedback collection plan | PM | Survey forms |
| Schedule first customer demos | PM | Calendar |

---

## Cost Estimate (Monthly)

### Development Phase (Months 1-3)

| Resource | Cost | Notes |
|----------|------|-------|
| Fabric F2 Trial | $0 | 60-day trial |
| Purview | $250 | Standard tier |
| AI Foundry (OpenAI + Search) | $400 | GPT-4o + embeddings |
| Functions | $50 | Consumption plan |
| Static Web App | $0 | Free tier |
| Storage | $20 | Backup |
| Monitoring | $50 | Log Analytics |
| **Total** | **$770/month** | |

### Production Phase (Months 4+)

| Resource | Cost | Notes |
|----------|------|-------|
| Fabric F64 | $1,400 | Auto-pause enabled |
| Purview | $350 | Increased scanning |
| AI Foundry | $600 | Higher usage |
| Functions | $100 | Premium plan |
| Static Web App | $9 | Standard tier |
| API Management | $150 | Developer tier |
| Storage | $30 | Backup |
| Monitoring | $100 | Full logging |
| **Total** | **$2,739/month** | |

### Cost Optimization

1. **Fabric auto-pause**: Pause capacity 8pm-6am, weekends = 60% savings
2. **Dev/Prod separation**: Delete dev resources when not in use
3. **Reserved capacity**: Consider 1-year reservation after 3 months
4. **Right-sizing**: Monitor and adjust AI compute based on usage

---

## Risk Mitigation

### Technical Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| MCP migration breaks compatibility | Medium | High | Maintain v1 API for 6 months |
| Fabric performance issues | Low | Medium | Start with F64, scale up if needed |
| AI model drift | Medium | Medium | Implement monitoring, retrain quarterly |
| Data quality issues | Medium | Medium | Purview quality rules, validation |

### Timeline Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Learning curve delays | High | Medium | Budget 20% buffer per phase |
| Integration complexity | Medium | High | Test integrations early |
| Scope creep | High | Medium | Strict phase gates |

### Operational Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Demo environment failure | Low | High | Backup videos, DR environment |
| Cost overrun | Medium | Medium | Daily cost monitoring, alerts |
| Security incident | Low | Critical | Follow Azure best practices, audits |

---

## Success Criteria

### Phase Gates

**Phase 0 Complete**:
- [ ] All resource groups created with proper tags
- [ ] Key Vault operational with managed identities
- [ ] Logging enabled for all resources
- [ ] Cost alerts configured

**Phase 1-2 Complete**:
- [ ] MCP data migrated to Fabric
- [ ] 5+ use case data pipelines operational
- [ ] Purview scanning all Fabric workspaces
- [ ] Data lineage visible end-to-end

**Phase 3-4 Complete**:
- [ ] AI models deployed with <2s latency
- [ ] Copilot Studio chatbot answering queries
- [ ] MCP functionality recreated
- [ ] French language support enabled

**Phase 5-6 Complete**:
- [ ] APIs consolidated and versioned
- [ ] Portal deployed with Azure AD SSO
- [ ] Power BI embedded and functional
- [ ] All integrations tested

**Phase 7 Complete**:
- [ ] 5 demo scenarios validated
- [ ] Demo videos recorded
- [ ] Documentation complete
- [ ] First customer demo scheduled

---

## Quick Start Checklist

### Day 1 Actions

```bash
# 1. Clone both repositories
cd ~/projects
git clone https://github.com/JCrossman/alberta-mcp.git
# Create new unified platform repo

# 2. Login to Azure
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# 3. Create first resource group
az group create \
  --name "rg-alberta-platform-identity-prod" \
  --location "canadacentral" \
  --tags project=alberta-platform environment=prod owner=jcrossman@microsoft.com

# 4. Create Key Vault
az keyvault create \
  --name "kv-alberta-platform-prod" \
  --resource-group "rg-alberta-platform-identity-prod" \
  --location "canadacentral" \
  --enable-rbac-authorization true

# 5. Set cost alert
az consumption budget create \
  --budget-name "alberta-platform-monthly" \
  --amount 1000 \
  --category Cost \
  --time-grain Monthly \
  --start-date "2026-01-01" \
  --end-date "2026-12-31"
```

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-19 | Jeremy Crossman | Initial migration plan |

---

## Next Steps

1. **Review this plan** - Any adjustments before we start?
2. **Execute Phase 0 Week 1** - Create resource groups and infrastructure
3. **Clone alberta-mcp** - Get code ready for migration
4. **Enable Fabric trial** - Start data platform setup

Ready to begin when you are! 🚀
