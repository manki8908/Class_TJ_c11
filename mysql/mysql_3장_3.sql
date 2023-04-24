-- 3-2 장
use market_db;
SELECT * FROM market_db.member;

-- desc: 내림차순, asc 오름차순(default), ! 에러발생
SELECT mem_id, mem_name, debut_date 
	FROM market_db.member
    order by debut_date desc;

-- desc: 내림차순, asc 오름차순(default)
SELECT mem_id, mem_name, debut_date, height from member
	where height >=164;
    order by debut_date desc;
    
SELECT mem_id, mem_name, debut_date, height from member
	where height >=164
    order by debut_date desc, debut_date ASC;

-- 출력개수 제한
SELECT * from member
	limit 3;

-- 오름차순 정렬 + 출력개수 제한
SELECT mem_name, debut_date from member
	order by debut_date
	limit 3;
    
-- 멤버id, 데뷰일 키순으로 내린차순 정렬 + 0번째부터 3개
SELECT mem_name, debut_date, height from member
	order by height desc
	limit 0,3;

-- 멤버id, 데뷰일 키순으로 내린차순 정렬 + 중간부터 3번째부터 2개
SELECT mem_name, debut_date, height from member
	order by height desc
	limit 3,2;
       
-- DISTINCT: 중복제거
SELECT * from member;
SELECT addr from member order by addr;
SELECT distinct addr from member order by addr;      -- 주소의 중복제거하고 유니크값만 출력

-- 멤버id 순으로 정렬하고 멤버id, amount 출력
SELECT mem_id, amount 
	from buy 
    order by mem_id;
    
-- 그룹별 amount 총합
SELECT mem_id "회원 아이디", sum(amount) "총 구매 개수"
	from buy 
    group by mem_id;

-- 총 금액조회(price*amount)
SELECT mem_id "회원 아이디", sum(price*amount) " 총 구매금액"
	from buy
    group by mem_id;

-- 평균 구매개수
SELECT AVG(amount) "평균 구매 개수" FROM buy;

-- 그룹별 평균 구매개수
SELECT mem_id, AVG(amount) "평균 구매 개수" 
	FROM buy
	GROUP BY mem_id;

-- 전체 행 개수
SELECT COUNT(*) FROM member;

-- PHONE에서 NULL 자동제외
SELECT COUNT(phone1) "연락처가 있는 회원" FROM member;

-- 총구매 금액이 1000원이상 산 회원
-- WHERE 조건절은 GROUP BY 와 함께 사용할 수 없음 --> HAVING 사용
SELECT mem_id "회원 아이디", sum(price*amount) " 총 구매금액"
	from buy
    WHERE sum(price*amount) > 1000
    GROUP BY mem_id;
    
SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액"
   FROM buy 
   GROUP BY mem_id   
   HAVING SUM(price*amount) > 1000 ;
   
SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액"
   FROM buy 
   GROUP BY mem_id   
   HAVING SUM(price*amount) > 1000
   ORDER BY SUM(price*amount) DESC;

-- ------------------------------
-- bookstore 문제
-- ------------------------------
-- 1.. BOOKSTORE DB 선택
USE bookstore;

-- 2.. book 테이블 도서를 이름순으로 검색
SELECT *
   FROM book
   order by book_name asc;
   
-- 3.. book 테이블 도서를 가격순으로 검색하고 가격이 같으면 이름순으로 검색
SELECT *
   FROM book
   order by price, book_name;
   
-- 4.. book 테이블 도서를 가격의 내림차순으로 검색하고 만약 가격이 같다면 출판사의 오름차순으로 검색
SELECT *
   FROM book
   order by price desc, publisher asc;
   
-- 5.. order 테이블 주문일자를 내림차순으로 정렬
SELECT *
   FROM orders
   order by oderdate desc;
   
-- 6.. book 테이블에서 bookname이 '썬'이 들어가있고 가격이 20000원 이하인책을 출판사 이름으로 내림차순으로 조회(모든컬럼)
SELECT *
   FROM book
   where (book_name like '%썬%' ) and (price < 20000)
   order by publisher desc;
   
-- 7.. order 테이블에서 saleprice가 1000원 이상인 데이터를 book id 오름차순으로 조회(모든컬럼)
SELECT *
   FROM orders
   WHERE saleprice > 1000
   order by bookid; 

-- ------------------------------
-- 3절, 데이터 변경을 위한 sql 문
-- insert/update/delete
-- ------------------------------
-- 삭제하고 싶을때 언세이프 옵션 끄기/켜기 쿼리
-- SET SQL_SAFE_UPDATES = 0; 끄기
-- SET SQL_SAFE_UPDATES = 1; 켜기
-- delete from hongong1 where toy_name = '우디';

