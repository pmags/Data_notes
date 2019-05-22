# Advanced joining

2 things can complidate joining 2 dataframes:
- Missing keys
- Duplicate columns

A missing key value occurs when a row in your primary dataset contains an NA in the key column. 

If we find that the names we need are hidden as row names we can use the function  `rownames_to_column()`

When joining 2 dataframes with similar name columns but want to use different suffix, we can use the following:

```R
left_join(playsWith, plays, by = "name", suffix = c("1","2"))
``` 

TO join multiple dataframes we can use the Purr package. The job of the purrr package is to take R functions and apply them to data structures in efficient ways. It includes the function reduce() which applies a function recursively. 

```R
# To use reduce we have first to combine the datasets into a list

tables <- list(surnames, names, plays)
reduce(tables, left_join, by = "name")
```

The job of reduce() is to apply a function in an iterative fashion to many datasets. As a result, reduce() works well with all of the dplyr join functions.


