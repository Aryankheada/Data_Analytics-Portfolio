WITH city_sales AS(
                    SELECT 
                           c.city,
						   c.state,
						   COUNT(DISTINCT o.order_id) AS total_orders,
						   SUM(oi.quantity * oi.selling_price) AS total_rev
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id
INNER JOIN order_items oi
ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY  c.city,
         c.state
)
SELECT *,
		DENSE_RANK() OVER (ORDER BY total_rev DESC) AS rank_
FROM city_sales
ORDER BY total_rev DESC;
