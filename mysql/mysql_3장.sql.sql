use market_db;

-- 선택 조회
select * from member;
select * from marget_db.member;  --  만약 sakila에 있다면 실행 안됨
select addr, debut_date, mem_name from member;    -- p115
select addr, debut_date "데뷰 일자", mem_name from member;    -- 컬럼네임에 별칭짓기

-- 조건문 조회
select * from member where mem_name = '블랙핑크';  -- execution plan에서 보면 full table scan(index가 없어서)
select * from member where mem_number = 4;  -- 멤버수 4 조건
select mem_id, mem_name from member where height > 162;

select mem_name, height, mem_number from member where height >=165 and mem_number >=6;
select mem_name, height, mem_number from member where height >=165 or mem_number >=6;
select mem_name, height from member where height >=163 and height <=165;
select mem_name, height from member where height between 163 and 165;

select mem_name, addr from member where addr='경기' or addr='전남' or addr='경남';
select mem_name, addr from member where addr IN ('경기','전남','경남');

select * from member where mem_name like '우%';  -- 앞글자가 우인 모든 컬럼
select * from member where mem_name like '__핑크';  -- 앞글자가 __(둘글자)인 모든 핑크

select height from member where mem_name='에이핑크';
-- 에이핑크의 키보다 큰 그룹을 찾는 쿼리
select mem_name, height from member where height > (select height from member where mem_name='에이핑크'); 

-- 복습(bookstore 라는 스키마 만들기)
-- 테이블은 3개(book / bookid(int(pk)), bookame(VARCHAR40), publisher(VARCHAR40), price(INT)
--           customer / custid(int(PK)), username(VARCHAR20), address(VARCHAR50), phone(VARCHAR20)
-- 			 order / oderid(int(PK)), custid(int(FK)), bookid(int(FK)), saleprice(int), oderdate(date) )
--           foreign key로 custid 연결

#DROP DATABASE IF EXISTS bookstore; -- 만약 market_db가 존재하면 우선 삭제한다.
CREATE DATABASE bookstore;
USE bookstore;

CREATE TABLE Book -- 회원 테이블
( bookid  		INT NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  book_name    	VARCHAR(40), -- 이름
  publisher     VARCHAR(40),  -- 인원수
  price	  		INT -- 지역(경기,서울,경남 식으로 2글자만입력)
);

CREATE TABLE Customer -- 회원 테이블
( custid  		INT NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  user_name    	VARCHAR(40), -- 이름
  address       VARCHAR(50),  -- 인원수
  phone	  		VARCHAR(20) -- 지역(경기,서울,경남 식으로 2글자만입력)
);

CREATE TABLE Orders -- 회원 테이블
( orderid  		INT PRIMARY KEY, -- 사용자 아이디(PK)
  custid    	INT, -- 이름
  bookid        INT,  -- 인원수
  saleprice	    INT, -- 지역(경기,서울,경남 식으로 2글자만입력)
  oderdate		DATE,
  FOREIGN KEY (custid) REFERENCES Customer(custid),
  FOREIGN KEY (bookid) REFERENCES Book(bookid)
);

INSERT INTO Book VALUES(1, '철학의 역사', '정론사', 7500);
INSERT INTO Book VALUES(2, '3D_모델링_시작하기', '한비사', 1500);
INSERT INTO Book VALUES(3, 'SQL의 이해', '새미디어', 2200);
INSERT INTO Book VALUES(4, '텐서플로우 시작', '새미디어', 3500);
INSERT INTO Book VALUES(5, '인공지능 개론', '정론사', 8000);
INSERT INTO Book VALUES(6, '파이썬 고급', '정론사', 8000);
INSERT INTO Book VALUES(7, '객체지향 Java', '튜링사', 20000);
INSERT INTO Book VALUES(8, 'C++ 중급', '튜링사', 18000);
INSERT INTO Book VALUES(9, 'Secure 코딩', '정보사', 7500);
INSERT INTO Book VALUES(10, 'Machine learning 이해', '새미디어', 32000);
select * from Book;

