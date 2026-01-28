# Assigning Fabric Capacity to Workspaces

## Quick Steps

### For Each Workspace:

1. **Navigate to Fabric Portal**
   - Go to: https://app.fabric.microsoft.com
   - Sign in with your Microsoft account

2. **Open Workspace Settings**
   - Click on the workspace name in the left sidebar (e.g., "alberta-healthcare")
   - Click the **⚙️ (Settings)** icon in the top right, or
   - Click the **...** menu next to the workspace name → Select **Workspace settings**

3. **Assign Capacity**
   - In the settings panel, look for **"License info"** or **"Premium"** section
   - Click **"Trial"** or **"License mode"** dropdown
   - Select **"Fabric capacity"**
   - Choose **"fabricalbertadev"** from the capacity dropdown
   - Click **"Apply"** or **"Save"**

4. **Verify Assignment**
   - You should see "Fabric capacity: fabricalbertadev" in the workspace settings
   - The workspace badge should show "F2" or capacity indicator

## Alternative Method: Bulk Assignment

If you're a Capacity Administrator:

1. **Go to Admin Portal**
   - Click the **⚙️ (Settings)** icon in top right
   - Select **"Admin portal"**
   - Navigate to **"Capacity settings"**

2. **Manage Capacity**
   - Find **"fabricalbertadev"** in the list
   - Click on it to open capacity settings
   - Go to **"Workspaces"** tab

3. **Assign Workspaces**
   - Click **"Assign workspaces"**
   - Select all 6 alberta workspaces:
     - ☑ alberta-healthcare
     - ☑ alberta-justice
     - ☑ alberta-energy
     - ☑ alberta-agriculture
     - ☑ alberta-pensions
     - ☑ alberta-coordination
   - Click **"Apply"**

## Workspaces Created

| Workspace Name | Workspace ID | Purpose |
|----------------|--------------|---------|
| alberta-healthcare | e18c4eb6-b6b2-4778-98cf-d8af3ad13215 | Healthcare data and analytics |
| alberta-justice | c780cc3b-fe24-4678-a6f2-250afd91de9e | Justice and courts data |
| alberta-energy | 053e2131-7ddc-4b57-89c2-5b0f2a3ec869 | Energy sector data |
| alberta-agriculture | 1d746c8d-d173-4680-9ef3-d382a2136b61 | Agriculture and farming data |
| alberta-pensions | 86dd4de7-85ec-49ab-ad72-ec1bc76ecb55 | Pension and benefits data |
| alberta-coordination | 1013f015-ee04-473d-a868-4dc682f322fe | MCP migration and coordination |

## After Assignment

Once workspaces are assigned to the capacity, you can:

1. **Create Lakehouses**
   - Click workspace → **+ New** → **Lakehouse**
   - Name it: `<workspace-name>-lakehouse` (e.g., "alberta-healthcare-lakehouse")

2. **Create Folder Structure**
   - In the Lakehouse, create folders:
     - `bronze/` - Raw data from sources
     - `silver/` - Cleansed and validated data
     - `gold/` - Analytics-ready, aggregated data

3. **Create Data Pipelines**
   - Click workspace → **+ New** → **Data pipeline**
   - Build pipelines to ingest Alberta Open Data

4. **Create Notebooks**
   - Click workspace → **+ New** → **Notebook**
   - Use for data transformations and analysis

## Troubleshooting

**"You don't have permission to assign capacity"**
- You need to be a Capacity Administrator
- Ask your tenant admin to add you to the capacity admins
- Or use the workspace settings method instead

**"Capacity not showing in dropdown"**
- Make sure the capacity is Active (not Paused)
- Run: `./status-fabric.sh` to check
- If paused, run: `./resume-fabric.sh`
- Refresh the portal page

**"Trial capacity is assigned instead"**
- Trial capacities have limitations
- Make sure you select "Fabric capacity" as the license mode
- Then choose "fabricalbertadev" specifically

## Cost Reminder

⚠️ Your Fabric F2 capacity costs **$1.35/hour** ($988/month) while Active.

**Remember to pause when not using:**
```bash
cd ~/Desktop/FoundryPurview/infrastructure/bicep/fabric
./pause-fabric.sh
```

This saves ~70% if you only use it during work hours!

---

**Created:** January 28, 2026  
**Capacity:** fabricalbertadev (F2, Canada Central)  
**Subscription:** ME-MngEnvMCAP516709-jcrossman-1
