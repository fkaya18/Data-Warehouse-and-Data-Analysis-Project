USE Dummydb;
GO


IF OBJECT_ID('silver.products', 'U') IS NOT NULL
	DROP TABLE silver.products
GO

CREATE TABLE silver.products(
	product_id INT PRIMARY KEY,
	title NVARCHAR(50),
	description NVARCHAR(256),
	brand NVARCHAR(50),
	sku NVARCHAR(50),
	category NVARCHAR(50),
	subcategory NVARCHAR(50),
	price DECIMAL(10,2),
	discount_percentage DECIMAL(10,2),
	discounted_price DECIMAL(10,2),
	rating DECIMAL(10,2),
	stock INT,
	warranty_information NVARCHAR(50),
	shipping_information NVARCHAR(50),
	availability_status NVARCHAR(50),
	return_policy NVARCHAR(50),
	min_order_quantity INT,
	thumbnail NVARCHAR(256),
	dimension_width DECIMAL(10,2),
	dimension_height DECIMAL(10,2),
	dimension_depth DECIMAL(10,2),
	meta_created_at DATETIMEOFFSET, 
	meta_updated_at DATETIMEOFFSET,
	dwh_created_date DATETIME2 DEFAULT GETDATE()
);


IF OBJECT_ID('silver.carts', 'U') IS NOT NULL
	DROP TABLE silver.carts;
GO

CREATE TABLE silver.carts(
	order_id INT,
	product_id INT,
	user_id INT,
	product_title NVARCHAR(50),
	product_price DECIMAL(10,2),
	product_quantity INT,
	product_total DECIMAL(10,2),
	product_discount_percentage DECIMAL(10,2),
	product_discounted_total DECIMAL(10,2),
	total_products INT,
	total_quantity INT,
	total DECIMAL(10,2),
	discounted_total DECIMAL(10,2),
	product_thumbnail NVARCHAR(256),
	dwh_created_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.users', 'U') IS NOT NULL
	DROP TABLE silver.users;
GO

CREATE TABLE silver.users(
	user_id INT PRIMARY KEY,
	first_name NVARCHAR(50),
	last_name NVARCHAR(50),
	maiden_name NVARCHAR(50),
	age INT,
	gender NVARCHAR(50),
	email NVARCHAR(50),
	phone NVARCHAR(50),
	birthdate DATE,
	image NVARCHAR(256),
	profession NVARCHAR(50),
	address_city NVARCHAR(50),
	address_state NVARCHAR(50),
	address_state_code NVARCHAR(50),
	address_country NVARCHAR(50),
	bank_card_type NVARCHAR(50),
	bank_currency NVARCHAR(50),
	dwh_created_date DATETIME2 DEFAULT GETDATE()
);


IF OBJECT_ID('silver.reviews', 'U') IS NOT NULL
	DROP TABLE silver.reviews
GO

CREATE TABLE silver.reviews(
	review_id INT,
	product_id INT,
	user_id INT,
	rating INT,
	comment NVARCHAR(256),
	review_date DATETIMEOFFSET,
	reviewer_name NVARCHAR(50),
	reviewer_email NVARCHAR(50),
	dwh_created_date DATETIME2 DEFAULT GETDATE()
);
GO
