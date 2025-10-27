# sql-data-warehouse
Designing and implementing a SQL Server–based modern data warehouse, including ETL workflows, data modelling, and analytics.


🏗️ SQL Server Data Warehouse Project
👋 Welcome

Welcome to my SQL Data Warehouse project!
This repository showcases my work in designing and building a modern data warehouse using SQL Server — from raw data ingestion to business-ready analytics. The goal of this project is to demonstrate end-to-end data engineering skills, from ETL processes to data modelling and reporting.

🧱 Project Architecture

The solution follows the Medallion Architecture (Bronze → Silver → Gold) to ensure scalability, quality, and clarity of data flow.

Bronze Layer: Ingests raw data from source systems (ERP and CRM) stored as CSV files. Data is loaded into SQL Server tables without transformation to preserve original integrity.

Silver Layer: Cleanses and standardises data using stored procedures. Here, transformations such as normalization, enrichment, and derived columns are applied to create a consistent, high-quality dataset.

Gold Layer: Integrates business logic, aggregations, and star-schema modelling to produce business-ready data for analytics and reporting.

Data from the Gold layer is consumed by BI tools, ad-hoc SQL queries, and can serve as input for machine learning applications.

(See the architecture diagram above for a visual overview.)

⚙️ Project Requirements
🧩 Building the Data Warehouse (Data Engineering)

Objective:
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

Specifications:

Data Sources: Import data from two systems — ERP and CRM — provided as CSV files.

Data Quality: Cleanse and fix data quality issues before analysis.

Integration: Combine both sources into a unified, analysis-ready model.

Scope: Focus only on the latest dataset (no historisation).

Documentation: Provide clear documentation of the data model for business and analytics teams.

📊 Analytics & Reporting (Data Analysis)

Objective:
Develop SQL-based analytics to deliver actionable insights into:

Customer behaviour

Product performance

Sales trends

These insights help stakeholders track key metrics and support strategic decision-making.

🙋 About Me

I’m a recent graduate with a strong interest in data engineering and a passion for building robust, scalable data solutions. This project represents my hands-on approach to learning modern data practices — from ETL development to data modelling and analytics.
