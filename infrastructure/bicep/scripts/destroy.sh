#!/bin/bash
# destroy.sh - Tear down Alberta Platform Infrastructure
# Usage: ./destroy.sh [environment]
# Example: ./destroy.sh dev

set -e

ENVIRONMENT=${1:-dev}
PROJECT="alberta-platform"

echo "================================================"
echo "⚠️  DESTROY Alberta Platform Infrastructure"
echo "================================================"
echo ""
echo "Environment: ${ENVIRONMENT}"
echo ""
echo "This will DELETE the following resource groups:"
echo "  • rg-${PROJECT}-identity-prod"
echo "  • rg-${PROJECT}-data-${ENVIRONMENT}"
echo "  • rg-${PROJECT}-ai-${ENVIRONMENT}"
echo "  • rg-${PROJECT}-governance-prod"
echo "  • rg-${PROJECT}-api-${ENVIRONMENT}"
echo "  • rg-${PROJECT}-web-${ENVIRONMENT}"
echo ""
read -p "Are you ABSOLUTELY sure? Type 'DELETE' to confirm: " CONFIRM

if [ "$CONFIRM" != "DELETE" ]; then
  echo "Aborted."
  exit 0
fi

echo ""
echo "🗑️  Deleting resource groups (async)..."
echo ""

# List of resource groups to delete
RGS=(
  "rg-${PROJECT}-identity-prod"
  "rg-${PROJECT}-data-${ENVIRONMENT}"
  "rg-${PROJECT}-ai-${ENVIRONMENT}"
  "rg-${PROJECT}-governance-prod"
  "rg-${PROJECT}-api-${ENVIRONMENT}"
  "rg-${PROJECT}-web-${ENVIRONMENT}"
)

for RG in "${RGS[@]}"; do
  echo "   Deleting: $RG"
  az group delete --name "$RG" --yes --no-wait 2>/dev/null || echo "   (not found or already deleting)"
done

echo ""
echo "✅ Deletion initiated (running in background)"
echo ""
echo "Monitor progress:"
echo "   az group list --query \"[?starts_with(name, 'rg-${PROJECT}')].{name:name, state:properties.provisioningState}\" -o table"
echo ""
echo "This will take 5-10 minutes to complete."
echo ""
