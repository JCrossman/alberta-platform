# Alberta Open Data Intelligence Platform - Implementation Plan

## Overview

This implementation plan provides a phased approach to building the Alberta Open Data Intelligence Platform, prioritizing learning objectives, demonstration value, and customer impact.

---

## 🚨 IMPORTANT: Migration from Alberta MCP

**This project includes a full migration of the existing [Alberta MCP](https://github.com/JCrossman/alberta-mcp) project.**

The Alberta MCP project (Ministry Coordination Protocol servers for citizen services) will be consolidated into this unified platform, replacing:
- CosmosDB → Microsoft Fabric (OneLake)
- Azure OpenAI (standalone) → Azure AI Foundry (managed)
- TypeScript MCP servers → Copilot Studio agents

**See**: [MIGRATION_PLAN.md](./MIGRATION_PLAN.md) for the detailed migration strategy, Azure best practices, and Bicep templates.

**See**: [../infrastructure/BICEP_TEMPLATES.md](../infrastructure/BICEP_TEMPLATES.md) for Infrastructure as Code templates.

---

## Critical Demo Consideration

**Target Audience**: Senior government leadership (Deputy Ministers, CIOs, Directors)

**Key Insight**: Executives don't care about the inner wiring—they need to see a **transformational experience**. While Phases 1-6 focus on building robust Azure backend services (Fabric, Purview, AI Foundry, Copilot), the executive demo experience requires a polished, branded portal that showcases the citizen and staff experience.

**Two-Track Approach**:
- **Phases 1-6**: Build solid technical foundation, demo to technical audiences using native Azure interfaces
- **Phase 7**: Add custom React portal for executive demos, showing the "art of the possible"

This ensures you master the technology first, then add the polish needed for C-suite presentations.

---

## Project Phases

### Phase 0: Foundation & Setup (Week 1-2) ✅ IN PROGRESS
**Objective**: Establish Azure environment and core infrastructure

#### Tasks
1. **Azure Environment Setup** ✅ COMPLETED (Jan 20, 2026)
   - [x] Create Azure subscription (if needed)
   - [x] Set up Canadian Azure regions (Canada Central, Canada East)
   - [x] Configure resource groups and naming conventions via Bicep IaC
   - [x] Set up GitHub for version control
   - [x] Establish cost management and budgeting alerts

2. **Service Provisioning** 🔄 IN PROGRESS (Updated: Jan 28, 2026)
   - [ ] Deploy core Azure infrastructure via Bicep:
     - Azure OpenAI (GPT-4o, text-embedding-3-small) - East US
     - Azure AI Search - Canada Central
     - Azure Functions (Flex Consumption)
     - Static Web App - East US 2
     - Key Vault with managed secrets
     - Storage Accounts with containers
     - Log Analytics & Application Insights
     - **Status**: Resource groups created, services deployment pending (name conflicts to resolve)
   - [x] Enable Microsoft Fabric capacity (fabricalbertadev - F2, Canada Central) ✅ COMPLETED Jan 28
   - [x] Create Fabric workspaces (6 workspaces created and assigned) ✅ COMPLETED Jan 28
   - [ ] Set up Microsoft Purview scanning (manual)
   - [ ] Configure Copilot Studio environment (manual)
   
**Infrastructure Deployment Details**:
- **IaC Location**: `infrastructure/bicep/`
- **Deployment Script**: `infrastructure/bicep/scripts/deploy.sh dev`
- **Destroy Script**: `infrastructure/bicep/scripts/destroy.sh dev`
- **Deployment Time**: ~15 minutes
- **Cost**: ~$645/month (without Fabric)

**Fabric Deployment Details** ✅ COMPLETED:
- **Capacity**: fabricalbertadev (F2 SKU, Canada Central)
- **Subscription**: ME-MngEnvMCAP516709-jcrossman-1 (dabe0b83-abdb-448f-9ab0-31dfb2ab6b4b)
- **Status**: Active (billing $1.35/hour)
- **Workspaces Created** (Jan 28, 2026):
  - alberta-healthcare (e18c4eb6-b6b2-4778-98cf-d8af3ad13215)
  - alberta-justice (c780cc3b-fe24-4678-a6f2-250afd91de9e)
  - alberta-energy (053e2131-7ddc-4b57-89c2-5b0f2a3ec869)
  - alberta-agriculture (1d746c8d-d173-4680-9ef3-d382a2136b61)
  - alberta-pensions (86dd4de7-85ec-49ab-ad72-ec1bc76ecb55)
  - alberta-coordination (1013f015-ee04-473d-a868-4dc682f322fe)
- **Management Scripts**: `infrastructure/bicep/fabric/` (pause-fabric.sh, resume-fabric.sh, status-fabric.sh)
- **Cost Management**: Pause when not in use to save ~70% (~$290/month vs $988/month)

3. **Data Source Identification** 🔜 NEXT
   - [ ] Identify Alberta Open Data sources (healthcare, environment, education)
   - [ ] Document data schemas and APIs
   - [ ] Assess data quality and update frequency
   - [ ] Create data source inventory
   - [ ] Obtain necessary API keys/access credentials
   - **Target Start**: After core Azure services deployed

4. **Security & Compliance Baseline**
   - [ ] Configure Azure AD/Entra ID security
   - [ ] Set up network security groups
   - [ ] Enable Azure Security Center
   - [ ] Configure audit logging
   - [ ] Document compliance requirements (Protected A/B simulation)

**Deliverables**:
- Fully configured Azure environment
- Data source catalog
- Security baseline documentation
- Development environment ready

**Learning Focus**:
- Azure resource management
- Security and compliance fundamentals
- Data source evaluation

---

### Phase 1: Data Foundation with Microsoft Fabric (Week 3-5)
**Objective**: Build unified data platform and establish data engineering patterns

#### Tasks
1. **OneLake Configuration**
   - [ ] Set up OneLake storage structure
   - [ ] Define data zones (Bronze/Silver/Gold architecture)
   - [ ] Configure data retention policies
   - [ ] Implement folder security

2. **Data Ingestion - Healthcare**
   - [ ] Create data pipeline for Alberta Health Services wait times
   - [ ] Build incremental load process
   - [ ] Implement error handling and logging
   - [ ] Create data quality checks
   - [ ] Schedule automated refreshes

3. **Data Ingestion - Environmental**
   - [ ] Ingest air quality data (Alberta Environment)
   - [ ] Integrate water quality datasets
   - [ ] Add climate/weather data
   - [ ] Create unified environmental data model

4. **Data Ingestion - Additional Sources**
   - [ ] Education statistics
   - [ ] Public spending/budget data
   - [ ] Demographics and census data

5. **Data Transformation**
   - [ ] Build data cleaning notebooks (PySpark/SQL)
   - [ ] Create data models for each domain
   - [ ] Implement slowly changing dimensions
   - [ ] Build fact and dimension tables
   - [ ] Create aggregated views for reporting

6. **Initial Analytics**
   - [ ] Create Power BI workspace
   - [ ] Build healthcare dashboard (wait times, trends)
   - [ ] Build environmental dashboard (air quality, water)
   - [ ] Implement row-level security
   - [ ] Create mobile-optimized views

**Deliverables**:
- Operational data pipelines for 3+ data sources
- Bronze/Silver/Gold data lake architecture
- 2-3 Power BI dashboards
- Data engineering documentation

**Learning Focus**:
- Microsoft Fabric OneLake architecture
- Data engineering with Fabric notebooks
- Power BI integration with Fabric
- Data pipeline orchestration

**Demo Value**:
- Show unified data platform replacing data silos
- Demonstrate real-time analytics on government data
- Highlight ease of integration and governance

---

### Phase 2: Data Governance with Microsoft Purview (Week 6-8)
**Objective**: Implement comprehensive data governance, cataloging, and compliance

#### Tasks
1. **Data Catalog Setup**
   - [ ] Register Fabric workspace as data source
   - [ ] Configure automated scanning
   - [ ] Enable data lineage tracking
   - [ ] Set up glossary terms

2. **Business Glossary**
   - [ ] Define government-specific terms
   - [ ] Create healthcare domain glossary
   - [ ] Create environmental domain glossary
   - [ ] Map technical to business terms
   - [ ] Assign glossary stewards

3. **Data Classification**
   - [ ] Create custom classifications (Protected A/B simulation)
   - [ ] Define sensitivity labels
   - [ ] Implement automated classification rules
   - [ ] Tag PII and sensitive data
   - [ ] Configure classification reports

4. **Data Lineage**
   - [ ] Validate end-to-end lineage from source to report
   - [ ] Document data transformations
   - [ ] Create impact analysis views
   - [ ] Track data flow across systems

5. **Data Quality & Insights**
   - [ ] Set up data quality rules
   - [ ] Configure data profiling
   - [ ] Create data quality dashboards
   - [ ] Implement data health monitoring

6. **Access Policies**
   - [ ] Define data access policies
   - [ ] Implement resource sets
   - [ ] Configure self-service access requests
   - [ ] Create audit reports

7. **Compliance Framework**
   - [ ] Document Protected B handling procedures
   - [ ] Create compliance checklists
   - [ ] Implement audit logging
   - [ ] Build compliance dashboards

**Deliverables**:
- Fully cataloged data assets
- Business glossary with 50+ terms
- Data classification scheme
- Data lineage visualization
- Compliance documentation

**Learning Focus**:
- Purview data cataloging and discovery
- Data classification and sensitivity labeling
- Data lineage and impact analysis
- Compliance and audit capabilities

**Demo Value**:
- Show how to find data across the organization
- Demonstrate data lineage for regulatory compliance
- Highlight sensitive data protection
- Show self-service data discovery

---

### Phase 3: AI Agents with Azure AI Foundry (Week 9-12)
**Objective**: Build intelligent AI agents for predictive analytics and insights

#### Tasks
1. **AI Foundry Setup**
   - [ ] Create AI Foundry project
   - [ ] Connect to Fabric data sources
   - [ ] Configure model catalog
   - [ ] Set up prompt flow
   - [ ] Enable responsible AI dashboard

2. **Healthcare Prediction Model**
   - [ ] Build wait time prediction model
   - [ ] Train on historical data
   - [ ] Validate model performance
   - [ ] Deploy as REST endpoint
   - [ ] Create model monitoring

3. **Environmental Analytics Agent**
   - [ ] Build air quality forecasting model
   - [ ] Create anomaly detection for water quality
   - [ ] Implement trend analysis
   - [ ] Deploy multi-model agent

4. **Natural Language Query Agent**
   - [ ] Build RAG (Retrieval Augmented Generation) system
   - [ ] Index government data for semantic search
   - [ ] Create prompt templates
   - [ ] Implement query routing
   - [ ] Add source attribution

5. **Agent Orchestration**
   - [ ] Design multi-agent workflow
   - [ ] Implement agent routing logic
   - [ ] Create agent monitoring dashboard
   - [ ] Build error handling and fallbacks

6. **Responsible AI Implementation**
   - [ ] Configure fairness assessment
   - [ ] Implement bias detection
   - [ ] Create explainability reports
   - [ ] Document AI model cards
   - [ ] Set up human-in-the-loop review

7. **Integration with Purview**
   - [ ] Enable AI agent governance
   - [ ] Track AI data usage
   - [ ] Configure AI observability
   - [ ] Create AI compliance reports

**Deliverables**:
- 3+ trained AI models
- Deployed AI agents with REST APIs
- RAG-based query system
- Responsible AI documentation
- AI monitoring dashboards

**Learning Focus**:
- Azure AI Foundry project structure
- Model training and deployment
- Prompt engineering and RAG
- Multi-agent orchestration
- Responsible AI practices

**Demo Value**:
- Show predictive insights for resource planning
- Demonstrate natural language interaction with data
- Highlight responsible AI governance
- Show AI agent collaboration

---

### Phase 4: Citizen Services with Copilot Studio (Week 13-15)
**Objective**: Create low-code conversational AI for citizen engagement

#### Tasks
1. **Copilot Studio Setup**
   - [ ] Create Copilot Studio environment
   - [ ] Connect to AI Foundry models
   - [ ] Configure authentication
   - [ ] Set up analytics

2. **Alberta Services Chatbot**
   - [ ] Design conversation topics
     - Finding government services
     - Healthcare information
     - Environmental reports
     - Permit applications
   - [ ] Build conversation flows
   - [ ] Implement slot filling
   - [ ] Add fallback handling

3. **AI Foundry Integration**
   - [ ] Connect to RAG query agent
   - [ ] Integrate prediction models
   - [ ] Route complex queries to AI Foundry
   - [ ] Implement response formatting

4. **Data Visualization Integration**
   - [ ] Embed Power BI reports in chat
   - [ ] Generate custom data cards
   - [ ] Create adaptive cards for results
   - [ ] Implement chart summaries

5. **Multi-Channel Deployment**
   - [ ] Deploy to Teams
   - [ ] Create web chat widget
   - [ ] Test mobile responsiveness
   - [ ] Configure channel-specific features

6. **Multilingual Support**
   - [ ] Add French language support
   - [ ] Test translation quality
   - [ ] Implement language detection
   - [ ] Create bilingual responses (Canadian requirement)

7. **Analytics & Improvement**
   - [ ] Configure conversation analytics
   - [ ] Track user satisfaction
   - [ ] Identify common queries
   - [ ] Iterate on conversation design

**Deliverables**:
- Functional citizen services chatbot
- Multi-channel deployment
- Bilingual support (English/French)
- Usage analytics dashboard
- Demo scripts

**Learning Focus**:
- Copilot Studio conversation design
- Low-code AI agent building
- Integration with Azure AI Foundry
- Multi-channel deployment
- Conversation analytics

**Demo Value**:
- Show 24/7 citizen service availability
- Demonstrate natural conversation flow
- Highlight low-code development speed
- Show bilingual capabilities

---

### Phase 5: Integration & End-to-End Scenarios (Week 16-17)
**Objective**: Connect all components and create complete user journeys

#### Tasks
1. **End-to-End Healthcare Scenario**
   - [ ] Citizen asks chatbot about wait times
   - [ ] Chatbot queries AI agent
   - [ ] AI returns prediction
   - [ ] Chatbot shows visualization
   - [ ] User can drill into Power BI report
   - [ ] All interactions tracked in Purview

2. **End-to-End Environmental Scenario**
   - [ ] Citizen asks about air quality
   - [ ] System shows current data + forecast
   - [ ] User can request historical trends
   - [ ] Anomaly detection alerts shown
   - [ ] Data lineage available for transparency

3. **Data Governance Scenario**
   - [ ] Data steward searches for dataset
   - [ ] Finds data in Purview catalog
   - [ ] Views lineage and quality metrics
   - [ ] Requests access through policy
   - [ ] Uses data in Power BI
   - [ ] Audit trail captured

4. **Cross-Service Workflows**
   - [ ] Test data flow: Fabric → AI Foundry → Copilot
   - [ ] Validate governance: Purview tracking all interactions
   - [ ] Verify security: proper access controls
   - [ ] Confirm compliance: audit logs complete

**Deliverables**:
- 3+ end-to-end demo scenarios
- Integration testing results
- User journey documentation
- Demo flow scripts

**Learning Focus**:
- Cross-service integration
- End-to-end data governance
- Complete user experiences
- System testing

---

### Phase 6: Demo Preparation & Documentation (Week 18-20)
**Objective**: Create compelling demos and comprehensive documentation

#### Tasks
1. **Demo Scripts**
   - [ ] Write detailed demo scripts for each use case
   - [ ] Create talking points for government audience
   - [ ] Develop ROI narratives
   - [ ] Practice demo timing (15min, 30min, 60min versions)
   - [ ] Create demo reset procedures

2. **Demo Assets**
   - [ ] Create demo videos (2-3 minutes each)
   - [ ] Build PowerPoint presentation deck
   - [ ] Design architecture diagrams
   - [ ] Create customer-facing materials
   - [ ] Develop leave-behind resources

3. **Technical Documentation**
   - [ ] Document architecture decisions
   - [ ] Create setup/deployment guide
   - [ ] Write troubleshooting guide
   - [ ] Document API specifications
   - [ ] Create data dictionary

4. **Business Documentation**
   - [ ] Create executive summary
   - [ ] Document business value and ROI
   - [ ] Build case studies
   - [ ] Create customer success metrics
   - [ ] Develop FAQ document

5. **Training Materials**
   - [ ] Create self-paced learning modules
   - [ ] Build hands-on labs
   - [ ] Write best practices guide
   - [ ] Create quick reference cards

6. **Portal Planning (Prep for Phase 7)**
   - [ ] Design mockups for citizen portal
   - [ ] Design mockups for admin portal
   - [ ] Identify which Power BI reports to embed
   - [ ] Document API integration requirements
   - [ ] Create user journey flows for portal
   - [ ] Review React + Azure Functions architecture
   - [ ] **Note**: Portal development deferred to Phase 7 for executive demos

**Deliverables**:
- Complete demo kit
- Technical and business documentation
- Training materials
- Video demonstrations
- Presentation decks
- Portal design mockups (ready for Phase 7 development)

---

## Phase 7: Optimization & Advanced Features (Week 21+)
**Objective**: Enhance platform with advanced capabilities and executive-ready polish

### PRIORITY: Custom Portal for Executive Demos

**Context**: Senior government leadership needs to see a transformational *experience*, not Azure consoles. While technical audiences appreciate seeing the Azure services, executives need to visualize the citizen and staff experience with polished, branded interfaces.

**Preferred Implementation**:

#### Custom Portal Development
- [ ] **Frontend**: React-based single-page application
  - Citizen landing page with embedded chatbot
  - Dashboard home with embedded Power BI reports
  - Data catalog search interface
  - Responsive design (mobile + desktop)
  - Alberta government branding
  
- [ ] **Backend**: Azure Functions (serverless)
  - API layer calling Power BI REST API
  - Integration with Purview REST API for catalog search
  - Proxy for AI Foundry endpoints
  - Authentication middleware
  
- [ ] **Authentication**: Azure AD integration
  - SSO for government staff
  - Guest access for demos
  - Role-based access (citizen vs. admin vs. steward)
  
- [ ] **Hosting**: Azure Static Web Apps or App Service
  - Canadian region deployment
  - SSL certificate
  - Custom domain (optional)

**Portal Structure**:
```
Alberta Government Data Hub
├── /citizen (public-facing)
│   ├── Home with chatbot widget
│   ├── Live dashboards (embedded Power BI)
│   ├── Service finder
│   └── Open data explorer
├── /admin (internal staff)
│   ├── Executive dashboard
│   ├── Operational analytics
│   ├── AI insights viewer
│   └── Data request workflow
└── /governance (data stewards)
    ├── Data catalog search
    ├── Quality dashboard
    ├── Lineage viewer
    └── Access management
```

**Estimated Effort**: 4-6 weeks
**Estimated Cost**: +$100-200/month (hosting + Functions consumption)

**Why This Matters**:
- Executive demos focus on *transformation*, not *technology*
- Shows "art of the possible" with government branding
- Demonstrates citizen-centric design
- Easier for non-technical stakeholders to envision deployment
- Differentiates from standard Azure console demos

**Demo Strategy Shift**:
- **Technical audiences**: Show Azure consoles (Phases 1-6)
- **Executive audiences**: Show custom portal (Phase 7+)
- **Mixed audiences**: Portal first, then "under the hood" in Azure

---

#### Other Optional Advanced Features
- [ ] Real-time streaming data with Fabric Event Streams
- [ ] Advanced ML ops with model monitoring
- [ ] Custom Purview connectors
- [ ] Advanced agent orchestration patterns
- [ ] GraphQL APIs for external access
- [ ] Mobile app integration
- [ ] Voice interface with Azure Speech
- [ ] Advanced security features (managed identities, RBAC)

---

## Resource Requirements

### Azure Resources Estimate (Monthly)
- Microsoft Fabric: ~$500-1000 (depends on capacity)
- Microsoft Purview: ~$200-400
- Azure AI Foundry: ~$300-600 (includes model hosting)
- Copilot Studio: ~$200 (includes message credits)
- Supporting services: ~$100-200
- **Total Estimated**: $1,300-2,200/month

### Time Commitment
- **Learning Mode**: 10-15 hours/week
- **Demo Prep Mode**: 20-25 hours/week
- **Total Duration**: 20 weeks (5 months)

### Skills Development
- Data engineering (Fabric)
- Data governance (Purview)
- AI/ML engineering (AI Foundry)
- Conversational AI design (Copilot Studio)
- Azure architecture
- Government sector knowledge

---

## Success Metrics

### Learning Objectives
- [ ] Successfully deploy all 4 Azure services
- [ ] Build 3+ end-to-end use cases
- [ ] Complete 5+ customer demos
- [ ] Obtain relevant Microsoft certifications (optional)

### Demo Effectiveness
- [ ] Can deliver 15-minute demo without issues
- [ ] Can answer technical questions confidently
- [ ] Have 3+ customer success stories
- [ ] Positive customer feedback on demos

### Technical Achievement
- [ ] Zero data breaches or security incidents
- [ ] 99%+ uptime for demo environment
- [ ] <2 second response time for AI queries
- [ ] Complete data lineage for all assets

---

## Risk Management

### Technical Risks
- **Data availability**: Alberta Open Data APIs change or become unavailable
  - *Mitigation*: Cache data locally, use multiple sources
- **Cost overrun**: Azure services exceed budget
  - *Mitigation*: Set up cost alerts, use auto-shutdown, monitor daily
- **Complexity**: Integration challenges between services
  - *Mitigation*: Start simple, iterate, leverage Microsoft documentation

### Demo Risks
- **Environment issues**: Demo breaks during customer presentation
  - *Mitigation*: Have backup environment, use recorded videos as backup
- **Data freshness**: Stale data reduces demo impact
  - *Mitigation*: Automate data refreshes, validate before demos
- **Customer misalignment**: Demo doesn't match customer needs
  - *Mitigation*: Pre-call discovery, customize talking points

---

## Next Steps

1. **Immediate** (This Week):
   - Review and approve implementation plan
   - Set up Azure subscription
   - Identify initial Alberta Open Data sources
   - Create project tracking board

2. **Short Term** (Next 2 Weeks):
   - Complete Phase 0 (Foundation & Setup)
   - Begin Phase 1 (Data Foundation)
   - Schedule weekly progress reviews

3. **Medium Term** (Month 2-3):
   - Complete data platform and governance
   - Begin AI development
   - Start demo script development

4. **Long Term** (Month 4-5):
   - Complete all integrations
   - Deliver first customer demo
   - Iterate based on feedback

---

## Appendix

### Helpful Resources
- [Microsoft Fabric Documentation](https://learn.microsoft.com/fabric/)
- [Microsoft Purview Documentation](https://learn.microsoft.com/purview/)
- [Azure AI Foundry Documentation](https://learn.microsoft.com/azure/ai-foundry/)
- [Copilot Studio Documentation](https://learn.microsoft.com/copilot-studio/)
- [Alberta Open Data Portal](https://open.alberta.ca/)
- [Canada Protected B Guidelines](https://www.canada.ca/en/government/system/digital-government/digital-government-innovations/cloud-services/government-canada-security-control-profile-cloud-based-it-services.html)

### Microsoft Learning Paths
- Microsoft Fabric Analytics Engineer
- Azure AI Engineer
- Security, Compliance, and Identity Fundamentals
