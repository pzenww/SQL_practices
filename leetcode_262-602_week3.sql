-- 262(HARD)

/*
테이블 구조 짜는건 잘했으나 JOIN하는 방법이랑 '', "" 사용법이 헷갈려서 오류남
*/

/*
JOIN 할 때 동일한 컬럼명이 없는 경우 JOIN 하는 방법
> 조인하는 컬럼들에 맞게 테이블에 별칭을 붙이고 각각의 컬럼을 기준으로 조인
예시)
join Users uc on t.client_id = uc.users_id
join Users ud on t.driver_id = ud.users_id

위와 같이 여러번 조인해야하는 경우 where로 조건을 걸명 에러가 뜸
> 조인하는 쿼리 뒤에 and 별칭.banned = 'No'와 같이 조건을 걸어서 조인해야함
예시)
join Users uc on t.client_id = uc.users_id and uc.banned = 'No'
join Users ud on t.driver_id = ud.users_id and ud.banned = 'No'
*/

/*
데이터 값을 작성할 때: '' 사용
별칭을 지정할 때 띄어쓰기가 필요한 경우: "" 사용
*/

select
    request_at as Day,
    round(
        sum(case when status like 'cancelled_by_%' then 1 else 0 end) -- 조건을 만족하도록 테이블을 조인한 뒤, 필요한 데이터값 추출
        /count(*)
        , 2) as "Cancellation Rate"
from Trips as t
join Users uc on t.client_id = uc.users_id and uc.banned = 'No' -- banned가 아닌 client_id를 JOIN
join Users ud on t.driver_id = ud.users_id and ud.banned = 'No' -- banned가 아닌 driver_id를 JOIN
where request_at between '2013-10-01' and '2013-10-03'
group by request_at;

/*
또다른 방법: 
*/

WITH banned_users AS ( -- 조건에 대해 먼저 테이블을 생성
    SELECT users_id
    FROM Users
    WHERE banned = "Yes"
)

SELECT 
    request_at AS Day, 
    ROUND(SUM(IF(status != "completed", 1, 0)) / COUNT(*), 2) AS "Cancellation Rate"
FROM Trips
WHERE 
    request_at BETWEEN "2013-10-01" AND "2013-10-03"
    AND client_id NOT IN (SELECT * FROM banned_users) -- 조건 테이블을 활용하여 조건을 만족하도록 작석
    AND driver_id NOT IN (SELECT * FROM banned_users)
GROUP BY request_at;



-- 550

/*
처음 로그인 한 날 + 1일 값이 테이블에 존재할 때 카운트하는 방식으로 쿼리를 작성하고 싶었으나
집계함수 안에서 또 다른 집계함수를 쓰는것은 불가능!
> 따라서 서브쿼리(CTE)를 정의해서 진행해야함
*/

/*
개인적으로 잘 안 풀려서 그냥 지피티 도움 받음...
그 결과 가장 효율적인 풀이와 설명 알려줌 ㅎ
*/

WITH first_log AS (                              -- 각 player 첫 로그인일 구함
    SELECT 
        player_id,
        MIN(event_date) AS first_day             -- MIN으로 첫 로그인일 추출
    FROM Activity
    GROUP BY player_id
)
SELECT 
    ROUND(
        AVG(
            CASE 
                WHEN a.event_date IS NOT NULL    -- 다음날 로그인 있으면 1
                THEN 1 
                ELSE 0                           -- 없으면 0
            END
        ), 
        2
    ) AS fraction                               -- 전체 player 중 다음날 로그인한 비율
FROM first_log f
LEFT JOIN Activity a
  ON f.player_id = a.player_id                  -- player_id 매칭
 AND a.event_date = DATE_ADD(f.first_day, INTERVAL 1 DAY); -- 첫 로그인 다음날 기록만 확인

/*
원래 분자/분모 형태로 만든 후 별칭을 붙이는 방식으로 쿼리를 짰는데
이 방법 대신 AVG를 활용하면 더 쉽게 계산할 수 있는게 새로운 인사이트 !
분자/전체인 경우에는 AVG를 사용해도 좋을 것 같음
*/

/*
AND a.event_date = DATE_ADD(f.first_day, INTERVAL 1 DAY) 조건을 충족하는 것만 조인해서
다음날 로그인이 있으면 데이터값이 있고 다음날 로그인이 없으면 NULL임
> CASE WHEN a.event_date IS NOT NULL THEN 1 ELSE 0 END 쿼리로 해결 가능
*/



-- 570

/*
문제 이해를 잘 못해서

with direct_reports as
(
    select
        id,
        name,
        count(managerId) as reports
    from Employee
    group by id
)
select
    dr.name
from Employee e
join direct_reports dr on e.id = dr.id
and dr.reports >= 5;

이렇게 짰다가 수정
*/

