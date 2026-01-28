# Deployment Guide - Alberta Platform

## Infrastructure as Code (Bicep)

This project uses Azure Bicep for reproducible infrastructure deployments.

## Prerequisites

- Azure CLI installed and configured
- Azure subscription with appropriate permissions
- Bicep CLI (included with Azure CLI)

## Quick Deploy ✅ COMPLETED

**Status**: All infrastructure already deployed and verified (Jan 28, 2026)

**Subscription**: ME-MngEnvMCAP516709-jcrossman-1  
**Subscription ID**: dabe0b83-abdb-448f-9ab0-31dfb2ab6b4b

All resources are running. No deployment needed at this time.

For future deployments or updates:
```bash
# Navigate to infrastructure directory
cd infrastructure/bicep

# Deploy to dev environment
./scripts/deploy.sh dev

# Deploy to prod environment (when ready)
./scripts/deploy.sh prod
```

## What Gets Deployed

### Resource Groups (6)
- `rg-alberta-platform-identity-prod` - Key Vault, managed identities, monitoring
- `rg-alberta-platform-ai-dev` - Azure OpenAI, AI Search
- `rg-alberta-platform-data-dev` - Storage accounts, data containers
- `rg-alberta-platform-api-dev` - Azure Functions, function storage
- `rg-alberta-platform-web-dev` - Static Web App
- `rg-alberta-platform-governance-prod` - Purview (manual setup)

### Azure Resources

#### AI Services
- **Azure OpenAI** (`oai-alberta-platform-dev`)
  - Location: East US (GPT-4o not available in Canada Central)
  - Models: GPT-4o (10K TPM), text-embedding-3-small (120K TPM)
  - Endpoint: https://oai-alberta-platform-dev.openai.azure.com/

- **Azure AI Search** (`srch-alberta-platform-dev`)
  - Location: Canada Central (data residency)
  - SKU: Basic
  - Endpoint: https://srch-alberta-platform-dev.search.windows.net

#### Compute
- **Azure Functions** (`func-alberta-platform-api-dev`)
  - Plan: Flex Consumption
  - Runtime: Node.js 20
  - Managed Identity: System-assigned
  - Endpoint: https://func-alberta-platform-api-dev.azurewebsites.net

- **Static Web App** (`swa-alberta-platform-portal-dev`)
  - Location: East US 2 (not available in Canada Central)
  - SKU: Free (dev), Standard (prod)
  - Endpoint: https://wonderful-glacier-06429630f.2.azurestaticapps.net

#### Storage & Data
- **Data Storage** (`stalbertaplatformdatadev`)
  - Containers: data, backup
  - Replication: LRS
  - Location: Canada Central

- **Function Storage** (`stfuncalbertaplatformdev`)
  - For Azure Functions internal use
  - Shared key access enabled (required by Functions)

#### Security & Monitoring
- **Key Vault** (`kv-alberta-platform-dev`)
  - RBAC enabled
  - Soft delete enabled (90 days)
  - Secrets: openai-api-key, aisearch-api-key

- **Log Analytics** (`log-alberta-platform-dev`)
  - Retention: 30 days
  - Location: Canada Central

- **Application Insights** (`appi-alberta-platform-dev`)
  - Connected to Function App and AI services
  - Location: Canada Central

## Deployment Time

- **Validation**: ~10 seconds
- **Deployment**: ~10-15 minutes
- **Total**: ~15 minutes

## Cost Estimates

### Development Environment (Current Deployment)
- Azure OpenAI (S0): ~$150/month
- AI Search (Basic): ~$75/month
- Azure Functions (Flex): ~$5/month (pay-per-use)
- Static Web App (Free): $0/month
- Storage (LRS): ~$5/month
- Key Vault: ~$5/month
- Monitoring: ~$5/month
- **Total: ~$245/month**

### With Microsoft Fabric
- Fabric F2 (auto-pause): +$400/month
- Fabric F64: +$8,671/month
- **Total: $645-$8,916/month**

## Manual Setup Required

After Bicep deployment, these services must be configured manually via Azure Portal:

1. **Microsoft Fabric**
   - No Bicep support (preview extension unstable)
   - See [MANUAL_SETUP_STEPS.md](../MANUAL_SETUP_STEPS.md)

2. **Microsoft Purview**
   - Limited Bicep support
   - See [MANUAL_SETUP_STEPS.md](../MANUAL_SETUP_STEPS.md)

3. **Copilot Studio**
   - Power Platform, not Azure Resource Manager
   - See [MANUAL_SETUP_STEPS.md](../MANUAL_SETUP_STEPS.md)

4. **Function App Key Vault Access**
   ```bash
   az role assignment create \
     --assignee $(az functionapp show --name func-alberta-platform-api-dev \
       --resource-group rg-alberta-platform-api-dev \
       --query identity.principalId -o tsv) \
     --role "Key Vault Secrets User" \
     --scope /subscriptions/<subscription-id>/resourceGroups/rg-alberta-platform-identity-prod/providers/Microsoft.KeyVault/vaults/kv-alberta-platform-dev
   ```

## Deployment Outputs

After successful deployment, you'll see:

