USE HealthcareAnalytics;
GO

IF OBJECT_ID('gold.fact_patient_admissions', 'U') IS NOT NULL DROP TABLE gold.fact_patient_admissions;
GO

WITH cleaned_data AS (
    SELECT 
        HASHBYTES('SHA1', ISNULL([Name], '') + '|' + ISNULL(CONVERT(VARCHAR(10), [Date_of_Admission], 120), '')) AS admission_key,
        HASHBYTES('SHA1', ISNULL([Doctor], '') + '|' + ISNULL([Hospital], '')) AS provider_key,
        HASHBYTES('SHA1', ISNULL([Medical_Condition], '') + '|' + ISNULL([Medication], '') + '|' + ISNULL([Test_Results], '')) AS medical_key,
        HASHBYTES('SHA1', ISNULL([Insurance_Provider], '') + '|' + ISNULL([Admission_Type], '')) AS insurance_key,
        [Billing_Amount] AS billing_amount,
        CAST([Date_of_Admission] AS DATE) AS date_of_admission,
        CAST([Discharge_Date] AS DATE) AS discharge_date,
        -- Business Rule: Minimum Length of Stay is 1 day, even for same-day discharge
        CASE 
            WHEN DATEDIFF(day, CAST([Date_of_Admission] AS DATE), CAST([Discharge_Date] AS DATE)) < 1 
            THEN 1 
            ELSE DATEDIFF(day, CAST([Date_of_Admission] AS DATE), CAST([Discharge_Date] AS DATE)) 
        END AS length_of_stay_days
    FROM bronze.raw_healthcare_dataset
    WHERE [Billing_Amount] >= 0 
      AND CAST([Date_of_Admission] AS DATE) <= CAST([Discharge_Date] AS DATE)
      AND [Medical_Condition] IS NOT NULL
      AND LTRIM(RTRIM([Medical_Condition])) <> ''
)
SELECT * INTO gold.fact_patient_admissions FROM cleaned_data;
GO