-- ------------------------------
-- 1절, 280p~
--
-- 기존 full table에서 조회, 데이터가 많아지면 찾기 힘듦
-- 빠른 찾기를 위해 인덱스(색인) 사용
-- 클러스터형 인덱스 = 사전형
-- 보조 인덱스 = 책뒤에 색인
-- ------------------------------

-- --------- primary, unique key
USE market_db;
CREATE TABLE table1  (
    col1  INT  PRIMARY KEY,	-- 기본키로 지정, 프라이머리키(클러스터형 인덱스) -> 인덱스로 자동 적용
    col2  INT,
    col3  INT
);
SHOW INDEX FROM table1; -- 인덱스 정보 확인

CREATE TABLE table2  (
    col1  INT  PRIMARY KEY,
    col2  INT  UNIQUE,	-- 고유키 지정(보조인덱스, 중복값 허용 안함)
    col3  INT  UNIQUE
);
SHOW INDEX FROM table2;


-- ------------ primary key test
USE market_db;
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member 
( mem_id      CHAR(8) , 
  mem_name    VARCHAR(10),
  mem_number  INT ,  
  addr        CHAR(2)  
 );

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울');
SELECT * FROM member;
SHOW INDEX FROM member;

-- alter로 프라이머리키 지정 --> 자동 정렬
ALTER TABLE member
     ADD CONSTRAINT 
     PRIMARY KEY (mem_id);
SELECT * FROM member;

-- primary key를 mem_name롤 변경
ALTER TABLE member DROP PRIMARY KEY ; -- 기본 키 제거
ALTER TABLE member 
    ADD CONSTRAINT 
    PRIMARY KEY(mem_name);
SELECT * FROM member;

-- 추가 데이터도 자동 정렬
INSERT INTO member VALUES('GRL', '소녀시대', 8, '서울');
SELECT * FROM member;

-- ---------------- 보조 인덱스
-- unique는 찾아보기가 여러개 만들어지기만 하고 정렬은 되지 않음
-- 보조 인덱스는 적절히 사용, 너무 많으면 메모리 효율이 떨어지고 느려짐

USE market_db;
DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id      CHAR(8) , 
  mem_name    VARCHAR(10),
  mem_number  INT ,  
  addr        CHAR(2)  
 );
INSERT INTO member VALUES('TWC', '트와이스', 9, '서울');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울');
SELECT * FROM member;

-- mem_id를 보조인덱스(unique)로 지정 --> 순서 변함없음
ALTER TABLE member
     ADD CONSTRAINT 
     UNIQUE (mem_id);
SELECT * FROM member;

-- mem_name를 보조인덱스(unique)로 지정 --> 순서 변함없음
ALTER TABLE member
     ADD CONSTRAINT 
     UNIQUE (mem_name);
SELECT * FROM member;

-- 제일 마지막에 추가됨 --> 순서 변함없음
INSERT INTO member VALUES('GRL', '소녀시대', 8, '서울');
SELECT * FROM member;


-- ------------------------------
-- 2절
--
-- 인덱스 사용
-- 
-- ------------------------------ 

USE market_db;
CREATE TABLE cluster  -- 클러스터형 테이블 
( mem_id      CHAR(8) , 
  mem_name    VARCHAR(10)
 );
INSERT INTO cluster VALUES('TWC', '트와이스');
INSERT INTO cluster VALUES('BLK', '블랙핑크');
INSERT INTO cluster VALUES('WMN', '여자친구');
INSERT INTO cluster VALUES('OMY', '오마이걸');
INSERT INTO cluster VALUES('GRL', '소녀시대');
INSERT INTO cluster VALUES('ITZ', '잇지');
INSERT INTO cluster VALUES('RED', '레드벨벳');
INSERT INTO cluster VALUES('APN', '에이핑크');
INSERT INTO cluster VALUES('SPC', '우주소녀');
INSERT INTO cluster VALUES('MMU', '마마무');
SELECT * FROM market_db.cluster;

-- primary key 지정
ALTER TABLE cluster
    ADD CONSTRAINT 
    PRIMARY KEY (mem_id);

SELECT * FROM cluster;


USE market_db;
CREATE TABLE second  -- 보조 인덱스 테이블 
( mem_id      CHAR(8) , 
  mem_name    VARCHAR(10)
 );
INSERT INTO second VALUES('TWC', '트와이스');
INSERT INTO second VALUES('BLK', '블랙핑크');
INSERT INTO second VALUES('WMN', '여자친구');
INSERT INTO second VALUES('OMY', '오마이걸');
INSERT INTO second VALUES('GRL', '소녀시대');
INSERT INTO second VALUES('ITZ', '잇지');
INSERT INTO second VALUES('RED', '레드벨벳');
INSERT INTO second VALUES('APN', '에이핑크');
INSERT INTO second VALUES('SPC', '우주소녀');
INSERT INTO second VALUES('MMU', '마마무');
SELECT * FROM second;

-- unique 부여, pricmary key 처럼 순서인덱스가 없기 때문에 고유 위치정보가 따로 생성됨
ALTER TABLE second
    ADD CONSTRAINT 
    UNIQUE (mem_id);

-- 겉으로 드러나는 변화는 없음
SELECT * FROM second;


-- ------------------------------
-- 3절, 인덱스의 실제 사용
--
-- 보조 인덱스[단순보조(중복허용), 고유보조(중복x)]
--
-- ------------------------------

-- 초기 상태 로드
USE market_db;
SELECT * FROM member;
SHOW INDEX FROM member;
SHOW TABLE STATUS LIKE 'member';

-- ------------ 단순 보조 인덱스 생성
CREATE INDEX idx_member_addr 
   ON member (addr);
SHOW INDEX FROM member;
SHOW TABLE STATUS LIKE 'member';	-- index_length 변화 없음

-- 변동 인덱스 적용(분석/처리)
ANALYZE TABLE member
SHOW TABLE STATUS LIKE 'member';	-- index_length 변화


-- --------- 고유 인덱스 
-- 오류 발생, 이미 mem_number 열에 중복값이 있는데(Non_unique=1) unique 인덱스는 중복을 허용하지 않음
CREATE UNIQUE INDEX idx_member_mem_number
    ON member (mem_number); 

-- 정상 적용
CREATE UNIQUE INDEX idx_member_mem_name
    ON member (mem_name);

SHOW INDEX FROM member;

-- 중복값 허용 안함, mem_name에 '마마무' 존재
INSERT INTO member VALUES('MOO', '마마무', 2, '태국', '001', '12341234', 155, '2020.10.10');

ANALYZE TABLE member;   -- 지금까지 만든 인덱스를 모두 적용
SHOW INDEX FROM member;

-- 보조 인덱스 사용
SELECT mem_id, mem_name, addr 
    FROM member 
    WHERE mem_name = '에이핑크';


CREATE INDEX idx_member_mem_number
    ON member (mem_number);
ANALYZE TABLE member; -- 인덱스 적용

-- execution plan으로 스캔 방법 확인
-- 검색되는 개수가 작아서 인덱스 사용
SELECT mem_name, mem_number 
    FROM member 
    WHERE mem_number >= 7;
    
-- 검색되는 개수가 많아서 full table 스캔
SELECT mem_name, mem_number 
    FROM member 
    WHERE mem_number >= 1; 
    
-- full table scan
SELECT mem_name, mem_number 
    FROM member 
    WHERE mem_number*2 >= 14; 

-- index scan
SELECT mem_name, mem_number 
    FROM member 
    WHERE mem_number >= 14/2;  