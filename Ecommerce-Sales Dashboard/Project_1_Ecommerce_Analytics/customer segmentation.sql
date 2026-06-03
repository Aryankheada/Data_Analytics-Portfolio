WITH customer_segement AS (
           SELECT 
		    c.customer_id,
           CONCAT(c.first_name,' ',c.last_name) AS customer_name,
            COUNT(DISTINCT o.order_id) AS total_orders,
            SUM(oi.quantity * oi.selling_price) AS total_spent
FROM order_items oi
INNER JOIN orders o
ON oi.order_id = o.order_id
INNER JOIN customers c 
ON o.customer_id = c.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.first_name,
          c.last_name,
          c.customer_id
)
SELECT *,
       CASE 
           WHEN total_spent > 3000000 THEN 'VIP'
           WHEN total_spent > 1000000 THEN 'Regular'
           ELSE 'Low spender'
END AS customer_spend
FROM customer_segement
ORDER BY total_spent DESC;