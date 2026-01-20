# Demo Delivery Guide - Alberta Open Data Intelligence Platform

## Overview

This guide explains **how** to physically deliver demos to Government of Alberta customers, including setup, delivery methods, and best practices.

---

## Demo Delivery Methods

### Method 1: Live Screen Share (Recommended)

**Best For**: Most demos, especially first meetings

**Setup:**
- Join customer meeting via Teams/Zoom
- Share your entire screen
- Navigate through Azure services live
- Customer watches, asks questions

**Advantages:**
- Most authentic and impressive
- Can adapt to customer questions
- Shows real integration
- Builds credibility

**Risks:**
- Technical failures
- Slow performance
- Internet issues

**Mitigation:**
- Run pre-demo checklist 2 hours before
- Have backup videos ready
- Test internet connection

---

### Method 2: Hybrid Live + Video

**Best For**: High-stakes demos, executives

**Setup:**
- Primary: Live demo
- Backup: Pre-recorded 2-3 min videos for each use case
- Seamlessly switch if issues arise

**When to Use Backup Video:**
- API is slow or down
- Service outage
- Unexpected error
- Poor internet connection

**Script:**
> "Let me show you a video of this in action while we discuss the architecture and ROI..."

---

### Method 3: Customer Self-Service Access

**Best For**: Technical audiences, extended evaluations

**Setup:**
- Provide guest access to your environment
- Read-only permissions
- Guided tour with them clicking

**Access Levels:**
```
Power BI: Share dashboard link (view-only)
Purview: Azure AD guest with Data Reader role
Chatbot: Deploy to shared Teams channel
Demo Tenant: Create separate demo AAD tenant
```

**Advantages:**
- Highly interactive
- Customers get hands-on experience
- Can explore at their own pace

**Risks:**
- Security/access management
- Customers might get confused
- Need to monitor usage

---

### Method 4: Pre-Recorded Demo Video

**Best For**: Asynchronous sharing, large audiences

**Setup:**
- Record 5-15 minute demo video
- Post to YouTube (unlisted) or Stream
- Send link with supporting materials

**Use Cases:**
- Initial outreach
- Follow-up after meeting
- Conference presentations
- Training materials

---

## Demo Environment Architecture

### What You'll Show Customers

#### Browser-Based Demos (Screen Share)

**Power BI Dashboard:**
```
URL: https://app.powerbi.com
Navigate to: Workspace > Alberta Platform > Healthcare Dashboard
Show: Live dashboard with filters, drill-down
```

**Microsoft Purview Catalog:**
```
URL: https://web.purview.azure.com
Navigate to: Data Catalog > Search "wait times"
Show: Data asset, lineage diagram, classification
```

**Azure Portal:**
```
URL: https://portal.azure.com
Navigate to: Fabric workspace, AI Foundry project
Show: Pipelines running, AI models deployed
```

**Copilot Chatbot:**

*Option A: Teams Integration*
```
Open: Microsoft Teams
Navigate to: Alberta Demo channel
Show: Conversation with chatbot
```

*Option B: Web Chat Widget*
```
URL: https://your-custom-domain.com/chatbot
Show: Web interface for chatbot
```

*Option C: Copilot Studio Test Canvas*
```
URL: https://copilotstudio.microsoft.com
Open: Test bot panel
Show: Conversation flow
```

**AI Agent API (Optional - Technical Audience):**
```
Tool: Postman or Thunder Client in VS Code
Show: POST request to prediction API
Show: JSON response with prediction
```

---

## Pre-Demo Setup Checklist

### 2 Hours Before Demo

**Environment Health Check:**
- [ ] Log into Azure Portal - verify access
- [ ] Check Fabric capacity is running (not paused)
- [ ] Verify AI endpoints respond (test API call)
- [ ] Confirm Purview catalog is accessible
- [ ] Test chatbot responds correctly

**Data Freshness:**
- [ ] Verify Power BI datasets refreshed today
- [ ] Check data pipeline last run was successful
- [ ] Confirm no quality issues flagged

**Performance Warm-Up:**
- [ ] Open Power BI dashboard (cache/load it)
- [ ] Run test chatbot query (wake up AI models)
- [ ] Load Purview lineage diagram (can be slow first time)

**Technical Setup:**
- [ ] Close unnecessary browser tabs/apps
- [ ] Clear browser cache
- [ ] Disable notifications (Do Not Disturb)
- [ ] Test screen sharing in Teams/Zoom
- [ ] Have backup videos ready
- [ ] Print or open demo script on second monitor

