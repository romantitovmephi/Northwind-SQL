--1
CREATE TABLE teacher
(
	teacher_id serial, 
	first_name varchar, 
	last_name varchar, 
	birthday date, 
	phone varchar, 
	title varchar
)

--2
ALTER TABLE teacher
ADD COLUMN middle_name varchar

--3
ALTER TABLE teacher
DROP COLUMN middle_name

--4
ALTER TABLE teacher
RENAME birthday TO birth_date

--5
ALTER TABLE teacher
ALTER COLUMN phone SET DATA TYPE varchar(32)

--6
CREATE TABLE exam
(
	exam_id serial, 
	exam_name varchar(256), 
	exam_date date
)

--7
INSERT INTO exam (exam_name, exam_date)
VALUES
('Math', '2023-06-01'),
('Physics', '2023-06-07'),
('Topology', '2023-06-15')

--8
SELECT *
FROM exam

--9
TRUNCATE TABLE exam RESTART IDENTITY

