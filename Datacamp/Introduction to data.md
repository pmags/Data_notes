---
PageTitle: Introduction to data
---
# Introduction to data
## Chapter 1 - Language of data
On a dataframe the information is organized so that each line/row represents an observation and each column a variable.

Code example to load a package and data from inside the package:

```R
#Load package
library (openintro)

#Load data
data(hsb2)
```
The `str()` function provides the structure of the data we are going to use. Alternatively, one can use the `dplyr::glimpse()` function. Both cases return the total number of variables and observation, the name of each variable and allow to check the first values.

**Types of variables:**
* Numerical (quantitative): numerical values
    - **Continuous**: infinite number of values within a given range, often measured
    - **Discrete**: specific set of numeric values that can be counted or enumerated, often counted

* Categorical (qualitative): limited number of distinct categories. [Not good to make arithmetic calculations]
    - **Ordinal**: finite number of values within a given range, often measured [often they are treated as _factors_]

<span style =color:blue>**Categorical data is often stored as factors in R.** Important use: statistical modeling.</span>

Categorical variables are useful especially when we need to subset our data or only gather information filtered by a specific characteristic. For that we can use `table()` function in R. The following code example shows how quickly we can access data using this function:

```R
# Number of students in public and private schools in hsb2
table(hsb2$schtyp)

public  private
168     32

# Filters the database to only public
hsb2_public <- hsb2 %>%
    filter (schtyp == "public")
```
The pipe operator tells R to pass the object that comes before the operator (right side)to the function that comes after. Pipes are useful because they allow us to create sequences of data wrangling.

> From wikipedia: Data wrangling, sometimes referred to as data munging, is the process of transforming and mapping data from one "raw" data form into another format with the intent of making it more appropriate and valuable for a variety of downstream purposes such as analytics. A data wrangler is a person who performs these transformation operations.

When subsetting a data frame using factors (for example removing one of the levels) R will always leave the level as a placeholder on the data frame. This can be a problem during data visualization and therefore is advisable that this unused levels be removed. Levels can be dropped using the `droplevels()` function to overwrite the factor column. 

```R
hsb2_public$schtyp <- droplevels(hsb2_public$schtyp)
```

A common way of creating a new variable from an existing variable is discretizing, that is, converting a numerical variable to a categorical variable based on certain criteria.

> **Tip:** sometimes is useful to assign a function result to a new variable but to print the result to. To avoid the redundancy of repeating code, we can use brackets around the entire expression like: `(avg_read <- mean(hsb2$read))`

Example of using the dplyr package to create a variable on a data frame conditional to a function:

```R
# Creat a new variable: read_cat
hsb2 <- hsb2 %>%
        mutate(read_cat = ifelse(read <avg_read,
            "below average","at or above average"))
```

>The median marks the 50th percentile, or midpoint, of a distribution.

`dplyr::case_when()` function allows you to vectorise multiple `if` and `else if` statements. A sequence of two-sided formulas. The left hand side (LHS) determines which values match this case. The right hand side (RHS) provides the replacement value. The LHS must evaluate to a logical vector. The RHS does need to be logical, but all RHSs must evaluate to the same type of vector. Example of code using `dplyr::case_when()`

```R
email50_fortified <- email50 %>%
  mutate(number_yn = case_when(
    email50$number == "none" ~ "no", 
    # if number is "none", make number_yn "no"
    email50$number != "none" ~ "yes"  
    # if number is not "none", make number_yn "yes"
    )
  )
```
This code is useful to create a series of conditions over a given variable and more readable than a chain of `ifelse`.

#### Visualizing numerical data
The first step of any data analysis is an exploratory analysis is an exploratory analysis, and for this purpose, visualizing data is one of the best tools.

This course uses the ggplot2. Here is an example of a plot:

```R
#Scatterplot of math vs. science scores
ggplot(data = hsb2, aes(x = science, y = math)) + geom_point()
```
The first argument is the data frame containing the data we wish to plot. `aes` stands for the aesthetics of the plot where we say that we want the axis to be. `geom_point` represents the way we render each observation. In this case we decided we wanted it to be rendered as a point. ggplot2 plots are constructed iteratively from a series of layers, the plus sign separates this layers. [note: when we want to use a multivariable analysis we can assign variables to colors on the `aes`. Sometimes is useful to force ggplot2 to accept this variables as factors even if they are not defined as such. For this we define color parameter as follows: `color = factor(spam)`].

## Chapter 2 - Study types and cautionary tales
