\# Healthcare Analytics Semantic Layer and Data Product



\## Overview

This project demonstrates the end-to-end development of a business-ready semantic data product for a healthcare organization. It transforms raw, flat patient admission data into an optimized Gold/Presentation Layer using dimensional modeling (Star Schema), complex T-SQL transformations, and strict data governance principles.



\## Business Value

\- \*\*Standardized KPIs:\*\* Resolves conflicting business definitions for metrics such as "Length of Stay" and "High-Cost Admissions" to ensure enterprise-wide consistency.

\- \*\*Optimized Performance:\*\* Pre-aggregated fact and dimension tables enable sub-second query performance in downstream BI tools (e.g., Power BI).

\- \*\*Governance and Trust:\*\* Enforced via a formal Data Contract, automated data quality checks, and a centralized Business Glossary.



\## Tech Stack and Practices

\- \*\*Data Platform:\*\* Microsoft SQL Server (T-SQL).

\- \*\*Development Environment:\*\* SQL Server Management Studio (SSMS).

\- \*\*Modeling:\*\* Star Schema (Dimensional Modeling) with conformed dimensions.

\- \*\*Governance:\*\* Data Contracts, Business Glossary, Metadata Management.

\- \*\*Workflow:\*\* Designed for Git version control, CI/CD integration, and peer-reviewed pull requests.



\## Project Structure



healthcare-semantic-layer-gold/

├── README.md

├── data/

│ └── modified\_healthcare\_dataset.csv # Raw Bronze layer dataset

├── governance/

│ ├── data\_contract.md # SLAs, quality rules, and schema evolution policies

│ └── business\_glossary.md # Standardized metric definitions and conflict resolutions

├── semantic\_model/

│ └── star\_schema\_design.md # Fact and dimension table architecture

└── sql\_transformations/

├── 01\_data\_quality\_checks.sql # Bronze layer profiling and validation

├── 02\_build\_dimension\_tables.sql # Gold layer dimension creation

├── 03\_build\_fact\_table.sql # Gold layer fact creation with business logic

└── 04\_business\_kpis.sql # Analytical queries and window functions







\## How to Use



\### Prerequisites

\- Microsoft SQL Server installed and accessible.

\- SQL Server Management Studio (SSMS) or Azure Data Studio.

\- The `modified\_healthcare\_dataset.csv` file located in the `data/` directory.



\### Execution Steps

1\. \*\*Environment Setup:\*\* Create the `HealthcareAnalytics` database and initialize the `bronze` and `gold` schemas.

2\. \*\*Bronze Layer Ingestion:\*\* Use the SSMS Import Flat File wizard to load `modified\_healthcare\_dataset.csv` into the `bronze.raw\_healthcare\_dataset` table.

3\. \*\*Data Quality Profiling:\*\* Execute `01\_data\_quality\_checks.sql` to validate the raw data against the governance rules defined in the Data Contract.

4\. \*\*Semantic Layer Construction:\*\* Execute the transformation scripts in strict numerical order:

&#x20;  - `02\_build\_dimension\_tables.sql` (Creates `dim\_date`, `dim\_provider`, `dim\_medical`, `dim\_insurance`)

&#x20;  - `03\_build\_fact\_table.sql` (Creates `fact\_patient\_admissions` with enforced business rules)

5\. \*\*Analytics and Reporting:\*\* Execute `04\_business\_kpis.sql` to verify the Gold layer outputs and calculate standardized metrics.

6\. \*\*BI Integration:\*\* Connect Power BI directly to the `gold` schema tables using the relationships defined in `semantic\_model/star\_schema\_design.md`.



\## Data Governance and Conflict Resolution

A key focus of this project is resolving metric ambiguity. For example, "Length of Stay" is standardized in the `business\_glossary.md` and enforced in the T-SQL fact table script to ensure same-day discharges are counted as a minimum of 1 day, preventing skewed operational reporting. All schema changes require formal review as outlined in the `data\_contract.md`.

