# Changelog

All notable changes to the Alberta Open Data Intelligence Platform will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-01-20 (Evening)

### Added - Fabric Cost Management
- Created `pause-fabric.sh` - Pauses Fabric capacity to stop billing
- Created `resume-fabric.sh` - Resumes Fabric capacity (starts billing)
- Created `status-fabric.sh` - Shows current capacity state and billing status
- Created `fabric-aliases.sh` - Optional shell shortcuts (work-start, work-end)
- Created `infrastructure/bicep/fabric/README.md` - Complete Fabric management guide

### Deployed - Microsoft Fabric
- Microsoft Fabric F2 capacity "fabricalbertadev" deployed to Canada Central
- Successfully tested pause functionality (capacity currently paused)
- Verified status checking and state transitions
- Cost management solution: Manual pause/resume can save 70% ($988→$290/month)

### Changed
- Updated `PROJECT_STATUS.md` - Added Fabric deployment status and pause/resume workflow
- Updated `MANUAL_SETUP_STEPS.md` - Added deployed status and daily cost management instructions
- Updated cost estimates to reflect actual Fabric F2 pricing ($988/month 24/7)

### Testing
- ✅ Pause script: Successfully paused capacity
- ✅ Status script: Shows "Paused" state with billing stopped
- ✅ State transitions: Active → Pausing → Paused (~30 seconds)
- ⏳ Resume script: Ready to test (not tested yet to avoid charges overnight)

### Documentation
- Comprehensive cost management guide in Fabric README
- Daily workflow examples (work-start, work-end)
- Cost tracking recommendations
- Portal verification instructions

## [1.0.0] - 2026-01-20

### Added - Infrastructure as Code
- Complete Bicep IaC implementation for Azure infrastructure
- Main orchestrator (`main.bicep`) for subscription-level deployment
- Six modular Bicep templates:
  - `identity.bicep` - Key Vault, managed identities
  - `monitoring.bicep` - Log Analytics, Application Insights
  - `storage.bicep` - Data and function storage accounts
  - `ai.bicep` - Azure OpenAI, AI Search, model deployments
  - `api.bicep` - Azure Functions (Flex Consumption)
  - `web.bicep` - Static Web App
- Helper module `keyvault-secrets.bicep` for cross-resource-group secret management
- Deployment automation scripts:
  - `deploy.sh` - One-command deployment
  - `destroy.sh` - Clean teardown
- Parameter file for dev environment (`dev.parameters.json`)

### Deployed - Azure Resources
- **Resource Groups (6)**:
  - `rg-alberta-platform-identity-prod` - Identity and monitoring
  - `rg-alberta-platform-ai-dev` - AI services
  - `rg-alberta-platform-data-dev` - Data storage
  - `rg-alberta-platform-api-dev` - API layer
  - `rg-alberta-platform-web-dev` - Web frontend
  - `rg-alberta-platform-governance-prod` - Governance (Purview)

- **Azure OpenAI** (`oai-alberta-platform-dev`)
  - Location: East US (for GPT-4o model availability)
  - Deployments: GPT-4o (10K TPM), text-embedding-3-small (120K TPM)
  - Endpoint: https://oai-alberta-platform-dev.openai.azure.com/

- **Azure AI Search** (`srch-alberta-platform-dev`)
  - Location: Canada Central (data residency)
  - SKU: Basic
  - Endpoint: https://srch-alberta-platform-dev.search.windows.net

- **Azure Functions** (`func-alberta-platform-api-dev`)
  - Plan: Flex Consumption
  - Runtime: Node.js 20
  - System-assigned managed identity
  - Endpoint: https://func-alberta-platform-api-dev.azurewebsites.net

- **Static Web App** (`swa-alberta-platform-portal-dev`)
  - Location: East US 2 (service availability)
  - SKU: Free (dev environment)
  - Endpoint: https://wonderful-glacier-06429630f.2.azurestaticapps.net

- **Key Vault** (`kv-alberta-platform-dev`)
  - RBAC-enabled
  - Secrets: openai-api-key, aisearch-api-key
  - Soft delete: 90 days retention

- **Storage Accounts**:
  - `stalbertaplatformdatadev` - Data storage with containers (data, backup)
  - `stfuncalbertaplatformdev` - Function app storage

