# Data Catalog for Gold Layer

## Overview

The Gold Layer represents business-level data, organized specifically to support analysis and reporting. It includes dimension and fact tables that focus on key business metrics.

---

### 1. **gold.dim_customers**

**Purpose:** Stores detailed demographic and personal information about customers for analysis and reporting.

**Columns:**

| Column Name   | Data Type    | Description                                                                 |
|---------------|--------------|-----------------------------------------------------------------------------|
| customer_id   | INT          | Unique identifier for each customer.                                       |
| first_name    | NVARCHAR     | Customer's first name.                                                     |
| last_name     | NVARCHAR     | Customer's last or family name.                                            |
| maiden_name   | NVARCHAR     | Customer's maiden name (if applicable).                                    |
| age           | INT          | Customer's age.                                                            |
| gender        | NVARCHAR     | Gender of the customer (e.g., 'Male', 'Female').                           |
| email         | NVARCHAR     | Email address of the customer.                                             |
| phone         | NVARCHAR     | Contact phone number of the customer.                                      |
| birthdate     | DATE         | Customer's date of birth (YYYY-MM-DD).                                     |
| profession    | NVARCHAR     | Customer's profession.                                                     |
| city          | NVARCHAR     | City of residence.                                                         |
| state         | NVARCHAR     | State of residence.                                                        |
| state_code    | NVARCHAR     | Abbreviated code of the state.                                             |
| country       | NVARCHAR     | Country of residence (e.g., 'United States', 'Germany').                   |

---

### 2. **gold.dim_products**

**Purpose:** Contains descriptive information about products including pricing, categories, and shipping details.

**Columns:**


| Column Name           | Data Type    | Description                                                                 |
|------------------------|--------------|-----------------------------------------------------------------------------|
| product_id            | INT          | Unique identifier for each product.                                         |
| product               | NVARCHAR     | Name of the product.                                                        |
| description           | NVARCHAR     | Detailed description of the product.                                        |
| brand                 | NVARCHAR     | Product brand.                                                              |
| sku                   | NVARCHAR     | Stock Keeping Unit — unique identifier used by retailers.                  |
| category              | NVARCHAR     | Main category of the product.                                               |
| subcategory           | NVARCHAR     | Subcategory under the main category.                                        |
| price                 | DECIMAL      | Original price of the product.                                              |
| discount_percentage   | DECIMAL      | Discount applied on the product (e.g., 15.5).                               |
| discounted_price      | DECIMAL      | Final price after applying the discount.                                   |
| rating                | DECIMAL      | Average product rating.                                                    |
| stock                 | INT          | Available stock quantity.                                                   |
| warranty_information  | NVARCHAR     | Warranty duration (e.g., '2 year', '3 months')                              |
| shipping_information  | NVARCHAR     | Shipping time (e.g., 'overnight', '3-5 business days').                     |
| availability_status   | NVARCHAR     | Availability flag (e.g., 'In Stock', 'Out of Stock').                       |
| return_policy         | NVARCHAR     | Return period (e.g., 'No return', '30 days', '60 days').                    |
| min_order_quantity    | INT          | Minimum orderable quantity.                                                 |
| thumbnail             | NVARCHAR     | URL or path to the product thumbnail image.                                 |


---

### 3. **gold.dim_reviews**

**Purpose:** Captures customer feedback and ratings on products to assess satisfaction and quality.

**Columns:**


| Column Name     | Data Type    | Description                                                                 |
|------------------|--------------|-----------------------------------------------------------------------------|
| review_id       | INT          | Unique identifier for each review.                                          |
| product_id      | INT          | Foreign key referencing the reviewed product.                               |
| customer_id     | INT          | Foreign key referencing the customer who wrote the review.                  |
| reviewer_name   | NVARCHAR     | Name of the reviewer.                                                       |
| reviewer_email  | NVARCHAR     | Email address of the reviewer.                                              |
| comment         | NVARCHAR     | Review content or comment.                                                  |
| rating          | INT          | Rating score given by the reviewer.                                         |
| review_date     | DATETIMEOFFSET | Date when the review was submitted.                                       |


---

### 4. **gold.fact_orders**

**Purpose:** Tracks transactional sales data by linking customers and products, including pricing and quantity metrics.

**Columns:**


| Column Name               | Data Type    | Description                                                                 |
|----------------------------|--------------|-----------------------------------------------------------------------------|
| order_id                 | INT          | Identifier of the order. Part of the composite primary key with `product_id`. |
| product_id              | INT          | Identifier of the ordered product. Part of the composite primary key with `order_id`. |
| customer_id             | INT          | ID of the customer who made the order.                                      |
| product_name            | NVARCHAR     | Name of the product.                                                        |
| product_price           | DECIMAL      | Original price of the product at order time.                                |
| product_quantity        | INT          | Quantity of the product ordered.                                            |
| product_total           | DECIMAL      | Total price without discount (product_price × product_quantity).            |
| product_discount_percentage | DECIMAL  | Discount rate applied on the product.                                       |
| product_discounted_total | DECIMAL     | Total price after discount.                                                 |
| total_products          | INT          | Total number of different products in the order.                            |
| total_quantity          | INT          | Total quantity of all items ordered.                                        |
| total_price             | DECIMAL      | Total order price before discount.                                          |
| discounted_total_price  | DECIMAL      | Final price after applying all discounts.                                   |
| product_thumbnail       | NVARCHAR     | URL or path to the product image in the order.                              |

