---
PageTitle: Machine Learning with Tree based models in R
---

# Classification Trees

Supervised learning is the subfield of machine learning where you train a model using input data and corresponding labels the convers is called unsupervised learning, where you learn from the input data alone.

In supervised learning each example is a pair consisting of the input data and an output value which represents a category or label in the case of classification, or a numeric valur in the case of regression. The algorithm analyzes the trainning data and produces an inferred model which can be used for mapping new examples to predicted labels or values.

A decision tree is a hierarchical structure with nodes and directed edges. The node at the top is called the *root node*. The nodes at the botton are called the *leaf nodes* or*terminal nodes*.
The other are called internal nodes.

A *classification tree* is a decision tree that performs a classification task. Where follows an example for a `rpart` model:

```R
# Look at the data
str(creditsub)

# Create the model
	credit_model <- rpart(formula = default ~ ., 
			data = creditsub, 
			method = "class")

# Display the results
rpart.plot(x = credit_model, yesno = 2, type = 0, extra = 0)
	```

The first part of the code trains a model using credit data from german risk database and the second plots the decision tree. This is a binary model where the output is either default or non default.

	Advantages of tree based machine learning:
	- simple to understand, interpret, visualize
	- Can handle both numerical and categorical features (inputs) natively
	- Can handle missing data elegantly
	- Robust to outliers
	- Require litle data preparation
	- Can model non-linearity in the data
	- Can be trained quicly on large datasets

	Disadvantages of using tree based models:
	- Large trees can be hard to interpret
	- Trees have high variance, which causes model performance to be poor
	- Trees overfit easily

As in other models is advised to use a train/test split. The course introduces the following method (this can easly be done using caret split functions)

	```R
	n <- nrow(restaurants)
	n_train <- round(0.80*n)
	set.seed(12)
train_indices <- sample(1:n, n_train)
	restaurant_train <- restaurants[train_indices,]
	restaurant_test <- restaurants[-train_indices,]

# train the model to predict binary output

	restaurant_model <- rpart(formula = will_wait ~. ,
			data = restaurant_train,
			method = "class")

# formula: response variable ~ predictor variables
# data: trainning ste
# method: is "class" since we are dealing with a binary response
	```

In order to make predictions using the model we just created we can use the `predict()` function like other models. On Rpart we can chosse the type of output either be raw or class. eg:

	```R
	class_prediction <- predict(object = restaurant_model, newdata = restaurant_test, type = "class") #otherwise we can use "prob" for raw values
	```

	**Evaluation metrics for binary classification**
	- Accuracy,
	- Confusion matrix
	- Log-loss
	- AUC


	We will use the caret package to create a confusion matrix in R:

	```R
# calculate the confusion matrix for the test set
confusionMatrix (data = class_prediction, reference = restaurant_test$will_wait)

# Reference is a vector of the true class labels

	```

The idea behind classification trees is to split the data into subsets where each subset belongs to only one class. Decision boundaries separate regions of pure data. 
For this we need to calculate the quality of each split. The impurity measure of a node specifies how mixed the resulting subsets are, we want the split that minimizes the impurity. A common impurity measure used for determining the best split is the Gini index.


# Introduction to regression trees

In regression the goal is to predict a numeric outcome from a set of inputs. In classification tree homogenetey is measure by entropy which is undefined for numeric data instead is measure by statistics such as variance, standard deviation or absolute deviation from the mean. 

While trainning a model, because is regression we should us "anova" instead of "class". We will devide the data into trainning set, validation set and test set. The goal of the validation set is to tune the hyperparameters of a model, or to select a best model from a set of candidate models.

```R
# Look at the data
str(grade)

# Set seed and create assignment
set.seed(1)
assignment <- sample(1:3, size = nrow(grade), prob = c(0.7,0.15,0.15), replace = TRUE)
# It assigns 70% to 1 and devides equally the rest among both categories

# Create a train, validation and tests from the original data frame 
grade_train <- grade[assignment == 1, ]    # subset grade to training indices only
grade_valid <- grade[assignment == 2, ]  # subset grade to validation indices only
grade_test <- grade[assignment == 3, ]   # subset grade to test indices only

# Train the model
grade_model <- rpart(formula = final_grade ~ ., 
                     data = grade_train, 
                     method = "anova")

# Look at the model output                      
print(grade_model)

# Plot the tree model
rpart.plot(x = grade_model, yesno = 2, type = 0, extra = 0)

```

