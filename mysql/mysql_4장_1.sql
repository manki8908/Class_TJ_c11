-- ------------------------------
-- 1절
-- ------------------------------
USE market_db;

-- --------------- 정수형
CREATE TABLE hongong4 (
    tinyint_col  TINYINT,	-- -128 ~ 127
    smallint_col SMALLINT,	-- -32768 ~ 32768
    int_col    INT,			-- -21억 ~ 21억
    bigint_col BIGINT );	-- -900경 ~ 900경

INSERT INTO hongong4 VALUES(127, 32767, 2147483647, 9000000000000000000);
SELECT * FROM hongong4;
INSERT INTO hongong4 VALUES(128, 32768, 2147483648, 90000000000000000000); -- OUT OF RANGE

DROP TABLE IF EXISTS buy, member;
CREATE TABLE member								-- 회원 테이블
( mem_id      	CHAR(8) NOT NULL PRIMARY KEY,	-- 회원 아이디(PK)
  mem_name      VARCHAR(10) NOT NULL, 			-- 이름, VARCHAR=가변
  mem_number    TINYINT NOT NULL,				-- 인원수
  addr          CHAR(2) NOT NULL,				-- 주소(경기,서울,경남 식으로 2글자만입력)
  phone1        CHAR(3),						-- 연락처의 국번(02, 031, 055 등)
  phone2        CHAR(8),						-- 연락처의 나머지 전화번호(하이픈제외)
  height        TINYINT unsigned,				-- 평균 키
  debut_date    DATE							-- 데뷔 일자
  );
  
  -- --------------- 문자형
  CREATE TABLE big_table (
  data1  CHAR(255),
  data2  VARCHAR(16384) );
  
  -- 넷플릭스
CREATE DATABASE netflix_db;
USE netflix_db;
CREATE TABLE movie 
  (movie_id        INT,
   movie_title     VARCHAR(30),
   movie_director  VARCHAR(20),
   movie_star      VARCHAR(20),
   movie_script    LONGTEXT,		-- 42억 BITE(4GB), 소설, 영화/ 대본
   movie_film      LONGBLOB,		-- 42억 BITE(4GB), 사진, 영화/ 동영상
); 
  

  -- --------------- 변수의 사용
USE market_db;
SET @myVar1 = 5 ;
SET @myVar2 = 4.25 ;

SELECT @myVar1 ;
SELECT @myVar1 + @myVar2 ;

SET @txt = '가수 이름==> ' ;
SET @height = 166;
SELECT @txt , mem_name FROM member WHERE height > @height ;

-- !에러 LIMIT에는 변수를 사용할 수 없음
SET @count = 3;
SELECT mem_name, height 
	FROM member 
    ORDER BY height 
    LIMIT @count;
    
-- 위 문을 굳이 쓰고 싶을때
SET @count = 3;
PREPARE mySQL FROM 'SELECT mem_name, height FROM member ORDER BY height LIMIT ?';
EXECUTE mySQL USING @count;


-- --------------- 데이터 형 변환
SELECT AVG(price) '평균 가격' FROM buy;
SELECT CAST(AVG(price) AS SIGNED)  '평균 가격'  FROM buy ;		-- SINGED: 부호가 있는 정수, UNSINED: 부호가 없는 정수
SELECT CONVERT(AVG(price) , SIGNED)  '평균 가격'  FROM buy ;

SELECT CAST('2022$12$12' AS DATE);
SELECT CAST('2022/12/12' AS DATE);
SELECT CAST('2022%12%12' AS DATE);
SELECT CAST('2022@12@12' AS DATE);

SELECT num, CONCAT(CAST(price AS CHAR), 'X', CAST(amount AS CHAR) ,'=' ) '가격X수량',
    price*amount '구매액' 
  FROM buy ;

SELECT '100' + '200' ;			-- 문자와 문자를 더함 (정수로 변환되서 연산됨)
SELECT CONCAT('100', '200');	-- 문자와 문자를 연결 (문자로 처리)
SELECT CONCAT(100, '200');		-- 정수와 문자를 연결 (정수가 문자로 변환되서 처리)

SELECT 1 > '2mega'; -- 정수인 2로 변환되어서 비교
SELECT 3 > '2MEGA'; -- 정수인 2로 변환되어서 비교
SELECT 0 = 'mega2'; -- 문자는 0으로 변환됨
SELECT 0 = 0;


-- ------------------------------
-- 2절
-- ------------------------------

USE market_db;
DESC market_db.buy;
DESC market_db.member;

-- 내부 조인: 양쪽 모두 데이터가 있는 것들만 조인
SELECT * FROM buy					-- 출력할 내용
     INNER JOIN member				-- 참초할 테이블
     ON buy.mem_id = member.mem_id	-- 공통 컬럼
   WHERE buy.mem_id = 'GRL';		-- 출력 조건
   
-- !에러
SELECT mem_id, mem_name, prod_name, addr, CONCAT(phone1, phone2) AS '연락처' 
   FROM buy
     INNER JOIN member
     ON buy.mem_id = member.mem_id;

