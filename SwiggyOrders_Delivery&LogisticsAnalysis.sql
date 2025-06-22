-- Order delivery status
SELECT delivery_status, COUNT(*) AS num_of_orders
FROM swiggy_orders_dataset
GROUP BY delivery_status;

-- Average delivery time
SELECT AVG(DATEDIFF(MINUTE, order_time, delivery_time)) AS avg_delivery_minutes
FROM swiggy_orders_dataset
WHERE delivery_status = 'Delivered' AND delivery_time > order_time;

-- Late deliveries (over 60 mins)
SELECT COUNT(*) AS late_deliveries
FROM swiggy_orders_dataset
WHERE delivery_status = 'Delivered'AND DATEDIFF(MINUTE, order_time, delivery_time) > 60;

-- City-wise cancelled orders
SELECT city, COUNT(*) AS cancelled_orders
FROM swiggy_orders_dataset
WHERE delivery_status = 'Cancelled'
GROUP BY city ORDER BY cancelled_orders DESC;

-- Restaurant-wise cancelled orders
SELECT restaurant, COUNT(*) AS cancelled_orders
FROM swiggy_orders_dataset
WHERE delivery_status = 'Cancelled'
GROUP BY restaurant
ORDER BY cancelled_orders DESC;