- **Monitoring**:
  - Log Analytics workspace (`log-alberta-platform-dev`)
  - Application Insights (`appi-alberta-platform-dev`)
  - Diagnostic settings for all resources

### Documentation
- Added `DEPLOYMENT.md` - Complete deployment guide
- Added `MANUAL_SETUP_STEPS.md` - Portal-based setup for Fabric/Purview/Copilot
- Updated `README.md` - Infrastructure deployment status
- Updated `GETTING_STARTED.md` - Reflects completed infrastructure
- Updated `docs/implementation-plan.md` - Phase 0 marked as complete
- Updated `docs/MIGRATION_PLAN.md` - Full migration strategy
- Created `infrastructure/BICEP_TEMPLATES.md` - IaC documentation
- Added `.gitignore` - Azure, secrets, and build artifacts

### Architecture Decisions
- **Regional Strategy**:
  - Canada Central: Primary data storage, AI Search (compliance)
  - East US: Azure OpenAI (GPT-4o model availability)
  - East US 2: Static Web Apps, Purview (service availability)

- **Resource Organization**:
  - Workload-based resource groups (identity, ai, data, api, web, governance)
  - Enables independent lifecycle management and RBAC
  - Facilitates cost tracking per workload

- **Naming Convention**:
  - Pattern: `{service}-{project}-{workload}-{env}`
  - Storage: max 24 chars, lowercase alphanumeric
  - Tags: project, environment, owner, createdBy, createdDate

- **Security**:
  - Key Vault RBAC (not access policies)
  - Managed identities (no stored credentials)
  - Soft delete enabled on Key Vault
  - Diagnostic logging to Log Analytics
  - Network security planned for production

### Known Issues
- Function App Key Vault access requires manual role assignment (cross-resource-group Bicep limitation)
- Microsoft Fabric requires manual portal setup (no stable Bicep support)
- Microsoft Purview requires manual portal setup (limited Bicep support)
- Copilot Studio requires manual setup (Power Platform, not ARM)

### Cost Estimates
- **Current deployment**: ~$245/month (without Fabric)
- **With Fabric F2**: ~$645/month
- **With Fabric F64**: ~$8,916/month
- Auto-pause can reduce Fabric costs by ~60%

### Migration
- Initiated migration from [Alberta MCP](https://github.com/JCrossman/alberta-mcp)
- Plan to consolidate:
  - CosmosDB → Microsoft Fabric (OneLake)
  - Standalone Azure OpenAI → AI Foundry (managed)
  - TypeScript MCP servers → Copilot Studio agents
- 26-week migration roadmap documented

## [0.1.0] - 2026-01-19

### Added - Project Foundation
- Initial project structure and documentation
- User stories for 5 personas (healthcare admin, environmental analyst, CDO, security officer, citizen)
- Implementation plan (7 phases, 20+ weeks)
- Architecture design documentation
- Data governance framework
- Success metrics and KPIs
- Risk assessment and mitigation strategies
- Technical requirements documentation

### Use Cases Defined
1. Healthcare Intelligence (wait time analysis, resource optimization)
2. Courts and Justice (case tracking, resource allocation)
3. Energy and Agriculture (resource monitoring, predictive analytics)
4. Alberta Pensions (benefit calculations, fraud detection)

---

## Future Releases

### [1.1.0] - Planned
- Microsoft Fabric capacity deployment (F2 or F64)
- Microsoft Purview scanning configuration
- Copilot Studio agent setup
- Data migration from Alberta MCP CosmosDB
- Initial data pipelines (Healthcare use case)

### [1.2.0] - Planned
- Complete data governance implementation
- Power BI dashboards
- Fabric notebooks for data engineering
- Purview data lineage configuration

### [2.0.0] - Planned
- Custom React portal deployment
- AI agent orchestration
- Production-ready configurations
- Customer demo materials

---

## Links
- **Repository**: https://github.com/JCrossman/alberta-platform
- **Migration Source**: https://github.com/JCrossman/alberta-mcp
- **Issues**: https://github.com/JCrossman/alberta-platform/issues
- **Discussions**: https://github.com/JCrossman/alberta-platform/discussions

---

**Maintained by**: Jeremy Crossman (jcrossman@microsoft.com)
