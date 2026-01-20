# Technical Requirements - Alberta Open Data Intelligence Platform

## Overview

This document outlines the technical requirements for building the Alberta Open Data Intelligence Platform, including Azure services, infrastructure, development tools, and prerequisites.

---

## Azure Services Required

### Microsoft Fabric
**Purpose**: Unified data platform for ingestion, storage, transformation, and analytics

**Components Needed**:
- Fabric Workspace (Capacity-based)
- OneLake Storage
- Data Factory (Pipelines)
- Synapse Data Engineering (Notebooks)
- Synapse Data Warehouse (optional for SQL analytics)
- Power BI Workspace
- Data Activator (for real-time alerts)

**Capacity Requirements**:
- **Development**: F2 Trial (Free for 60 days)
- **Demo/Production**: F64 minimum ($8,671/month)
- **Recommended**: F64 with auto-pause during off-hours

**Regions**: Canada Central or Canada East

---

### Microsoft Purview
**Purpose**: Data governance, cataloging, lineage, and compliance

**Components Needed**:
- Purview Account
- Data Map (automated scanning)
- Data Catalog
- Data Estate Insights
- Data Policy
- Lineage tracking

**Pricing Tier**:
- Standard tier
- Pay-as-you-go pricing
- Estimated cost: $200-400/month based on:
  - Number of assets scanned
  - Number of vCore hours
  - Data map operations

**Regions**: Canada Central or Canada East (must match Fabric)

---

### Azure AI Foundry (formerly Azure AI Studio)
**Purpose**: AI model development, deployment, and orchestration

**Components Needed**:
- AI Foundry Project
- Azure OpenAI Service
  - GPT-4 Turbo (for chatbot and RAG)
  - GPT-4 (for high-quality responses)
  - text-embedding-ada-002 (for embeddings)
- Azure Machine Learning
  - Compute instances (for development)
  - Compute clusters (for training)
  - Inference endpoints (for deployment)
- Azure Cognitive Search (for RAG vector store)
- Prompt Flow (for agent orchestration)

**Compute Requirements**:
- **Development**: 
  - Compute instance: Standard_DS3_v2
- **Training**: 
  - Compute cluster: Standard_NC6s_v3 (GPU) or Standard_D4s_v3 (CPU)
  - Auto-scale: 0-4 nodes
- **Inference**:
  - Managed endpoint: Standard_DS3_v2 with auto-scaling

**Estimated Cost**: $300-600/month
- Azure OpenAI: ~$200/month (10,000 queries)
- Compute: ~$100-200/month
- Cognitive Search: ~$100/month (Basic tier)

**Regions**: Canada Central (Azure OpenAI available)

---

### Copilot Studio
**Purpose**: Low-code conversational AI development

**Requirements**:
- Copilot Studio environment
- Power Platform environment
- Message credits (10,000 included, then pay-as-you-go)
- Premium connectors for AI Foundry integration

**Estimated Cost**: $200/month
- Copilot Studio: Standalone license ~$200/month
- Or: Included with Power Virtual Agents license

**Regions**: Canada (Power Platform)

---

### Supporting Azure Services

#### Azure Active Directory (Entra ID)
- **Purpose**: Identity and access management
- **Components**:
  - Azure AD Premium P1 (for conditional access)
  - App registrations (for service principals)
  - Managed identities
- **Cost**: Included with Azure subscription

#### Azure Key Vault
- **Purpose**: Secrets, keys, and certificate management
- **Components**:
  - Vault for secrets
  - Access policies for services
- **Cost**: ~$10/month (pay-per-operation)

#### Azure Monitor
- **Purpose**: Logging, metrics, and alerting
- **Components**:
  - Log Analytics workspace
  - Application Insights (for AI apps)
  - Alerts and action groups
- **Cost**: ~$50/month (first 5GB free)