INSERT INTO Customer VALUES(1, '박지성', '영국 맨체스타', '010-1234-1010');
INSERT INTO Customer VALUES(2, '김연아', '대한민국 서울', '010-1223-3456');
INSERT INTO Customer VALUES(3, '장미란', '대한민국 강원도', '010-4878-1901');
INSERT INTO Customer VALUES(4, '추신수', '대한민국 부산', '010-8000-8765');
INSERT INTO Customer VALUES(5, '박세리', '대한민국 대전', NULL);
select * from Customer;

INSERT INTO Orders VALUES(1, 1, 1, 7500, str_to_date('2021-02-01','%Y-%m-%d'));
INSERT INTO Orders VALUES(2, 1, 3, 44000, str_to_date('2021-02-03','%Y-%m-%d'));
INSERT INTO Orders VALUES(3, 2, 5, 8000, str_to_date('2021-02-03','%Y-%m-%d'));
INSERT INTO Orders VALUES(4, 3, 6, 8000, str_to_date('2021-02-04','%Y-%m-%d'));
INSERT INTO Orders VALUES(5, 4, 7, 20000, str_to_date('2021-02-05','%Y-%m-%d'));
INSERT INTO Orders VALUES(6, 1, 2, 15000, str_to_date('2021-02-07','%Y-%m-%d'));
INSERT INTO Orders VALUES(7, 4, 8, 18000, str_to_date('2021-02-07','%Y-%m-%d'));
INSERT INTO Orders VALUES(8, 3, 10, 32000, str_to_date('2021-02-08','%Y-%m-%d'));
INSERT INTO Orders VALUES(9, 2, 10, 32000, str_to_date('2021-02-09','%Y-%m-%d'));
INSERT INTO Orders VALUES(10, 3, 8, 18000, str_to_date('2021-02-10','%Y-%m-%d'));
select * from Orders;

-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------

/* 1. 산술 연산자 */
select 1;
select 1+1;
select 0.1;
select 1-1;
select 100/20;
select 5.0/2;

/* book 테이블에서 price 값에 연산 */
USE bookstore;
select price * 0.05 from book;
select price / 2 from book;
select (price / 2)*100 from book;

/* 2. 비교연산자 */
select 1 > 100;
select 1 < 100;
select 0 = 0;
select 101 <> 10; -- !=
select 101 != 10; -- !=

/* 3. 논리연산자 */
select (10 >= 10) and (5 < 10);
select (10 > 10) and (5 < 10);
select (10 > 10) or (5 < 10);
select not (10 > 10);

/* 4. 집계함수 */
-- 북스토에서 판매한 건수
select count(*) from orders;
-- 고객이 주문한 도서의 총 판매액
select sum(saleprice) from orders;
-- 고객이 주문한 도서의 총 판매액인데 '총매출'로 컬럼명 표시
select sum(saleprice) as 총매출 from orders;
-- 고객이 주문한 도서의 평균 판매액인데 '총매출'로 컬럼명 표시
select avg(saleprice) as 평균매출 from orders;
-- 판매액을 합계 평균, 최저, 최고가 구하기
select sum(saleprice) as 총매출액,
	   avg(saleprice) as 평균매출,
	   min(saleprice) as 최저매출, 
       max(saleprice) as 최고매출
from orders;

-- 1. 가격이 10000원 보다 크고 20000원 이하인 도서를 검색
select * from book where price between 10000 and 20000;
-- 2. 주문일자가 2021/02/01에서 2021/02/07내 주문내역검색
select * from orders where oderdate between '2021-02-01' and '2021-02-07';
-- 3. 도서번호가 3,4,5,6 인 주문 목록 출력
select * from book where bookid in(3,4,5,6);
-- 4. 박씨성을 가진 고객 출력
select user_name from customer where user_name like '박%';
-- 5. 2번째 글자가 '지'인 고객 출력
select user_name from customer where user_name like '_지_';  -- or '_지%'
-- 6. '철학의 역사'를 출간한 검색
select book_name,publisher from book where book_name in('철학의 역사');
-- 7. 도서이름에 썬으로 일치하고 20000원 이상인 도서
select * from book where (book_name like '%썬') and (price >= 20000);
-- 8. 출판사 이름이 '정론사' 혹은 '새미디어' 인 도서를 검색
select * from book where publisher IN('정론사', '새미디어');



-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------

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





