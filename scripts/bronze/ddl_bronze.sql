
USE Dummydb;
GO


IF OBJECT_ID('bronze.products', 'U') IS NOT NULL
	DROP TABLE bronze.products;
GO


CREATE TABLE bronze.products(
	product_id INT PRIMARY KEY,
	title NVARCHAR(50),
	description NVARCHAR(256),
	category NVARCHAR(50),
	price DECIMAL(10,2),
	discount_percentage DECIMAL(10,2),
	rating DECIMAL(10,2),
	stock INT,
	tags NVARCHAR(256),
	brand NVARCHAR(50),
	sku NVARCHAR(50),
	weight INT,
	warranty_information NVARCHAR(50),
	shipping_information NVARCHAR(50),
	availability_status NVARCHAR(50),
	reviews NVARCHAR(MAX),
	return_policy NVARCHAR(50),
	min_order_quantity INT,
	images NVARCHAR(MAX),
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



IF OBJECT_ID('bronze.carts', 'U') IS NOT NULL
	DROP TABLE bronze.carts;
GO

CREATE TABLE bronze.carts (
	order_id INT,
	products NVARCHAR(MAX),
	total DECIMAL(10,2),
	discounted_total DECIMAL(10,2),
	user_id INT,
	total_products INT,
	total_quantity INT
);
GO



IF OBJECT_ID('bronze.users', 'U') IS NOT NULL
	DROP TABLE bronze.users;
GO

CREATE TABLE bronze.users(
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



SELECT *
FROM bronze.products;
GO

SELECT *
FROM bronze.carts;
GO

SELECT *
FROM bronze.users;