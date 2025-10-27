# sql-data-warehouse
Designing and implementing a SQL Server–based modern data warehouse, including ETL workflows, data modelling, and analytics.


# 🏗️ SQL Server Data Warehouse Project

## 👋 Welcome  
Welcome to my **SQL Data Warehouse** project!  
This repository showcases my work in designing and building a **modern data warehouse** using **SQL Server** — from raw data ingestion to business-ready analytics.  
The goal of this project is to demonstrate end-to-end **data engineering** skills, including ETL processes, data modelling, and analytical reporting.

---

## 🧱 Project Architecture  
The solution follows the **Medallion Architecture** (Bronze → Silver → Gold) to ensure data quality, scalability, and clarity across the pipeline.

### 🥉 Bronze Layer  
- Ingests raw data from **ERP** and **CRM** systems stored as CSV files.  
- Loads data into SQL Server tables without transformations (as-is).  
- Ensures full data capture and traceability of source data.

### 🥈 Silver Layer  
- Cleanses and standardises data using **stored procedures**.  
- Applies transformations such as:  
  - Data cleansing and normalisation  
  - Derived columns  
  - Data enrichment  
- Produces a consistent, reliable dataset ready for business integration.

### 🥇 Gold Layer  
- Integrates business logic and performs aggregations.  
- Builds analytical data models such as **star schemas** and **flat tables**.  
- Delivers business-ready views for:  
  - **BI & reporting**  
  - **Ad-hoc SQL queries**  
  - **Machine learning**  

📊 *See the architecture diagram above for a visual overview.*

---

## ⚙️ Project Requirements  

### 🧩 Building the Data Warehouse (Data Engineering)
**Objective:**  
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

**Specifications:**  
- **Data Sources:** Import data from two systems — ERP and CRM — provided as CSV files.  
- **Data Quality:** Cleanse and fix data quality issues before analysis.  
- **Integration:** Combine both sources into a unified, analysis-ready model.  
- **Scope:** Focus only on the latest dataset (no historisation).  
- **Documentation:** Provide clear data model documentation for business and analytics teams.

---

### 📊 Analytics & Reporting (Data Analysis)
**Objective:**  
Develop SQL-based analytics to deliver actionable insights into:  
- Customer behaviour  
- Product performance  
- Sales trends  

These insights help stakeholders track key business metrics and support strategic decision-making.

---

## 🙋 About Me  
I’m a **recent graduate** with a strong interest in **data engineering** and a passion for building robust, scalable data solutions.  
This project reflects my hands-on approach to learning modern data practices — from **ETL development**
