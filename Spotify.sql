-- Create Database For Spotify
CREATE DATABASE spotify;

Use spotify;

CREATE TABLE spotify_data(
id	VARCHAR(30) NOT NULL PRIMARY KEY,
name VARCHAR(255) NOT NULL,	
artists	VARCHAR(1500) NOT NULL,
duration_ms INT NOT NULL,	
release_date VARCHAR(25) NOT NULL,
year INT NOT NULL,
acousticness DOUBLE NOT NULL,
danceability DOUBLE NOT NULL,
energy DOUBLE NOT NULL,
instrumentalness DOUBLE NOT NULL,
liveness DOUBLE NOT NULL,
loudness DOUBLE NOT NULL,
speechiness	DOUBLE NOT NULL,
tempo DOUBLE NOT NULL,	
valence DOUBLE NOT NULL,
mode INT NOT NULL,
popularity INT NOT NULL,
song_key INT NOT NULL,	
explicit INT NOT NULL
);

-- View the data
SELECT * FROM spotify_data;

-- Shape of the Dataset
SELECT COUNT(*) AS num_rows
FROM spotify_data;

-- Content of the Dataset
SHOW COLUMNS FROM spotify_data;

-- DATA CLEANING 

# Rename name and year columns #
ALTER TABLE spotify_data
CHANGE COLUMN name song_name VARCHAR(255),
CHANGE COLUMN year release_year INT;

# Checking for duplicates #
SELECT id,
     COUNT(id) as count
FROM spotify_data
GROUP BY id
HAVING(count > 1);     --- NO DUPLICATES ---

# Checking for NULL values in the most relevant Columns #
SELECT COUNT(*) AS count
FROM spotify_data
WHERE id IS NULL 
  OR song_name IS NULL
  OR release_year IS NULL 
  OR artists IS NULL
  OR duration IS NULL
  OR popularity IS NULL
  OR song_key IS NULL
  OR liveness IS NULL
  OR danceability IS NULL
  OR acousticness IS NULL; 

# Removing all special characters and cleaning the artists column #
UPDATE spotify_data
SET artists = REPLACE(REPLACE(REPLACE(artists, '[', ''), ']', ''), '''', '');


# Convert duration_ms from millisecond to mm:ss #
ALTER TABLE spotify_data
ADD COLUMN duration VARCHAR(5);

-- Update the new column with the duration
UPDATE spotify_data
SET duration = SUBSTRING(sec_to_time(floor(duration_ms/1000)), 4, 5);

# Dropping all irrelevant columns #
ALTER TABLE spotify_data
DROP COLUMN duration_ms;

ALTER TABLE spotify_data
DROP COLUMN release_date;

-- QUESTIONS 

-- Q1: Total songs
SELECT 
    COUNT(*) AS total_number_of_song
FROM
    spotify_data;


-- Q2: Numbers of songs released by year
SELECT
    CASE 
    WHEN release_year BETWEEN 1920 AND 1929 THEN '1920s'
	WHEN release_year BETWEEN 1930 AND 1939 THEN '1930s'
    WHEN release_year BETWEEN 1940 AND 1949 THEN '1940s'
	WHEN release_year BETWEEN 1950 AND 1959 THEN '1950s'
    WHEN release_year BETWEEN 1960 AND 1969 THEN '1960s'
	WHEN release_year BETWEEN 1970 AND 1979 THEN '1970s'
    WHEN release_year BETWEEN 1980 AND 1989 THEN '1980s'
	WHEN release_year BETWEEN 1990 AND 1999 THEN '1990s'
    WHEN release_year BETWEEN 2000 AND 2009 THEN '2000s'
	WHEN release_year BETWEEN 2010 AND 2019 THEN '2010s'
	ELSE '2020s'
  END AS 'song_decade',
  COUNT(release_year) AS songs_count
FROM
    spotify_data
GROUP BY song_decade
ORDER BY songs_count DESC;


-- Q3: Most popular song and artists
SELECT 
    song_name, artists, popularity
FROM
    spotify_data
ORDER BY popularity DESC
LIMIT 10;


-- Q4: Percentage of songs released in 2020 
SELECT 
    (SUM(CASE
        WHEN release_year BETWEEN '2019' AND '2020' THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*)) AS percentage_released_in_2020
FROM
    spotify_data;


-- Q5: Determine the 'danceability' of each song --
SELECT 
    song_name,
    artists,
    CASE
        WHEN danceability >= 0.7 THEN 'Most Danceable'
        WHEN danceability >= 0.5 THEN 'Danceable'
        WHEN danceability >= 0.3 THEN 'Least Danceable'
        ELSE 'Not Danceable'
    END AS danceability_group
FROM
    spotify_data
ORDER BY danceability_group;


-- Q6: How many songs fall into each danceability group?
SELECT
    danceability_group,
    COUNT(*) AS song_count
FROM (
    SELECT 
        song_name,
        artists,
        CASE
            WHEN danceability >= 0.7 THEN 'Most Danceable'
            WHEN danceability >= 0.5 THEN 'Danceable'
            WHEN danceability >= 0.3 THEN 'Least Danceable'
            ELSE 'Not Danceable'
        END AS danceability_group
    FROM
        spotify_data
) AS subquery
GROUP BY
    danceability_group
ORDER BY
    danceability_group;


-- Q7: Artist and song with the longest song duration 
SELECT 
    song_name, artists, 
    MAX(duration) AS longest_song_length
FROM
    spotify_data
GROUP BY song_name, artists
ORDER BY longest_song_length DESC
LIMIT 1;
    
    
-- Q8: Average song duration --
SELECT
       ROUND(AVG(duration),2) AS avg_song_length
FROM spotify_data;


-- Q9: Return all song names with the song length longer than the average song length --
SELECT 
    song_name, duration
FROM
    spotify_data
WHERE
    duration > (SELECT 
            AVG(duration) AS avg_song_length
        FROM
            spotify_data)
ORDER BY duration;


-- Q10: Most recently released song
SELECT 
    song_name, artists, release_year
FROM
    spotify_data
ORDER BY release_year DESC
LIMIT 5;

-- Q11: Distribution of each key by song
SELECT 
    song_key, COUNT(*) AS song_count
FROM
    spotify_data
GROUP BY song_key
ORDER BY song_count DESC;


-- Q12: Top 5 artists with the highest average acousticness
SELECT 
    artists, AVG(acousticness) AS avg_acousticness
FROM
    spotify_data
GROUP BY artists
ORDER BY avg_acousticness DESC
LIMIT 5;


-- Q13: What is the song with the highest average liveness?
    SELECT
    song_name,
    artists,
    AVG(liveness) AS average_liveness
FROM
    spotify_data
GROUP BY
    song_name, artists
HAVING
    AVG(liveness) = MAX(liveness)
ORDER BY average_liveness desc
Limit 1;





