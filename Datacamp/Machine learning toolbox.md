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
Real world data has missing values. A solution is to use the median to predict what the value would be.
Caret allows a simple solution to this problem by passing `medianImpute` to the `preProcess` argument for train. This tells caret to inpute the missing values in X with their medians. Fortunately, the train() function in caret contains an argument called preProcess, which allows you to specify that median imputation should be used to fill in the missing values. 

In previous chapters, you created models with the train() function using formulas such as y ~ .. An alternative way is to specify the x and y arguments to train(), where x is an object with samples in rows and features in columns and y is a numeric or factor vector containing the outcomes. Said differently, x is a matrix or data frame that contains the whole dataset you'd use for the data argument to the lm() call, for example, but excludes the response variable column; y is a vector that contains just the response variable column.

Example
```r
# Apply median imputation: model
model <- train(
  x = breast_cancer_x, y = breast_cancer_y,
  method = "glm",
  trControl = myControl,
  preProcess = "medianImpute"
)

# Print model to console
model
```

Notice that in this case features are separated from the target variable.

There are some problems with median imputation. It is very fast, but it can produce incorrect results if the input data has a systematic bias and is missing not-at-random. In other words, if there is a pattern in the data that leads to missing values, median imputation can miss this. It is therefore useful to explore other strategies for missing imputation, particularcly for linear models. **Ones useful ype of missing value imputation is k-nearest neighbors or KNN imputation.** This is a strategy for imputing missing values based on other, similar non-missing rows. Fortunately, the train function has a built-in method to do this by just passing the following argument `preProcess = "knnImpute"`

An alternative to median imputation is k-nearest neighbors, or KNN, imputation. This is a more advanced form of imputation where missing values are replaced with values from other rows that are similar to the current row. While this is a lot more complicated to implement in practice than simple median imputation, it is very easy to explore in caret using the preProcess argument to train(). You can simply use preProcess = "knnImpute" to change the method of imputation used prior to model fitting.

The preprocess argument to train can do a lot more than missing value imputation. It exposes a very wide range of pre-processing steps that can have a large impact on the results of your models. You can also chain together multiple preprocessing steps. A "common" recipe for linear model is to do median imputation -> center data -> scale -> fit glm. we can had Principal components analysis (PCA).

**Preprocessing cheat sheet**
- start with median imputation or try knn imputation
- For linear models like lm. glm and glmnet always center and scale
- For lienar models try PCA and spatial sign transformation
- Tree-based models don't need much preprocessing

One set of preprocessing functions that is particularly useful for fitting regression models is standardization: centering and scaling. You first center by subtracting the mean of each column from each value in that column, then you scale by dividing by the standard deviation.

No (or low) variance variables may impact the results of our model. In general we remove this columns prior to model. With caret, we can had the `zv` to the preprocessing argument to remove constant-valued columns or `nzv` to remove nearly constant columns.

Fortunately, caret contains a utility function called nearZeroVar() for removing such variables to save time during modeling.

nearZeroVar() takes in data x, then looks at the ratio of the most common value to the second most common value, freqCut, and the percentage of distinct values out of the number of total samples, uniqueCut. By default, caret uses freqCut = 19 and uniqueCut = 10, which is fairly conservative. I like to be a little more aggressive and use freqCut = 2 and uniqueCut = 20 when calling nearZeroVar().

```r
# Identify near zero variance predictors: remove_cols
remove_cols <- nearZeroVar(bloodbrain_x, names = TRUE, 
                           freqCut = 2, uniqueCut = 20)

# Get all column names from bloodbrain_x: all_cols
all_cols <- names(bloodbrain_x)

# Remove from data: bloodbrain_x_small
bloodbrain_x_small <- bloodbrain_x[ , setdiff(all_cols, remove_cols)]
```

In this code we use `setdiff` to generate the columns that are on dataframe all_cols but are not included on remove_cols. The above code can give us information regarding which columns were removed  but we can do the same using the `nzv` on pre process argument in the train function.

PCA is incredibly useful because it combines the low-variance and correlated variables in your dataset into a single set of high-variance, perpendicular predictors. It prevents colinearity. We can combine this with the "zv" argument.

An alternative to removing low-variance predictors is to run PCA on your dataset. This is sometimes preferable because it does not throw out all of your data: many different low variance predictors may end up combined into one high variance PCA variable, which might have a positive impact on your model's accuracy.

# Chapter 5: Selecting models: a case study in churn prediction
In order to make a good comparison between models we need to define the training and test folds and make sure each model uses exactly the same split for each fold. We can do this by pre-defining a trainControl object, which explicitly specifies which rows are used for model building and which are used as holdouts. WE make train test indexes for cross-validation using caret's `createFolds` function. Note that these folds preserve the class distribution: the first fold has about a 14% churn rate. 

Example code:
```r
set.seed(42)
myFolds <- createFolds(churnTrain$churn, k = 5)

myControl <- trainControl (
  summaryFunction = twoClassSummary,
  classProbs = TRUE
  verbosIter = TRUE,
  savePredictions = TRUE,
  index = myFolds
)
```
We can use myFolds as created above to fit multiple models.

```r
# Fit glmnet model: model_glmnet
model_glmnet <- train(
  x = churn_x, y = churn_y,
  metric = "ROC",
  method = "glmnet",
  trControl = myControl
)

# Fit random forest: model_rf
model_rf <- train(
  x = churn_x, y = churn_y,
  metric = "ROC",
  method = "ranger",
  trControl = myControl
)
```
T
he function `resamples()` provides a variety of methods for assessing which of two models is the best for a given dataset. 

Example code:

```r
model_list <- list(
  glmnet = model_glmnet,
  rf = model_rf
)

# Collect resamples from the CV folds
resamp <- resamples(model_list)
summary(resamps)
```
You can compare models in caret using the resamples() function, provided they have the same training data and use the same trainControl object with preset cross-validation folds. resamples() takes as input a list of models and can be used to compare dozens of models at once (though in this case you are only comparing two models). We can than plot the results by using somthing like:

```r
dotplot(lots_of_models, metric = "ROC")
```
In general, you want the model with the higher median AUC, as well as a smaller range between min and max AUC.

Another useful plot for comparing models is the scatterplot, also known as the xy-plot. This plot shows you how similar the two models' performances are on different folds.

It's particularly useful for identifying if one model is consistently better than the other across all folds, or if there are situations when the inferior model produces better predictions on a particular subset of the data.

```r
# Create xyplot
xyplot(resamples, metric = "ROC")
```

`caretEnsemble` provides the caretList() function for creating multiple caret models at once on the same dataset, using the same resampling folds. You can also create your own lists of caret models.