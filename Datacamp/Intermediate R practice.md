---
PageTitle: Intermediate R practice
---
# Intermediate R practice

### Important expressions:

`my_class <- c(me, other_199)` creates a matrix by adding two vectors.

`last_5 <- cbind(my_class, previous_4` it creates a matrix by adding columns using the function `cbind()`

`colnames(last_5) <- nms` changes the colnames of last_5 matrix by the values of the vector **nms**

`cbind()` takes a sequence of vector, matrix or data.frame arguments and combines by columns or rows, respectively (c for columns or r for rows)

`summary()` is a generic function used to produce result summaries of the results of various model fitting functions.

`mean(last_5 < 64)` calculates the proportion of valures below 64 in the total population of last_5

`mean(my_class >= 70 & my_class <= 85)` calculates the proportion of values between 70 and 85.

`sum(last_5 == 80 | last_5 == 90)` It counts all values which are either equal to 80 or 90. Because this is a condition, the function `sum()` will sum up only when the condition is true.

`top_grades <- my_class[my_class >= 85]` it subsets my_class vector to only show values above or equal to 85.

---

### Code Blocks

##### Code 1
The following code block represents a loop which repeats as long as the variable is false and ends when the variable `found` is true. This codes uses `&&` in order to assure that if the first argument is not varifiable to not look for the second.

```R
i <- 1
found <- FALSE

while(found == FALSE){
    if(logs[[i]]$sucess == FALSE && logs[[i]]$details$location == "waste"){
        print("found")
        found <- TRUE
    }else{
        print("still looking")
        i <- i+1
    }
}
```
The `while()` loop keeps executing code until its condition evaluates to false. The `for()` loop, on the other hand, iterates over a sequence, where a looping variable changes for eah iteration, according to the sequence.

Both the following expressions should generate the same output:

```R
# option 1
for(log in logs){
    print(log$timestamp)
}


#option 2
for(i in 1:lenght(logs)){
    print(logs[[i]]$timestamp)
}
```

---
##### Code 2
The following code generates a report containing only error observations.

```R
failures <- list() #generates an empty list to store the results
for(log in logs){
    if(log$success == FALSE){
        failures <- c(failures, list(logs))
    }
}
```

You cannot use the `$` notation if the element you want to select is a variable and not the actual name of a list:

- log$property # won't work
- log[[property]] # will work

---
##### Code 3
The following code allows to select the property where the selection is made

```R
extract_info <- function(x, property){
    info <- c()
    for(log in x){
        info <- c(info, log[[property]])
    }
    return(info)
}
```
Had we used `!log$success` it would mean all ocurrences where the variable `success` is false.

```R
# This exercice objective was to know the % of failures by using functions

compute_fail_pct <- function(x){ # creates a function with the x argument
    failures <- c()
    for(log in x){
        if(!log$succes){
            failures <- c(failures, log$sucess)# In case is false it adds to the list, otherwise it won't
        }
    }
    results <- lenght(failures)/lenght(x)*100
    return(results)
} 
```
Given a list `logs` from which we wish to extract data from a variable "timestamp" we can use the simple code

```R
lapply(logs,"[[","timestamp")
```
`[[` is a fuction that selects from a list with the argument "timestamp"

`Sapply ()` performs an `Lapply()` and checkes if the result can be simplified as a vector.

Syntax for `Vapply()`

```R
vapply(x,FUN, FUN.VALUE)
```

Once you know about `Vapply()`, there is really no reason to use `Sapply()` anymore. If the output that `Lapply()` would generate can be simplified to an array, you'll want to use `Vapply()` to do this securely. If simplification is not possible, simply stick to `Lapply()`.

```R
# Returns  vector with uppercase version of message elements in log entries
message_fun <- function(x){ 
    toupper(x$details$message){
        Vapply(logs,message_fun, character(1))
    }
}
```