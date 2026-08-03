CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    grade INT NOT NULL
);

INSERT INTO students (name, grade) VALUES
('Олена Коваль', 92),
('Іван Петренко', 85),
('Марія Шевченко', 78);

SELECT * FROM students;