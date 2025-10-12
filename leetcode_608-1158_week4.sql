-- 608

/*
가능한 CTE와 서브쿼리를 만들지 않고 직관적으로 쿼리를 짜려고 했으나,
아예 사용하지 않고 작성하는건 불가능인거 같음...
Root와 Leaf는 조건이 명확해서 case when으로 만들기 쉬웠으나,
Inner에서 자꾸 오류가 나서 결국 Inner 조건을 서브쿼리로 작성
*/

select
    id,
    case when p_id is null then 'Root'
         when id in(
            select p_id
            from tree
            where p_id is not null  -- Inner의 조건은 자기 id가 p_id에도 존재해야함 (대신 1은 이미 null 조건에서 걸러졌으므로 정상 작동하는듯)
         ) then 'Inner'
         else 'Leaf' end as 'type'
from tree;

/*
쉬운 풀이방법을 봤는데, 똑같은데 서브쿼리에서 where p_id is not null 이 조건은 필요없는 것 같음
아마 첫번째 case when 조건에서 null인게 걸러져서 그런듯  -> 순서대로 조건 걸러짐
*/



-- 626

/*
어려움.. 연속되는 숫자끼리 id를 바꿀 방법이 생각이 안 남 .. 

그래서 지피티한테 힌트 달라고 해서
- 짝수(id % 2 = 0) → 앞자리(id-1) 로 이동
- 홀수(id % 2 = 1) → 뒷자리(id+1) 로 이동
까진 이해를 함.. 
(다음에 비슷한 문제 나오면 그땐 지금 외운거 써먹는 수 밖에 없을듯)

근데? 여기서 조심해야하는게 THEN id = id+1 이런 파이썬식 사고로 덮어씌우는게 아니라
그냥 THEN 다음 값이 데이터에 찍히는 거기 땜에 id+1을 쓰는 거였음...
*/

select
    case when id%2 = 1
             and id <> (select max(id) from seat)  -- 홀수 중에서도 홀수로 끝나는 경우 마지막 홀수는 바꾸면 안되니까 조건 추가
             then id + 1
         when id%2 = 0 then id - 1
         else id
         end as id,
    student
from seat
order by id;

/*
추가로 실수한 거 ㅎ..

1. 이게 대소 비교를 할 때 max를 쓰고 싶으면 그냥 max만 쓰면 안 되고
   그 max를 쓰는 서브쿼리를 만들어야함.
   그래서 max(id) 이거 아니고 select max(id) from seat 이런식으로 서브쿼리 안에서 집계함수를 써야하는 것

2. 정신없긴 한데 그래도 마지막에 Output에 맞게 정렬 꼭 해주긔..
   위 쿼리로 순서가 막 2143 이렇게 뒤죽박죽 되어있기 땜에 꼭 정렬해주고 끝나야함..
*/



-- 1045

/*
처음에는
with product as (
    select
        customer_id,
        (select
            count(product_key)
    from customer
    group by customer_id) as product_cnt
)
select
    customer_id
from product
where product_cnt = (select max(product_cnt) from product);
로 쿼리를 작성해서
상품의 갯수와 customer가 구입한 갯수가 동일하면 모두 구매한 고객으로 처리하는건 잘 접근했으나, 뭔가 꼬임

*/

/*
2트
select
    customer_id
from customer
where 
    (select count(distinct product_key) from product)
    = (select count(distinct product_key) from customer group by customer_id);
그냥 갯수 조건을 아예 서브쿼리로 한번에 넣어버림
흑 근데 또 안 됨.. 왜냐면 select count(distinct product_key) from customer group by customer_id 가 1개 이상의 값을 반환해서 = 비교가 불가능..

답답해서 지피티한테 고쳐달랬더니
group by를 밖으로 빼고 having으로 조건 넣으라네
*/

select
    customer_id
from customer
group by customer_id
having 
    (select count(distinct product_key) from product)
    = (select count(distinct product_key));  --드디어 성공 ...



-- 1070 (오오 이 문제 뭔가 실무 문제 같고 조은듯!)

/*
1트
select 
    product_id, 
    year as first_year, 
    quantity, 
    price 
from sales 
group by product_id 
having year = (select min(year) from sales)
아 근데 일케 하니까 product_id별 첫번째 연도가 아니라 전체 product 중 첫번째 연도로 됨...
*/

SELECT product_id, year AS first_year, quantity, price
FROM (
  SELECT
    s.*,
    MIN(year) OVER (PARTITION BY product_id) AS first_year -- MIN() OVER (PARTITION BY ) 에서 OVER~이 거의 모든 집계함수랑 같이 쓸 수 있다는 점 ㄷ
  FROM Sales AS s
) t -- 이런식으로 서브쿼리 작성하는거 좀 연습해봐야할듯
WHERE t.year = t.first_year;

/*
GROUP BY vs PARTITION BY

[ GROUP BY ]
- 역할: 데이터를 그룹 단위로 **요약(Aggregate)**  
- 행 수 변화: ✅ 줄어듦 (그룹당 1행만 남음)  
- 사용 위치: `SELECT`, `HAVING`, `ORDER BY` 등  
- 결과 형태: 그룹별로 하나의 집계 결과만 남김  

[ PARTITION BY ]
- 역할: 데이터를 그룹(Partition)으로 나누되 행은 유지, 각 파티션 내에서 집계 또는 순위 계산.
- 행 수 변화: ❌ 유지됨 (원본 행 그대로 존재)
- 사용 위치: SELECT절의 OVER() 내부
- 결과 형태: 파티션별 집계 결과가 모든 행마다 표시됨
*/

/*
들여쓰기는 실무에서 정해서 정해진대로 함
왜냐면 들여쓰기는 크게 코드에 영향이 없어서 그냥 가독성만을 위해서 하는 것)
*/


-- 1158 (오 이거도 약간 실무 같당)

/*
1트
select
    distinct o.buyer_id,
    u.join_date,
    (select 
        count(order_date) 
    from orders 
    where year(order_date) = 2019) as orders_in_2019
from orders as o
join users as u on o.buyer_id = u.user_id
order by o.buyer_id
근데 이렇게 하니까 또 각 buyer_id별 2019년에 주문한 횟수가 아니라 전체 buyer에서 2019년에 주문한 횟수로 됨...
*/

SELECT 
  u.user_id AS buyer_id,
  u.join_date,
  COUNT(o.order_id) AS orders_in_2019
FROM Users u -- 기준 테이블 잘 잡긔..
LEFT JOIN Orders o 
  ON u.user_id = o.buyer_id AND YEAR(o.order_date) = 2019 -- 애초에 2019로 거르고 join
GROUP BY u.user_id; -- sql 표준에서는 user_id로만 group by 하면 안 되고, select에서 비집계 컬럼은 다 group by에 넣어야함 > GROUP BY user_id, join_date; 이렇게 해야함

/*
join vs left join

join (inner join): A and B
left join: A 전체 + B는 A와의 여집합만 포함
*/
