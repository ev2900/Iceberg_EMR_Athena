
-- 1. Create database
CREATE DATABASE iceberg_database

-- 2. Create iceberg table
CREATE TABLE iceberg_database.amazon_reviews_iceberg (
    marketplace string,
    customer_id string,
    review_id string,
    product_id string,
    product_parent string,
    product_title string,
    star_rating int,
    helpful_votes int,
    total_votes int,
    vine string,
    verified_purchase string,
    review_headline string,
    review_body string,
    review_date bigint,
    year int,
    product_category string
)
PARTITIONED BY (product_category)
LOCATION 's3://<<update-s3-bucket>>/amazon_reviews_iceberg/'
TBLPROPERTIES (
    'table_type'='ICEBERG',
    'format'='parquet',
    'write_target_data_file_size_bytes'='536870912'
)

-- 3. Query empty iceberg table
SELECT * FROM "iceberg_database"."amazon_reviews_iceberg" limit 10

-- 4. Populate the iceberg table w 6,397,681
INSERT INTO iceberg_database.amazon_reviews_iceberg
SELECT *
FROM default.amazon_reviews_parquet
WHERE product_category in ('Gift_Card', 'Apparel','Software')

-- 3. Re-Query iceberg table w data
SELECT * FROM "iceberg_database"."amazon_reviews_iceberg" LIMIT 10