---
PageTitle: Machine learning toolbox
---

# Chapter 1: Regression models: fitting them and evaluating their performance

Caret is one of the most widely used packages in R for supervised learning asl know as predictive modeling. 

Supervised learning is machine learning when you have a "target variable" or something you want to predict. There are two main kind of predictive models: *classification* and *regression*. Classification models predict qualitative variables. Regression models predict quantitative variables.

In order to manually calculate to RMSE we can use the following:

```r
erro <- predictions - real values
sqrt(mean((error)^2))
```
The RMSE has the same units as the database.

Our goal is to create models that do not overfit the training data and generalize well. The best approach is to test models on new data. Simulating this experience with a train/test split helps make an honest assessment of yourself as a modeler.

One way you can take a train/test split of a dataset is to order the dataset randomly, then divide it into the two sets. This ensures that the training set and test set are both random samples and that any biases in the ordering of the dataset (e.g. if it had originally been ordered by price or size) are not retained in the samples we take for training and testing your models. You can think of this like shuffling a brand new deck of playing cards before dealing hands.  You use the `sample()` function to shuffle the row indices of a dataset.

`sample()` function basically select random rows from a table. By using this function with the function `nrow()` it basically creates a shuffles the rows and creates a new index for the database.

The following code is a simple form to split the data into a 80/20:

```r
# Determine row to split on: split
split <- round(nrow(diamonds)*.80)

# Create train
train <- diamonds[1:split,]

# Create test
test <- diamonds[(split + 1):nrow(diamonds),]

```
A better approach than a simple train/test split is using multiple test sets and averaging out-of-sample error, which gives us a more precise estimate of the true out-of-sample error. One of the most well know approaches is cross validation, in which we split our data into ten "folds" or train/est splits. We create these folds in such a way that eacg point in our dataset occurs in exactly one test set.

The `train()` function in caret does a different kind of resampling know as bootstrap validation. An example below:

```r
model <- train(mpg ~hp, mtcras,
                method = "lm",
                trControl = trainControl( method = "cv", number = 10, verboseIter = TRUE))
```

In this case we fit a linear regresison model, but we could just as easely fit other models by changing the parameter `method`. The `trControl` argument provides information for cross validation (this case we use "cv"). The vervoselte= TRUE gives us a progress log. You can do more than just one iteration of cross-validation. Repeated cross-validation gives you a better estimate of the test-set error. You can also repeat the entire cross-validation procedure. This takes longer, but gives you many more out-of-sample datasets to look at and much more precise assessments of how well the model performs.

One of the awesome things about the train() function in caret is how easy it is to run very different models or methods of cross-validation just by tweaking a few simple arguments to the function call. For example, you could repeat your entire cross-validation procedure 5 times for greater confidence in your estimates of the model's out-of-sample accuracy, e.g.:

```r
# Fit lm model using 5 x 5-fold CV: model
model <- train(
  medv ~ ., Boston,
  method = "lm",
  trControl = trainControl(
    method = "repeatedcv", number = 5,
    repeats = 5, verboseIter = TRUE
  )
)
```

# Chapter 2: Classification models: fitting them and evaluating their performance

