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

Classification models differ from regression models in that you're trying to predict a categorical target.

A useful tool for evaluating classification models is known as a confusion matrix. This is a matrix of the model's predicted classes versus the actual outcomes in reality.

**The columns of the confusion matrix are the true classes while the rows are the predictions.**

The main diagonal of the confusion matrix are the instances where the model is correct and the second diagonal when its wrong.

To create a confusion matrix we start by fitting a model and predict on a test set. After, we cut the predicted probabilities with a treshold to get class assignments. A Logistic regression outputs a probability that an object is true, but we need this probabilities to make a binary decision. Then we do a 2-way frequency table using the `table()` function.

```r
table(p_class, test[["Class"]])
```

We can either use the `confusionMatrix()` function in caret do the calculations. confusionMatrix() in caret improves on table() from base R by adding lots of useful ancillary statistics in addition to the base rates in the table. You can calculate the confusion matrix (and the associated statistics) using the predicted outcomes as well as the actual outcomes.

Example code:

```r
# If p exceeds threshold of 0.5, M else R: m_or_r
m_or_r <- ifelse(p >0.5, "M", "R")

# Convert to factor: p_class
p_class <-factor(m_or_r, levels = levels(test[["Class"]]))

# Create confusion matrix
confusionMatrix(p_class, test[["Class"]])
```

In order to analyse different thresholds on a more sistematic way we can plot the tradeoff between true positives and false positives. This is cal the Receiver Operating Characteristic curve or `ROC curve`.

Note: This course uses the `library(caTools)` to generate Roc curves.

```r
library(caTools)
colAUC(p, test[["Class"]], plotROC = TRUE)
```

The x-axis is the false positive rate and the y axis is the true positive. Each point along the curve represents a different threshold. 

`colAUC(predicted_probabilities, actual, plotROC = TRUE)`

Just looking at a ROC curve starts to give us a good idea of how to evaluate whether or not our predictive model is any good. 

Models with random predictions tend to produce curves that closely follow the diagonal line. On the other hand models that allow for a clear separation of classes produce a box with a single point at 1,0 to represent a model where is possible to achieve a 100% true positive rate and a 0% false positive rate.

The area under the curve for a perfect model is exactly 1 and for a random model is 0.5.

AUC ROC (Area under the ROC curve) is a single-number summary of the model's accuracy that does not require us to manually evaluate confusion matrices. This number summarizes the model's performance across all possible classification.

You can use the trainControl() function in caret to use AUC (instead of acccuracy), to tune the parameters of your models. The twoClassSummary() convenience function allows you to do this easily.

When using twoClassSummary(), be sure to always include the argument classProbs = TRUE or your model will throw an error! (You cannot calculate AUC with just class predictions. You need to have class probabilities as well.)

Example code:

```r
myControl <- trainControl(
  method = "cv",
  number = 10,
  summaryFunction = twoClassSummary,
  classProbs = TRUE, # IMPORTANT!
  verboseIter = TRUE
)
```
# Chapter 3: Tuning model parameters to improve performance

Random forests are a very popular type of machine learning model. They are quite robust against overfitting.

The drawback to random forest is that, unlike linear models, they have hyperparameters to tune. They have to be manually specified by the data scientist as inputs to the predictive model.

Random forest start with a simple decision tree model, which is fast but usually not very accurate. Random forest improves the accuray by fitting many trees which one to a bootstrap sample of the data. This is called _bootstrap aggregation or bagging._ Random forests take bagging one step further by randomly resampling the columns of the dataset at each split.

```r
model <- train(Class~., 
                data= Sonar,
                method = "ranger"
)
```

Random forest models are much more flexible than linear models, and can model complicated nonlinear effects as well as automatically capture interactions between variables.

Example of code for random forest and 5 folds control.

```r
 # Fit random forest: model
model <- train(
  quality ~.,
  tuneLength = 1,
  data = wine, method = "ranger",
  trControl = trainControl(method = "cv", number = 5, verboseIter = TRUE)
)

# Print model to console
model
```

Random forests have hyperparameters that control how the model is fit. The most important of these hyperparameters is `mtry` or number of randomly selected variables used at each split point in the individual decision trees that make up the random forest. Caret selects hyperparameters based on out-of-sample error. we can do this by increase the value of tunelenght (default = 3).  Suppose that a tree has a total of 10 splits and mtry = 2. This means that there are 10 samples of 2 predictors each time a split is evaluate

We can pass our own, fully customized grids as data frames to the tuneGrid argument in train function. Random forests have a single tuning paramete, `mtry` so we make a data frame with a single column. We then pass this dataframe to tuneGrid parameter. You can provide any number of values for mtry, from 2 up to the number of columns in the dataset. In practice, there are diminishing returns for much larger values of mtry. 

Example of code:

```r
# Define the tuning grid: tuneGrid
tuneGrid <- data.frame(
  .mtry = c(2,3,7),
  .splitrule = "variance",
  .min.node.size = 5
)

# Fit random forest: model
model <- train(
  quality~.,
  tuneGrid = tuneGrid,
  data = wine, 
  method = "ranger",
  trControl = trainControl(method = "cv", number = 5, verboseIter = TRUE)
)

# Print model to console
model

# Plot model
plot(model)
```

`Glmnet` models are a an extension of generalized linear models, or the glm function in R. However, they have built-in variable selection that is useful on many real-world datasets. Thereare two different primary forms:

  - **Lasso regression** which penalizes number of non-zero coefficients
  - **Ridge regression** which penalizes absolute magnitude of coefficients

`glmnet` models place constrains on your coefficients which helps prevent overfitting. **This is more commonly known as "penalized" regression modeling and is a very useful technique on datasets with many predictors and few values.**

The glmnet models can fit a mix of lasso and ridge models. This gives lots of parameters to tune. An example is the `alpha` which varies between [0,1] where 0 is pure lasso and 1 is pure ridge. On the other hand `lambda` ranges from [0,Inf] and measures the size of the penalty.

Classification problems are a little more complicated than regression problems because you have to provide a custom summaryFunction to the train() function to use the AUC metric to rank your models.

For a single `alpha` gmlnet fits all values of `lambda` simultaneously. This is called the sub-model trick because we can fit a number of different models simultaneously and then explore the results of each sub-model after the fact. 

```r
# My favorite tuning grid for glmnet models is:

expand.grid(alpha = 0:1,
  lambda = seq(0.0001, 1, length = 100))
```

This grid explores a large number of lambda values (100, in fact), from a very small one to a very large one. If you want to explore fewer models, you can use a shorter lambda sequence. For example, `lambda = seq(0.0001, 1, length = 10)` would fit 10 models per value of alpha.

Example:

```r
# Train glmnet with custom trainControl and tuning: model
model <- train(
  y~., overfit,
  tuneGrid = expand.grid(alpha = 0:1,lambda = seq(0.0001,1, length = 20)),
  method = "glmnet",
  trControl = myControl
)

# Print model to console
model

# Print maximum ROC statistic
max(model[["results"]][["ROC"]])
```

# Chapter 4: Preprocessing your data