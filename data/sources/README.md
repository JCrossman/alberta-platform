# Alberta Open Data Sources

## Overview
This document catalogs the Alberta Open Data sources used in the Alberta Open Data Intelligence Platform.

**Last Updated**: January 19, 2026  
**Owner**: Jeremy Crossman (jcrossman@microsoft.com)

---

## Use Case 1: Healthcare

### Emergency Department Wait Times
- **URL**: [To be added after research]
- **Description**: Real-time and historical emergency department wait times
- **Update Frequency**: [e.g., Hourly, Daily]
- **Format**: [e.g., JSON API, CSV download]
- **API Available**: [Yes/No]
- **Fields**: [Key data fields]
- **License**: Alberta Open Government License
- **Notes**: 

### Hospital Capacity
- **URL**: [To be added]
- **Description**: 
- **Update Frequency**: 
- **Format**: 
- **Notes**: 

---

## Use Case 2: Courts and Justice

### Court Statistics
- **URL**: [To be added after research]
- **Description**: Court case volumes, backlogs, case types
- **Update Frequency**: 
- **Format**: 
- **API Available**: 
- **Fields**: 
- **License**: 
- **Notes**: May need to distinguish public vs sealed records

### Court Locations
- **URL**: [To be added]
- **Description**: 
- **Update Frequency**: 
- **Notes**: 

---

## Use Case 3: Energy

### Energy Consumption Data
- **URL**: [To be added after research]
- **Description**: Provincial/regional energy usage patterns
- **Update Frequency**: 
- **Format**: 
- **API Available**: 
- **Fields**: 
- **License**: 
- **Notes**: 

### Energy Rates
- **URL**: [To be added]
- **Description**: 
- **Update Frequency**: 
- **Notes**: 

---

## Use Case 4: Agriculture

### Crop Production Statistics
- **URL**: [To be added after research]
- **Description**: Annual crop yields by region
- **Update Frequency**: 
- **Format**: 
- **API Available**: 
- **Fields**: 
- **License**: 
- **Notes**: 

### Agricultural Land Use
- **URL**: [To be added]
- **Description**: 
- **Update Frequency**: 
- **Notes**: 

---

## Use Case 5: Alberta Pensions

### Pension Plan Statistics (Aggregate)
- **URL**: [To be added after research]
- **Description**: High-level pension statistics (not individual records)
- **Update Frequency**: 
- **Format**: 
- **API Available**: 
- **Fields**: 
- **License**: 
- **Notes**: Individual pension data is Protected B - will use aggregate/simulated data only

### Demographic Data
- **URL**: [To be added]
- **Description**: 
- **Update Frequency**: 
- **Notes**: 

---

## Data Quality Assessment

| Data Source | Completeness | Accuracy | Timeliness | Usability | Overall |
|-------------|--------------|----------|------------|-----------|---------|
| Healthcare - ER Wait Times | TBD | TBD | TBD | TBD | TBD |
| Courts - Statistics | TBD | TBD | TBD | TBD | TBD |
| Energy - Consumption | TBD | TBD | TBD | TBD | TBD |
| Agriculture - Crops | TBD | TBD | TBD | TBD | TBD |
| Pensions - Statistics | TBD | TBD | TBD | TBD | TBD |

**Rating Scale**: Excellent (5) | Good (4) | Fair (3) | Poor (2) | Unusable (1)

---

## API Access Credentials

| Data Source | API Key Required | How to Obtain | Status |
|-------------|------------------|---------------|--------|
| [Source name] | Yes/No | [Instructions] | [Not Started / In Progress / Complete] |

---

## Backup Data Sources

If primary sources are unavailable or insufficient:

### Alternative Healthcare Data
- StatsCan health data
- Provincial health reports (manual extraction)

### Alternative Justice Data
- Federal court statistics
- Similar datasets from other provinces

### Alternative Energy/Agriculture
- Statistics Canada agricultural/energy data
- Environment Canada data

### Alternative Pension Data
- May need to create synthetic data for demo purposes
- Use aggregated statistics only

---

## Next Steps

- [ ] Complete research on Alberta Open Data portal
- [ ] Document all URLs and data formats
- [ ] Test API access for each source
- [ ] Assess data quality
- [ ] Identify any gaps
- [ ] Determine if synthetic data needed for any use case
- [ ] Document API authentication requirements

---

## Notes

**Privacy Considerations**:
- All data used must be publicly available (Public classification)
- No Protected A/B data in demo (will simulate governance of sensitive data)
- Pension data: Use aggregate statistics only, never individual records

**Data Residency**:
- All data stored in Canadian Azure regions (Canada Central, Canada East)
- Complies with Alberta data sovereignty requirements

**License Compliance**:
- Alberta Open Government License allows use, modification, redistribution
- Attribution required in demos and documentation
