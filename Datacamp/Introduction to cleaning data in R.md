---
PageTitle: Introduction to cleaning data in R
---
# Introduction to cleaning data in R
Every data analisys is composed normaly by this 4 steps:
1. Collect data
2. Clean data
3. Analyse data
4. Report data

In fact, most time of a data scientist is devoted to the first 2 steps.
Exploring raw data includes:
- Understand the structure of the data
- Look at the data
- Visualize the data

The following functions are useful to better understand the data:

- `class()` - gives you the class of an object
- `dim()` - gives you the dimensions of a data.frame, this means, the number of rows and columns
- `names()` - gives you the colnames
- `summary()` - when applied to a data.frame it gives a summary of each variable/column
- `head()` - shows the firs 6 rows of a dataframe
- `tail()` - shows the last 6 rows of a dataframe
- `hist()` - view histogram of a single variable (base R)
- `plot()` - view the plot of two variables (base R)

A histogram, created with `hist()` fuction, takes a vector of data, breaks it up into intervals, then plots as a vertical bar the numbers of instances within each interval. A `scatterplot`, created with the `plot()` function, takes two vectores(columns) of data and plots them as a series of `(x,y)` coordinates on a two dimensial plane.

On a **tidydata** environment, rows represent observations, columns are variables and only one type of observational unit per table.

`tidyr` package applies the principles of `tidydata`.

`gather(data,key,value,...)` - it gathers information into a smaller dataframe. `data` as the data.frame and `key` the bare name of columns containing keys. Is the contrary of `spread(data,key,value,...)`

`separate(data,col,into)` example `separate(treatments, year_mo, c("year","month")` separates the column "year_mon" into columns "year" and "month". With the argument `sep = ""` we can specify the separator. The contrary would be the function `unite(data,col,...)`

**Ludibrate package:**

- `ymd()` - converts values to dates specifing year, month and day
- `ymd_hms()` - the same but adds hours, minutes and seconds

**stringr package:**
- `str_trim()` - eliminates blanks between characters in a string 
- `str_pad("24493", width=7,side="left",pad="0")` - it tells that the string has 7 characters and if it doesn't hads 0.
- `str_detect(friends,"Alice")` - result is a boolean vector of TRUE or FALSE if vector `friends` contains `Alice`
- `str_replace(friends, "Alice", "David")` - substitues `Alice` for `David` on the friends vector.
- `tolower()` - raise all lowercases
- `toupper()` - raise all uppercase

**Fiding missing values:**
- `is.na()` - vector of TRUE/FALSE if value is n.a.
- `any(is.na())` - TRUE if there is any n.a. on vector 
- `sum(is.na())` - Total number of n.a. on a database
- `na.omit()` - erases all rows with n.a. of a database

Code example that converst various columns into class `numeric`

```R
weather6 <- mutate_each(weather5, funs(as.numeric),cloud_cover:windDegrees) 
#Add tranformed variables to a data frame (NSE) 
```
_Convention: Because the period `(.)` has special meaning in certain situations we generally recommend using underscores `(_)` to separate words in variable names. We also prefer all lower case letters so taht no one has to remember whihc letters are upper case of lower case._
