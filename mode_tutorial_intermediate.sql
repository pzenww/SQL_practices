-- 0: Putting it together

-- 1: SQL Aggregate Functions

-- 2: SQL COUNT
/*
COUNT(계산하고픈 열 이름): a SQL aggregate function for counting the number of rows in a particular column
*/

SELECT COUNT(*)
  FROM tutorial.aapl_historical_stock_price;
  
SELECT COUNT(high)
  FROM tutorial.aapl_historical_stock_price; -- COUNT(*)보다 개수가 적음 > null이 존재하기 때문 (null값을 제외하고 카운팅됨)
  
SELECT COUNT(low)
  FROM tutorial.aapl_historical_stock_price;
  
/*
COUNT()는 숫자가 아닌 열에도 사용할 수 있음
*/

SELECT COUNT(date)
  FROM tutorial.aapl_historical_stock_price;
  
/*
머릿글이 count라고 지정되는 것보단 별칭을 붙여주는게 확인하기 더 편함
*/

SELECT COUNT(date) AS count_of_date
  FROM tutorial.aapl_historical_stock_price;
  
SELECT COUNT(date) AS "Count Of Date"  -- 공백을 사용하는 경우엔 꼭 "" 붙여주기 ('' 안 됨) > 이 경우에만 "" 이고 나머지는 다 '' 붙임
  FROM tutorial.aapl_historical_stock_price;
  
SELECT * FROM tutorial.aapl_historical_stock_price;

SELECT 
  COUNT(date) AS count_of_date,
  COUNT(year) AS count_of_year,
  COUNT(month) AS count_of_month,
  COUNT(open) AS count_of_open,
  COUNT(high) AS count_of_high,
  COUNT(low) AS count_of_low,
  COUNT(close) AS count_of_close,
  COUNT(volume) AS count_of_volume,
  COUNT(id) AS count_of_id
FROM tutorial.aapl_historical_stock_price;


-- 3: SQL SUM
/*
SUM: a SQL aggregate function. that totals the values in a given column (단 숫자만 가능/수직으로만 계산)
SUM은 null을 0으로 취급하기 때문에 null 걱정 안 해도 됨!
*/

SELECT SUM(volume)
  FROM tutorial.aapl_historical_stock_price;
  
SELECT SUM(open)/COUNT(open) as avg_open
  FROM tutorial.aapl_historical_stock_price;


-- 4: MIN/MAX
/*
MIN/MAX: SQL aggregation functions that return the lowest and highest values in a particular column
*/

SELECT MIN(volume) AS min_volume,
       MAX(volume) AS max_volume
  FROM tutorial.aapl_historical_stock_price;
  
SELECT MIN(low) AS min_price
  FROM tutorial.aapl_historical_stock_price;
  
SELECT MAX(close - open)
  FROM tutorial.aapl_historical_stock_price;


-- 5: AVG
/*
AVG: SQL aggregate function that calculates the average of a selected group of values
특징 1) 숫자 열에만 사용할 수 있음
특징 2) Null 값을 완전히 무시
*/

SELECT AVG(high)
  FROM tutorial.aapl_historical_stock_price
 WHERE high IS NOT NULL;
 
SELECT AVG(high)
  FROM tutorial.aapl_historical_stock_price;
  
SELECT AVG(volume)
  FROM tutorial.aapl_historical_stock_price;


-- 6: GROUP BY
/*
GROUP BY: SQL aggregate function allows you to separate data into groups, which can be aggregated independently of one another
*/

SELECT year,
       COUNT(*) AS count
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year;
 
 SELECT year,
       month,
       COUNT(*) AS count
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year, month;
 
 SELECT year,
        month,
        SUM(volume) AS sum_volume
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year, month
  ORDER BY year, month;
  
SELECT year,
      avg(close - open) as average
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year;

SELECT month,
      max(high) as highest,
      min(low) as lowest
FROM tutorial.aapl_historical_stock_price
GROUP BY month
ORDER BY month;


-- 7: HAVING
/*
HAVING: the "clean" way to filter a query that has been aggregated
[ 쿼리 작성 순서 ]
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
*/

