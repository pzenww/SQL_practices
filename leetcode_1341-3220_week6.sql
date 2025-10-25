-- 1341

/*
SELECT
    (SELECT name
     FROM (
         SELECT user_id, COUNT(*) AS cnt
         FROM MovieRating
         GROUP BY user_id
         ORDER BY cnt DESC
         LIMIT 1
     ) t1
     JOIN Users u ON u.user_id = t1.user_id),
     
    (SELECT title
     FROM (
         SELECT movie_id, rating
         FROM MovieRating
         ORDER BY rating DESC
         LIMIT 1
     ) t2
     JOIN Movies m ON m.movie_id = t2.movie_id)
FROM MovieRating mr;

원래 서브쿼리로만 해결하려고 했는데 구조적 오류가 발견됐다그 함..
솔직히 구조적 규칙이나 쿼리별 금지사항/고려할 점을 알고 쿼리를 작성하면 오류가 덜 발생할 거 같은데 좀 아쉽
*/

-- 최적 쿼리

(SELECT name AS results
FROM MovieRating JOIN Users USING(user_id)
GROUP BY name
ORDER BY COUNT(*) DESC, name -- 가장 많이 평가한 것과 이름 알파벳 순서 조건을 동시에 order by로 정렬
LIMIT 1)

UNION ALL

(SELECT title AS results
FROM MovieRating JOIN Movies USING(movie_id)
WHERE EXTRACT(YEAR_MONTH FROM created_at) = 202002 -- EXTRACT(part FROM date_column) → 날짜(date 또는 datetime) 타입에서 특정 부분(part) 을 뽑아내는 함수
GROUP BY title
ORDER BY AVG(rating) DESC, title
LIMIT 1);

/*
각각 조건을 충족하는 열 값을 추출할 때는 위 쿼리처럼 하나씩 조건에 맞는 값을 선택하고 같은 이름으로 정의한 뒤 (as results) UNION ALL 을 활용하는 것도 좋을 방법인듯
*/

-- UNION: 중복 제거
-- UNION ALL: 중복 제거 안 함


-- 1393

/*
with buy_price as (
    select
    stock_name,
    -price as neg_price
    from stocks
    where operation = 'Buy'
),
sell_price as (
    select
    stock_name,
    price as pos_price
    from stocks
    where operation = 'Sell'
)
select
    stock_name,
    (sum(b.neg_price)+sum(s.pos_price))
from buy_price b
left join sell_price s using(stock_name)
group by stock_name

이렇게 하려고 했으나
지금 쿼리는 buy_price와 sell_price에서 각각 여러 행이 존재할 때
LEFT JOIN 후에 곱집합(cross join)처럼 행이 불필요하게 늘어날 수 있다고 함..

그래서 아래처럼 바꿈
*/

WITH buy_price AS (
    SELECT stock_name, SUM(-price) AS neg_price -- CTE 안에서 미리 주식 이름별 SUM을 계산해두기
    FROM stocks
    WHERE operation = 'Buy'
    GROUP BY stock_name
),
sell_price AS (
    SELECT stock_name, SUM(price) AS pos_price -- 동일
    FROM stocks
    WHERE operation = 'Sell'
    GROUP BY stock_name
)
SELECT
    stock_name,
    SUM(neg_price + pos_price) AS capital_gain_loss -- CTE에서 미리 계산해둔 SUM값을 가져와서 합하기
FROM (
    SELECT stock_name, neg_price, 0 AS pos_price FROM buy_price 
    UNION ALL -- 두 CTE 구조가 같기 때문에 이럴 때는 JOIN 보다 UNION이 적합
    SELECT stock_name, 0 AS neg_price, pos_price FROM sell_price
) t
GROUP BY stock_name;



-- 1907

/*
with salary as(
    select
        account_id,
        (case when income < 20000 then 'Low Salary'
              when income >= 20000 and income <= 50000 then 'Average Salary'
              when income > 50000 then 'High Salary'
              end) as category
    from accounts
)
select
    category,
    (case when count(account_id)>0 then count(account_id)
         else 0 end) as accounts_count
from salary
group by category

이렇게 했는데 !! 거의 다 왔는데 !!
category에 해당하는 값이 없을 때 결과 0을 반환하느걸 구현 안 해서 아래처럼 수정
*/

WITH salary AS (
    SELECT
        account_id,
        CASE
            WHEN income < 20000 THEN 'Low Salary'
            WHEN income >= 20000 AND income <= 50000 THEN 'Average Salary'
            WHEN income > 50000 THEN 'High Salary'
        END AS category
    FROM accounts
)
SELECT
    c.category,
    COALESCE(COUNT(s.account_id), 0) AS accounts_count -- null로 채어워진건 0으로 바꿔주는거 COALESCE 은근 여기저기 많이 쓰이는거 같아서 잘 기억하기
FROM (
    SELECT 'Low Salary' AS category -- 어떤 상황에서든 무조건 세가지 카테고리가 나오는 테이블을 만는건데.. 솔직히 썩 와닿진 않음
    UNION ALL
    SELECT 'Average Salary'
    UNION ALL
    SELECT 'High Salary'
) c
LEFT JOIN salary s
    ON c.category = s.category -- 억테이블이랑 salary 구분해둔 테이블이랑 합치기 (average salary 카테고리는 salary에 해당하는 값이 없으니 null로 채워짐)
GROUP BY c.category;



-- 1934
/*
WITH confirmed_cnt AS (
    SELECT
        user_id,
        COUNT(*) AS confirmed_cnt
    FROM Confirmations
    WHERE action = 'confirmed'
    GROUP BY user_id
),
total_cnt AS (
    SELECT
        user_id,
        COUNT(*) AS total_cnt
    FROM Confirmations
    GROUP BY user_id
) 여기까진 잘 했음!! 
*/

/*
이번에도 마찬가지로 null 값으로 들어가는 부분은 COALESCE로 0 처리해줘야하는데 
이게 문제가 아니라 애초에 confirmations 테이블에 없는 아이디 6을 잘 처리하는 방법이 잘 생각이 안 남 ..
그래서 답안 구경하다가 이렇게 간단하게 할 수 있는거 보고 충격 받음..
*/
  
select s.user_id, round(avg(if(c.action="confirmed",1,0)),2) as confirmation_rate
from Signups as s left join Confirmations as c on s.user_id= c.user_id group by user_id;

-- select 안에서 if 쓰는거 첨 보는듯 신기
-- 이게 select 안에서 쓰면 안돼서 CTE로 따로 빼서 만들어야하는 쿼리랑 if처럼 써도 되는 쿼리랑 좀 정리해서 공부해두면 더 도움될듯



-- 3220 (마지막!)
/*
원래 CTE 만들어서 하려고 했는데 그냥 간단하게 case when으로 해결할 수 있을 거 같아서
*/

select 
    transaction_date, 
    sum(case when amount%2!=0 then amount else 0 end) as odd_sum, 
    sum(case when amount%2=0 then amount else 0 end) as even_sum 
from transactions 
group by transaction_date 
order by transaction_date;
