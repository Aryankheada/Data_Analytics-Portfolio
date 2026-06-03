SELECT 
       p.product_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
		SUM(oi.quantity * oi.selling_price) AS total_rev
FROM order_items oi
INNER JOIN orders o
ON oi.order_id = o.order_id
INNER JOIN products p 
ON oi.product_id = p.product_id
WHERE o.order_status = 'DELIVERED'
GROUP BY p.product_name
ORDER BY total_rev DESC
LIMIT 10;