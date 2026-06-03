SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month_,
        COUNT(DISTINCT o.order_id) AS total_orders,
		SUM(oi.quantity * oi.selling_price) AS total_rev
FROM order_items oi
INNER JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'DELIVERED'
GROUP BY month_
ORDER BY month_ ASC;