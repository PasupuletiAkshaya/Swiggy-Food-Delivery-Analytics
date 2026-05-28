-- Business Problems
-- Q.1 How many restaurants are currently listed on the Swiggy platform?
SELECT COUNT(*) AS total_restaurants
FROM restaurants;

-- Q.2 Which cities have the highest number of restaurants listed on the platform?
SELECT 
    City,
    COUNT(*) AS total_restaurants
FROM restaurants
GROUP BY City
ORDER BY total_restaurants DESC;

-- Q.3 Which cities experience the highest and lowest average delivery times?
SELECT 
    City,
    ROUND(AVG(`Delivery time`), 2) AS avg_delivery_time
FROM restaurants
GROUP BY City
ORDER BY avg_delivery_time DESC;

-- Q.4 Which restaurants have the highest average order pricing?
SELECT 
    Restaurant,
    City,
    Price
FROM restaurants
ORDER BY Price DESC
LIMIT 10;

-- Q.5 Which restaurants have received the highest customer ratings?
SELECT 
    Restaurant,
    City,
    `Avg ratings`
FROM restaurants
ORDER BY `Avg ratings` DESC
LIMIT 10; 

-- Q.6 Which cities have the highest average restaurant pricing?
SELECT 
    City,
    ROUND(AVG(Price), 2) AS avg_price
FROM restaurants
GROUP BY City
ORDER BY avg_price DESC;

-- Q.7 Which cities have more than 1000 restaurants listed on the platform?
SELECT 
    City,
    COUNT(*) AS total_restaurants
FROM restaurants
GROUP BY City
HAVING COUNT(*) > 1000
ORDER BY total_restaurants DESC;

-- Q.8 Which restaurants maintain both high ratings and high customer engagement?
SELECT 
    Restaurant,
    City,
    `Avg ratings`,
    `Total ratings`
FROM restaurants
WHERE `Avg ratings` >= 4.5
AND `Total ratings` >= 100
ORDER BY `Total ratings` DESC;

-- Q.9 Which restaurants provide the fastest delivery service?
SELECT 
    Restaurant,
    City,
    `Delivery time`
FROM restaurants
ORDER BY `Delivery time` ASC
LIMIT 10;

-- Q.10 How can restaurants be categorized based on pricing levels?
SELECT 
    Restaurant,
    Price,
    CASE
        WHEN Price < 200 THEN 'Budget'
        WHEN Price BETWEEN 200 AND 500 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS price_category
FROM restaurants;

-- Q.11 How do restaurants rank within their respective cities based on customer ratings?
SELECT 
    Restaurant,
    City,
    `Avg ratings`,
    `Total ratings`,
    ROW_NUMBER() OVER(
        PARTITION BY City
        ORDER BY `Avg ratings` DESC,
                 `Total ratings` DESC
    ) AS restaurant_rank
FROM restaurants
WHERE `Total ratings` >= 100;

-- Q.12 Which are the top-performing restaurants in every city?
WITH ranked_restaurants AS (
    SELECT 
        Restaurant,
        City,
        `Avg ratings`,
        `Total ratings`,
        ROW_NUMBER() OVER(
            PARTITION BY City
            ORDER BY `Avg ratings` DESC,
                     `Total ratings` DESC) AS restaurant_rank
    FROM restaurants
    WHERE `Total ratings` >= 100)
SELECT *
FROM ranked_restaurants
WHERE restaurant_rank <= 3;

-- Q.13 How does each restaurant’s pricing compare with the average pricing of its city?
SELECT 
    Restaurant,
    City,
    Price,
    ROUND(AVG(Price) OVER(PARTITION BY City),2) AS city_avg_price
FROM restaurants; 

-- Q.14 Which restaurants perform better than their city’s average customer rating?
WITH cte AS (
SELECT 
    Restaurant,
    City,
    `Avg ratings` AS restaurant_rating,
    ROUND(
        AVG(`Avg ratings`) 
        OVER(PARTITION BY City),2
    ) AS city_avg_rating
FROM restaurants)
SELECT * FROM cte
WHERE restaurant_rating > city_avg_rating;

-- Q.15 Which restaurants receive the highest customer engagement based on total ratings?
SELECT 
    Restaurant,
    City,
    `Total ratings`,
    DENSE_RANK() OVER(
        ORDER BY `Total ratings` DESC
    ) AS ranking
FROM restaurants;