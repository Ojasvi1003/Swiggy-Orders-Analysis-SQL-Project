-- Top 10 high-value customers
SELECT TOP 10 customer_id, COUNT(*) AS total_orders, SUM(total_amount) AS total_spent
FROM swiggy_orders_dataset 
WHERE delivery_status != 'Cancelled'
GROUP BY customer_id 
ORDER BY total_spent DESC;

-- Top 10 customers with highest average order values
SELECT TOP 10 customer_id, COUNT(*) AS total_orders, AVG(total_amount) AS avg_order_value
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY customer_id
ORDER BY AVG(total_amount) DESC;

-- Customers with repeat orders
SELECT customer_id, COUNT(*) AS num_of_orders
FROM swiggy_orders_dataset 
WHERE delivery_status!='Cancelled'
GROUP BY customer_id
HAVING COUNT(customer_id)>1
ORDER BY COUNT(*) DESC;

-- Customers using different payment modes
SELECT payment_mode, COUNT(DISTINCT(customer_id)) AS PM_customers
FROM swiggy_orders_dataset 
GROUP BY payment_mode
ORDER BY COUNT(DISTINCT(customer_id)) DESC;

-- City-wise customer behavior
SELECT city, COUNT(DISTINCT(customer_id)) AS city_orders
FROM swiggy_orders_dataset
GROUP BY city
ORDER BY city_orders DESC;

-- Number of customers who cancelled one or more orders
SELECT COUNT(DISTINCT(customer_id)) AS cust_cancelled_orders
FROM swiggy_orders_dataset
WHERE delivery_status = 'Cancelled'
;

-- Number of cancelled orders per customer
SELECT customer_id, COUNT(*) AS cancelled_orders
FROM swiggy_orders_dataset
WHERE delivery_status = 'Cancelled'
GROUP BY customer_id
HAVING COUNT(*) > 0
ORDER BY COUNT(*) DESC;