#### Azure Storage
- **Purpose**: Backup, archive, and temporary storage
- **Components**:
  - General-purpose v2 storage account
  - Hot tier for active data
  - Cool tier for backups
- **Cost**: ~$20/month

#### Azure Virtual Network
- **Purpose**: Network isolation and security
- **Components**:
  - Virtual Network
  - Subnets
  - Private endpoints (optional for higher security)
  - Network Security Groups
- **Cost**: ~$10/month (Private endpoints: +$10/endpoint)

---

## Total Azure Cost Estimate

### Development Environment (Months 1-3)
| Service | Cost/Month |
|---------|-----------|
| Fabric (F2 Trial) | $0 |
| Purview | $200 |
| Azure AI Foundry | $300 |
| Copilot Studio | $200 |
| Supporting Services | $100 |
| **Total** | **$800/month** |

### Demo/Production Environment (Months 4+)
| Service | Cost/Month |
|---------|-----------|
| Fabric (F64) | $1,200 (with auto-pause) |
| Purview | $300 |
| Azure AI Foundry | $400 |
| Copilot Studio | $200 |
| Supporting Services | $100 |
| **Total** | **$2,200/month** |

**Cost Optimization**:
- Use Fabric trial for as long as possible
- Auto-pause Fabric capacity during off-hours (8pm-6am, weekends)
- Delete development resources when not in use
- Use Azure reservations for predictable workloads (not recommended for demo)

---

## Data Sources

### Alberta Open Data Portal
**URL**: https://open.alberta.ca/

**Key Datasets**:

1. **Healthcare**
   - Emergency Department Wait Times
   - Hospital capacity and bed availability
   - Surgical wait times
   - Healthcare facility locations

2. **Environmental**
   - Air quality monitoring (real-time and historical)
   - Water quality testing results
   - Climate and weather data
   - Environmental incident reports

3. **Education**
   - School performance indicators
   - Enrollment statistics
   - School locations and demographics

4. **Financial**
   - Budget allocations by ministry
   - Public sector salaries
   - Grants and funding programs

5. **Demographics**
   - Population statistics
   - Census data
   - Economic indicators

**Access**:
- Most datasets available via REST API (JSON/CSV)
- Some require API key (free registration)
- Update frequencies vary (real-time to annual)

**Data License**: 
- Alberta Open Government License
- Allows use, modification, and redistribution
- Attribution required

---

## Development Tools & Software

### Required

**IDE / Code Editors**:
- Visual Studio Code (free)
  - Extensions: Python, Jupyter, Azure, Bicep, PowerShell
- Azure Data Studio (free, for SQL)
- Power BI Desktop (free)

**Version Control**:
- Git (free)
- GitHub or Azure DevOps (free tier)

**Languages & Runtimes**:
- Python 3.10+ (for Fabric notebooks, AI development)
- PowerShell 7+ (for Azure automation)
- Node.js 18+ (optional, for custom integrations)

**Package Managers**:
- pip (Python packages)
- npm (Node packages, if using)

**Azure Tools**:
- Azure CLI (free)
- Azure PowerShell module (free)
- Azure Bicep CLI (free, for infrastructure as code)

**Python Libraries**:
```
# Data Engineering
pandas==2.1.4
numpy==1.24.3
pyspark==3.5.0
pyarrow==14.0.1

# Azure SDKs
azure-identity==1.15.0
azure-storage-blob==12.19.0
azure-ai-ml==1.13.0
azure-cognitiveservices-speech==1.34.0

# ML/AI
scikit-learn==1.3.2
xgboost==2.0.3
lightgbm==4.1.0
openai==1.6.1
langchain==0.1.0

# Data Quality
great-expectations==0.18.8

# Utilities
requests==2.31.0
python-dotenv==1.0.0
```

### Optional (Nice to Have)

- Postman (API testing)
- DBeaver (database client)
- Draw.io or Visio (architecture diagrams)
- OBS Studio (screen recording for demo videos)

---

## Infrastructure as Code

