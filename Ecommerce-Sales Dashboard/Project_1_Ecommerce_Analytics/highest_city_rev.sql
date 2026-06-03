	WITH highest_rev_city AS(
				SELECT c.city,
				       COUNT(DISTINCT o.order_id) AS total_orders,
                       SUM(oi.quantity * oi.selling_price) AS total_rev,
                        COUNT(DISTINCT c.customer_id) AS total_customers,
                        SUM(oi.quantity * oi.selling_price)  /
                         COUNT(DISTINCT o.order_id) AS avg_order_value
FROM order_items oi
INNER JOIN orders o ON
oi.order_id = o.order_id
INNER JOIN customers c ON
o.customer_id = c.customer_id
WHERE o.order_status = 'DELIVERED'
GROUP BY c.city
)
SELECT *,
       DENSE_RANK() OVER (ORDER BY total_rev DESC) AS rank_
FROM hig hest_rev_city