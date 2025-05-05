-- This is the unnormalized form table.
CREATE TABLE AwardData ( 

 id INT PRIMARY KEY,

 movie_title VARCHAR(255),

 release_year INT,

 director_names VARCHAR(255), -- MULTIPLE directors separated by commas!

 actor_names VARCHAR(255), -- MULTIPLE actors separated by commas!

 studio_names VARCHAR(255), -- MULTIPLE studios listed (for co-productions)

 awards_info VARCHAR(500) -- Entire award details crammed together, like 'Best Picture-2019; Best Director-2019'

);



INSERT INTO AwardData (id, movie_title, release_year, director_names, actor_names, studio_names, awards_info)
VALUES
(1, 'Everything Everywhere All At Once', 2022, 'Daniel Kwan, Daniel Scheinert', 'Michelle Yeoh, Ke Huy Quan', 'A24', 'Best Picture-2023; Best Director-2023'),
(2, 'The Power of the Dog', 2021, 'Jane Campion', 'Benedict Cumberbatch, Kirsten Dunst', 'Netflix', 'Best Director-2022'),
(3, 'CODA', 2021, 'Sian Heder', 'Emilia Jones, Troy Kotsur', 'Apple TV+', 'Best Picture-2022'),
(4, 'Nomadland', 2020, 'Chloé Zhao', 'Frances McDormand', 'Searchlight Pictures', 'Best Picture-2021; Best Director-2021'),
(5, '1917', 2019, 'Sam Mendes', 'George MacKay, Dean-Charles Chapman', 'DreamWorks, Universal', 'Best Cinematography-2020');

-- Normalization:
-- As per the question the AwardData table is normalized into 3NF creating tables Movies, Directors, Actors, Studios and Awards. Through this transitive dependencies have been eliminated.
-- Prior to the 3NF there were transitive dependencies such as award_info depended on movie_title not just the id which was the primary key.
-- Junction tables are created to create relationships between the tables. Mainly connecting with the Movies table. Further explanation is below.
CREATE TABLE Movies (
	movie_id INT PRIMARY KEY,
	movie_title VARCHAR(255),
	release_year INT -- Release year was included in Movies tables and did not have it's own table, as it was not necessary/ not very beneficial.
	);

INSERT INTO Movies (movie_id, movie_title, release_year) VALUES
(1,'Everything Everywhere All At Once', 2022),
(2, 'The Power of the Dog', 2021),
(3, 'CODA', 2021),
(4, 'Nomadland', 2020),
(5, '1917', 2019) ;

CREATE TABLE Directors (
	director_id INT PRIMARY KEY, -- Each director has their own unique row with their own unique ID, instead of being dependant on the movie id as previous.
	director_name VARCHAR(255) );

INSERT INTO Directors (director_id, director_name) VALUES 
(1, 'Daniel Kwan'),
(2, 'Daniel Scheinert'),
(3, 'Jane Campion'),
(4, 'Sian Heder'),
(5, 'Chloé Zhao'),
(6, 'Sam Mendes') ;

CREATE TABLE Actors ( 
	actor_id INT PRIMARY KEY, -- Each actor has their own unique row with their own unique ID, instead of being dependant on the movie id as previous.
	actor_name VARCHAR(255) );

INSERT INTO Actors (actor_id, actor_name) VALUES
(1, 'Michelle Yeoh'),
(2, 'Ke Huy Quan'),
(3, 'Benedict Cumberbatch'),
(4, 'Kirsten Dunst'),
(5, 'Emilia Jones'),
(6, 'Troy Kotsur'),
(7, 'Frances McDormand'),
(8, 'George MacKay'),
(9, 'Dean-Charles Chapman') ;

CREATE TABLE Studios (
	studio_id INT PRIMARY KEY, -- Each studio has their own unique row with their own unique ID, instead of being dependant on the movie id as previous.
	studio_name VARCHAR(255) );

INSERT INTO Studios (studio_id, studio_name) VALUES
(1, 'A24'),
(2, 'Netflix'),
(3, 'Apple TV+'),
(4, 'Searchlight Pictures'),
(5, 'DreamWorks'),
(6, 'Universal') ;

CREATE TABLE Awards (
    award_id INT PRIMARY KEY, -- Each award has their own unique row with their own unique ID, instead of being dependant on the movie id as previous.
    movie_id INT,
    category VARCHAR(255),
    year INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id) ); -- movie_id is added to the table as foreign key, instead of creating a junction table as one movie might win multiple awards but an award can
														  -- only be awarded to one movie. Creating a one-to-many relation between Movies and Awards respectively.

