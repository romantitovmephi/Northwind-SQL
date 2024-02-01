SELECT amname FROM pg_am  -- увидеть доступные типы индексов

EXPLAIN  -- увидеть план выполнения запроса

CREATE TABLE perf_test(
	id int,
	reason text COLLATE "C",
	annotation text COLLATE "C"
);

-- заполним таблицу
INSERT INTO perf_test(id, reason, annotation)
SELECT s.id, md5(random()::text), null           -- md5(random()::text) ген-ет рандомный текст
FROM generate_series(1, 1000000) AS s(id)
ORDER BY random();

-- чтобы был разный текст в reason и annotation
UPDATE perf_test
SET annotation = UPPER(md5(random()::text));

EXPLAIN
SELECT *
FROM perf_test
WHERE id = 37000    -- без индекса будет вып-ся parallel seq scan, с индексом - index scan

-- 1 построение простого индекса
CREATE INDEX idx_perf_test_id ON perf_test(id);

-- индекс по двум колонкам
CREATE INDEX idx_perf_test_reason_annotation ON perf_test(reason, annotation);

-- будет index scan по обоим колонкам или только по первой
EXPLAIN
SELECT *        
FROM perf_test
WHERE reason LIKE 'bc%' AND annotation LIKE 'AB%'; 

-- для второй колонки, в таком случае, нужен отдельный индекс
CREATE INDEX idx_perf_test_annotation ON perf_test(annotation);

EXPLAIN
SELECT *        
FROM perf_test
WHERE annotation LIKE 'AB%';

-- 2 для выражения (или функции) нужно строить отдельный индекс, например для LOWER(annotation)
CREATE INDEX idx_perf_test_annotation_lower ON perf_test(LOWER(annotation));

EXPLAIN
SELECT *        
FROM perf_test
WHERE LOWER(annotation) LIKE 'ab%';

-- 3 для ускорения поиска по регулярным выражениям можно построить индекс gin
CREATE EXTENSION pg_trgm;

CREATE INDEX trgm_idx_perf_test_reason ON perf_test USING gin (reason gin_trgm_ops);

EXPLAIN ANALYZE
SELECT *        
FROM perf_test
WHERE reason LIKE '%dfe%';