In order to evaluate a regression tree we can not use acuracy because it does not apply. Because prediction an real values are both numeric values it makes sense to measure the distance between both. Two of the most popular metrics are *Mean Absolute Error* and *Root Mean Square Error*.

Taking the square root brings the metric back to the original scale of the response. Both MAE and RMSE express average model prediction error in units of the variable of interest. RMSE penalizes more large errors.

On this course we will use a package called `Metrics` for calculating the RMSE.

```R
library(Metrics)

# compute the rmse
rmse(actual = test$response, #the actual values
	predicted = pred) # the predicted values
```

**Hyperparameters for Rpart:**
- mintsplit: minimum number of data points required to attempt a split
- cp: complexity parameter and it serves as a penalty term to control tree size. The smaller the value the more complex the tree will be.
- maxdepth: depth of a decision tree

The following example prunes a Rpart tree using the optimal cp value. It is important to recall that while trainning a Rpart model it stores a 10 fold validation of the CP inside the model under *cptable*.

```R
# Plot the "CP Table"
plotcp(grade_model)

# Print the "CP Table"
print(grade_model$cptable)

# Retrieve optimal cp value based on cross-validated error
opt_index <- which.min(grade_model$cptable[, "xerror"])
cp_opt <- grade_model$cptable[opt_index, "CP"]
```

One common technique for performing model selection is called *grid search*. 

We will manually create a grid:

```R
# Establish a list of possible values for minsplit and maxdepth
minsplit <- seq(1, 4, 1)
maxdepth <- seq(1, 6, 1)

# Create a data frame containing all combinations 
hyper_grid <- expand.grid(minsplit = minsplit, maxdepth = maxdepth)

# expand.grid creates a data frame from all combinations of the supplied vectors or factors.

# Check out the grid
head(hyper_grid)

# Print the number of grid combinations
nrow(hyper_grid)

# Number of potential models in the grid
num_models <- nrow(hyper_grid)

# Create an empty list to store models
grade_models <- list()

# Write a loop over the rows of hyper_grid to train the grid of models
for (i in 1:num_models) {

    # Get minsplit, maxdepth values at row i
    minsplit <- hyper_grid$minsplit[i]
    maxdepth <- hyper_grid$maxdepth[i]

    # Train a model and store in the list
    grade_models[[i]] <- rpart(formula = final_grade ~ ., 
                               data = grade_train, 
                               method = "anova",
                               minsplit = minsplit,
                               maxdepth = maxdepth)
}

# Number of potential models in the grid
num_models <- length(grade_models)

# Create an empty vector to store RMSE values
rmse_values <- c()

# Write a loop over the models to compute validation RMSE
for (i in 1:num_models) {

    # Retrieve the i^th model from the list
    model <- grade_models[[i]]
    
    # Generate predictions on grade_valid 
    pred <- predict(object = model,
                    newdata = grade_valid)
    
    # Compute validation RMSE and add to the 
    rmse_values[i] <- rmse(actual = grade_valid$final_grade, 
                           predicted = pred)
}

# Identify the model with smallest validation set RMSE
best_model <- grade_models[[which.min(rmse_values)]]

# Print the model paramters of the best model
best_model$control

# Compute test set RMSE on best_model
pred <- predict(object = best_model,
                newdata = grade_test)
rmse(actual = grade_test$final_grade, 
     predicted = pred)
```

# Bagged trees

One the main drawbacks of decision trees is their high variance.

Bagged trees averages many trees to reduce this variance. Combining several models into one is what's called an ensemble model. "Bagging" is an assemble method and Bagging is the shorthand for bootstrap aggregation. Bagging uses bootstrap sampling and aggregates the individual models by averaging. 

The way bagging works is the following: 
1. You draw B samples with replacemente from the original training set where B is a number less than or equal to the N, number of total samples in the training set. A common choice is one half N.

2. Train a decision on the newly set. Repeat steps

3. Each bootstraped tree will typically involve different features than the original and might have a different number of terminal nodes. you the generate predictions from each of the trees and then simply average the predictions together to get the final prediction.

Fitting a bagged decision model is similar to other models:

```R
library(ipred)
bagging(formula = response ~., data=dat)
```

If we want to estimate the model's accuracy using the "out-of-bag" (OOB) samples, we can set the the coob parameter to TRUE. The OOB samples are the training obsevations that were not selected into the bootstrapped sample (used in training). Since these observations were not used in training, we can use them instead to evaluate the accuracy of the model (done automatically inside the bagging() function).

