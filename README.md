# Database normalization using relation model with PostgreSQL
The project defines and normalizes a relational database with PostgreSQL. The project also derives from unnormalized data using a CSV file and implements the normalization to 1NF, 2NF, and 3NF.

# Features
- Import raw data from a CSV file into the PostgreSQL database.
- Normalize data to eliminate redundancy and ensure data integrity:
    - 1NF excludes multiple values by adding another table if the attribute has multiple values.
    - 2NF reduces partial dependencies by creating a schema that splits data according to composed keys.
    - 3NF eliminates transitive dependencies by restructuring the tables.
- Tables Created
    - courses
    - books
    - authors
    - publishers
    - course_books
    - book_authors

# Setup Instructions
- Clone the repository

`git clone https://github.com/LachinHasanli/database_normalization_postgres`

`cd database_normalization_postgres`

- Save the unnormalized CSV file as Unnormalized1.csv in an accessible location, noting the full path.
- Edit the script.sql replacing the path with the correct one in this command:

`COPY unnormalized_data FROM '/tmp/Unnormalized1.csv' DELIMITER ',' CSV HEADER;`

- Execute the SQL script:

`psql -U your_username -d your_database -f normalize.sql`

- The script can also be imported into a PgAdmin SQL window after creating the database.
