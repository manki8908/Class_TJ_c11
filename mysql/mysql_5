-- ------------------------------
-- 1절
-- ------------------------------

-- --------------- gui로 data 생성 219p
CREATE DATABASE naver_db;
-- 왼쪽 스키마 테이블에서 naver_db/Tables 오른쪽 클릭, member create_table
-- 왼쪽 스키마 테이블에서 naver_db/Tables 오른쪽 클릭, buy create_table


-- --------------- sql로 data 생성 
DROP DATABASE IF EXISTS naver_db;
CREATE DATABASE naver_db;

DROP TABLE IF EXISTS member;  -- 기존에 있으면 삭제
CREATE TABLE member -- 회원 테이블
( mem_id        CHAR(8) NOT NULL PRIMARY KEY,
  mem_name      VARCHAR(10) NOT NULL, 
  mem_number    TINYINT NOT NULL, 
  addr          CHAR(2) NOT NULL,
  phone1        CHAR(3) NULL,
  phone2        CHAR(8) NULL,
  height        TINYINT UNSIGNED NULL, 
  debut_date    DATE NULL
  -- primary key(mem_id) -- 키설정 이렇게도 가능
);
describe member;

DROP TABLE IF EXISTS buy;  -- 기존에 있으면 삭제
CREATE TABLE buy 
(  num         INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   mem_id      CHAR(8) NOT NULL, 
   prod_name     CHAR(6) NOT NULL, 
   group_name     CHAR(4) NULL ,
   price         INT UNSIGNED NOT NULL,
   amount        SMALLINT UNSIGNED  NOT NULL ,
   FOREIGN KEY(mem_id) REFERENCES member(mem_id)
);
describe buy;

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015-10-19');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남', '055', '22222222', 163, '2016-8-8');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기', '031', '33333333', 166, '2015-1-15');

INSERT INTO buy VALUES( NULL, 'BLK', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES( NULL, 'BLK', '맥북프로', '디지털', 1000, 1);
INSERT INTO buy VALUES( NULL, 'APN', '아이폰', '디지털', 200, 1);


-- ------------------------------
-- 2절 
--  		기본키 제약조건
--			외래키 제약조건
-- ------------------------------

USE naver_db;
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL PRIMARY KEY, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL
);

DESCRIBE member;


DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL,
  PRIMARY KEY (mem_id)
);


-- ALTER를 이용해 이미 만들어진 테이블에 제약조건 추가
DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL
);
ALTER TABLE member			
     ADD CONSTRAINT			-- 제약조건 추가
     PRIMARY KEY (mem_id);
     
describe member;     

-- key 이름 생성,
DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL,
  CONSTRAINT PRIMARY KEY PK_member_mem_id (mem_id)
);
describe member;   

-- 외래키 기준이 제약조건이 없으면 적용불가
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member 
( -- mem_id  CHAR(8) NOT NULL PRIMARY KEY, 
  mem_id  CHAR(8) NOT NULL, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL
);
CREATE TABLE buy 
(  num         INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   mem_id      CHAR(8) NOT NULL, 
   prod_name     CHAR(6) NOT NULL, 
   FOREIGN KEY(mem_id) REFERENCES member(mem_id)
);


-- 기준테이블과 참조테이블의 외래키의 컬럼명이 같을 필요는 없음
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL PRIMARY KEY, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL
);
CREATE TABLE buy 
(  num         INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   user_id      CHAR(8) NOT NULL, 
   prod_name     CHAR(6) NOT NULL, 
   FOREIGN KEY(user_id) REFERENCES member(mem_id)
);

-- alter 이용
DROP TABLE IF EXISTS buy;
CREATE TABLE buy 
(  num         INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   mem_id      CHAR(8) NOT NULL, 
   prod_name     CHAR(6) NOT NULL
);
ALTER TABLE buy
    ADD CONSTRAINT 
    FOREIGN KEY(mem_id) REFERENCES member(mem_id);
    
