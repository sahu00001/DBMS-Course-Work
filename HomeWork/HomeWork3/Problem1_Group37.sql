-- (GQ3): Using SQL statements to create the relations for the database.
--Dropping all the tables before we create a new one.
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


--We opted for indexing the 'Movie' table because one of the queries filters movies by their genre. Creating an index on the 'genre' column can substantially enhance the speed and efficiency of this specific query.

-- Creating an index on the 'genre' column in the 'Movie' table
CREATE INDEX Movie_Genre ON Movie (genre);

--Through the establishment of an index on the 'genre' column, the database can swiftly fetch all movies categorized under 'Action,' resulting in a more expedient and effective query.
--This is an example of a secondary index because the movie genre is not sorted in the main file, but it's created to optimize query performance based on the genre attribute commonly used in queries.

--Now, we will rerun the query #2 (Find the names of all Action movies) to demonstrate the benefits of indexing the genre column:
-- 2. Find the names of all Action movies
select mname from Movie where genre='Action'

