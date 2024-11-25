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
