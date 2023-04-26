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