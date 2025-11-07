/*
===============================================================================
Stored Procedure: Bronze Layer Load (Source → Bronze)
===============================================================================
Script Purpose:
    This stored procedure handles the initial data ingestion step of the pipeline, 
    loading raw data from external CSV files into the Bronze layer.

    Operations Included:
        - Truncates existing data in the Bronze tables before reloading.
        - Uses the BULK INSERT command to load data from six CSV source files 
          into the corresponding Bronze tables.

Parameters:
    None. 
    This stored procedure does not take any input parameters or return values.

Usage Example:
    EXEC bronze.load_bronze_layer;
===============================================================================
*/



CREATE OR ALTER PROCEDURE bronze.load_bronze_layer AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @bronze_start_time DATETIME, @bronze_end_time DATETIME;
	BEGIN TRY
		SET @bronze_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Tibor\Projects\Programming\DataProjects\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
	 


		TRUNCATE TABLE bronze.crm_prd_info;

		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Tibor\Projects\Programming\DataProjects\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
	 


		TRUNCATE TABLE bronze.crm_sales_details;

		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Tibor\Projects\Programming\DataProjects\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
	 
		SET @end_time = GETDATE();
		PRINT '------------------------------------------------';
		PRINT 'Finished Loading CRM Tables';
		PRINT '>> CRM Tables Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------';

		PRINT '------------------------------------------------';
		PRINT 'Started Loading ERP Tables';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_cust_az12;

		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Tibor\Projects\Programming\DataProjects\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
	 


		TRUNCATE TABLE bronze.erp_loc_a101;

		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Tibor\Projects\Programming\DataProjects\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
	 


		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Tibor\Projects\Programming\DataProjects\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();

		
		PRINT '------------------------------------------------';
		PRINT 'Finished Loading ERP Tables';
		PRINT '>> ERP Tables Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-- Bronze Layer Ingestion Succesful';
		PRINT '>> Total Load Duration: ' + CAST(DATEDIFF(SECOND, @bronze_start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------';
	END TRY

	BEGIN CATCH
		PRINT '================================================';
		PRINT 'AN UNEXPECTED ERROR OCCURED DURING THE BRONZE LOADING PROCESS';
		PRINT 'Error Message: '  + ERROR_MESSAGE();
		PRINT 'Error Number: '   + CAST(ERROR_NUMBER() AS NVARCHAR(10));
		PRINT 'Error State: '    + CAST(ERROR_STATE() AS NVARCHAR(10));
		PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
		PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
		PRINT '================================================';
	END CATCH
END
