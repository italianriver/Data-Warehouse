# SQL Server Data Warehouse Project

## Welcome  
Welcome to my **SQL Data Warehouse** project!  
This repository showcases my work in designing and building a **modern data warehouse** using **SQL Server** — from raw data ingestion to business-ready analytics.  
The goal of this project is to demonstrate end-to-end **data engineering** skills, including ETL processes, data modelling, and provide an analytics ready data layer.

---

## Project Architecture  
The data architecture follows the **Medallion Architecture** Bronze → Silver → Gold.

![data architecture overview](docs/data_architecture_overview.png)

### Bronze Layer  
- Ingests raw data from **ERP** and **CRM** systems stored as CSV files.  
- Loads data into SQL Server tables without transformations (as-is).  
- Ensures full data capture and traceability of source data.

### Silver Layer  
- Cleanses and standardises data using **stored procedures**.  
- Applies transformations such as:  data cleansing and normalisation, computed columns and data enrichment  
- Produces a consistent, reliable dataset ready for business integration.

### Gold Layer  
- Integrates business logic and performs aggregations.  
- Builds business-ready data into a star schema to support reporting and analytics 
- Delivers business-ready views for:  

---

## Project Requirements  

### Building the Data Warehouse (Data Engineering)
**Objective:**  
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

**Specifications:**  
- **Data Sources:** Import data from two systems — ERP and CRM — provided as CSV files.  
- **Data Quality:** Cleanse and fix data quality issues before analysis.  
- **Integration:** Combine both sources into a unified, analysis-ready model.  
- **Scope:** Focus only on the latest dataset (no historisation).  
- **Documentation:** Provide clear data model documentation for business and analytics teams.

---

### Analytics & Reporting (Data Analysis)
**Objective:**  
Develop SQL-based analytics to deliver actionable insights into:  
- Customer behaviour  
- Product performance  
- Sales trends  

These insights help stakeholders track key business metrics and support strategic decision-making.

---

## About Me

I'm a recent graduate who is motivated by turning raw data into meaningful insights through clean, efficient data pipelines. I started this project to **deepen my understanding and apply core SQL skills** essential to **end-to-end data engineering**, while also **strengthening my experience in data modeling**. 
