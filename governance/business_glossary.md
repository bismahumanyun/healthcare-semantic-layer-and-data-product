# Business Glossary and Metric Standardization

| Term | Business Definition | Technical Calculation (T-SQL) | Conflict Resolution Note |
|------|---------------------|-------------------------------|--------------------------|
| **Length of Stay (LOS)** | Total days a patient occupies a hospital bed. | `CASE WHEN DATEDIFF(day, date_of_admission, discharge_date) < 1 THEN 1 ELSE DATEDIFF(day, date_of_admission, discharge_date) END` | Standardized to ensure same-day discharges are counted as a minimum of 1 day, preventing skewed operational metrics and bed-capacity reporting. |
| **High-Cost Admission** | An admission that significantly exceeds typical costs for its specific condition. | `billing_amount` > 90th percentile of `billing_amount` partitioned by `medical_condition`. | Prevents unfair comparisons between inherently low-cost conditions (e.g., Flu) and high-cost conditions (e.g., Cancer). |
| **Active Patient** | A patient currently admitted or discharged within the last 30 days. | `discharge_date IS NULL OR discharge_date >= DATEADD(day, -30, GETDATE())` | Resolves ambiguity between patients who are merely "registered" in the system versus those "actively receiving care". |