```R
# Bagging is a randomized model, so let's set a seed (123) for reproducibility
set.seed(123)

# Train a bagged model
credit_model <- bagging(formula = default ~ ., 
                        data = credit_train,
                        coob = TRUE)

# Print the model
print(credit_model)
```

Using the metrics package we can compute the AUC the following way:

```R
library(Metrics)
auc(actual,predicted)
```

The following example calculates the confusion matrix using Caret:

```R
# Generate predicted classes using the model object
class_prediction <- predict(object = credit_model,    
                            newdata = credit_test,  
                            type = "class")  # return classification labels

# Print the predicted classes
print(class_prediction)

# Calculate the confusion matrix for the test set
confusionMatrix(data = class_prediction,       
                reference = credit_test$default)  
```

In binary classification problems, we can predict numeric values instead of class labels. In fact, class labels are created only after you use the model to predict a raw, numeric, predicted value for a test point.

The predicted label is generated by applying a threshold to the predicted value, such that all tests points with predicted value greater than that threshold get a predicted label of "1" and, points below that threshold get a predicted label of "0".

```R
# Generate predictions on the test set
pred <- predict(object = credit_model,
                newdata = credit_test,
                type = "prob")

# `pred` is a matrix
class(pred)
                
# Look at the pred format
head(pred)
                
# Compute the AUC (`actual` must be a binary (or 1/0 numeric) vector)
auc(actual = ifelse(credit_test$default == "yes", 1, 0), 
    predicted = pred[,"yes"]) 
```

Example of a bagging tree trainned using Caret with crossvalidation included on the train control:

```R
# Specify the training configuration
ctrl <- trainControl(method = "cv",     # Cross-validation
                     number = 5,      # 5 folds
                     classProbs = TRUE,                  # For AUC
                     summaryFunction = twoClassSummary)  # For AUC

# Cross validate the credit model using "treebag" method; 
# Track AUC (Area under the ROC curve)
set.seed(1)  # for reproducibility
credit_caret_model <- train(default ~ .,
                            data = credit_train, 
                            method = "treebag",
                            metric = "ROC",
                            trControl = ctrl)

# Look at the model object
print(credit_caret_model)

# Inspect the contents of the model list 
names(credit_caret_model)

# Print the CV AUC
credit_caret_model$results[,"ROC"]

# Generate predictions on the test set
pred <- predict(object = credit_caret_model, 
                newdata = credit_test,
                type = "prob")

# Compute the AUC (`actual` must be a binary (or 1/0 numeric) vector)
auc(actual = ifelse(credit_test$default == "yes", 1, 0), 
                    predicted = pred[,"yes"])

```

# Random Forests

The basic idea behind random forest is identical to bagging. Both are ensembles of trees trained on boostraps. However in the Random Forest lagorithm there is slight tweak to the way the decision trees are built that leads to better performance.

	The key difference is that while training we add a bit of extra randomness to the model. At each split, rather than considering all features, or input variables for the split we sample a subset of these features and consider only these few variables as a candidates for the split. It improves upon bagging by reducing the correlation between the sampled trees.

If we print a random forest model we will see the number of trees used, the **number of variables tried at each split which is random forest parlance is called "mtry"**.

The defaukt mtry values is the square root of the number of features.

The print will also include a "out-of.bag" or "OOB" estimate of the error rate of the model. This is the error rate computed across the sample that were not selected into the bootstrapped training sets.

Some of the samples will be duplicated in the training set and some will be absent. The absent examples are what is called "out of bag" samples. The last row returns the final out of bag error.

By ploting a model forest model object it show a plot it show the OOB error rates as a function of the number of trees in the forest. This helps decide how many trees are are necessary to include in the ensemble. After a certain point including more trees on a model will not increase the performance because the OOB error flatens out.

We will plot the OOB error as a function of the number of trees trained, and extract the final OOB error of the Random Forest model from the trained model object.

```R
# Grab OOB error matrix & take a look
err <- credit_model$err.rate
head(err)

# Look at final OOB error rate (last row in err matrix)
oob_err <- err[nrow(err), "OOB"]
print(oob_err)

# Plot the model trained in the previous exercise
plot(credit_model)

# Add a legend since it doesn't have one by default
legend(x = "right", 
       legend = colnames(err),
       fill = 1:ncol(err))
```

