WITH seller_perf AS (
               SELECT 
                    p.brand,
					COUNT(DISTINCT o.order_id) AS total_orders,
					SUM(oi.quantity * oi.selling_price) AS total_rev
FROM order_items oi
INNER JOIN products p 
ON oi.product_id = p.product_id
INNER JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.brand
)
SELECT *,
        DENSE_RANK() OVER(ORDER BY total_rev DESC) AS rank_
FROM seller_perf
ORDER BY total_rev DESC;