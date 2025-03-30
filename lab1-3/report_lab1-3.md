## Тарасов Артём Б22-525
## МИФИ - 2025. Основы безопасности БД.
## Лабораторная работа 1-3

Платформа онлайн-курсов.
Пример легенды (какие ответы нужны сотрудникам)
- Курсы и их преподаватели: список всех курсов с указанием фамилии преподавателя.
- Студенты определённого курса: кто записан на конкретный курс (например, «Основы Python»)?
- Кол-во студентов на каждом курсе: руководству важна статистика популярности курсов.
- Курсы без записей: хотим понять, какие курсы ещё не набрали ни одного студента.
- Студенты с количеством сертификатов: кому выдали сертификаты и в каком объёме?
- Сравнение прогресса: кто превысил средний прогресс по курсу?
- Список всех людей в системе: показать (students + teachers) как единый общий список.
- Рекурсивный запрос: пример генерации последовательности чисел (или любая простая демонстрация «иерархических» возможностей).


### Примеры
1. Список всех курсов с указанием ФИО преподавателя (JOIN)
```
sqlite> SELECT 
   ...>     C.course_id,
   ...>     C.title AS course_title,
   ...>     T.first_name || ' ' || T.last_name AS teacher_name
   ...> FROM Course AS C
   ...> JOIN Teacher AS T 
   ...>     ON C.teacher_id = T.teacher_id;
course_id  course_title   teacher_name  
---------  -------------  --------------
1          Основы Python  Сергей Сидоров
```
классический INNER JOIN, даёт частичную «денормализацию» — в одной выборке курс и имя его преподавателя.

2. Список студентов, записанных на курс «Основы Python» (JOIN + WHERE)

```
sqlite> SELECT 
   ...>     S.student_id,
   ...>     S.first_name || ' ' || S.last_name AS student_name,
   ...>     E.enrolled_at
   ...> FROM Enrollment AS E
   ...> JOIN Student AS S 
   ...>     ON E.student_id = S.student_id
   ...> JOIN Course AS C  
   ...>     ON E.course_id = C.course_id
   ...> WHERE C.title = 'Основы Python';
student_id  student_name   enrolled_at
----------  -------------  -----------
1           Иван Иванов    2023-09-01 
2           Мария Петрова  2023-09-02 
```
Ещё один пример соединения нескольких таблиц, чтобы найти всех студентов, связанных с конкретным курсом.

3. Количество студентов на каждом курсе (GROUP BY)

```
sqlite> SELECT 
   ...>     C.course_id,
   ...>     C.title,
   ...>     COUNT(E.student_id) AS student_count
   ...> FROM Course AS C
   ...> LEFT JOIN Enrollment AS E 
   ...>     ON C.course_id = E.course_id
   ...> GROUP BY C.course_id, C.title;
course_id  title          student_count
---------  -------------  -------------
1          Основы Python  2          
```
Использую агрегатную функцию COUNT и группировку, чтобы посчитать количество записей на курс. LEFT JOIN позволяет вывести курсы даже без студентов (в таком случае student_count будет 0).

4. Найти курсы, где нет ни одного зачисленного студента (LEFT JOIN + фильтр)
```
sqlite> SELECT 
   ...>     C.course_id,
   ...>     C.title
   ...> FROM Course AS C
   ...> LEFT JOIN Enrollment AS E 
   ...>     ON C.course_id = E.course_id
   ...> WHERE E.course_id IS NULL;
sqlite> 
```
Ни одного подобного курса, что соответствует иситине, так как у меня только один курс 'Основы Python'. Смысл запрооса посмотреть, где E.course_id отсутствует (значение NULL), значит на курс никто не записался.

5. Список студентов с количеством полученных сертификатов (JOIN + GROUP BY)
```
sqlite> SELECT 
   ...>     S.student_id,
   ...>     S.first_name || ' ' || S.last_name AS student_name,
   ...>     COUNT(Cert.certificate_id) AS total_certificates
   ...> FROM Student AS S
   ...> JOIN Certificate AS Cert 
   ...>     ON S.student_id = Cert.student_id
   ...> GROUP BY S.student_id
   ...> ORDER BY total_certificates DESC;
student_id  student_name  total_certificates
----------  ------------  ------------------
1           Иван Иванов   1       
```
Агрегат COUNT по сертификатам, сгруппированным по студенту, позволяет увидеть, сколько сертификатов у каждого студента. Сортируем по убыванию.

6. Студенты, чей прогресс по курсу «Основы Python» выше среднего (подзапрос)

```
sqlite> SELECT 
   ...>     S.first_name || ' ' || S.last_name AS student_name,
   ...>     E.progress
   ...> FROM Enrollment AS E
   ...> JOIN Student AS S 
   ...>     ON E.student_id = S.student_id
   ...> JOIN Course AS C 
   ...>     ON E.course_id = C.course_id
   ...> WHERE C.title = 'Основы Python'
   ...>   AND E.progress > (
(x1...>       SELECT AVG(E2.progress)
(x1...>       FROM Enrollment AS E2
(x1...>       JOIN Course AS C2 
(x1...>           ON E2.course_id = C2.course_id
(x1...>       WHERE C2.title = 'Основы Python'
(x1...>   );
student_name  progress
------------  --------
Иван Иванов   0.7     
```
Применяем вложенный подзапрос для вычисления среднего прогресса по конкретному курсу, затем в основном запросе берём строки со значением E.progress выше этого среднего.

7. Объединение списков (UNION): все люди в системе
```
sqlite> SELECT 'Student' AS role, first_name, last_name, email
   ...> FROM Student
   ...> 
   ...> UNION
   ...> 
   ...> SELECT 'Teacher' AS role, first_name, last_name, email
   ...> FROM Teacher;
role     first_name  last_name  email          
-------  ----------  ---------  ---------------
Student  Test        User       test@mail.ru   
Student  Иван        Иванов     ivanov@mail.ru 
Student  Мария       Петрова    petrova@mail.ru
Teacher  Сергей      Сидоров    sidorov@mail.ru
```

Оператор UNION даёт объединённый набор строк из двух таблиц. Дубликаты при обычном UNION устраняются, UNION ALL (если нужен) оставляет повторы. Мы получаем общий список людей с указанием их «роли».

8. Рекурсивный запрос (WITH RECURSIVE)

```
sqlite> WITH RECURSIVE numbers(n) AS (
(x1...>     VALUES (1)           
(x1...>     UNION ALL
(x1...>     SELECT n + 1 
(x1...>     FROM numbers
(x1...>     WHERE n < 10
(x1...> )
   ...> SELECT n 
   ...> FROM numbers;
n 
--
1 
2 
3 
4 
5 
6 
7 
8 
9 
10
```
Демонстрируется, как в SQLite3 можно создавать рекурсивные CTE. В данном случае просто генерируем числа от 1 до 10.


## Вывод
В данной лр получилось разобраться и применить:
- Применение различных типов JOIN (INNER, LEFT).
- Использование агрегатных функций (COUNT, AVG) и группировки GROUP BY.
- Подзапросы в секции WHERE.
- Операторы объединения UNION.
- Использование CTE (в том числе рекурсивных) для генерации данных или обхода иерархий.

Мы получили как 8 различных запросов, отвечающих на реальные вопросы «легенды» и использующих  расширенныевозможности SQL/SQLite3.