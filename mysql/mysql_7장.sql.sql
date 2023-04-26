-- ------------------------------
-- 1절, stored procedure
-- ------------------------------

/*
-- 기본 구조
DELIMITER $$		-- 구분자를 $$로 하겠다는 표시, 다른표식으로도 가능
CREATE PROCEDURE user_proc()
BEGIN
	-- 쿼리문;
END $$
DELIMITER ;			-- 앞으로 구분자는 다시 ';'(sql구분자) 으로 쓰겠다
CALL user_proc();
*/

-- -------------------- 기본구조 테스트
USE market_db;
DROP PROCEDURE IF EXISTS user_proc;
DELIMITER $$
CREATE PROCEDURE user_proc()
BEGIN
    SELECT * FROM member; -- 스토어드 프로시저 내용
END $$
DELIMITER ;
CALL user_proc();


-- -------------------- 매개변수 사용
USE market_db;
DROP PROCEDURE IF EXISTS user_proc1;
DELIMITER $$
CREATE PROCEDURE user_proc1(IN userName VARCHAR(10))	-- 매개변수 선언
BEGIN
  SELECT * FROM member WHERE mem_name = userName;		-- userName: 매개변수
END $$
DELIMITER ;
CALL user_proc1('에이핑크');


-- -------------------- 매개변수 사용, 2개
DROP PROCEDURE IF EXISTS user_proc2;
DELIMITER $$
CREATE PROCEDURE user_proc2(
    IN userNumber INT, 
    IN userHeight INT  )
BEGIN
  SELECT * FROM member 
    WHERE mem_number > userNumber AND height > userHeight;
END $$
DELIMITER ;

CALL user_proc2(6, 165);


-- -------------------- 출력매개변수가 있는 프로시져
DROP PROCEDURE IF EXISTS user_proc3;
DELIMITER $$
CREATE PROCEDURE user_proc3(
    IN txtValue CHAR(10),
    OUT outValue INT     )
BEGIN
  INSERT INTO noTable VALUES(NULL,txtValue);
  SELECT MAX(id) INTO outValue FROM noTable; 
END $$
DELIMITER ;

-- noTable이 없어 에러
DESC noTable;

-- noTable을 만들어줌
CREATE TABLE IF NOT EXISTS noTable(
    id INT AUTO_INCREMENT PRIMARY KEY, 
    txt CHAR(10)
);

-- noTable 확인
select * FROM noTable;

-- user_proc3 호출 테스트
CALL user_proc3 ('테스트1', @myValue);
SELECT CONCAT('입력된 ID 값 ==>', @myValue);



 -- -------------------- 조건문 활용
DROP PROCEDURE IF EXISTS ifelse_proc;
DELIMITER $$
CREATE PROCEDURE ifelse_proc(
    IN memName VARCHAR(10)
)
BEGIN
    DECLARE debutYear INT;	-- 함수내 변수 선언
    SELECT YEAR(debut_date) into debutYear FROM member	-- 년도만 뽑아옴
        WHERE mem_name = memName;
    IF (debutYear >= 2015) THEN
            SELECT '신인 가수네요. 화이팅 하세요.' AS '메시지';
    ELSE
            SELECT '고참 가수네요. 그동안 수고하셨어요.'AS '메시지';
    END IF;
END $$
DELIMITER ;
CALL ifelse_proc ('오마이걸');



 -- -------------------- while문 활용
 -- 1부터 100까지 합
DROP PROCEDURE IF EXISTS while_proc;
DELIMITER $$
CREATE PROCEDURE while_proc()
BEGIN
    DECLARE hap INT; -- 합계
    DECLARE num INT; -- 1부터 100까지 증가
    SET hap = 0; -- 합계 초기화
    SET num = 1; 
    
    WHILE (num <= 100) DO  -- 100까지 반복.
        SET hap = hap + num;
        SET num = num + 1; -- 숫자 증가
    END WHILE;
    SELECT hap AS '1~100 합계';
END $$
DELIMITER ;

CALL while_proc();

 -- 4의배수 제외, 합1000 넘으면 종료
DROP PROCEDURE IF EXISTS while_proc2;
DELIMITER $$
CREATE PROCEDURE while_proc2()
BEGIN
    DECLARE hap INT; -- 합계
    DECLARE num INT; -- 1부터 100까지 증가
    SET hap = 0; -- 합계 초기화
    SET num = 1; 
    
	myWhile:				-- label 지정
    WHILE (1) DO  -- 
    
		IF (num%4 = 0) THEN
          SET num = num + 1;     
          ITERATE myWhile;	-- 지정한 label문으로 가서 계속 진행
		ELSE
          SET hap = hap + num;
		  SET num = num + 1; -- 숫자 증가
        END IF;
        
        IF (hap > 1000) THEN 
         LEAVE myWhile; -- 지정한 label문을 떠남. 즉, While 종료.
        END IF;

    END WHILE;
    
    SELECT '1부터 100까지의 합(4의 배수 제외), 1000 넘으면 종료 ==>', num, hap; 
END $$
DELIMITER ;

