USE sakila;

-- Write SQL queries to perform the following tasks using the Sakila database:

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*)
FROM inventory
WHERE film_id IN (
SELECT film_id 
FROM film 
WHERE title = 'Hunchback Impossible'
);

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title, length
FROM film
WHERE length > (
SELECT AVG(length)
FROM film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT *
FROM actor
WHERE actor_id IN (
SELECT actor_id
FROM film_actor
WHERE film_id IN (
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
));

-- Bonus:

-- 4. Identify all movies categorized as family films.
SELECT *
FROM film
WHERE film_id IN (
SELECT film_id
FROM film_category
WHERE category_id = (
SELECT category_id
FROM category
WHERE name = 'Family'
));

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
SELECT address_id
FROM address
WHERE city_id IN (
SELECT city_id
FROM city
WHERE country_id = (
SELECT country_id
FROM country
WHERE country = 'Canada'
)));

SELECT first_name, last_name, email
FROM customer
JOIN address USING (address_id)
JOIN city USING (city_id)
JOIN country USING (country_id)
WHERE country = 'Canada';

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is the actor who has acted in the most number of films. 
SELECT title
FROM film
WHERE film_id IN (
SELECT film_id
FROM film_actor
WHERE actor_id = (
SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1
));

-- 7. Find the films rented by the most profitable customer in the Sakila database. 
-- Use the customer and payment tables to find the customer who has made the largest sum of payments.
SELECT title
FROM film
WHERE film_id IN (
SELECT film_id 
FROM inventory
WHERE inventory_id IN (
SELECT inventory_id
FROM rental
WHERE customer_id = (
SELECT customer_id
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1
)));

-- 8. Retrieve the client_id and total_amount_spent for the clients who spent > AVG total_amount spent by each client. 
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > (
SELECT AVG(total_amount)
FROM (
SELECT SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
) AS avg_total_per_customer
);