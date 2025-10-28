/*
================================================================
CREATE DATABASE AND SCHEMAS
================================================================
Script purpose:
	This script creates a new database named 'DataWarehouse' after checking if it already exists.
	If the DB already exists, it is dropped and recreated. Additionally, the script sets up three schemas
	used for the medaillon architecture within the database: 'bronze', 'silver', and 'gold'.

WARNING:
	This script drop the entire 'DataWarehouse' database if it exists.
	All its data will be permanently deleted. Ensure you have proper back ups.
*/


USE master;
GO

-- Drop DB if already exists
IF DB_ID('DataWarehouse') IS NOT NULL
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO


-- Create DB
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
