-- (GQ3): Using SQL statements to create the relations for the database.
-- Dropping all the tables before we create a new one.
DROP TABLE IF EXISTS Performer;
DROP TABLE IF EXISTS Director;
DROP TABLE IF EXISTS Acted;
DROP TABLE IF EXISTS Movie;

-- Creating Performer table
CREATE TABLE Performer(
        pid INT,
        pname VARCHAR(64),
        years_of_experience INT,
        age INT,
        PRIMARY KEY (pid)
)
-- Creating Director table
CREATE TABLE Director(
    did INT,
    dname VARCHAR(64),
    earnings REAL,
    PRIMARY KEY (did)
)

-- Creating Movie table
CREATE TABLE Movie(
    mname VARCHAR(64),
    genre VARCHAR(20),
    minutes INT,
    release_year INT,
    did INT,
    PRIMARY KEY (mname),
    FOREIGN KEY (did) REFERENCES Director
)

-- Creating Acted table
CREATE TABLE Acted(
    pid INT,
    mname VARCHAR(64),
    PRIMARY KEY (pid, mname),
    FOREIGN KEY (pid) REFERENCES Performer,
    FOREIGN KEY (mname) REFERENCES Movie   
)

-- (GQ4): Populating the relations using SQL statements with the given data
-- Inserting data into Performer table
insert into Performer values 
            (1, 'Morgan', 48, 67),
            (2, 'Curz', 14, 28),
            (3, 'Adams', 1, 16),
            (4, 'Perry', 18, 32),
            (5, 'Hanks', 36, 55),
            (6, 'Hanks', 15, 24),
            (7, 'Lewis', 13, 32)

-- Inserting data into Director table
insert into Director values
            (1, 'Parker', 580000),
            (2, 'Black', 2500000),
            (3, 'Black', 30000),
            (4, 'Stone', 820000)

-- Inseting data into Movie table
insert into Movie values
    ('Jurassic Park', 'Action', 125, 1984, 2),
	  ('Shawshank Redemption', 'Drama', 105, 2001, 2),
    ('Fight Club', 'Drama', 144, 2015, 2),
    ('The Departed', 'Drama', 130, 1969, 3),
    ('Back to the Future', 'Comedy', 89, 2008, 3),
    ('The Lion King', 'Animation', 97, 1990, 1),
    ('Alien', 'Sci-Fi', 115, 2006, 3),
    ('Toy Story', 'Animation', 104, 1978, 1),
    ('Scarface', 'Drama', 124, 2003, 1),
    ('Up', 'Animation', 111, 1999, 4);

-- Inserting data into Acted table
INSERT INTO Acted (pid, mname)
VALUES
    (4, 'Fight Club'),
    (5, 'Fight Club'),
    (6, 'Shawshank Redemption'),
    (4, 'Up'),
    (5, 'Shawshank Redemption'),
    (1, 'The Departed'),
    (2, 'Fight Club'),
    (3, 'Fight Club'),
    (4, 'Alien');

-- 1. Display all the data you store in the database to verify that you have populated the relations correctly
SELECT * FROM Performer
SELECT * FROM Director
SELECT * FROM Movie
SELECT * FROM Acted

-- 2. Find the names of all Action movies
select mname from Movie where genre='Action'

-- 3. For each genre, display the genre and the average length (minutes) of movies for that genre.
select genre, avg(minutes) as 'average length (minutes)' from Movie group by genre

-- 4. Find the names of all performers with at least 20 years of experience who have acted in a movie directed by Black.
select distinct pname from Performer where years_of_experience >= 20 and pid in
					(select pid from Acted where mname in 
					(select mname from Movie where did in
					(select did from Director where dname = 'Black'))) 

-- 5. Find the age of the oldest performer who is either named “Hanks” or has acted in a movie named “The Departed”.
select max(age) as 'age (oldest performer)' from Performer where pname='Hanks' or pid in 
						(select pid from Acted where mname = 'The Departed')

-- 6. Find the names of all movies that are either a Comedy or have had more than one performer act in them
select mname from Movie where genre = 'Comedy' or mname IN 
						(select mname from Acted group by mname having count(pid) > 1)

-- 7. Find the names and pid's of all performers who have acted in at least two movies that have the same genre
select pname, pid from Performer where pid in 
						(select Acted.pid from Acted, Movie 
						 where Acted.mname = Movie.mname group by Acted.pid, Movie.genre 
						 Having count(Acted.mname) >=2)
-- 8. Decrease the earnings of all directors who directed “Up” by 10%
update Director set earnings = (earnings - (earnings * 10 / 100)) 
								where did in (
								select did from movie where mname = 'Up')
select * from Director

-- 9. Delete all movies released in the 70's and 80's (1970 <= release_year <= 1989).
DELETE FROM Acted WHERE mname IN (SELECT mname FROM Movie WHERE
					  release_year BETWEEN 1970 AND 1989)
DELETE FROM Movie WHERE release_year BETWEEN 1970 AND 1989
SELECT * FROM Acted
SELECT * FROM Movie