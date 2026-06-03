SELECT
      COUNT(DISTINCT o.order_id) AS total_orders,
                       SUM(oi.quantity * oi.selling_price) AS total_rev,
                        COUNT(DISTINCT o.customer_id) AS total_customers,
                        SUM(oi.quantity * oi.selling_price)  /
                         COUNT(DISTINCT o.order_id) AS avg_order_value,
                         SUM(oi.quantity) AS total_qty_sold
FROM order_items oi
INNER JOIN orders o 
ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'


 
       