```json
{
  "keyVaultUri": "https://kv-alberta-platform-dev.vault.azure.net/",
  "openAiEndpoint": "https://oai-alberta-platform-dev.openai.azure.com/",
  "aiSearchEndpoint": "https://srch-alberta-platform-dev.search.windows.net",
  "functionAppUrl": "https://func-alberta-platform-api-dev.azurewebsites.net",
  "staticWebAppUrl": "https://wonderful-glacier-06429630f.2.azurestaticapps.net"
}
```

## Teardown

To delete all resources:

```bash
cd infrastructure/bicep
./scripts/destroy.sh dev
```

**Warning**: This will delete all data and cannot be undone.

## Customization

### Change Environment
Edit `infrastructure/bicep/parameters/dev.parameters.json`:
```json
{
  "environment": "staging",
  "location": "eastus",
  "ownerEmail": "your-email@example.com"
}
```

### Add New Resource
1. Create module in `infrastructure/bicep/modules/`
2. Add module reference in `main.bicep`
3. Add parameters to `parameters/dev.parameters.json`
4. Test deployment

### Change SKUs
Edit the module files:
- AI Search: `modules/ai.bicep` (line 24)
- Storage: `modules/storage.bicep` (line 19)
- Static Web App: `modules/web.bicep` (line 17)

## Troubleshooting

### "CustomDomainInUse" Error
Soft-deleted Cognitive Services resources block names for 48 hours.

**Solution**:
```bash
az cognitiveservices account purge \
  --name oai-alberta-platform-dev \
  --resource-group rg-alberta-platform-ai-dev \
  --location eastus
```

### "LocationNotAvailableForResourceType"
Some Azure services aren't available in all regions.

**Current workarounds**:
- Azure OpenAI: East US (GPT-4o models)
- Static Web Apps: East US 2
- Microsoft Purview: East US 2

### "RequestConflict" During Deployment
Resource is still provisioning/deprovisioning.

**Solution**: Wait 2-5 minutes and retry deployment.

### Storage Account Shared Key Policy
If Function App fails to deploy due to shared key access policy:

**Solution**: Edit `modules/api.bicep` line 28-30 to explicitly allow shared keys.

## Verification

After deployment:

```bash
# List all resource groups
az group list --tag project=alberta-platform -o table

# List resources in AI resource group
az resource list --resource-group rg-alberta-platform-ai-dev -o table

# Test OpenAI endpoint
curl https://oai-alberta-platform-dev.openai.azure.com/openai/deployments/gpt-4o/chat/completions?api-version=2024-02-15-preview \
  -H "api-key: $(az keyvault secret show --vault-name kv-alberta-platform-dev --name openai-api-key --query value -o tsv)" \
  -H "Content-Type: application/json" \
  -d '{"messages":[{"role":"user","content":"Hello"}]}'
```

## CI/CD Integration

### GitHub Actions (Recommended)

```yaml
name: Deploy Infrastructure

on:
  push:
    branches: [main]
    paths:
      - 'infrastructure/bicep/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      
      - name: Deploy Bicep
        run: |
          cd infrastructure/bicep
          ./scripts/deploy.sh dev
```

### Azure DevOps

```yaml
trigger:
  paths:
    include:
      - infrastructure/bicep/*

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: AzureCLI@2
  inputs:
    azureSubscription: 'Alberta-Platform'
    scriptType: 'bash'
    scriptLocation: 'inlineScript'
    inlineScript: |
      cd infrastructure/bicep
      ./scripts/deploy.sh dev
```

## Best Practices

1. **Always use IaC** - Never create resources manually in Portal
2. **Version control** - Commit all Bicep changes to Git
3. **Test in dev first** - Deploy to dev, validate, then prod
4. **Monitor costs** - Set up budget alerts
5. **Use managed identities** - Avoid storing credentials
6. **Enable soft delete** - Key Vault, Storage for disaster recovery
7. **Tag everything** - Use consistent tagging strategy
8. **Document changes** - Update this file when modifying infrastructure

## Regional Considerations

### Data Residency
- Primary: **Canada Central** (data storage, search)
- Secondary: **Canada East** (backup, DR)

### Service Availability Exceptions
Some services aren't available in Canadian regions:
- **Azure OpenAI GPT-4o**: East US (Canada Central only has older models)
- **Static Web Apps**: East US 2 (not in any Canadian region)
- **Microsoft Purview**: East US 2 (not in any Canadian region)

**Note**: Data storage remains in Canada Central for compliance. Only AI inference and static hosting are in US regions.

## Security Considerations

1. **No public endpoints** - Consider adding VNet integration for prod
2. **Key Vault RBAC** - Use role-based access, not access policies
3. **Managed identities** - Function App uses system-assigned identity
4. **Soft delete enabled** - 90-day retention for deleted secrets
5. **Diagnostic logging** - All resources send logs to Log Analytics

## Support

For deployment issues:
- Check troubleshooting section above
- Review [MANUAL_SETUP_STEPS.md](../MANUAL_SETUP_STEPS.md)
- Check Azure Resource Manager deployment logs in Portal
- Contact: jcrossman@microsoft.com

---

**Last Updated**: January 20, 2026
**Deployment Version**: v1.0.0
**Bicep CLI Version**: 0.25.3
