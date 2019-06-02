---
PageTitle: Categorical data in the tidyverse
---
# Introduction to factor variables
Mutate() and summarise() in dplyr both have variants where you can add the suffix if or all to change the operation. mutate_if() and summarise_if apply their second argument, a function, to all columns where the first argument is true, and mutate_all() and summarise_all take one argument, a function, and apply it to all columns. There are more handy functions - summarise_at() and mutate_at(). These let you select columns by name-based select helpers. 

dplyr has two other functions that can come in handy when exploring a dataset. The first is top_n(x, var), which gets us the first x rows of a dataset based on the value of var. The other is pull(), which allows us to extract a column and take out the name, leaving only the value(s) from the column. 

`fct_reorder` will reorder the levels of a factor. `fct_rev` organizes a factor from the most to the least relevant.

The following code will organize by each level and from biggest to smallest
```r
# Make a bar plot
ggplot(multiple_choice_responses, aes(fct_rev(fct_infreq(EmployerIndustry)))) + 
    geom_bar() + 
    # flip the coordinates
    coord_flip()
```
A ggplot with arranged factors

```r
multiple_choice_responses %>%
  # remove NAs
  filter(!is.na(EmployerIndustry) & !is.na(Age)) %>%
  # get mean_age by EmployerIndustry
  group_by(EmployerIndustry) %>%
  summarise(mean_age = mean(Age)) %>%
  # reorder EmployerIndustry by mean_age 
  mutate(EmployerIndustry = fct_reorder(EmployerIndustry, mean_age)) %>%
  # make a scatterplot of EmployerIndustry by mean_age
  ggplot(aes(x = EmployerIndustry, y = mean_age)) + 
    geom_point() + 
    coord_flip()
```

# Manipulating Factor Variables