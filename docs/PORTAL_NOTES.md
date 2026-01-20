# Custom Portal Development - Planning Notes

## Strategic Context

**Critical Insight**: Senior government leadership (Deputy Ministers, CIOs, Directors) evaluate solutions based on the **transformational experience**, not the technical implementation. They need to visualize how citizens and staff will interact with the platform, not how data flows through Azure services.

## Phased Approach

### Phases 1-6: Technical Foundation (Weeks 1-20)
**Focus**: Master Azure services
**Demo Approach**: Technical audiences see native interfaces
- Power BI: Web dashboards (polished ✅)
- Copilot: Teams or web chat (polished ✅)
- Purview: Azure portal (technical console ⚠️)
- Fabric: Azure portal (technical console ⚠️)
- AI Foundry: Azure portal (technical console ⚠️)

**Good for:**
- IT Directors
- Data Architects
- Data Engineers
- Security Officers
- Anyone who wants to see "how it really works"

**Less effective for:**
- Deputy Ministers
- CIOs
- Program Directors
- Policy leaders
- Anyone focused on outcomes, not implementation

---

### Phase 7: Executive Polish (Weeks 21-26)
**Focus**: Build custom branded portal
**Demo Approach**: Executives see citizen/staff experience

## Preferred Portal Architecture

### Technology Stack

**Frontend**: React
- Modern, component-based UI
- Rich ecosystem of libraries
- Excellent Azure integration
- Easy to brand with Alberta government styling

**Backend**: Azure Functions (Serverless)
- No infrastructure management
- Auto-scaling
- Pay only for execution
- Perfect for API gateway pattern

**Authentication**: Azure Active Directory
- Single sign-on for government staff
- Guest access for demos
- Role-based access control
- Enterprise security

**API Integrations**:
- Power BI REST API (embed dashboards)
- Purview REST API (data catalog search)
- AI Foundry endpoints (predictions, chatbot)
- Custom business logic

**Hosting**: Azure Static Web Apps or App Service
- Canadian region deployment
- SSL/HTTPS by default
- CI/CD integration with GitHub
- Low cost ($100-200/month)

---

## Portal Structure

### Portal Architecture
```
Alberta Government Data Hub
├── /citizen (Public-Facing Experience)
│   ├── Home Page
│   │   ├── Hero section with value proposition
│   │   ├── Embedded chatbot widget (Copilot)
│   │   └── Quick links to services
│   ├── Live Dashboards
│   │   ├── Healthcare wait times (embedded Power BI)
│   │   ├── Air quality map (embedded Power BI)
│   │   └── Open data explorer
│   ├── Service Finder
│   │   ├── Search government services
│   │   ├── Eligibility checker
│   │   └── Application guides
│   └── About
│       ├── How it works
│       ├── Data sources
│       └── Privacy policy
│
├── /admin (Internal Staff Portal)
│   ├── Executive Dashboard
│   │   ├── KPI summary cards
│   │   ├── Embedded Power BI reports
│   │   └── AI-powered insights
│   ├── Operational Analytics
│   │   ├── Healthcare operations
│   │   ├── Environmental monitoring
│   │   └── Citizen service metrics
│   ├── AI Insights Viewer
│   │   ├── Predictions (wait times, air quality)
│   │   ├── Anomaly alerts
│   │   └── Recommendations
│   └── Data Request Workflow
│       ├── Request access to datasets
│       ├── Approval tracking
│       └── Download data
│
└── /governance (Data Steward Portal)
    ├── Data Catalog
    │   ├── Search interface (calls Purview API)
    │   ├── Faceted filtering
    │   └── Dataset details
    ├── Data Lineage Viewer
    │   ├── Visual lineage graph
    │   ├── Impact analysis
    │   └── Transformation details
    ├── Quality Dashboard
    │   ├── Quality scores by dataset
    │   ├── Trending over time
    │   └── Issue tracking
    └── Access Management
        ├── Pending access requests
        ├── User permissions
        └── Audit logs
```

---

## User Personas & Journeys

### Citizen Journey (2am Saturday)
```
Alex's child has a fever. ER or wait until morning?

1. Visits: alberta-data-hub.ca
2. Sees chatbot: "How can I help you?"
3. Types: "Should I go to ER with a sick child?"
4. Chatbot: "Let me check current wait times..."
   [Calls AI Foundry → predicts wait time]
5. Response: "Royal Alexandra Hospital: 45 min wait now, 
   predicted 60 min in 2 hours. Stollery Children's: 
   30 min wait now, predicted 25 min in 2 hours."
6. Shows embedded chart with trends
7. Alex clicks through to see detailed dashboard
8. Makes informed decision ✅
```

