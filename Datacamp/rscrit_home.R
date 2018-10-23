# --- Task 1
# Loading necessary packages
library(tidyverse)

# Loading the data
responses <- read_csv("Datacamp/project/Exploring the Kaggle Data Science Survey/datasets/kagglesurvey.csv")

# Printing the first 10 rows
head(responses,10)

# --- Task 2
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

# --- Task 3
# Creating a new data frame
tool_count <- tools

# Grouping the data by work_tools, calculate the number of responses in each group
tool_count <- tool_count  %>% 
    group_by(work_tools)  %>% 
    summarise(tool_distinct = n())

# Sorting tool_count so that the most popular tools are at the top
tool_count <- arrange(tool_count,desc(tool_distinct))

# Printing the first 6 results
head(tool_count,6)

# -- Task 4
# https://stackoverflow.com/questions/25664007/reorder-bars-in-geom-bar-ggplot2
# Creating a bar chart of the work_tools column. 
# Arranging the bars so that the tallest are on the far right
ggplot(tool_count, aes(x = reorder(work_tools,
    tool_distinct), y = tool_distinct)) +

    geom_bar(stat="identity", color = "blue", fill = "white") +
    geom_text(aes(label=tool_distinct),vjuts=1.6,color = "black",size = 3.5)+
    theme_minimal()+
# Rotating the bar labels 90 degrees
    theme(axis.text.x = element_text(angle = 90))

# --- Task 5
# Creating a new data frame called debate_tools
debate_tools <- responses

# Creating a new column called language preference, based on the conditions specified in the Instructions
# https://www.rdocumentation.org/packages/dplyr/versions/0.7.3/topics/case_when
# case_when() allows to vectorise multiple if and else if statements
# https://www.rdocumentation.org/packages/base/versions/3.4.3/topics/grep
#grepl() search and matches to argument pattern within each element of a character vector



debate_tools <- debate_tools  %>% 
   mutate(language_preference = case_when(
      grepl(pattern = "R",x = WorkToolsSelect) & !grepl(pattern = "Python",x = WorkToolsSelect) ~ "R",
      !grepl(pattern = "R",x = WorkToolsSelect) & grepl(pattern = "Python",x = WorkToolsSelect) ~ "Python",
      grepl(pattern = "R",x = WorkToolsSelect) & grepl(pattern = "Python",x = WorkToolsSelect) ~ "both",
      !grepl(pattern = "R",x = WorkToolsSelect) & !grepl(pattern = "Python",x = WorkToolsSelect) ~ "neither"

   )
)

# Printing the first 6 rows
head(debate_tools,6)

# -- Task 6
# Creating a new data frame
debate_plot <- debate_tools

# Grouping by language preference and calculate number of responses
debate_plot <- debate_plot  %>% 
   group_by(language_preference)  %>% 
    summarise(number_preferences = n())  %>% 

# Removing the row for users of "neither"
    filter(language_preference != "neither")

# Creating a bar chart
ggplot(debate_plot, aes(x= language_preference,y = number_preferences))+
            geom_bar(stat="identity", color = "blue", fill = "white")

# --- Task 7
# https://dplyr.tidyverse.org/reference/arrange.html
# https://dplyr.tidyverse.org/reference/ranking.html

# Creating a new data frame
recommendations <- debate_tools

# Grouping by language_preference and then LanguageRecommendationSelect
recommendations <- recommendations  %>% 
   group_by(language_preference, LanguageRecommendationSelect)  %>%
    summarise(recommendations_count = n())

# Removing empty responses and include the top recommendations
recommendations <- arrange(recommendations,language_preference,desc(recommendations_count)) %>%
    mutate(rown = row_number()) %>%
        filter(rown <= 4)

# --- Task 8
# Creating a faceted bar plot
ggplot(recommendations, aes(y = recommendations_count, x = LanguageRecommendationSelect))+
        geom_bar(stat = "identity")+
        facet_wrap(~language_preference)

# --- Task 9
# Would R users find this statement TRUE or FALSE?
R_is_number_one = TRUE