CALL while_proc2();
 
  
-- -------------------- 동적SQL 341p
DROP PROCEDURE IF EXISTS dynamic_proc;
DELIMITER $$
CREATE PROCEDURE dynamic_proc(
    IN tableName VARCHAR(20)
)
BEGIN
  SET @sqlQuery = CONCAT('SELECT * FROM ', tableName);
  PREPARE myQuery FROM @sqlQuery;
  EXECUTE myQuery;
  DEALLOCATE PREPARE myQuery;
END $$
DELIMITER ;

CALL dynamic_proc ('member');



-- ------------------------------
-- 2절, stored function
--
-- 뭐리문을 사용하지 않음
-- ------------------------------

-- stored fuction 생성 권한 설정
SET GLOBAL log_bin_trust_function_creators = 1;

-- ------------------------------ 기본 구조
/*
USE market_db;
DROP FUNCTION IF EXISTS sumFunc;
DELIMITER $$
CREATE FUNCTION sumFunc(number1 INT, number2 INT)	-- 입력변수 선언
    RETURNS INT		-- 반환 변수 선언
BEGIN
    RETURN number1 + number2;
END $$
DELIMITER ;
SELECT sumFunc(100, 200) AS '합계';	-- select로 호출함
*/

-- 기본 구조 테스트
USE market_db;
DROP FUNCTION IF EXISTS sumFunc;
DELIMITER $$
CREATE FUNCTION sumFunc(number1 INT, number2 INT)	-- 입력변수 선언
    RETURNS INT		-- 반환 변수 선언
BEGIN
    RETURN number1 + number2;
END $$
DELIMITER ;
SELECT sumFunc(100, 200) AS '합계';	-- select로 호출함


-- 데뷰년도를 입력하면 활동기간을 출력하는 함수
DROP FUNCTION IF EXISTS calcYearFunc;
DELIMITER $$
CREATE FUNCTION calcYearFunc(dYear INT)
    RETURNS INT
BEGIN
    DECLARE runYear INT; -- 활동기간(연도)
    SET runYear = YEAR(CURDATE()) - dYear;
    RETURN runYear;
END $$
DELIMITER ;

-- 출력 예)
SELECT calcYearFunc(2010) AS '활동기간(년)';

-- 값을 다른 변수에 넣을 수 있음
SELECT calcYearFunc(2007) INTO @debut2007;
SELECT calcYearFunc(2013) INTO @debut2013;
SELECT @debut2007-@debut2013 AS '2007과 2013 차이' ;

-- 각 그룹별 활동기간도 생성할 수 있음
SELECT mem_id, mem_name, calcYearFunc(YEAR(debut_date)) AS '활동 기간' 
    FROM member; 
    
    
-- -------------- 함수의 내용확인
-- 밑에 창에 create defifner에 마우스 오버하면 내용이 뜸, 또는 오른쪽 클릭해서 openview
-- 또는 form editor에서 확인 가능
SHOW CREATE FUNCTION calcYearFunc;

DROP FUNCTION calcYearFunc;



-- -------------- 커서 만들기
-- 커서: 테이블의 한행씩 특정업무 처리

USE market_db;

DROP PROCEDURE IF EXISTS cursor_proc;
DELIMITER $$
CREATE PROCEDURE cursor_proc()
BEGIN
	-- 
    DECLARE memNumber INT;					-- 회원의 인원수
    DECLARE cnt INT DEFAULT 0;				-- 읽은 행의 수
    DECLARE totNumber INT DEFAULT 0;		-- 인원의 합계
    DECLARE endOfRow BOOLEAN DEFAULT FALSE; -- 행의 끝 여부(기본을 FALSE)

	-- 커서 선언
    DECLARE memberCuror CURSOR FOR (SELECT mem_number FROM member);
    
    -- 행의 끝이면 endOfRow 변수에 TRUE를 대입 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET endOfRow = TRUE;
    
	-- 커서 열기
    OPEN memberCuror; 

		-- 커서 반복 내용
		cursor_loop: LOOP
			-- 행을 하나씩 읽어 옴
			FETCH  memberCuror INTO memNumber; 	
        
			-- 행이 끝나면 loop 종료
			IF endOfRow THEN 
				LEAVE cursor_loop;
			END IF;

			-- 행개수 세고, 멤버수 더하기
			SET cnt = cnt + 1;
			SET totNumber = totNumber + memNumber;        
		END LOOP cursor_loop;

		-- 평균 인원수 산출
		SELECT (totNumber/cnt) AS '회원의 평균 인원 수';

	-- 커서 닫기
    CLOSE memberCuror; 
END $$
DELIMITER ;

CALL cursor_proc();



-- ------------------------------
-- 3절, trigger
--
--
-- 특정 작업 전에 자동으로 선행 수행되는 것
-- 테이블에 insert, update, delete 작업이 발생하면 수행
-- ex) 삭제전 백업, 등등..
-- ------------------------------

