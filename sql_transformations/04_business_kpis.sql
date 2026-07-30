USE HealthcareAnalytics;
GO

-- KPI 1: Average Length of Stay and Total Billing by Medical Condition
SELECT 
    m.medical_condition,
    COUNT(f.admission_key) AS total_admissions,
    ROUND(AVG(CAST(f.length_of_stay_days AS FLOAT)), 2) AS avg_length_of_stay,
    ROUND(SUM(f.billing_amount), 2) AS total_billing_amount
FROM gold.fact_patient_admissions f
JOIN gold.dim_medical m ON f.medical_key = m.medical_key
GROUP BY m.medical_condition
ORDER BY total_admissions DESC;
GO

-- KPI 2: Billing Efficiency by Insurance Provider (Using Window Functions)
WITH provider_metrics AS (
    SELECT 
        i.insurance_provider,
        i.admission_type,
        SUM(f.billing_amount) AS total_billed,
        COUNT(f.admission_key) AS admission_count
    FROM gold.fact_patient_admissions f
    JOIN gold.dim_insurance i ON f.insurance_key = i.insurance_key
    GROUP BY i.insurance_provider, i.admission_type
)
SELECT 
    insurance_provider,
    admission_type,
    total_billed,
    ROUND(total_billed / NULLIF(admission_count, 0), 2) AS avg_billing_per_admission,
    ROUND((total_billed / SUM(total_billed) OVER (PARTITION BY admission_type)) * 100.0, 2) AS pct_of_total_billed_by_type
FROM provider_metrics
ORDER BY admission_type, total_billed DESC;
GO