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

**Commons summary statistics:**

Summary statistics are exactly what they sound like - they summarize many numbers in one statistic. For example, mean, median, minimum, maximum, and standard deviation are summary statistics. Calculating summary statistics allows you to get a better sense of your data, even if there's a lot of it. 

```python
dataframe["column"].mean() #returns the mean value for this column
dataframe["column"].median() #returns the demidan value for this column
dataframe["column"].mode() #returns the mode value for this column
dataframe["column"].min() #returns the min value for this column
dataframe["column"].max() #returns the max value for this column
dataframe["column"].var() #returns the max value for this column
dataframe["column"].std() #returns the max value for this column
dataframe["column"].sum() #returns the max value for this column
dataframe["column"].quantile() #returns the max value for this column
```
While pandas and NumPy have tons of functions, sometimes you may need a different function to summarize your data.

The .agg() method allows you to apply your own custom functions to a DataFrame, as well as apply functions to more than one column of a DataFrame at once, making your aggregations super efficient.

In the custom function for this exercise, "IQR" is short for inter-quartile range, which is the 75th percentile minus the 25th percentile. It's an alternative to standard deviation that is helpful if your data contains outliers.

```python
# creates a function which returns the 30% percentile
def pct30(column)
    return column.percentile(0.3)

# We can use this function over a given column using args
dataframe["column"].agg(pct30)

# It can be called on a list of columns too
dataframe[["column1","column2"]].agg(pct30)
```
```python
# Pandas has methods for comulative statistics:
dataframe["column"].cumsum
dataframe["column"].cummax
dataframe["column"].cumprod 
```

```python
# We can drop duplicates using the following code:

unique = dataframe.drop_duplicates(subset=["columname1", "columnname2"]) 

# Drop duplicate store/type combinations
store_types = sales.drop_duplicates(subset = ["store","type"])
print(store_types.head())

# Drop duplicate store/department combinations
store_depts = sales.drop_duplicates(subset = ["store","department"])
print(store_depts.head())

# Subset the rows that are holiday weeks and drop duplicate dates
holiday_dates = sales[sales["is_holiday"]== True].drop_duplicates(subset ="date")

# Print date col of holiday_dates
print(holiday_dates["date"])

```

```py
# to count we use the following code
# The normalize argument can be used to turn counts into proportions
dataframe["columnname"].value_counts(sort = True, normalize = True)
```
We can use `groupby` method to aggregate different summary statistics about a dataframe.

```py
# Calculates the mean by group  column
dataframe.groupby("groupcolumn")["selectcolumn"].mean()
```

While .groupby() is useful, you can calculate grouped summary statistics without it. 

```py
# From previous step
sales_by_type = sales.groupby("type")["weekly_sales"].sum()

# Group by type and is_holiday; calc total weekly sales
sales_by_type_is_holiday = sales.groupby(["type","is_holiday"])["weekly_sales"].sum()
print(sales_by_type_is_holiday)
```

Instead of a groups table we can use a pivot table to generate dataframe statistics. Pivot tables are the standard way of aggregating data in spreadsheets. In pandas, pivot tables are essentially just another way of performing grouped calculations. That is, the .pivot_table() method is just an alternative to .groupby(). 

The .pivot_table() method has several useful arguments, including fill_value and margins.

- **fill_value** replaces missing values with a real value (known as imputation). 
- **margins** is a shortcut for when you pivoted by two variables, but also wanted to pivot by each of those variables separately: it gives the row and column totals of the pivot table contents.


```py
dataframe.pivot_table(values = "column", index = "column")
dataframe.pivot_table(values = "column", index="column", columns="column", fill_value = 0)
```

## Ch3: Slicing and indexing

pandas allows you to designate columns as an index. This enables cleaner code when taking subsets (as well as providing more efficient lookup under some circumstances).

```py
# Look at temperatures
print(temperatures)

# Index temperatures by city
temperatures_ind = temperatures.set_index("city")

# Look at temperatures_ind
print(temperatures_ind)

# Reset the index, keeping its contents
print(temperatures_ind.reset_index())

# Reset the index, dropping its contents
print(temperatures_ind.reset_index(drop=True))
```