INSERT INTO Awards (award_id, movie_id, category, year) VALUES
(1, 1, 'Best Picture', 2023),
(2, 1, 'Best Director', 2023),
(3, 2, 'Best Director', 2022),
(4, 3, 'Best Picture', 2022),
(5, 4, 'Best Picture', 2021),
(6, 4, 'Best Director', 2021),
(7, 5, 'Best Cinematography', 2020) ;

-- Junction Tables
-- Junction tables are created for tables who have a many-to-many relationships with Movies table. As Directors, Actors and Studios can have multiple Movies and also Movies can have multiple of them.
-- Creating junction tables helps in keeping the main tables clean with less columns and also helps in building relationships between them.

CREATE TABLE Movie_Directors (
    movie_id INT,
    director_id INT,
    PRIMARY KEY (movie_id, director_id), -- Both are taken as Primary Key.
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id), -- Linking with Movies table.
    FOREIGN KEY (director_id) REFERENCES Directors(director_id) ); -- Linking with Directors table.

INSERT INTO Movie_Directors (movie_id, director_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6);

CREATE TABLE Movie_Actors (
    movie_id INT,
    actor_id INT,
    PRIMARY KEY (movie_id, actor_id), -- Both are taken as Primary Key.
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id), -- Linking with Movies table.
    FOREIGN KEY (actor_id) REFERENCES Actors(actor_id)); -- Linking with Actors table.

INSERT INTO Movie_Actors (movie_id, actor_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(5, 8),
(5, 9);

CREATE TABLE Movie_Studios (
    movie_id INT,
    studio_id INT,
    PRIMARY KEY (movie_id, studio_id), -- Both are taken as Primary Key.
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id), -- Linking with Movies table.
    FOREIGN KEY (studio_id) REFERENCES Studios(studio_id) ); -- Linking with Studios table.

