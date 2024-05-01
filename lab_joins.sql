USE sakila;

-- 1. List the number of films per category.
SELECT COUNT(f.film_id) as number_films,
fc.category_id,
name as name_category
FROM film AS f
LEFT JOIN film_category AS fc
ON f.film_id = fc.film_id
LEFT JOIN category AS c
ON fc.category_id = c.category_id
GROUP BY category_id;

-- 2. Retrieve the store ID, city, and country for each store.
SELECT s.store_id,
		c.city,
		co.country
FROM store AS s
LEFT JOIN address AS a
ON s.address_id = a.address_id
LEFT JOIN city AS c
ON a.city_id = c.city_id
LEFT JOIN country AS co
ON co.country_id = c.country_id
GROUP BY store_id;

-- 3.Calculate the total revenue generated by each store in dollars.
-- ingresos totales por cada tienda
SELECT s.store_id,
FORMAT(SUM(p.amount),2, 'En-Us') as amount
FROM payment as p
LEFT JOIN customer as c
ON p.customer_id = c.customer_id
LEFT JOIN store as s
ON s.store_id = c.store_id
GROUP BY s.store_id;

-- 4. Determine the average running time of films for each category.
SELECT 
AVG(f.length) as avg_time,
c.category_id,
c.name
FROM film AS f
LEFT JOIN film_category AS fc
ON f.film_id = fc.film_id
LEFT JOIN category AS c
ON fc.category_id = c.category_id
GROUP BY category_id;

-- Bonus:
-- 5.Identify the film categories with the longest average running time.
SELECT 
AVG(f.length) as avg_time,
c.category_id,
c.name
FROM film AS f
LEFT JOIN film_category AS fc
ON f.film_id = fc.film_id
LEFT JOIN category AS c
ON fc.category_id = c.category_id
GROUP BY category_id
ORDER BY avg_time DESC; 

-- 6.Display the top 10 most frequently rented movies in descending order.
SELECT
f.title as movie,
COUNT(r.rental_date) as most_rental
FROM film as f
LEFT JOIN inventory as i
ON f.film_id = i.film_id
LEFT JOIN rental as r
ON i.inventory_id = r.inventory_id
GROUP BY movie
ORDER BY most_rental DESC 
LIMIT 10;

-- 7. Determine if "Academy Dinosaur" can be rented from Store 1.
SELECT 
f.title,
s.store_id, 
r.return_date,
r.rental_date
FROM film as f
LEFT JOIN inventory as i
ON f.film_id = i.film_id
LEFT JOIN rental as r
ON i.inventory_id = r.inventory_id
LEFT JOIN store as s
ON i.store_id = s.store_id
WHERE f.title LIKE '%Academy Dinosaur%' AND s.store_id = 1
ORDER BY r.return_date DESC
LIMIT 1; 


-- 8. Provide a list of all distinct film titles, along with their availability status in the inventory. 
-- Include a column indicating whether each title is 'Available' or 'NOT available.' Note that there are 42 titles that are not in the inventory, and this information can be obtained using a CASE statement combined with IFNULL."
SELECT
    DISTINCT(f.title) AS unique_film,
    CASE 
        WHEN i.inventory_id IS NULL THEN 'Not Available'
        ELSE 'Available'
    END AS status
FROM film AS f
LEFT JOIN inventory AS i ON f.film_id = i.film_id;
