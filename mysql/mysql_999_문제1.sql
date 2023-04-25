use bookstore;
insert into book value(12, 'OpenCV 파이썬', '포웨이', 23500);
insert into book value(13, '자연어 처리 시작하기', '투시즌', 20000);
insert into book value(14, 'SQL 이해', '새미디어', 22000);

insert into customer value(6, '박보영', '서울 서초구', '010-9999-5555');
insert into customer value(7, '오정세', '서울 중구', '010-8888-4444');
insert into customer value(8, '이병헌', '서울 성북구', '010-7777-3333');

insert into orders values(11, 6, 12, 23500, STR_TO_DATE('2020-02-01','%Y-%m-%d'));
insert into orders values(12, 6, 14, 44000, STR_TO_DATE('2020-02-03','%Y-%m-%d'));
insert into orders values(13, 8, 13, 20000, STR_TO_DATE('2020-02-03','%Y-%m-%d'));
insert into orders values(14, 3, 13, 20000, STR_TO_DATE('2020-02-04','%Y-%m-%d'));
insert into orders values(15, 4, 12, 23500, STR_TO_DATE('2020-02-05','%Y-%m-%d'));
insert into orders values(16, 5, 8, 35000, STR_TO_DATE('2020-02-07','%Y-%m-%d'));

select * from book where bookid in (12,13,14);

-- 1. v_order 테이블 만들기: orderid, custid(0),
-- username, bookid(0), saleprice, orderdate 가져와서
-- custid(c) = custid(o) and bookid(b) = bookid(o)
CREATE VIEW v_orders
AS SELECT orderid, O.custid, user_name, O.bookid, saleprice, oderdate
	FROM customer C, book B, orders O
	WHERE C.custid = O.custid and B.bookid = O.bookid;

-- 2. v_order 도서가격이 20000 이상인 레코드로 변경
create or replace view v_orders(custid, user_name, address)
as select C.custid, user_name, address
from customer C, orders O, book B
where B.price >= 20000;

-- 3. v_cust_purchase 테이블 생성
-- username(c) '고객', sum(O.saleprice) '구매액'
-- customer C, oders O C.custid = O.custid
-- 집계분석
create or replace view v_cust_purchase
as select C.user_name as '고객', sum(O.saleprice) '구매액'
from customer C, orders O
where C.custid = O.custid
group by 고객
order by 구매액 DESC;
select * from v_cust_purchase;


