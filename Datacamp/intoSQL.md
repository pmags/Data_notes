---
PageTitle: introduction to sql for datascience
---

# Selecting columns
SQL, which stands for Structured Query Language, is a language for interacting with data stored in something called a relational database.

You can think of a relational database as a collection of tables. A table is just a set of rows and columns, like a spreadsheet, which represents exactly one type of entity. For example, a table might represent employees in a company or purchases made, but not both.

Each row, or record, of a table contains information about a single entity. For example, in a table representing employees, each row represents a single person. Each column, or field, of a table contains a single attribute for all rows in the table. For example, in a table representing employees, we might have a column containing first and last names for all employees.

In SQL, you can select data from a table using a SELECT statement. For example, the following query selects the name column from the people table:

```sql
SELECT name
FROM people;
```

In this query, SELECT and FROM are called keywords. In SQL, keywords are not case-sensitive. It's also good practice (but not necessary for the exercises in this course) to include a semicolon at the end of your query. This tells SQL where the end of your query is!

To select multiple columns from a table, simply separate the column names with commas!

For example, this query selects two columns, name and birthdate, from the people table:

```sql
SELECT name, birthdate
FROM people;
```
if what we want are all columns of a data base we can use the following code:

```sql
SELECT *
FROM people;
```
If you only want to return a certain number of results, you can use the LIMIT keyword to limit the number of rows returned:

``` sql
SELECT *
FROM people
LIMIT 10;
```
Often your results will include many duplicate values. If you want to select all the unique values from a column, you can use the DISTINCT keyword.

This might be useful if, for example, you're interested in knowing which languages are represented in the films table:

```sql
SELECT DISTINCT language
FROM films;
```

To count observations on a column we use the kwyword COUNT

```sql
SELECT COUNT(*)
FROM people;
```

As you've seen, COUNT(*) tells you how many rows are in a table. However, if you want to count the number of non-missing values in a particular column, you can call COUNT on just that column.

It's also common to combine COUNT with DISTINCT to count the number of distinct values in a column.

For example, this query counts the number of distinct birth dates contained in the people table:

```sql
SELECT COUNT(DISTINCT birthdate)
FROM people;
```
# Filtering rows
In SQL, the WHERE keyword allows you to filter based on both text and numeric values in a table. There are a few different comparison operators you can use:

= equal
<> not equal
< less than
> greater than
<= less than or equal to
>= greater than or equal to
For example, you can filter text records such as title. The following code returns all films with the title 'Metropolis':

```sql
SELECT title
FROM films
WHERE title = 'Metropolis';

```
Notice that the WHERE clause always comes after the FROM statement!

For example, this query gets the titles of all films which were filmed in China:

```sql
SELECT title
FROM films
WHERE country = 'China';
```
Often, you'll want to select data based on multiple conditions. You can build up your WHERE queries by combining multiple conditions with the AND keyword.

For example,

```sql
SELECT title
FROM films
WHERE release_year > 1994
AND release_year < 2000;
```

What if you want to select rows based on multiple conditions where some but not all of the conditions need to be met? For this, SQL has the OR operator.

For example, the following returns all films released in either 1994 or 2000:

```sql
SELECT title
FROM films
WHERE release_year = 1994
OR release_year = 2000;
```

When combining AND and OR, be sure to enclose the individual clauses in parentheses, like so:

```sql
SELECT title
FROM films
WHERE (release_year = 1994 OR release_year = 1995)
AND (certification = 'PG' OR certification = 'R');
```

As you've learned, you can use the following query to get titles of all films released in and between 1994 and 2000:

```sql
SELECT title
FROM films
WHERE release_year >= 1994
AND release_year <= 2000;
```
Checking for ranges like this is very common, so in SQL the BETWEEN keyword provides a useful shorthand for filtering values within a specified range. This query is equivalent to the one above:

```sql
SELECT title
FROM films
WHERE release_year
BETWEEN 1994 AND 2000;
```
It's important to remember that BETWEEN is inclusive, meaning the beginning and end values are included in the results!

```sql
SELECT name
FROM kids
WHERE age BETWEEN 2 AND 12
AND nationality = 'USA';
```
 The IN operator allows you to specify multiple values in a WHERE clause, making it easier and quicker to specify multiple OR conditions! 


```sql
SELECT name
FROM kids
WHERE age IN (2, 4, 6, 8, 10); 
```
n SQL, NULL represents a missing or unknown value. You can check for NULL values using the expression IS NULL. For example, to count the number of missing birth dates in the people table:

```sql
SELECT COUNT(*)
FROM people
WHERE birthdate IS NULL;
```
Sometimes, you'll want to filter out missing values so you only get results which are not NULL. To do this, you can use the IS NOT NULL operator.

As you've seen, the WHERE clause can be used to filter text data. However, so far you've only been able to filter by specifying the exact text you're interested in. In the real world, often you'll want to search for a pattern rather than a specific text string.

In SQL, the LIKE operator can be used in a WHERE clause to search for a pattern in a column. To accomplish this, you use something called a wildcard as a placeholder for some other values. There are two wildcards you can use with LIKE:

The % wildcard will match zero, one, or many characters in text. The _ wildcard will match a single character. 