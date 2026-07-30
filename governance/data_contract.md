# Data Contract: gold.fact_patient_admissions

## Ownership and SLA
- **Data Owner:** Enterprise Data Analytics Team
- **Stakeholders:** Hospital Operations, Finance, Clinical Directors
- **Refresh SLA:** Daily by 06:00 AM EST
- **Upstream Dependency:** bronze.raw_healthcare_dataset

## Data Quality Rules (Enforced in T-SQL)
1. **Completeness:** `medical_condition`, `admission_type`, and `billing_amount` MUST NOT be NULL or empty strings.
2. **Validity:** `discharge_date` MUST be greater than or equal to `date_of_admission`.
3. **Accuracy:** `billing_amount` MUST be greater than or equal to 0. Records violating this are filtered out during the Gold layer load.
4. **Uniqueness:** `admission_key` (generated via `HASHBYTES('SHA2_256', ...)`) must be unique per patient admission to prevent duplicate billing.

## Schema Evolution and Change Management
Any changes to column names, data types, or business logic require a formal Pull Request, a documented impact analysis, and approval from the Data Governance Council before merging into the main branch.