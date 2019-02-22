---
PageTitle: Machine learning in the tidyverse
---

# Chapter 1: Foundations of "tidy" Machine learning

What makes a tibble special for machine learning is that it can natively store arbitrarily complex objects using a special column know as the list column. **This is particularly helpful for storing models since the output of these models are always complex objects.**

The process of nesting compacts the information into similar categories (example: various observations by country grouped into countries)

example:
```r
library(tidyverse)
nested <- gaminder %>%
        group_by(country)%>%
        nest()
```
This code groups observation by country and them create nested dataframes for each country. To simplify the data we can use the `unnest()` function. A nested dataframe is simply a way to shape your data. Essentially taking the group_by() windows and packaging them in corresponding rows. 

The `map()` function applies a desired function to every element in a vector or a list and always returns a list as its result. 

`map(.x = , .f = )` .x is the vector or list and .f is the function.

```r
map(.x = nested$data, .f = ~mean(.x$population))
```

This calculates de mean of population for each country. The `.x` acts as the placeholder for each element of the list. You can append the resulting list of population means using the `mutate()` function.

```r
pop_df <- nested %>%
    mutate(pop_mean = map(data, ~mean(.x$population))) %>%
    unnest()
```
We can also use map to append models for each country. example:

```r
nested %>% 
    mutate(model = map(data, ~lm(formula = population ~fertility, data = .x)))
```

In combination with mutate(), you can use map() to append the results of your calculation to a dataframe. Since the map() function always returns a vector of lists you must use unnest() to extract this information into a numeric vector.

When you know that the output of your mapped function is an expected type (here it is a numeric vector) you can leverage the map_*() family of functions to explicitly try to return that object type instead of a list. 

The following code creates several models:

```r
# Build a linear model for each country
gap_models <- gap_nested %>%
    mutate(model = map(data, ~lm(formula = life_expectancy~year, data = .x)))
    
# Extract the model for Algeria    
algeria_model <- gap_models$model[[1]]

# View the summary for the Algeria model
summary(algeria_model)
```

The core of the Broom packages are 3 functions:

- `tidy()` returns the statistical findings of the model
- `glance()` returns a concise one-row summary of the model
- `augment()` adds prediction columns to the data being modeled. This allows for example to plot how well my model fits:

```r
augment(algeria_model) %>%
    ggplot(mapping = aes(x=year))+
    geom_point(mapping = aes(y=life_expectancy))+
    geom_line(mapping = aes(y=.fitted),color = "red")
```

Having nested the models we can extract the coefficients as follows:

```r
gap_models %>%
    mutate(coef = map(model, ~tidy(.x))) %>%
    unnest(coef)
```
It adds a new column named coef that is the result of applying the tidy function to every nested dataframe. This results in a tibble containing the estimate for each coefficient of every country model.

We will learn to use the `glance()`function to measure how well each of the 77 models fit their underlying data.

One way we can measure the fit of a model is to calculate its `rsquared` metric which measures the relationship between the variation explained by the regression model and the total variation in the data.

We can use `map` and `glance `to create a datatable os statistics for each model.

```r
model_perf <- gap_models %>%
    mutate(coef = map(model, ~glance(.x))) %>%
    unnest(coef)
```
The `top_n` function cam give us the highest values.

Example:

```r
# Plot a histogram of rsquared for the 77 models    
model_perf %>% 
  ggplot(aes(x = r.squared)) + 
  geom_histogram()  
  
# Extract the 4 best fitting models
best_fit <- model_perf %>% 
  top_n(n = 4, wt = r.squared)

# Extract the 4 models with the worst fit
worst_fit <- model_perf %>% 
  top_n(n = 4, wt = -r.squared)
```

```r
best_augmented <- best_fit %>% 
  # Build the augmented dataframe for each country model
  mutate(augmented = map(model,~augment(.x))) %>% 
  # Expand the augmented dataframes
  unnest(augmented)

worst_augmented <- worst_fit %>% 
  # Build the augmented dataframe for each country model
  mutate(augmented = map(model, ~augment(.x))) %>% 
  # Expand the augmented dataframes
  unnest(augmented)
```

```r
# Compare the predicted values with the actual values of life expectancy 
# for the top 4 worst fitting models
worst_augmented %>% 
  ggplot(aes(x = year)) +
  geom_point(aes(y = life_expectancy)) + 
  geom_line(aes(y = .fitted), color = "red") +
  facet_wrap(~country, scales = "free_y")
```

