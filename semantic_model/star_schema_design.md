# Star Schema Design (Gold / Presentation Layer)

## Fact Table
- **`fact_patient_admissions`**: 
  - **Grain:** One row per patient admission.
  - **Foreign Keys:** `provider_key`, `medical_key`, `insurance_key`.
  - **Additive Measures:** `billing_amount`, `length_of_stay_days`.
  - **Degenerate Dimensions:** `admission_key`, `date_of_admission`, `discharge_date`.

## Dimension Tables (Contextual Data Layers)
All dimension tables utilize durable surrogate keys generated via `HASHBYTES('SHA2_256', ...)` to ensure referential integrity and optimize join performance in Power BI.

- **`dim_date`**: 
  - **Primary Key:** `admission_date`
  - **Attributes:** `admission_year`, `admission_month`, `admission_day`, `admission_day_of_week`. Used for time-intelligence calculations.
  
- **`dim_provider`**: 
  - **Primary Key:** `provider_key`
  - **Attributes:** `doctor_name`, `hospital_name`. Represents the conformed provider entity.
  
- **`dim_medical`**: 
  - **Primary Key:** `medical_key`
  - **Attributes:** `medical_condition`, `medication`, `test_results`. Groups clinical attributes to reduce fact table width.
  
- **`dim_insurance`**: 
  - **Primary Key:** `insurance_key`
  - **Attributes:** `insurance_provider`, `admission_type`. Groups financial and intake attributes.