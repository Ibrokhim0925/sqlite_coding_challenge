-- SQL Coding Challenge Submission
-- Tool Used: VS Code + SQLTools (SQLite driver)
-- Validation: Each query was run individually against the bais_sqlite_lab.db
-- to confirm the logic and results.


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

-- TASK 2: Total Revenue by Product Category
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM
    products AS p
JOIN
    order_items AS oi ON p.id = oi.product_id
GROUP BY
    p.category
ORDER BY
    revenue DESC;

-- TASK 2 (Variant): Revenue for 'Delivered' Orders Only
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM
    products AS p
JOIN
    order_items AS oi ON p.id = oi.product_id
JOIN
    orders AS o ON oi.order_id = o.id
WHERE
    o.status = 'Delivered'
GROUP BY
    p.category
ORDER BY
    revenue DESC;

-- TASK 3: Employees Earning Above Their Department Average
WITH DepartmentAverages AS (
    SELECT
        department_id,
        AVG(salary) AS dept_average_salary
    FROM
        employees
    GROUP BY
        department_id
)
SELECT
    e.first_name,
    e.last_name,
    d.name AS department_name,
    e.salary AS employee_salary,
    da.dept_average_salary AS department_average
FROM
    employees AS e
JOIN
    departments AS d ON e.department_id = d.id
JOIN
    DepartmentAverages AS da ON e.department_id = da.department_id
WHERE
    e.salary > da.dept_average_salary
ORDER BY
    department_name, employee_salary DESC;

-- TASK 4: Cities with the Most Loyal Customers
SELECT
    city,
    COUNT(id) AS gold_customer_count
FROM
    customers
WHERE
    loyalty_level = 'Gold'
GROUP BY
    city
ORDER BY
    gold_customer_count DESC, city;

-- TASK 4 (Extension): Loyalty Distribution by City
SELECT
    city,
    COUNT(CASE WHEN loyalty_level = 'Gold' THEN 1 ELSE NULL END) AS gold_count,
    COUNT(CASE WHEN loyalty_level = 'Silver' THEN 1 ELSE NULL END) AS silver_count,
    COUNT(CASE WHEN loyalty_level = 'Bronze' THEN 1 ELSE NULL END) AS bronze_count,
    COUNT(id) AS total_customers
FROM
    customers
GROUP BY
    city
ORDER BY
    gold_count DESC, total_customers DESC, city;
