WITH customer_spend AS(
            SELECT 
            CONCAT (c.first_name,' ',c.last_name) AS customer_name,
            c.city,
            c.customer_id,
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
         c.city,
         c.customer_id
),
city_spend AS(
           SELECT *,
           AVG(total_spent) OVER(PARTITION BY city) AS city_avg_spent
FROM customer_spend
)
SELECT *,
       (total_spent - city_avg_spent) AS diff_from_avg
FROM 
        city_spend
WHERE total_spent > city_avg_spent
ORDER BY city,
          total_spent DESC;
          
