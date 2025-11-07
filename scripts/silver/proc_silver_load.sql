/*
===============================================================================
Stored Procedure: Silver Layer Load (Bronze → Silver)
===============================================================================
Script Purpose:
    This stored procedure executes the ETL workflow that transfers and refines data 
    from the Bronze layer into the Silver layer.

    Operations Performed:
        - Clears existing data in the Silver tables prior to reload.
        - Transforms and loads enriched, standardized, and cleansed data from the Bronze layer into Silver.
        
Parameters:
    None. 
    This stored procedure does not take any input parameters or return values.

Usage Example:
    EXEC silver.load_silver_layer;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver_layer AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @silver_start_time DATETIME, @silver_end_time DATETIME;

	BEGIN TRY
		SET @silver_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Performing Bronze > Silver Layer Tranformation';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Transforming & Loading CRM Tables';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();


		PRINT '>> Truncating Table: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;

		INSERT INTO silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
			)
		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE WHEN UPPER (TRIM(cst_marital_status)) = 'M' THEN 'Married'
				 WHEN UPPER (TRIM(cst_marital_status)) = 'S' THEN 'Single'
				 ELSE 'N/A'
			END AS cst_marital_status,															-- Mapping code values to descriptive values
			CASE WHEN UPPER (TRIM(cst_gndr)) = 'M' THEN 'Male'
				 WHEN UPPER (TRIM(cst_gndr)) = 'F' THEN 'Female'
				 ELSE 'N/A'
			END AS cst_gndr,
			cst_create_date
			FROM (
				SELECT *, 
				ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date) AS flag_last   -- Ranking rows to guarantee freshest data
				FROM bronze.crm_cust_info
				WHERE cst_id IS NOT NULL
		) AS ranked
		WHERE flag_last = 1;



		PRINT '>> Truncating Table: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;

		INSERT INTO silver.crm_prd_info (
			prd_id, 
			cat_id, 
			prd_key, 
			prd_nm, 
			prd_cost, 
			prd_line, 
			prd_start_dt, 
			prd_end_dt
		)
		SELECT 
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Derive category ID
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,		   -- Derive product key
			prd_nm,
			ISNULL(prd_cost, 0) AS prd_cost,
			CASE UPPER(TRIM(prd_line))							   -- Map product codes to descriptive values
				 WHEN 'T' THEN 'Touring'
				 WHEN 'M' THEN 'Mountain'
				 WHEN 'R' THEN 'Road'
				 WHEN 'S' THEN 'Others'
				 ELSE 'n/a'
			END AS prd_line,
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt	-- Calculate missing end date using next known starting date
		FROM bronze.crm_prd_info;



		PRINT '>> Truncating Table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;

		INSERT INTO silver.crm_sales_details (
			sls_ord_num, 
			sls_prd_key, 
			sls_cust_id, 
			sls_order_dt, 
			sls_ship_dt, 
			sls_due_dt, 
			sls_sales, 
			sls_quantity, 
			sls_price 
		)
		SELECT
			sls_ord_num, 
			sls_prd_key, 
			sls_cust_id, 
			CASE WHEN LEN(sls_order_dt) != 8 OR sls_order_dt > 20300101 OR sls_order_dt < 19800101 THEN NULL    -- Check valid date format and inside company boundaries
				 ELSE CONVERT(date, CAST(sls_order_dt AS char(8)), 112)											-- Convert INT date to DATE format
			END AS sls_order_dt,
			CASE WHEN LEN(sls_ship_dt) != 8 OR sls_ship_dt > 20300101 OR sls_ship_dt < 19800101 THEN NULL		-- Check valid date format and inside company boundaries
				 ELSE CONVERT(date, CAST(sls_ship_dt AS char(8)), 112)
			END AS sls_ship_dt,
			CASE WHEN LEN(sls_due_dt) != 8 OR sls_due_dt > 20300101 OR sls_due_dt < 19800101 THEN NULL			-- Check valid date format and inside company boundaries
				 ELSE CONVERT(date, CAST(sls_due_dt AS char(8)), 112)
			END AS sls_due_dt,
			CASE WHEN sls_sales IS NULL OR sls_sales < 0 AND sls_price IS NOT NULL THEN (sls_quantity * ABS(sls_price))		
				 WHEN sls_price IS NOT NULL AND sls_sales != (sls_price * sls_quantity) THEN (ABS(sls_price) * sls_quantity)
				 ELSE sls_sales
			END AS sls_sales,																					-- Transform NULL and negative values by using quantity and price if available
			sls_quantity,
			CASE WHEN sls_price IS NULL OR sls_price < 0 AND sls_sales IS NOT NULL THEN (sls_sales / sls_quantity)
				 WHEN sls_price < 0 THEN ABS(sls_price)
				 ELSE sls_price
			END AS sls_price																					-- Transform NULL and negative values by using quantity and sales if available
		FROM bronze.crm_sales_details



		SET @end_time = GETDATE();

		PRINT '------------------------------------------------';
		PRINT '** Finished Transforming & Loading CRM Tables **';
		PRINT '>> CRM Tables Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------';
		PRINT '';
		PRINT '------------------------------------------------';
		PRINT 'Started Transforming & Loading ERP Tables';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;

		INSERT INTO silver.erp_cust_az12 (
			CID, 
			BDATE, 
			GEN
		)
		SELECT 
			CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, len(CID))    -- Remove first three chars (not needed) to make matching with other table possible
				 ELSE CID
			END AS cid,
			CASE WHEN BDATE > GETDATE() THEN NULL					      -- Remove invalid birth dates
				 ELSE BDATE
			END AS bdate,
			CASE WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'   -- Convert code values to descriptive values
				 WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
			 ELSE 'n/a'
			END AS gen
		FROM bronze.erp_cust_az12


		PRINT '>> Truncating Table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;

		INSERT INTO silver.erp_loc_a101 (
			cid,
			cntry
		)
		SELECT 
			REPLACE(CID, '-', '') AS cid,										-- Handling invalid values - fix for customer id, needed for matching with other tables
			CASE WHEN CNTRY IS NULL OR TRIM(CNTRY) = '' THEN 'n/a'				
				 WHEN UPPER(TRIM(CNTRY)) IN ('USA', 'US', 'UNITED STATES') THEN 'USA'
				 WHEN UPPER(TRIM(CNTRY)) IN ('DE', 'GERMANY') THEN 'Germany'
				 ELSE TRIM(CNTRY)
			END AS cntry														-- Data normalization - cleaning duplicate, empty and NULL country values
		FROM bronze.erp_loc_a101


		PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		INSERT INTO silver.erp_px_cat_g1v2 (
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT *
		FROM bronze.erp_px_cat_g1v2

		SET @end_time = GETDATE();

		
		PRINT '------------------------------------------------';
		PRINT '** Finished Loading ERP Tables **';
		PRINT '>> ERP Tables Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------';
		PRINT '';
		PRINT '================================================';
		PRINT '*** Silver Layer Hop Has Succesfully Completed ***';
		PRINT '>> Total Silver Layer Duration: ' + CAST(DATEDIFF(SECOND, @silver_start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '================================================';
	END TRY

	BEGIN CATCH
		PRINT '================================================';
		PRINT 'AN UNEXPECTED ERROR OCCURED DURING THE SILVER HOP PROCESS';
		PRINT 'Error Message: '  + ERROR_MESSAGE();
		PRINT 'Error Number: '   + CAST(ERROR_NUMBER() AS NVARCHAR(10));
		PRINT 'Error State: '    + CAST(ERROR_STATE() AS NVARCHAR(10));
		PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
		PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
		PRINT '================================================';
	END CATCH
END
