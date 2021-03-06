set hive.explain.user=false;
SET hive.vectorized.execution.enabled=false;
set hive.fetch.task.conversion=none;
set hive.cli.print.header=true;

CREATE TABLE T1_n123(key INT, value INT) STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '../../data/files/groupby_groupingid.txt' INTO TABLE T1_n123;

set hive.groupby.skewindata = true;

-- SORT_QUERY_RESULTS

SELECT key, value, GROUPING__ID, count(*) from T1_n123 GROUP BY key, value WITH ROLLUP;
SELECT key, value, GROUPING__ID, count(*) from T1_n123 GROUP BY ROLLUP (key, value);

SELECT GROUPING__ID, count(*)
FROM
(
SELECT key, value, GROUPING__ID, count(*) from T1_n123 GROUP BY key, value WITH ROLLUP
) t
GROUP BY GROUPING__ID;

SELECT GROUPING__ID, count(*)
FROM
(
SELECT key, value, GROUPING__ID, count(*) from T1_n123 GROUP BY ROLLUP(key, value)
) t
GROUP BY GROUPING__ID;


SELECT t1.GROUPING__ID, t2.GROUPING__ID FROM (SELECT GROUPING__ID FROM T1_n123  GROUP BY key,value WITH ROLLUP) t1
JOIN 
(SELECT GROUPING__ID FROM T1_n123 GROUP BY key, value WITH ROLLUP) t2
ON t1.GROUPING__ID = t2.GROUPING__ID;

SELECT t1.GROUPING__ID, t2.GROUPING__ID FROM (SELECT GROUPING__ID FROM T1_n123  GROUP BY ROLLUP(key,value)) t1
JOIN
(SELECT GROUPING__ID FROM T1_n123 GROUP BY ROLLUP(key, value)) t2
ON t1.GROUPING__ID = t2.GROUPING__ID;





set hive.groupby.skewindata = false;

SELECT key, value, GROUPING__ID, count(*) from T1_n123 GROUP BY key, value WITH ROLLUP;

SELECT GROUPING__ID, count(*)
FROM
(
SELECT key, value, GROUPING__ID, count(*) from T1_n123 GROUP BY key, value WITH ROLLUP
) t 
GROUP BY GROUPING__ID;

SELECT t1.GROUPING__ID, t2.GROUPING__ID FROM (SELECT GROUPING__ID FROM T1_n123  GROUP BY key,value WITH ROLLUP) t1
JOIN 
(SELECT GROUPING__ID FROM T1_n123 GROUP BY key, value WITH ROLLUP) t2
ON t1.GROUPING__ID = t2.GROUPING__ID;


