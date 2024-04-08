create database imdb;
select * from imdb_movie_data_2023;
select count(*) from imdb_movie_data_2023;
alter table imdb_movie_data_2023 rename column `Moive Name` to Movie_Name;
alter table imdb_movie_data_2023 rename column `Meta Score` to Meta_score;
alter table imdb_movie_data_2023 rename column `PG Rating` to PG_Rating;


-- 1) What are the top-rated movies in the dataset? -- 

select
  Movie_Name,
  rating
from
  imdb_movie_data_2023
order by
  rating desc
limit 10;

-- 2. What is the earliest released movie listed in the IMDb movie , along with its title and release year?

select Movie_Name,Year,Rating from imdb_movie_data_2023
where Year=(select min(Year) from imdb_movie_data_2023);

-- 3. Which movies directed by Steven Spielberg are listed in the IMDb movie ?

select Movie_Name,Year
from imdb_movie_data_2023
where director = 'Steven Spielberg';

-- 4.Counting the movies released in 2023 and rating greater than 8?

select Movie_Name from imdb_movie_data_2023
where year=2023 and Rating>8;

-- 5. What are the top five PG rating categories based on the number of movies in the IMDb ?

select PG_Rating,count(*) as RATING
from imdb_movie_data_2023
group by PG_Rating
order by PG_Rating limit 5;


-- 6)Who are the most frequent directors in the dataset?-- 

select
  director,
  count(*) as movie_count
from
  imdb_movie_data_2023
group by
  director
order by
  movie_count desc;

-- 7)Count of movies in each decade-- 

select concat(floor(year / 10) * 10, 's') as decade,
	count(*) as movies_count
from imdb_movie_data_2023
where year >= 1940
group by decade
order by decade;


-- 8)Identify directors who have worked in multiple genres and count the distinct genres for each:

  select
  director,
  count(distinct genre) as distinct_genre_count
from
  imdb_movie_data_2023
group by
  director
having
  count(distinct genre) > 1
order by
  distinct_genre_count desc;


-- 9)Which combination of genre and director produces the highest-rated movies?-- 

select
  genre,
  director,
  avg(rating) as avg_rating
from
  imdb_movie_data_2023
group by
  genre, director
order by
  avg_rating desc;


-- 10)Categorize movies based on their ratings:-- 

select
  movie_name,
  rating,
  case
    when rating >= 8.0 then 'Excellent'
    when rating >= 6.0 and rating < 8.0 then 'Good'
    else 'Average or Below'
  end as rating_category
from
  imdb_movie_data_2023;


-- 11. Details and ratings of Comedy movies released in 2020:

select movie_name,year,Genre,Rating,votes,Cast,Director
from imdb_movie_data_2023 
where year = 2020 and Genre like '%Comedy%';


-- 12.Check if a movie is suitable for children:

select movie_name,Genre, 
case
when PG_Rating like 'G' then 'Yes'
when PG_Rating like 'PG' then 'Under parental guidence' 
else 'No'
end as SuitableForChildren
from imdb_movie_data_2023;


-- 13. The cast details of a movie by its name using stored procedure:

delimiter $$
create procedure get1(in y int)
begin
     select movie_name,Cast,Director from imdb_movie_data_2023 where year=y;
end $$
delimiter ;

call get1(2010);

-- 14.find out the top 10 movies names, rating,genre of movies that Leonardo DiCaprio  have acted in and sort then by rating 
SELECT movie_name,Rating,Genre FROM imdb_movie_data_2023
WHERE Cast LIKE '%Leonardo DiCaprio%' 
order by Rating desc
limit 10;

-- 15 Find out which director has made the most amount of films with a Meta score 90 and above
create view Rating2 as
Select Director,Count(*) As Film_count from imdb_movie_data_2023 where Meta_score>=90 
group by Director; 
Select * from Rating2 where Film_count = (select max(Film_count) from Rating2);


-- 16 ,find out which Genre of movie was the most Released ?
CREATE VIEW Genre_Count AS
SELECT Genre, COUNT(*) AS MovieCount
FROM imdb_movie_data_2023 
GROUP BY Genre;
SELECT *
FROM Genre_Count
WHERE MovieCount = (SELECT MAX(MovieCount) FROM Genre_Count);


-- 17 Find the top 3 directors with the highest average ratings for their movies, 

select Director,avg(Rating) as Avg_rating,Count(*) as Film_count
from imdb_movie_data_2023
group by Director
order by Film_count desc
limit 3;

-- 18 Find the top 10Genrewhich has the highest effectiveness ratio 
#Effectiveness ratio=(Rating * Votes) + (AvgVotesPerMovie * GlobalAvgRating)) / (Votes + AvgVotesPerMovie)
create view Table1 as
SELECT *,
    ((Rating * Votes) + (AvgVotesPerMovie * GlobalAvgRating)) / (Votes + AvgVotesPerMovie) AS EffectiveRating
FROM (
    SELECT *,
        (SELECT AVG(Rating) FROM imdb_movie_data_2023) AS GlobalAvgRating,
        (SELECT AVG(Votes) FROM imdb_movie_data_2023) AS AvgVotesPerMovie
    FROM imdb_movie_data_2023
) AS subquery
ORDER BY EffectiveRating DESC;

select Genre,avg(EffectiveRating) as EffectiveRating
from table1
group by Genre
order by EffectiveRating
limit 10;




