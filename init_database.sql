/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'Dummydb' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver_prep', 'silver' and 'gold'.
	
WARNING:
    Running this script will drop the entire 'Dummydb' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO


IF EXISTS (SELECT 1 FROM sys.databases WHERE name='Dummydb')
BEGIN
	ALTER DATABASE Dummydb SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE Dummydb
END;
GO

CREATE DATABASE Dummydb
COLLATE Latin1_General_CS_AS;
GO

USE Dummydb;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver_prep;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO


