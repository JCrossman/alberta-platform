#!/bin/bash
# deploy.sh - Deploy Alberta Platform Infrastructure
# Usage: ./deploy.sh [environment]
# Example: ./deploy.sh dev

set -e

ENVIRONMENT=${1:-dev}
LOCATION="canadacentral"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEPLOYMENT_NAME="alberta-platform-${ENVIRONMENT}-$(date +%Y%m%d-%H%M%S)"

echo "================================================"
echo "🚀 Alberta Platform Infrastructure Deployment"
echo "================================================"
echo ""
echo "Environment:  ${ENVIRONMENT}"
echo "Location:     ${LOCATION}"
echo "Deployment:   ${DEPLOYMENT_NAME}"
echo ""

# Check if parameter file exists
PARAM_FILE="${SCRIPT_DIR}/parameters/${ENVIRONMENT}.parameters.json"
if [ ! -f "$PARAM_FILE" ]; then
  echo "❌ Parameter file not found: $PARAM_FILE"
  echo "   Available environments:"
  ls -1 "${SCRIPT_DIR}/parameters/"*.json 2>/dev/null | xargs -n1 basename | sed 's/.parameters.json//' | sed 's/^/   - /'
  exit 1
fi

echo "📋 Step 1: Validating Bicep template..."
az deployment sub validate \
  --location $LOCATION \
  --template-file "${SCRIPT_DIR}/main.bicep" \
  --parameters "@${PARAM_FILE}" \
  --output none

if [ $? -eq 0 ]; then
  echo "✅ Validation passed"
else
  echo "❌ Validation failed"
  exit 1
fi

echo ""
echo "🏗️  Step 2: Deploying infrastructure..."
echo "   This will take 10-15 minutes..."
echo ""

az deployment sub create \
  --name $DEPLOYMENT_NAME \
  --location $LOCATION \
  --template-file "${SCRIPT_DIR}/main.bicep" \
  --parameters "@${PARAM_FILE}"

if [ $? -eq 0 ]; then
  echo ""
  echo "================================================"
  echo "✅ DEPLOYMENT SUCCESSFUL"
  echo "================================================"
  echo ""
  echo "📤 Deployment Outputs:"
  az deployment sub show \
    --name $DEPLOYMENT_NAME \
    --query properties.outputs \
    --output json
  echo ""
  echo "================================================"
  echo "📋 NEXT STEPS:"
  echo "================================================"
  echo ""
  echo "1. Manual Setup Required (no Bicep support):"
  echo "   → Microsoft Fabric: https://portal.azure.com"
  echo "   → Microsoft Purview: https://portal.azure.com"
  echo "   → Copilot Studio: https://copilotstudio.microsoft.com"
  echo ""
  echo "2. See MANUAL_SETUP_STEPS.md for detailed instructions"
  echo ""
  echo "3. Store OpenAI key:"
  echo "   az keyvault secret show --vault-name kv-alberta-platform-${ENVIRONMENT} --name openai-api-key"
  echo ""
  echo "================================================"
else
  echo ""
  echo "❌ DEPLOYMENT FAILED"
  echo ""
  echo "Check the error messages above for details."
  exit 1
fi
