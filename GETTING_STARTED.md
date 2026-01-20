# Getting Started - Alberta Open Data Intelligence Platform

## Welcome! 🎉

Congratulations on starting your Azure learning journey! This project will help you master Microsoft Fabric, Purview, AI Foundry, and Copilot Studio while building a compelling demonstration platform for Government of Alberta customers.

## What You've Got

This repository contains everything you need:

### 📚 Documentation (docs/)
1. **[Implementation Plan](docs/implementation-plan.md)** - Your roadmap with weekly tasks
2. **[User Stories](docs/user-stories.md)** - What you're building and why
3. **[Architecture](docs/architecture.md)** - How everything fits together
4. **[Data Governance](docs/data-governance.md)** - Framework for managing data
5. **[Success Metrics](docs/success-metrics.md)** - How to measure progress
6. **[Risk Assessment](docs/risk-assessment.md)** - Potential issues and solutions
7. **[Technical Requirements](docs/technical-requirements.md)** - What you need to build this

### 📁 Project Structure
```
FoundryPurview/
├── README.md                  ← You are here
├── GETTING_STARTED.md         ← This file
├── docs/                      ← All documentation
├── data/                      ← Data sources and schemas
├── fabric/                    ← Microsoft Fabric artifacts
├── purview/                   ← Purview configurations
├── ai-foundry/                ← AI models and agents
├── copilot-studio/            ← Chatbot configurations
├── infrastructure/            ← Infrastructure as Code
├── demos/                     ← Demo scripts and assets
└── scripts/                   ← Automation scripts
```

## Your First Week

### Day 1: Orientation
- [x] Read this file
- [ ] Read the [Implementation Plan](docs/implementation-plan.md) overview
- [ ] Skim the [User Stories](docs/user-stories.md) to understand what you're building
- [ ] Review your Azure subscription and budget

### Day 2: Azure Setup ✅ COMPLETED
- [x] Create or identify your Azure subscription
- [x] Set up cost alerts ($1,800/month warning, $2,000/month critical)
- [x] Create resource groups using IaC:
  - `rg-alberta-platform-identity-prod`
  - `rg-alberta-platform-ai-dev`
  - `rg-alberta-platform-data-dev`
  - `rg-alberta-platform-api-dev`
  - `rg-alberta-platform-web-dev`
  - `rg-alberta-platform-governance-prod`
- [x] Set up Azure CLI on your machine
- [x] Install VS Code with Azure extensions

### Day 3: Deploy Infrastructure ✅ COMPLETED
- [x] Deploy core Azure resources using Bicep IaC
- [x] Azure OpenAI (GPT-4o, embeddings) deployed to East US
- [x] Azure AI Search deployed to Canada Central
- [x] Azure Functions with Flex Consumption plan
- [x] Static Web App for React portal
- [x] Key Vault with API secrets stored
- [x] Storage accounts with containers
- [x] Monitoring (Log Analytics, App Insights)

### Day 4: Manual Service Setup
- [ ] Enable Microsoft Fabric capacity (F2 or F64) - See [MANUAL_SETUP_STEPS.md](MANUAL_SETUP_STEPS.md)
- [ ] Configure Microsoft Purview scanning
- [ ] Set up Copilot Studio environment
- [ ] Grant Function App Key Vault access (see manual steps)
- [ ] Verify all endpoints are working

