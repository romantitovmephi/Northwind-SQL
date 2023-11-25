--1
CREATE TABLE exam
(
	exam_id serial UNIQUE NOT NULL,
	exam_name varchar(256), 
	exam_date date
)
--test
INSERT INTO exam (exam_name, exam_date)
VALUES
('Math', '2023-06-01')

INSERT INTO exam (exam_name, exam_date)
VALUES
('Phys', '2023-06-11')

TRUNCATE TABLE exam RESTART IDENTITY

SELECT *
FROM exam
--
--2
ALTER TABLE exam
DROP CONSTRAINT exam_exam_id_key

--3
ALTER TABLE exam
ADD PRIMARY KEY(exam_id)

--4
CREATE TABLE person
(
	person_id int PRIMARY KEY,
	first_name varchar,
	last_name varchar
)
--5
CREATE TABLE passport
(
	passport_id int PRIMARY KEY,
	serial_num int NOT NULL,
	registration varchar,
	person_id int,
	
	CONSTRAINT FK_passport_person FOREIGN KEY (person_id) REFERENCES person(person_id)
)
--6
ALTER TABLE book
ADD COLUMN weight decimal CONSTRAINT CHK_book_weight CHECK (0 < weight AND weight < 100)
--7
INSERT INTO book
VALUES
(5,'book', 456, 1, -99)

SELECT *
FROM book
--
--8
CREATE TABLE student
(
	student_id serial PRIMARY KEY,
	full_name varchar,
	course int DEFAULT 1
)
DROP TABLE student

INSERT INTO student (full_name, course)
VALUES
('John Wik', 3)

--9
INSERT INTO student (full_name)
VALUES
('Jack Milk')

--10
ALTER TABLE student
ALTER COLUMN course DROP DEFAULT

