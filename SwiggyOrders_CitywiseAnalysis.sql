--Total Orders and Revenue Per City
SELECT city, COUNT(*) AS total_orders, SUM(total_amount) AS total_revenue
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY city
ORDER BY total_revenue DESC;

--Average Order Value (AOV) Per City
SELECT city, AVG(total_amount) AS avg_order_value
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY city
ORDER BY avg_order_value DESC;

--Cancellation Rate Per City
SELECT city, COUNT(*) AS total_orders, SUM(CASE WHEN delivery_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
CAST(SUM(CASE WHEN delivery_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS cancellation_rate_percent
FROM swiggy_orders_dataset
GROUP BY city
ORDER BY cancellation_rate_percent DESC;

--Top 3 Restaurants by Revenue in Each City
WITH city_restaurant_revenue AS (
  SELECT city, restaurant, SUM(total_amount) AS revenue, RANK() OVER (PARTITION BY city ORDER BY SUM(total_amount) DESC) AS rank
  FROM swiggy_orders_dataset
  WHERE delivery_status != 'Cancelled'
  GROUP BY city, restaurant
)
SELECT city, restaurant, revenue
FROM city_restaurant_revenue
WHERE rank <= 3
ORDER BY city, revenue DESC;

--Most Ordered Item Per City
WITH city_item_orders AS (
  SELECT city, item, SUM(quantity) AS total_quantity, ROW_NUMBER() OVER (PARTITION BY city ORDER BY SUM(quantity) DESC) AS rn
  FROM swiggy_orders_dataset
  WHERE delivery_status != 'Cancelled'
  GROUP BY city, item
)
SELECT city, item, total_quantity
FROM city_item_orders
WHERE rn = 1
ORDER BY city;

--Average Delivery Time Per City
SELECT city, AVG(DATEDIFF(MINUTE, order_time, delivery_time)) AS avg_delivery_time_mins
FROM swiggy_orders_dataset
WHERE delivery_status = 'Delivered' AND delivery_time > order_time
GROUP BY city
ORDER BY avg_delivery_time_mins DESC;

--Peak Order Hour Per City
WITH hourly_orders AS (
  SELECT city, DATEPART(HOUR, order_time) AS order_hour, COUNT(*) AS total_orders
  FROM swiggy_orders_dataset
  WHERE delivery_status != 'Cancelled'
  GROUP BY city, DATEPART(HOUR, order_time)
),
ranked_hours AS (
  SELECT city, FORMAT(DATEADD(HOUR, order_hour, 0), 'HH\:00') + '-' + 
  FORMAT(DATEADD(HOUR, order_hour + 1, 0), 'HH\:00') AS order_hour_slot, total_orders,
  ROW_NUMBER() OVER (PARTITION BY city ORDER BY total_orders DESC) AS rn
  FROM hourly_orders
)
SELECT city, order_hour_slot, total_orders
FROM ranked_hours
WHERE rn = 1
ORDER BY city;

--Top Grossing Items Per City by Revenue
WITH city_item_revenue AS (
  SELECT city, item, SUM(quantity * price_per_unit) AS item_revenue, ROW_NUMBER() OVER (PARTITION BY city ORDER BY SUM(quantity * price_per_unit) DESC) AS rn
  FROM swiggy_orders_dataset
  WHERE delivery_status != 'Cancelled'
  GROUP BY city, item
)
SELECT city, item, item_revenue
FROM city_item_revenue
WHERE rn = 1
ORDER BY item_revenue DESC;