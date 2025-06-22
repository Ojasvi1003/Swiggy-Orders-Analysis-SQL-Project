-- Payment mode usage in delivered orders
SELECT payment_mode, COUNT(*) AS usage_count, SUM(total_amount) AS total_spent
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY payment_mode
ORDER BY usage_count DESC;

-- Average order value per payment method
SELECT payment_mode, AVG(total_amount) AS avg_order_value
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY payment_mode
ORDER BY AVG(total_amount) DESC;

-- City-wise payment mode
SELECT city, payment_mode, count(*) AS num_orders
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY city, payment_mode
ORDER BY city, num_orders DESC;