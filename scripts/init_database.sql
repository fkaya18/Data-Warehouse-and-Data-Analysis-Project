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


