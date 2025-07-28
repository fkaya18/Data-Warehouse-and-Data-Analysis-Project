/*
===============================================================================
DDL Script: Create Silver Preperation Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver_prep' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver_prep' Tables
===============================================================================
*/

USE Dummydb;
GO


IF OBJECT_ID('silver_prep.products', 'U') IS NOT NULL
	DROP TABLE silver_prep.products;
GO

CREATE TABLE silver_prep.products(
	product_id INT PRIMARY KEY,
	title NVARCHAR(50),
	description NVARCHAR(256),
	category NVARCHAR(50),
	subcategory NVARCHAR(50),
	price DECIMAL(10,2),
	discount_percentage DECIMAL(10,2),
	rating DECIMAL(10,2),
	stock INT,
	brand NVARCHAR(50),
	sku NVARCHAR(50),
	weight INT,
	warranty_information NVARCHAR(50),
	shipping_information NVARCHAR(50),
	availability_status NVARCHAR(50),
	return_policy NVARCHAR(50),
	min_order_quantity INT,
	image_1 NVARCHAR(256),
	image_2 NVARCHAR(256),
	image_3 NVARCHAR(256),
	image_4 NVARCHAR(256),
	image_5 NVARCHAR(256),
	image_6 NVARCHAR(256),
	thumbnail NVARCHAR(256),
	dimension_width DECIMAL(10,2),
	dimension_height DECIMAL(10,2),
	dimension_depth DECIMAL(10,2),
	meta_created_at DATETIMEOFFSET, 
	meta_updated_at DATETIMEOFFSET,
	meta_barcode NVARCHAR(50),
	meta_qr_code NVARCHAR(50)
);
GO


IF OBJECT_ID('silver_prep.carts', 'U') IS NOT NULL
	DROP TABLE silver_prep.carts;
GO

CREATE TABLE silver_prep.carts(
	order_id INT,
	total DECIMAL(10,2),
	discounted_total DECIMAL(10,2),
	user_id INT,
	total_products INT,
	total_quantity INT,
	product_id INT,
	product_title NVARCHAR(50),
	product_price DECIMAL(10,2),
	product_quantity INT,
	product_total DECIMAL(10,2),
	product_discount_percentage DECIMAL(10,2),
	product_discounted_total DECIMAL(10,2),
	product_thumbnail NVARCHAR(256)
);
GO

IF OBJECT_ID('silver_prep.users', 'U') IS NOT NULL
	DROP TABLE silver_prep.users;
GO

CREATE TABLE silver_prep.users(
user_id INT PRIMARY KEY ,
first_name NVARCHAR(50),
last_name NVARCHAR(50),
maiden_name NVARCHAR(50),
age INT,
gender NVARCHAR(50),
email NVARCHAR(50),
phone NVARCHAR(50),
username NVARCHAR(50),
password NVARCHAR(50),
birthdate DATE,
image NVARCHAR(256),
blood_group NVARCHAR(50),
height DECIMAL(10,2),
weight DECIMAL(10,2),
eye_color NVARCHAR(50),
ip NVARCHAR(50),
mac_address NVARCHAR(50),
university NVARCHAR(256),
ein NVARCHAR(50),
ssn NVARCHAR(50),
user_agent NVARCHAR(512),
role NVARCHAR(50),
hair_color NVARCHAR(50),
hair_type NVARCHAR(50),
address_street NVARCHAR(50),
address_city NVARCHAR(50),
address_state NVARCHAR(50),
address_state_code NVARCHAR(50),
address_postal_code NVARCHAR(50),
address_coordinates_lat FLOAT,
address_coordinates_lng FLOAT,
address_country NVARCHAR(50),
bank_card_expire NVARCHAR(50),
bank_card_number NVARCHAR(50),
bank_card_type NVARCHAR(50),
bank_currency NVARCHAR(50),
bank_iban NVARCHAR(50),
company_deparment NVARCHAR(50),
company_name NVARCHAR(50),
company_title NVARCHAR(50),
company_address_street NVARCHAR(50),
company_address_city NVARCHAR(50),
company_address_state NVARCHAR(50),
company_address_state_code NVARCHAR(50),
company_address_postal_code NVARCHAR(50),
company_address_coordinates_lat FLOAT,
company_address_coordinates_lng FLOAT,
company_address_country NVARCHAR(50),
crypto_coin NVARCHAR(50),
crypto_wallet NVARCHAR(50),
crypto_network NVARCHAR(50)
);
GO


IF OBJECT_ID('silver_prep.reviews', 'U') IS NOT NULL
	DROP TABLE silver_prep.reviews
GO

CREATE TABLE silver_prep.reviews(
	review_id INT PRIMARY KEY,
	product_id INT,
	rating INT,
	comment NVARCHAR(256),
	date DATETIMEOFFSET,
	reviewer_name NVARCHAR(50),
	reviewer_email NVARCHAR(50)
);
GO



SELECT *
FROM silver_prep.products;
GO

SELECT *
FROM silver_prep.carts;
GO

SELECT *
FROM silver_prep.users;


SELECT *
FROM silver_prep.reviews;
