-- TASK 1: Top 5 Customers by Total Spend
SELECT
    c.first_name || ' ' || c.last_name AS customer_full_name,
    SUM(oi.quantity * oi.unit_price) AS total_spend
FROM
    customers AS c
JOIN
    orders AS o ON c.id = o.customer_id
JOIN
    order_items AS oi ON o.id = oi.order_id
GROUP BY
    c.id -- Grouping by customer ID is safer than by name
ORDER BY
    total_spend DESC
LIMIT 5;
