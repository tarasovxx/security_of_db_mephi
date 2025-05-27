## Тарасов Артём Б22-525
## МИФИ - 2025. Основы безопасности БД. Postgres

Платформа онлайн-курсов.

Сущности: студенты, курсы, модули, уроки, преподаватели, сертификаты, отзывы, попытки тестов


Неформальное описание
-- 
Представим компанию **«EduMaster»**, которая предоставляет онлайн-курсы по различным направлениям (программирование, дизайн, маркетинг и пр.). 

## Спецификация таблиц
![alt text](db_lab1_diagramm.png)
Рис 1. Спецификация таблиц

PostgreSQL — это свободная объектно-реляционная СУБД с 35-летней историей, известная ACID-совместимостью, расширяемой архитектурой и богатым стандартом SQL. Она поддерживает:

    транзакции MVCC без блокировок чтения;

    полнотекстовый поиск, JSONB, PostGIS;

    расширяемые типы, операторы, функции, процедуры, индексы;

    репликацию (потоковую, логическую) и встроённый механизм резервного копирования.
    Благодаря лицензии PostgreSQL License система широко используется от стартапов до корпораций и облаков (AWS RDS / Aurora Postgres, GCP Cloud SQL, Azure Database for PostgreSQL).


Для начала я просто поднял Docker контейнер с образом базы данных postgesql15 и локально подключился, используя агент DBeaver

```bash
docker run -d --name pg15 -e POSTGRES_PASSWORD=secret -p 5432:5432 postgres:15
```

Также можем подключиться используя CLI

```bash
# локально
psql -U postgres -h localhost -p 5432 -d edumaster
# или в Docker
docker exec -it pg15 psql -U postgres -d edumaster

```

schema_pg.sql
```sql
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

----------------------------------------------------
-- 1. Student
----------------------------------------------------
CREATE TABLE "Student" (
  student_id     SERIAL PRIMARY KEY,          -- SERIAL = авто-PK
  first_name     TEXT      NOT NULL,
  last_name      TEXT      NOT NULL,
  email          TEXT      NOT NULL UNIQUE,
  phone          TEXT,
  date_of_birth  DATE,
  registered_at  TIMESTAMP NOT NULL DEFAULT now()
);

----------------------------------------------------
-- 2. Teacher
----------------------------------------------------
CREATE TABLE "Teacher" (
  teacher_id     SERIAL PRIMARY KEY,
  first_name     TEXT      NOT NULL,
  last_name      TEXT      NOT NULL,
  email          TEXT      NOT NULL UNIQUE,
  phone          TEXT,
  hired_at       TIMESTAMP NOT NULL DEFAULT now()
);

----------------------------------------------------
-- 3. Course
----------------------------------------------------
CREATE TABLE "Course" (
  course_id      SERIAL PRIMARY KEY,
  teacher_id     INTEGER   NOT NULL REFERENCES "Teacher"(teacher_id)
                   ON DELETE CASCADE ON UPDATE CASCADE,
  title          TEXT      NOT NULL,
  description    TEXT,
  created_at     TIMESTAMP NOT NULL DEFAULT now(),
  price          NUMERIC(12,2),
  language       TEXT      NOT NULL,
  difficulty     TEXT      NOT NULL
);

----------------------------------------------------
-- 4. Module
----------------------------------------------------
CREATE TABLE "Module" (
  module_id      SERIAL PRIMARY KEY,
  course_id      INTEGER NOT NULL REFERENCES "Course"(course_id)
                   ON DELETE CASCADE ON UPDATE CASCADE,
  module_title   TEXT    NOT NULL,
  module_desc    TEXT,
  order_index    INTEGER NOT NULL
);

----------------------------------------------------
-- 5. Lesson
----------------------------------------------------
CREATE TABLE "Lesson" (
  lesson_id      SERIAL PRIMARY KEY,
  module_id      INTEGER NOT NULL REFERENCES "Module"(module_id)
                   ON DELETE CASCADE ON UPDATE CASCADE,
  lesson_title   TEXT    NOT NULL,
  lesson_content TEXT,
  video_url      TEXT,
  order_index    INTEGER NOT NULL
);

----------------------------------------------------
-- 6. Enrollment  (M-N)
----------------------------------------------------
CREATE TABLE "Enrollment" (
  student_id     INTEGER NOT NULL REFERENCES "Student"(student_id)
                   ON DELETE CASCADE ON UPDATE CASCADE,
  course_id      INTEGER NOT NULL REFERENCES "Course"(course_id)
                   ON DELETE CASCADE ON UPDATE CASCADE,
  enrolled_at    TIMESTAMP NOT NULL DEFAULT now(),
  progress       REAL      DEFAULT 0,
  PRIMARY KEY (student_id, course_id)
);

----------------------------------------------------
-- 7. TestAttempt
----------------------------------------------------
CREATE TABLE "TestAttempt" (
  attempt_id     SERIAL PRIMARY KEY,
  student_id     INTEGER   NOT NULL REFERENCES "Student"(student_id)
                   ON DELETE CASCADE ON UPDATE CASCADE,
  lesson_id      INTEGER   NOT NULL REFERENCES "Lesson"(lesson_id)
                   ON DELETE CASCADE ON UPDATE CASCADE,
  started_at     TIMESTAMP NOT NULL,
  finished_at    TIMESTAMP,
  score          REAL      NOT NULL,
  max_score      REAL      NOT NULL,
  passed         BOOLEAN   NOT NULL
);

----------------------------------------------------
-- 8. Review
----------------------------------------------------
CREATE TABLE "Review" (
  review_id     SERIAL PRIMARY KEY,
  student_id    INTEGER NOT NULL REFERENCES "Student"(student_id)
                   ON DELETE CASCADE ON UPDATE CASCADE,
  course_id     INTEGER NOT NULL REFERENCES "Course"(course_id)
                   ON DELETE CASCADE ON UPDATE CASCADE,
  rating        REAL    NOT NULL,
  review_text   TEXT,
  created_at    TIMESTAMP NOT NULL DEFAULT now()
);

----------------------------------------------------
-- 9. Certificate
----------------------------------------------------
CREATE TABLE "Certificate" (
  certificate_id  SERIAL PRIMARY KEY,
  student_id      INTEGER NOT NULL REFERENCES "Student"(student_id)
                   ON DELETE CASCADE ON UPDATE CASCADE,
  course_id       INTEGER NOT NULL REFERENCES "Course"(course_id)
                   ON DELETE CASCADE ON UPDATE CASCADE,
  date_issued     DATE     NOT NULL,
  certificate_url TEXT
);
```

