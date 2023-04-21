SELECT * FROM member;
SELECT member_name, member_addr FROM member;
SELECT * FROM member WHERE member_name = '아이유';
#CREATE INDEX idx_member_name ON member(member_name);
#SELECT * FROM member WHERE member_name = '아이유';

#CREATE VIEW member_view AS SELECT * FROM member;
SELECT * FROM member_view;

DELIMITER $$
CREATE PROCEDURE myProc()
BEGIN
 SELECT * FROM shop_dbl.member WHERE member_name = '나훈아';
 SELECT * FROM shop_dbl.product WHERE product_name = '삼각김밥';
END$$
DELIMITER ;

CALL myProc();

