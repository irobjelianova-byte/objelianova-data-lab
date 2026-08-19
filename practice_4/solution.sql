--Завдання 1.3.
SELECT 'products' AS t, COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'employees', COUNT(*) FROM employees
UNION ALL SELECT 'events', COUNT(*) FROM events
UNION ALL SELECT 'customer_data', COUNT(*) FROM customer_data
UNION ALL SELECT 'product_catalog', COUNT(*) FROM product_catalog
UNION ALL SELECT 'products_with_categories', COUNT(*) FROM products_with_categories;

--Завдання 2.1.
SELECT
    name,
    price,
    CEIL(price) AS price_ceil,
    ROUND(SQRT(price)::numeric, 2) AS price_sqrt
FROM products
ORDER BY id ASC;

--Завдання 2.2.
SELECT
    name,
    price,
    MOD(price, 1000) AS price_rest
FROM products
ORDER BY id ASC;

--Завдання 2.3.
SELECT
    name,
    discount,
    CASE
        WHEN COALESCE(discount, 0) < 0.07 THEN 'Мінімальна'
        WHEN COALESCE(discount, 0) <= 0.12 THEN 'Середня'
        ELSE 'Висока'
    END AS discount_level
FROM products
ORDER BY id ASC;

--Завдання 2.4.
SELECT
    name,
    ROUND((price * COALESCE(discount, 0))::numeric, 2) AS money_discount,
    ROUND(
        GREATEST(
            price * COALESCE(discount, 0),
            1000
        )::numeric,
        2
    ) AS max_discount
FROM products
ORDER BY id ASC;

--Завдання 2.5.
SELECT
    name,
    price,
    LEAST(price, 18000) AS capped_price
FROM products
ORDER BY id ASC;

-- Завдання 3.1
SELECT
    COUNT(*) AS orders_count,
    SUM(total_amount) AS total_sales,
    ROUND(AVG(total_amount), 2) AS avg_amount,
    MIN(total_amount) AS min_amount,
    MAX(total_amount) AS max_amount
FROM orders;

-- Завдання 3.2
SELECT
    region,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS total_sales,
    ROUND(AVG(total_amount), 2) AS avg_amount
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

-- Завдання 3.3
SELECT
    customer_id,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY customer_id ASC;

-- Завдання 3.4
SELECT
    customer_id,
    COUNT(DISTINCT region) AS regions_count,
    STRING_AGG(DISTINCT region, ', ' ORDER BY region) AS regions
FROM orders
GROUP BY customer_id
HAVING COUNT(DISTINCT region) > 1
ORDER BY customer_id ASC;

-- Завдання 3.5
SELECT
    region,
    ROUND(AVG(total_amount), 2) AS avg_amount,
    ROUND(STDDEV(total_amount), 2) AS stddev_amount,
    ROUND(VARIANCE(total_amount), 2) AS variance_amount
FROM orders
GROUP BY region
ORDER BY region ASC;

-- Завдання 4.1
SELECT
    id,
    first_name,
    last_name,
    LOWER(
        LEFT(last_name, 3) ||
        LEFT(first_name, 3) ||
        id::text
    ) AS login
FROM employees
ORDER BY id ASC;

-- Завдання 4.2
SELECT
    id,
    first_name,
    last_name,
    LENGTH(bio) AS bio_length,
    LEFT(bio, 50) || '...' AS bio_short
FROM employees
WHERE LENGTH(bio) > 50
ORDER BY id ASC;

-- Завдання 4.3
SELECT
    id,
    department,
    TRIM(department) AS department_trimmed,
    bio,
    TRIM(bio) AS bio_trimmed
FROM employees
WHERE department <> TRIM(department)
   OR bio <> TRIM(bio)
ORDER BY id ASC;

-- Завдання 4.4
SELECT DISTINCT
    SPLIT_PART(email, '@', 2) AS domain
FROM employees
ORDER BY domain ASC;

-- Завдання 4.5 — вставка
INSERT INTO employees (first_name, last_name, email, bio, department)
VALUES ('Софія', 'Кравчук Мельник', 'sofiia.kravchuk@example.com',
        'Аналітик даних', 'IT');

