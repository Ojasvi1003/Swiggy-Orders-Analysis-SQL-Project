SELECT * FROM swiggy_orders_dataset;

-- Total orders
SELECT COUNT(*) AS total_orders 
FROM swiggy_orders_dataset;

-- Unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers 
FROM swiggy_orders_dataset;

-- Unique restaurants
SELECT COUNT(DISTINCT restaurant) AS restaurants 
FROM swiggy_orders_dataset;

-- Time range
SELECT MIN(order_time) AS first_order_time, MAX(order_time) AS last_order_time 
FROM swiggy_orders_dataset;

-- Order status count
SELECT delivery_status, COUNT(*) AS order_status 
FROM swiggy_orders_dataset 
GROUP BY delivery_status;

-- Total revenue
SELECT SUM(total_amount) AS total_revenue 
FROM swiggy_orders_dataset
WHERE delivery_status !='Cancelled';

-- Items count
SELECT item, COUNT(*) order_count, SUM(quantity) AS item_quantity 
FROM swiggy_orders_dataset 
GROUP BY item;

-- City-wise orders
SELECT city, COUNT(*) AS customers_per_city 
FROM swiggy_orders_dataset 
GROUP BY city;

-- Payment mode preference
SELECT payment_mode, COUNT(*) AS customers_per_pm 
FROM swiggy_orders_dataset 
GROUP BY payment_mode;