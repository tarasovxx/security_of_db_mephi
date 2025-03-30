## Тарасов Артём Б22-525
## МИФИ - 2025. Основы безопасности БД.
## Лабораторная работа 1-2

Платформа онлайн-курсов.

Прежде всего необходимо запролнить базу данных тестовыми данными, для этого создам insert_data.sql

```sql
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

```

Я использую sqlite3, поэтому добюавлю данные в уже созданную в ЛР 1-1 Базу данных lsb1-1.db
```bash
~/MEPhi/databases/lab1-1 ❯ sqlite3 lab1-1.db   
sqlite> .read ../lab1-2/insert_data.sql
```

Данные успешно добавлены, теперь перейдём к sql запросам

1. Все студенты
```sql
sqlite> SELECT * FROM Student;
student_id  first_name  last_name  email            phone        date_of_birth  registered_at
----------  ----------  ---------  ---------------  -----------  -------------  -------------
1           Иван        Иванов     ivanov@mail.ru   89991234567  2000-01-01     2023-09-01   
2           Мария       Петрова    petrova@mail.ru  89997654321  1999-05-15     2023-09-10   
10          Test        User       test@mail.ru                  1995-01-01     2024-01-01   
```
Выводит всех зарегистрированных студентов.

2. Студенты, зарегистрированные после 1 сентября 2023
```
sqlite> SELECT first_name, last_name, registered_at
   ...> FROM Student
   ...> WHERE registered_at > '2023-09-01';
first_name  last_name  registered_at
----------  ---------  -------------
Мария       Петрова    2023-09-10   
Test        User       2024-01-01   
```

Условная выборка по дате регистрации.

3. Все курсы, отсортированные по цене по убыванию
```
sqlite> SELECT title, price
   ...> FROM Course
   ...> ORDER BY price DESC;
title          price  
-------------  -------
Основы Python  4999.99
```
Упорядоченная выборка — дорогие курсы сверху.

4. Студенты, родившиеся после 2000 года

```
sqlite> SELECT first_name, last_name, date_of_birth
   ...> FROM Student
   ...> WHERE date_of_birth > '1999-06-01';
first_name  last_name  date_of_birth
----------  ---------  -------------
Иван        Иванов     2000-01-01   
```

Фильтрация по дате рождения.

5. Округление цен курсов до тысяч

```
sqlite> SELECT title, ROUND(price, -3) AS rounded_price
   ...> FROM Course;
title          rounded_price
-------------  -------------
Основы Python  5000.0      
```
Демонстрация использования функции ROUND.

6. Количество отзывов в таблице Review
```
sqlite> SELECT COUNT(*) AS review_count FROM Review;
review_count
------------
2        
```
Подсчёт всех отзывов.

7. Уникальные уровни сложности курсов

```
sqlite> SELECT DISTINCT difficulty FROM Course;
difficulty
----------
Beginner  
```

Уникальные значения поля — уровни сложности.

8.  Псевдо-запрос: расчёт длительности теста в минутах
```
sqlite> SELECT (20 - 12) AS test_duration;
test_duration
-------------
8            
```
Оценка выражения без обращения к таблице.

9. VACUUM
```
sqlite> VACUUM;
sqlite> 
```

Используется для очистки и обслуживания БД после большого количества изменений (например, INSERT, DELETE, UPDATE). Она пересоздаёт физический файл базы данных, устраняя фрагментацию и уменьшая объём файла. Особенно полезна перед архивированием или отправкой БД.


## Вывод
Были разработаны и выполнены простые SQL-запросы без использования JOIN, включая полные и условные выборки, сортировки, агрегатные функции, извлечение уникальных значений и псевдо-вычисления. Также была продемонстрирована работа команды VACUUM для обслуживания и оптимизации базы данных.
В результате были получены навыки базовой работы с SQL и извлечения информации из отдельных таблиц, что является основой для дальнейшего изучения более сложных операций работы с реляционными базами данных.