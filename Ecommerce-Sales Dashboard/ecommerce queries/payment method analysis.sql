SELECT 
     p.payment_status,
      COUNT(DISTINCT o.order_id) AS total_orders,
		SUM(p.payment_amount) AS total_rev,
        (SUM(p.payment_amount) /COUNT(DISTINCT o.order_id) ) AS avg_order_value
FROM payments p
INNER JOIN orders o 
ON p.order_id = o.order_id
WHERE o.order_status = 'Delivered' 
GROUP BY p.payment_status
ORDER BY total_rev   