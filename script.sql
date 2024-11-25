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

