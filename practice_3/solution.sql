--Завдання 1.3.
SELECT COUNT(*) AS employees_total
FROM hr.employees;

--Завдання 2.1.
SELECT first_name, last_name
FROM hr.employees
WHERE manager_id = 101
ORDER BY employee_id ASC;

--Завдання 2.2.
SELECT first_name, last_name, salary
FROM hr.employees
WHERE salary < 4000
ORDER BY salary ASC;

--Завдання 2.3.
SELECT employee_id, first_name, last_name, hire_date
FROM hr.employees
WHERE EXTRACT(YEAR FROM hire_date) = 1996
ORDER BY hire_date ASC;

--Завдання 2.4.
SELECT employee_id, first_name, last_name, email
FROM hr.employees
WHERE email LIKE '%example.com'
ORDER BY email ASC;

--Завдання 2.5.
SELECT employee_id, first_name, last_name, department_id
FROM hr.employees
WHERE department_id IN (20, 30, 50)
ORDER BY department_id ASC, employee_id ASC;

--Завдання 2.6.
SELECT employee_id, first_name
FROM hr.employees
WHERE LOWER(first_name) LIKE '%a'
ORDER BY first_name ASC;

--Завдання 2.7.
SELECT employee_id, first_name, last_name, salary, commission_pct
FROM hr.employees
WHERE salary > 6000
  AND commission_pct = 0.15
ORDER BY salary ASC;

--Завдання 2.8.
SELECT employee_id, first_name, last_name, phone_number
FROM hr.employees
WHERE phone_number LIKE '515%'
ORDER BY phone_number ASC;

--Завдання 2.9.
SELECT employee_id, first_name, last_name, salary
FROM hr.employees
WHERE department_id = 20
ORDER BY salary DESC;

--Завдання 2.10.
SELECT employee_id, first_name, last_name, hire_date
FROM hr.employees
ORDER BY hire_date ASC, employee_id ASC
LIMIT 7;

--Завдання 2.11.
SELECT employee_id, first_name, last_name, salary
FROM hr.employees
WHERE salary > 4000
ORDER BY employee_id ASC
LIMIT 5;

--Завдання 2.12.
SELECT
    employee_id,
    first_name,
    last_name,
    CAST(salary AS TEXT) || ' EUR' AS salary_eur
FROM hr.employees
ORDER BY employee_id ASC;

--Завдання 2.13.
SELECT
    employee_id,
    first_name,
    last_name
FROM hr.employees
WHERE manager_id = 101
ORDER BY last_name ASC;

--Завдання 2.14.
SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM hr.employees
ORDER BY salary DESC
OFFSET 3
LIMIT 10;

--Завдання 2.15.
SELECT
    employee_id,
    first_name,
    last_name,
    hire_date
FROM hr.employees
WHERE hire_date > DATE '2000-01-01'
ORDER BY hire_date DESC;

--Завдання 3.1.
SELECT ROUND(AVG(salary), 2) AS avg_salary
FROM hr.employees
WHERE job_id LIKE 'S%';

--Завдання 3.2.
SELECT
    department_id,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM hr.employees
GROUP BY department_id
ORDER BY department_id ASC;

--Завдання 3.3.
SELECT COUNT(*) AS employees_count
FROM hr.employees
WHERE salary > 3000;

--Завдання 3.4.
SELECT
    department_id,
    SUM(salary) AS total_salary
FROM hr.employees
GROUP BY department_id
HAVING SUM(salary) > 10000
ORDER BY total_salary DESC;

--Завдання 3.5.
SELECT
    employee_id,
    first_name,
    last_name,
    COALESCE(commission_pct, 0) AS commission
FROM hr.employees
ORDER BY employee_id ASC;

--Завдання 3.6.
SELECT
    employee_id,
    last_name,
    salary + salary * COALESCE(commission_pct, 0) AS total_income
FROM hr.employees
WHERE salary + salary * COALESCE(commission_pct, 0) > 5000
ORDER BY total_income DESC;

--Завдання 4.1.
SELECT
    e.first_name,
    e.last_name,
    j.job_title
FROM hr.employees AS e
INNER JOIN hr.jobs AS j
    ON e.job_id = j.job_id
ORDER BY e.last_name ASC;

