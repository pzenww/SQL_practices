-- 1: Using SQL in Mode

-- 2: SQL SELECT
# SELECT: indicates which columns you would like to view
# FROM: identifies the table that they live in

SELECT *
  FROM tutorial.us_housing_units;
  
SELECT year,
       month,
       west
  FROM tutorial.us_housing_units;
  
SELECT west AS "West_Region",
       south AS "South_Region"
  FROM tutorial.us_housing_units;
  
SELECT year AS "Year",
       month AS "Month",
       month_name AS "Month Name",
       west AS "West",
       midwest AS "Midwest",
       south AS "South",
       northeast AS "Northeast"
  FROM tutorial.us_housing_units;
  
-- 3: SQL LIMIT
# LIMIT: use limits as a simple way to keep their queries from taking too long to return

SELECT *
  FROM tutorial.us_housing_units
 LIMIT 100;
 
 SELECT *
  FROM tutorial.us_housing_units
 LIMIT 15;

-- 4: SQL WHERE
# WHERE: filtering the data using the WHERE

-- 5: SQL Comparison Operators
# Not equal to:	<> or !=
# You can use >, <, and the rest of the comparison operators on non-numeric columns as well—they filter based on alphabetical order

 SELECT *
  FROM tutorial.us_housing_units
 WHERE month = 1;
 
 SELECT *
  FROM tutorial.us_housing_units
 WHERE west > 30;
 
 SELECT *
  FROM tutorial.us_housing_units
 WHERE west > 50;
 
 SELECT *
  FROM tutorial.us_housing_units
 WHERE south <= 20;
 
 SELECT *
  FROM tutorial.us_housing_units
 WHERE month_name != 'January';
 
 SELECT *
  FROM tutorial.us_housing_units
 WHERE month_name > 'January';
 
 SELECT *
  FROM tutorial.us_housing_units
 WHERE month_name > 'J';
 
  SELECT *
  FROM tutorial.us_housing_units
 WHERE month_name = 'February';
 
 SELECT *
  FROM tutorial.us_housing_units
 WHERE month_name < 'O';
 
SELECT *
  FROM tutorial.us_housing_units
  WHERE month_name <= 'N';
  
  SELECT year,
       month,
       west,
       south,
       west + south AS south_plus_west
  FROM tutorial.us_housing_units;
  
  SELECT year,
       month,
       west,
       south,
       west + south - 4 * year AS nonsense_column
  FROM tutorial.us_housing_units;
  
SELECT 
  *,
  west + south + midwest + northeast as total
FROM tutorial.us_housing_units;

SELECT year,
       month,
       west,
       south,
       (west + south)/2 AS south_west_avg
  FROM tutorial.us_housing_units;
  
SELECT *
FROM tutorial.us_housing_units
WHERE west > ( midwest + northeast );

SELECT
  year,
  month,
  south / ( south + west + midwest + northeast ) * 100 as south_pct,
  west / ( south + west + midwest + northeast ) * 100 as west_pct,
  midwest / ( south + west + midwest + northeast ) * 100 as midwest_pct,
  northeast / ( south + west + midwest + northeast ) * 100 as northeast_pct
FROM tutorial.us_housing_units
WHERE year >= 2000;

-- 6: SQL Logical Operators
# LIKE: allows you to match similar values, instead of exact values.
# IN: allows you to specify a list of values youd like to include.
# BETWEEN: allows you to select only rows within a certain range.
# IS NULL: allows you to select rows that contain no data in a given column.
# AND: allows you to select only rows that satisfy two conditions.
# OR: allows you to select rows that satisfy either of two conditions.
# NOT: allows you to select rows that do not match a certain condition.

SELECT *
  FROM tutorial.billboard_top_100_year_end
ORDER BY year DESC, year_rank;

-- 7: SQL LIKE
# %: used above represents any character or set of characters
# LIKE: case-sensitive, meaning that the above query will only capture matches (대소문자 구분!)
# ILIKE: LIKE랑 동일한 기능인데 대소문자 구분 안 함
# _ (a single underscore): substitute for an individual character

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE "group_name" LIKE 'Snoop%';
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE "group_name" ILIKE 'snoop%';
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE artist ILIKE 'dr_ke';
 
 SELECT *
 FROM tutorial.billboard_top_100_year_end
 WHERE artist LIKE 'Ludacris';
 
 SELECT *
 FROM tutorial.billboard_top_100_year_end
 WHERE artist LIKE 'DJ%';

