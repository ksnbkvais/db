WITH UserRatingCounts AS (
    SELECT 
        user_id, 
        COUNT(*) AS rating_count
    FROM MovieRating
    GROUP BY user_id
),
MaxUserRating AS (
    SELECT 
        user_id
    FROM UserRatingCounts
    WHERE rating_count = (
        SELECT MAX(rating_count) FROM UserRatingCounts
    )
),
TopUser AS (
    SELECT 
        name
    FROM Users
    WHERE user_id IN (SELECT user_id FROM MaxUserRating)
    ORDER BY name
    LIMIT 1
),
FebruaryRatings AS (
    SELECT 
        movie_id, 
        AVG(rating) AS avg_rating
    FROM MovieRating
    WHERE created_at BETWEEN '2020-02-01' AND '2020-02-29'
    GROUP BY movie_id
),
MaxAverageRating AS (
    SELECT 
        movie_id
    FROM FebruaryRatings
    WHERE avg_rating = (
        SELECT MAX(avg_rating) FROM FebruaryRatings
    )
),
TopMovie AS (
    SELECT 
        title
    FROM Movies
    WHERE movie_id IN (SELECT movie_id FROM MaxAverageRating)
    ORDER BY title
    LIMIT 1
)
SELECT name AS results FROM TopUser
UNION ALL
SELECT title AS results FROM TopMovie;
