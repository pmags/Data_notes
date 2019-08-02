---
PageTitle: Introduction to Relational Databases in SQL
---

# Chapter 1: Intro to relational databases

A database models real-life entities by storing them in tables. Each table only contain data from a single entity type. This reduces redundancy by storing entities only once.

A database can be used to model relationships between entities.

"information_schema" is actually some sort of meta-database that holds information about your current database.

information_schema is a meta-database that holds information about your current database. information_schema has multiple tables you can query with the known SELECT * FROM syntax:

    - tables: information about all tables in your current database
    
    - columns: information about all columns in all of the tables in your current database 

```sql
-- Query the first five rows of our table
SELECT *
FROM university_professors 
LIMIT 5;
```

The following code creates new tables for a database:

```sql
CREATE TABLE table_name (
 column_a data_type,
 column_b data_type,
 column_c data_type
);
```
Table and columns names, as well as datatypes, don't need to be surrounded by quotation marks.

```sql
-- Create a table for the professors entity type
CREATE TABLE professors (
 firstname text,
 lastname text
);

-- Print the contents of this table
SELECT * 
FROM professors
```

To add columns you can use the following SQL query:

```sql
ALTER TABLE table_name
ADD COLUMN column_name data_type;
```

In order to copy data from an existing table to a new one, you can use the "INSERT INTO SELECT DISTINCT" pattern.

```sql
INSERT INTO organizations 
SELECT DISTINCT organization, 
    organization_sector
FROM university_professors;
```

If we want to insert manually we would follow the pattern below:

```sql
INSERT INTO table_name (column_a, column_b)
VALUES ("value_a", "value_b");
```

ou'll use the following queries:

    To rename columns:

```sql
ALTER TABLE table_name
RENAME COLUMN old_name TO new_name;

```
    To delete columns:

```sql
ALTER TABLE table_name
DROP COLUMN column_name;
```

In order to delete a table we can use the following code:

```sql
DROP TABLE table_name;
```

# Chapter 2: Enforce data consistency with attribute constraints

Integrity constrains can be divided into 3 types:

1. Attribute constrains
2. Key constrains
3. Referencial integrity constrains

Constrains give the data structure and insure data quality.

If you know that a certain column stores numbers as text, you can cast the column to a numeric form, i.e. to integer.

```sql
SELECT CAST(some_column AS integer)
FROM table;
```
To alter types after column creation we use the code below:

```sql
ALTER TABLE students
ALTER COLUMN name 
TYPE varchar(128);
```
The syntax for changing the data type of a column is straightforward. The following code changes the data type of the column_name column in table_name to varchar(10): 

```sql
ALTER TABLE table_name
ALTER COLUMN column_name
TYPE varchar(10)
```

If you don't want to reserve too much space for a certain varchar column, you can truncate the values before converting its type.

For this, you can use the following syntax:

```sql
ALTER TABLE table_name
ALTER COLUMN column_name
TYPE varchar(x)
USING SUBSTRING(column_name FROM 1 FOR x)
```
**The not-null constrain**

As the name says, the not-null constraint disallows any "NULL" values on a given column. This must hold true for the current state and for any future state.

The following code adds a not-null constrain to existing table:

```sql
ALTER TABLE students
ALTER COLUMN home_phone
SET NOT NULL;
```

**The unique constrain**
Disallow duplicate values in a column.

We can create columns with unique constrains with the following code:

```sql
CREATE TABLE table_name(
    column_name UNIQUE
);
```
We can add that constrain after using the following:

```sql
ALTER TABLE table_name
ADD CONSTRAINT some_name UNIQUE(column_name);
```
# Uniquely identify records with key constraints

In the entity-relationship diagram keys are denoted by underlined attribute names.

A key is an attribute or combination of attributes that uniquely identify a record. As long as attributes can be removed we can call it a _superkey_. If one or more attributes can be removed than is called a _minimal key or key_.

There's a simple way of finding out whether a certain column (or a combination) contains only unique values – and thus identifies the records in the table.

You already know the SELECT DISTINCT query from the first chapter. Now you just have to wrap everything within the COUNT() function and PostgreSQL will return the number of unique rows for the given columns:

```sql
SELECT COUNT(DISTINCT(column_a, column_b, ...))
FROM table;
```

There's a very basic way of finding out what qualifies for a key in an existing, populated table:

1. Count the distinct records for all possible combinations of columns. If the resulting number x equals the number of all rows in the table for a combination, you have discovered a superkey.

2. Then remove one column after another until you can no longer remove columns without seeing the number x decrease. If that is the case, you have discovered a (candidate) key.

Primary keys are one of the most importante concepts in database design. It should be chosen from candidate keys and the main purpose is to uniquely identify records in a table. They must be unique an not null and are time invariant.

The following code specify a primary once upon creation:

```sql
CREATE TABLE products (
    product_no integer PRIMARY KEY,
    name text,
    price numeric
);
```
The following will create a primary key by combining two columns:

```sql
CREATE TABLE example (
    a integer,
    b integer,
    c integer,
    PRIMARY KEY (a, c)
);
```
If a table is already created we can add primary key as any counstrain:

```sql
ALTER TABLE table_name
ADD CONSTRAINT some_name PRIMARY KEY (column_name)
```

Example

```sql
-- Rename the university_shortname column to id
ALTER TABLE universities
RENAME COLUMN university_shortname TO id;

-- Make id a primary key
ALTER TABLE universities
ADD CONSTRAINT university_pk PRIMARY KEY (id);
```

