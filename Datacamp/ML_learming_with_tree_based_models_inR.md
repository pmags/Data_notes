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



