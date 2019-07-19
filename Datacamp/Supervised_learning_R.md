---
Title: Supervised learning in R- Classification
---

# Chapter 1: K-nearest neighbors (knn)

A knn learner decides that to signs are simillar by leterally measuring the distance between them. 

The distance is measure on a feature space. Many knn leaners use the euclidean distance formula. In R, the knn model requires information on the trainning dataset, the test values and the class labels.

As expected, stop signs tend to have a higher average red value. This is how kNN identifies similar signs. 

Using `knn()` already returns the predictions.

Example for applying code:

```r
# Use kNN to identify the test road signs
sign_types <- signs$sign_type
signs_pred <- knn(train = signs[-1], test = test_signs[-1], cl = sign_types)

# Create a confusion matrix of the predicted versus actual values
signs_actual <- test_signs$sign_type
table(signs_pred, signs_actual)

# Compute the accuracy
mean(signs_pred == signs_actual)
```

Note that this last argument allows to quickly compute accuracy.

When we set k = 1 it means that the single nearest, most similiar, neighbor was used to classify the unlabeled example.

By default, the knn() function in the class package uses only the single nearest neighbor.

Setting a k parameter allows the algorithm to consider additional nearby neighbors. This enlarges the collection of neighbors which will vote on the predicted class.

When multiple nearest neighbors hold a vote, it can sometimes be useful to examine whether the voters were unanimous or widely separated.

For example, knowing more about the voters' confidence in the classification could allow an autonomous vehicle to use caution in the case there is any chance at all that a stop sign is ahead.

knn use distance functions and it assume that the data is numeric. It is also important that when calculating data that it should be nomalized.

**We should normalize after we have already create one hot coding.** (it could be min max normalization)

# Chapter 2: Naive Bayes
The algorithm known as _Naive Bayes_ applies Bayesian methods to estimate the conditional probability of an outcome.

The naivebayes package offers several ways to peek inside a Naive Bayes model.

Typing the name of the model object provides the a priori (overall) and conditional probabilities of each of the model's predictors. If one were so inclined, you might use these for calculating posterior (predicted) probabilities by hand.

Alternatively, R will compute the posterior probabilities for you if the type = "prob" parameter is supplied to the predict() function.

One event is independent of another if knowing one doesn't give you information about how likely the other is. For example, knowing if it's raining in New York doesn't help you predict the weather in San Francisco. The weather events in the two cities are independent of each other.

# Chapter 3: Logistic regression
As with many of R's machine learning methods, you can apply the predict() function to the model object to forecast future behavior. By default, predict() outputs predictions in terms of log odds unless type = "response" is specified. This converts the log odds to probabilities.

When one outcome is very rare, predicting the opposite can result in a very high accuracy. For this reason is sometimes better to look at auc curves.

All of the predictors used in a regression analysis must be numeric and there can't have NA.

```r

Dummy coding categorical data

# create gender factor
my_data$gender <- factor(my_data$gender,       levels = c(0, 1, 2),
                         labels = c("Male", "Female", "Other"))


```

A strategy to deal with missing data is to impute values based on average and create a new binary variable that records everytime a value was missing.

Sometimes ew can make automatic feature selection- Stepwise regression mean regression model step by step, evaluating each predictor to see which ones add value to the final model. A procedure called backward deletion begins with a model containing all of the predictors. It then checks to see what happens when each one of the predictors is removed from the model. If removing a predictor does not substantially impact the model's ability to predict the outcome, then it can be safely deleted.

The same idea applied in the other direction is called forward selection.

In the absence of subject-matter expertise, stepwise regression can assist with the search for the most important predictors of the outcome of interest.

Example of stepwise regression code

```r
# Specify a null model with no predictors
null_model <- glm(donated ~1, data = donors, family = "binomial")

# Specify the full model using all of the potential predictors
full_model <- glm(donated ~., data = donors, family = "binomial")

# Use a forward stepwise algorithm to build a parsimonious model
step_model <- step(null_model, scope = list(lower = null_model, upper = full_model), direction = "forward")

# Estimate the stepwise donation probability
step_prob <- predict(step_model, type = "response")

# Plot the ROC of the stepwise model
library(pROC)
ROC <- roc(donors$donated, step_prob)
plot(ROC, col = "red")
auc(ROC)
```

# Chapter 4: Classification Trees

```r
# Examine the loan_model object
loan_model

# Load the rpart.plot package
library(rpart.plot)

# Plot the loan_model with default settings
rpart.plot(loan_model)

# Plot the loan_model with customized settings
rpart.plot(loan_model, type = 3, box.palette = c("red", "green"), fallen.leaves = TRUE)
```

All assemble methods are based on the idea that weaker learns become stronger once working together.