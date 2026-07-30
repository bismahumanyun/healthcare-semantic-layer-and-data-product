USE HealthcareAnalytics;
GO

-- 1. Dim Date
IF OBJECT_ID('gold.dim_date', 'U') IS NOT NULL DROP TABLE gold.dim_date;
SELECT DISTINCT
    CAST([Date_of_Admission] AS DATE) AS admission_date,
    YEAR([Date_of_Admission]) AS admission_year,
    MONTH([Date_of_Admission]) AS admission_month,
    DAY([Date_of_Admission]) AS admission_day,
    DATENAME(weekday, [Date_of_Admission]) AS admission_day_of_week
INTO gold.dim_date
FROM bronze.raw_healthcare_dataset;
GO

-- 2. Dim Provider
IF OBJECT_ID('gold.dim_provider', 'U') IS NOT NULL DROP TABLE gold.dim_provider;
SELECT 
    HASHBYTES('SHA1', ISNULL([Doctor], '') + '|' + ISNULL([Hospital], '')) AS provider_key,
    [Doctor] AS doctor_name,
    [Hospital] AS hospital_name
INTO gold.dim_provider
FROM bronze.raw_healthcare_dataset
GROUP BY [Doctor], [Hospital];
GO

-- 3. Dim Medical
IF OBJECT_ID('gold.dim_medical', 'U') IS NOT NULL DROP TABLE gold.dim_medical;
SELECT 
    HASHBYTES('SHA1', ISNULL([Medical_Condition], '') + '|' + ISNULL([Medication], '') + '|' + ISNULL([Test_Results], '')) AS medical_key,
    [Medical_Condition] AS medical_condition,
    [Medication] AS medication,
    [Test_Results] AS test_results
INTO gold.dim_medical
FROM bronze.raw_healthcare_dataset
GROUP BY [Medical_Condition], [Medication], [Test_Results];
GO

-- 4. Dim Insurance
IF OBJECT_ID('gold.dim_insurance', 'U') IS NOT NULL DROP TABLE gold.dim_insurance;
SELECT 
    HASHBYTES('SHA1', ISNULL([Insurance_Provider], '') + '|' + ISNULL([Admission_Type], '')) AS insurance_key,
    [Insurance_Provider] AS insurance_provider,
    [Admission_Type] AS admission_type
INTO gold.dim_insurance
FROM bronze.raw_healthcare_dataset
GROUP BY [Insurance_Provider], [Admission_Type];
GO