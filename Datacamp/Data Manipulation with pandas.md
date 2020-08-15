---
PageTitle: Data Manipulation with pandas
---

# Data Manipulation with pandas
## Ch1: Transforming Data

Pandas is built on top on **Numpy** and **Matplotlib**. There are many ways to store data, but rectangular data, also known as "tabular data" is the most common form. In pandas this is represented as a **Dataframe object**

```python
    dataframe.head() # returns the first rows
    dataframe.info() # returns info on the data frame similar to R.str
    dataframe.shape # returns the number of rows and columns
    dataframe.describe() # computes summary metrics

# Dataframes are composed of several elements
    dataframe.values # returns a numpy array of values
    dataframe.columns # returns an array of columns names
    dataframe.index # returns an index object 
```

In order to sort the order of the rows we can use `database.sort_values("column_name", ascending = FALSE)`. If we pass a list of column names, then we can sort by multiple columns like this `database.sort_value(["column1", "column2"])`.

To zoom in on only one column we do `database["column_name"]`. To do it for more than one column we need to pass a list into subsetting like this `database[["column1", "column2"]]`.

if you want to filter on multiple values of a categorical variable, the easiest way is to use the `isin` method like `database[database["column"].isin(["Black", "Brown"])]`

When working with data, you may not need all of the variables in your dataset. Square-brackets ([]) can be used to select only the columns that matter to you in an order that makes sense to you.

A large part of data science is about finding which bits of your dataset are interesting. One of the simplest techniques for this is to find a subset of rows that match some criteria. This is sometimes known as filtering rows or selecting rows.

There are many ways to subset a DataFrame, perhaps the most common is to use relational operators to return True or False for each row, then pass that inside square brackets.

You can filter for multiple conditions at once by using the "logical and" operator, &.

```python
dogs[(dogs["height_cm"] > 60) & (dogs["col_b"] == "tan")]
```


## Ch2: Aggregating Data

## Ch3: Slicing and indexing

## Ch4: Creating and Visualizing DataFrames