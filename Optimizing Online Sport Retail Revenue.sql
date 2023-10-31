DROP TABLE IF EXISTS info;

CREATE TABLE info
(product_name VARCHAR(100),
 product_id VARCHAR(11) PRIMARY KEY,
 description VARCHAR(700)
);

DROP TABLE IF EXISTS finance;

CREATE TABLE finance
(product_id VARCHAR(11) PRIMARY KEY,
    listing_price FLOAT,
    sale_price FLOAT,
    discount FLOAT,
    revenue FLOAT
);

DROP TABLE IF EXISTS reviews;

CREATE TABLE reviews
(product_id VARCHAR(11) PRIMARY KEY,
    rating FLOAT,
    reviews FLOAT
);

DROP TABLE IF EXISTS traffic;

CREATE TABLE traffic
(product_id VARCHAR(11) PRIMARY KEY,
    last_visited TIMESTAMP
);

DROP TABLE IF EXISTS brands;

CREATE TABLE brands
(product_id VARCHAR(11) PRIMARY KEY,
    brand VARCHAR(7)
);

COPY info FROM 'D:/Projects SQL Portfolio/Optimizing Online Sports Retail Revenue/info_v2.csv' DELIMITER ',' CSV HEADER;
COPY finance FROM 'D:/Projects SQL Portfolio/Optimizing Online Sports Retail Revenue/finance.csv' DELIMITER ',' CSV HEADER;
COPY reviews FROM 'D:/Projects SQL Portfolio/Optimizing Online Sports Retail Revenue/reviews_v2.csv' DELIMITER ',' CSV HEADER;
COPY traffic FROM 'D:/Projects SQL Portfolio/Optimizing Online Sports Retail Revenue/traffic_v3.csv' DELIMITER ',' CSV HEADER;
COPY brands FROM 'D:/Projects SQL Portfolio/Optimizing Online Sports Retail Revenue/brands_v2.csv' DELIMITER ',' CSV HEADER;


-- Count all columns as total_rows
-- Count the number of non-missing entries for description, listing_price, and last_visited
-- Join info, finance, and traffic

SELECT
    COUNT(*) AS total_rows,
    COUNT(i.description) AS count_description,
    COUNT(f.listing_price) AS count_listing_price,
    COUNT(t.last_visited) AS count_last_visited
FROM info AS i
INNER JOIN finance AS f
    ON i.product_id = f.product_id
INNER JOIN traffic AS t
    ON t.product_id = f.product_id;

-- Select the brand, listing_price as an integer, and a count of all products in finance 
-- Join brands to finance on product_id
-- Filter for products with a listing_price more than zero
-- Aggregate results by brand and listing_price, and sort the results by listing_price in descending order

SELECT
    brand,
    CAST(listing_price AS integer),
    COUNT(*)
FROM brands AS b
INNER JOIN finance AS f
    ON b.product_id = f.product_id
WHERE listing_price > 0
GROUP BY brand, listing_price 
ORDER BY listing_price DESC;

-- Select the brand, a count of all products in the finance table, and total revenue
-- Create four labels for products based on their price range, aliasing as price_category
-- Join brands to finance on product_id and filter out products missing a value for brand
-- Group results by brand and price_category, sort by total_revenue

SELECT
    b.brand,
    COUNT(*),
    SUM(f.revenue) AS total_revenue,
    CASE WHEN listing_price < 42 THEN 'Budget'
        WHEN listing_price >= 42 AND listing_price < 74 THEN 'Average'
        WHEN listing_price >= 74 AND listing_price < 129 THEN 'Expensive'
        ELSE 'Elite' END AS price_category
FROM brands AS b
INNER JOIN finance AS f
    ON b.product_id = f.product_id
WHERE b.brand IS NOT NULL
GROUP BY b.brand, price_category 
ORDER BY total_revenue DESC;

-- Select brand and average_discount as a percentage
-- Join brands to finance on product_id
-- Aggregate by brand
-- Filter for products without missing values for brand

SELECT
    b.brand,
    AVG(f.discount) * 100 AS average_discount
FROM brands AS b
INNER JOIN finance AS f
    ON b.product_id = f.product_id
GROUP BY b.brand
HAVING b.brand IS NOT NULL
ORDER BY average_discount;

-- Calculate the correlation between reviews and revenue as review_revenue_corr
-- Join the reviews and finance tables on product_id

SELECT corr(r.reviews, f.revenue) AS review_revenue_corr
FROM reviews AS r
INNER JOIN finance AS f
    ON r.product_id = f.product_id;
		
-- Calculate the correlation between reviews and revenue as review_revenue_corr
-- Join the reviews and finance tables on product_id

SELECT corr(r.reviews, f.revenue) AS review_revenue_corr
FROM reviews AS r
INNER JOIN finance AS f
    ON r.product_id = f.product_id;
	
-- Select brand, month from last_visited, and a count of all products in reviews aliased as num_reviews
-- Join traffic with reviews and brands on product_id
-- Group by brand and month, filtering out missing values for brand and month
-- Order the results by brand and month

SELECT
    b.brand,
    DATE_PART('month', t.last_visited) AS month,
    COUNT(r.*) AS num_reviews
FROM brands AS b
INNER JOIN traffic AS t
    ON b.product_id = t.product_id
INNER JOIN reviews AS r
    ON t.product_id = r.product_id
GROUP BY b.brand, month
HAVING b.brand IS NOT NULL 
    AND DATE_PART('month', t.last_visited) IS NOT NULL
ORDER BY b.brand, month;

-- Create the footwear CTE, containing description and revenue
-- Filter footwear for products with a description containing %shoe%, %trainer, or %foot%
-- Also filter for products that are not missing values for description
-- Calculate the number of products and median revenue for footwear products

WITH footwear AS
    (SELECT
         i.description,
         f.revenue
     FROM info AS i
     INNER JOIN finance AS f
         ON i.product_id = f.product_id
     WHERE description ILIKE '%shoe%'
         OR description ILIKE '%trainer%'
         OR description ILIKE '%foot%'
         AND description IS NOT NULL
    )
    
SELECT
    COUNT(*) AS num_footwear_products,
    percentile_disc(0.5) within group (order by revenue) AS median_footwear_revenue
FROM footwear;

-- Copy the footwear CTE from the previous task
-- Calculate the number of products in info and median revenue from finance
-- Inner join info with finance on product_id
-- Filter the selection for products with a description not in footwear

WITH footwear AS
    (SELECT
         i.description,
         f.revenue
     FROM info AS i
     INNER JOIN finance AS f
         ON i.product_id = f.product_id
     WHERE description ILIKE '%shoe%'
         OR description ILIKE '%trainer%'
         OR description ILIKE '%foot%'
         AND description IS NOT NULL
    )

SELECT
    COUNT(i.*) AS num_clothing_products,
    percentile_disc(0.5) within group (order by f.revenue) AS median_clothing_revenue
FROM info AS i
INNER JOIN finance AS f
    ON i.product_id = f.product_id
WHERE description NOT IN (
                        SELECT description
                        FROM footwear);









	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	











