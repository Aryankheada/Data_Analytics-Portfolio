WITH top_customers AS(
               SELECT 
            CONCAT (c.first_name,' ',c.last_name) AS customer_name,
            c.city,
            COUNT(DISTINCT o.order_id) AS total_orders,
            SUM(oi.quantity * oi.selling_price) AS total_spent
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
WHERE o.order_status = 'DELIVERED'
GROUP BY c.first_name,
		 c.last_name,
         c.city
)
SELECT *
FROM(
SELECT*,
        DENSE_RANK() OVER (PARTITION BY city ORDER BY total_spent DESC) AS rank_
FROM top_customers
) ranked
WHERE rank_ <= 3
ORDER BY city,
         total_spent