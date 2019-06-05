---
PageTitle: Categorical data in the tidyverse
---

# Chapter 1: Introduction to factor variables

Categorical data are data that fall into unordered groups, while ordinal data have an inherent order but not a constant distance between them. In R we can represent this kind of variables in 2 ways, as characters or as factors. Normamly we use factors for categorical and ordinal variables and characters otherwise.

```r
# Mutate all character columns to factors
multipleChoiceResponses %>%
    mutate_if(is.character, as.factor)
```
To better understand our variable we can use the following functions: `nlevels()` which return the number of levels of `levels()` which return the levels of a factor.
