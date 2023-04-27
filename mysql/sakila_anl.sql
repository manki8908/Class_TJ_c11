-- -------------------------------------
-- sakila 데이터 분석
-- -------------------------------------
USE sakila;

-- actor, film, customer, staff, rental, inventory count
desc sakila.actor;	-- 200명/ actor_id, first_name, last_name, last_update
select count(*) from sakila.actor;

desc sakila.film;	-- 1000개/ film_id, title, description, release_year, language_id, orriginal_language_id,
					-- 			rental_duration, rental_rate, length, replacement_cost, rating
                    -- 			special_features, last_update
select count(*) from sakila.film;

desc sakila.film_actor;	-- 5462개 /actor_id, film_id, last_update
select count(*) from sakila.film_actor;

desc sakila.customer;	-- 599개/ customer_id, store_id, first_name, last_name, email, address_id, active
						-- create_date, last_update
select count(*) from sakila.customer;

desc sakila.staff;	-- 2명/ staff_id, first_name, last_name, address_id, picture, email, store_id, active
					-- 		username, password, last_update
select count(*) from sakila.staff;

desc sakila.rental;	-- 16044개/ rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update
select count(*) from sakila.rental;

desc sakila.inventory;	-- 4581개/ inventory_id, film_id, store_id, last_update
select count(*) from sakila.inventory;

desc sakila.country;	-- 109개/ country_id, country, last_update
select count(*) from sakila.country;

desc sakila.address;	-- 603개/ address_id, address, address2, district, city_id, postal_code, phone, location
						-- 	last_update
select count(*) from sakila.address;

desc sakila.payment;	-- 16049개/ payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update
select count(*) from sakila.payment;


-- -------------------------------------


-- 1. 배우 이름을 합쳐서 '배우' 컬럼을 조회
select upper(concat(first_name, " ", last_name)) "배우" from sakila.actor;

-- 2. son으로 끝나는 성을 가진 배우 조회
select * from sakila.actor where upper(last_name) like '%son';

-- 3. 배우들이 출연한 영화 배우 이름을 합쳐서 '배우' 컬럼으로 조회 tittle, release_year
select UPPER(concat(first_name,' ', last_name)) '배우', F.title, F.release_year from film F, actor A, film_actor B
where A.actor_id = B.actor_id and B.film_id = F.film_id;

-- 4. 성(last name) 별  배우 숫자, 내림차순, 중복이면 성 알파벡 오름차순
select last_name, count(*) as 명 from sakila.actor
group by last_name
order by 명 desc, last_name ;

-- 5. country가 오스트레일리아  독일 contry id / contry
select country_id, country from sakila.country
-- where country = "Australia" or country = "Germany";
where country IN("Australia", "Germany");


-- 6. 스테프 테이블에서 이름을 성이름을 합치고 STAFF로 하고,
-- staff과 address테이블을 합치고 
-- address, district, postal code, city id를 조회
select concat(S.first_name, ' ', S.last_name) "직원", A.address, A.district, A.postal_code, A.city_id from sakila.staff S 
inner join address A
ON S.address_id = A.address_id;


-- 7. 스테프 이름 합치고, payment(pay컬럼) 테이블과 합치고
-- staff 이름기준으로 그룹화하여 7월 이면서 2005년 조회
select concat(S.first_name, ' ', S.last_name) AS 직원 , sum(P.amount)
from  sakila.staff S
inner join sakila.payment P
on S.staff_id = P.staff_id
where YEAR(P.payment_date) = 2005 and MONTH(P.payment_date) = 7
group by 직원;


-- 8.영화별 출연 배우의 수
select F.title, count(*) AS 배우수
from film F
inner join film_actor FA
on F.film_id = FA.film_id
group by F.title
order by 배우수 desc;


-- 9. 영화 제목이 'HALLOWEEN NUTS' 배우 이름이 성과 이름을 합쳐서 나오도록 조회
-- 서브쿼리 - 조건절에 쿼리를 새로 만들어야함
select concat(first_name, ' ', last_name) 배우
from actor
where actor_id in 
(select actor_id from film_actor where film_id in
(select film_id from film
 where lower(title) = lower('HALLOWEEN NUTS')));

-- 10.1 국가가 CANADA인 고객의 이름을 서브쿼리로 찾기
-- 고객 성과 이름을 합치고 고개, email, customer, address, city, country 활용
-- 서브쿼리 3번 
select concat(first_name, ' ', last_name) 고객, email
from customer
where address_id in
(select address_id from address where city_id in 
(select city_id from city where country_id in 
(select country_id from country 
where country = 'CANADA')));

-- 10.2 join을 활용해 국가가 canada인 고객 이름
select concat(first_name, ' ', last_name) 고객, email from customer CUS
inner join address A on A.address_id = CUS.address_id
inner join city CT on A.city_id = CT.city_id
inner join country C on C.country_id = CT.country_id
where country = 'CANADA';

-- 11. 영화에서 PG등급, G등급 조회
-- rating, count(*) 수량
select rating, count(*) as 수량 from film
where rating = 'PG' or rating = 'G'
group by rating;

-- 12. pg 또는 g등급 영화 이름 rating, title, release year
select title, rating, release_year from film
where rating = 'PG' or rating = 'G';

-- 13. 등급별 rating, count
select rating, count(*) from film group by rating;


-- 14. rental_rate가 1~6인 등급별 영화의 수를 출력
select rating, count(*) "영화수" from sakila.film
where rental_rate between 1 and 6
group by rating;


-- 15. film테이블에서 등급별 영화 수 합계, 최고 , 최소 rating, 
-- 평균 렌탈비용으로 내림차순 정렬 rental_rate 
select rating, count(*) "영화수", sum(rental_rate), max(rental_rate) '최고', min(rental_rate) '최소' from film
group by rating, rental_rate
order by avg(rental_rate) desc;

-- 16. 등급별 영화 개수, 등급, 평균렌탈 rate를 조회하고 평균렌탈 rate를 내림차순으로 조회
select count(*), rating, avg(rental_rate) as 평균 from film
group by rating
order by 평균 desc;

-- 17. 분류가 family 인 film 테이블에서 서브쿼리를 이용해 조회
-- film, film_category, category 테이블 활용

-- join
select film_id, title, release_year from film F
inner join film_category FC on F.film_id = FC.film_id
inner join category C on FC.category_id = C.category_id
where C.name = 'Family';

-- sub 쿼리
select film_id, title, release_year
from film
where film_id in
(select film_id from film_category where category_id in
(select category_id from category where name = 'FAMILY'));


-- 3. action 영화의 이름, 영화수, 합계(rental_rate),
-- 		평균, 최소, 최고 집계
-- select title, count(*), sum(rental_rate), avg(rental_rate), min(rental_rate), max(rental_rate)
-- from film F
select title from film F
inner join film_category FC on F.film_id = FC.film_id
inner join category C on FC.category_id = C.category_id
where C.name = 'Action';

-- 19. 가장 대여비가 높은 영화 분류
-- category, film_category, inventory, payment, rental


-- 가장 대여비가 높은 영화 분류 조회 2개(name, sum(ifnull)을 사용 payment 테이블에서
-- amount 합계) name은 category_name으로 합계는 revenue로 별칭a
-- category, film_ccategory, inventory, payment rental 테이블 join 후 name으로
-- 그룹 분석 후 revenue로 내림차순



-- 20. 위의 쿼리문 결과를 뷰로 생성 v_cat_revenue로 하고 뷰를 조회 하시오 