-- 엄밀하게는 지정이 필요함, 그러나 코드가 너무 복잡해짐
SELECT buy.mem_id, member.mem_name, buy.prod_name, member.addr, CONCAT(member.phone1, member.phone2) AS '연락처' 
   FROM buy
     INNER JOIN member
     ON buy.mem_id = member.mem_id;
     
-- 별칭을 사용하여 간략해짐
SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, CONCAT(M.phone1, M.phone2) AS '연락처' 
   FROM buy B
     INNER JOIN member M
     ON B.mem_id = M.mem_id;
	
-- 중복제거: 1번이라도 구매한 이력이 있는 회원원
SELECT DISTINCT M.mem_id, M.mem_name, M.addr
   FROM buy B
     INNER JOIN member M
     ON B.mem_id = M.mem_id
   ORDER BY M.mem_id;
   
SELECT DISTINCT M.mem_id, M.mem_name, M.addr
   FROM member M
     INNER JOIN buy B
     ON B.mem_id = M.mem_id
   ORDER BY M.mem_id;
   
-- 외부 조인: 한쪽에만 데이터가 있어도 조인
-- left/right outer: 왼쪽/오른쪽에 있는 내용은 모두 출력되어야 한다

SELECT M.mem_id, M.mem_name, B.prod_name, M.addr
   FROM member M
     LEFT OUTER JOIN buy B
     ON M.mem_id = B.mem_id
   ORDER BY M.mem_id;
   
SELECT M.mem_id, M.mem_name, B.prod_name, M.addr
   FROM member M
     RIGHT OUTER JOIN buy B
     ON M.mem_id = B.mem_id
   ORDER BY M.mem_id;

-- 회원가입후 한번도 구매한 적이 없는 회원 목록
 -- (멤버아이디, 프로덕네임, 멤버네임, 멤버주소)
SELECT distinct M.mem_id, M.mem_name, B.prod_name, M.addr
   FROM member M
	LEFT OUTER JOIN buy B
     ON M.mem_id = B.mem_id
     WHERE B.prod_name IS NULL     
   ORDER BY M.mem_id;

-- cross join
SELECT * 
   FROM buy 
     CROSS JOIN member ;
     
SELECT COUNT(*) "데이터 개수"
   FROM sakila.inventory
      CROSS JOIN world.city;

USE market_db;
CREATE TABLE emp_table (emp CHAR(4), manager CHAR(4), phone VARCHAR(8));

INSERT INTO emp_table VALUES('대표', NULL, '0000');
INSERT INTO emp_table VALUES('영업이사', '대표', '1111');
INSERT INTO emp_table VALUES('관리이사', '대표', '2222');
INSERT INTO emp_table VALUES('정보이사', '대표', '3333');
INSERT INTO emp_table VALUES('영업과장', '영업이사', '1111-1');
INSERT INTO emp_table VALUES('경리부장', '관리이사', '2222-1');
INSERT INTO emp_table VALUES('인사부장', '관리이사', '2222-2');
INSERT INTO emp_table VALUES('개발팀장', '정보이사', '3333-1');
INSERT INTO emp_table VALUES('개발주임', '정보이사', '3333-1-1');
SELECT * FROM market_db.emp_table;

SELECT A.emp "직원" , A.phone "직원 연락처", B.emp "직속상관", B.phone "직속상관연락처"
   FROM emp_table A
      INNER JOIN emp_table B
         ON A.manager = B.emp;
   -- WHERE A.emp = '경리부장';

-- 구매고객이 가격 8000 이상 도서를
-- 2권이상 주문한 고객 이름, 수량, 판매금액을 조회
use bookstore;
SELECT C.user_name, O.custid, count(*) As '수량', sum(O.saleprice) As '판매액'
   FROM orders O
	LEFT JOIN customer C
     ON O.custid = C.custid
     WHERE saleprice > 8000
     group by custid
     having count(*) >= 2;

-- TRIM() 문자열 좌우 공백제거 -> 파이썬 trip과 같음
select trim("     안녕하세요  ");
select ltrim("     안녕하세요  ");
select rtrim("     안녕하세요  ");

-- 문자열 좌우 문자 제거 (both)
select trim(both '안' from '안녕하세요');

-- 문자열 좌측 제거
select trim(leading from ' 안녕하세요');
select trim(leading '안' from '안녕하세요안');

-- 문자열 우측 공백 제거
select trim(trailing from '안녕하세요 ');
select trim(trailing '안' from '안녕하세요안');

select length('안녕');			-- 6, bite
select char_length('안녕');		-- 2,
select character_length('안녕');	-- 2,

-- 대소문자
select upper('sql로 시작하는 하루');
select lower('A에서 Z까지 !');
select upper('a에서 z까지 !');

-- 추출
select substring('안녕하세요', 2, 3);
select substring_index('안.녕.하.세.요', '.', 2);
select substring_index('안.녕.하.세.요', '.', -3);
select left('안녕하세요', 3);
select right('안녕하세요', 3);

