

SELECT
	product_id,
	COUNT(*) AS id_count
FROM silver.products
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;


SELECT 
	DISTINCT category
FROM silver.products;

SELECT 
	DISTINCT subcategory
FROM silver.products;

SELECT
	price,
	discount_percentage,
	rating,
	stock,
	min_order_quantity,
	dimension_width,
	dimension_height,
	dimension_depth
FROM silver.products
WHERE price <= 0
OR discount_percentage < 0
OR rating <= 0
OR stock < 0
OR min_order_quantity <=0
OR dimension_width <= 0
OR dimension_height <= 0
OR dimension_depth <= 0;


SELECT
	DISTINCT brand
FROM silver.products;


SELECT *
FROM silver.products
WHERE brand IS NULL;


SELECT 
	sku,
	COUNT(*) AS sku_count
FROM silver.products
GROUP BY sku
HAVING COUNT(*) > 1 OR sku IS NULL;

SELECT 
	sku
FROM silver.products
WHERE sku NOT LIKE '[A-Z][A-Z][A-Z]-[A-Z][A-Z][A-Z]-[A-Z][A-Z][A-Z]-[0-9][0-9][0-9]';


SELECT 
	DISTINCT warranty_information
FROM silver.products;


SELECT 
	DISTINCT shipping_information 
FROM silver.products;


SELECT 
	DISTINCT availability_status 
FROM silver.products;



SELECT thumbnail
FROM silver.products
WHERE NOT (
    thumbnail LIKE '%.webp'
    AND thumbnail LIKE 'https://cdn.dummyjson.com/product-images/%'
);


SELECT 
	meta_created_at,
	meta_updated_at
FROM silver.products
WHERE meta_created_at > GETDATE() 
OR YEAR(meta_created_at) < 2025
OR meta_updated_at > GETDATE() 
OR YEAR(meta_updated_at) < 2025
OR LEN(meta_created_at) <> 34
OR LEN(meta_updated_at) <> 34;







SELECT 
	order_id,
	product_id,
	COUNT(*)
FROM silver.carts
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


SELECT
	DISTINCT user_id
FROM silver.carts
WHERE user_id NOT IN (
SELECT 
	DISTINCT user_id
FROM silver.users)
ORDER BY user_id;


SELECT
	DISTINCT product_id
FROM silver.carts
WHERE product_id NOT IN (
SELECT 
	DISTINCT product_id
FROM silver.products)
ORDER BY product_id;


SELECT
	total,
	discounted_total,
	total_products,
	total_quantity,
	product_price,
	product_quantity,
	product_total,
	product_discount_percentage,
	product_discounted_total
FROM silver.carts
WHERE total <= 0
OR discounted_total <= 0
OR total_products <= 0
OR total_quantity < 0
OR product_price <= 0
OR product_quantity <=0
OR product_total <= 0
OR product_discount_percentage < 0
OR product_discounted_total <= 0;


SELECT
    order_id,
    COUNT(DISTINCT total) AS total_var,
    COUNT(DISTINCT discounted_total) AS discounted_total_var,
    COUNT(DISTINCT user_id) AS user_id_var,
    COUNT(DISTINCT total_products) AS total_products_var,
    COUNT(DISTINCT total_quantity) AS total_quantity_var
FROM silver.carts
GROUP BY order_id
HAVING 
    COUNT(DISTINCT total) > 1 OR
    COUNT(DISTINCT discounted_total) > 1 OR
    COUNT(DISTINCT user_id) > 1 OR
    COUNT(DISTINCT total_products) > 1 OR
    COUNT(DISTINCT total_quantity) > 1;


SELECT
	order_id,
	COUNT(DISTINCT product_id) AS product_count,
	total_products
FROM silver.carts
GROUP BY order_id, total_products
HAVING COUNT(DISTINCT product_id) <> total_products
ORDER BY order_id;


SELECT 
	order_id,
	total_quantity,
	SUM(product_quantity) AS calculated_quantity
FROM silver.carts
GROUP BY order_id, total_quantity
HAVING total_quantity <> SUM(product_quantity)
ORDER BY order_id;




