# This is just a simulated R script used for datacamp projects trainning

## Support:
# ggplot cheat sheet
# https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
# https://rpubs.com/jonathan-keith/365148
# https://github.com/vdbcyril/kaggle-datascience-survey-r/blob/master/kaggle-datascience-survey-r.ipynb

## --- Task 1
# Loading necessary packages
library(tidyverse)

# Loading the data
responses <- read_csv("Datacamp/Kaggle project/datasets/kagglesurvey.csv")

# Printing the first 10 rows
head(responses,10)


## --- Task 2
# Printing the first respondents' tools and languages
responses[1,2]

# Creating a new data frame called tools
tools <- responses

# Adding a new column to tools which splits the WorkToolsSelect column at the commas and unnests the new column
tools <- tools  %>% 
    mutate(work_tools = strsplit(WorkToolsSelect,",")) %>%
        unnest(work_tools)

# Viewing the first 6 rows of tools
head(tools,6)

# unnest() - If you have a list - column, this makes each element of the list its own row.

# After looking at the first respondent's tool-use, 
#you'll see that this survey-taker listed multiple tools which are each 
# separated by a comma. To learn how many people use each tool, 
# we need to separate out all of the tools used by each individual. 
# There are several ways to complete this task, but we recommend using the base 
# R function strsplit() to separate the tools at each comma. Since that will 
# leave you with a list inside of your data frame, we can use the tidyr function unnest() 
# to separate each list item into a new row. 

## --- Task 3
# Creating a new data frame
tool_count <- tools

# Grouping the data by work_tools, calculate the number of responses in each group
tool_count <- tool_count  %>% 
    group_by(work_tools)  %>% 
    summarise(tool_distinct = n())

# dplyr::n() gives you the number of observations in the current group Similiar to use count on a group.
# It can only be used inside mutate() or summarise()

# Sorting tool_count so that the most popular tools are at the top
tool_count <- arrange(tool_count,desc(tool_distinct))
# Printing the first 6 results
head(tool_count,6)

## --- Task 4
# Creating a bar chart of the work_tools column. 
# Arranging the bars so that the tallest are on the far right
ggplot(tool_count,aes(x = work_tools, y = tool_distinct)) + 
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 90))

# Rotating the bar labels 90 degrees