USE HealthcareAnalytics;
GO

SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN billing_amount < 0 THEN 1 ELSE 0 END) AS negative_billing_count,
    SUM(CASE WHEN CAST(date_of_admission AS DATE) > CAST(discharge_date AS DATE) THEN 1 ELSE 0 END) AS invalid_stay_count,
    SUM(CASE WHEN medical_condition IS NULL OR LTRIM(RTRIM(medical_condition)) = '' THEN 1 ELSE 0 END) AS null_condition_count,
    CASE 
        WHEN SUM(CASE WHEN billing_amount < 0 THEN 1 ELSE 0 END) > 0 
          OR SUM(CASE WHEN CAST(date_of_admission AS DATE) > CAST(discharge_date AS DATE) THEN 1 ELSE 0 END) > 0 
        THEN 'FAIL: Data requires cleansing'
        ELSE 'PASS: Ready for Gold Layer'
    END AS governance_status
FROM bronze.raw_healthcare_dataset;
GO