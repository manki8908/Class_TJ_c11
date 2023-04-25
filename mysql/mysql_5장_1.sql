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