### Administrator Journey (Monday 9am)
```
Sarah (Healthcare Director) needs to plan this week's staffing.

1. Logs into admin portal with Azure AD SSO
2. Lands on Executive Dashboard
3. Sees alert: "⚠️ High ER volume predicted Friday 4-8pm"
4. Clicks into prediction details
5. Views AI model's reasoning (weather, events, historical trends)
6. Drills into Power BI dashboard showing facility capacity
7. Checks data lineage to verify data quality
8. Makes staffing decision based on trusted data ✅
```

### Data Steward Journey (Tuesday 10am)
```
Marcus (Environmental Analyst) needs water quality data.

1. Logs into governance portal
2. Searches catalog: "water quality"
3. Finds dataset with quality score: 95/100 ✅
4. Reviews metadata, update frequency, owner
5. Clicks "View Lineage"
6. Sees data flow: Sensor → Fabric → Gold Layer
7. Requests access (auto-approved for low-sensitivity)
8. Downloads data or uses API ✅
```

---

## Visual Design Principles

### Alberta Government Branding
- Use Alberta government color palette
- Alberta logo and wordmark
- Professional, accessible design
- Bilingual (English/French) throughout

### Accessibility
- WCAG 2.1 AA compliance
- Screen reader compatible
- Keyboard navigation
- High contrast mode
- Responsive mobile design

### User Experience
- Fast load times (<3 seconds)
- Intuitive navigation
- Clear calls-to-action
- Progressive disclosure (simple → advanced)
- Consistent design patterns

---

## Development Estimates

### Phase 7 Timeline (4-6 weeks)

**Week 21-22: Portal Foundation**
- [ ] Set up React project structure
- [ ] Configure Azure Functions backend
- [ ] Implement Azure AD authentication
- [ ] Deploy to Azure Static Web Apps
- [ ] Establish CI/CD pipeline

**Week 23: Citizen Portal**
- [ ] Build home page with chatbot widget
- [ ] Embed Power BI dashboards (healthcare, environmental)
- [ ] Create service finder interface
- [ ] Mobile responsive design

**Week 24: Admin Portal**
- [ ] Build executive dashboard
- [ ] Embed operational analytics
- [ ] Create AI insights viewer
- [ ] Implement role-based access

**Week 25: Governance Portal**
- [ ] Build data catalog search (Purview API)
- [ ] Create lineage visualization
- [ ] Build quality dashboard
- [ ] Implement access request workflow

**Week 26: Polish & Testing**
- [ ] Alberta government branding
- [ ] Accessibility testing
- [ ] Performance optimization
- [ ] User acceptance testing
- [ ] Demo rehearsal

---

## API Integration Examples

### Power BI Embed
```javascript
// React component embedding Power BI
import { PowerBIEmbed } from 'powerbi-client-react';

function HealthcareDashboard() {
  return (
    <PowerBIEmbed
      embedConfig={{
        type: 'report',
        id: 'report-id-from-powerbi',
        embedUrl: 'https://app.powerbi.com/...',
        accessToken: azureAdToken,
        settings: {
          panes: { filters: { visible: false } },
          background: 'transparent'
        }
      }}
    />
  );
}
```

