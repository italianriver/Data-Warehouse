
#  B Store Data Catalog 

This data catalog documents the **Gold Layer** of the b store data warehouse, modeled using a **Star Schema**. It contains one central **fact table** `sales` and two related **dimension tables**: `customers` and `products`. The Gold Layer represents business-level data and is structured to enable reporting and analytics.

---

## Star Schema Overview

- **Fact Table**: `gold.sales.fact` – contains transactional sales data.
- **Dimension Tables**:
  - `gold.customers_dim` – describes customers.
  - `gold.products_dim` – describes products.

---

## Table: `gold.customers_dim`
**Description:** A dimension table that stores enriched customer profile data, including personal details, demographics, and origin from both CRM and ERP systems.

| Column Name          | Data Type | Description                                              
|----------------------|-----------|------------------------------------------------------------------
| `customer_key_surr`  | INT         | Surrogate key for the customer (PK)              | 
| `customer_id`        | INT         | Natural key or business identifier               | 
| `customer_number`    | INT         | Possibly a store-specific number                 | 
| `first_name`         | NVARCHAR(50)   | Customer's first name                            |
| `last_name`          | NVARCHAR(50)   | Customer's last name                             |
| `marital_status`     | NVARCHAR(50)   | Marital status of customer ('Married', 'Single')                       | 
| `birthdate`          | DATE     | Customer's date of birth, formatted as YYYY-MM-DD                         | 
| `gender`             | NVARCHAR(50)   | Gender ('Male', 'Female', 'n/a')                                           |
| `country`            | NVARCHAR(50)   | Country of residence                             | 
| `record_create_date` | DATE     | Date the customer was registered   | 

---

## Table: `gold.sales.fact`
**Description:** A dimension table containing product information such as name, category, pricing, and lifecycle dates. Combines product metadata from CRM and ERP sources to support product-level analysis.

| Column Name          | Data Type | Description                                      | 
|----------------------|-----------|--------------------------------------------------|
| `order_number`       | NVARCHAR(50)         | Unique ID for each order                         | 
| `product_key_surr`   | INT         | Foreign (surrogate) key to product dimension                          | 
| `customer_key_surr`  | INT         | Foreign (surrogate) key to customer dimension                         | 
| `order_date`         | DATE     | Date when the order was placed                   |
| `order_ship_date`    | DATE     | Date when the order was shipped                  | 
| `order_due_date`     | DATE     | Promised delivery date                           | 
| `sale_price`         | INT  | Total amount of the sale                         | 
| `sale_quantity`      | INT      | Number of units sold                             | 
| `item_price`         | INT  | Price per individual item                        | 

---

## Table: `gold.products_dim`
**Description:** The central fact table that captures sales transactions, including order dates, quantities, and pricing. Linked to product and customer dimensions to enable time-based and customer/product-level analysis..

| Column Name              | Data Type | Description                                         | 
|--------------------------|-----------|-----------------------------------------------------|
| `product_key_surr`       | INT         | Surrogate key for product (PK)                    | 
| `product_id`             |INT        | Natural/business identifier                         | 
| `category_id`            | NVARCHAR(50)         | Reference to category                         | 
| `product_number`         | NVARCHAR(50)   | Internal product number                             | 
| `product_name`           | NVARCHAR(50)   | Name of the product                                 | 
| `product_cost`           | INT  | Cost to produce or acquire the product              | 
| `product_line`           | NVARCHAR(50)   | Product line classification                         | 
| `product_category`       | NVARCHAR(50)   | High-level category                                 | 
| `product_subcategory_name` | NVARCHAR(50) | Subcategory name                                    | 
| `maintenance`            | NVARCHAR(50)  | Indicates if product includes maintenance service ('Yes', 'No')   | 
| `product_start_sell_date`| DATE     | Start date for product being on sale                | 
| `product_end_sell_date`  | DATE     | End date (if retired) of product                    | 

---

## Notes

- Foreign keys in the `gold.sales.fact` table link to surrogate keys in the dimension tables.
- `record_create_date` and `product_start_sell_date` can be useful for historical tracking or SCD (slowly changing dimension) analysis.

---

_Last updated: November 2025_
