
# 📦 Bicycle Store Data Catalog – Star Schema Documentation

This data catalog documents the **Gold Layer** of the bicycle store data warehouse, modeled using a **Star Schema**. It contains one central **fact table** and two related **dimension tables**: `customers`, `products`, and `sales`.

---

## ⭐ Star Schema Overview

- **Fact Table**: `gold.sales.fact` – contains transactional sales data.
- **Dimension Tables**:
  - `gold.customers_dim` – describes customers.
  - `gold.products_dim` – describes products.

---

## 📄 Table: `gold.customers_dim`

| Column Name          | Data Type | Description                                      | Example        |
|----------------------|-----------|--------------------------------------------------|----------------|
| `customer_key_surr`  | ?         | Surrogate key for the customer (PK)              | 101            |
| `customer_id`        | ?         | Natural key or business identifier               | CUST0001       |
| `customer_number`    | ?         | Possibly a store-specific number                 | 558392         |
| `first_name`         | string?   | Customer's first name                            | John           |
| `last_name`          | string?   | Customer's last name                             | Doe            |
| `marital_status`     | string?   | Marital status of customer                       | Married        |
| `birthdate`          | date?     | Customer's date of birth                         | 1985-07-21     |
| `gender`             | string?   | Gender                                           | Male           |
| `country`            | string?   | Country of residence                             | Netherlands    |
| `record_create_date` | date?     | Date the customer was registered (ETL metadata)  | 2021-04-01     |

---

## 📄 Table: `gold.sales.fact`

| Column Name          | Data Type | Description                                      | Example        |
|----------------------|-----------|--------------------------------------------------|----------------|
| `order_number`       | ?         | Unique ID for each order                         | ORD123456      |
| `product_key_surr`   | ?         | FK to product dimension                          | 205            |
| `customer_key_surr`  | ?         | FK to customer dimension                         | 101            |
| `order_date`         | date?     | Date when the order was placed                   | 2023-07-10     |
| `order_ship_date`    | date?     | Date when the order was shipped                  | 2023-07-12     |
| `order_due_date`     | date?     | Promised delivery date                           | 2023-07-14     |
| `sale_price`         | decimal?  | Total amount of the sale                         | 249.99         |
| `sale_quantity`      | int?      | Number of units sold                             | 2              |
| `item_price`         | decimal?  | Price per individual item                        | 124.99         |

---

## 📄 Table: `gold.products_dim`

| Column Name              | Data Type | Description                                         | Example        |
|--------------------------|-----------|-----------------------------------------------------|----------------|
| `product_key_surr`       | ?         | Surrogate key for product (PK)                      | 205            |
| `product_id`             | ?         | Natural/business identifier                         | PROD001        |
| `category_id`            | ?         | Reference to category                               | CAT10          |
| `product_number`         | string?   | Internal product number                             | BIK-29382      |
| `product_name`           | string?   | Name of the product                                 | Mountain Bike  |
| `product_cost`           | decimal?  | Cost to produce or acquire the product              | 99.50          |
| `product_line`           | string?   | Product line classification                         | Sports         |
| `product_category`       | string?   | High-level category                                 | Bikes          |
| `product_subcategory_name` | string? | Subcategory name                                    | Mountain       |
| `maintenance`            | boolean?  | Indicates if product includes maintenance service   | false          |
| `product_start_sell_date`| date?     | Start date for product being on sale                | 2022-01-01     |
| `product_end_sell_date`  | date?     | End date (if retired) of product                    | NULL           |

---

## 📌 Notes

- Foreign keys in the `gold.sales.fact` table link to surrogate keys in the dimension tables.
- `record_create_date` and `product_start_sell_date` can be useful for historical tracking or SCD (slowly changing dimension) analysis.

---

_Last updated: November 2025_
