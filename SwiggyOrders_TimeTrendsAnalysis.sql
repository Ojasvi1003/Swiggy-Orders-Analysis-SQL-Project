-- Hourly Order Volume
SELECT FORMAT(DATEADD(HOUR, DATEPART(HOUR, order_time), 0), 'HH\:00') + '-' + 
  FORMAT(DATEADD(HOUR, DATEPART(HOUR, order_time) + 1, 0), 'HH\:00') AS order_hour_slot,
  COUNT(*) AS total_orders
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time);

-- Hourly Revenue
SELECT FORMAT(DATEADD(HOUR, DATEPART(HOUR, order_time), 0), 'HH\:00') + '-' + 
  FORMAT(DATEADD(HOUR, DATEPART(HOUR, order_time) + 1, 0), 'HH\:00') AS order_hour_slot,
  SUM(total_amount) AS revenue
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time);

-- Top Ordering Window (Peak Hour)
SELECT TOP 1 FORMAT(DATEADD(HOUR, DATEPART(HOUR, order_time), 0), 'HH\:00') + '-' + 
  FORMAT(DATEADD(HOUR, DATEPART(HOUR, order_time) + 1, 0), 'HH\:00') AS peak_hour_slot,
  COUNT(*) AS total_orders
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY DATEPART(HOUR, order_time)
ORDER BY total_orders DESC;

-- Delivery Time vs Order Time (per hour)
SELECT FORMAT(DATEADD(HOUR, DATEPART(HOUR, order_time), 0), 'HH\:00') + '-' + 
  FORMAT(DATEADD(HOUR, DATEPART(HOUR, order_time) + 1, 0), 'HH\:00') AS order_hour_slot,
  AVG(DATEDIFF(MINUTE, order_time, delivery_time)) AS avg_delivery_time_mins
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY DATEPART(HOUR, order_time)
HAVING AVG(DATEDIFF(MINUTE, order_time, delivery_time))>=0
ORDER BY DATEPART(HOUR, order_time);

-- Restaurant-wise peak time slots 
SELECT TOP 1 WITH TIES
  restaurant,
  FORMAT(DATEADD(HOUR, DATEPART(HOUR, order_time), 0), 'HH\:00') + '-' + 
  FORMAT(DATEADD(HOUR, DATEPART(HOUR, order_time) + 1, 0), 'HH\:00') AS peak_order_slot,
  COUNT(*) AS total_orders
FROM swiggy_orders_dataset
WHERE delivery_status != 'Cancelled'
GROUP BY restaurant, DATEPART(HOUR, order_time)
ORDER BY ROW_NUMBER() OVER (PARTITION BY restaurant ORDER BY COUNT(*) DESC);

--Most ordered item per time window
SELECT time_slot, item, total_quantity
FROM (
  SELECT FORMAT(DATEADD(HOUR, DATEPART(HOUR, order_time), 0), 'HH\:00') + '-' + 
    FORMAT(DATEADD(HOUR, DATEPART(HOUR, order_time) + 1, 0), 'HH\:00') AS time_slot, item, SUM(quantity) AS total_quantity,
    ROW_NUMBER() OVER (PARTITION BY DATEPART(HOUR, order_time) ORDER BY SUM(quantity) DESC) AS rn
  FROM swiggy_orders_dataset
  WHERE delivery_status != 'Cancelled'
  GROUP BY DATEPART(HOUR, order_time), item) AS ranked
WHERE rn = 1
ORDER BY time_slot;