--Завдання 4.2.
SELECT
    e.first_name,
    e.last_name,
    e.salary,
    j.job_title
FROM hr.employees AS e
INNER JOIN hr.jobs AS j
    ON e.job_id = j.job_id
WHERE e.salary > 5000
ORDER BY e.salary DESC;

--Завдання 4.3.
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM hr.employees AS e
LEFT JOIN hr.departments AS d
    ON e.department_id = d.department_id
ORDER BY e.last_name ASC;

--Завдання 4.4.
SELECT
    d.department_name,
    e.first_name,
    e.last_name
FROM hr.employees AS e
RIGHT JOIN hr.departments AS d
    ON e.department_id = d.department_id
ORDER BY d.department_name ASC;

--Завдання 4.5.
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM hr.employees AS e
FULL OUTER JOIN hr.departments AS d
    ON e.department_id = d.department_id
ORDER BY d.department_name ASC, e.last_name ASC;

--Завдання 4.6.
SELECT
    e.first_name,
    e.last_name,
    j.job_title,
    d.department_name
FROM hr.employees AS e
INNER JOIN hr.jobs AS j
    ON e.job_id = j.job_id
INNER JOIN hr.departments AS d
    ON e.department_id = d.department_id
ORDER BY d.department_name ASC, e.last_name ASC;

--Завдання 4.7.
SELECT
    d.department_name,
    COUNT(e.employee_id) AS employees_count
FROM hr.departments AS d
LEFT JOIN hr.employees AS e
    ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
ORDER BY employees_count DESC;

--Завдання 4.8.
SELECT
    d.department_name,
    COUNT(e.employee_id) AS employees_count
FROM hr.departments AS d
INNER JOIN hr.employees AS e
    ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) > 3
ORDER BY employees_count DESC;

--Завдання 4.9.
SELECT
    d.department_name,
    c.country_name
FROM hr.departments AS d
INNER JOIN hr.locations AS l
    ON d.location_id = l.location_id
INNER JOIN hr.countries AS c
    ON l.country_id = c.country_id
ORDER BY c.country_name ASC, d.department_name ASC;

--Завдання 4.10.
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM hr.employees AS e
INNER JOIN hr.departments AS d
    ON e.department_id = d.department_id
INNER JOIN hr.locations AS l
    ON d.location_id = l.location_id
INNER JOIN hr.countries AS c
    ON l.country_id = c.country_id
INNER JOIN hr.regions AS r
    ON c.region_id = r.region_id
WHERE r.region_name = 'Europe'
ORDER BY e.last_name ASC;

--Завдання 5.1.
SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM hr.employees
WHERE salary > (
    SELECT AVG(salary)
    FROM hr.employees
)
ORDER BY salary DESC;

--Завдання 5.2.
SELECT
    department_id,
    department_name
FROM hr.departments
WHERE department_id IN (
    SELECT department_id
    FROM hr.employees
    GROUP BY department_id
    HAVING SUM(salary) > 100000
)
ORDER BY department_id ASC;

--Завдання 5.3.
SELECT
    employee_id,
    first_name,
    last_name
FROM hr.employees
WHERE department_id IN (
    SELECT department_id
    FROM hr.departments
    WHERE department_name LIKE 'S%'
)
ORDER BY employee_id ASC;

--Завдання 5.4.
SELECT
    e.employee_id,
    e.last_name,
    e.salary,
    e.job_id
FROM hr.employees AS e
WHERE e.salary > (
    SELECT j.max_salary
    FROM hr.jobs AS j
    WHERE j.job_id = e.job_id
)
ORDER BY e.salary DESC;

--Завдання 5.5.
SELECT
    d.department_id,
    d.department_name
FROM hr.departments AS d
WHERE NOT EXISTS (
    SELECT 1
    FROM hr.employees AS e
    WHERE e.department_id = d.department_id
)
ORDER BY d.department_id ASC;

--Завдання 5.6.
SELECT
    e.department_id,
    COUNT(*) AS employees_count
FROM hr.employees AS e
WHERE e.department_id IN (
    SELECT department_id
    FROM hr.employees
    GROUP BY department_id
    HAVING AVG(salary) > 15000
)
GROUP BY e.department_id
ORDER BY e.department_id ASC;