-- Завдання 4.5 — пошук
SELECT
    id,
    first_name,
    last_name
FROM employees
WHERE last_name LIKE '% %'
ORDER BY id ASC;

-- Завдання 4.6
SELECT
    department,
    STRING_AGG(bio, '; ') AS bios
FROM employees
GROUP BY department
ORDER BY department ASC;

-- Завдання 4.7
SELECT
    LPAD(id::text, 5, '*') AS padded_id,
    first_name,
    last_name
FROM employees
ORDER BY id ASC;


-- Завдання 5.1
SELECT
    event_name,
    ROUND(
        (EXTRACT(EPOCH FROM (end_date - start_date)) / 3600)::numeric,
        1
    ) AS duration_hours,
    ROUND(
        (EXTRACT(EPOCH FROM (end_date - start_date)) / 86400)::numeric,
        2
    ) AS duration_days
FROM events
ORDER BY id ASC;

-- Завдання 5.2
SELECT
    event_name,
    TO_CHAR(start_date, 'DD.MM.YYYY HH24:MI') AS start_formatted,
    TO_CHAR(end_date, 'FMMonth DD, YYYY') AS end_formatted
FROM events
ORDER BY id ASC;

-- Завдання 5.3
SELECT
    event_name,
    start_date,
    CASE
        WHEN start_date < NOW() THEN 'Минуле'
        ELSE 'Майбутнє'
    END AS status
FROM events
ORDER BY id ASC;

-- Завдання 5.4
SELECT
    event_name,
    registration_deadline,
    start_date,
    (start_date::date - registration_deadline) AS days_before_start
FROM events
WHERE (start_date::date - registration_deadline) < 7
ORDER BY id ASC;

-- Завдання 5.5
SELECT
    event_name,
    CASE EXTRACT(DOW FROM start_date)
        WHEN 0 THEN 'Неділя'
        WHEN 1 THEN 'Понеділок'
        WHEN 2 THEN 'Вівторок'
        WHEN 3 THEN 'Середа'
        WHEN 4 THEN 'Четвер'
        WHEN 5 THEN 'П’ятниця'
        WHEN 6 THEN 'Субота'
    END AS weekday
FROM events
ORDER BY id ASC;

-- Завдання 5.6
SELECT
    event_name,
    start_date,
    start_date - INTERVAL '3 days' AS reminder_date
FROM events
ORDER BY id ASC;

-- Завдання 5.7
SELECT
    event_name,
    EXTRACT(YEAR FROM start_date)::integer AS event_year,
    EXTRACT(MONTH FROM start_date)::integer AS event_month,
    EXTRACT(QUARTER FROM start_date)::integer AS event_quarter
FROM events
ORDER BY id ASC;

-- Завдання 6.1
SELECT
    name,
    CASE
        WHEN email IS NOT NULL AND phone IS NOT NULL THEN 'Є обидва'
        WHEN email IS NOT NULL THEN 'Є email'
        WHEN phone IS NOT NULL THEN 'Є телефон'
        ELSE 'Контактні дані відсутні'
    END AS contact_status
FROM customer_data
ORDER BY id ASC;

-- Завдання 6.2
SELECT
    name,
    COALESCE(email, 'Немає email') AS email,
    COALESCE(phone, 'Немає телефону') AS phone,
    COALESCE(address, 'Адреса не вказана') AS address,
    COALESCE(total_purchases, 0) AS total_purchases,
    COALESCE(
        last_purchase_date::text,
        'Немає покупок'
    ) AS last_purchase_date
FROM customer_data
ORDER BY id ASC;

-- Завдання 6.3
SELECT
    id,
    name,
    total_purchases
FROM customer_data
WHERE COALESCE(total_purchases, 0) = 0
ORDER BY id ASC;

-- Завдання 6.4
SELECT
    id,
    name
FROM customer_data
WHERE email IS NULL
  AND phone IS NULL
ORDER BY id ASC;

