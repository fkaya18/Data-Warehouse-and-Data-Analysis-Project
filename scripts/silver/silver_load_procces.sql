USE Dummydb;
GO

INSERT INTO silver.products(
	product_id,
	title,
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
	thumbnail,
	dimension_width,
	dimension_height,
	dimension_depth,
	meta_created_at, 
	meta_updated_at	
)

SELECT
	product_id,
	title,
	description,
	brand,
	sku,
	category,
	subcategory,
	price,
	discount_percentage,
	ROUND(price * (1 - discount_percentage / 100), 2) AS discounted_price,
	rating,
	stock,
	REPLACE(warranty_information, ' warranty', '') AS warranty_information,
	LTRIM(REPLACE(REPLACE(shipping_information, 'Ships in', ''), 'Ships', '')) AS shipping_information,
	availability_status,
	CASE 
        WHEN return_policy = 'No return policy' THEN 'No return'
        ELSE LTRIM(REPLACE(return_policy, ' return policy', ''))
    END AS return_policy,
	min_order_quantity,
	thumbnail,
	dimension_width,
	dimension_height,
	dimension_depth,
	meta_created_at, 
	meta_updated_at
FROM silver_prep.products;
GO

UPDATE silver.products
SET brand = 'Nescafe'
WHERE title = 'Nescafe Coffee';
GO


INSERT INTO silver.carts(
	order_id,
	product_id,
	user_id,
	product_title,
	product_price,
	product_quantity,
	product_total,
	product_discount_percentage,
	product_discounted_total,
	total_products,
	total_quantity,
	total,
	discounted_total,
	product_thumbnail
)

SELECT
	order_id,
	product_id,
	user_id,
	product_title,
	product_price,
	product_quantity,
	product_total,
	product_discount_percentage,
	product_discounted_total,
	total_products,
	total_quantity,
	total,
	discounted_total,
	product_thumbnail
FROM silver_prep.carts;
GO

INSERT INTO silver.users(
	user_id,
	first_name,
	last_name,
	maiden_name,
	age,
	gender,
	email,
	phone,
	birthdate,
	image,
	profession,
	address_city,
	address_state,
	address_state_code,
	address_country,
	bank_card_type,
	bank_currency
)

SELECT 
	user_id,
	first_name,
	last_name,
	maiden_name,
	DATEDIFF(YEAR, birthdate, GETDATE()) 
	- CASE
		WHEN DATEADD(YEAR, DATEDIFF(YEAR, birthdate, GETDATE()), birthdate) > GETDATE() THEN 1
		ELSE 0
	END AS age,
	CASE
		WHEN gender = 'female' THEN 'Female'
		ELSE 'Male'
	END AS gender,
	email,
	phone,
	birthdate,
	image,
	company_title,
	address_city,
	CASE
		WHEN address_city = 'Phoenix' THEN 'Arizona'
		WHEN address_city = 'Denver'  THEN 'Colorado'
		WHEN address_city IN ('Los Angeles','San Diego','San Francisco','San Jose') THEN 'California'
		WHEN address_city = 'Jacksonville' THEN 'Florida'
		WHEN address_city = 'Indianapolis' THEN 'Indiana'
		WHEN address_city = 'Chicago' THEN 'Illinois'
		WHEN address_city = 'Charlotte' THEN 'North Carolina'
		WHEN address_city = 'New York' THEN 'New York'
		WHEN address_city = 'Columbus' THEN 'Ohio'
		WHEN address_city = 'Philadelphia' THEN 'Pennsylvania'
		WHEN address_city IN ('Austin','Dallas','Fort Worth','Houston','San Antonio') THEN 'Texas'
		WHEN address_city = 'Seattle' THEN 'Washington'
		WHEN address_city = 'Washington' THEN 'District of Columbia'
		ELSE address_state
	END AS address_state,
	CASE
		WHEN address_city = 'Phoenix' THEN 'AZ'
		WHEN address_city = 'Denver'  THEN 'CO'
		WHEN address_city IN ('Los Angeles','San Diego','San Francisco','San Jose') THEN 'CA'
		WHEN address_city = 'Jacksonville' THEN 'FL'
		WHEN address_city = 'Indianapolis' THEN 'IN'
		WHEN address_city = 'Chicago' THEN 'IL'
		WHEN address_city = 'Charlotte' THEN 'NC'
		WHEN address_city = 'New York' THEN 'NY'
		WHEN address_city = 'Columbus' THEN 'OH'
		WHEN address_city = 'Philadelphia' THEN 'PA'
		WHEN address_city IN ('Austin','Dallas','Fort Worth','Houston','San Antonio') THEN 'TX'
		WHEN address_city = 'Seattle' THEN 'WA'
		WHEN address_city = 'Washington' THEN 'DC'
		ELSE address_state_code
	END AS address_state_code,
	address_country,
	bank_card_type,
	bank_currency
FROM silver_prep.users;
GO




WITH product_customers AS (
    SELECT
        c.product_id,
        u.user_id,
        CONCAT(u.first_name, ' ', u.last_name) AS reviewer_name,
        u.email AS reviewer_email,
        ROW_NUMBER() OVER (PARTITION BY c.product_id ORDER BY u.user_id) AS rn
    FROM silver_prep.carts c
    JOIN silver_prep.users u ON c.user_id = u.user_id
    GROUP BY c.product_id, u.user_id, u.first_name, u.last_name, u.email
),
ordered_reviews AS (
    SELECT
        r.review_id,
        r.product_id,
        r.comment,
        r.rating,
        r.date,
        ROW_NUMBER() OVER (PARTITION BY r.product_id ORDER BY r.review_id) AS rn
    FROM silver_prep.reviews r
),
matched AS (
    SELECT
		COALESCE(r.review_id, 133) AS review_id,
        pc.product_id,
        pc.user_id,
        COALESCE(r.comment, 'Nice Product') AS comment,
        COALESCE(r.rating, 4) AS rating,
        COALESCE(r.date, '2025-04-30 09:41:02.0530000 +00:00') AS review_date,
        pc.reviewer_name,
        pc.reviewer_email
    FROM product_customers pc
    LEFT JOIN ordered_reviews r
      ON pc.product_id = r.product_id AND pc.rn = r.rn
)
INSERT INTO silver.reviews(
	review_id,
	product_id,
	user_id,
	comment,
	rating,
	review_date,
	reviewer_name,
	reviewer_email
)
SELECT
	m.review_id,
	m.product_id,
	m.user_id,
	m.comment,
	m.rating,
	m.review_date,
	m.reviewer_name,
	m.reviewer_email
FROM matched m;


