# Hackerrank > SQL Basic > Easy > Basic Select 문제 풀어본 결과 너무 쉬워서 Advanced Select로 변경
# Hackerrank > SQL Basic > Easy > Advanced Select



# Problem: Type of Triangle (https://www.hackerrank.com/challenges/what-type-of-triangle/problem?isFullScreen=true)

## Submission 1:
SELECT
    CASE
    WHEN A = B = C THEN 'Equilateral'
    WHEN A = B OR B = C OR A = C AND NOT A = B = C THEN 'Isosceles'
    WHEN A + B < C OR A + C < B OR B + C < A THEN 'Not A Triangle'
    ELSE 'Scalene'
END AS Output
FROM TRIANGLES;

## Mistake 1: SQL은 Python처럼 체인 비교 (A=B=C)를 지원하지 않음 > A = B AND B = C 로 수정해야 맞는 문법
## Mistake 2: OR / AND를 같이 사용할 때는 괄호를 활용하여 우선순위를 명확히 해줘야함

## Solving Idea 1: 삼각형을 구분하기 이전에 Not A Triangle부터 확인해야함 > 조건 순서도 신경쓰기

## Submission 2: 
SELECT
    CASE
    WHEN A + B < C OR A + C < B OR B + C < A THEN 'Not A Triangle'
    WHEN A = B AND B = C AND A = C THEN 'Equilateral'
    WHEN A = B OR B = C OR A = C THEN 'Isosceles'
    ELSE 'Scalene'
END AS Output
FROM TRIANGLES;

## Mistake 1: A + B = C인 경우도 삼각형이 성립하지 않으므로 A + B <= C 가 맞음
## Mistake 2: WHEN A = B AND B = C AND C = A에서 C = A는 암묵적으로 성립하기 때문에 필요없음

## Submission 3:
SELECT
    CASE
    WHEN A + B <= C OR A + C <= B OR B + C <= A THEN 'Not A Triangle'
    WHEN A = B AND B = C THEN 'Equilateral'
    WHEN A = B OR B = C OR A = C THEN 'Isosceles'
    ELSE 'Scalene'
END AS Output
FROM TRIANGLES;

## SOLVED !


---------------------------------------------
# Hackerrank > SQL Basic > Easy > Aggregation



# Problem 1: Revising Aggregations - The Sum Function (https://www.hackerrank.com/challenges/revising-aggregations-sum/problem?isFullScreen=true)

## Submission 1:
SELECT
    SUM(POPULATION)
FROM CITY
WHERE DISTRICT = 'California';

## SOLVED !


# Problem 2: Average Population (https://www.hackerrank.com/challenges/average-population/problem?isFullScreen=true)

## Submission 1:
SELECT
    FLOOR(AVG(POPULATION))
FROM CITY;

## Solving Idea 1: 반올림은 ROUND(), 버림은 FLOOR(), 올림은 CEIL()

## SOLVED !


# Problem 3: Population Density Difference (https://www.hackerrank.com/challenges/population-density-difference/problem?isFullScreen=true)

## Submission 1:
SELECT
    max(population) - min(population)
From city;

## SOLVED !


# Problem 4: The Blunder (https://www.hackerrank.com/challenges/the-blunder/problem?isFullScreen=true)
-- 어려움 ....

## Solving Idea 1: 해당 문제는 정상적인 데이터가 주어지고 0을 빼고 잘못 입력한 데이터 베이스와의 차이를 계산하라는 문제
## Solving Idea 2: REPLACE(str, from_str, to_str): 원본문자열에서 찾을 문자열을 바꿀 문자열로 바꿔주는 함수 (숫자 넣으면 자동 문자열 변환)
## Solving Idea 3: CAST(값 AS 바꿀 데이터 타입): 데이터 타입을 바꿔주는 함수

## Submission 1:
SELECT
    CEIL(
        AVG(Salary)
        - AVG(CAST(REPLACE(Salary, 0, '')AS integer))
    )
From EMPLOYEES
WHERE Salary > 1000 AND Salary < power(10,5);

## Mistake 1: REPLACE(Salary, 0, '') > 0도 문자열로 입력해야하므로 '0'으로 수정
## Mistake 2: MySQL에서는 INTEGER보단 UNSIGNED를 쓰는게 나음

## Submission 2:
SELECT
    CEIL(
        AVG(Salary)
        - AVG(CAST(REPLACE(Salary, '0', '')AS UNSIGNED))
    )
From EMPLOYEES;

## SOLVED !
