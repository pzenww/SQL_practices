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

CREATE FUNCTION 함수이름(매개변수 타입) 
RETURNS 반환타입
BEGIN
   (함수 안에서 실행할 SQL 문)
   RETURN 결과값;
END;
*/

/*
주의할점: SET문, RETURN문, CREATE FUNCTION문 총 3개의 쿼리를 실행한거기 때문에 ;도 꼭 각 쿼리 끝나고 써줘야함
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
        WHERE s2.score >= s1.score) AS rank -- 자기와 같거나 보다 더 큰 숫자의 개수를 세서 순위로 설정
FROM Scores s1
ORDER BY s1.score DESC;



-- 180