The killer feature for indexes is .loc[]: a subsetting method that accepts index values. When you pass it a single argument, it will take a subset of rows.

The code for subsetting using .loc[] can be easier to read than standard square bracket subsetting, which can make your code less burdensome to maintain.

```py
# Make a list of cities to subset on
cities = ["Moscow", "Saint Petersburg"]

# Subset temperatures using square brackets
print(temperatures[temperatures["city"].isin(cities)])

# Subset temperatures_ind using .loc[]
print(temperatures_ind.loc[cities])
```
Indexes can also be made out of multiple columns, forming a multi-level index (sometimes called a hierarchical index). There is a trade-off to using these.

The benefit is that multi-level indexes make it more natural to reason about nested categorical variables. For example, in a clinical trial you might have control and treatment groups. Then each test subject belongs to one or another group, and we can say that a test subject is nested inside treatment group. Similarly, in the temperature dataset, the city is located in the country, so we can say a city is nested inside country.

The main downside is that the code for manipulating indexes is different from the code for manipulating columns, so you have to learn two syntaxes, and keep track of how your data is represented.

```py
# Index temperatures by country & city
temperatures_ind = temperatures.set_index(["country", "city"])

# List of tuples: Brazil, Rio De Janeiro & Pakistan, Lahore
rows_to_keep = [("Brazil", "Rio De Janeiro"),("Pakistan", "Lahore")]

# Subset for rows to keep
print(temperatures_ind.loc[rows_to_keep])
```

Previously, you changed the order of the rows in a DataFrame by calling .sort_values(). It's also useful to be able to sort by elements in the index. For this, you need to use .sort_index().

```py
# Sort temperatures_ind by index values
print(temperatures_ind.sort_index())

# Sort temperatures_ind by index values at the city level
print(temperatures_ind.sort_index(level="city"))

# Sort temperatures_ind by country then descending city
print(temperatures_ind.sort_index(level=["country"
,"city"], ascending = [True, False]))
```

Slicing lets you select consecutive elements of an object using first:last syntax. DataFrames can be sliced by index values, or by row/column number; we'll start with the first case. This involves slicing inside the .loc[] method.

Compared to slicing lists, there are a few things to remember.

- You can only slice an index if the index is sorted (using .sort_index()).
- To slice at the outer level, first and last can be strings.
- To slice at inner levels, first and last should be tuples.
- If you pass a single slice to .loc[], it will slice the rows.

Slicing is particularly useful for time series, since it's a common thing to want to filter for data within a date range. Add the date column to the index, then use .loc[] to perform the subsetting. The important thing to remember is to keep your dates in ISO 8601 format, that is, yyyy-mm-dd.

```py
# Use Boolean conditions to subset temperatures for rows in 2010 and 2011
temperatures_bool = temperatures[(temperatures["date"] >= "2010-01-01") & (temperatures["date"] <= "2011-12-31")]
print(temperatures_bool)

# Set date as an index
temperatures_ind = temperatures.set_index("date")

# Use .loc[] to subset temperatures_ind for rows in 2010 and 2011
print(temperatures_ind.loc["2010":"2011"])

# Use .loc[] to subset temperatures_ind for rows from Aug 2010 to Feb 2011
print(temperatures_ind.loc["2010-08":"2011-02"])
```

The most common ways to subset rows are the ways we've previously discussed: using a Boolean condition, or by index labels. However, it is also occasionally useful to pass row numbers.

This is done using .iloc[], and like .loc[], it can take two arguments to let you subset by rows and columns.

```py
# Get 23rd row, 2nd column (index 22, 1)
print(temperatures.iloc[22,1])

# Use slicing to get the first 5 rows
print(temperatures.iloc[:5])

# Use slicing to get columns 3 to 4
print(temperatures.iloc[:,2:4])

# Use slicing in both directions at once
print(temperatures.iloc[:5,2:4])
```

You can access the components of a date (year, month and day) using code of the form dataframe["column"].dt.component. For example, the month component is dataframe["column"].dt.month, and the year component is dataframe["column"].dt.year.

