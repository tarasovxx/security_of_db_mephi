-- Students
INSERT INTO Student VALUES (1, 'Иван', 'Иванов', 'ivanov@mail.ru', '89991234567', '2000-01-01', '2023-09-01');
INSERT INTO Student VALUES (2, 'Мария', 'Петрова', 'petrova@mail.ru', '89997654321', '1999-05-15', '2023-09-10');

-- Teachers
INSERT INTO Teacher VALUES (1, 'Сергей', 'Сидоров', 'sidorov@mail.ru', '89991112233', '2022-01-01');

-- Courses
INSERT INTO Course VALUES (1, 1, 'Основы Python', 'Изучение основ языка Python', '2023-09-01', 4999.99, 'RU', 'Beginner');

-- Modules
INSERT INTO Module VALUES (1, 1, 'Введение', 'Основные понятия', 1);
INSERT INTO Module VALUES (2, 1, 'Условные операторы', 'if, else, elif', 2);

-- Lessons
INSERT INTO Lesson VALUES (1, 1, 'Что такое Python?', 'Python — язык программирования...', 'https://video.url/intro', 1);
INSERT INTO Lesson VALUES (2, 2, 'if-else конструкции', 'Разбор условий...', 'https://video.url/if', 1);

-- Enrollment
INSERT INTO Enrollment VALUES (1, 1, '2023-09-01', 0.7);
INSERT INTO Enrollment VALUES (2, 1, '2023-09-02', 0.4);

-- TestAttempt
INSERT INTO TestAttempt VALUES (1, 1, 1, '2023-09-10 12:00', '2023-09-10 12:15', 8.5, 10.0, 1);
INSERT INTO TestAttempt VALUES (2, 2, 2, '2023-09-12 13:00', '2023-09-12 13:20', 6.0, 10.0, 0);

-- Reviews
INSERT INTO Review VALUES (1, 1, 1, 4.5, 'Курс полезный, но скучноват.', '2023-09-15');
INSERT INTO Review VALUES (2, 2, 1, 5.0, 'Отлично подан материал!', '2023-09-16');

-- Certificates
INSERT INTO Certificate VALUES (1, 1, 1, '2023-10-01', 'https://certs.url/ivanov');
