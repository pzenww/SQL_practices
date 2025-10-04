-- 176

/*
OFFSET: 쿼리 결과에서 몇 개의 행을 건너뛸지를 지정하는 키워드로 보통 LIMIT (또는 FETCH) 와 같이 사용됨
LIMIT row_count OFFSET skip_count
row_count는 불러올 행 / skip_count는 건너뛸 행
*/

/* 
문제에서 SecondHighestSalary로 output이 나타나는 형태로 답을 지정했기 떄문에
SELECT () as SecondHighestSalary;로 output 설정해야함 
*/

-- answer:
select
    (select distinct 
    salary
    from Employee
    order by salary desc
    limit 1 offset 1)
    as SecondHighestSalary;



-- 177

/* 
CREATE FUNCTION: 사용자 정의 함수(User-Defined Function, UDF) 를 만들 때 쓰는 구문

CREATE FUNCTION > 함수가 아니라 MySQL에서 제공하는 기능임 > MySQL에서만 사용 가능
RETURNS 반환타입
BEGIN
   (함수 안에서 실행할 SQL 문)
   RETURN 결과값;
END;
*/

/*
주의할점: SET문 (얘도 MySQL에서만 제공하는 기능), RETURN문, CREATE FUNCTION문 총 3개의 쿼리를 실행한거기 때문에 ;도 꼭 각 쿼리 끝나고 써줘야함
*/

create function getNthHighestSalary(n int) returns int
begin
    set n = n-1; -- 2번째로 가장 높은 급여를 찾으려면 1번째로 높은 급여(1행)만 건너뛰면 되기 때문 (n, n-1)
    return
        (
        select distinct salary
        from employee
        order by salary desc
        limit 1 offset n -- set문을 먼저 실행시켜 건너뛰어야하는 행의 수를 설정했기 떄문에 n으로 진행
        );               -- offset문 뒤에는 n-1 같은 계산식을 쓸 수 없기 떄문에 set문으로 먼저 지정 필요함
end;



-- 178

/*
RANK문: 순위 매기기
RANK() OVER (PARTITION BY column_name ORDER BY column_name ASC|DESC)
PARTITION BY는 그룹별로 순위를 매겨야할 때 사용 (필요없으면 생략하고 바로 order by)

ROW_NUMBER() : 동점 관계없이 그냥 순번 1,2,3,4...
RANK() : 동점이면 같은 순위, 다음 순위 건너뜀 1,2,2,4...
DENSE_RANK() : 동점이면 같은 순위, 다음 순위 안 건너뜀 1,2,2,3...
*/

select
    score,
    dense_RANK() OVER (ORDER BY score DESC) as 'rank'
from scores
order by score desc;

-- RANK() 사용하지 않고 구하는 방법이 있긴 한데 RANK() 쓰는게 더 효율적
SELECT s1.score, 
       (SELECT COUNT(DISTINCT s2.score) -- 동일한 테이블에서 숫자 가져오기 (동일한 숫자는 하나로 취급)
        FROM Scores s2 
        WHERE s2.score >= s1.score) AS 'rank' -- 자기와 같거나 보다 더 큰 숫자의 개수를 세서 순위로 설정
FROM Scores s1  -- rank 와 같이 예약어로 이미 MySQL에 지정되어있는건 오류가 날 가능성이 커서 ''을 써주는게 좋음
ORDER BY s1.score DESC;



-- 180

/*
JOIN문: 두 개 이상의 테이블을 합쳐서 하나의 결과 집합을 만듦

SELECT 컬럼들
FROM 테이블A a
JOIN 테이블B b
  ON a.기준컬럼 = b.기준컬럼; > ON: 어떤 컬럼을 기준으로 합칠지 정하는 부분

기본 JOIN은 모든 기준을 만족하는 행만 결과에 포함
*/

select distinct l1.num as ConsecutiveNums
from logs l1
join logs l2
    on l2.id = l1.id + 1 and l2.num = l1.num
join logs l3
    on l3.id = l2.id + 1 and l3.num = l1.num;

