#MYSQL MUSIC DATA ANALYSIS PROJECT 

#Creating Database - music and importing CSV files as different tables in this database
CREATE DATABASE music;
USE music;

#QUESTIONS
#Q1  Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent.
SELECT 
    CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,
    artist.name AS artist_name,
    SUM(invoice_line.unit_price * invoice_line.quantity) AS total_spent
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN album ON track.album_id = album.album_id
JOIN artist ON album.artist_id = artist.artist_id
GROUP BY customer_name, artist_name
ORDER BY customer_name, total_spent DESC;

#Q2 Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.
SELECT 
    CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,
    customer.country AS country,
    SUM(invoice_line.unit_price * invoice_line.quantity) AS total_spent
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
GROUP BY customer_name, country 
ORDER BY customer_name, total_spent DESC;

#Q3 Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A.
SELECT email, last_name, first_name FROM customer 
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
 SELECT track_id FROM track
 JOIN genre ON track.genre_id = genre.genre_id
 WHERE genre.name = "Rock"
)
ORDER BY email;

#Q4 Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands #AC/DC
SELECT artist.artist_id, artist.name, count(artist.artist_id) AS number_of_songs FROM track 
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.NAME = "Rock"
GROUP BY artist.artist_id, artist.NAME
ORDER BY number_of_songs DESC LIMIT 10;

#Q5 Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
SELECT name, milliseconds FROM track 
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;

#Q6 Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money? #FrantiÅ¡ek WichterlovÃ¡
SELECT customer.customer_id, customer.last_name, customer.first_name, sum(invoice.total) AS total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, customer.last_name, customer.first_name
ORDER BY total DESC LIMIT 1;

#Q7 Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals? #USA, 1040.4899999999999998
SELECT billing_country, sum(total) FROM invoice GROUP BY billing_country ORDER BY sum(total) DESC;

#Q8 Who is the senior most employee based on job title? #Andrew Adams
SELECT * FROM employee ORDER BY levels DESC LIMIT 1;

#Q9 Which countries have the most invoices? #USA
SELECT billing_country, count(*) FROM invoice GROUP BY billing_country ORDER BY count(*) DESC;

#Q10 What are the top 3 values of total invoice? #23.7599999999999998, 19.8, 19.8
SELECT total FROM invoice ORDER BY total DESC;


#END