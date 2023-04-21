use sakila;
show tables;
DESC actor;

-- actor, film, customer, staff, rental, inventory count
select count(*) from actor;
select count(*) from film;
select count(*) from customer;
select count(*) from staff;
select count(*) from rental;
select count(*) from inventory;
-- 배우 이름을 합쳐서 '배우' 조회
select UPPER(concat(first_name,' ', last_name)) '배우'
from actor;
-- son으로 끝나는 성을 가진 배우
SELECT * from actor where UPPER(last_name) LIKE '%SON';
-- 배우들이 출연한 영화 
select UPPER(concat(first_name,' ', last_name)) '배우',
F.title, F.release_year
from film F, actor A, film_actor B
where A.actor_id = B.actor_id
	and B.film_id = F.film_id;
-- 성(last name) 별  배우 숫자
SELECT last_name, count(*) AS 명
FROM actor
group by last_name
order by 명 DESC, last_name;	
-- country가 오스트레일리아  독일 contry id / contry
DESC country;
SELECT country_id, country
from country 
where country IN ('AUSTRALIA', 'GERMANY');

-- 1. 스테프 테이블에서 이름을 성이름을 합치고 STAFF,
-- staff과 address테이블을 합치고 
-- address, district, postal code, city id를 조회
select concat(STF.first_name, ' ', STF.last_name) staff,
ADR.address, ADR.district, ADR.postal_code, ADR.city_id
FROM staff STF
left join address ADR ON STF.address_id = ADR.address_id;



-- 2. 스테프 이름 합치고 payment(pay컬럼) 테이블과 합치고
-- staff 이름기준으로 그룹화하여 7월 이면서 2005년 조회
select concat(STF.first_name, ' ', STF.last_name) staff,
sum(PAY.amount) 
from STAFF STF left join payment PAY 
ON STF.staff_id = PAY.staff_id
where month(PAY.payment_date) = 7
     and year(PAY.payment_date) = 2005
group by STF.first_name, STF.last_name;

-- 3.영화별 출연 배우의 수
select FLM.title, count(*) 배우
from film FLM inner join
film_actor FLM_ACT ON FLM.film_id = FLM_ACT.film_id
group by FLM.title
order by 배우 DESC;

-- 1. '영화이름' 넣으면 출연해 배우들이 나오도록 'HALLOWEEN NUTS'
select concat(first_name, ' ', last_name) 배우
from actor
where actor_id in 
(select actor_id from film_actor where film_id in
(select film_id from film
 where lower(title) = lower('HALLOWEEN NUTS')));
-- 2. 국가가 CANADA인 고객의 이름 서브쿼리를 
--    이용한 방법 join을 이용한방법
select concat(first_name, ' ', last_name) 고객, email
from customer
where address_id in
(select address_id from address where city_id in 
(select city_id from city where country_id in 
(select country_id from country 
where country = 'CANADA')));

-- join을 활용해 국가가 canada인 고객 이름
select concat(CUS.first_name, ' ', CUS.last_name) 
고객, CUS.email
from customer CUS
join address ADR ON CUS.address_id = ADR.address_id
join city CIT ON ADR.city_id = CIT.city_id
join country COU ON CIT.country_id = COU.country_id
where COU.country = 'CANADA';

-- 영화 등급 
SELECT RATING FROM film group by rating;
-- 1. 영화에서 PG 또는 G등급 조회
select rating, count(*) 수량
from film
where rating = 'PG' OR rating = 'G'
group by rating;
-- 2. pg 또는 g등급 영화 제목
select rating, title, release_year
from film
where rating = 'PG' OR rating = 'G';
 
-- 등급별 영화의 수를 출력
select rating, count(*)
from film
GROUP BY RATING;

-- rental_rate가 1~6이하인 등급별 영화의 수를 출력
select rating, count(*)
from film
where rental_rate > 1.0 and rental_rate < 6.0
GROUP BY rating;

-- 1. 등급별 영화 수와 합계, 최고 , 최소
--    rental_rate를 조회하고 평균 렌탈비용으로 정렬
SELECT rating, count(*) 수량,
sum(rental_rate) 합계,
avg(rental_rate) 평균,
min(rental_rate) 최소,
max(rental_rate) 최대
from film
group by rating, rental_rate
order by avg(rental_rate) DESC;
-- 2. 등급별 영화 갯수, 등급, 평균렌탈 rate 출력하고
--    평균렌탈rate를 내리차순으로 정렬
select rating , count(*) AS 수량,
avg(rental_rate) AS 평균
from film
group by rating 
order by 평균 DESC;

-- 1. 분류가 'family' 인 영화 film 테이블 subquery를 이용해 조회
--     또는 join 활용
select film_id, title, release_year
from film
where film_id in
(select film_id from film_category where category_id in
(select category_id from category where name = 'FAMILY'));
-- join 
select F.film_id, F.title, F.release_year
from film F
	left join  film_category FC ON F.film_id = FC.film_id
    left join category C ON FC.film_id = C.category_id
where C.name = 'FAMILY';
-- 2. 영화 분류별 영화의 갯수 film film_category, category
--     동등조인 활용 또는 left 조인 활용
-- 동등조인 
select C.name, count(F.film_id) 수량,
	sum(F.rental_rate) 합계,
	avg(rental_rate) 평균,
	min(rental_rate) 최소,
	max(rental_rate) 최대
From film F, film_category FC, category C
where FC.category_id = C.category_id 
and FC.film_id = F.film_id
group by C.name, F.rental_rate 
order by 평균 DESC;

-- 3. action 영화의 이름, 영화수, 합계(rental_rate),
-- 		평균, 최소, 최고 집계
select C.name, count(F.film_id) 영화수,
	sum(F.rental_rate) 합계,
	avg(rental_rate) 평균,
	min(rental_rate) 최소,
	max(rental_rate) 최대
From film F, film_category FC  
join category C
ON FC.category_id = C.category_id
where FC.film_id = F.film_id
group by C.name, F.rental_rate 
HAVING C.name='action' order by 평균 DESC;

-- 가장 대여비가 높은 영화 분류
-- category, film_category, inventory, payment, rental
select CAT.name category_name, sum(ifnull(PAY.amount, 0)) revenue
from category CAT
left join film_category FLM_CAT 
ON CAT.category_id = FLM_CAT.category_id
left join film FIL ON FLM_CAT.film_id = FIL.film_id
left join inventory INV ON FIL.film_id = INV.film_id
left join rental REN ON INV.inventory_id = REN.inventory_id
left join payment PAY ON REN.rental_id = PAY.rental_id
group by CAT.name
order by revenue DESC;

-- 뷰를 생성 뷰이름은 v_cat_revenue 
-- cateogory - name, category_name, 
-- sum(ifnull(pay.amount, 0) Revenue
create or replace view v_cat_revenue AS
select CAT.name category_name, sum(ifnull(PAY.amount, 0)) revenue
from category CAT
left join film_category FLM_CAT 
ON CAT.category_id = FLM_CAT.category_id
left join film FIL ON FLM_CAT.film_id = FIL.film_id
left join inventory INV ON FIL.film_id = INV.film_id
left join rental REN ON INV.inventory_id = REN.inventory_id
left join payment PAY ON REN.rental_id = PAY.rental_id
group by CAT.name
order by revenue DESC;
select * from v_cat_revenue limit 10;