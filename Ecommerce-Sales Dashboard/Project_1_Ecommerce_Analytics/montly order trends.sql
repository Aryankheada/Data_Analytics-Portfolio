SELECT 
       DATE_FORMAT(o.order_date, '%Y-%m') AS month_,
        COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o 
WHERE o.order_status = 'DELIVERED'
GROUP BY month_
ORDER BY month_ ASC;