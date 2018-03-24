/*Query 1 -
Find out all the directors who have also acted in movies */
SELECT count(*)
 FROM director
  WHERE director_name IN (SELECT actor_1_name
       FROM movie_actors) 
       
  UNION SELECT count(*)
  FROM director
     WHERE director_name IN (SELECT actor_2_name
        FROM movie_actors)
  
  UNION SELECT count(*)
  FROM director
  WHERE director_name IN (SELECT actor_3_name
  FROM movie_actors);


/*Query 2 -
Which is the most common combination of Genre in which the movies are made?*/
SELECT COUNT(*)
FROM movie
WHERE
    genres IN (SELECT genres
        FROM movie
        WHERE
            SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 1),
                    '|',
                    - 1) = 'Action'
                OR SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 2),
                    '|',
                    - 1) = 'Action'
                OR SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 3),
                    '|',
                    - 1) = 'Action'
                OR SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 4),
                    '|',
                    - 1) = 'Action')
        AND SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 1),
            '|',
            - 1) = 'Thriller'
        OR SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 2),
            '|',
            - 1) = 'Thriller'
        OR SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 3),
            '|',
            - 1) = 'Thriller'
        OR SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 4),
            '|',
            - 1) = 'Thriller'
            
            
/*Query 3 -
A decade is a sequence of 10 consecutive years. For example, 1916 to 1925 & 2006 to 2015. Find the decade with the number of films & display a single decade with maximum films too.*/
/*No of movies released in each year*/ 
SELECT title_year, count(movieID)
FROM movie
WHERE title_year IS NOT NULL
GROUP BY title_year;
/*
No of movies released in each decade( starting decade being 1916 to 1925) as first movie in database is 1916*/
SELECT decade, cnt
from( SELECT round(title_year, -1) as decade, count(movieID) as cnt
FROM movie
WHERE title_year IS NOT NULL
GROUP BY round(title_year, -1))movie;

/*ROUND DEMO -
https://www.w3schools.com/sql/trymysql.asp?filename=trysql_func_mysql_round */


/*Query 4 -
Who are the actors whose movies have scored IMDB score more than the average IMDB score?*/
SELECT DISTINCT
    ma.actor_1_name AS 'Actor name', COUNT(*)
FROM
    movie_actors ma,
    movie_popularity mp
WHERE
    ma.movieID = mp.movieID
        AND mp.imdb_score > (SELECT 
            AVG(imdb_score)
        FROM
            movie_popularity)
        AND ma.actor_1_name IS NOT NULL
GROUP BY 1 
UNION SELECT DISTINCT
    ma.actor_2_name, COUNT(*)
FROM
    movie_actors ma,
    movie_popularity mp
WHERE
    ma.movieID = mp.movieID
        AND mp.imdb_score > (SELECT 
            AVG(imdb_score)
        FROM
            movie_popularity)
        AND ma.actor_2_name IS NOT NULL
GROUP BY 1 
UNION SELECT DISTINCT
    ma.actor_3_name, COUNT(*)
FROM
    movie_actors ma,
    movie_popularity mp
WHERE
    ma.movieID = mp.movieID
        AND mp.imdb_score > (SELECT 
            AVG(imdb_score)
        FROM
            movie_popularity)
        AND ma.actor_3_name IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;


/*Query 5 -
Find the countries where the most popular movies were produced and also compare their budget.*/
SELECT country, sum(budget)
FROM  movie
WHERE movieID IN (SELECT movieID
       FROM movie_popularity
       WHERE  imdb_score > (SELECT  AVG(imdb_score)
     FROM movie_popularity)
AND movie_facebook_likes > (SELECT  AVG(movie_facebook_likes)
            FROM movie_popularity))
GROUP BY country
ORDER BY 2 DESC;


/*Query 6 -
Who are the most popular actors and find the movies that gave them the popularity and compare the gross of the movie.*/
SELECT DISTINCT actor_3_name as 'Actor name', movie_title as 'Movie Title', gross as 'Gross'
FROM actor_ratings r, movie_actors a, movie m
WHERE a.movieId = m.movieID AND r.movieID = a.movieID AND actor_3_facebook_likes IN 
      (SELECT MAX(actor_3_facebook_likes)
       FROM actor_ratings)
       
      UNION SELECT DISTINCT actor_2_name, movie_title, gross
      FROM actor_ratings r, movie_actors a, movie m
      WHERE a.movieId = m.movieID AND r.movieID = a.movieID AND actor_2_facebook_likes IN
      (SELECT MAX(actor_2_facebook_likes)
       FROM actor_ratings) 
       
      UNION SELECT DISTINCT actor_1_name, movie_title, gross
      FROM actor_ratings r,movie_actors a,movie m
      WHERE a.movieId = m.movieID AND r.movieID = a.movieID AND actor_1_facebook_likes IN
      (SELECT MAX(actor_1_facebook_likes)
      FROM actor_ratings);
      
      
/*Query 7 -
Which Genre grossed the most?*/
SELECT sum(gross), "Action" from movie
where SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 1), '|', -1)='Action' or SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 2), '|', -1)='Action'      or  SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 3), '|', -1)='Action'      or  SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 4), '|', -1)='Action'
UNION
SELECT sum(gross), "Horror"from movie
where SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 1), '|', -1)='Horror'	or SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 2), '|', -1)='Horror'      or  SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 3), '|', -1)='Horror'      or  SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 4), '|', -1)='Horror';


/*Query 8 -
What was the profit made in 20th and 21st century?*/
select  avg(gross-budget) as profit, "20th century" AS century
from movie m, movie_popularity mp
where m.movieID=mp.movieID
and m.title_year between 1900 and 1999
union
select  avg(gross-budget), "21th century"
from movie m, movie_popularity mp
where m.movieID=mp.movieID
and m.title_year between 2000 and 2017;