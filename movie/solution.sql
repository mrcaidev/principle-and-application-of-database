-- Find all movies.
SELECT *
FROM movie;

-- Find all reviewers whose name include 'er'.
SELECT *
FROM reviewer
WHERE name LIKE '%er%';

-- Find the titles of all movies released before 1980.
SELECT title
FROM movie
WHERE year < 1980;

-- Find the reviewer names who have ratings with all movies.
SELECT name
FROM reviewer
WHERE NOT EXISTS (
    SELECT *
    FROM movie
    WHERE NOT EXISTS (
        SELECT *
        FROM rating
        WHERE rating.rid = reviewer.rid
            AND rating.mid = movie.mid
    )
);

-- Find the titles of all movies directed by Steven Spielberg.
SELECT title
FROM movie
WHERE director = 'Steven Spielberg';

-- Find all years that have a movie that received a rating of 4 or 5,
-- and sort them in increasing order.
SELECT DISTINCT movie.year
FROM rating
    LEFT OUTER JOIN movie ON movie.mid = rating.mid
WHERE rating.stars IN (4, 5)
ORDER BY movie.year ASC;

-- Find the titles of all movies that have no ratings.
SELECT title
FROM movie
WHERE mid NOT IN (
    SELECT DISTINCT mid
    FROM rating
);

-- Some reviewers didn't provide a date with their rating.
-- Find the names of all reviewers who have ratings with a NULL value for the date.
SELECT DISTINCT reviewer.name
FROM rating
    LEFT OUTER JOIN reviewer ON reviewer.rid = rating.rid
WHERE rating.ratingdate IS NULL;

-- Write a query to return the ratings data in a more readable format:
-- reviewer name, movie title, stars, and rating date.
-- Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
SELECT reviewer.name AS "reviewer",
    movie.title AS "movie",
    rating.stars AS "stars",
    rating.ratingdate AS "rating date"
FROM rating
    LEFT OUTER JOIN reviewer ON reviewer.rid = rating.rid
    LEFT OUTER JOIN movie ON movie.mid = rating.mid
ORDER BY reviewer.name, movie.title, rating.stars;

-- For all cases where the same reviewer rated the same movie twice
-- and gave it a higher rating the second time,
-- return the reviewer's name and the title of the movie.
SELECT reviewer.name, movie.title
FROM rating a
    LEFT OUTER JOIN rating b ON b.rid = a.rid
    LEFT OUTER JOIN movie ON movie.mid = b.mid
    LEFT OUTER JOIN reviewer ON reviewer.rid = b.rid
WHERE a.mid = b.mid
    AND a.ratingdate < b.ratingdate
    AND a.stars < b.stars;

-- For each movie that has at least one rating, find the highest number of stars that movie received.
-- Return the movie title and number of stars.
-- Sort by movie title.
SELECT DISTINCT movie.title, MAX(rating.stars) AS "max_stars"
FROM rating
    LEFT OUTER JOIN movie ON movie.mid = rating.mid
WHERE stars IS NOT NULL
GROUP BY movie.title
ORDER BY movie.title;

-- List movie titles and average ratings, from highest-rated to lowest-rated.
-- If two or more movies have the same average rating, list them in alphabetical order.
SELECT movie.title, AVG(rating.stars) AS "avg_stars"
FROM rating
    LEFT OUTER JOIN movie ON movie.mid = rating.mid
GROUP BY movie.title
ORDER BY AVG(rating.stars) DESC, movie.title ASC;

-- Find the names of all reviewers who have contributed three or more ratings.
SELECT reviewer.name
FROM rating
    LEFT OUTER JOIN reviewer ON reviewer.rid = rating.rid
GROUP BY reviewer.name
HAVING COUNT(reviewer.name) >= 3;

-- Find the names of all reviewers who rated Gone with the Wind.
SELECT DISTINCT reviewer.name
FROM rating
    LEFT OUTER JOIN reviewer ON reviewer.rid = rating.rid
    LEFT OUTER JOIN movie ON movie.mid = rating.mid
WHERE movie.title = 'Gone with the Wind';

-- For any rating where the reviewer is the same as the director of the movie,
-- return the reviewer name, movie title, and number of stars.
SELECT reviewer.name, movie.title, rating.stars
FROM rating
    LEFT OUTER JOIN reviewer ON reviewer.rid = rating.rid
    LEFT OUTER JOIN movie ON movie.mid = rating.mid
WHERE reviewer.name = movie.director;

-- Return all reviewer names and movie names together in a single list, alphabetized.
-- (Sorting by the first name of the reviewer and first word in the title is fine;
-- no need for special processing on last names or removing "The".)
SELECT name AS "name"
FROM reviewer
UNION
SELECT title AS "name"
FROM movie
ORDER BY name;

