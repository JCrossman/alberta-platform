# System Architecture - Alberta Open Data Intelligence Platform

## Architecture Overview

This document describes the technical architecture of the Alberta Open Data Intelligence Platform, demonstrating how Microsoft Fabric, Purview, AI Foundry, and Copilot Studio work together to deliver a secure, governed, and intelligent data platform.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         CITIZEN & EMPLOYEE INTERFACES                    │
├─────────────────────────────────────────────────────────────────────────┤
│  Web Portal  │  Mobile App  │  Teams  │  Power BI  │  APIs              │
└──────┬───────────────┬─────────┬──────────┬─────────────────┬───────────┘
       │               │         │          │                 │
┌──────▼───────────────▼─────────▼──────────▼─────────────────▼───────────┐
│                        COPILOT STUDIO LAYER                              │
├──────────────────────────────────────────────────────────────────────────┤
│  • Citizen Services Chatbot (24/7 Natural Language Interface)           │
│  • Multi-channel deployment (Web, Teams, Mobile)                         │
│  • Bilingual support (English/French)                                   │
│  • Conversation analytics and optimization                              │
└──────┬───────────────────────────────────────────────────────────────────┘
       │
┌──────▼───────────────────────────────────────────────────────────────────┐
│                      AZURE AI FOUNDRY LAYER                              │
├──────────────────────────────────────────────────────────────────────────┤
│  AI Agents & Models:                                                     │
│  ├─ Healthcare Prediction Agent (Wait times, resource optimization)     │
│  ├─ Environmental Analytics Agent (Air quality, water monitoring)       │
│  ├─ Natural Language Query Agent (RAG for semantic search)              │
│  └─ Multi-Agent Orchestrator (Routing, collaboration)                   │
│                                                                          │
│  Capabilities:                                                           │
│  ├─ Prompt Flow for agent workflows                                     │
│  ├─ Model catalog (GPT-4, custom models)                                │
│  ├─ Responsible AI dashboard                                            │
│  └─ Model monitoring and evaluation                                     │
└──────┬───────────────────────────────────────────────────────────────────┘
       │
┌──────▼───────────────────────────────────────────────────────────────────┐
│                     MICROSOFT FABRIC LAYER                               │
├──────────────────────────────────────────────────────────────────────────┤
│  OneLake (Unified Data Lake):                                           │
│  ├─ Bronze Layer (Raw data ingestion)                                   │
│  ├─ Silver Layer (Cleaned, validated data)                              │
│  └─ Gold Layer (Business-ready aggregated data)                         │
│                                                                          │
│  Fabric Components:                                                      │
│  ├─ Data Factory (Pipelines for ETL/ELT)                                │
│  ├─ Synapse Data Engineering (Spark notebooks, transformations)         │
│  ├─ Synapse Data Warehouse (SQL analytics)                              │
│  ├─ Power BI (Dashboards and reports)                                   │
│  ├─ Data Activator (Real-time alerts)                                   │
│  └─ Event Streams (Real-time data streaming)                            │
└──────┬───────────────────────────────────────────────────────────────────┘
       │
┌──────▼───────────────────────────────────────────────────────────────────┐
│                    MICROSOFT PURVIEW LAYER                               │
├──────────────────────────────────────────────────────────────────────────┤
│  Data Governance:                                                        │
│  ├─ Data Catalog (Automated scanning, metadata management)              │
│  ├─ Business Glossary (Standardized terminology)                        │
│  ├─ Data Classification (Protected A/B sensitivity labels)              │
│  ├─ Data Lineage (End-to-end tracking)                                  │
│  ├─ Data Quality (Profiling, monitoring, alerting)                      │
│  ├─ Access Policies (Self-service with governance)                      │
│  └─ AI Agent Governance (Observability, compliance)                     │
└──────┬───────────────────────────────────────────────────────────────────┘
       │
┌──────▼───────────────────────────────────────────────────────────────────┐
│                         DATA SOURCES                                     │
├──────────────────────────────────────────────────────────────────────────┤
│  Alberta Open Data:                                                      │
│  ├─ Healthcare (Alberta Health Services wait times, capacity)           │
│  ├─ Environmental (Air quality, water quality, climate)                 │
│  ├─ Education (School performance, enrollment)                          │
│  ├─ Public Spending (Budget allocations, expenditures)                  │
│  └─ Demographics (Census data, population statistics)                   │
└──────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────┐
│                    CROSS-CUTTING CONCERNS                                │
├──────────────────────────────────────────────────────────────────────────┤
│  • Azure AD/Entra ID (Identity & Access Management)                     │
│  • Azure Key Vault (Secrets management)                                 │
│  • Azure Monitor (Logging, metrics, alerts)                             │
│  • Azure Security Center (Security posture management)                  │
│  • Azure Cost Management (Budget tracking)                              │
│  • Canadian Data Residency (Canada Central, Canada East)                │
└──────────────────────────────────────────────────────────────────────────┘
```

## Data Flow Architecture

### 1. Data Ingestion Flow
```
Alberta Open Data APIs
    ↓