insert_data_pg.sql
```
-- Students
INSERT INTO "Student"(student_id, first_name, last_name, email, phone, date_of_birth, registered_at)
VALUES
  (1,'Иван','Иванов','ivanov@mail.ru','89991234567','2000-01-01','2023-09-01'),
  (2,'Мария','Петрова','petrova@mail.ru','89997654321','1999-05-15','2023-09-10');

-- Teachers
INSERT INTO "Teacher"(teacher_id, first_name, last_name, email, phone, hired_at)
VALUES (1,'Сергей','Сидоров','sidorov@mail.ru','89991112233','2022-01-01');

-- Courses
INSERT INTO "Course"(course_id, teacher_id, title, description, created_at, price, language, difficulty)
VALUES (1,1,'Основы Python','Изучение основ языка Python','2023-09-01',4999.99,'RU','Beginner');

-- Modules
INSERT INTO "Module"(module_id, course_id, module_title, module_desc, order_index) VALUES
 (1,1,'Введение','Основные понятия',1),
 (2,1,'Условные операторы','if, else, elif',2);

-- Lessons
INSERT INTO "Lesson"(lesson_id, module_id, lesson_title, lesson_content, video_url, order_index) VALUES
 (1,1,'Что такое Python?','Python — язык программирования...','https://video.url/intro',1),
 (2,2,'if-else конструкции','Разбор условий...','https://video.url/if',1);

-- Enrollment
INSERT INTO "Enrollment"(student_id, course_id, enrolled_at, progress) VALUES
 (1,1,'2023-09-01',0.7),
 (2,1,'2023-09-02',0.4);

-- TestAttempt  (passed = TRUE/FALSE)
INSERT INTO "TestAttempt"(attempt_id, student_id, lesson_id, started_at, finished_at, score, max_score, passed) VALUES
 (1,1,1,'2023-09-10 12:00','2023-09-10 12:15',8.5,10.0,TRUE),
 (2,2,2,'2023-09-12 13:00','2023-09-12 13:20',6.0,10.0,FALSE);

-- Reviews
INSERT INTO "Review"(review_id, student_id, course_id, rating, review_text, created_at) VALUES
 (1,1,1,4.5,'Курс полезный, но скучноват.','2023-09-15'),
 (2,2,1,5.0,'Отлично подан материал!','2023-09-16');

-- Certificates
INSERT INTO "Certificate"(certificate_id, student_id, course_id, date_issued, certificate_url) VALUES
 (1,1,1,'2023-10-01','https://certs.url/ivanov');
```

