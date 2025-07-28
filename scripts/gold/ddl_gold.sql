USE Dummydb;
GO

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers
GO


CREATE VIEW gold.dim_customers AS 
SELECT
	user_id AS customer_id,
	first_name,
	last_name,
	maiden_name,
	age,
    gender,
    email,
    phone,
    birthdate,
	profession,
    address_city AS city,
    address_state AS state,
    address_state_code AS state_code,
    address_country AS country
FROM silver.users;
GO


IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
	product_id,
	title AS product,
	description,
	brand,
	sku,
	category,
	subcategory,
	price,
	discount_percentage,
	discounted_price,
	rating,
	stock,
	warranty_information,
	shipping_information,
	availability_status,
	return_policy,
	min_order_quantity,
	thumbnail
FROM silver.products;
GO


IF OBJECT_ID('gold.dim_reviews', 'V') IS NOT NULL
    DROP VIEW gold.dim_reviews;
GO

CREATE VIEW gold.dim_reviews AS
SELECT
	review_id,
	product_id,
	user_id AS customer_id,
	reviewer_name,
	reviewer_email,
	comment,
	rating,
	review_date
FROM silver.reviews;
GO

IF OBJECT_ID('gold.fact_orders', 'V') IS NOT NULL
    DROP VIEW gold.fact_orders;
GO

CREATE VIEW gold.fact_orders AS
SELECT
	order_id,
	product_id,
	user_id AS customer_id,
	product_title AS product_name,
	product_price,
	product_quantity,
	product_total,
	product_discount_percentage,
	product_discounted_total,
	total_products,
	total_quantity,
	total AS total_price,
	discounted_total AS discounted_total_price,
	product_thumbnail
FROM silver.carts;

