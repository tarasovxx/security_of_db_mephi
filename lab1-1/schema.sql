
----------------------------------------------------
-- 1. Student
----------------------------------------------------
CREATE TABLE Student (
  student_id     INTEGER PRIMARY KEY,
  first_name     TEXT NOT NULL,
  last_name      TEXT NOT NULL,
  email          TEXT NOT NULL UNIQUE,
  phone          TEXT,
  date_of_birth  TEXT,
  registered_at  TEXT NOT NULL
);

----------------------------------------------------
-- 2. Teacher
----------------------------------------------------
CREATE TABLE Teacher (
  teacher_id     INTEGER PRIMARY KEY,
  first_name     TEXT NOT NULL,
  last_name      TEXT NOT NULL,
  email          TEXT NOT NULL UNIQUE,
  phone          TEXT,
  hired_at       TEXT NOT NULL
);

----------------------------------------------------
-- 3. Course
----------------------------------------------------
CREATE TABLE Course (
  course_id      INTEGER PRIMARY KEY,
  teacher_id     INTEGER NOT NULL,
  title          TEXT NOT NULL,
  description    TEXT,
  created_at     TEXT NOT NULL,
  price          REAL,
  language       TEXT NOT NULL,
  difficulty     TEXT NOT NULL,
  FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

----------------------------------------------------
-- 4. Module
----------------------------------------------------
CREATE TABLE Module (
  module_id      INTEGER PRIMARY KEY,
  course_id      INTEGER NOT NULL,
  module_title   TEXT NOT NULL,
  module_desc    TEXT,
  order_index    INTEGER NOT NULL,
  FOREIGN KEY (course_id) REFERENCES Course(course_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

----------------------------------------------------
-- 5. Lesson
----------------------------------------------------
CREATE TABLE Lesson (
  lesson_id      INTEGER PRIMARY KEY,
  module_id      INTEGER NOT NULL,
  lesson_title   TEXT NOT NULL,
  lesson_content TEXT,
  video_url      TEXT,
  order_index    INTEGER NOT NULL,
  FOREIGN KEY (module_id) REFERENCES Module(module_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

----------------------------------------------------
-- 6. Enrollment (many-to-many между Student и Course)
----------------------------------------------------
CREATE TABLE Enrollment (
  student_id     INTEGER NOT NULL,
  course_id      INTEGER NOT NULL,
  enrolled_at    TEXT NOT NULL,
  progress       REAL DEFAULT 0,
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES Student(student_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (course_id) REFERENCES Course(course_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

----------------------------------------------------
-- 7. TestAttempt
----------------------------------------------------
CREATE TABLE TestAttempt (
  attempt_id     INTEGER PRIMARY KEY,
  student_id     INTEGER NOT NULL,
  lesson_id      INTEGER NOT NULL,
  started_at     TEXT NOT NULL,
  finished_at    TEXT,
  score          REAL NOT NULL,
  max_score      REAL NOT NULL,
  passed         INTEGER NOT NULL,  -- 1/0, could store bool
  FOREIGN KEY (student_id) REFERENCES Student(student_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (lesson_id) REFERENCES Lesson(lesson_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

----------------------------------------------------
-- 8. Review
----------------------------------------------------
CREATE TABLE Review (
  review_id     INTEGER PRIMARY KEY,
  student_id    INTEGER NOT NULL,
  course_id     INTEGER NOT NULL,
  rating        REAL NOT NULL,
  review_text   TEXT,
  created_at    TEXT NOT NULL,
  FOREIGN KEY (student_id) REFERENCES Student(student_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (course_id) REFERENCES Course(course_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

----------------------------------------------------
-- 9. Certificate
----------------------------------------------------
CREATE TABLE Certificate (
  certificate_id  INTEGER PRIMARY KEY,
  student_id      INTEGER NOT NULL,
  course_id       INTEGER NOT NULL,
  date_issued     TEXT NOT NULL,
  certificate_url TEXT,
  FOREIGN KEY (student_id) REFERENCES Student(student_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (course_id) REFERENCES Course(course_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