```py
# Add a year column to temperatures
temperatures["year"] = temperatures["date"].dt.year

# Pivot avg_temp_c by country and city vs year
temp_by_country_city_vs_year = temperatures.pivot_table(values = "avg_temp_c", index = ["country","city"], columns = "year")

# See the result
print(temp_by_country_city_vs_year)
```
Pivot tables are filled with summary statistics, but they are only a first step to finding something insightful. Often you'll need to perform further calculations on them. A common thing to do is to find the rows or columns where a highest or lowest value occurs. 

```py
# Get the worldwide mean temp by year
mean_temp_by_year = temp_by_country_city_vs_year.mean()

# Filter for the year that had the highest mean temp
print(mean_temp_by_year[mean_temp_by_year == mean_temp_by_year.max()])

# Get the mean temp by city
mean_temp_by_city = temp_by_country_city_vs_year.mean(axis = "columns")

# Filter for the city that had the lowest mean temp
print(mean_temp_by_city[mean_temp_by_city == mean_temp_by_city.min()])
```

## Ch4: Creating and Visualizing DataFrames

```py
# Import matplotlib.pyplot with alias plt
import matplotlib.pyplot as plt

# Look at the first few rows of data
print(avocados.head())

# Get the total number of avocados sold of each size
nb_sold_by_size = avocados.groupby("size")["nb_sold"].sum()

# Create a bar plot of the number of avocados sold by size
nb_sold_by_size.plot(kind="bar")

# Show the plot
plt.show()
```

Line plots are designed to visualize the relationship between two numeric variables, where each data values is connected to the next one. They are especially useful for visualizing change in a number over time, since each time point is naturally connected to the next time point. In this exercise, you'll visualize the change in avocado sales over three years.

```py
# Import matplotlib.pyplot with alias plt
import matplotlib.pyplot as plt

# Get the total number of avocados sold on each date
nb_sold_by_date = avocados.groupby("date")["nb_sold"].sum()

# Create a line plot of the number of avocados sold by date
nb_sold_by_date.plot()

# Show the plot
plt.show()
```

```py
# Scatter plot of nb_sold vs avg_price with title
avocados.plot(x = "nb_sold", y = "avg_price", title = "Number of avocados sold vs. average price", kind = "scatter")

# Show the plot
plt.show()
```

```py
# Modify bins to 20
avocados[avocados["type"] == "conventional"]["avg_price"].hist(alpha=0.5, bins = 20)

# Modify bins to 20
avocados[avocados["type"] == "organic"]["avg_price"].hist(alpha=0.5, bins= 20)

# Add a legend
plt.legend(["conventional", "organic"])

# Show the plot
plt.show()
```

Missing values are everywhere, and you don't want them interfering with your work. Some functions ignore missing data by default, but that's not always the behavior you might want. Some functions can't handle missing values at all, so these values need to be taken care of before you can use them. If you don't know where your missing values are, or if they exist, you could make mistakes in your analysis

`dataframe.isna()` returns if is not a NA and `dataframe.isna().any()` returns per column. 

```py

# Import matplotlib.pyplot with alias plt
import matplotlib.pyplot as plt

# Check individual values for missing values
print(avocados_2016.isna())

# Check each column for missing values
print(avocados_2016.isna().any())

# Bar plot of missing values by variable
avocados_2016.isna().sum().plot(kind = "bar")

# Show plot
plt.show()

# removes na
avocados_complete = avocados_2016.dropna()
```

Another way of handling missing values is to replace them all with the same value. For numerical variables, one option is to replace values with 0—you'll do this here. However, when you replace missing values, you make assumptions about what a missing value means. In this case, you will assume that a missing number sold means that no sales for that avocado type were made that week. 

```py
# From previous step
cols_with_missing = ["small_sold", "large_sold", "xl_sold"]
avocados_2016[cols_with_missing].hist()
plt.show()

# Fill in missing values with 0
avocados_filled = avocados_2016.fillna(0)

# Create histograms of the filled columns
avocados_filled[cols_with_missing].hist()

# Show the plot
plt.show()
```


```py
# Code to import a csv file into pandas
new_dos = pd.read_csv("path to csv")

# to experot to csv
new_dogs.to_csv("path to export")
```