### Purview Catalog Search
```javascript
// Azure Function calling Purview API
async function searchCatalog(req, context) {
  const searchTerm = req.query.search;
  
  const response = await fetch(
    `https://${purviewAccount}.purview.azure.com/catalog/api/search/query`,
    {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${purviewToken}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        keywords: searchTerm,
        limit: 20
      })
    }
  );
  
  return response.json();
}
```

### AI Prediction API
```javascript
// Call AI Foundry endpoint
async function predictWaitTime(facilityId) {
  const response = await fetch(
    `https://${aiEndpoint}/predict/waittime`,
    {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${aiToken}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        facility_id: facilityId,
        prediction_hours: 48
      })
    }
  );
  
  return response.json();
}
```

---

## Cost Impact

### Additional Monthly Costs (Phase 7)
- Azure Static Web Apps: $0-20/month (free tier likely sufficient)
- Azure Functions: $50-100/month (consumption plan)
- Application Insights: $20/month (monitoring)
- Custom domain + SSL: $10/month (optional)

**Total Additional**: ~$100-200/month

**Total Platform Cost** (with portal): ~$2,300-2,400/month

---

## Demo Strategy Shift

### Before Portal (Phases 1-6)
**Technical Demo Flow**:
1. Start with architecture slides
2. Show Fabric data pipeline
3. Show Purview governance
4. Show AI Foundry models
5. Show Copilot chatbot
6. End with Power BI dashboards

**Audience**: IT decision-makers, architects, engineers
**Message**: "Look how well these services integrate"

---

### After Portal (Phase 7+)
**Executive Demo Flow**:
1. Start with citizen experience (portal)
2. Show chatbot conversation
3. Show embedded dashboards
4. Then reveal: "Let me show you what's behind this..."
5. Quick glimpse of Azure services
6. End with ROI and transformation story

**Audience**: Deputy Ministers, CIOs, Directors, Policy leaders
**Message**: "Look at this transformational experience for citizens and staff"

---

## Key Differentiators with Portal

### Without Portal (Azure Consoles)
❌ Feels like IT demo, not business transformation
❌ Hard for executives to envision their deployment
❌ Looks unfinished/prototype-y
❌ Can't visualize citizen experience
✅ Shows technical depth
✅ Good for IT audiences

### With Portal (Custom UI)
✅ Executive-friendly, polished experience
✅ Easy to envision with Alberta branding
✅ Shows citizen and staff journeys
✅ Feels like "real product"
✅ Demonstrates transformation, not just technology
✅ Can still show Azure backend for technical audiences

---

## Success Metrics (Portal-Specific)

### User Experience
- [ ] Portal loads in <3 seconds
- [ ] Chatbot responds in <2 seconds
- [ ] Power BI dashboards load in <5 seconds
- [ ] 100% mobile responsive
- [ ] WCAG 2.1 AA compliant

### Demo Effectiveness
- [ ] Executive satisfaction: 4.5+/5
- [ ] "Can you show us again?" requests
- [ ] Follow-up meetings scheduled
- [ ] Budget conversations initiated
- [ ] Executive champions identified

### Technical
- [ ] 99.5% uptime
- [ ] All APIs respond <500ms
- [ ] Zero security vulnerabilities
- [ ] Successful Azure AD SSO

---

## When to Build the Portal

### Recommended Trigger Points

**Build Portal When:**
- ✅ Phases 1-6 complete (technical foundation solid)
- ✅ First executive demo scheduled
- ✅ Customer expresses interest in "seeing the experience"
- ✅ Budget approved to extend project
- ✅ Presenting at conference or large audience

**Don't Build Yet If:**
- ⏸️ Still learning Azure services (Phases 1-4)
- ⏸️ Only demoing to technical audiences
- ⏸️ No executive demos in pipeline
- ⏸️ Time/budget constrained
- ⏸️ Backend services still unstable

**Decision Point**: End of Week 20 (after Phase 6 complete)
- Assess: Do I have executive demos coming up?
- If yes → Proceed to Phase 7 portal build
- If no → Continue refining backend, defer portal

---

## Alternative: Hybrid Approach

If full portal is too much, consider **Phase 7a: Minimal Portal**

### Minimal Viable Portal (2-3 weeks)
```
Simple Landing Page
├── Hero with chatbot widget ✅
├── Embedded Power BI dashboard (1-2 reports) ✅
├── About page with architecture ✅
└── Links to Purview/Fabric for deep dives ⚠️
```

**Pros**: Faster, cheaper, still shows citizen experience
**Cons**: Less polished, limited admin/governance portals
**Cost**: +$50/month
**Effort**: 2-3 weeks

**Decision**: Discuss in Week 20 based on demo pipeline

---

## Conclusion

The custom portal (Phase 7) transforms this from an **impressive technical demo** into a **compelling executive presentation** that visualizes government transformation.

**Recommendation**: 
1. Complete Phases 1-6 with focus and discipline
2. Master the Azure services
3. Deliver technical demos successfully
4. Then add portal polish for executive audiences
5. Portal makes the difference between "interesting" and "transformational"

**Bottom line**: The backend is the substance. The portal is the story. Both matter, but substance must come first.

---

**Created**: January 19, 2026  
**Owner**: Jeremy Crossman (jcrossman@microsoft.com)  
**Status**: Planning - Execute in Phase 7 (Week 21+)  
**Priority**: High for executive demos, deferred until technical foundation solid
