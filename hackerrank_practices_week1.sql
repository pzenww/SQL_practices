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

## Solving Idea 1: 반올림은 ROUND(), 버림은 FLOOR()

## SOLVED !
