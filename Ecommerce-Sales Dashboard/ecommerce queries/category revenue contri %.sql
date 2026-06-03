WITH category_rev AS(
          SELECT
              p.category,
              SUM(oi.quantity * oi.selling_price) AS total_rev
FROM order_items oi 
INNER JOIN orders o 
ON oi.order_id = o.order_id
INNER JOIN products p 
ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
)
SELECT *,
       (total_rev/SUM(total_rev) OVER())*100 AS revenue_percnt
FROM category_rev 
ORDER BY total_rev DESC;
     
