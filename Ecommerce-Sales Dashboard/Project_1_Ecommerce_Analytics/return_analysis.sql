SELECT 
      p.product_name,
      p.category,
      COUNT(DISTINCT r.return_id) AS total_returns,
      COUNT(DISTINCT o.order_id) AS total_orders,
      (COUNT(DISTINCT r.return_id) / COUNT(DISTINCT o.order_id)* 100) AS return_percnt
FROM returns r 
INNER JOIN orders o 
ON r.order_id = o.order_id
INNER JOIN order_items oi 
ON o.order_id = oi.order_id
INNER JOIN products p 
ON oi.product_id = p.product_id
GROUP BY  p.product_name,
      p.category
ORDER BY return_percnt
LIMIT 10;