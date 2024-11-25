-- Drop the table if it exists
DROP TABLE IF EXISTS unnormalized_data;

-- Create the unnormalized table
CREATE TABLE unnormalized_data (
    CRN INT,
    ISBN VARCHAR(20),
    Title VARCHAR(255),
    Authors VARCHAR(255),
    Edition INT,
    Publisher VARCHAR(100),
    PublisherAddress TEXT,
    Pages INT,
    Year INT,
    CourseName VARCHAR(100)
);

-- Automatic import of Unnormalized1.csv. Place the file in a path accessible by the Postgres user
COPY unnormalized_data FROM '/tmp/Unnormalized1.csv' DELIMITER ',' CSV HEADER;

-- ALTERNATIVE IMPORT
-- Import the CSV file into the table (use the \COPY command)
-- Run this command in a PostgreSQL terminal:
-- \COPY unnormalized_data FROM 'Unnormalized1.csv' DELIMITER ',' CSV HEADER;

-- Drop existing normalized tables if they exist
DROP TABLE IF EXISTS book_authors;
DROP TABLE IF EXISTS course_books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS publishers;
DROP TABLE IF EXISTS courses;


-- Create the authors table
CREATE TABLE authors (
    AuthorID SERIAL PRIMARY KEY,
    AuthorName VARCHAR(100) UNIQUE
);

-- Create the publishers table
CREATE TABLE publishers (
    PublisherID SERIAL PRIMARY KEY,
    PublisherName VARCHAR(100),
    PublisherAddress TEXT
);

-- Create the books table
CREATE TABLE books (
    ISBN VARCHAR(20) PRIMARY KEY,
    Title VARCHAR(255),
    Edition INT,
    PublisherID INT,
    Pages INT,
    Year INT,
    FOREIGN KEY (PublisherID) REFERENCES publishers(PublisherID)
);

-- Create the book_authors table
CREATE TABLE book_authors (
    ISBN VARCHAR(20),
    AuthorID INT,
    PRIMARY KEY (ISBN, AuthorID),
    FOREIGN KEY (ISBN) REFERENCES books(ISBN),
    FOREIGN KEY (AuthorID) REFERENCES authors(AuthorID)
);

-- Create the courses table
CREATE TABLE courses (
    CRN INT PRIMARY KEY,
    CourseName VARCHAR(100)
);

-- Create the course_books table
CREATE TABLE course_books (
    CRN INT,
    ISBN VARCHAR(20),
    PRIMARY KEY (CRN, ISBN),
    FOREIGN KEY (CRN) REFERENCES courses(CRN),
    FOREIGN KEY (ISBN) REFERENCES books(ISBN)
);

-- Populate the authors table
INSERT INTO authors (AuthorName)
SELECT DISTINCT UNNEST(STRING_TO_ARRAY(Authors, ', ')) AS AuthorName
FROM unnormalized_data;

-- Populate the publishers table
INSERT INTO publishers (PublisherName, PublisherAddress)
SELECT DISTINCT Publisher, PublisherAddress FROM unnormalized_data;

-- Populate the books table
INSERT INTO books (ISBN, Title, Edition, PublisherID, Pages, Year)
SELECT DISTINCT ISBN, Title, Edition, p.PublisherID, Pages, Year
FROM unnormalized_data u
JOIN publishers p ON u.Publisher = p.PublisherName;

-- Populate the book_authors table
INSERT INTO book_authors (ISBN, AuthorID)
SELECT DISTINCT u.ISBN, a.AuthorID
FROM unnormalized_data u
JOIN authors a ON POSITION(a.AuthorName IN u.Authors) > 0;

-- Populate the courses table
INSERT INTO courses (CRN, CourseName)
SELECT DISTINCT CRN, CourseName FROM unnormalized_data;

-- Populate the course_books table
INSERT INTO course_books (CRN, ISBN)
SELECT DISTINCT CRN, ISBN
FROM unnormalized_data;
