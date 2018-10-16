---
PageTitle: Importing Data in R
Abstract: Note taken during the Import data in R from Datacamp
---
# Importing Data in R
`Flat files`: simple text files that present their values using tables(eg: csv, txt)

**Basic functions to import flat files**

- `read.csv("states.csv", stringsAsFactors = FALSE)` code uses the base function `read.csv()` to import a csv file into a R Working Environment. The first argument on the function refers to the file path and should always be between commas. In this example, because the file was on the root of the working directory the name is enough as a file path.  
- `read.delim("states.txt", stringsAsFactors = FALSE)` code uses the base function `read.delim()` to import a .txt file into a R Working Environment.
-  Both functions, as a standard, consider all imported tables to include a header on the first row. To disable we need to include `header = FALSE` as argument.

If we want to get a list of all files available on the working directory we can use the function `dir()` from base R.

<span style = color:red> **Note:** If not specified, all functions on base R or `utils package` will coerce characters into factors. To avoid this coercion we have to include the argument `stringAsFactors = FALSE`.</span>

As a rule, for simple flat files with data separated by commas `,` or points `.`, the functions `read.csv()` or `read.delim()` suffice. If data is separated by other arguments or multiple arguments than is advisable to use the `read.table()` function with the argument `sep = <separation>`. 

The function `read.table()` can rename each column name using the argument `col.names= <"array or vector of names">`, and classes `colclasses = ()`. This allows for data manipulation at the time of importing. If, for a given column we choose `colclasses = "NULL"` then this column/variable won't be imported.

**Define file paths**

If we wish to let our file path independent from our function or code, a easy way is to set the path as a variable as the following code

```R
path <- files.path("data","hotdog.txt")
```

`which.min()` indexes the minimum value inside a vector.

**Readr package**

This package is not included in base R so it needs to be installed:

```R
install.packages("readr")
library(readr)
```

It has all the main features of base R to import files but it allows for an easier manipulation. For example, it allows to set column types by letters `col_types = "ccdd" c= character, d= double, i= integer, l= logical`

The following table converts base R into readr functions:

| utils package | readr package |
| ------------- | ------------- |
| read.table()  | read_delim()  |
| read.csv()    | read_csv()    |
| read.delim()  | read_tsv()    |

Through `skip` and `n_max` you can control which part of your flat file you are actually importing into R.
- `skip` specifies the number of lines you are ignoring in the flat file before actually starting to import data.
- `n_max` specifies the number of lines you're actually importing

Another way of setting the types of the imported columns is using collectors. Collector functions can be passed in a `list()` to the `col_values()` argument of `read_<functions>` to tell them how to interpret values in a column.

**Data.table package**

Similar to readr the `data.table` package is not part of base R.

```R
install.packages("data.table")
library(data.table)
```

Advantages of `fread()` functions:
- it automatically generates column names
- infer column types and separators
- extremely fast
- variables can be chosen using the arguments `drop = <variables not to include>` and `select = <variables to include>` 

**readXl package**

`excel_sheets()` list different sheets on an excel file
`read_excel()` actually import data into R. By using the argument `sheet = <sheet number>` you select which sheet of the excel file you would like to import, for example `read_excel("cities.xlsx",sheet = 2)` imports sheet 2.

code example:
```R
my_worbook <-lapply(excel_sheets("data.xlsx"),read_excel, path="data.xlsx")
```

The `read_excel()` function is called multiple times in the data.xlsx file and each sheet is loaded in one after the other. The result is a list of data.frames, each data frame representing on of the sheets in data.xlsx.

code example:
```R
rea_excel(path, sheet = 1, col_names = TRUE, col_types = NULL, skip = 0)
```

If `col_names = TRUE` than the first row is considered to be the table header. When `col_types = NULL` then R will guess each column class. (columns/variables can be "text", "numeric" or "blank" if we want R to ignore this column during import).

Another argument that can be very useful when reading in excel files that are less tidy is `skip`. With skip, you can tell R to ignore a specified number of rows inside the Excel sheets you're trying to pull from data from.

**gdata package**

Is an entire suite of tools for data manipulation.

`read.xls()` it basically comes down to two steps: converting the Excel file to a `.csv` file using Perl script, and them reading that `.csv` file with `read.csv()` function that is loaded by default in R, through the utils package. This means that all the options tat you can specify in `read.csv()`, can also be specified in `read.xls()`.

`na.omit()` erases all values/rows with `NA`

**XLconnect package**

Work with excel through R by creating a bridge between Excel and R.

`book <-loadWorkbook("cities.xlsx")`
`getsheets(book)` gives the sheets name on a workbook
`readworksheet(book, sheet = "year_2000")` imports data from sheet "year_2000"
`createSheet(book, name = "year_2010")` creates sheet in workbook
`writeWorksheet(book, pop_2010, sheet = "year_2010")` imports data from `pop_2010` into an excel worksheet
`saveWorkbook(book, file = "cities2.xlsx")`
`renameSheet()` renames a workbook sheet
`removeSheet()` removes a workbook sheet

