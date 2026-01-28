#!/bin/bash

echo "════════════════════════════════════════════════════════"
echo "📂 CREATING FABRIC WORKSPACES"
echo "════════════════════════════════════════════════════════"
echo ""

# Fabric capacity details
CAPACITY_NAME="fabricalbertadev"
RESOURCE_GROUP="rg-alberta-platform-data-dev"

# Get capacity ID
echo "Getting Fabric capacity ID..."
CAPACITY_ID=$(az fabric capacity show \
  --name "$CAPACITY_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query id -o tsv 2>/dev/null)

if [ -z "$CAPACITY_ID" ]; then
  echo "❌ ERROR: Could not find Fabric capacity '$CAPACITY_NAME'"
  exit 1
fi

echo "✅ Capacity ID: $CAPACITY_ID"
echo ""

# Get Power BI token for Fabric APIs
echo "Getting authentication token..."
TOKEN=$(az account get-access-token --resource https://analysis.windows.net/powerbi/api --query accessToken -o tsv)

if [ -z "$TOKEN" ]; then
  echo "❌ ERROR: Could not get authentication token"
  exit 1
fi

echo "✅ Token acquired"
echo ""

# Workspaces to create
WORKSPACES=(
  "alberta-healthcare:Healthcare data and analytics"
  "alberta-justice:Justice and courts data"
  "alberta-energy:Energy sector data"
  "alberta-agriculture:Agriculture and farming data"
  "alberta-pensions:Pension and benefits data"
  "alberta-coordination:MCP migration and coordination data"
)

SUCCESS_COUNT=0
FAILED_COUNT=0

# Create each workspace
for workspace_info in "${WORKSPACES[@]}"; do
  IFS=':' read -r name description <<< "$workspace_info"
  
  echo "────────────────────────────────────────────────────────"
  echo "Creating workspace: $name"
  echo "Description: $description"
  echo ""
  
  # Create workspace via Fabric REST API (without capacity - will assign later)
  RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    "https://api.fabric.microsoft.com/v1/workspaces" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"displayName\": \"$name\",
      \"description\": \"$description\"
    }")
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -1)
  BODY=$(echo "$RESPONSE" | sed '$d')
  
  if [ "$HTTP_CODE" -eq 201 ] || [ "$HTTP_CODE" -eq 200 ]; then
    WORKSPACE_ID=$(echo "$BODY" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    echo "✅ Created successfully"
    echo "   Workspace ID: $WORKSPACE_ID"
    ((SUCCESS_COUNT++))
  elif [ "$HTTP_CODE" -eq 409 ]; then
    echo "⚠️  Already exists (skipping)"
    ((SUCCESS_COUNT++))
  else
    echo "❌ Failed (HTTP $HTTP_CODE)"
    echo "   Response: $BODY"
    ((FAILED_COUNT++))
  fi
  echo ""
done

echo "════════════════════════════════════════════════════════"
echo "📊 SUMMARY"
echo "════════════════════════════════════════════════════════"
echo "✅ Successful: $SUCCESS_COUNT"
echo "❌ Failed: $FAILED_COUNT"
echo ""
echo "View workspaces at: https://app.fabric.microsoft.com"
echo "════════════════════════════════════════════════════════"
