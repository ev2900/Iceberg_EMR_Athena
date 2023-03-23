--
-- Schema Evolution
--

-- Add new column
ALTER TABLE iceberg_database.amazon_reviews_iceberg ADD COLUMNS (comment string)

-- Populare column
UPDATE iceberg_database.amazon_reviews_iceberg SET comment = 'High rated' WHERE star_rating >=4

-- Verify 
SELECT * FROM iceberg_database.amazon_reviews_iceberg WHERE star_rating >=4 LIMIT 10

--
-- Time travel and version travel queries
--

-- View snapshots
SELECT * FROM "iceberg_database"."amazon_reviews_iceberg$iceberg_history"

-- Query data From past snapshot
SELECT * FROM iceberg_database.amazon_reviews_iceberg FOR SYSTEM_VERSION AS OF  <<replace snapshot_id>> WHERE marketplace ='UK' LIMIT 10

-- Quert data from past time
SELECT * FROM iceberg_database.amazon_reviews_iceberg for SYSTEM_TIME as of  TIMESTAMP '<<replace with made_current_at time>>' where marketplace ='UK' LIMIT 10

--
-- Delete rows
--

-- Delete rows
DELETE FROM iceberg_database.amazon_reviews_iceberg WHERE product_category = 'Software'

-- Verify 
SELECT * FROM iceberg_database.amazon_reviews_iceberg WHERE product_category = 'Software'

--
-- Retrieve deleted data
--

-- View snapshots
SELECT * FROM "iceberg_database"."amazon_reviews_iceberg$iceberg_history"

-- Select 2nd snapshot ID
INSERT INTO iceberg_database.amazon_reviews_iceberg
SELECT * FROM iceberg_database.amazon_reviews_iceberg FOR SYSTEM_VERSION AS OF  <<Enter Snapshot ID>>
WHERE product_category = 'Software' LIMIT 10

-- Verify
SELECT * FROM iceberg_database.amazon_reviews_iceberg WHERE product_category = 'Software' LIMIT 10