SELECT year,
       month,
       MAX(high) AS month_high
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year, month
HAVING MAX(high) > 400
 ORDER BY year, month;


-- 8: CASE
/*
The CASE statement is SQL's way of handling if/then logic
CASE WHEN ~ THEN ~ ELSE ~ END
여러 조건 중 OR 사용할 때 IN(,) 사용하면 더 편함
*/

SELECT * FROM benn.college_football_players;
 
 SELECT player_name,
       year,
       CASE WHEN year = 'SR' THEN 'yes'
            ELSE NULL END AS is_a_senior
  FROM benn.college_football_players;
  
SELECT player_name,
       year,
       CASE WHEN year = 'SR' THEN 'yes'
            ELSE 'no' END AS is_a_senior
  FROM benn.college_football_players;

SELECT player_name,
       state,
       CASE WHEN state = 'CA' THEN 'yes'
            ELSE NULL END AS from_cal
  FROM benn.college_football_players
  ORDER BY from_cal;
  
SELECT player_name,
       weight,
       CASE WHEN weight > 250 THEN 'over 250'
            WHEN weight > 200 THEN '201-250'
            WHEN weight > 175 THEN '176-200'
            ELSE '175 or under' END AS weight_group
  FROM benn.college_football_players;
  
SELECT player_name,
       weight,
       CASE WHEN weight > 250 THEN 'over 250'
            WHEN weight > 200 AND weight <= 250 THEN '201-250'
            WHEN weight > 175 AND weight <= 200 THEN '176-200'
            ELSE '175 or under' END AS weight_group
  FROM benn.college_football_players;
  
SELECT player_name,
       height,
       CASE WHEN height > 75 THEN 'over 75'
            WHEN height > 70 AND height <= 75 THEN '70-75'
            WHEN height > 65 AND height <= 70 THEN '65-70'
            ELSE '65 or under' END AS height_group
  FROM benn.college_football_players;
  
SELECT player_name,
       CASE WHEN year = 'FR' AND position = 'WR' THEN 'frosh_wr'
            ELSE NULL END AS sample_case_statement
  FROM benn.college_football_players;
  
SELECT *,
       CASE WHEN year IN('JR', 'SR') THEN player_name
            ELSE NULL END AS jr_sr
  FROM benn.college_football_players;
               
SELECT CASE WHEN year = 'FR' THEN 'FR'
            ELSE 'Not FR' END AS year_group,
            COUNT(*) AS count
  FROM benn.college_football_players
 GROUP BY year_group;
 
 SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(*) AS count
  FROM benn.college_football_players
 GROUP BY year_group;
 
SELECT CASE WHEN state IN ('CA','OR','WA') THEN 'West Coast'
            WHEN state = 'TX' THEN 'Texas'
            ELSE 'Others' END AS state_group,
            COUNT(*) AS count
  FROM benn.college_football_players
  WHERE weight >= 300
 GROUP BY state_group;
 
 SELECT CASE WHEN year IN ('FR', 'SO') THEN 'underclass'
            WHEN year IN ('JR', 'SR') THEN 'upperclass'
            ELSE NULL END AS class_group,
       SUM(weight) AS combined_player_weight
  FROM benn.college_football_players
 WHERE state = 'CA'
 GROUP BY class_group;
 
-- 피벗팅

SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(*) AS count
  FROM benn.college_football_players
 GROUP BY year_group;
 
SELECT COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count
  FROM benn.college_football_players;

-- 행 * 열 둘다 원하는 기준이 있을 때
SELECT state,
       COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count, -- 열 피벗팅
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count,
       COUNT(*) AS total_players
  FROM benn.college_football_players
 GROUP BY state; -- 행 피벗팅
 
SELECT CASE WHEN school_name < 'n' THEN 'A-M'
            WHEN school_name >= 'n' THEN 'N-Z'
            ELSE NULL END AS school_name_group,
       COUNT(*) AS players
  FROM benn.college_football_players
 GROUP BY school_name_group;



