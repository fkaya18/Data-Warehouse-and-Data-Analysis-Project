USE Dummydb;
GO

SELECT
	customer_id,
	COUNT(*) AS id_count
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;


SELECT
	product_id,
	COUNT(*) AS id_count
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;


SELECT
	review_id,
	COUNT(*) AS id_count
FROM gold.dim_reviews
GROUP BY review_id
HAVING COUNT(*) > 1 OR review_id IS NULL;


SELECT
	order_id,
	product_id,
	COUNT(*) AS id_count
FROM gold.fact_orders
GROUP BY order_id, product_id
HAVING COUNT(*) > 1 OR order_id IS NULL OR product_id IS NULL;


SELECT 
    product_id,
    customer_id,
    COUNT(*) AS review_count,
    MIN(review_id) AS min_review_id,
    MAX(review_id) AS max_review_id
FROM gold.dim_reviews
GROUP BY product_id, customer_id
HAVING COUNT(*) > 1


SELECT *
FROM gold.fact_orders AS o
LEFT JOIN gold.dim_customers AS c
ON o.customer_id = c.customer_id
LEFT JOIN gold.dim_products AS p
ON o.product_id = p.product_id
LEFT JOIN gold.dim_reviews AS r
ON o.product_id = r.product_id AND o.customer_id = r.customer_id
ORDER BY order_id;




