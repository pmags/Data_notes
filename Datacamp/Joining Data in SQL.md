---
Title: Joining Data in SQL
---

# Chapter 1: introduction to joins

In this chapter we will learn about the inner join which along with left join are probably the two most common joins.

With inner joins we look for matches in the right table corresponding to all entries in the key field in the left table.

Code to make a inner join

```sql
SELECT p1.country, p1.continent, prime_minister, president
FROM prime_ministers AS p1
INNER JOIN presidents AS p2
ON p1.country = p2.contry;
```

```sql
SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id;
```
Instead of writing the full table name, you can use table aliasing as a shortcut. For tables you also use AS to add the alias immediately after the table name with a space. Check out the aliasing of cities and countries below.

```sql
SELECT c1.name AS city, c2.name AS country
FROM cities AS c1
INNER JOIN countries AS c2
ON c1.country_code = c2.code;
```

Notice that to select a field in your query that appears in multiple tables, you'll need to identify which table/table alias you're referring to by using a . in your SELECT statement.

Another example

```sql
-- 3. Select fields with aliases
SELECT c.code AS country_code, name, year, inflation_rate
FROM countries AS c
  -- 1. Join to economies (alias e)
  INNER JOIN economies AS e
    -- 2. Match on code
    ON c.code = e.code;
```

The ability to combine multiple joins in a single query is a powerful feature of SQL, e.g:

```sql
SELECT *
FROM left_table
  INNER JOIN right_table
    ON left_table.id = right_table.id
  INNER JOIN another_table
    ON left_table.id = another_table.id;
```
As you can see here it becomes tedious to continually write long table names in joins. This is when it becomes useful to alias each table using the first letter of its name (e.g. countries AS c)! It is standard practice to alias in this way.

```sql
-- 6. Select fields
SELECT c.code, name, region, e.year, fertility_rate, unemployment_rate
  -- 1. From countries (alias as c)
  FROM countries AS c
  -- 2. Join to populations (as p)
  INNER JOIN populations AS p
    -- 3. Match on country code
    ON c.code = p.country_code
  -- 4. Join to economies (as e)
  INNER JOIN economies AS e
    -- 5. Match on country code and year
    ON c.code = e.code AND e.year = p.year;
```

When the key fiel you'd like to join on is the same name in both tables we can use a **USING** clause instead of **ON** clause.

```sql
SELECT *
FROM countries
  INNER JOIN economies
    USING(code)
```

example 

```sql
-- 4. Select fields
SELECT c.name AS country, continent, l.name AS language, official
  -- 1. From countries (alias as c)
  FROM countries AS c
  -- 2. Join to languages (as l)
  INNER JOIN languages AS l
    -- 3. Match using code
    USING(code) 
```

**Self-joins** are used to compare values in a field to other values of the same field from within the same table.

The following will calculate a variation by using the self join concept:

```sql
SELECT p1.country_code,
       p1.size AS size2010, 
       p2.size AS size2015,
       -- 1. calculate growth_perc
       ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
-- 2. From populations (alias as p1)
FROM populations AS p1
  -- 3. Join to itself (alias as p2)
  INNER JOIN populations AS p2
    -- 4. Match on country code
    ON p1.country_code = p2.country_code
        -- 5. and year (with calculation)
        AND p1.year = p2.year - 5;
```
Often it's useful to look at a numerical field not as raw data, but instead as being in different categories or groups.

You can use CASE with WHEN, THEN, ELSE, and END to define a new grouping field.

```sql
SELECT name, continent, code, surface_area,
    -- 1. First case
    CASE WHEN surface_area > 2000000 THEN 'large'
        -- 2. Second case
        WHEN surface_area > 350000  THEN 'medium'
        -- 3. Else clause + end
        ELSE 'small' END
        -- 4. Alias name
        AS geosize_group
-- 5. From table
FROM countries;
```

```sql
SELECT country_code, size,
  CASE WHEN size > 50000000
            THEN 'large'
       WHEN size > 1000000
            THEN 'medium'
       ELSE 's mall' END
       AS popsize_group
INTO pop_plus       
FROM populations
WHERE year = 2015;

-- 5. Select fields
SELECT name, continent, geosize_group, popsize_group
-- 1. From countries_plus (alias as c)
FROM countries_plus AS c
  -- 2. Join to pop_plus (alias as p)
  INNER JOIN pop_plus AS p
    -- 3. Match on country code
    ON c.code = p.country_code
-- 4. Order the table    
ORDER BY geosize_group;
```

# Chapter 2: Outer joins and cross joins

**OUTER JOINS** reach out to another table while keeping all of the records of the original table.

The syntax of a left join is similar to the INNER JOIN

```sql
SELECT p1.country, prime_minister, president
FROM prime_ministers AS p1
LEFT JOIN presidents AS p2
ON p1.country = p2.country;
```

```sql
SELECT c1.name AS city, code, c2.name AS country,
       region, city_proper_pop
FROM cities AS c1
  -- 1. Join right table (with alias)
  LEFT JOIN countries AS c2
    -- 2. Match on country code
    ON c1.country_code = c2.code
-- 3. Order by descending country code
ORDER BY code DESC;
```

The following code calculates the average gdp per region

```sql
-- Select fields
SELECT region, AVG(gdp_percapita) AS avg_gdp
-- From countries (alias as c)
FROM countries AS c
  -- Left join with economies (alias as e)
  LEFT JOIN economies AS e
    -- Match on code fields
    ON c.code = e.code
-- Focus on 2010
WHERE year = 2010
-- Group by region
GROUP BY region;
```

