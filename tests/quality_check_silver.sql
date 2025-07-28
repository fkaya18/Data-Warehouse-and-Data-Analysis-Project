/*
===============================================================================
Silver Layer Quality Checks
===============================================================================
Script Purpose:
    This script performs comprehensive quality checks for data validation and 
    integrity across the 'silver' layer tables (products, carts, users, reviews). 
    It includes checks for:
    - Duplicate and null primary keys validation.
    - Referential integrity between related tables.
    - Business rule validation (negative values, invalid ranges).
    - Data format compliance (SKUs, emails, URLs, phone numbers).
    - Cross-field consistency and calculated field accuracy.
    - Date validation and timestamp format verification.
Usage Notes:
    - Execute these checks after silver layer data transformation.
    - Review and address any anomalies identified during validation.
    - Ensures data quality before promotion to gold layer.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.users'
-- ====================================================================


-- Check for Duplicate User IDs
-- Expectation: No Results (user_id should be unique)
SELECT
	user_id,
	COUNT(*)
FROM silver.users 
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY user_id;


-- Check Age Range Boundaries
-- Expectation: Age values should fall within realistic human limits
SELECT
	MIN(age) AS min_age,
	MAX(age) AS max_age
FROM silver.users;


-- Validate Age Consistency with Birthdate
-- Expectation: age and calculated age from birthdate should match
SELECT
	age,
	birthdate,
	DATEDIFF(YEAR, birthdate, GETDATE()) 
	- CASE
		WHEN DATEADD(YEAR, DATEDIFF(YEAR, birthdate, GETDATE()), birthdate) > GETDATE() THEN 1
		ELSE 0
	END AS age_calculated
FROM silver.users;


-- Check for Gender Value Consistency
-- Expectation: A limited set of distinct and valid gender values
SELECT 
	DISTINCT gender
FROM silver.users;


-- Validate Email Format Consistency
-- Expectation: Email should match the expected naming convention
SELECT
	email,
	LOWER(CONCAT(first_name, '.', last_name, '@x.dummyjson.com')) AS email_check
FROM silver_prep.users
WHERE email <> LOWER(CONCAT(first_name, '.', last_name, '@x.dummyjson.com'));


-- Validate Phone Number Format
-- Expectation: Phone numbers should match the expected format
SELECT
	phone
FROM silver.users
WHERE phone NOT LIKE '+[0-9]% [0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]';


-- Review Unique Profession Values
-- Expectation: Validate variety and spelling consistency in professions
SELECT
	DISTINCT profession
FROM silver.users;


-- Review Distinct City Values
-- Expectation: Identify unique cities and check for duplicates or typos
SELECT
	DISTINCT address_city
FROM silver.users
ORDER BY 1;


-- Review Distinct State Values
-- Expectation: Identify unique states and check for duplicates or typos
SELECT
	DISTINCT address_state
FROM silver.users
ORDER BY 1;


-- Validate City-State-StateCode Combinations
-- Expectation: Ensure state code consistency per city and state
SELECT
	DISTINCT address_city,
	address_state,
	address_state_code
FROM silver.users
ORDER BY 2;


-- Review Distinct Country Values
-- Expectation: Only valid and correctly spelled country names
SELECT 
	DISTINCT address_country
FROM silver.users;


-- Check Bank Card Types
-- Expectation: Limited to supported card types (e.g., Visa, MasterCard)
SELECT
	DISTINCT bank_card_type
FROM silver.users;


-- Check Bank Currency Values
-- Expectation: Valid and standardized currency codes
SELECT
	DISTINCT bank_currency
FROM silver.users;



-- ====================================================================
-- Checking 'silver.products'
-- ====================================================================


-- Check for NULLs or Duplicate Product IDs
-- Expectation: No Results (product_id should be unique and not NULL)
SELECT
	product_id,
	COUNT(*) AS id_count
FROM silver.products
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;


-- Review Distinct Product Categories
-- Expectation: Clean, standardized list of product categories
SELECT 
	DISTINCT category
FROM silver.products;


-- Review Distinct Product Subcategories
-- Expectation: Clean, standardized list of product subcategories
SELECT 
	DISTINCT subcategory
FROM silver.products;


-- Identify Invalid Numeric Product Attributes
-- Expectation: All numeric values must be positive and realistic
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


-- Review Distinct Brand Names
-- Expectation: Consistent brand naming without duplicates or typos
SELECT
	DISTINCT brand
FROM silver.products;


-- Check for Missing Brand Information
SELECT *
FROM silver.products
WHERE brand IS NULL;


-- Check for NULLs or Duplicate SKUs
-- Expectation: SKU should be unique and not NULL
SELECT 
	sku,
	COUNT(*) AS sku_count
FROM silver.products
GROUP BY sku
HAVING COUNT(*) > 1 OR sku IS NULL;


-- Validate SKU Format
-- Expectation: SKU should follow the pattern 'AAA-BBB-CCC-123'
SELECT 
	sku
FROM silver.products
WHERE sku NOT LIKE '[A-Z][A-Z][A-Z]-[A-Z][A-Z][A-Z]-[A-Z][A-Z][A-Z]-[0-9][0-9][0-9]';


-- Review Distinct Warranty Information
-- Expectation: Clean and standardized warranty info
SELECT 
	DISTINCT warranty_information
FROM silver.products;


-- Review Distinct Shipping Information
-- Expectation: Standardized shipping policy descriptions
SELECT 
	DISTINCT shipping_information 
FROM silver.products;


-- Review Distinct Availability Statuses
-- Expectation: Limited and standardized values (e.g., 'In Stock', 'Out of Stock')
SELECT 
	DISTINCT availability_status 
FROM silver.products;


-- Validate Thumbnail URL Format
-- Expectation: Thumbnail should be a .webp file with a valid CDN URL
SELECT thumbnail
FROM silver.products
WHERE NOT (
    thumbnail LIKE '%.webp'
    AND thumbnail LIKE 'https://cdn.dummyjson.com/product-images/%'
);


-- Check Metadata Timestamps for Validity
-- Expectation: Dates should not be in the future or before 2025 and should match expected length
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



-- ====================================================================
-- Checking 'silver.carts'
-- ====================================================================

-- Check for Duplicate Product Entries in the Same Order
-- Expectation: Each (order_id, product_id) pair should be unique
SELECT 
	order_id,
	product_id,
	COUNT(*)
FROM silver.carts
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- Identify Invalid User References
-- Expectation: All user_id values in carts should exist in the users table
SELECT
	DISTINCT user_id
FROM silver.carts
WHERE user_id NOT IN (
SELECT 
	DISTINCT user_id
FROM silver.users)
ORDER BY user_id;


-- Identify Invalid Product References
-- Expectation: All product_id values in carts should exist in the products table
SELECT
	DISTINCT product_id
FROM silver.carts
WHERE product_id NOT IN (
SELECT 
	DISTINCT product_id
FROM silver.products)
ORDER BY product_id;


-- Identify Invalid or Negative Values in Cart and Product Fields
-- Expectation: All numeric values must be positive and logically valid
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


-- Check for Inconsistent Order-Level Aggregates
-- Expectation: Each order_id should have consistent values for order-level fields
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


-- Validate total_products Field Against Actual Product Count
-- Expectation: total_products should match COUNT of distinct product_id per order
SELECT
	order_id,
	COUNT(DISTINCT product_id) AS product_count,
	total_products
FROM silver.carts
GROUP BY order_id, total_products
HAVING COUNT(DISTINCT product_id) <> total_products
ORDER BY order_id;


-- Validate total_quantity Field Against Sum of product_quantity
-- Expectation: total_quantity should equal sum of product_quantity per order
SELECT 
	order_id,
	total_quantity,
	SUM(product_quantity) AS calculated_quantity
FROM silver.carts
GROUP BY order_id, total_quantity
HAVING total_quantity <> SUM(product_quantity)
ORDER BY order_id;


-- Validate product_total Calculation
-- Expectation: product_total = product_price × product_quantity
SELECT
	product_total,
	product_price * product_quantity AS total_product_price
FROM silver.carts
WHERE product_total <> product_price * product_quantity;


-- Validate product_discounted_total Calculation
-- Expectation: product_discounted_total = product_total × (1 - discount%)
SELECT
	product_discounted_total,
	ROUND(product_total * (1 - product_discount_percentage / 100), 2) AS calculated_total
FROM silver.carts
WHERE product_discounted_total <> ROUND(product_total * (1 - product_discount_percentage / 100), 2);


-- Validate total Amount per Order
-- Expectation: total = SUM of product_total for the order
SELECT
	order_id,
	total,
	ROUND(SUM(product_total), 2) AS calculated_total
FROM silver.carts
GROUP BY order_id, total
HAVING total <> ROUND(SUM(product_total), 2)
ORDER BY order_id;


-- Validate discounted_total Amount per Order
-- Expectation: discounted_total = SUM of product_discounted_total for the order
SELECT
	order_id,
	discounted_total,
	ROUND(SUM(product_discounted_total), 2) AS calculated_discounted_total
FROM silver.carts
GROUP BY order_id, discounted_total
HAVING discounted_total <> ROUND(SUM(product_discounted_total), 2)
ORDER BY order_id;


-- Validate Thumbnail URL Format
-- Expectation: Thumbnails must be .png files from the correct CDN path
SELECT product_thumbnail
FROM silver.carts
WHERE NOT (
    product_thumbnail LIKE '%/thumbnail.png'
    AND product_thumbnail LIKE 'https://cdn.dummyjson.com/products/images/%'
);



-- ====================================================================
-- Checking 'silver.reviews'
-- ====================================================================

-- Check for Duplicate Review IDs
-- Expectation: No Results (review_id should be unique)
SELECT
	review_id,
	COUNT(*) AS id_count
FROM silver.reviews
HAVING COUNT(*) > 1;


-- Identify Invalid Product References in Reviews
-- Expectation: All product_id values in reviews should exist in the products table
SELECT
	DISTINCT product_id
FROM silver.reviews
WHERE product_id NOT IN (
	SELECT 
		DISTINCT product_id 
	FROM silver.products);


-- Identify Invalid User References in Reviews
-- Expectation: All user_id values in reviews should exist in the users table
SELECT
	DISTINCT user_id
FROM silver.reviews
WHERE user_id NOT IN (
	SELECT 
		DISTINCT user_id 
	FROM silver.users);


-- Detect Invalid Rating Values
-- Expectation: Ratings should be positive and within a valid range
SELECT
	rating
FROM silver.reviews
WHERE rating <= 0;


-- Validate Reviewer Identity Matching
-- Expectation: reviewer_name and reviewer_email should match the corresponding user_id from the users table
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

-- Validate Review Date Consistency
-- Expectation: review_date should not be in the future or before 2025, and should have correct length
SELECT 
	review_date
FROM silver.reviews
WHERE review_date > GETDATE() 
OR YEAR(review_date) < 2025
OR LEN(review_date) <> 34;

