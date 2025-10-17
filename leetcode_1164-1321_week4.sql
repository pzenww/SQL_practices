-- 1164

/*
select
    p1.product_id,
    p2.new_price as price
from products p1
join 
(select * 
from products 
group by product_id
having max(change_date) 
) as p2;

처음에 이렇게 할랬는데 having이랑 max()를 같이 못쓴단다 흑..
그리고 'GROUP BY에는 집계되지 않은 컬럼(예: new_price, change_date)을 모두 포함할 수 없음' 이라는데 잘 이해가 안 가서 다시 물어보니까
*을 써버리면 행 중에서 어떤 값으로 선택해서 보여줘야 되는지 알 수 없어서 그런거라 함
그래서 *가 아니라 max() 같이 명확하게 select에서 지정해줘야됨
*/

/*
with before_16th as(
    select
    product_id,
    new_price
    from products
    where change_date <= '2019-08-16'
)
select
    p.product_id,
    (case when p.product_id in (select product_id from before_16th)
        then max(b.new_price)
    else 10 
    end) as price
from products p
join before_16th b on p.product_id = b.product_id
group by product_id

이거도 문법 자잘하게 틀린거 많이 고친 것..
1. 집계 함수 쓰려면 꼭 group by 써주기
2. (case when ~ then ~ / else ~ / end) as ~
3. join할 때 기준점 꼭 적어주기 on ~ = ~

하 근데 case when 안에 max()를 쓸 수 없단다
그래서 window 함수를 결국 써서 case when 부분을 간단하게 대체 -> 근데 전체 기준으로 max()가 잡힌건지 답이 이상하게 나옴..
*/

-- 결국

WITH cte AS
(SELECT *, RANK() OVER (PARTITION BY product_id ORDER BY change_date DESC) AS r 
FROM Products
WHERE change_date <= '2019-08-16')

SELECT product_id, new_price AS price
FROM cte
WHERE r = 1
UNION
SELECT product_id, 10 AS price
FROM Products
WHERE product_id NOT IN (SELECT product_id FROM cte);

/*
union 써서 쉽게 쉽게..
*/



-- 1174

/*
WITH cte AS (
    SELECT 
        customer_id,
        MIN(order_date) AS first_order_date,
        customer_pref_delivery_date,
        CASE 
            WHEN MIN(order_date) = customer_pref_delivery_date THEN 'immediate'
            ELSE 'scheduled'
        END AS order_state
    FROM Delivery
    GROUP BY customer_id, customer_pref_delivery_date
)
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN order_state = 'immediate' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS immediate_percentage
FROM cte;

이렇게 잘 썼는데 답이 자꾸 틀림;
*/

Select round(avg(order_date = customer_pref_delivery_date)*100, 2) as immediate_percentage
from Delivery
where (customer_id, order_date) in (
  Select customer_id, min(order_date) 
  from Delivery
  group by customer_id
);

-- 이렇게 쉽고 간단한 방법이 있었음 ..
-- avg(order_date = customer_pref_delivery_date) 이렇게 간단하게 해버리는게 벽 느껴지네..



-- 1193

select
    date_format(trans_date, '%Y-%m') as month,
    country,
    count(id) as trans_count,
    sum(case when state = 'approved' then 1 else 0 end) as approved_count,
    sum(amount) as trans_total_amount,
    sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
from transactions
group by country, date_format(trans_date, '%Y-%m')

/*
무난.. 했삼..
근데 이거 조심
처음에는 
amount in (select amount from transactions where state = 'approved') as approved_total_amount
이렇게 짰었는데 마지막 열을
근데 이렇게 하면 문제가 “금액이 approved 테이블에 포함되어 있냐”만 판단하는 불린(참/거짓) 식이어서 합계(sum) 계산이 아니라 0 또는 1만 반환됨
그래서 위처럼 해야함
*/



-- 1204

select
    person_name
from (
    select 
        person_name,
        sum(weight) over(order by turn) as total_weight
    from queue
) q
where total_weight <= 1000
order by total_weight desc
limit 1;

/*
처음에 비슷하게 생각하긴 함 근데 이걸 생각 못함
sum(weight) over(order by turn) as total_weight

SUM()에 OVER (ORDER BY ...)를 붙이면 한 줄씩 누적 계산을 하게 됨 > 각 행마다 누적합 값이 들어감

Alice | 250
Alex | 600
John Cena | 1000 이런식으로
*/



-- 1321

SELECT
    visited_on,
    (
        SELECT SUM(amount)
        FROM customer
        WHERE visited_on BETWEEN DATE_SUB(c.visited_on, INTERVAL 6 DAY) AND c.visited_on
    ) AS amount,
    ROUND(
        (
            SELECT SUM(amount) / 7
            FROM customer
            WHERE visited_on BETWEEN DATE_SUB(c.visited_on, INTERVAL 6 DAY) AND c.visited_on
        ),
        2
    ) AS average_amount
FROM customer c
WHERE visited_on >= (
        SELECT DATE_ADD(MIN(visited_on), INTERVAL 6 DAY)
        FROM customer
    )
GROUP BY visited_on;

/*
DATE_SUB(date, INTERVAL n DAY) : 특정 날짜(date)에서 n일을 뺀 날짜가 나오는 함수
DATE_ADD(date, INTERVAL n DAY) : 특정 날짜(date)에 n일을 더하는 날짜가 나오는 함수

주의!!!
가장 첫날부터 7일이 지나야 이동평균이 계산 가능하니까, 7일 이전의 데이터는 제외하는 조건 꼭 필요함
WHERE visited_on >= (SELECT DATE_ADD(MIN(visited_on), INTERVAL 6 DAY))*/