USE market_db;

-- Data: hongong1
CREATE TABLE hongong1 (toy_id  INT, toy_name CHAR(4), age INT);
INSERT INTO hongong1 VALUES (1, '우디', 25);							-- 순서를 맞춰 넣은 경우
INSERT INTO hongong1(toy_id, toy_name) VALUES (2, '버즈');			-- 키 이름으로
INSERT INTO hongong1(toy_name, age, toy_id) VALUES ('제시', 20, 3);

-- Data: hongong2
CREATE TABLE hongong2 ( 
   toy_id  INT AUTO_INCREMENT PRIMARY KEY,      -- 값이 자동증가 순으로
   toy_name CHAR(4), 
   age INT);
INSERT INTO hongong2 VALUES (NULL, '보핍', 25);  -- null은 자동증가 키 이기 때문에 
INSERT INTO hongong2 VALUES (NULL, '슬링키', 22);
INSERT INTO hongong2 VALUES (NULL, '렉스', 21);
SELECT * FROM hongong2;
SELECT LAST_INSERT_ID();  -- 마지막 인덱스 아이디 확인

ALTER TABLE hongong2 AUTO_INCREMENT=100;          -- alter 테이블 변경, 다음 아이디 값 100부터 
INSERT INTO hongong2 VALUES (NULL, '재남', 35);
SELECT * FROM hongong2;

-- Da-- Data: hongong3
CREATE TABLE hongong3 ( 
   toy_id  INT AUTO_INCREMENT PRIMARY KEY, 
   toy_name CHAR(4), 
   age INT);
ALTER TABLE hongong3 AUTO_INCREMENT=1000;			-- 시작 1000부터
SET @@auto_increment_increment=3;					-- 증가값 3으로 지정, @@:시스템 변수, 전체시스템변수 SHOW GLOBAL VARIABLES
INSERT INTO hongong3 VALUES (NULL, '토마스', 20);
INSERT INTO hongong3 VALUES (NULL, '제임스', 23);
INSERT INTO hongong3 VALUES (NULL, '고든', 25);
SELECT * FROM hongong3;


-- market_db에 도시인구(from world.table) 삽입
SELECT COUNT(*) FROM world.city;
DESC world.city;					-- DESC describe
SELECT * FROM world.city LIMIT 5;

CREATE TABLE city_popul ( city_name CHAR(35), population INT);
INSERT INTO city_popul
    SELECT Name, Population FROM world.city;

-- -------------------- Update
-- SET SQL_SAFE_UPDATES = 0; 끄기
set sql_safe_updates=0;
USE market_db;
UPDATE city_popul
    SET city_name = '서울'
    WHERE city_name = 'Seoul';		-- !주의 where문을 안쓰면 전체 내용이 바뀜
SELECT  * FROM city_popul WHERE  city_name = 'seoul';
SELECT  * FROM city_popul WHERE  city_name = '서울';

UPDATE city_popul
    SET city_name = '뉴욕'
    WHERE city_name = 'New York';
SELECT  * FROM city_popul WHERE  city_name = 'New York';
SELECT  * FROM city_popul WHERE  city_name = '뉴욕';

UPDATE city_popul
    SET population = population / 10000 ;
SELECT * FROM city_popul LIMIT 5;


-- -------------------- Delete
DELETE FROM city_popul 
    WHERE city_name LIKE 'New%';
    
-- 중복 지웠다해도 0개가 지웠다고 출력되면서 적용됨
DELETE FROM city_popul 
    WHERE city_name LIKE 'New%'
    LIMIT 5;

-- 대용량 테이블 삭제
CREATE TABLE big_table1 (SELECT * FROM world.city , sakila.country); 
CREATE TABLE big_table2 (SELECT * FROM world.city , sakila.country); 
CREATE TABLE big_table3 (SELECT * FROM world.city , sakila.country); 
SELECT COUNT(*) FROM big_table1;

DELETE FROM big_table1;  -- 3초, 빈테이블 존재
SELECT * FROM big_table1;
DROP TABLE big_table2;   -- 0.016초, 없어져 버림
SELECT * FROM big_table2;
TRUNCATE TABLE big_table3;  -- 0.015초, 빈테이블 존재 --> delete랑 결과는 같은데 속도가 빠름 --> delete문은 조건문이 들어감, truncate 바로삭제
SELECT * FROM big_table3;  


