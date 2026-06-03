WITH category_sales AS(
       SELECT 
       o.shipping_city,
       p.category,
       COUNT(DISTINCT o.order_id) AS total_orders,
       SUM(oi.quantity * oi.selling_price) AS total_rev
FROM orders o
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
LEFT JOIN products p 
ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY o.shipping_city,
         p.category
)
SELECT *,
       DENSE_RANK() OVER(PARTITION BY shipping_city ORDER BY total_rev) AS rank_
FROM category_sales
ORDER BY shipping_city,
total_rev DESC;