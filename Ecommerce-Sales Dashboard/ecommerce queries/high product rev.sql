WITH product_high_rev AS(
                SELECT c.city,
                       p.category,
	              COUNT(DISTINCT o.order_id) AS total_orders,
                   SUM(oi.quantity * oi.selling_price) AS total_rev
FROM order_items oi 
INNER JOIN orders o
ON oi.order_id = o.order_id
INNER JOIN customers c
ON o.customer_id = c.customer_id
INNER JOIN products p on 
oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY c.city,
		p.category
)
SELECT * 
FROM (
      SELECT *,
      DENSE_RANK() OVER (PARTITION BY city ORDER BY total_rev DESC) AS rank_
FROM product_high_rev
) ranked
where rank_ =  1
ORDER BY city, 
        total_rev DESC;