### Bicep Templates (Recommended)
**Why Bicep**:
- Native Azure language
- Cleaner syntax than ARM templates
- Better for Azure-only deployments

**What to Template**:
- Resource groups
- Fabric workspace
- Purview account
- AI Foundry project
- Key Vault
- Storage accounts
- Networking

### Terraform (Alternative)
**Why Terraform**:
- Multi-cloud support
- Larger ecosystem
- More mature tooling

**Providers Needed**:
- azurerm (Azure)
- azuread (Azure AD)

**Decision**: Use Bicep for simplicity unless multi-cloud requirement

---

## Prerequisites & Access

### Azure Subscription
- **Required**: Azure subscription with Owner or Contributor role
- **Budget**: $800-2,200/month depending on phase
- **Region**: Canada Central or Canada East
- **Naming**: Use consistent naming convention
  - Format: `{service}-{project}-{env}-{region}`
  - Example: `fabric-alberta-demo-cc`

### Microsoft 365 (for Copilot Studio)
- Microsoft 365 tenant
- Power Platform environment
- Teams (for chatbot deployment)

### Permissions
- **Azure**: Contributor or Owner on subscription
- **Purview**: Data Curator, Data Reader roles
- **Fabric**: Admin or Member of workspace
- **AI Foundry**: Contributor on AI project
- **Copilot Studio**: System Administrator or Environment Maker

### API Keys
- Alberta Open Data API keys (if required by dataset)
- OpenAI API key (if using non-Azure OpenAI for development)

---

## Development Environment Setup

### Local Machine Requirements

**Hardware**:
- CPU: 4+ cores (8+ recommended)
- RAM: 16GB minimum (32GB recommended)
- Storage: 100GB free space (SSD preferred)
- Internet: Stable broadband connection

**Operating System**:
- Windows 10/11 (recommended for Power BI Desktop)
- macOS (supported with workarounds for Power BI)
- Linux (supported via VS Code remote)

### Network Requirements
- **Outbound HTTPS (443)**: To Azure services, GitHub
- **Outbound HTTP (80)**: For package managers
- **No VPN restrictions**: To Azure Canada regions
- **No firewall blocking**: Azure service endpoints

---

## Security Requirements

### Identity & Authentication
- **Azure AD/Entra ID**: All services must use Azure AD for authentication
- **Service Principals**: For automated pipelines and integrations
- **Managed Identities**: For Azure service-to-service authentication
- **No hardcoded credentials**: All secrets in Key Vault

### Network Security
- **Data in Transit**: TLS 1.2 minimum for all connections
- **Data at Rest**: AES-256 encryption for all storage
- **Network Isolation**: Use Virtual Network integration where available
- **Private Endpoints**: For production deployment (optional for demo)

### Access Control
- **Principle of Least Privilege**: Grant minimum necessary permissions
- **RBAC**: Use Azure RBAC for all resource access
- **MFA**: Enable MFA for all admin accounts
- **Conditional Access**: Restrict access by location/device if possible

### Compliance
- **Data Residency**: All data stored in Canadian Azure regions
- **Audit Logging**: Enable diagnostic logs for all services
- **Retention**: 90 days minimum, 7 years for compliance simulation
- **No PII**: Use only public datasets with no personal information

---

## Data Architecture Requirements

### Data Lake (OneLake)

**Structure**:
```
/OneLake
  /Bronze
    /healthcare
      /wait_times
        /year=2024
          /month=01
            /day=01
              /data.parquet
    /environmental
    /education
  /Silver
    /healthcare
    /environmental
    /education
  /Gold
    /healthcare_analytics
    /environmental_analytics
    /citizen_services
```

**File Formats**:
- **Bronze**: Parquet (compressed, columnar)
- **Silver**: Delta Lake (ACID transactions, time travel)
- **Gold**: Delta Lake (optimized for BI)

**Partitioning**:
- By date (year/month/day) for time-series data
- By region for geographic data