-- Завдання 6.5
SELECT
    COUNT(*) AS total,
    COUNT(email) AS with_email,
    COUNT(phone) AS with_phone,
    COUNT(address) AS with_address,
    COUNT(*) FILTER (
        WHERE email IS NULL
          AND phone IS NULL
          AND address IS NULL
    ) AS with_nothing
FROM customer_data;

-- Завдання 7.1
SELECT
    name,
    attributes ->> 'brand' AS brand,
    COALESCE(
        attributes -> 'specs' -> 'memory' ->> 'ram',
        'Не вказано'
    ) AS ram
FROM product_catalog
ORDER BY id ASC;

-- Завдання 7.2
SELECT
    name,
    attributes -> 'specs' ->> 'battery' AS battery
FROM product_catalog
WHERE attributes -> 'specs' ? 'battery'
ORDER BY id ASC;

-- Завдання 7.3
SELECT
    name,
    tags
FROM product_catalog
WHERE tags ?| ARRAY['gaming', 'wearables', 'audio']
ORDER BY id ASC;

-- Завдання 7.4
SELECT
    COUNT(*) FILTER (
        WHERE attributes -> 'specs' ? 'screen'
    ) AS with_screen,
    COUNT(*) FILTER (
        WHERE attributes -> 'specs' ? 'battery'
    ) AS with_battery,
    COUNT(*) FILTER (
        WHERE attributes -> 'specs' ? 'gps'
    ) AS with_gps,
    COUNT(*) FILTER (
        WHERE attributes -> 'specs' ?| ARRAY['screen', 'battery', 'gps']
    ) AS with_any
FROM product_catalog;

-- Завдання 7.5
SELECT
    name,
    attr_key,
    attr_value
FROM product_catalog
CROSS JOIN LATERAL jsonb_each(attributes) AS a(attr_key, attr_value)
ORDER BY id ASC;

-- Завдання 7.6
SELECT
    JSONB_OBJECT_AGG(
        brand,
        product_names
    ) AS brands_products
FROM (
    SELECT
        attributes ->> 'brand' AS brand,
        JSONB_AGG(name ORDER BY name) AS product_names
    FROM product_catalog
    GROUP BY attributes ->> 'brand'
) AS grouped_products;

-- Завдання 7.7
UPDATE product_catalog
SET attributes = jsonb_set(
    attributes,
    '{specs,warranty}',
    '"1 рік"',
    true
)
WHERE NOT (
    attributes -> 'specs' ? 'warranty'
);

SELECT
    name,
    attributes -> 'specs' ->> 'warranty' AS warranty
FROM product_catalog
ORDER BY id ASC;

-- Завдання 8.1
SELECT
    STRING_AGG(name, ', ' ORDER BY id) AS products
FROM products_with_categories;

-- Завдання 8.2
SELECT
    name,
    categories,
    cardinality(categories) AS categories_count
FROM products_with_categories
WHERE cardinality(categories) > 2
ORDER BY id ASC;

-- Завдання 8.3
SELECT
    name,
    categories
FROM products_with_categories
WHERE categories && ARRAY['Гаджети', 'Ноутбуки', 'Аудіо']
ORDER BY id ASC;

-- Завдання 8.4
SELECT
    name,
    unnest(specifications) AS specification
FROM products_with_categories
ORDER BY id ASC;

-- Завдання 8.5
SELECT
    name,
    COUNT(*) AS numeric_specs_count
FROM products_with_categories
CROSS JOIN LATERAL unnest(specifications) AS specification
WHERE specification ~ '[0-9]'
GROUP BY id, name
HAVING COUNT(*) >= 2
ORDER BY id ASC;

-- Завдання 8.6
SELECT
    category,
    COUNT(*) AS products_count,
    SUM(price) AS total_price
FROM products_with_categories
CROSS JOIN LATERAL unnest(categories) AS category
GROUP BY category
ORDER BY total_price DESC;

-- Завдання 8.7
UPDATE products_with_categories
SET categories = array_append(categories, 'Топ-продаж')
WHERE NOT ('Топ-продаж' = ANY(categories));

SELECT
    name,
    categories
FROM products_with_categories
ORDER BY id ASC;