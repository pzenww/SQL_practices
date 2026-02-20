-- [ 3374 ]

- 문제: 첫 글자, - 다음 첫 글자는 대문자로 바꾸고, 나머지는 소문자로 변환하시오
- 문제점: 어렵다 .. solution도 너무 어려워서 그냥 최대한 기본적인 문법으로 쿼리 엄청 길어도 돌아가게 하는 방법으로 생각함 ...
- 사용한 쿼리: 
1) len() : 문자열 길이 반환
2) substring(문자열, 시작위치, 길이) : 문자열에서 특정 위치의 일부를 잘라냄
3) like'[A-Za-z]' : 해당 문자가 영어 알파벳인지 검사 -> TRUE/FALSE 식으로 결과가 나옴
4) upper/lower
5) row_number() over (order by ) : 문자 위치(position)를 만들기 위해 활용
6) string_agg(ch, '') within group (order by pos) : 잘라놓은 문자들을 다시 하나의 문자열로 합침

- 로직 고민 ..
  : 우선 전체 lower 적용 > 문자 위치(pos) 만들기 > 영어가 아닌 문자 찾아내고 위치(pos) 알아내기 > 1번과 pos+1번은 upper 적용 > 문자를 하나의 문자열로 붙이기
- 로직 피드백
  : 전체 lower 적용 > 문자열 한 글자씩 분해 > 각 문자에 대해 영어인지 판단 > case when으로 영어면 upper 아니면 lower 유지 > 하나의 문자열로 붙이기

- 너무 어렵기만 하고 데이터분석 할 때 필요없는 쿼리 문제인거 같아서 머리 쥐어짜다가 그냥 3475 푸는거로 했어요 ..


-- [ 3421 ]

- 열심히 고민했으나 .. 역량 부족으로 솔루션 봤으요 ㅠㅠ 흑흑 분발해야겠다
  
with cte as(
    select min(exam_date) first, max(exam_date) last, student_id id, subject subject -- 시험 1차, 2차 날짜와 학생 아이디/과목으로 구성된 테이블 생성
    from scores
    group by student_id, subject
)
select b.student_id , b.subject, b.score first_score , c.score latest_score
from cte a
    right join scores b on b.student_id = a.id and b.exam_date = a.first -- 처음 시험 본 날짜를 기준으로 해당 점수는 처음 점수로 열 추가
    and b.subject = a.subject
    right join scores c on c.student_id = a.id and c.exam_date = a.last -- 마지막으로 시험 본 날짜를 기준으로 해당 점수는 최근 점수로 열 추가
    and c.subject = a.subject
where c.score > b.score -- 처음 점수보다 최근 점수가 더 큰 것만 필터링
order by a.id , a.subject


-- [ 3451 ]

