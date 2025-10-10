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
아마 첫번째 case when 조건에서 null인게 걸러져서 그런듯
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