INSERT INTO member VALUES('BLK', '블랙핑크', 163);
INSERT INTO buy VALUES(NULL, 'BLK', '지갑');
INSERT INTO buy VALUES(NULL, 'BLK', '맥북');

SELECT * FROM naver_db.buy;
SELECT * FROM naver_db.member;

-- ! error 외래키 설정으로 수정 불가
UPDATE member SET mem_id = 'PINK' WHERE mem_id='BLK';
-- ! error 외래키 설정으로 지워지지도 않음
DELETE FROM member WHERE  mem_id='BLK';


-- cascade: 업데이트 가능하게 속성 추가
DROP TABLE IF EXISTS buy;
CREATE TABLE buy 
(  num         INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   mem_id      CHAR(8) NOT NULL, 
   prod_name     CHAR(6) NOT NULL
);
ALTER TABLE buy
    ADD CONSTRAINT 
    FOREIGN KEY(mem_id) REFERENCES member(mem_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

-- 테스트 데이터 삽입
INSERT INTO buy VALUES(NULL, 'BLK', '지갑');
INSERT INTO buy VALUES(NULL, 'BLK', '맥북');

-- 업데이트 및 확인
UPDATE member SET mem_id = 'PINK' WHERE mem_id='BLK';
SELECT M.mem_id, M.mem_name, B.prod_name FROM buy B  INNER JOIN member M  ON B.mem_id = M.mem_id;
      
-- 지우고 및 확인
DELETE FROM member WHERE  mem_id='PINK';
SELECT M.mem_id, M.mem_name, B.prod_name FROM buy B  INNER JOIN member M  ON B.mem_id = M.mem_id;


-- unique(중복안됨 지정) 제약조건
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL PRIMARY KEY, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL,
  email       CHAR(30)  NULL UNIQUE	-- 중복안됨 지정
);

INSERT INTO member VALUES('BLK', '블랙핑크', 163, 'pink@gmail.com');
INSERT INTO member VALUES('TWC', '트와이스', 167, NULL);
INSERT INTO member VALUES('APN', '에이핑크', 164, 'pink@gmail.com');  -- 중복 오류
SELECT * FROM member;


-- check(조건)
DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL PRIMARY KEY, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL CHECK (height >= 100),
  phone1      CHAR(3)  NULL
);

INSERT INTO member VALUES('BLK', '블랙핑크', 163, NULL);
INSERT INTO member VALUES('TWC', '트와이스', 99, NULL);

-- alter로 check 추가
ALTER TABLE member
    ADD CONSTRAINT 
    CHECK  (phone1 IN ('02', '031', '032', '054', '055', '061' )) ;
    
-- 테스트
INSERT INTO member VALUES('TWC', '트와이스', 167, '02');
INSERT INTO member VALUES('OMY', '오마이걸', 167, '010'); -- !오류



-- 기본값(DEFAULT) 제약 조건
DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL PRIMARY KEY, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL DEFAULT 160,   -- 기본값 '160' 사용
  phone1      CHAR(3)  NULL
);
ALTER TABLE member
    ALTER COLUMN phone1 SET DEFAULT '02';	-- 기본값 '02' 사용

INSERT INTO member VALUES('RED', '레드벨벳', 161, '054');
INSERT INTO member VALUES('SPC', '우주소녀', default, default);	-- 기본값 호출
SELECT * FROM member;


-- ------------------------------
-- 3절, 뷰
-- ------------------------------

USE market_db;
SELECT mem_id, mem_name, addr FROM market_db.member;

-- 뷰를 만드는 형식
create view v_member as SELECT mem_id, mem_name, addr FROM market_db.member; -- 스키마/뷰에 나타남
select * from v_member;

-- 특정 출력 내용, 문서보안등 저장해놓고 쓰기 편함
SELECT mem_name, addr FROM v_member
   WHERE addr IN ('서울', '경기');
   
-- ----------- 출력 예를 뷰로 저장
-- 출력 예
SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, 
        CONCAT(M.phone1, M.phone2) '연락처' 
   FROM buy B
     INNER JOIN member M
     ON B.mem_id = M.mem_id;

