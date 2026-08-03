-- Видалення таблиць
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS hotels;

-- Створення таблиці hotels
CREATE TABLE hotels (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    rating NUMERIC(2,1) NOT NULL CHECK (rating BETWEEN 1 AND 5),
    rooms INT NOT NULL CHECK (rooms > 0)
);

-- Створення таблиці customers
CREATE TABLE customers (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE
);

-- Створення таблиці bookings
CREATE TABLE bookings (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hotel_id INT NOT NULL REFERENCES hotels(id) ON DELETE CASCADE,
    customer_id INT NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    total_price NUMERIC(10,2) NOT NULL CHECK (total_price > 0),
    CONSTRAINT chk_dates CHECK (check_out > check_in)
);

-- Додавання готелів
INSERT INTO hotels (name, location, rating, rooms) VALUES
    ('Hilton Kyiv',          'Київ',     4.8, 120),
    ('Premier Palace Hotel', 'Львів',    4.5, 80),
    ('Radisson Blu Resort',  'Буковель', 4.7, 150),
    ('Fairmont Grand Hotel', 'Київ',     4.6, 100),
    ('Opera Hotel',          'Одеса',    4.2, 75);

-- Додавання клієнтів
INSERT INTO customers (full_name, email, phone) VALUES
    ('Олександр Коваленко', 'kovalenko@email.com', '+380501234567'),
    ('Марина Петренко',     'petrenko@email.com',  '+380931234567'),
    ('Ігор Савчук',         'savchuk@email.com',   '+380671111222'),
    ('Анна Демченко',       'demchenko@email.com', '+380931223344'),
    ('Максим Ткаченко',     'tkachenko@email.com', '+380631234555');

-- Додавання бронювань
INSERT INTO bookings (hotel_id, customer_id, check_in, check_out, total_price) VALUES
    (1, 2, '2024-05-01', '2024-05-05', 8000.00),
    (2, 4, '2024-06-10', '2024-06-15', 12000.00),
    (3, 1, '2024-07-20', '2024-07-25', 9500.00),
    (5, 3, '2024-08-15', '2024-08-20', 7000.00),
    (4, 5, '2024-09-01', '2024-09-06', 8500.00);

-- Перевірка кількості записів
SELECT
    (SELECT COUNT(*) FROM hotels) AS hotels_cnt,
    (SELECT COUNT(*) FROM customers) AS customers_cnt,
    (SELECT COUNT(*) FROM bookings) AS bookings_cnt;

-- Перевірка роботи ON DELETE CASCADE
begin;

delete from hotels
where id = 1;

select count(*) as bookings_after_delete
from bookings;

rollback ;

select count(*) as bookings_after_rollback
from bookings;