-- 8: SQL IN
# IN: a logical operator in SQL that allows you to specify a list of values that youd like to include in the results

 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year_rank IN (1, 2, 3);
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE artist IN ('Taylor Swift', 'Usher', 'Ludacris');
 
  SELECT *
 FROM tutorial.billboard_top_100_year_end
 WHERE artist ILIKE 'm.c.%';
 
  SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE artist ILIKE 'Elvis%';
 
  SELECT *
  FROM tutorial.billboard_top_100_year_end
WHERE artist IN ('Elvis Presley', 'M.C. Hammer');

SELECT *
 FROM tutorial.billboard_top_100_year_end
 WHERE artist ILIKE 'hammer';
 
 SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE "group_name" IN ('M.C. Hammer', 'Hammer', 'Elvis Presley');

-- 9: SQL BETWEEN
# BETWEEN: a logical operator in SQL that allows you to select only rows that are within a specific range

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year_rank BETWEEN 5 AND 10;
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year_rank >= 5 AND year_rank <= 10;
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year BETWEEN 1985 AND 1990; -- 주의! WHERE은 ,로 나열 못 하고 AND로만 나열 가능함

-- 10: SQL IS NULL
# IS NULL: a logical operator in SQL that allows you to exclude rows with missing data from your results

 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE artist IS NULL;
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE song_name IS NULL;

-- 11: SQL AND
# AND: a logical operator in SQL that allows you to select only rows that satisfy two conditions

 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2012 AND year_rank <= 10;
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2012
   AND year_rank <= 10
   AND "group_name" ILIKE '%feat%';
   
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank <= 10
  AND artist ILIKE '%Ludacris%';
  
SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year_rank = 1
   AND year IN (1990, 2000, 2010); -- AND 말고도 IN을 활용해서 작성하기!!

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year BETWEEN 1960 AND 1969
   AND song_name ilike '%love%';

-- 12: SQL OR
# OR: a logical operator in SQL that allows you to select rows that satisfy either of two conditions

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year_rank = 5 OR artist = 'Gotye';
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2013
   AND ("group_name" ILIKE '%macklemore%' OR "group_name" ILIKE '%timberlake%');
   
SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year_rank <= 10
   AND ("group_name" ILIKE '%Katy Perry%' OR "group_name" ILIKE '%Bon Jovi%');
   
SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE song_name LIKE '%California%'
   AND (year BETWEEN 1970 AND 1979 OR year BETWEEN 1990 AND 1999);
   
SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE group_name ILIKE '%Dr. Dre%'
   AND (year < 2001 OR year > 2009);

-- 13: SQL NOT
# NOT: a logical operator in SQL that you can put before any conditional statement to select rows for which that statement is false

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2013
   AND year_rank NOT BETWEEN 2 AND 3;
   
SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2013
   AND year_rank <= 3;
   
SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2013
   AND "group_name" NOT ILIKE '%macklemore%';
   
SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2013
   AND artist IS NOT NULL;
   
SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2013
   AND song_name NOT ilike '%a%';

-- 14: SQL ORDER BY
# ORDER BY: allows you to reorder your results based on the data in one or more columns

SELECT *
  FROM tutorial.billboard_top_100_year_end
 ORDER BY artist;

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2013
 ORDER BY year_rank;
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2013
 ORDER BY year_rank DESC;
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2012
 ORDER BY song_name DESC;
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank <= 3
 ORDER BY year DESC, year_rank;
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year_rank <= 3
 ORDER BY year_rank, year DESC;
 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year_rank <= 3
 ORDER BY 2, 1 DESC; -- 2번째 컬럼은 오름차순 정렬 > 1번째 컬럼은 내림차순 정렬

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2010
 ORDER BY year_rank, artist;

 
 SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE group_name ILIKE '%T-Pain%'
 ORDER BY year_rank DESC;
 
SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year_rank BETWEEN 10 AND 20
 AND YEAR IN (1993, 2003, 2013)
 ORDER BY year, year_rank;