The following code compares test accuracy to OOB accuracy

```R
# Generate predicted classes using the model object
class_prediction <- predict(object = credit_model,   # model object 
                            newdata = credit_test,  # test dataset
                            type = "class") # return classification labels
                            
# Calculate the confusion matrix for the test set
cm <- confusionMatrix(data = class_prediction,       # predicted classes
                      reference = credit_test$default)  # actual classes
print(cm)

# Compare test set accuracy to OOB accuracy
paste0("Test Accuracy: ", cm$overall[1])
paste0("OOB Accuracy: ", 1 - oob_err)
```

One of the nicest things about Random Forest algorithm is that you're provided with a built-in validation without sacrificing any training data.

This computation is already built in but this metric is difficul to compare to other models as GLM, it is only useful to compare several random forest models. 


There is only a handful of hyperparameters hat have a big impact on the performance of the model. The main are:

- ntree: number of trees in the model
- mtry: number of variables/features randomly sampled as candidates at each split
- sampsize: number of samples to train on
- nodesize: minimum size (number of samples) of the terminal nodes
- maxnodes: maximum number of terminal nodes

Note that (unfortunately) the tuneRF() interface does not support the typical formula input that we've been using, but instead uses two arguments, x (matrix or data frame of predictor variables) and y (response vector; must be a factor for classification).

Example of tunning the ntree for the RandomForest package:

```R
# Execute the tuning process
set.seed(1)              
res <- tuneRF(x = subset(credit_train, select = -default),
              y = credit_train$default,
              ntreeTry = 500)
               
# Look at results
print(res)

# Find the mtry value that minimizes OOB Error
mtry_opt <- res[,"mtry"][which.min(res[,"OOBError"])]
print(mtry_opt)

# If you just want to return the best RF model (rather than results)
# you can set `doBest = TRUE` in `tuneRF()` to return the best RF model
# instead of a set performance matrix.
```

In this exercise, you will create a grid of mtry, nodesize and sampsize values. In this example, we will identify the "best model" based on OOB error. The best model is defined as the model from our grid which minimizes OOB error.

Example for coding using a grid for hyperparameter:

```R
# Establish a list of possible values for mtry, nodesize and sampsize
mtry <- seq(4, ncol(credit_train) * 0.8, 2)
nodesize <- seq(3, 8, 2)
sampsize <- nrow(credit_train) * c(0.7, 0.8)

# Create a data frame containing all combinations 
hyper_grid <- expand.grid(mtry = mtry, nodesize = nodesize, sampsize = sampsize)

# Create an empty vector to store OOB error values
oob_err <- c()

# Write a loop over the rows of hyper_grid to train the grid of models
for (i in 1:nrow(hyper_grid)) {

    # Train a Random Forest model
    model <- randomForest(formula = default ~ ., 
                          data = credit_train,
                          mtry = hyper_grid$mtry[i],
                          nodesize = hyper_grid$nodesize[i],
                          sampsize = hyper_grid$sampsize[i])
                          
    # Store OOB error for the model                      
    oob_err[i] <- model$err.rate[nrow(model$err.rate), "OOB"]
}

# Identify optimal set of hyperparmeters based on OOB error
opt_i <- which.min(oob_err)
print(hyper_grid[opt_i,])
```

# Boosted trees

Boosting is an iterative algorithm that considers past fits to improce performance.

The two most popular algorithms are Adaboost and the Gradient Boosting Machine (GBM). GBM represents only a small tweak on the original Adaboost algorithm. 

**Adaboost Algorithm**
- Train a decision tree where each observation is assigned an equal weight. 
- After evaluating the first tree we increase the weight of the observations that are difficult to classify and lower weights of the observations that are easy to classify.
- A second tree is grown on weighted data
- New model: tree1+tree2
- Calculate classification error from this new 2 tree ensemble model
- Grow a 3rd tree to predict the revised residuals
- Repeat this process through iteractions

Subsquent trees help classifying observations that are not well classified by preceding trees. 

To train a GBM in R we need to specify a few arguments as defined in the following example:

```R
model <- gbm(formula = response~.,
		distribution= "bernouli",i #In the case it is a binary distribuition the response variable
		data= train,
		n.tree = 5000)
```

