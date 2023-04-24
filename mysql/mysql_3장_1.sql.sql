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

-- 3장2절(124p)






