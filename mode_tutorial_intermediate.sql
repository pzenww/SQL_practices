-- 1: Putting it together

-- 2: SQL Aggregate Functions

-- 3: SQL COUNT
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


-- 4: SQL SUM
/*
SUM: a SQL aggregate function. that totals the values in a given column (단 숫자만 가능/수직으로만 계산)
SUM은 null을 0으로 취급하기 때문에 null 걱정 안 해도 됨!
*/

SELECT SUM(volume)
  FROM tutorial.aapl_historical_stock_price;
  
SELECT SUM(open)/COUNT(open) as avg_open
  FROM tutorial.aapl_historical_stock_price;