```r
# Build a linear model for each country using all features
gap_fullmodel <- gap_nested %>% 
  mutate(model = map(data, ~lm(formula = life_expectancy ~., data = .x)))

fullmodel_perf <- gap_fullmodel %>% 
  # Extract the fit statistics of each model into dataframes
  mutate(fit = map(model, ~glance(.x))) %>% 
  # Simplify the fit dataframes for each model
  unnest(fit)
  
# View the performance for the four countries with the worst fitting 
# four simple models you looked at before
fullmodel_perf %>% 
  filter(country %in% worst_fit$country) %>% 
  select(country, adj.r.squared)
```

#Chapter 3: Build, Tune & Evaluate Regression Models

To make splits between train and test data we can use the following code:

```r
library(rsample)
gap_split <- initial_split(gapminder, prop = 0.75)
```
We can then divide the train data into train and validate using cross validation for this.

We can use the function `vfold_cv()` to make this splits. The result will be a lits column tibble.

n a disciplined machine learning workflow it is crucial to withhold a portion of your data (testing data) from any decision-making process. This allows you to independently assess the performance of your model when it is finalized. The remaining data, the training data, is used to build and select the best model.

```r
set.seed(42)

# Prepare the initial split object
gap_split <- initial_split(gapminder, prop = 0.75)

# Extract the training dataframe
training_data <- training(gap_split)

# Extract the testing dataframe
testing_data <- testing(gap_split)

# Calculate the dimensions of both training_data and testing_data
dim(training_data)
dim(testing_data)
```
```r
set.seed(42)

# Prepare the dataframe containing the cross validation partitions
cv_split <- vfold_cv(training_data, v = 5)

cv_data <- cv_split %>% 
  mutate(
    # Extract the train dataframe for each split
    train = map(splits, ~training(.x)), 
    # Extract the validate dataframe for each split
    validate = map(splits, ~testing(.x))
  )

# Use head() to preview cv_data
head(cv_data)
```

It assumes that all the splits will be made with the initial 75% done by the `initial_split`. 

```r
cv_prep_lm <- cv_models_lm %>% 
  mutate(
    # Extract the recorded life expectancy for the records in the validate dataframes
    validate_actual = map(validate, ~.x$life_expectancy),
    # Predict life expectancy for each validate set using its corresponding model
    validate_predicted = map2(.x = model, .y = validate, ~predict(.x, .y))
  )
```

Now that you have both the actual and predicted values of each fold you can compare them to measure performance.

For this regression model, you will measure the Mean Absolute Error (MAE) between these two vectors. This value tells you the average difference between the actual and predicted values.

```r
library(Metrics)
# Calculate the mean absolute error for each validate fold       
cv_eval_lm <- cv_prep_lm %>% 
  mutate(validate_mae = map2_dbl(.x=validate_actual, .y=validate_predicted, ~mae(actual = .x, predicted = .y)))

# Print the validate_mae column
cv_eval_lm$validate_mae

# Calculate the mean of validate_mae column
mean(cv_eval_lm$validate_mae)

```

Using the same idea for a random forest model

```r
library(ranger)

# Build a random forest model for each fold
cv_models_rf <- cv_data %>% 
  mutate(model = map(train, ~ranger(formula = life_expectancy ~., data = .x,
                                    num.trees = 100, seed = 42)))

# Generate predictions using the random forest model
cv_prep_rf <- cv_models_rf %>% 
  mutate(validate_predicted = map2(.x = model, .y = validate, ~predict(.x, .y)$predictions))
```

We are using the ranger package to generate the random forest model.

```r
library(ranger)

# Calculate validate MAE for each fold
cv_eval_rf <- cv_prep_rf %>% 
  mutate(validate_mae = map2_dbl(.x=validate_actual, .y=validate_predicted, ~mae(actual = .x, predicted = .y)))

# Print the validate_mae column
cv_eval_rf$validate_mae

# Calculate the mean of validate_mae column
mean(cv_eval_rf$validate_mae)
```

Now with mtry parameters:

```r
# Prepare for tuning your cross validation folds by varying mtry
cv_tune <- cv_data %>% 
  crossing(mtry = 2:5) 

# Build a model for each fold & mtry combination
cv_model_tunerf <- cv_tune %>% 
  mutate(model = map2(.x = train, .y = mtry, ~ranger(formula = life_expectancy~., 
                                           data = .x, mtry = .y, 
                                           num.trees = 100, seed = 42)))
```
You've now built models where you've varied the random forest-specific hyperparameter mtry in the hopes of improving your model further. Now you will measure the performance of each mtry value across the 5 cross validation partitions to see if you can improve the model.