### Day 5: Data Exploration
- [ ] Browse [Alberta Open Data Portal](https://open.alberta.ca/)
- [ ] Identify 3-5 datasets to use:
  - Healthcare (e.g., Emergency Department wait times)
  - Environmental (e.g., Air quality monitoring)
  - At least one other domain
- [ ] Document datasets in `data/sources/README.md`
- [ ] Test API access (get sample data)

### Week 2: Learning & Planning
- [ ] Complete Microsoft Fabric fundamentals module
- [ ] Set up Git repository (if not done)
- [ ] Create project tracking board (GitHub Projects, Azure Boards, or Trello)
- [ ] Plan your Week 2 tasks from implementation plan

## Quick Reference

### Essential Links
- **Alberta Open Data**: https://open.alberta.ca/
- **Microsoft Fabric Docs**: https://learn.microsoft.com/fabric/
- **Microsoft Purview Docs**: https://learn.microsoft.com/purview/
- **Azure AI Foundry Docs**: https://learn.microsoft.com/azure/ai-foundry/
- **Copilot Studio Docs**: https://learn.microsoft.com/copilot-studio/

### Your Contact Info
- **Email**: jcrossman@microsoft.com
- **Project Timeline**: 20 weeks (5 months)
- **Budget**: $800/month (dev), $2,200/month (demo)

## How to Use This Project

### Following the Plan
The [Implementation Plan](docs/implementation-plan.md) has 7 phases:
- **Phase 0** (Weeks 1-2): Foundation & Setup ← START HERE
- **Phase 1** (Weeks 3-5): Data Foundation with Fabric
- **Phase 2** (Weeks 6-8): Data Governance with Purview
- **Phase 3** (Weeks 9-12): AI Agents with AI Foundry
- **Phase 4** (Weeks 13-15): Citizen Services with Copilot
- **Phase 5** (Weeks 16-17): Integration & End-to-End
- **Phase 6** (Weeks 18-20): Demo Prep & Documentation
- **Phase 7** (Weeks 21+): Advanced Features (optional)

Each phase has detailed tasks with checkboxes - check them off as you complete!

### Understanding User Stories
The [User Stories](docs/user-stories.md) describe what you're building from the perspective of different users:
- **Sarah**: Healthcare Administrator who needs predictive insights
- **Marcus**: Environmental Analyst who monitors air/water quality
- **David**: Chief Data Officer who needs governance
- **Jennifer**: Security Officer who ensures compliance
- **Alex**: Citizen who wants quick access to services

Build features to solve their problems!

### Using the Architecture
The [Architecture](docs/architecture.md) shows how all the pieces fit together. Reference this when:
- Designing data flows
- Planning integrations
- Explaining the solution to customers
- Troubleshooting issues

### Measuring Success
The [Success Metrics](docs/success-metrics.md) help you track progress:
- **Learning**: Am I mastering the technologies?
- **Technical**: Is the platform performing well?
- **Business**: Would this deliver value to Alberta?
- **Demo**: Can I present this confidently?

Review metrics weekly to stay on track.

### Managing Risks
The [Risk Assessment](docs/risk-assessment.md) identifies things that could go wrong:
- APIs changing or going offline
- Costs exceeding budget
- Technical challenges
- Demo failures

Have mitigation strategies ready!

## Working Mode Recommendations

### Full-Time Focus (20+ hours/week)
If you can dedicate full-time effort:
- Follow the 20-week plan as written
- Complete one phase every 2-3 weeks
- Should finish in 5 months
- Will have polished, demo-ready platform

### Part-Time Focus (10-15 hours/week)
If you're balancing this with other work:
- Double the timeline (40 weeks / 10 months)
- Focus on MVP features (Phases 0-4)
- Skip advanced features unless needed
- Will have working demo in 6-7 months

### Weekend Warrior (5-10 hours/week)
If you can only work weekends:
- Triple the timeline (60 weeks / 14 months)
- Focus on one amazing use case (e.g., chatbot OR healthcare)
- Accept that not everything will be built
- Will have focused demo in 9-12 months

**Recommendation**: Start with 10-15 hours/week and adjust based on progress.

## Tips for Success

### 🎯 Stay Focused
- Don't try to build everything at once
- Master one service before adding complexity
- It's okay to skip optional features
- MVP first, polish later

### 📖 Learn as You Go
- Read Microsoft Docs when stuck
- Watch YouTube tutorials
- Ask questions in forums
- Don't be afraid to experiment

### 💰 Watch Your Budget
- Set up cost alerts (critical!)
- Review Azure costs weekly
- Auto-pause Fabric capacity overnight
- Delete resources you're not using

### 🎪 Demo Early and Often
- Practice demos starting Week 10
- Show colleagues for feedback
- Record yourself presenting
- Iterate on your storytelling

### 🤝 Get Help When Stuck
- Microsoft Tech Community forums
- Stack Overflow
- Microsoft support (if available)
- Colleagues or mentors

### 📝 Document as You Go
- Take screenshots of working features
- Note issues and how you solved them
- Keep a learning journal
- Will help with demos and future reference

## Common Pitfalls to Avoid

❌ **Don't**: Try to make it perfect  
✅ **Do**: Make it working, then make it better

❌ **Don't**: Skip data governance (boring but critical)  
✅ **Do**: Build Purview governance from the start

❌ **Don't**: Wait until Week 18 to practice demos  
✅ **Do**: Start demoing at Week 10, iterate continuously

❌ **Don't**: Hardcode credentials in code  
✅ **Do**: Use Key Vault and managed identities

❌ **Don't**: Build on bleeding-edge preview features  
✅ **Do**: Use generally available (GA) features for stability

❌ **Don't**: Ignore costs until you get the bill  
✅ **Do**: Check costs daily at first, weekly once stable

## Customization Ideas

This project template is opinionated but flexible. Feel free to:

### Swap Data Domains
- Instead of Healthcare: Use Transportation or Justice
- Instead of Environmental: Use Energy or Agriculture
- Keep what resonates with your customers!

### Adjust Use Cases
- Focus on 1-2 amazing use cases vs. 4 mediocre ones
- Go deep on chatbot OR predictive analytics
- Choose based on customer priorities

### Change Tech Stack
- Use Terraform instead of Bicep (if you prefer)
- Add Power Apps for UI (beyond Copilot)
- Integrate with other Azure services

### Expand Scope (Later)
- Add real-time streaming with Event Hubs
- Build mobile app with Power Apps
- Create GraphQL API layer
- Add voice interface with Azure Speech

## When Things Go Wrong

### "I'm Stuck on a Technical Problem"
1. Check Microsoft Docs first
2. Search Stack Overflow / Microsoft Tech Community
3. Ask AI assistant (GitHub Copilot, ChatGPT)
4. Post question with context in forums
5. Reach out to Microsoft support
6. Don't spend more than 4 hours stuck - ask for help!

### "I'm Behind Schedule"
1. Review what you've accomplished (celebrate!)
2. Identify what's taking longer than expected
3. Decide: simplify or extend timeline
4. Focus on MVP features
5. Skip nice-to-haves if needed
6. Remember: Learning is the main goal!

### "Costs Are Too High"
1. Check which services are expensive (Cost Management)
2. Delete unused resources
3. Auto-pause Fabric capacity
4. Use cheaper SKUs in dev
5. Consider pausing project if needed
6. Budget is a constraint, not a failure

### "Demo Didn't Go Well"
1. Ask for specific feedback
2. Don't take it personally
3. Iterate on content and delivery
4. Practice more
5. Try different use case
6. Every demo makes you better!

### "I'm Not Learning Fast Enough"
1. Everyone learns at different speeds
2. Focus on understanding, not memorizing
3. Take breaks when frustrated
4. Teach someone else (best way to learn)
5. Celebrate small wins
6. Progress > perfection

## Milestone Celebrations 🎉

When you hit these milestones, take a moment to celebrate:

- [ ] **Week 2**: Azure environment fully set up
- [ ] **Week 5**: First Power BI dashboard published
- [ ] **Week 8**: Data fully cataloged in Purview
- [ ] **Week 12**: First AI model deployed
- [ ] **Week 15**: Chatbot responding to queries
- [ ] **Week 17**: End-to-end demo working
- [ ] **Week 20**: First customer demo delivered
- [ ] **Stretch**: Second customer demo, positive feedback!

## Support & Community

### Where to Ask Questions
- **Microsoft Tech Community**: https://techcommunity.microsoft.com/
- **Stack Overflow**: Use tags `azure`, `microsoft-fabric`, `purview`
- **Reddit**: r/azure, r/PowerBI, r/MachineLearning

### Share Your Progress
- Blog about your learning journey
- Tweet with #MicrosoftFabric #AzureAI
- Present at local user groups
- Contribute back to open source

## Next Steps

1. ✅ You've read this guide
2. ➡️ Open [Implementation Plan](docs/implementation-plan.md)
3. ➡️ Start Phase 0, Week 1 tasks
4. ➡️ Set up project tracking
5. ➡️ Begin building!

## Questions?

If you have questions or need help:
- **Email**: jcrossman@microsoft.com
- **Review docs**: Start with Implementation Plan
- **Community**: Microsoft Tech Community forums

---

**You've got this! 🚀**

Remember: The goal isn't perfection, it's learning and building something valuable for Alberta government customers. Start small, iterate often, and enjoy the journey.

Good luck!

---

## Infrastructure Deployment Summary

**Status**: Core infrastructure deployed via Bicep IaC (January 20, 2026)

### Deployed Resources
```
✅ 6 Resource Groups (identity, ai, data, api, web, governance)
✅ Azure OpenAI with GPT-4o & embeddings (East US)
✅ Azure AI Search (Canada Central)
✅ Azure Functions (Flex Consumption)
✅ Static Web App (East US 2)
✅ Key Vault with secrets
✅ Storage Accounts (data + functions)
✅ Log Analytics & App Insights
```

### Deployment Commands
```bash
# Deploy infrastructure
cd infrastructure/bicep
./scripts/deploy.sh dev

# Destroy infrastructure (if needed)
./scripts/destroy.sh dev

# View deployment outputs
az deployment sub show --name alberta-platform-dev-<timestamp> \
  --query properties.outputs -o json
```

### Key Endpoints
- **OpenAI**: https://oai-alberta-platform-dev.openai.azure.com/
- **AI Search**: https://srch-alberta-platform-dev.search.windows.net
- **Function App**: https://func-alberta-platform-api-dev.azurewebsites.net
- **Static Web**: https://wonderful-glacier-06429630f.2.azurestaticapps.net
- **Key Vault**: https://kv-alberta-platform-dev.vault.azure.net/

### Regional Placement
- **Canada Central**: Data storage, AI Search
- **East US**: Azure OpenAI (GPT-4o not available in Canada)
- **East US 2**: Static Web App, Purview

*Last Updated: January 20, 2026*
