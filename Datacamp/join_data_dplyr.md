---
Title: Joining Data in R using Dplyr
---

# Mutating joins

*Benfits of dplyr join functions*
- Always preserve row order
- Intuitive syntax
- Can be applied to databases, spark, etc

At a very basic level a join combines two datasets by adding the columns of one dataste alongside the columns of the other. In order to join to operate it needs a pair of keys. A key is a column or combination of columns that occurs in each of he tables that we want to join.

Dplyr completes the join by matching rows that have the same values of the key. The key in the first table is called a *primary key* because dplyr treats the first table as your primary table. 

When the key appears in the second table it is called a secondary key or a foreign key. 

The primary key should uniquely identify each row in the first dataset. In contrast the foreign key only has to correspond with the primary key. It is acceptable for a value to be duplicated, or to even not apprear at all, in the foreign key. 

**The basic join function in dplyr is a*left join*.** You can use it whenever you wnat to augment a data frame with information from another data frame. 

When using left_join we first pass the name of the dataframe we want to augment, the primary table. 


Left joins and right joins are half of a class of joins called mutating joins. Like mutate, the mutating joins return a copy of the primary dataset that has had one or more columns added to it from the secondary dataset. The mutating joins differ from each other with respect to which values and rows they return in the final result. 

*Inner join* returns only the rows from the first dataset that have a match in the second dataset. *full join* returns every row in either dataset.

# Filtering joins and set operations

Like mutating joins, filtering joins take two dataframes and the name of a column or columns to join on. Unlike mutating joins, filtering joins retunr a copy of the primary data frame that has been filtered, not augmented.

If we apply semi_join we get a copy of names that has been filtered to just the rows that have a match in plays. 

Example of two similar  output using semi_join and regular dplyr

```R
# View the output of semi_join()
artists %>% 
  semi_join(songs, by = c("first", "last"))

# Create the same result
artists %>% 
  right_join(songs, by = c("first", "last")) %>% 
  filter(!is.na(instrument)) %>% 
  select(first, last, instrument)
```

**Anti joins** do the opposite of semi joins: they show which rows in the primary data frame do not have matches in the secondary data frame. 

When two datasets contain the exact same variables, it can be helpful to combine them with set operations like union or intersection. `union()` will return every row that appears in one or more of the datasets. If a row appears multiple times, union will oinly return it once. `intersect()` will return only the rows that appear in both datasets. `setdiff()  will retunr the rows that appear in the first dataset, but not the second. There is no set operation to find rows that appear in one data frame or another, but not both. 

The following code is a work around that allows to gather not in both databases:

```R
# Select songs from live and greatest_hits
live_songs <- live %>% select(song)
greatest_songs <- greatest_hits %>% select(song)


# Find songs in at least one of live_songs and greatest_songs
all_songs <- union(live_songs, greatest_songs)

# Find songs in both 
common_songs <- intersect(live_songs,greatest_songs)

# Find songs that only exist in one dataset
setdiff(all_songs,common_songs)
```

To check if two datasets contain the exact same rows, in any order we can use `setequal()`. 

# Assembling data
Dplyr has binding functions similar to base R cbind and rbind, they are called `bind_cols()` and `bind_rows()`. `bind_rows` combines 2 datasets that contain the exact same columns in the same order into a single dataset. `bind_cols` combines 2 or more datasets that contain the same rows in the same order into a single dataset. Compared to the base R functions, this can handle a list of dataframes. 

```R
# The following code binds together a list of dataframes
jimi %>% 
  # Bind jimi by rows, with ID column "album"
  bind_rows(.id = "album") %>% 
  # Make a complete data frame
  left_join(discography, by = "album")
```

Compared to `data.frame`, `data_frame` will never do the following:

- Change the data type of vectors (eg strings to factors)
- add row names to the data frame
- change the column names
- recycle vectors greater than length one
- It works lazely and in order which means that we can refer to a new column before as the input for a new column

`as_data_frame` works to convert a list of vetors into dataframe, but if its a list of dataframes then it won't work. Nonethelesse we can use `bind_rows()` in this ocasion:

```R
# Replace the first line so each album has its own rows
bind_rows(michael, .id = "album") %>% 
  group_by(album) %>% 
  mutate(rank = min_rank(peak)) %>% 
  filter(rank == 1) %>% 
  select(-rank, -peak)
```

# Advanced joining


# Case study
The following code returns a dataframe with common variables on a list

```r
# Examine lahmanNames
lahmanNames

# Find variables in common
reduce(lahmanNames, .f = intersect)
```
The following code returns the variable by appearance:

```r
lahmanNames %>%  
  # Bind the data frames in lahmanNames
  bind_rows(.id = "dataframe") %>%
  # Group the result by var
  group_by(var) %>%
  # Tally the number of appearances
  tally() %>%
  # Filter the data
  filter(n > 1) %>% 
  # Arrange the results
  arrange(desc(n))

  lahmanNames %>% 
  # Bind the data frames
  bind_rows(.id = "dataframe") %>%
  # Filter the results
  filter(var == "playerID") %>% 
  # Extract the dataframe variable
  `$`(dataframe) #works similar to pull
```

`distinct()` returns a dataframe with all the duplicate values removed. `count()` can also be a usefull tool when used with the `vars` argument returning the number of appearances of values on a column.