-- 뷰로 만듦(CREATE VIEW)
CREATE VIEW v_memberbuy
AS
    SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, 
            CONCAT(M.phone1, M.phone2) '연락처' 
       FROM buy B
         INNER JOIN member M
         ON B.mem_id = M.mem_id;

SELECT * FROM v_memberbuy WHERE mem_name = '블랙핑크';


USE market_db;
CREATE VIEW v_viewtest1
AS
    SELECT B.mem_id 'Member ID', 
			M.mem_name AS 'Member Name', 
            B.prod_name "Product Name", 
            CONCAT(M.phone1, M.phone2) AS "Office Phone" 
       FROM buy B
         INNER JOIN member M
         ON B.mem_id = M.mem_id;

SELECT  * FROM v_viewtest1; 
SELECT  DISTINCT `Member ID`, `Member Name` FROM v_viewtest1; -- 문자 이름에 공백이 있으면 백틱(``)을 사용

-- 수정 (ALTER VIEW)
ALTER VIEW v_viewtest1
AS
    SELECT B.mem_id '회원 아이디', 
			M.mem_name AS '회원 이름', 
            B.prod_name "제품 이름", 
            CONCAT(M.phone1, M.phone2) AS "연락처" 
       FROM buy B
         INNER JOIN member M
         ON B.mem_id = M.mem_id;
         
SELECT  DISTINCT `회원 아이디`, `회원 이름` FROM v_viewtest1; -- 문자 이름에 공백이 있으면 백틱(``)을 사용

DROP VIEW v_viewtest1;


-- 기존에 view가 있더라도 덮어씀
USE market_db;
CREATE OR REPLACE VIEW v_viewtest2 AS SELECT mem_id, mem_name, addr FROM member;
DESCRIBE v_viewtest2;
DESCRIBE member;

-- 뷰의 소스코드 확인(result grid 창- form editor창)
SHOW CREATE VIEW v_viewtest2;

-- -------------- 뷰 수정(원본자료는 바뀌지 않음)
-- update
UPDATE v_member SET addr = '부산' WHERE mem_id='BLK' ; -- '경남' --> '부산'
select * from v_member;

-- insert(오류, 뷰의 원본 테이블에 notnull 설정된 컬럼이 있음, 265p 설명) 
INSERT INTO v_member(mem_id, mem_name, addr) VALUES('BTS','방탄소년단','경기') ;

-- 키가 167이상인 뷰를 만들어 보기
select * from member;
CREATE OR REPLACE VIEW v_height167 
	AS SELECT * FROM member
	WHERE height >= 167;
select * from v_height167 ;

-- 잠시 수정 권한 꺼두기
select @@sql_safe_updates;
set sql_safe_updates = 0;

-- 167 이하인 자료 삭제, 삭제할 자료가 없긴함
delete from v_height167 where height < 167;

-- create view에서 167이상 조건이 있는데 159 자료를 입력하면 
-- 오류없이 삽입은 되나 적용은 안됨
INSERT INTO v_height167 VALUES('TRA','티아라', 6, '서울', NULL, NULL, 159, '2005-01-01') ;
select * from v_height167 ;

-- alter로 조건 수정, 'WITH CHECK OPTION'을 통해 167미만 자료 삽입 안되도록
ALTER VIEW v_height167
AS
    SELECT * FROM member WHERE height >= 167
        WITH CHECK OPTION ;

-- 'WITH CHECK OPTION' 기능 작동 -> 삽입에러
INSERT INTO v_height167 VALUES('TOB','텔레토비', 4, '영국', NULL, NULL, 140, '1995-01-01') ;


-- 테이블 삭제시 뷰는?
CREATE VIEW v_complex
AS
    SELECT B.mem_id, M.mem_name, B.prod_name, M.addr
        FROM buy B
            INNER JOIN member M
            ON B.mem_id = M.mem_id;
            
SELECT * FROM market_db.v_height167;

-- 원본 테이블 삭제
DROP TABLE IF EXISTS buy, member;

-- 원본 삭제로 참조할 테이블이 없어
SELECT * FROM market_db.v_height167;

