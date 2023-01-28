select count(*) from customer;

select min (payment_date) min_payment, max (payment_date) max_payment from payment

select f.title, sum(p.amount) from payment as p 
join rental as r on p.rental_id = r.rental_id
join inventory as i on r.inventory_id = i.inventory_id
join film as f on i.film_id = f.film_id
group by f.title
order by sum(p.amount) DESC

select p.payment_id, p.rental_id ,p.amount, r.inventory_id, i.film_id, f.title, r.customer_id, c.address_id,
a.city_id, ci.city from payment as p 
join rental as r on p.rental_id = r.rental_id
join inventory as i on r.inventory_id = i.inventory_id
join film as f on i.film_id = f.film_id
join customer as c on r.customer_id = c.customer_id
join address as a on c.address_id = a.address_id
join city as ci on a.city_id = ci.city_id
group by city


select p.payment_id, p.rental_id ,p.amount, r.inventory_id, i.film_id, f.title, r.customer_id, c.address_id,
a.city_id, ci.city from payment as p 
join rental as r on p.rental_id = r.rental_id
join inventory as i on r.inventory_id = i.inventory_id
join film as f on i.film_id = f.film_id
join customer as c on r.customer_id = c.customer_id
join address as a on c.address_id = a.address_id
join city as ci on a.city_id = ci.city_id
group by city



select ci.city, count(p.amount) as revenue from payment as p 
join rental as r on p.rental_id = r.rental_id
join inventory as i on r.inventory_id = i.inventory_id
join film as f on i.film_id = f.film_id
join customer as c on r.customer_id = c.customer_id
join address as a on c.address_id = a.address_id
join city as ci on a.city_id = ci.city_id
group by city
order by count(p.amount) desc







join city