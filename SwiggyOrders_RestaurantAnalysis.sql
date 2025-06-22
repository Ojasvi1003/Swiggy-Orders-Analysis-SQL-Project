-- Favorite restaurants
SELECT restaurant, COUNT(*) AS order_count
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY restaurant
ORDER BY order_count DESC;

-- Restaurants with highest revenues
SELECT restaurant, SUM(total_amount) AS revenue
FROM swiggy_orders_dataset 
WHERE delivery_status != 'Cancelled'
GROUP BY restaurant 
ORDER BY revenue DESC;

-- Restaurants with high average order value
SELECT restaurant, AVG(total_amount) AS avg_order_value
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY restaurant 
ORDER BY avg_order_value DESC;

-- Best-selling item per restaurant
WITH RankedItems AS (
  SELECT restaurant, item, COUNT(*) AS order_item_count, DENSE_RANK() OVER (PARTITION BY restaurant ORDER BY COUNT(*) DESC) AS rank
  FROM swiggy_orders_dataset
  WHERE delivery_status != 'Cancelled'
  GROUP BY restaurant, item
)
SELECT restaurant, item, order_item_count
FROM RankedItems
WHERE rank = 1;

-- First and Last Order Time per Restaurant
SELECT 
    restaurant,
    MIN(order_time) AS first_order_time,
    MAX(order_time) AS last_order_time,
	DATEDIFF(HOUR, MIN(order_time), MAX(order_time)) AS business_hours
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY restaurant
ORDER BY business_hours DESC;