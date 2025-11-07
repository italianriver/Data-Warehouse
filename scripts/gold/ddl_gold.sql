/*
===============================================================================
Script: Gold Layer Creation (Silver → Gold)
===============================================================================
Script Purpose:
    This script creates the Gold Layer views that serve as the analytical layer 
    of the data warehouse. This process transforms Silver layer data into an enriched, 
	business-ready model designed to support reporting and business intelligence (BI) activities.

    Operations Performed:
        - Checks for existing Gold views and drops them if present.
        - Creates dimension and fact views in the Gold schema:
            * gold.customers_dim
            * gold.products_dim
            * gold.sales_fact
        - Establishes a star schema structure using views to ensure flexibility 
          and maintainability of the Gold Layer.

Notes:
    - This layer uses SQL views rather than physical tables for transparency 
      and to ensure the latest Silver data is always reflected.

Parameters:
    None.
    This script is executed as a standalone ETL transformation step.

Usage Example:
    - Query the views directly;
===============================================================================
*/


IF OBJECT_ID('gold.customers_dim', 'V') IS NOT NULL
	DROP VIEW gold.customers_dim;
GO

-- Creating gold customer dimension table
CREATE VIEW gold.customers_dim AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key_surr,
	ci.cst_id AS customer_id,  
	ci.cst_key AS customer_number,  
	ci.cst_firstname AS first_name,  
	ci.cst_lastname AS last_name,  
	ci.cst_marital_status AS marital_status,    
	ca.bdate AS birthdate,
	CASE WHEN ci.cst_gndr = 'n/a' AND ca.gen != 'n/a' AND ca.gen IS NOT NULL THEN ca.gen -- CRM is master for gender value
			ELSE ci.cst_gndr
	END AS gender,
	la.cntry AS country,
	ci.cst_create_date AS record_create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
	on ci.cst_key = la.cid;
GO

IF OBJECT_ID('gold.products_dim', 'V') IS NOT NULL
	DROP VIEW gold.products_dim;
GO

-- Creating gold products dimension table
CREATE VIEW gold.products_dim AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pdi.prd_id) AS product_key_surr,
	pdi.prd_id AS product_id,  
	pdi.cat_id AS category_id,
	pdi.prd_key AS product_number,
	pdi.prd_nm AS product_name,
	pdi.prd_cost AS product_cost,  
	pdi.prd_line AS product_line,  
	pc.cat AS product_category,
	pc.subcat AS product_subcategory_name,
	pc.maintenance AS maintenance,
	pdi.prd_start_dt AS product_start_sell_date,
	pdi.prd_end_dt AS product_end_sell_date
FROM silver.crm_prd_info AS pdi
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
	ON pdi.cat_id = pc.id
WHERE pdi.prd_end_dt IS NULL;				-- Display only freshest data
GO

IF OBJECT_ID('gold.sales_fact', 'V') IS NOT NULL
	DROP VIEW gold.sales_fact;
GO

-- Creating gold sales fact table
CREATE VIEW gold.sales_fact AS
SELECT
	sd.sls_ord_num AS order_number,   
	pr.product_key_surr,
	ci.customer_key_surr,
	sd.sls_order_dt AS order_date,  
	sd.sls_ship_dt AS order_ship_date,  
	sd.sls_due_dt AS order_due_date,  
	sd.sls_sales AS sale_price,  
	sd.sls_quantity AS sale_quantity,  
	sd.sls_price AS item_price
	FROM silver.crm_sales_details AS sd
	LEFT JOIN gold.product_dim AS pr
		ON sd.sls_prd_key = pr.product_number
	LEFT JOIN gold.customer_dim AS ci
		on sd.sls_cust_id = ci.customer_id;
			
