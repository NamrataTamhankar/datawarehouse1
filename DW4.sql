-- dimDate
create table dimDate(date_key integer not null primary key, date date not null, year smallint not null, quarter smallint not null,
					month smallint not null,week smallint not null, day smallint not null, is_weekend boolean);
					
select column_name, data_type from information_schema.columns where table_name= 'dimdate';

-- dimCustomer
create table dimCustomer(customer_key serial not null primary key, customer_id smallint not null, 
						 first_name varchar(50) not null, last_name varchar(50) not null, email varchar(50),
						 address varchar(50) not null, address2 varchar(50), district varchar(50) not null,
						 city varchar(50) not null, country varchar(50) not null, postal_code varchar(10) not null,
						 create_date timestamp not null, start_date date not null, last_date date not null);
		
		


-- dimStore
create table dimStore(store_key serial primary key, store_id smallint not null, address varchar(50) not null,
					   address2 varchar(50), district varchar(50) not null, city varchar(50) not null,
					 country varchar(50) not null, postal_code varchar(10) not null, phone varchar(20) not null,
					  actve smallint not null, create_date timestamp not null, start_date date not null, last_date date not null);
					  

-- dimMovie
create table dimMovie(movie_key serial primary key, film_id smallint not null,title varchar(255)not null,
					  description text, release_year year, language varchar(20) not null, 
					  orignal_language varchar(20), length smallint not null, 
					  rating varchar(5)not null, special_feature varchar(255)not null);
					  
					  
-- insertinto dimdate table
insert into dimdate(date_key, date, year, quarter, month, week, day, is_weekend)
select distinct (to_char(payment_date :: Date, 'yymmdd'):: integer) as date_key, date(payment_date) as date, 
extract(year from payment_date)as year,extract(quarter from payment_date)as quarter,
extract(month from payment_date)as month, extract(week from payment_date)as week, extract(day from payment_date)as day, 
case when extract (ISODOW  from payment_date) IN(6,7) then true else false end as is_weekend
from payment;


-- insertinto public.dimcustomer table
insert into dimcustomer(customer_key, customer_id, first_name, last_name, email, address, address2, district, 
						city, country, postal_code, create_date, start_date, last_date)
select c.customer_id as customer_key, 
		c.customer_id, c.first_name, c.last_name, c.email, a.address, a.address2, 
a.district,ci.city_id, co.country, postal_code, c.create_date, now() as start_date, now() as last_date
from customer as c join address as a on c.address_id = a.address_id
					join city as ci on a.city_id = ci.city_id
					join country as co on ci.country_id = co.country_id;
					
					
select * from dimcustomer;
					
-- insertinto dimmovie table
insert into dimmovie(movie_key, film_id, title, description, release_year, language, orignal_language, length, rating, special_feature)					 	
select f.film_id as movie_key, f.film_id, f.title, f.description, f.release_year, l.name, l.name,
f.length, f.rating, f.special_features
from film as f join language as l on f.language_id = l.language_id;

select * from dimmovie limit 5;
		 
					
-- insertinto dimstore table
insert into dimstore( store_id, address, address2, district, city, country, postal_code, phone, 
					 actve, create_date, start_date, last_date)
select c.store_id, a.address, a.address2, a.district, ci.city_id, co.country, postal_code, 
a.phone, c.active, c.create_date, now() as start_date, now() as last_date
from customer as c join address as a on c.address_id = a.address_id
					join city as ci on a.city_id = ci.city_id
					join country as co on ci.country_id = co.country_id
-- 					join store as s on a.address_id = s.address_id;
					
select * from inventory;

select * from customer limit 5

select * from dimstore limit 5;
select * from dimmovie limit 5;
select * from dimdate limit 5;
select * from dimcustomer limit 5;

-- factsale
create table factsale(sales_key serial primary key, date_key integer references dimdate (date_key),
					 customer_key integer references dimcustomer (customer_key), 
					  movie_key integer references dimmovie (movie_key), 
					 store_key integer references dimstore (store_key), sales_amount numeric)
	
-- insertinto factsale table
insert into factsale(date_key, customer_key, movie_key, store_key, sales_amount)
select to_char(payment_date :: Date, 'yymmdd'):: integer as date_key, p.customer_id as customer_key,
i.film_id as movie_key, i.store_id as store_key, p.amount as sales_amount 
from payment p join rental r on p.rental_id = r.rental_id 
join inventory i on r.inventory_id = i.inventory_id;					
					
select * from factsale limit 5;

-- 3NF					
select f.title, extract(month from p.payment_date) as month, ci.city, sum(p.amount) as revenue
from payment as p join rental as r on p.rental_id = r.rental_id
join inventory as i on r.inventory_id = i.inventory_id 
join film as f on i.film_id = f.film_id join customer as c on p.customer_id = c.customer_id
join address as a on c.address_id = a.address_id join city as ci on a.city_id = ci.city_id
group by f.title, month, ci.city order by f.title, month, ci.city, revenue desc

-- 152msec

-- dimensiontable starschema
select dm.title, dd.month, dc.city, sum(sales_amount) as revenue from factsale
join dimmovie as dm on dm.movie_key = factsale.movie_key join dimdate as dd on dd.date_key = factsale.date_key
join dimcustomer as dc on dc.customer_key = factsale.customer_key
group by dm.title, dd.month, dc.city
order by dm.title, dd.month, dc.city, revenue desc
-- 108msec









					  
					  