**Naming Conventions**:
- Lowercase with underscores: `wait_times_fact`
- Avoid spaces and special characters
- Include version suffix if schema changes: `wait_times_v2`

### Data Models

**Star Schema** (for Power BI):
- Fact tables: `fact_wait_times`, `fact_air_quality`
- Dimension tables: `dim_facility`, `dim_date`, `dim_location`
- Surrogate keys for relationships

**Data Quality**:
- Non-null constraints on key fields
- Valid value ranges
- Referential integrity
- Freshness checks

---

## AI/ML Requirements

### Model Development

**Frameworks**:
- Scikit-learn (classical ML)
- XGBoost/LightGBM (gradient boosting)
- TensorFlow/PyTorch (deep learning, if needed)
- LangChain (LLM orchestration)

**Model Registry**:
- Azure ML model registry
- Version control for models
- Model metadata (accuracy, training date, features)

**Experiment Tracking**:
- MLflow (integrated with Azure ML)
- Track metrics, parameters, artifacts

### Model Deployment

**Endpoint Types**:
- **Real-time**: Managed endpoints for low-latency predictions
- **Batch**: Batch endpoints for bulk processing

**Scaling**:
- Auto-scaling based on CPU/memory
- Min instances: 1, Max instances: 5

**Monitoring**:
- Input/output logging
- Prediction drift detection
- Model performance metrics

---

## Integration Requirements

### APIs

**Fabric REST API**:
- Authentication: Azure AD bearer token
- Rate limits: TBD (check current limits)
- Endpoints: Items, workspaces, pipelines

**Purview REST API**:
- Authentication: Azure AD bearer token
- Endpoints: Data catalog, lineage, classifications

**AI Foundry/Azure ML API**:
- Authentication: Azure AD bearer token or API key
- Endpoints: Model inference, prompt flow

**Power Platform API** (for Copilot):
- Authentication: Azure AD OAuth 2.0
- Endpoints: Bots, topics, analytics

### Message Formats

**JSON** (preferred):
```json
{
  "timestamp": "2024-01-19T12:00:00Z",
  "facility_id": "FID123",
  "wait_time_minutes": 45,
  "patient_count": 12
}
```

**Parquet** (for large datasets):
- Columnar format
- Compression: Snappy
- Schema evolution support

---

## Testing Requirements

### Unit Testing
- Test data transformations
- Test AI model functions
- Coverage target: 70%+
- Framework: pytest (Python)

### Integration Testing
- Test end-to-end pipelines
- Test API integrations
- Test data quality rules

### Performance Testing
- Load test AI endpoints (100 concurrent requests)
- Stress test data pipelines (1M rows)
- Query performance benchmarks

### Demo Testing
- Full demo run-through (no errors)
- Timed sections (within target duration)
- Backup procedures validated

---

## Documentation Requirements

### Code Documentation
- Docstrings for all functions
- README in each code directory
- Inline comments for complex logic

### Architecture Documentation
- High-level architecture diagram
- Data flow diagrams
- Security architecture
- Deployment architecture

### User Documentation
- Demo scripts with screenshots
- FAQ document
- Troubleshooting guide
- Setup instructions

### Governance Documentation
- Business glossary
- Data classification guide
- Access control policies
- Compliance procedures

---

## Non-Functional Requirements

### Performance
- Dashboard load time: <5 seconds
- AI query response: <2 seconds (P95)
- Pipeline execution: <30 minutes for daily refresh
- Chatbot response: <2 seconds

### Availability
- Target: 99.5% uptime during business hours
- Planned maintenance windows: Off-hours only
- Disaster recovery: 4-hour RTO, 1-hour RPO

### Scalability
- Support 100 concurrent Power BI users
- Support 1,000 chatbot conversations/day
- Ingest 10M rows/day in data pipelines
- Store 5 years of historical data