```r
# Generate validate predictions for each model
cv_prep_tunerf <- cv_model_tunerf %>% 
  mutate(validate_predicted = map2(.x = model, .y = validate, ~predict(.x, .y)$predictions))

# Calculate validate MAE for each fold and mtry combination
cv_eval_tunerf <- cv_prep_tunerf %>% 
  mutate(validate_mae = map2_dbl(.x = validate_actual, .y = validate_predicted, ~mae(actual = .x, predicted = .y)))

# Calculate the mean validate_mae for each mtry used  
cv_eval_tunerf %>% 
  group_by(mtry) %>% 
  summarise(mean_mae = mean(validate_mae))
```

Using cross-validation you were able to identify the best model for predicting life_expectancy using all the features in gapminder. Now that you've selected your model, you can use the independent set of data (testing_data) that you've held out to estimate the performance of this model on new data.

```r
# Build the model using all training data and the best performing parameter
best_model <- ranger(formula = life_expectancy ~., data = training_data,
                     mtry = 4, num.trees = 100, seed = 42)

# Prepare the test_actual vector
test_actual <- testing_data$life_expectancy

# Predict life_expectancy for the testing_data
test_predicted <- predict(best_model, testing_data)$predictions

# Calculate the test MAE
mae(test_actual, test_predicted)
```

#Chapter 4: Build, Tune & Evaluate Classification Models

```r
# Build a model using the train data for each fold of the cross validation
cv_models_lr <- cv_data %>% 
  mutate(model = map(train, ~glm(formula = Attrition~.,
                               data = .x, family = "binomial")))
```

```r
# Extract the first model and validate 
model <- cv_models_lr$model[[1]]
validate <- cv_models_lr$validate[[1]]

# Prepare binary vector of actual Attrition values in validate
validate_actual <- validate$Attrition == "Yes"

# Predict the probabilities for the observations in validate
validate_prob <- predict(model, validate, type = "response")

# Prepare binary vector of predicted Attrition values for validate
validate_predicted <- validate_prob > 0.5
```

Now that you have the binary vectors for the actual and predicted values of the model, you can calculate many commonly used binary classification metrics. In this exercise you will focus on:

    accuracy: rate of correctly predicted values relative to all predictions.
    precision: portion of predictions that the model correctly predicted as TRUE.
    recall: portion of actual TRUE values that the model correctly recovered.

```r
library(Metrics)

# Compare the actual & predicted performance visually using a table
table(validate_actual, validate_predicted)

# Calculate the accuracy
accuracy(validate_actual, validate_predicted)

# Calculate the precision
precision(validate_actual, validate_predicted)

# Calculate the recall
recall(validate_actual, validate_predicted)
```

For various models:

```r
cv_prep_lr <- cv_models_lr %>% 
  mutate(
    # Prepare binary vector of actual Attrition values in validate
    validate_actual = map(validate, ~.x$Attrition == "Yes"),
    # Prepare binary vector of predicted Attrition values for validate
    validate_predicted = map2(.x = model, .y = validate, ~predict(.x, .y, type = "response") > 0.5)
  )
```

For RandomForest models:

```r
library(ranger)

# Prepare for tuning your cross validation folds by varying mtry
cv_tune <- cv_data %>%
  crossing(mtry = c(2,4,8,16)) 

# Build a cross validation model for each fold & mtry combination
cv_models_rf <- cv_tune %>% 
  mutate(model = map2(.x = train , .y = mtry, ~ranger(formula = Attrition~., 
                                           data = .x, mtry = .y,
                                           num.trees = 100, seed = 42)))
```

To calculate for each mtry:

```r
cv_prep_rf <- cv_models_rf %>% 
  mutate(
    # Prepare binary vector of actual Attrition values in validate
    validate_actual = map(validate, ~.x$Attrition == "Yes"),
    # Prepare binary vector of predicted Attrition values for validate
    validate_predicted = map2(.x = model, .y = validate, ~predict(.x, .y, type = "response")$predictions == "Yes")
  )

# Calculate the validate recall for each cross validation fold
cv_perf_recall <- cv_prep_rf %>% 
  mutate(recall = map2_dbl(.x = validate_actual, .y = validate_predicted, ~recall(actual = .x, predicted = .y)))

# Calculate the mean recall for each mtry used  
cv_perf_recall %>% 
  group_by(mtry) %>% 
  summarise(mean_recall = mean(recall))
```

```r
# Build the logistic regression model using all training data
best_model <- glm(formula = Attrition~., 
                  data = training_data, family = "binomial")


# Prepare binary vector of actual Attrition values for testing_data
test_actual <- testing_data$Attrition == "Yes"

# Prepare binary vector of predicted Attrition values for testing_data
test_predicted <- predict(best_model, testing_data, type = "response") > 0.5
```

