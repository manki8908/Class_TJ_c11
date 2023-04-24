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