Using such a large number of trees (10,000) is probably not optimal for a GBM model, but we will build more trees than we need and then select the optimal number of trees based on early performance-based stopping. The best GBM model will likely contain fewer trees than we started with.
For binary classification, gbm() requires the response to be encoded as 0/1 (numeric), so we will have to convert from a "no/yes" factor to a 0/1 numeric response column.

```R
# Convert "yes" to 1, "no" to 0
credit_train$default <- ifelse(credit_train$default == "yes", 1, 0)

# Train a 10000-tree GBM model
set.seed(1)
credit_model <- gbm(formula = default ~ ., 
                    distribution = "bernoulli", 
                    data = credit_train,
                    n.trees = 10000)
                    
# Print the model object                    
print(credit_model)

# summary() prints variable importance
summary(credit_model)
```

The nice thing about tree based models is that they include a built-in mechanism for evaluating variable importance. Using summary() over the gbm model returns a plot of the variable importance and a table ranking the variables by their relative influence which is a measure that quantifies how useful certain variabçe were in training the model.

When predicting a GBM model we need to specify the number of trees to use in the prediction. Another argument that you can specify is type, which is only relevant to Bernoulli and Poisson distributed outcomes. When using Bernoulli loss, the returned value is on the log odds scale by default and for Poisson, it's on the log scale. If instead you specify type = "response", then gbm converts the predicted values back to the same scale as the outcome. This will convert the predicted values into probabilities for Bernoulli and expected counts for Poisson.

```{r}
# Since we converted the training response col, let's also convert the test response col
credit_test$default <- ifelse(credit_test$default == "yes", 1, 0)

# Generate predictions on the test set
preds1 <- predict(object = credit_model, 
                  newdata = credit_test,
                  n.trees = 10000)

# Generate predictions on the test set (scale to response)
preds2 <- predict(object = credit_model, 
                  newdata = credit_test,
                  n.trees = 10000,
                  type = "response")

# Compare the range of the two sets of predictions
range(preds1)
range(preds2)
```

Hyperparameter tuning is especially important in GBM models since they are prone to overfitting. In tuning, on an iterative algorithm such as the GBM also includes, you can "tune" the number of iterations on a interative model what is called an "early stopping". 

Mots hyperparameters are similar to Random Forest models whith exception of Shrinkage which represent the learning rate of a tree. The term "early stopping" is used to describe the process of stopping the training in an iterative algorithm by means of evaluating the model performance on a holdout set. 

The ideal time to stop training an iterative model is after the validation error has decreased and started to stabilize, and before the validation error starts to increase due to overfitting. But, other metrics can be used to control the early stopping. 

Use the gbm.perf() function to estimate the optimal number of boosting iterations (aka n.trees) for a GBM model object using both OOB and CV error. When you set out to train a large number of trees in a GBM (such as 10,000) and you use a validation method to determine an earlier (smaller) number of trees, then that's called "early stopping". The term "early stopping" is not unique to GBMs, but can describe auto-tuning the number of iterations in an iterative learning algorithm.

Example of code for 

```R
# Optimal ntree estimate based on OOB
ntree_opt_oob <- gbm.perf(object = credit_model, 
                          method = "OOB", 
                          oobag.curve = TRUE)

# Train a CV GBM model
set.seed(1)
credit_model_cv <- gbm(formula = default ~ ., 
                       distribution = "bernoulli", 
                       data = credit_train,
                       n.trees = 10000,
                       cv.folds = 2)

# Optimal ntree estimate based on CV
ntree_opt_cv <- gbm.perf(object = credit_model_cv, 
                         method = "cv")
 
# Compare the estimates                         
print(paste0("Optimal n.trees (OOB Estimate): ", ntree_opt_oob))                         
print(paste0("Optimal n.trees (CV Estimate): ", ntree_opt_cv))

# Generate predictions on the test set using ntree_opt_oob number of trees
preds1 <- predict(object = credit_model, 
                  newdata = credit_test,
                  n.trees = ntree_opt_oob)
                  
# Generate predictions on the test set using ntree_opt_cv number of trees
preds2 <- predict(object = credit_model, 
                  newdata = credit_test,
                  n.trees = ntree_opt_cv)   

# Generate the test set AUCs using the two sets of preditions & compare
auc1 <- auc(actual = credit_test$default, predicted = preds1)  #OOB
auc2 <- auc(actual = credit_test$default, predicted = preds2)  #CV 

# Compare AUC 
print(paste0("Test set AUC (OOB): ", auc1))                         
print(paste0("Test set AUC (CV): ", auc2))

```
 

