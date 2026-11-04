--Завдання 1
SELECT
    country,
    COUNT(id) AS users_count
FROM
    `bigquery-public-data.thelook_ecommerce.users`
GROUP BY
    country
ORDER BY
    users_count DESC
LIMIT 10;

--Завдання 2
SELECT
    p.category,
    COUNT(oi.product_id) AS items_sold,
    ROUND(SUM(oi.sale_price), 2) AS revenue
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` AS oi
INNER JOIN
    `bigquery-public-data.thelook_ecommerce.products` AS p
    ON oi.product_id = p.id
GROUP BY
    p.category
ORDER BY
    revenue DESC;

--Завдання 3
SELECT
    status,
    COUNT(order_id) AS orders_count
FROM
    `bigquery-public-data.thelook_ecommerce.orders`
WHERE
    status IN ('Complete', 'Shipped')
GROUP BY
    status
ORDER BY
    status;

--Завдання 4
SELECT
    FORMAT_DATE('%Y-%m', DATE(created_at)) AS month,
    COUNT(*) AS items_sold,
    ROUND(AVG(sale_price), 2) AS avg_price
FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
WHERE
    EXTRACT(YEAR FROM created_at) IN (2024, 2025)
GROUP BY
    month
ORDER BY
    month ASC;

--Завдання 5
SELECT
    p.category,
    ROUND(SUM(oi.sale_price), 2) AS revenue
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` AS oi
INNER JOIN
    `bigquery-public-data.thelook_ecommerce.products` AS p
    ON oi.product_id = p.id
GROUP BY
    p.category
HAVING
    SUM(oi.sale_price) > 100000
ORDER BY
    revenue DESC;

--Завдання 6
SELECT
    p.name AS product_name,
    p.brand,
    COUNT(oi.product_id) AS times_sold,
    ROUND(SUM(oi.sale_price), 2) AS revenue
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` AS oi
INNER JOIN
    `bigquery-public-data.thelook_ecommerce.products` AS p
    ON oi.product_id = p.id
GROUP BY
    p.name,
    p.brand
ORDER BY
    revenue DESC
LIMIT 10;

--Завдання 7
SELECT
    p.category,
    COUNT(*) AS total_items,
    COUNTIF(oi.returned_at IS NOT NULL) AS returned_items,
    ROUND(
        SAFE_DIVIDE(
            COUNTIF(oi.returned_at IS NOT NULL),
            COUNT(*)
        ) * 100,
        1
    ) AS return_rate_pct
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` AS oi
INNER JOIN
    `bigquery-public-data.thelook_ecommerce.products` AS p
    ON oi.product_id = p.id
GROUP BY
    p.category
ORDER BY
    return_rate_pct DESC;

--Завдання 8
WITH buyers_by_category AS (
    SELECT DISTINCT
        p.category,
        u.id AS user_id,
        u.age
    FROM
        `bigquery-public-data.thelook_ecommerce.order_items` AS oi
    INNER JOIN
        `bigquery-public-data.thelook_ecommerce.products` AS p
        ON oi.product_id = p.id
    INNER JOIN
        `bigquery-public-data.thelook_ecommerce.users` AS u
        ON oi.user_id = u.id
)

SELECT
    category,
    COUNT(user_id) AS buyers,
    ROUND(AVG(age), 1) AS avg_age
FROM
    buyers_by_category
GROUP BY
    category
ORDER BY
    avg_age DESC;

--Завдання 9
WITH monthly_revenue AS (
    SELECT
        FORMAT_DATE('%Y-%m', DATE(created_at)) AS month,
        SUM(sale_price) AS revenue
    FROM
        `bigquery-public-data.thelook_ecommerce.order_items`
    WHERE
        EXTRACT(YEAR FROM created_at) = 2025
    GROUP BY
        month
)

SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM
    monthly_revenue
ORDER BY
    revenue_rank ASC;

--Завдання 10
WITH monthly_revenue AS (
    SELECT
        FORMAT_DATE('%Y-%m', DATE(created_at)) AS month,
        SUM(sale_price) AS revenue
    FROM
        `bigquery-public-data.thelook_ecommerce.order_items`
    WHERE
        EXTRACT(YEAR FROM created_at) = 2025
    GROUP BY
        month),
monthly_comparison AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue
    FROM
        monthly_revenue)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(prev_month_revenue, 2) AS prev_month_revenue,
    ROUND(
        SAFE_DIVIDE(
            revenue - prev_month_revenue,
            prev_month_revenue
        ) * 100,
        1
    ) AS growth_pct
FROM
    monthly_comparison
ORDER BY
    month ASC;

--Завдання 11
WITH product_revenue AS (
    SELECT
        p.id AS product_id,
        p.category,
        p.name AS product_name,
        SUM(oi.sale_price) AS revenue
    FROM
        `bigquery-public-data.thelook_ecommerce.order_items` AS oi
    INNER JOIN
        `bigquery-public-data.thelook_ecommerce.products` AS p
        ON oi.product_id = p.id
    GROUP BY
        p.id,
        p.category,
        p.name)
SELECT
    category,
    product_name,
    ROUND(revenue, 2) AS revenue,
    ROW_NUMBER() OVER (
        PARTITION BY category
        ORDER BY revenue DESC, product_id
    ) AS rank_in_category
FROM
    product_revenue
QUALIFY
    rank_in_category <= 3
ORDER BY
    category,
    rank_in_category;