INSERT INTO Movie_Studios (movie_id, studio_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(5, 6);

-- Complex JOIN Query: Listing all award winning movies displaying: Movie Title, Director Name, Lead Actor Name, Studio Name, Award Category

-- The Junction tables are heavily used to create the complex Joins. All tables are used. Award table can be directly joined with Movies table.
SELECT m.movie_title AS 'Movie Title', d.director_name AS 'Director Name', a.actor_name AS 'Lead Actor Name', s.studio_name AS 'Studio Name', aw.category AS 'Award Category' -- Selected columns.
FROM Movies m
JOIN Movie_Directors md ON md.movie_id = m.movie_id -- Movies-Directors junction table used to JOIN with Movies.
JOIN Directors d ON md.director_id = d.director_id -- Movies-Directors junction table used to JOIN with Directors.
JOIN Movie_Actors ma ON ma.movie_id = m.movie_id -- Movies-Actors junction table used to JOIN with Movies.
JOIN Actors a ON a.actor_id = ma.actor_id -- Movies-Actors junction table used to JOIN with Actors.
JOIN Movie_Studios ms ON ms.movie_id = m.movie_id -- Movies-Studios junction table used to JOIN with Movies.
JOIN Studios s ON s.studio_id = ms.studio_id -- Movies-Studios junction table used to JOIN with Studios.
JOIN Awards aw ON aw.movie_id = m.movie_id; -- Junction table not required to JOIN.

-- Subqueries and Correlated 
	-- Actors who have won more than one award

SELECT a.actor_name
FROM Actors a
WHERE ( 
		SELECT COUNT(*) -- Counts all rows in the JOIN.
		FROM Movie_Actors ma -- Junction table used as it contains all Movies and Actors.
		JOIN Awards aw ON ma.movie_id = aw.movie_id -- JOINing with Awards table, creating connection between Movies, Actors and Awards.
		WHERE ma.actor_id = a.actor_id -- connecting junction table with main table.
		) > 1; -- Count of rows needs to be more than one.

	-- Directors whose films have the highest average award count

SELECT d.director_name
FROM Directors d
JOIN ( 
    SELECT md.director_id, AVG(award_count * 1.0) AS avg_awards -- This calculates average award count per director.
    FROM Movie_Directors md -- Junction table used to connect Directors and Movies.
    JOIN (
        SELECT movie_id, COUNT(*) AS award_count -- Count of awards per movie.
        FROM Awards -- Awards table contains award records per movie.
        GROUP BY movie_id -- Grouping to get count per movie.
    ) aw_counts ON md.movie_id = aw_counts.movie_id -- Connecting movie award counts to the director via the junction table.
    GROUP BY md.director_id -- Grouping to get an average per director.
) avg_per_director ON d.director_id = avg_per_director.director_id -- Linking average award data to the Directors table.
WHERE avg_per_director.avg_awards = (
    SELECT MAX(avg_awards) -- Get the highest average award count among all directors.
    FROM (
        SELECT md.director_id, AVG(award_count * 1.0) AS avg_awards -- Repeat of average calculation for comparison.
        FROM Movie_Directors md
        JOIN (
            SELECT movie_id, COUNT(*) AS award_count -- Count awards per movie again.
            FROM Awards
            GROUP BY movie_id
        ) aw_counts ON md.movie_id = aw_counts.movie_id
        GROUP BY md.director_id -- Grouping per director again for aggregation.
    ) temp -- Alias for derived table used to extract MAX value.
);

-- Windows Function
	-- Query that shows all studios and the running total of awards their movies have won.
	
SELECT 
    s.studio_name, -- Display the name of each studio.
    a.award_id, -- Show the award ID (each row represents one award).
    1 AS total_awards, -- Each award counts as 1 for tallying purposes.
    ROW_NUMBER() OVER ( PARTITION BY s.studio_name ORDER BY a.award_id
    ) AS running_total_awards -- -- Assigns a sequential number to each award per studio, creating a running total.
FROM Studios s
JOIN Movie_Studios ms ON s.studio_id = ms.studio_id -- Junction table connecting Studios and Movies.
JOIN Awards a ON ms.movie_id = a.movie_id -- Connect Awards through movie ID to relate them to Studios.
ORDER BY s.studio_id; -- Sorts the result by studio for organized output.

	-- Directors ranked by the total number of awards their films have received.

SELECT 
    d.director_name, -- Display the name of each director.
    COUNT(a.award_id) AS award_count, -- Count the total number of awards won by movies directed by this director.
    DENSE_RANK() OVER (ORDER BY COUNT(a.award_id) DESC) AS Ranking -- Assign a ranking based on award count (directors with the same count share the same rank).
FROM Directors d
JOIN Movie_Directors md ON d.director_id = md.director_id -- Junction table connecting Directors and Movies.
JOIN Awards a ON md.movie_id = a.movie_id -- Join Awards through movie ID to count awards for each director.
GROUP BY d.director_name -- Group results by director to get award totals per director.
ORDER BY ranking; -- Sort the final output by the computed rank.

-- CTE
	-- Using a CTE, find all studios that have produced at least 3 award-winning films, along with the total number of awards.

WITH ThreeAwards AS (
	SELECT s.studio_name, COUNT(a.award_id) AS award_count -- Displays the name of each studio and count the total number of awards associated with the studio.
	FROM Studios s
	JOIN Movie_Studios ms ON ms.studio_id = s.studio_id -- Junction table connecting Studios and Movies.
	JOIN Awards a ON a.movie_id = ms.movie_id -- Connect Awards through movie ID to associate them with studios.
	GROUP BY s.studio_name -- Group results by studio to get award totals per studio.
	)

SELECT * FROM ThreeAwards
WHERE award_count >=3; -- Filter to only include studios with at least 3 awards.

-- Optional Bonus: Sketch a brief improvement for the schema if we wanted to start tracking awards for television shows separately

-- Ans: If I had to bring an improvement for the schema to track for television shows seperately I would create another table called Award_Category and join it with Awards table with one-to-many
-- relationship, as an Award_Category can have multiple Awards but an Award can only be under one Award_Category.
-- The Award_Category table will have two values Television and Movies.
-- The Awards table will have a new column which will be a foreign key to the table. The category column will be renamed to award_name to avoid confusion about assuming it is related to the new table.
-- The new table of Award_Category and Alteration of Awards table will be as follows:

-- CREATE TABLE Award_Category (
--    award_cat_id INT PRIMARY KEY,
--    award_cat_name VARCHAR(255) );

-- INSERT INTO Award_Category (award_cat_id, award_cat_name) VALUES
-- (1, 'Movies'),
-- (2, 'Television') ;

-- CREATE TABLE Awards (
--    award_id INT PRIMARY KEY,
--    movie_id INT,
--    award_name VARCHAR(255), -- category column renamed as award_name to avoid confusion.
--    year INT,
--    award_cat_id INT, -- New Column is added to Awards table to categorize the award into television or movies.
--    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id) 
--    FOREIGN KEY (award_cat_id) REFERENCES Award_Category(award_cat_id) ); -- New foreign key added to show the join with the Award_Category table.