WITH montly_rev AS (
               SELECT
                   DATE_FORMAT(o.order_id, '%Y-%m') AS month_,
				   SUM(oi.quantity * oi.selling_price) AS total_rev
FROM orders o
INNER JOIN order_items oi
ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY month_
)
SELECT *,
	LAG(total_rev) OVER(ORDER BY month_) AS previous_month_rev,
    (total_rev - LAG(total_rev) OVER(ORDER BY month_) /
    LAG(total_rev) OVER(ORDER BY month_)) *100 AS growth_percnt
FROM montly_rev
ORDER BY month_