### Security
- Zero security incidents
- 100% audit log coverage
- MFA for all admin access
- Encrypted data at rest and in transit

### Usability
- Power BI reports: Mobile-optimized
- Chatbot: Natural language, <3 turns to answer
- Purview catalog: <30 seconds to find dataset

---

## Change Management

### Version Control
- Git for all code, notebooks, Bicep templates
- Semantic versioning (major.minor.patch)
- Branch strategy: main (prod), develop (dev), feature branches

### Deployment
- Manual deployment for demo (automated CI/CD optional)
- Deployment checklist before each release
- Rollback plan for failed deployments

### Configuration Management
- Separate configs for dev/test/prod
- Environment variables for secrets
- Feature flags for toggling functionality

---

## Maintenance & Operations

### Monitoring
- Daily: Check dashboard for pipeline failures
- Weekly: Review costs, performance metrics
- Monthly: Review data quality, governance metrics

### Backups
- OneLake: Geo-redundant storage (automatic)
- Purview metadata: Weekly export
- Power BI workspaces: Monthly backup via API

### Updates
- Azure services: Apply updates in dev first, then prod
- Python packages: Update quarterly, test in dev
- Documentation: Update as changes made

---

## Success Criteria Validation

Before declaring "done":
- [ ] All Azure services deployed and configured
- [ ] 3+ data sources ingested and transformed
- [ ] 2+ Power BI dashboards published
- [ ] Data fully cataloged in Purview
- [ ] 2+ AI models deployed with APIs
- [ ] Chatbot deployed with 5+ topics
- [ ] End-to-end demo script validated
- [ ] All documentation complete
- [ ] Security review passed
- [ ] Demo delivered to 1+ customer

---

## Appendix: Quick Start Checklist

### Week 1: Foundation
- [ ] Create Azure subscription
- [ ] Set up resource groups (dev, prod)
- [ ] Enable Microsoft Fabric (trial)
- [ ] Create Purview account
- [ ] Set up Git repository
- [ ] Install development tools (VS Code, Azure CLI, etc.)

### Week 2: Data Platform
- [ ] Configure OneLake structure
- [ ] Create first data pipeline (healthcare wait times)
- [ ] Build first Power BI report
- [ ] Register data source in Purview

### Week 3: Governance
- [ ] Define business glossary terms
- [ ] Set up data classifications
- [ ] Configure data lineage
- [ ] Create data quality rules

### Week 4: AI
- [ ] Create AI Foundry project
- [ ] Deploy Azure OpenAI models
- [ ] Build first AI model (wait time prediction)
- [ ] Deploy model as REST API

### Week 5: Chatbot
- [ ] Set up Copilot Studio
- [ ] Create first conversation topic
- [ ] Integrate with AI Foundry
- [ ] Test in Teams

### Week 6+: Integration & Demo Prep
- [ ] Connect all services end-to-end
- [ ] Write demo scripts
- [ ] Practice demos
- [ ] Create demo videos
- [ ] Schedule customer demos

---

## Support & Resources

### Microsoft Documentation
- [Microsoft Fabric Docs](https://learn.microsoft.com/fabric/)
- [Microsoft Purview Docs](https://learn.microsoft.com/purview/)
- [Azure AI Foundry Docs](https://learn.microsoft.com/azure/ai-foundry/)
- [Copilot Studio Docs](https://learn.microsoft.com/copilot-studio/)

### Learning Paths
- Microsoft Learn: Fabric Analytics Engineer
- Microsoft Learn: Azure AI Engineer
- YouTube: Microsoft Mechanics, Azure Friday

### Community
- Microsoft Tech Community forums
- Stack Overflow (azure tags)
- GitHub Discussions

### Support Channels
- Azure Support (if subscribed)
- Microsoft employee support (if applicable)
- Community forums

---

**Document Version**: 1.0  
**Last Updated**: January 2026  
**Owner**: Jeremy Crossman (jcrossman@microsoft.com)
