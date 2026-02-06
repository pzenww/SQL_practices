-- INSERT INTO table_name (column1, column2, ...) VALUES (value1, value2, ...);

INSERT INTO users (name, email, age, city) VALUE (name '박재은', email 'jen@gmail.com', age 25, city 'Hongkong');
-- NOT NULL 조건이 있는 부분은 반드시 값을 넣어줘야함
  
-- 컬럼명을 지정하지 않고도 바로 값을 넣을 수 있음
INSERT INTO users VALUE (name '박재은', email 'jen@gmail.com', age 25, city 'Hongkong');
-- 컬럼이 인식되는 순서로 매핑이 되는 원리이나 컬럼의 순서나 구조가 바뀌는 순간 매핑에 문제가 생김 -> 따라서 추천하지 않음

-- 기법들

-- 단일 Raw 삽입
INSERT INTO users (name, email, age, city) VALUE (name '박재은', email 'jen@gmail.com', age 25, city 'Hongkong');

-- 다중 Raw 삽입
INSERT INTO users (name, email, age, city) VALUE 
  (name '박재은', email 'jen@gmail.com', age 25, city 'Hongkong'),
  (name '박재은', email 'jen@gmail.com', age 25, city 'Hongkong'),
  (name '박재은', email 'jen@gmail.com', age 25, city 'Hongkong'),
  (name '박재은', email 'jen@gmail.com', age 25, city 'Hongkong');
-- 다중 Raw 삽입을 하는 경우 메모리 사용량을 줄이는 등 최적화가 가능함

-- 테이블 간의 데이터를 복사
INSERT INTO users (name, email, age, city)
SELECT name, email, age, city
FROM old_users
WHERE status = 'active';

-- ON DUPLICATED KEY UPDATE
-- : 중복되는 Key가 있으면 update, 없다면 insert
INSERT INTO users (id, name, email, age, city)
    VALUE (100,'김철수', 'kim@naver.com', 13, 'Seoul')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    age = VALUES(age),
    city = VALUES(city),
    updated_at = NOW();

-- INSERT IGNORE INTO
-- : 중복 key가 있다면 건너뛰기, 없다면 insert
INSERT IGNORE INTO users (id, name, email, age, city)
    VALUE
    (100,'김철수', 'kim@naver.com', 13, 'Seoul'),
    (100,'김철수', 'kim@naver.com', 13, 'Seoul');

-- REPLACE INTO
REPLACE INTO users (id, name, email, age, city)
VALUE (id 1, name 'a', email 'b', age 4, city 'c')


-- 
