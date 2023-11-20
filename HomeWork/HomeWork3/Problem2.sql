--PROBLEM 2 (1) 

DROP PROCEDURE IF EXISTS Performerprocedure;
DROP PROCEDURE IF EXISTS Performerprocedure3;
GO
CREATE PROCEDURE Performerprocedure
    @pid INT,
    @pname VARCHAR(64),
    @age INT
AS
BEGIN
    -- Declare a variable to hold the calculated years_of_experience
    DECLARE @years_of_experience INT;

    -- Calculate the average years of experience for performers within the age range
    SELECT @years_of_experience = AVG(years_of_experience)
    FROM Performer
    WHERE age BETWEEN @age - 10 AND @age + 10;

    -- If there are no performers within the age range, set years_of_experience to 18 less than age
    IF @years_of_experience IS NULL
    BEGIN
        SET @years_of_experience = @age - 18;
    END

    -- Adjust years_of_experience to be at least 0 and no more than the performer's age
    IF @years_of_experience < 0
    BEGIN
        SET @years_of_experience = 0;
    END
    ELSE IF @years_of_experience > @age
    BEGIN
        SET @years_of_experience = @age;
    END

    -- Insert data into the Performer table
    INSERT INTO Performer (pid, pname, years_of_experience, age)
    VALUES (@pid, @pname, @years_of_experience, @age);
END;


--PROBLEM 2 (2) 
GO
CREATE PROCEDURE Performerprocedure3
    @pid INT,
    @pname VARCHAR(64), -- Performer name
    -- @years_of_experience INT OUTPUT, -- Output parameter for years of experience
    @age INT, -- Performer age
    @did INT OUTPUT -- Director's name (declare as OUTPUT parameter)
AS
BEGIN
    DECLARE @years_of_experience INT;
    -- Calculate the average years of experience for performers within the age range
    SELECT @years_of_experience = AVG(p.years_of_experience)
    FROM Performer p
    WHERE p.pid IN (
        SELECT DISTINCT a.pid
        FROM Acted a
        WHERE a.mname IN (
            SELECT m.mname
            FROM Movie m
            WHERE m.did = @did
        )
    );

    -- If there are no performers within the age range, set years_of_experience to 18 less than age
    IF @years_of_experience IS NULL
    BEGIN
        SET @years_of_experience = @age - 18;
    END

    -- Adjust years_of_experience to be at least 0 and no more than the performer's age
    IF @years_of_experience < 0
    BEGIN
        SET @years_of_experience = 0;
    END
    ELSE IF @years_of_experience > @age
    BEGIN
        SET @years_of_experience = @age;
    END
        -- Insert data into the Performer table
    INSERT INTO Performer (pid, pname, years_of_experience, age)
    VALUES (@pid, @pname, @years_of_experience, @age);

END;

