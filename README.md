# Alberta Open Data Intelligence Platform

## 🎉 Project Status: Phase 0 Complete ✅

**All Azure infrastructure deployed and verified** (January 28, 2026)

This unified platform consolidates the [Alberta MCP](https://github.com/JCrossman/alberta-mcp) project, providing:
- **Data Intelligence** (Fabric, Purview, AI Foundry) 
- **Citizen Services** (forms, pathways, coordination)
- **Infrastructure as Code** (Bicep templates for reproducible deployments)

### Deployed & Verified Resources (Subscription #1)
- ✅ Azure OpenAI (GPT-4o, text-embedding-3-small) - East US - **Running**
- ✅ Azure AI Search - Canada Central - **Running**
- ✅ Azure Functions (Flex Consumption) - Canada Central - **Running**
- ✅ Static Web App - East US 2 - **Deployed**
- ✅ Key Vault with RBAC - Canada Central - **Running**
- ✅ Storage Accounts with containers - Canada Central - **Running**
- ✅ Log Analytics & Application Insights - **Running**
- ✅ Microsoft Fabric F2 capacity (Canada Central) - **Active**
- ✅ 6 Fabric Workspaces created and assigned - **Ready**

### Current Phase: Phase 1 - Data Foundation (Week 3-5)
- [x] Deploy all Azure infrastructure ✅
- [x] Deploy Microsoft Fabric capacity ✅
- [x] Create Fabric workspaces ✅
- [ ] Create Lakehouses in workspaces
- [ ] Identify Alberta Open Data sources
- [ ] Build first data pipelines
- [ ] Create first Power BI dashboard

See [PROJECT_STATUS.md](PROJECT_STATUS.md) for detailed status and [docs/implementation-plan.md](docs/implementation-plan.md) for complete roadmap.

---

## Project Overview

A comprehensive learning and demonstration platform showcasing Microsoft Azure's data governance, analytics, and AI capabilities using Alberta's public sector data. This project demonstrates how provincial governments can leverage Azure Fabric, AI Foundry, Purview, and Copilot to deliver secure, compliant, and citizen-centric data services.

## Business Context

**Target Audience**: Government of Alberta provincial public sector customers

**Alignment with Alberta's 2026 Priorities**:
- Enterprise Data Analytics Strategic Plan implementation
- AI Data Centre Strategy and infrastructure expansion
- Data sovereignty and cybersecurity compliance
- Digital service delivery modernization
- Cross-sector collaboration and innovation

## Azure Services Demonstrated

### Microsoft Fabric
- Unified data lakehouse architecture with OneLake
- Real-time analytics and business intelligence
- Multi-source data integration
- Fabric IQ for intelligent data operations

### Microsoft Purview
- Data cataloging and discovery
- Data classification (Protected A/B simulation)
- Data lineage and impact analysis
- Compliance and governance controls
- AI agent observability and security

### Azure AI Foundry
- Custom AI model development and deployment
- Multi-agent orchestration
- Predictive analytics for public services
- Responsible AI framework implementation

### Copilot Studio
- Low-code conversational AI agents
- Citizen-facing service chatbot
- Automated report generation
- Integration with M365 ecosystem

## Use Cases

### 1. Healthcare Intelligence
- Wait time analysis and prediction
- Resource optimization recommendations
- Patient flow analytics
- Emergency department demand forecasting

### 2. Environmental Monitoring
- Air quality tracking and alerts
- Water resource management
- Climate data analysis
- Environmental compliance reporting

### 3. Citizen Service Portal
- 24/7 AI-powered service finder
- Policy and regulation Q&A
- Automated permit application guidance
- Multi-language support

### 4. Data Governance Excellence
- Sensitive data protection demonstration
- Audit trail and compliance reporting
- Cross-agency data sharing controls
- Privacy-preserving analytics

## Project Structure

```
alberta-platform/
├── README.md                       # This file
├── GETTING_STARTED.md              # Onboarding guide
├── DEPLOYMENT.md                   # Infrastructure deployment guide
├── MANUAL_SETUP_STEPS.md           # Portal-based setup
├── CHANGELOG.md                    # Version history
├── PROJECT_SUMMARY.md              # Executive summary
├── .gitignore                      # Git ignore rules
│
├── docs/                           # Documentation
│   ├── implementation-plan.md      # Detailed implementation roadmap ✅
│   ├── MIGRATION_PLAN.md           # Alberta MCP migration strategy ✅
│   ├── user-stories.md             # User stories and personas ✅
│   ├── architecture.md             # System architecture ✅
│   ├── data-governance.md          # Governance framework ✅
│   ├── success-metrics.md          # KPIs and success criteria ✅
│   ├── risk-assessment.md          # Risks and mitigation ✅
│   └── technical-requirements.md   # Technical specifications ✅
│
├── infrastructure/                 # Infrastructure as Code
│   ├── bicep/                      # Azure Bicep templates ✅
│   │   ├── main.bicep              # Main orchestrator
│   │   ├── modules/                # Modular templates
│   │   │   ├── identity.bicep      # Key Vault, identities
│   │   │   ├── monitoring.bicep    # Logging, insights
│   │   │   ├── storage.bicep       # Storage accounts
│   │   │   ├── ai.bicep            # OpenAI, AI Search
│   │   │   ├── api.bicep           # Azure Functions
│   │   │   ├── web.bicep           # Static Web App
│   │   │   └── keyvault-secrets.bicep # Helper module
│   │   ├── fabric/                 # Fabric deployment ✅
│   │   │   ├── fabric-capacity.json          # ARM template
│   │   │   ├── fabric-capacity.parameters.json
│   │   │   ├── deploy-fabric.sh    # Deployment script
│   │   │   ├── pause-fabric.sh     # Pause (stop billing)
│   │   │   ├── resume-fabric.sh    # Resume (start billing)
│   │   │   ├── status-fabric.sh    # Check status
│   │   │   ├── fabric-aliases.sh   # Shell shortcuts
│   │   │   └── README.md           # Management guide
│   │   ├── parameters/             # Environment configs
│   │   │   └── dev.parameters.json
│   │   └── scripts/                # Deployment automation
│   │       ├── deploy.sh
│   │       └── destroy.sh
│   └── BICEP_TEMPLATES.md          # IaC documentation ✅
│
├── data/                           # Data sources and schemas
│   ├── sources/                    # Alberta Open Data sources
│   ├── schemas/                    # Data models
│   └── sample-data/                # Sample datasets
│
├── fabric/                         # Microsoft Fabric artifacts
│   ├── notebooks/                  # Data engineering notebooks
│   ├── pipelines/                  # Data pipelines
│   ├── dataflows/                  # Dataflow definitions
│   └── reports/                    # Power BI reports
│
├── purview/                        # Purview configurations
│   ├── glossary/                   # Business glossary
│   ├── classifications/            # Custom classifications
│   ├── policies/                   # Data policies
│   └── scans/                      # Scan configurations
│
├── ai-foundry/                     # AI Foundry projects
│   ├── models/                     # AI models
│   ├── agents/                     # AI agents
│   ├── prompts/                    # Prompt engineering
│   └── evaluations/                # Model evaluations
│
├── copilot-studio/                 # Copilot Studio artifacts
│   ├── topics/                     # Conversation topics
│   ├── actions/                    # Custom actions
│   └── analytics/                  # Usage analytics
│
├── demos/                          # Demo scripts and guides
│   ├── healthcare/                 # Healthcare use case
│   ├── courts-justice/             # Courts & Justice use case
│   ├── energy-agriculture/         # Energy & Agriculture use case
│   ├── alberta-pensions/           # Pensions use case
│   └── governance/                 # Data governance demo
│
└── scripts/                        # Utility scripts
    ├── setup/                      # Setup automation
    ├── data-ingestion/             # Data ingestion scripts
    └── deployment/                 # Deployment helpers
```

✅ = Completed | 🚧 = In Progress | 📋 = Planned

## Getting Started

### Quick Start
```bash
# Clone the repository
git clone https://github.com/JCrossman/alberta-platform.git
cd alberta-platform

# If resuming work (Fabric is paused)
cd infrastructure/bicep/fabric
./resume-fabric.sh  # Takes ~30 seconds, starts billing

# Check status
./status-fabric.sh

# When done for the day
./pause-fabric.sh   # Stops billing immediately
```

For first-time deployment, see [DEPLOYMENT.md](DEPLOYMENT.md). For manual setup steps (Purview/Copilot), see [MANUAL_SETUP_STEPS.md](MANUAL_SETUP_STEPS.md).

## Key Features

- **Canadian Data Residency**: All data stored in Canadian Azure regions
- **Compliance Ready**: Demonstrates Protected B data handling practices
- **Scalable Architecture**: Production-ready patterns for enterprise deployment
- **Responsible AI**: Built-in governance, observability, and bias detection
- **Citizen-Centric Design**: Accessible, multilingual, and inclusive

## Learning Objectives

1. Master Microsoft Fabric for unified data platform management
2. Implement comprehensive data governance with Purview
3. Build and deploy production AI agents with AI Foundry
4. Create low-code conversational experiences with Copilot Studio
5. Demonstrate compliance and security best practices
6. Showcase ROI and business value to government stakeholders

## Demo Scenarios

Each use case includes:
- Business problem statement
- Technical solution walkthrough
- Live demonstration script
- ROI and impact metrics
- Customer talking points

## Success Criteria

- Functional end-to-end data pipeline from ingestion to insights
- Working AI agents demonstrating real-world government use cases
- Complete data governance and compliance framework
- Customer-ready demonstration materials
- Documented lessons learned and best practices

## Contributing

This is a personal learning and demonstration project. For questions or collaboration, contact jcrossman@microsoft.com.

## License

For demonstration and learning purposes only. Alberta Open Data sources used under their respective licenses.