-- Find the titles of all movies not reviewed by Chris Jackson.
SELECT movie.title
FROM movie
WHERE mid NOT IN (
    SELECT mid
    FROM rating
        LEFT OUTER JOIN reviewer ON reviewer.rid = rating.rid
    WHERE reviewer.name = 'Chris Jackson'
);

-- For all pairs of reviewers such that
-- both reviewers gave a rating to the same movie,
-- return the names of both reviewers.
-- Eliminate duplicates, don't pair reviewers with themselves,
-- and include each pair only once. For each pair,
-- return the names in the pair in alphabetical order.
SELECT DISTINCT re1.name AS "reviewer 1",
    re2.name AS "reviewer 2"
FROM rating ra1
    LEFT OUTER JOIN rating ra2 ON ra1.mid = ra2.mid
    LEFT OUTER JOIN reviewer re1 ON re1.rid = ra1.rid
    LEFT OUTER JOIN reviewer re2 ON re2.rid = ra2.rid
WHERE re1.name < re2.name;

-- For each rating that is the lowest (fewest stars) currently in the database,
-- return the reviewer name, movie title, and number of stars.
SELECT reviewer.name, movie.title, rating.stars
FROM rating
    LEFT OUTER JOIN movie ON movie.mid = rating.mid
    LEFT OUTER JOIN reviewer ON reviewer.rid = rating.rid
WHERE rating.stars = (
    SELECT MIN(stars)
    FROM rating
);

-- For each movie, return the title and the 'rating spread', that is,
-- the difference between highest and lowest ratings given to that movie.
-- Sort by rating spread from highest to lowest, then by movie title.
SELECT movie.title,
    MAX(rating.stars) - MIN(rating.stars) AS "rating spread"
FROM rating
    LEFT OUTER JOIN movie ON movie.mid = rating.mid
WHERE rating.stars IS NOT NULL
GROUP BY movie.title
ORDER BY MAX(rating.stars) - MIN(rating.stars) DESC, movie.title ASC;

-- Find the difference between the average rating of movies released before 1980
-- and the average rating of movies released after 1980.
-- (Make sure to calculate the average rating for each movie,
-- then the average of those averages for movies before 1980 and movies after.
-- Don't just calculate the overall average rating before and after 1980.)
SELECT AVG(a.avg) - AVG(b.avg) AS "difference"
FROM (
    SELECT AVG(rating.stars) AS "avg"
    FROM rating
        LEFT OUTER JOIN movie ON movie.mid = rating.mid
    WHERE rating.stars IS NOT NULL
    GROUP BY movie.mid, movie.year
    HAVING movie.year < 1980
) AS a,
(
    SELECT AVG(rating.stars) AS "avg"
    FROM rating
        LEFT OUTER JOIN movie ON movie.mid = rating.mid
    WHERE rating.stars IS NOT NULL
    GROUP BY movie.mid, movie.year
    HAVING movie.year > 1980
) AS b;

-- Some directors directed more than one movie.
-- For all such directors, return the titles of all movies directed by them,
-- along with the director name. Sort by director name, then movie title.
SELECT title, director
FROM movie
WHERE director IN (
    SELECT director
    FROM movie
    GROUP BY director
    HAVING COUNT(*) > 1
)
ORDER BY director, title;

-- Find the movie(s) with the highest average rating.
-- Return the movie title(s) and average rating.
SELECT movie.title, AVG(rating.stars) AS "avg_stars"
FROM rating
    LEFT OUTER JOIN movie ON movie.mid = rating.mid
GROUP BY movie.title
HAVING AVG(rating.stars) = (
    SELECT MAX(avg)
    FROM (
        SELECT AVG(rating.stars) AS "avg"
        FROM rating
        GROUP BY rating.mid
    )
);

-- Find the movie(s) with the lowest average rating.
-- Return the movie title(s) and average rating.
SELECT movie.title, AVG(rating.stars) AS "avg_stars"
FROM movie
    LEFT OUTER JOIN rating ON movie.mid = rating.mid
GROUP BY movie.title
HAVING AVG(rating.stars) = (
    SELECT MIN(avg)
    FROM (
        SELECT AVG(rating.stars) AS "avg"
        FROM rating
        GROUP BY rating.mid
    )
);

-- For each director, return the director's name
-- together with the title(s) of the movie(s) they directed
-- that received the highest rating among all of their movies,
-- and the value of that rating. Ignore movies whose director is NULL.
SELECT DISTINCT a.director, a.title, rating.stars
FROM rating
    LEFT OUTER JOIN movie a ON a.mid = rating.mid
WHERE a.director IS NOT NULL
    AND rating.stars = (
    SELECT MAX(rating.stars)
    FROM rating
        LEFT OUTER JOIN movie b ON b.mid = rating.mid
    WHERE b.director = a.director
);