Azure Data Factory Pipelines (Fabric)
    ↓
OneLake Bronze Layer (Raw data, partitioned by date)
    ↓
Purview Auto-Scan (Catalog, classify, profile)
    ↓
Data Quality Checks
    ↓
OneLake Silver Layer (Cleaned, validated, enriched)
    ↓
OneLake Gold Layer (Business aggregations, star schema)
    ↓
Power BI Semantic Models
    ↓
Dashboards & Reports
```

### 2. AI Inference Flow
```
User Query (Chatbot or API)
    ↓
Copilot Studio (Intent recognition, routing)
    ↓
AI Foundry Agent (Prompt processing)
    ↓
RAG System (Semantic search on OneLake data)
    ↓
Model Inference (Prediction or generation)
    ↓
Response Formatting
    ↓
Purview Audit Log (Track AI data access)
    ↓
User Interface (Chat response with visualizations)
```

### 3. Governance Flow
```
Data Asset Created (Fabric)
    ↓
Purview Auto-Discovery (Scan triggered)
    ↓
Metadata Extraction (Schema, lineage, statistics)
    ↓
Auto-Classification (AI-based sensitivity detection)
    ↓
Business Glossary Mapping
    ↓
Data Quality Assessment
    ↓
Catalog Searchable (Self-service discovery)
    ↓
Access Request (User or AI agent)
    ↓
Policy Evaluation (Purview)
    ↓
Approval Workflow (If required)
    ↓