**Communication:**
- [ ] Join meeting 5 minutes early
- [ ] Test audio/video
- [ ] Confirm customer can see screen share
- [ ] Have customer contact info if connection drops

---

## Demo Flow Examples

### 15-Minute Executive Demo

**Objective**: Show business value, not technical details

**Delivery**: 80% slides + videos, 20% live demo

**Flow:**

**Slides (3 min):**
- Alberta government priorities (1 slide)
- Business challenges (1 slide)
- Our solution approach (1 slide)

**Live Chatbot Demo (5 min):**
- Open chatbot in Teams or web
- Type: "What are the current hospital wait times in Edmonton?"
- Chatbot responds with data + chart
- Type: "Which hospital has the shortest wait?"
- Chatbot provides recommendation
- Explain: "This is available 24/7, in English and French"

**Power BI Dashboard (4 min):**
- Open healthcare dashboard
- Show: Current wait times by facility (map view)
- Click into: Trend over time
- Show: AI predictions for next 48 hours
- Explain: "This helps administrators allocate resources proactively"

**Governance Quick Show (2 min):**
- Switch to Purview
- Search: "wait times"
- Click dataset, show lineage diagram
- Explain: "We know exactly where data comes from, ensuring trust and compliance"

**Wrap-Up Slides (1 min):**
- ROI summary
- Next steps

---

### 30-Minute Technical Deep Dive

**Objective**: Show how it works, architecture, integrations

**Delivery**: 60% live demo, 40% discussion

**Flow:**

**Architecture Overview (5 min):**
- Show architecture diagram
- Explain: Data flows from Alberta Open Data → Fabric → Purview governance → AI Foundry → Copilot
- Highlight: Canadian data residency

**Data Platform Demo (10 min):**

*Fabric:*
- Navigate to Fabric workspace
- Show: Data pipeline (click into pipeline view)
- Show: OneLake structure (Bronze/Silver/Gold layers)
- Open: Notebook with transformation code
- Explain: "This runs daily, automatically cataloged in Purview"

*Power BI:*
- Open: Dashboard
- Explain: "This reads from Gold layer, has row-level security"
- Show: How to drill through to details

**Governance Demo (8 min):**

*Purview:*
- Search catalog: "healthcare"
- Open: Wait times dataset
- Show: Business glossary terms linked
- Show: Data classification (Protected B label)
- Show: Data lineage (click through from source to dashboard)
- Show: Data quality score
- Explain: "All AI agents also governed - we track what data they access"

**AI Agent Demo (5 min):**

*AI Foundry:*
- Show: AI project
- Show: Deployed models (wait time predictor, chatbot RAG)
- Show: Responsible AI dashboard
- Call API: Via Postman, show request/response

*Copilot Studio:*
- Show: Conversation design canvas
- Show: How chatbot routes to AI Foundry
- Show: Analytics (conversation volume, satisfaction)

**Q&A (2 min)**

---

### 60-Minute Hands-On Workshop

**Objective**: Let customer explore, understand deeply

**Delivery**: 40% you demo, 60% customer explores

**Flow:**

**Setup (5 min):**
- Send customer guest access links before meeting
- Verify they can log in
- Explain what they'll do

**Guided Tour (15 min):**
- You walk through architecture
- Show each service briefly
- Explain what they'll explore

**Hands-On Exploration (30 min):**

*Purview (10 min):*
- Customer searches catalog
- Finds dataset
- Explores lineage
- Reviews quality metrics
- You answer questions as they explore

*Chatbot (10 min):*
- Customer asks questions via chatbot
- Tries different queries
- You explain how it works behind scenes

*Power BI (10 min):*
- Customer explores dashboard
- Applies filters
- Drills into details
- You show how to build similar reports

**Discussion & Next Steps (10 min)**

---

## Demo Storytelling Framework

### Start with the Problem

**Bad:**
> "Let me show you Microsoft Fabric..."

**Good:**
> "Hospital administrators tell us their biggest challenge is unpredictable ER demand. They never know when to staff up. Let me show you how we solve that..."

### Show the User Experience First

**Order:**
1. ✅ Start with chatbot (citizen experience)
2. ✅ Show dashboard (administrator experience)
3. ✅ Then reveal the technology behind it

