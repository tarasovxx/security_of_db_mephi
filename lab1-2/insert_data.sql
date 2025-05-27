

-- Добавление второго преподавателя
INSERT INTO Teacher VALUES 
(2, 'Анна', 'Иванова', 'ivanova@mail.ru', '89994445566', '2023-01-01');

-- Добавление второго курса
INSERT INTO Course VALUES 
(2, 2, 'Advanced Python', 'Продвинутый курс', '2024-01-01', 15000, 'RU', 'Advanced');

-- Добавление модулей и уроков
INSERT INTO Module VALUES 
(3, 2, 'Асинхронное программирование', 'AsyncIO', 1),
(4, 2, 'Оптимизация кода', 'Профилирование', 2);

INSERT INTO Lesson VALUES 
(3, 3, 'Основы AsyncIO', '...', 'https://video.url/asyncio', 1),
(4, 4, 'cProfile', '...', 'https://video.url/cprofile', 1);

-- Добавление студентов
INSERT INTO Student VALUES 
(3, 'Алексей', 'Смирнов', 'smirnov@mail.ru', '89997778899', '2001-07-01', '2024-01-05'),
(4, 'Ольга', 'Петрова', 'petrova2@mail.ru', '89996665544', '2002-09-15', '2024-01-10');

-- Записи на курсы
INSERT INTO Enrollment VALUES 
(3, 2, '2024-01-06', 0.0),
(4, 2, '2024-01-07', 0.0);

-- Тестовые попытки
INSERT INTO TestAttempt VALUES 
(3, 3, 3, '2024-01-10 12:00', NULL, 0, 10, 0),
(4, 4, 4, '2024-01-11 14:00', '2024-01-11 14:30', 9.5, 10, 1);