SELECT
	product_total,
	product_price * product_quantity AS total_product_price
FROM silver.carts
WHERE product_total <> product_price * product_quantity;


SELECT
	product_discounted_total,
	ROUND(product_total * (1 - product_discount_percentage / 100), 2) AS calculated_total
FROM silver.carts
WHERE product_discounted_total <> ROUND(product_total * (1 - product_discount_percentage / 100), 2);


SELECT
	order_id,
	total,
	ROUND(SUM(product_total), 2) AS calculated_total
FROM silver.carts
GROUP BY order_id, total
HAVING total <> ROUND(SUM(product_total), 2)
ORDER BY order_id;


SELECT
	order_id,
	discounted_total,
	ROUND(SUM(product_discounted_total), 2) AS calculated_discounted_total
FROM silver.carts
GROUP BY order_id, discounted_total
HAVING discounted_total <> ROUND(SUM(product_discounted_total), 2)
ORDER BY order_id;


SELECT product_thumbnail
FROM silver.carts
WHERE NOT (
    product_thumbnail LIKE '%/thumbnail.png'
    AND product_thumbnail LIKE 'https://cdn.dummyjson.com/products/images/%'
);




SELECT
	user_id,
	COUNT(*)
FROM silver.users 
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY user_id;


SELECT
	MIN(age) AS min_age,
	MAX(age) AS max_age
FROM silver.users;


SELECT
	age,
	birthdate,
	DATEDIFF(YEAR, birthdate, GETDATE()) 
	- CASE
		WHEN DATEADD(YEAR, DATEDIFF(YEAR, birthdate, GETDATE()), birthdate) > GETDATE() THEN 1
		ELSE 0
	END AS age_calculated
FROM silver.users;


SELECT 
	DISTINCT gender
FROM silver.users;

SELECT
	email,
	LOWER(CONCAT(first_name, '.', last_name, '@x.dummyjson.com')) AS email_check
FROM silver_prep.users
WHERE email <> LOWER(CONCAT(first_name, '.', last_name, '@x.dummyjson.com'));


SELECT
	phone
FROM silver.users
WHERE phone NOT LIKE '+[0-9]% [0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]';


SELECT 
	MIN(birthdate),
	MAX(birthdate)
FROM silver.users;


SELECT
	DISTINCT profession
FROM silver.users;


SELECT
	DISTINCT address_city
FROM silver.users
ORDER BY 1;


SELECT
	DISTINCT address_state
FROM silver.users
ORDER BY 1;


SELECT
	DISTINCT address_city,
	address_state,
	address_state_code
FROM silver.users
ORDER BY 2;


SELECT 
	DISTINCT address_country
FROM silver.users;


SELECT
	DISTINCT bank_card_type
FROM silver.users;


SELECT
	DISTINCT bank_currency
FROM silver.users;





SELECT
	DISTINCT product_id
FROM silver.reviews
WHERE product_id NOT IN (
	SELECT 
		DISTINCT product_id 
	FROM silver.products);


SELECT
	DISTINCT user_id
FROM silver.reviews
WHERE user_id NOT IN (
	SELECT 
		DISTINCT user_id 
	FROM silver.users);


SELECT
	rating
FROM silver.reviews
WHERE rating <= 0;


SELECT 
    r.review_id,
    r.user_id AS review_user_id,
    r.reviewer_name,
    r.reviewer_email,
    u.user_id AS matched_user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    u.email
FROM silver.reviews AS r
LEFT JOIN silver.users AS u
    ON r.reviewer_name = CONCAT(u.first_name, ' ', u.last_name)
    AND r.reviewer_email = u.email
WHERE 
    (r.user_id IS NOT NULL AND r.user_id <> u.user_id)
    OR (
        r.reviewer_name IS NOT NULL AND r.reviewer_name <> CONCAT(u.first_name, ' ', u.last_name)
    )
    OR (
        r.reviewer_email IS NOT NULL AND r.reviewer_email <> u.email
    );


SELECT 
	review_date
FROM silver.reviews
WHERE review_date > GETDATE() 
OR YEAR(review_date) < 2025
OR LEN(review_date) <> 34;