SELECT name 
FROM Employee 
WHERE id IN (
    SELECT managerId  -- 애초에 name과 id가 일대일 대응이기 때문에 조건을 서브쿼리로 만들고 그 조건에 해당되는 id를 뽑으면 됨
    FROM Employee 
    GROUP BY managerId -- 그냥 id로 GROUP BY 해도 됨
    HAVING COUNT(*) >= 5) 



-- 585

WITH tiv_multi AS (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
),
unique_city AS (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
)
SELECT ROUND(SUM(i.tiv_2016), 2) AS tiv_2016
FROM Insurance i
JOIN tiv_multi t
  ON i.tiv_2015 = t.tiv_2015
JOIN unique_city c
  ON i.lat = c.lat AND i.lon = c.lon;

/*
틀렸던 포인트
1) 서브쿼리를 여러개 작성할 땐 with as 를 반복하면 안 되고 with as ~, as ~ 이런식으로 작성
2) lat, lon  같은 쌍으로 걸린 조건은 그냥 같이 group by 하면 됨
3) 조인은 상황에 따라
  - PK ↔ FK 관계일 때는 무조건 그 키 기준으로 JOIN (가장 보편적)
  - 조건 필터링을 위해 만든 CTE/서브쿼리는 → 조건 걸었던 컬럼으로 JOIN (예: tiv_2015, lat+lon)

아직까지는 조인 걸 때 어떤 컬럼을 기준으로 걸지, 어떤 식으로 서브쿼리를 만드는게 효율적인지 헷갈리는듯
*/



-- 601(HARD)

/*
LAG(column_name, offset, default) OVER (PARTITION BY ... ORDER BY ...) : 현재 행에서 이전 행의 값을 가져오는 함수
LEAD(column_name, offset, default) OVER (PARTITION BY ... ORDER BY ...) : 현재 행에서 다음 행의 값을 가져오는 함수

근데 이 문제는 연속 3개 이상이어서 더 어려웠던 것 같음
*/

WITH id_order AS (
  SELECT
      id,
      visit_date,
      people,
      LAG(id, 1)  OVER (ORDER BY id) AS prev1, -- 이전 행
      LAG(id, 2)  OVER (ORDER BY id) AS prev2, -- 전전 행
      LEAD(id, 1) OVER (ORDER BY id) AS next1, -- 다음 행
      LEAD(id, 2) OVER (ORDER BY id) AS next2 -- 다다음 행
  FROM Stadium
  WHERE people >= 100 -- 서브쿼리에서부터 조건 걸어서 추리는건 잘함!
)
SELECT
    id,
    visit_date,
    people
FROM id_order
WHERE
      (prev1 IS NOT NULL AND id - prev1 = 1 AND next1 IS NOT NULL AND next1 - id = 1)  -- 구간의 가운데
   OR (next2 IS NOT NULL AND next2 - id = 2)                                           -- 구간의 시작(나, 나+1, 나+2)
   OR (prev2 IS NOT NULL AND id - prev2 = 2)                                           -- 구간의 끝(나-2, 나-1, 나)
ORDER BY visit_date;

/*
지피티의 도움으로 답안을 수정하였으나
WHERE
      (prev1 IS NOT NULL AND id - prev1 = 1 AND next1 IS NOT NULL AND next1 - id = 1)  -- 구간의 가운데
   OR (next2 IS NOT NULL AND next2 - id = 2)                                           -- 구간의 시작(나, 나+1, 나+2)
   OR (prev2 IS NOT NULL AND id - prev2 = 2)                                           -- 구간의 끝(나-2, 나-1, 나)
이 부분이 잘 이해가 안 갔삼 ..
> 구간의 가운데/시작/끝 중 하나라도 만족한다면 연속하는 3행 이상의 경우라고 정의하는 발상이 .. 내 머리로는 아직 생각해낼 수 없는듯 ㅠ
*/

-- 이 방법으로 한 번 다시 해보기


-- 602

/*
일단 중복이 발생하더라도 distinct로 거른다는 마인드로 requester/accepter 각각 기준의 데이터를 동일한 기준으로 통일하는 발상이 중요했던듯
*/

with id_friend as
(
    SELECT requester_id AS id, accepter_id AS friend FROM RequestAccepted
UNION ALL
    SELECT accepter_id AS id, requester_id AS friend FROM RequestAccepted
)
SELECT id, COUNT(DISTINCT friend) AS num -- 가장 많은 사람이 1명일 땐 distinct 없어도 되긴 함
FROM id_friend
GROUP BY id
order by num desc limit 1; -- max는 집계합수라 제한이 은근 많으므로 가장 큰 수 / 가장 작은 수 하나 뽑을 떈 order by + limit 조합을 활용할 것
