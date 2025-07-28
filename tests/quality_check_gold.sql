/*
===============================================================================
Gold Layer Quality Checks
===============================================================================
Script Purpose:
    This script performs final quality validation checks across the 'gold' layer 
    dimensional model (dim_customers, dim_products, dim_reviews, fact_orders). 
    It includes checks for:
    - Primary key uniqueness and completeness validation.
    - Dimensional integrity across fact and dimension tables.
    - Composite key validation for fact tables.
    - Cross-dimensional consistency verification.
    - Final data integrity assessment before consumption.
Usage Notes:
    - Run these checks after gold layer dimensional modeling completion.
    - Verify all relationships and constraints before enabling analytical queries.
    - Confirms data warehouse readiness for business intelligence consumption.
===============================================================================
*/

USE Dummydb;
GO

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================

-- Check for NULL or Duplicate Customer IDs
-- Expectation: customer_id should be unique and not NULL
SELECT
	customer_id,
	COUNT(*) AS id_count
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;


-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================

-- Check for NULL or Duplicate Product IDs
-- Expectation: product_id should be unique and not NULL
SELECT
	product_id,
	COUNT(*) AS id_count
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;


-- ====================================================================
-- Checking 'gold.dim_reviews'
-- ====================================================================

-- Check for NULL or Duplicate Review IDs
-- Expectation: review_id should be unique and not NULL
SELECT
	review_id,
	COUNT(*) AS id_count
FROM gold.dim_reviews
GROUP BY review_id
HAVING COUNT(*) > 1 OR review_id IS NULL;


-- Check for Duplicate Reviews by the Same Customer for the Same Product
-- Expectation: Each (product_id, customer_id) pair should only appear once
SELECT 
    product_id,
    customer_id,
    COUNT(*) AS review_count,
    MIN(review_id) AS min_review_id,
    MAX(review_id) AS max_review_id
FROM gold.dim_reviews
GROUP BY product_id, customer_id
HAVING COUNT(*) > 1


-- ====================================================================
-- Checking 'gold.fact_orders'
-- ====================================================================

-- Check for NULLs or Duplicate Order-Product Pairs
-- Expectation: Each (order_id, product_id) pair should be unique and non-NULL
SELECT
	order_id,
	product_id,
	COUNT(*) AS id_count
FROM gold.fact_orders
GROUP BY order_id, product_id
HAVING COUNT(*) > 1 OR order_id IS NULL OR product_id IS NULL;


-- Check the data model connectivity between fact and dimensions
SELECT *
FROM gold.fact_orders AS o
LEFT JOIN gold.dim_customers AS c
ON o.customer_id = c.customer_id
LEFT JOIN gold.dim_products AS p
ON o.product_id = p.product_id
LEFT JOIN gold.dim_reviews AS r
ON o.product_id = r.product_id AND o.customer_id = r.customer_id
ORDER BY order_id;