Surrogate keys are sort of an artificial primary key in the sense that they are not based on a native column from the data.

The following example creats a key by combining two columns.

```sql
ALTER TABLE table_name
ADD COLUMN column_c varchar(256);

UPDATE table_name
SET column_c = CONCAT(column_a, column_b);
```

The following code adds a serial number column

```sql
-- Add the new column to the table
ALTER TABLE professors 
ADD COLUMN id serial;

-- Make id a primary key
ALTER TABLE professors  
ADD CONSTRAINT professors_pkey PRIMARY KEY (id);

-- Have a look at the first 10 rows of professors
SELECT * FROM professors LIMIT 10;
```

```sql
-- Count the number of distinct rows with columns make, model
SELECT COUNT(DISTINCT(make, model)) 
FROM cars;

-- Add the id column
ALTER TABLE cars
ADD COLUMN id varchar(128);

-- Update id with make + model
UPDATE cars
SET id = CONCAT(make, model);

-- Make id a primary key
ALTER TABLE cars
ADD CONSTRAINT id_pk PRIMARY KEY(id);
```

# chapter 4: Glue together tables with foreign keys

A foreign key points to the primary key of another table. Domanin of FK must be equal to domain of PK. Each value of FK must exist in PK of the other table ("referential integrity").

Example of creating a table with a foreign key:

```sql
CREATE TABLE manufacturers (
 name varchar(255) PRIMARY KEY
);

INSERT INTO manufacturers 
VALUES ('Ford'), ('VW'), ('GM');
CREATE TABLE cars (
 model varchar(255) PRIMARY KEY,
 manufacturer_name integer REFERENCES manufacturers (name)
);

INSERT INTO cars 
VALUES ('Ranger', 'Ford'), ('Beetle', 'VW');
```
In order to define a single column as foreign key we use the following syntax

```sql
ALTER TABLE a 
ADD CONSTRAINT a_fkey FOREIGN KEY (b_id) REFERENCES b (id);
```
Pay attention to the naming convention employed here: Usually, a foreign key referencing another primary key with name id is named x_id, where x is the name of the referencing table in the singular form.

```sql
-- Rename the university_shortname column
ALTER TABLE professors
RENAME COLUMN university_shortname TO university_id;

-- Add a foreign key on professors referencing universities
ALTER TABLE professors 
ADD CONSTRAINT professors_fkey FOREIGN KEY (university_id) REFERENCES universities (id);
```

The following code joins 2 tables using the primary key

```sql
-- Select all professors working for universities in the city of Zurich
SELECT professors.lastname, universities.id, universities.university_city
FROM professors
JOIN universities
ON professors.university_id = universities.id
WHERE universities.university_city = 'Zurich';
```
Syntax to define a relation table from scratch

```sql
CREATE TABLE affiliations (
 professor_id integer REFERENCES professors (id),
 organization_id varchar(256) REFERENCES organization (id),
 function varchar(256)
);
```

```sql
-- Add a professor_id column
ALTER TABLE affiliations
ADD COLUMN professor_id integer REFERENCES professors (id);

-- Rename the organization column to organization_id
ALTER TABLE affiliations
RENAME organization TO organization_id;

-- Add a foreign key on organization_id
ALTER TABLE affiliations
ADD CONSTRAINT affiliations_organization_fkey FOREIGN KEY (organization_id) REFERENCES organizations (id);
```

```sql
UPDATE table_a
SET column_to_update = table_b.column_to_update_from
FROM table_b
WHERE condition1 AND condition2 AND ...;
```

```sql
-- Update professor_id to professors.id where firstname, lastname correspond to rows in professors
UPDATE affiliations
SET professor_id = professors.id
FROM professors
WHERE affiliations.firstname = professors.firstname AND affiliations.lastname = professors.lastname;
```

**Referential integrity**: states that a record referencing another record in another table must always refer to an existing record.

```sql
-- Identify the correct constraint name
SELECT constraint_name, table_name, constraint_type
FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY';

-- Drop the right foreign key constraint
ALTER TABLE affiliations
DROP CONSTRAINT affiliations_organization_id_fkey;

-- Add a new foreign key constraint from affiliations to organizations which cascades deletion
ALTER TABLE affiliations
ADD CONSTRAINT affiliations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organizations (id) ON DELETE CASCADE;

-- Delete an organization 
DELETE FROM organizations 
WHERE id = 'CUREM';

-- Check that no more affiliations with this organization exist
SELECT * FROM organizations
WHERE id = 'CUREM';
```
Using what we learnt to query a database:

```sql
-- Count the total number of affiliations per university
SELECT COUNT(*), professors.university_id 
FROM affiliations
JOIN professors
ON affiliations.professor_id = professors.id
GROUP BY professors.university_id 
ORDER BY count DESC;
```

```sql
-- Filter the table and sort it
SELECT COUNT(*), organizations.organization_sector, 
professors.id, universities.university_city
FROM affiliations
JOIN professors
ON affiliations.professor_id = professors.id
JOIN organizations
ON affiliations.organization_id = organizations.id
JOIN universities
ON professors.university_id = universities.id
WHERE organizations.organization_sector = 'Media & communication'
GROUP BY organizations.organization_sector, 
professors.id, universities.university_city
ORDER BY count DESC;
```