```sql
-- Select fields
SELECT region, AVG(gdp_percapita) AS avg_gdp
-- From countries (alias as c)
FROM countries AS c
  -- Left join with economies (alias as e)
  LEFT JOIN economies AS e
    -- Match on code fields
    ON c.code = e.code
-- Focus on 2010
WHERE year = 2010
-- Group by region
GROUP BY region
-- Order by descending avg_gdp
ORDER BY avg_gdp DESC;
```

The **FULL JOIN** brings together both values from right and left tables and keeps track of the missing values.

**CROSS JOINS** create all possible combinations of two tables. (eg: equivalent to expand.grid when using R).

```sql
-- Select fields
SELECT c.name AS country, region, life_expectancy AS life_exp
-- From countries (alias as c)
FROM countries AS c
  -- Join to populations (alias as p)
  LEFT JOIN populations AS p
    -- Match on country code
    ON c.code = p.country_code
-- Focus on 2010
WHERE year = 2010
-- Order by life_exp
ORDER BY life_exp
-- Limit to 5 records
LIMIT 5
```
# Set theory clauses

In this chapter we will focus on UNION and UNION ALL.

- UNION includes every record in both tables but not double,
- UNION ALL includes avery record in both tables and does replicate thos that are in both tables.
- INTERSECT results in only those records found in both the 2 tables.
- EXCEPT results in only those records in one table but not the other
  
UNION and UNION ALL do not lookup like join. They simply stack up records on top of each other from one table to the next.

```sql
-- Select fields from 2010 table
SELECT *
  -- From 2010 table
  FROM economies2010
	-- Set theory clause
	UNION ALL
-- Select fields from 2015 table
SELECT *
  -- From 2015 table
  FROM  economies2015
-- Order by code and year
ORDER BY code, year;
```

SEMI JOIN & ANTI-JOIN use the right table to determine which records to keep in the left table.

An example of a semi join (in this case it uses query that returns all the countries which were independent before 1800 as a filter for the column)

```sql
SELECT president, country, continent
FROM presidents
WHERE country IN
  (
    SELECT name
    FROM states
    WHERE indep_year < 1800
  );
```
The semi-join chooses records in the first table where a condition is met in a second table. An anti-join chooses records in the first table where a condition is not met in the second table.

```sql
-- Select distinct fields
SELECT DISTINCT (name)
  -- From languages
  FROM languages
-- Where in statement
WHERE code IN
  -- Subquery
  (SELECT code
   FROM countries
   WHERE region = 'Middle East')
-- Order by name
ORDER BY name;
```

# Subqueries

The most common type of subquery is one inside of a WHERE statement.

```sql
-- Select fields
SELECT *
  -- From populations
  FROM populations
-- Where life_expectancy is greater than
WHERE life_expectancy > 1.15 *(
  -- 1.15 * subquery
  SELECT AVG(life_expectancy)
   FROM populations
   WHERE year = 2015)
  AND year = 2015;
```

Get the urban population of only urban areas

```sql
-- 2. Select fields
SELECT name, country_code, urbanarea_pop
  -- 3. From cities
  FROM cities
-- 4. Where city name in the field of capital cities
WHERE name IN
  -- 1. Subquery
  (SELECT capital
   FROM countries)
ORDER BY urbanarea_pop DESC;
```
The following queries are identical but follow a different approaches

```sql
/*SELECT countries.name AS country, COUNT(*) AS cities_num
  FROM cities
    INNER JOIN countries
    ON countries.code = cities.country_code
GROUP BY country
ORDER BY cities_num DESC, country
LIMIT 9;*/


SELECT countries.name AS country,
  (SELECT COUNT(*)
   FROM cities
   WHERE countries.code = cities.country_code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;
```

Example of using subqueries inside FROM

```sql
-- Select fields
SELECT local_name, subquery.lang_num
  -- From countries
  FROM countries,
  	-- Subquery (alias as subquery)
  	(-- Select fields (with aliases)
SELECT code, COUNT(code) AS lang_num
  -- From languages
  FROM languages
-- Group by code
GROUP BY code) AS subquery
  -- Where codes match
  WHERE countries.code = subquery.code
-- Order by descending number of languages
ORDER BY lang_num DESC;
```

```sql
-- Select fields
SELECT economies.code, inflation_rate, unemployment_rate
  -- From economies
  FROM economies
  -- Where year is 2015 and code is not in
  WHERE year = 2015 AND economies.code NOT IN
  	-- Subquery
  	(SELECT code
  	 FROM countries
  	 WHERE (gov_form = 'Constitutional Monarchy'OR gov_form LIKE '%Republic%'))
-- Order by inflation rate
ORDER BY inflation_rate;
```

```sql
-- Select fields
SELECT name, country_code, city_proper_pop, metroarea_pop,  
      -- Calculate city_perc
      city_proper_pop/ metroarea_pop * 100 AS city_perc
  -- From appropriate table
  FROM cities
  -- Where 
  WHERE name IN
    -- Subquery
    (SELECT capital
     FROM countries
     WHERE (continent = 'Europe'
        OR continent LIKE '%America'))
       AND metroarea_pop IS NOT NULL
-- Order appropriately
ORDER BY city_perc DESC
-- Limit amount
LIMIT 10;

```