Access Granted (Audit logged)
```

## Component Details

### Microsoft Fabric Components

#### OneLake
- **Purpose**: Unified data lake storage
- **Technology**: Built on Azure Data Lake Storage Gen2
- **Structure**: Multi-layer medallion architecture (Bronze/Silver/Gold)
- **Security**: Role-based access control, encryption at rest/in transit
- **Capacity**: F64 SKU recommended for production-scale demo

#### Data Factory
- **Purpose**: Orchestrate data ingestion and transformation
- **Key Pipelines**:
  - `healthcare-ingestion`: Hourly sync of AHS wait times
  - `environment-ingestion`: Real-time air/water quality
  - `batch-refresh`: Daily full refresh of education/spending data
- **Features**: Parameterized pipelines, retry logic, monitoring

#### Synapse Data Engineering
- **Purpose**: Large-scale data transformations
- **Technologies**: Apache Spark, PySpark, Scala
- **Notebooks**:
  - `data-quality-checks.ipynb`: Validation rules
  - `healthcare-transformations.ipynb`: Wait time calculations
  - `environmental-aggregations.ipynb`: Pollution indices
- **Optimization**: Delta Lake format, data partitioning, Z-ordering

#### Power BI
- **Purpose**: Business intelligence and visualization
- **Semantic Models**:
  - Healthcare Operations Model
  - Environmental Monitoring Model
  - Citizen Services Model
- **Reports**:
  - Executive Dashboard
  - Healthcare Analytics
  - Environmental Trends
  - Governance Metrics
- **Features**: Row-level security, incremental refresh, mobile layout

### Microsoft Purview Components

#### Data Map
- **Purpose**: Automated discovery and cataloging
- **Scan Schedule**: Daily full scan, hourly incremental
- **Sources Registered**:
  - Fabric workspaces (OneLake)
  - Azure SQL Database (if used)
  - Power BI workspaces
  - AI Foundry projects

#### Data Catalog
- **Purpose**: Search and discovery interface
- **Search Capabilities**: Full-text, faceted filters, relevance ranking
- **Metadata**: Technical + business metadata
- **Annotations**: User ratings, comments, expert endorsements

#### Data Lineage
- **Purpose**: Track data movement and transformations
- **Visualization**: Interactive graph showing source → transformation → destination
- **Granularity**: Column-level lineage where available
- **Impact Analysis**: "What if I change this?" simulation

#### Data Quality
- **Purpose**: Monitor and ensure data trustworthiness
- **Rules**:
  - Completeness: No null values in required fields
  - Accuracy: Values within expected ranges
  - Consistency: Cross-dataset validation
  - Timeliness: Data freshness checks
- **Alerting**: Email notifications for quality issues

### Azure AI Foundry Components

#### AI Project
- **Purpose**: Centralized AI development environment
- **Resources**:
  - Azure OpenAI (GPT-4, GPT-4 Turbo)
  - Azure Machine Learning compute
  - Model registry
  - Prompt flow

#### Models & Agents

**1. Healthcare Prediction Agent**
- **Type**: Regression model
- **Algorithm**: XGBoost, time-series forecasting
- **Input**: Historical wait times, day of week, time of day, weather
- **Output**: Predicted wait time (next 48 hours)
- **Accuracy Target**: 85%+ MAPE
- **Deployment**: Real-time endpoint with auto-scaling

**2. Environmental Analytics Agent**
- **Type**: Anomaly detection + forecasting
- **Algorithm**: Isolation Forest, LSTM
- **Input**: Air/water quality sensor data
- **Output**: Anomaly alerts, 24-hour forecast
- **Accuracy Target**: <5% false positive rate
- **Deployment**: Batch + real-time

**3. Natural Language Query Agent (RAG)**
- **Type**: Retrieval Augmented Generation
- **Components**:
  - Azure OpenAI GPT-4 (Generation)
  - Azure Cognitive Search (Retrieval)
  - Embeddings: text-embedding-ada-002
- **Index**: Government documents, policies, FAQs, datasets
- **Features**: Source attribution, confidence scoring
- **Guardrails**: Content filtering, grounding

#### Responsible AI
- **Fairness**: Bias detection across demographics
- **Transparency**: Model cards for each model
- **Accountability**: Human-in-the-loop for high-stakes decisions
- **Privacy**: No PII in training data
- **Security**: Input validation, output filtering

### Copilot Studio Components

#### Conversational Topics

**1. Service Discovery**
- Intent: "Help me find government services"
- Entities: Service type, location, eligibility
- Actions: Search catalog, recommend services
- Responses: Adaptive cards with links

**2. Healthcare Information**
- Intent: "What are hospital wait times?"
- Entities: Hospital, service type, time
- Actions: Call AI Foundry prediction API
- Responses: Current + predicted wait times with chart

**3. Environmental Queries**
- Intent: "Is the air quality safe today?"
- Entities: Location, date
- Actions: Query Fabric data, get forecast
- Responses: AQI with color coding, health recommendations

**4. Policy Questions**
- Intent: "What are the rules for X?"
- Entities: Topic, regulation
- Actions: RAG query on policy documents
- Responses: Natural language answer with citations

#### Integration Points
- **AI Foundry**: Custom actions calling REST APIs
- **Power BI**: Embedded reports in adaptive cards
- **Microsoft Graph**: Access to M365 data (if needed)
- **External APIs**: Weather, maps, geocoding

#### Analytics
- **Metrics Tracked**:
  - Conversation volume by topic
  - Resolution rate (answered without escalation)
  - User satisfaction (CSAT survey)
  - Average response time
  - Abandonment rate
- **Optimization**: A/B testing of responses, continuous learning

## Security Architecture

### Identity & Access Management
- **Azure AD/Entra ID**: Single sign-on for all services
- **Conditional Access**: MFA for sensitive data access
- **Privileged Identity Management**: Just-in-time admin access
- **Service Principals**: For application-to-application auth

### Network Security
- **Virtual Networks**: Isolate resources
- **Private Endpoints**: Fabric, Purview, AI services
- **Network Security Groups**: Restrict traffic
- **Azure Firewall**: Outbound filtering

### Data Security
- **Encryption at Rest**: AES-256 for all storage
- **Encryption in Transit**: TLS 1.2+
- **Data Classification**: Protected A/B labels
- **Data Loss Prevention**: Block sensitive data exfiltration
- **Customer-Managed Keys**: For highest security requirements (optional)

### Application Security
- **API Gateway**: Rate limiting, authentication
- **Input Validation**: Prevent injection attacks
- **Output Sanitization**: Prevent XSS
- **Secrets Management**: Azure Key Vault
- **Vulnerability Scanning**: Regular security assessments

### Compliance
- **Data Residency**: Canadian regions only
- **Audit Logging**: All access logged to Azure Monitor
- **Retention**: 7 years for compliance
- **Certifications**: ISO 27001, SOC 2, FedRAMP equivalents

## Deployment Architecture

### Resource Groups
```
rg-alberta-platform-dev      (Development environment)
rg-alberta-platform-test     (Testing environment)
rg-alberta-platform-prod     (Production/demo environment)
```

### Regions
- **Primary**: Canada Central (Toronto)
- **Secondary**: Canada East (Quebec) for disaster recovery

### Infrastructure as Code
- **Tool**: Azure Bicep (preferred) or Terraform
- **Repository**: Git-based version control
- **CI/CD**: Azure DevOps or GitHub Actions
- **Environments**: Dev, Test, Prod with approval gates

## Scalability & Performance

### Fabric Scaling
- **Capacity**: Start with F64, scale to F128+ as needed
- **Data Partitioning**: By date and region
- **Caching**: Power BI model caching, query result caching

### AI Foundry Scaling
- **Compute**: Auto-scaling for inference endpoints
- **Rate Limiting**: Prevent model overload
- **Caching**: Frequent query result caching

### Copilot Studio Scaling
- **Message Credits**: Monitor usage, scale plan as needed
- **Response Time**: <2 seconds target
- **Concurrent Users**: Supports thousands

## Disaster Recovery

### Backup Strategy
- **OneLake**: Geo-redundant storage (GRS)
- **Purview Catalog**: Daily metadata export
- **Power BI**: Workspace backup via API
- **AI Models**: Version control in Git

### Recovery Objectives
- **RTO** (Recovery Time Objective): 4 hours
- **RPO** (Recovery Point Objective): 1 hour
- **Testing**: Quarterly DR drills

## Monitoring & Observability

### Metrics
- **Data Pipeline Success Rate**: >99%
- **AI Model Response Time**: <2 seconds
- **Chatbot Availability**: >99.9%
- **Data Quality Score**: >90%

### Alerting
- **Critical**: Pipeline failures, security incidents
- **Warning**: Quality degradation, cost thresholds
- **Info**: Usage patterns, performance trends

### Dashboards
- **Operational Dashboard**: Real-time system health
- **Business Dashboard**: Usage, adoption, ROI
- **Governance Dashboard**: Compliance, data quality

## Cost Optimization

### Strategies
- **Auto-pause**: Fabric capacity during non-business hours
- **Reserved Instances**: For predictable workloads
- **Spot Instances**: For batch processing (AI training)
- **Data Lifecycle**: Move cold data to archive storage

### Estimated Monthly Costs
See Implementation Plan for detailed breakdown (~$1,300-2,200/month)

## Technology Stack Summary

| Layer | Technologies |
|-------|-------------|
| **Data Storage** | OneLake (ADLS Gen2), Delta Lake |
| **Data Processing** | Apache Spark, PySpark, SQL |
| **Orchestration** | Azure Data Factory |
| **Analytics** | Power BI, Synapse Analytics |
| **Governance** | Microsoft Purview |
| **AI/ML** | Azure OpenAI, Azure Machine Learning, Cognitive Search |
| **Conversational AI** | Copilot Studio |
| **Infrastructure** | Azure Bicep, Terraform |
| **Identity** | Azure AD/Entra ID |
| **Monitoring** | Azure Monitor, Application Insights |
| **Development** | VS Code, Jupyter Notebooks, Git |

## Integration Patterns

### Pattern 1: Real-Time Data Flow
Alberta API → Event Hub → Fabric Event Stream → OneLake → Real-time Dashboard

### Pattern 2: Batch ETL
Alberta API → Data Factory → OneLake Bronze → Spark Transform → OneLake Silver/Gold

### Pattern 3: AI Inference
User Query → Copilot → AI Foundry → OneLake (RAG) → Response

### Pattern 4: Governance Automation
New Data → Purview Scan → Auto-Classify → Policy Apply → Catalog Update

## Future Enhancements

### Phase 2 Capabilities (Post-MVP)
- **Streaming Analytics**: Real-time event processing
- **Advanced ML**: Deep learning for image/video analysis
- **Voice Interface**: Azure Speech integration
- **Mobile App**: Native iOS/Android apps
- **GraphQL API**: Flexible data access layer
- **Blockchain**: Immutable audit trail (if required)

## References
- [Microsoft Fabric Architecture](https://learn.microsoft.com/fabric/fundamentals/)
- [Purview Data Governance](https://learn.microsoft.com/purview/)
- [AI Foundry Best Practices](https://learn.microsoft.com/azure/ai-foundry/)
- [Copilot Studio Architecture](https://learn.microsoft.com/copilot-studio/)
