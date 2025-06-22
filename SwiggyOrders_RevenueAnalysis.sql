-- Total revenue
SELECT SUM(total_amount) AS total_revenue 
FROM swiggy_orders_dataset
WHERE delivery_status !='Cancelled';

-- Item-wise revenue
SELECT item, SUM(quantity*price_per_unit) as item_revenue 
FROM swiggy_orders_dataset 
WHERE delivery_status !='Cancelled'
GROUP BY item;

-- Revenue by restaurant
SELECT restaurant, SUM(total_amount) AS restaurant_revenue 
FROM swiggy_orders_dataset
WHERE delivery_status !='Cancelled'
GROUP BY restaurant 
ORDER BY SUM(total_amount) DESC;

-- Revenue by city
SELECT city, SUM(total_amount) AS city_revenue 
FROM swiggy_orders_dataset 
WHERE delivery_status !='Cancelled'
GROUP BY city;

-- Hourly revenue trends
SELECT DATEPART(HOUR, order_time) AS order_hour, SUM(total_amount) AS hourly_revenue, COUNT(*) AS total_orders
FROM swiggy_orders_dataset
WHERE delivery_status !='Cancelled'
GROUP BY DATEPART(HOUR, order_time)
ORDER BY order_hour;

-- Revenue lost due to cancelled orders
SELECT SUM(total_amount) AS revenue_cancelled_orders
FROM swiggy_orders_dataset
WHERE delivery_status !='Cancelled';

-- Revenue obtained through different payment modes
SELECT payment_mode, SUM(total_amount) AS PM_revenue
FROM swiggy_orders_dataset
WHERE delivery_status !='Cancelled'
GROUP BY payment_mode;

-- Average order spend
SELECT AVG(total_amount) AS avg_order_spend
FROM swiggy_orders_dataset;