-- ----------- 기본구조
/*
DROP TRIGGER IF EXISTS myTrigger;
DELIMITER $$ 
CREATE TRIGGER myTrigger  -- 트리거 이름
    AFTER  DELETE -- 삭제후에 작동하도록 지정
    ON trigger_table -- 트리거를 부착할 테이블
    FOR EACH ROW -- 각 행마다 적용시킴
BEGIN
    SET @msg = '가수 그룹이 삭제됨' ; -- 트리거 실행시 작동되는 코드들
END $$ 
DELIMITER ;
*/

-- --------- Triger test
-- test table 생
USE market_db;
DROP TABLE IF EXISTS trigger_table;
CREATE TABLE IF NOT EXISTS trigger_table (id INT, txt VARCHAR(10));
INSERT INTO trigger_table VALUES(1, '레드벨벳');
INSERT INTO trigger_table VALUES(2, '잇지');
INSERT INTO trigger_table VALUES(3, '블랙핑크');
SELECT * FROM market_db.trigger_table;

-- test trigger 생성
DROP TRIGGER IF EXISTS myTrigger;
DELIMITER $$ 
CREATE TRIGGER myTrigger	-- 트리거 이름
-- 선언
    AFTER  DELETE			-- 삭제후에 작동하도록 지정
    ON trigger_table		-- 트리거를 부착할 테이블
    FOR EACH ROW			-- 각 행마다 적용시킴
BEGIN
    SET @msg = '가수 그룹이 삭제됨' ; -- 트리거 실행시 작동되는 코드들
END $$ 
DELIMITER ;

-- ---------------- 적용
-- 데이터 추가이기 때문에 트리거 함수작동 없음
SET @msg = '';	-- 전역변수, trigger 함수내 변수와 동일
INSERT INTO trigger_table VALUES(4, '마마무');
SELECT * FROM market_db.trigger_table;
SELECT @msg;

-- 데이터 업데이트 이기 때문에 트리거 함수작동 없음
-- 업데이트 권한 해제
set sql_safe_updates=0;
UPDATE trigger_table SET txt = '블핑' WHERE id = 3;
SELECT @msg;

-- 트리거 함수 작동
DELETE FROM trigger_table WHERE id = 4;
SELECT @msg;


-- ----------------- 트리거 활용 예제
-- market_db 고객 테이블에 입력된 회원의 정보가 변경될 때
-- 변경한 사용자, 시간, 변경전의 데이터 등을 기록하는 트리거 작성
-- 삭제하기 전의 old table을 임시 저장함

-- test data: 기존 market_db에서 가수정보 로드
USE market_db;
CREATE TABLE singer (SELECT mem_id, mem_name, mem_number, addr FROM member);
SELECT * FROM market_db.singer;


-- test log data: 변경정보를 삽입할 테이블 생성
DROP TABLE IF EXISTS backup_singer;
CREATE TABLE backup_singer
( mem_id  		CHAR(8) NOT NULL , 
  mem_name    	VARCHAR(10) NOT NULL, 	-- 어떤정보를 = id, name, member수, addr
  mem_number    INT NOT NULL, 
  addr	  		CHAR(2) NOT NULL,
  modType  CHAR(2),						-- 변경된 타입. '수정' 또는 '삭제'
  modDate  DATE,						-- 변경된 날짜
  modUser  VARCHAR(30)					-- 변경한 사용자
);
SELECT * FROM market_db.backup_singer;


-- update trigger 작성
-- 초기화
DROP TRIGGER IF EXISTS singer_updateTrg;
-- 생성
DELIMITER $$
CREATE TRIGGER singer_updateTrg 	-- 트리거 이름
    AFTER UPDATE					-- 변경 후에 작동하도록 지정
    ON singer						-- 트리거를 부착할 테이블
    FOR EACH ROW					-- 각 행마다 적용시킴
BEGIN
    INSERT INTO backup_singer VALUES( OLD.mem_id, OLD.mem_name, OLD.mem_number, 
        OLD.addr, '수정', CURDATE(), CURRENT_USER() );
END $$ 
DELIMITER ;

-- delete trigger 작성
-- 초기화
DROP TRIGGER IF EXISTS singer_deleteTrg;
-- 생성
DELIMITER $$
CREATE TRIGGER singer_deleteTrg	-- 트리거 이름
    AFTER DELETE				-- 삭제 후에 작동하도록 지정
    ON singer					-- 트리거를 부착할 테이블
    FOR EACH ROW				-- 각 행마다 적용시킴
BEGIN
    INSERT INTO backup_singer VALUES( OLD.mem_id, OLD.mem_name, OLD.mem_number, 
        OLD.addr, '삭제', CURDATE(), CURRENT_USER() );
END $$ 
DELIMITER ;


SELECT * FROM market_db.backup_singer;
SELECT * FROM market_db.singer;

-- update test
UPDATE singer SET addr = '영국' WHERE mem_id = 'BLK';
-- delete test
DELETE FROM singer WHERE mem_number >= 7;

-- log 확인
SELECT * FROM backup_singer;

-- 전체  삭제 tset
TRUNCATE TABLE singer;

-- log 확인 --> DELETE trigger 이기 때문에 작동하지 않았음
SELECT * FROM backup_singer;