**Not:**
1. ❌ Start with Fabric architecture
2. ❌ Show data pipelines
3. ❌ Eventually get to business value

### Use Real Scenarios

**Examples:**

*Healthcare:*
> "It's 2am Sunday. A parent's child has a high fever. They want to know: should we go to the ER now or wait until morning? Let me show them..."

*Environmental:*
> "An environmental officer gets an alert: water quality sensors detected unusual readings. They need to know: Is this a real contamination event? Where is it? What's the source? Let me show how we help..."

*Citizen Services:*
> "A newcomer to Alberta wants to apply for a health card. They don't know the process. It's 8pm, offices are closed. Let me show how our chatbot helps..."

### Connect to Alberta Priorities

Always tie back to:
- Enterprise Data Analytics Strategic Plan
- AI Data Centre Strategy
- Digital service delivery modernization
- Data sovereignty and compliance
- Cross-sector collaboration

---

## Technical Delivery Tips

### Screen Sharing Best Practices

**Do:**
- Share entire screen (not just browser - easier to switch apps)
- Use 1920x1080 resolution (most compatible)
- Zoom browser to 125-150% for readability
- Close unnecessary tabs beforehand
- Use "Share computer sound" if showing videos

**Don't:**
- Share just one application (hard to switch)
- Use 4K resolution (customers can't read small text)
- Have personal/confidential info visible
- Keep notifications on

### Browser Setup

**Recommended Tabs (Open Before Demo):**
```
Tab 1: Power BI Dashboard
Tab 2: Purview Catalog
Tab 3: Azure Portal (Fabric workspace)
Tab 4: AI Foundry Project
Tab 5: Copilot Studio
Tab 6: Chatbot (Teams or web)
Tab 7: Architecture diagram (for reference)
```

**Browser Settings:**
- Clear cache before demo
- Disable auto-play videos
- Disable notifications
- Use Incognito/Private mode to avoid personal bookmarks showing

### Backup Plan

**If Live Demo Fails:**

1. **Don't panic** - stay calm and professional
2. **Acknowledge gracefully**: "Let me show you a video of this while we discuss the architecture"
3. **Switch to backup video** (2-3 min recorded demo)
4. **Continue value discussion** while video plays
5. **Move to different use case** if that one is broken
6. **Pivot to architecture discussion** if everything is down

**Script:**
> "I see we're experiencing some latency. Let me show you a video of this working, and we can discuss how this would integrate with your environment..."

---

## Post-Demo Follow-Up

### Immediately After (Same Day)

**Send:**
- Thank you email
- Link to demo video (if recorded)
- Architecture diagram
- One-page summary document
- FAQ document
- Suggested next steps

**Template Email:**
```
Subject: Alberta Data Platform Demo - Next Steps

Hi [Name],

Thank you for your time today. As discussed, here are some resources:

📹 Demo Recording: [link]
📊 Architecture Overview: [link]
📄 ROI Summary: [PDF]
❓ FAQ: [link]

Based on our conversation, suggested next steps:
1. [Specific to their needs]
2. [Specific to their needs]
3. Schedule follow-up in 2 weeks

Questions? Reply to this email or call me at [phone].

Best regards,
Jeremy
```

---

## Demo Environment Management

### Multi-Demo Setup

**Option 1: Single Shared Environment**
- All demos use same environment
- Reset data between demos
- Risk: One customer's actions affect another

**Option 2: Multiple Environments**
- Dev: Your development work
- Demo: Customer demos (reset weekly)
- Prod: Advanced customers with access

**Recommended:**
- Use single demo environment
- Snapshot/backup before major demos
- Reset to known good state weekly

### Demo Reset Procedure

**Weekly (Every Monday):**
- [ ] Refresh all Power BI datasets
- [ ] Clear chatbot conversation history (in Copilot Studio analytics)
- [ ] Verify all pipelines ran successfully
- [ ] Check data quality scores are good
- [ ] Test all critical paths
- [ ] Update any stale data

**Before High-Stakes Demo:**
- [ ] Full environment validation
- [ ] Fresh data refresh
- [ ] Backup current state
- [ ] Test run entire demo flow

---

## Equipment & Tools Needed

### Hardware

**Minimum:**
- Laptop with 16GB RAM, stable internet
- Headset with microphone (better than laptop mic)
- Webcam (built-in is fine)

**Recommended:**
- 2 monitors (demo on one, notes on other)
- External webcam (better quality)
- Hardwired ethernet (vs. WiFi for stability)
- Backup laptop/tablet (if primary fails)

### Software

**Required:**
- Modern browser (Edge/Chrome)
- Teams or Zoom
- Azure Portal access
- Power BI Desktop (for building, not demos)

**Optional:**
- OBS Studio (screen recording)
- Postman (API testing)
- PowerPoint (slides)
- Snagit (screenshots)
- Timer app (keep track of time)

---

## Common Demo Questions (Be Prepared)

### Technical

**Q: "How much does this cost?"**
A: "For a provincial deployment, estimated $50-100K/year for platform, but ROI is 5-10x based on time savings and better decisions. I can provide a detailed cost breakdown."

**Q: "How long to implement?"**
A: "MVP in 3-6 months. This demo environment took 20 weeks part-time. Full production deployment: 6-12 months depending on data sources and use cases."

**Q: "Is our data secure? Where is it stored?"**
A: "Yes. All data stored in Canadian Azure regions (Toronto/Quebec). Encrypted at rest and in transit. Meets Protected B requirements. Full audit logging."

**Q: "Can this integrate with our existing systems?"**
A: "Yes. Fabric can ingest from virtually any data source - databases, APIs, files, SaaS apps. We'd assess your specific systems, but typically no issues."

**Q: "What about data governance?"**
A: "That's the key differentiator - Purview provides automated cataloging, lineage, quality monitoring, and access control. Everything is governed from day one."

### Business

**Q: "Has anyone else done this in government?"**
A: "Yes, City of Kelowna uses similar tech for 311 services. Federal government has AI strategy. This is aligned with Alberta's Enterprise Data Analytics plan."

**Q: "What's the ROI?"**
A: "Based on typical government use, 90% faster data discovery, 50% reduction in call center volume, better decision-making. Payback typically 12-18 months."

**Q: "Can citizens access this?"**
A: "Yes, the chatbot can be public-facing for common questions, 24/7 in English and French. Backend analytics are for government staff only."

**Q: "What about AI accuracy and bias?"**
A: "We use Responsible AI framework - bias detection, explainability, human oversight for critical decisions. Model performance monitored continuously."

---

## Success Metrics for Demos

### During Demo

**Good signs:**
- ✅ Customer asks detailed questions
- ✅ Takes notes or screenshots
- ✅ Asks "How would this work with our data?"
- ✅ Wants to schedule follow-up
- ✅ Invites more stakeholders

**Warning signs:**
- ⚠️ Checking phone/email
- ⚠️ No questions
- ⚠️ Says "interesting" but vague
- ⚠️ Focused on cost only
- ⚠️ Compares to cheap alternative

### Post-Demo

**Success Criteria:**
- [ ] Follow-up meeting scheduled
- [ ] Customer shares with colleagues
- [ ] Specific use case identified
- [ ] Budget/timeline discussion
- [ ] Introduction to decision-maker

**Pipeline Stages:**
1. **Initial Demo** - Awareness
2. **Deep Dive** - Interest
3. **POC/Pilot Discussion** - Consideration
4. **Proposal** - Intent
5. **Deployment** - Purchase

---

## Demo Recording (For Backup Videos)

### Recording Setup

**Tool**: OBS Studio (free)

**Settings:**
- Resolution: 1920x1080
- Frame rate: 30fps
- Audio: Microphone + system audio
- Output: MP4 (H.264 codec)

**Recording Checklist:**
- [ ] Close unnecessary apps
- [ ] Clear browser history (clean demo)
- [ ] Disable notifications
- [ ] Script written out
- [ ] Practice run
- [ ] Record in quiet environment
- [ ] Good lighting on face (if showing)

**Post-Production:**
- Trim intro/outro
- Add captions (for accessibility)
- Add your contact info at end
- Upload to YouTube (unlisted) or Stream
- Test video plays on different devices

---

## Conclusion

Demos are a **conversation**, not a presentation. 

**Remember:**
- Focus on customer's problems, not your technology
- Tell stories, not feature lists
- Adapt to audience (executive vs. technical)
- Always have backup plan
- Follow up promptly
- Iterate and improve

**Most Important:**
Practice, practice, practice. The technology is great, but your delivery makes or breaks the demo!

---

**Document Owner**: Jeremy Crossman (jcrossman@microsoft.com)  
**Last Updated**: January 19, 2026  
**Version**: 1.0
