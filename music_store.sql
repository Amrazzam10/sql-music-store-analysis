--Who is the senior most employee based on job title?
select top 1 title, first_name +' ' + last_name as fullname
from employee$
order by levels desc
--Top Invoice by Total Amount:
SELECT top 1 invoice_id, customer_id, total
FROM invoice$
ORDER BY total DESC
--Customers with Multiple Invoices:
select c.customer_id ,c.first_name,c.last_name
from customer$ c
where ( select COUNT (*)  from invoice$ i where i.customer_id= c.customer_id) >1
--Number of customers in each country?
select country, COUNT (*) as countofcustomers 
from customer$
group by country
order by countofcustomers desc
--Tracks with Highest Unit Price:
SELECT top 10
t.name AS track_name,
t.unit_price
FROM track$ t
ORDER BY unit_price DESC
--total revenue generated by each billing country?
SELECT billing_country,sum(total) AS total_revenue
FROM invoice$
GROUP BY billing_country
ORDER BY total_revenue DESC;
--Top Selling Genre by Revenue:
select top 1 
g.name,
sum (total) as total_revenue 
from invoice$ i
join invoice_line il on i.invoice_id =il.invoice_line_id
join track$ t on il.track_id = t.track_id
join genre$ g on t.genre_id =g.genre_id
group by g.name
ORDER BY total_revenue DESC
-- top 5 monthly revenue 
SELECT top 5 DATEPART(YEAR, invoice_date) AS year,
 DATEPART(MONTH, invoice_date) AS month,
 SUM(total) AS monthly_revenue
FROM [invoice$]
GROUP BY DATEPART(YEAR, invoice_date), DATEPART(MONTH, invoice_date)
ORDER BY year, month;
--Top Composers by Number of Tracks?
SELECT composer,COUNT(track_id) AS number_of_tracks
FROM track$
WHERE composer IS NOT NULL
GROUP BY composer
ORDER BY number_of_tracks DESC;
--The top3customers who has spent the most money?
select top 3 c.customer_id,   SUM (total) as total
from customer$ c
join invoice$ i 
on c.customer_id =i.customer_id
group by c.customer_id
order by total desc
--Price Distribution by Media Type?
select max(t.unit_price) as maxprice,
min(t.unit_price) as minprice,
avg(t.unit_price) as avgprice,
m.name
from track$ t
join media_type$ m
on t.media_type_id=m.media_type_id
group by m.name
--top track in Playlists
select p.playlist_id , p.playlist_name,t.track_id,t.name,  count (pt.track_id) as trackcount
from playlist$ p
join playlist_track$ pt
on p.playlist_id =pt.playlist_id
join track$ t on pt.track_id=t.track_id
group by p.playlist_id, p.playlist_name,t.track_id,t.name
order by p.playlist_id,p.playlist_name, trackcount desc
--- top 5 made artist made albums 
select top 5
count (a.artist_id) as albums_count , ar.name 
from album2$ a
join artist$ ar
on a.artist_id =ar.artist_id
group by name
ORDER BY albums_count DESC;

--Popular Albums by Sales:
select a.title , count(il.track_id) as total_sales
from album2$ a
join track$ t on a.album_id = t.album_id
join invoice_line il on t.track_id=il.track_id
group by a.title
ORDER BY total_sales DESC;
--Playlist Track Count Ranking:
SELECT p.playlist_name AS playlist_name, 
COUNT(pt.track_id) AS track_count,
RANK() OVER (ORDER BY COUNT(pt.track_id) DESC) AS rank
FROM playlist$ p
LEFT JOIN playlist_track$ pt ON p.playlist_id = pt.playlist_id
GROUP BY p.playlist_name;
--
