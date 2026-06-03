WITH top_cat_month AS(
                SELECT 
                 p.category,
                DATE_FORMAT(o.order_date, '%Y-%m') AS month_,
				SUM(oi.quantity * oi.selling_price) AS total_rev
FROM order_items oi 
INNER JOIN orders o 
ON oi.order_id = o.order_id
INNER JOIN products p 
ON oi.product_id = p.product_id
WHERE o.order_status = 'DELIVERED' 
GROUP BY month_,
	   p.category
ORDER BY month_,
          total_rev
)
SELECT *
FROM(
SELECT*,
        DENSE_RANK() OVER (PARTITION BY month_ ORDER BY total_rev DESC) AS rank_
FROM top_cat_month
) ranked
WHERE rank_ = 1 
ORDER BY month_,
         total_rev DESC;