Запросы из lab1-2
```
-- 1. Все студенты
SELECT * FROM "Student";

-- 2. Зарегистрированы после 1 сент 2023
SELECT first_name,last_name,registered_at
FROM "Student"
WHERE registered_at::date > '2023-09-01';

-- 3. Курсы по цене ↓
SELECT title, price FROM "Course" ORDER BY price DESC;

-- 4. Родившиеся после 2000-01-01
SELECT first_name,last_name,date_of_birth
FROM "Student"
WHERE date_of_birth > '1999-06-01';

-- 5. Округление цены
SELECT title, ROUND(price, -3) AS rounded_price FROM "Course";

-- 6. Кол-во отзывов
SELECT COUNT(*) AS review_count FROM "Review";

-- 7. Уникальные уровни сложности
SELECT DISTINCT difficulty FROM "Course";

-- 8. Псевдозапрос
SELECT (20 - 12) AS test_duration;

-- 9. VACUUM (обычно не нужно — есть autovacuum)
VACUUM FULL;      -- вручную
```


Где PostgreSQL != SQLite3

| Точка                      | Что меняется                                                                                               | Комментарий                                      |
| -------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| **PK авто-инкремент**      | `INTEGER PRIMARY KEY` → `SERIAL` или `GENERATED BY DEFAULT AS IDENTITY`                                    | В Postgres нет магического rowid.                |
| **BOOLEAN**                | хранит `TRUE/FALSE`, `0/1` тоже принимаются, но выводятся как `t/f`                                        | В `TestAttempt.passed` лучше BOOLEAN.            |
| **Типы даты/времени**      | `TEXT` → `DATE`, `TIMESTAMP`                                                                               | Появляется строгая проверка формата и тайм-зоны. |
| **Кавычки**                | Имена в PascalCase нужно писать в двойных кавычках каждый раз                                              | Иначе `student_id` vs `"Student".student_id`.    |
| **NULL sorting**           | `ORDER BY col DESC` кладёт NULL ы **LAST** (SQLite — FIRST)                                                | Используйте `NULLS FIRST/LAST` явно.             |
| **LIMIT без OFFSET**       | Совпадает, но `LIMIT -1` запрещён                                                                          | В SQLite «-1» означает «без лимита».             |
| **RECURSIVE CTE**          | По-умолчанию лимит 100 циклов ⇒ `SET max_recursive_iterations`                                             | SQLite не ограничивает.                          |
| **VACUUM**                 | autovacuum работает сам; ручной `VACUUM FULL` эксклюзивно блокирует таблицу                                | В SQLite `VACUUM` всегда полное.                 |
| **`AUTOINCREMENT`-аналог** | `SERIAL` не гарантирует «без reused ID» после DELETE → берите `BIGSERIAL`+`generated always` если критично | SQLite `AUTOINCREMENT` блокирует reuse.          |


```
psql -f schema_pg.sql
psql -f insert_data_pg.sql
psql -f queries.sql
```


### Вывод
В ходе работы развёрнут контейнер PostgreSQL 15, выполнено двустороннее подключение (psql + DBeaver), полностью перенесена схема и данные онлайн-курсов из SQLite, а все ранее разработанные запросы успешно отработали в новой СУБД. Зафиксированы ключевые отличия PostgreSQL (типизация, кавычки, сортировка NULL, autovacuum). Полученная инсталляция готова к дальнейшему развитию: можно включать логическую репликацию, писать хранимые процедуры на PL/pgSQL и подключать расширения (например, PgAudit для курсовой по «Основам безопасности БД»).

Контейнер оставлен в рабочем состоянии; доступ к БД подтверждён обоими клиентами.