-- 다른 방법 (조금 더 비효율적이긴 함)

SELECT DISTINCT l1.num as ConsecutiveNums
FROM
    Logs l1,
    Logs l2,
    Logs l3 -- 카테시안 곱 발생 > 불필요한 행까지 만들어져서 비효율적임
WHERE
    l1.Id = l2.Id - 1
    AND l2.Id = l3.Id - 1
    AND l1.Num = l2.Num
    AND l2.Num = l3.Num
;

/*
하나의 데이터를 각각 다르게 불러오고 합칠 수 있다는 특징을 활용해서
조금더 효율적으로 쿼리 작성하기
*/



-- 181 번호 확인 안 하고 그냥 풀었네 쩝 어쩐지 쉽더라

select e1.name as Employee
from employee e1
join employee e2
    on e1.managerid = e2.id
where e1.salary > e2.salary;

/*
쿼리 잘 작성하긴 했으나 아직 join한 후의 테이블이 머리에 잘 안 그려짐

e1.id | e1.name | e1.salary | e1.managerId | e2.id | e2.name | e2.salary | e2.managerId
------+---------+-----------+--------------+-------+---------+-----------+--------------
1     | Joe     | 70000     | 3            | 3     | Sam     | 60000     | NULL
2     | Henry   | 80000     | 4            | 4     | Max     | 90000     | NULL
이런식으로 JOIN됨

e1.id 3,4에 해당되는 행이 없는 이유는 managerid가 null이기 때문
*/



-- 184

select
    d.name as Department,
    e.name as Employee,
    e.salary as Salary
from employee e
join department d
    on e.departmentid = d.id
where e.salary = (
    select max(salary)
    from employee
    where departmentid = e.departmentid
    );

/*
서브쿼리 연결 로직이 아직 잘 안 와닿는거 같음
이번 쿼리에서는
where e.salary = (
    select max(salary)
    from employee
    where departmentid = e.departmentid
    )
이 부분을 서브쿼리로 넣지 않아서 틀렸는데
e.salary를 서브쿼리로 max(salary)로 정해두는 거라는건 이해가 되는데
where departmentid = e.departmentid 로 해야하는게 약간 안 와닿음

그리고 서브쿼리 돌아가는 로직이 잘 이해가 안 가서 지피티한테 풀어서 설명해달라고 하니까

1단계: 바깥쿼리 첫 행 (Joe, dept=1)
e.departmentId = 1
서브쿼리 실행: SELECT MAX(salary) FROM Employee WHERE departmentId = 1;
→ 90000
조건 비교: e.salary=70000 vs 90000 → ❌ Joe 제외

이런식으로 하나씩 보니까 좀 알 것 같당
*/

-- 더 빠른 방법

SELECT Department, Employee, Salary
FROM (
    SELECT d.name AS Department,
           e.name AS Employee,
           e.salary AS Salary,
           RANK() OVER (
               PARTITION BY e.departmentId
               ORDER BY e.salary DESC
           ) AS rnk
    FROM Employee e
    JOIN Department d ON e.departmentId = d.id
) t
WHERE rnk = 1;

/* 원래 RANK() OVER (PARTITION BY _ ORDER BY) 활용하고팠는데 어디에 넣어야할지 몰랐삼..
아예 rank 열이 포함된 테이블을 만들고 거기서 다시 rank=1을 조건으로 필요한 결과값만 select하는 방법이군
*/



-- 185 (HARD)

SELECT Department, Employee, Salary
FROM (
    SELECT d.name AS Department,
           e.name AS Employee,
           e.salary AS Salary,
           DENSE_RANK() OVER (
               PARTITION BY e.departmentId
               ORDER BY e.salary DESC
           ) AS rnk
    FROM Employee e
    JOIN Department d ON e.departmentId = d.id
) t
WHERE rnk = 1 OR rnk = 2 OR rnk = 3;

/*
생각보다 184번 활용하니까 쉬웠음
DENSE_RANK()랑 AND가 아닌 OR인거 조심!
*/

