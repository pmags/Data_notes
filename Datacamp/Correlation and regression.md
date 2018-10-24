---
PageTitle: Correlation and regression
---
# Correlation and regression
## Chapter 1: Visualizing two variables
This course focus on the relationship between two numerical variables.

**Bivariate analysis** is one of the simplest forms of quantitative (statistical) analysis, It involves the analysis of two variables for the purpose of determining the empirical relationship between them. Bivariate analysis can be helpful in testing simple hypotheses of association. Bivariate analysis can help determine to what extent it becomes easier to know and predict a value for one variable (possible a dependent variable) if we know the value of the other variable (possibly the independent variable).

The **scatter plot** is one of the main and simplest way to visualize a relation between two numerical variables. Code example using the `ggplot()` package:

```R
ggplot(data = possum, aes(y=totalL, x = tailL)) +
    geom_point()+
    scale_x_continuous("some text")+
    scale_y_continuous ("some text")
```
Scatterplots are the most common and effective tools for visualizing the relationship between two numeric variables.

Can think of _boxplots_ as a generalization of a _scatterplot_ but with discretized explanatory variable. This can be achieved in R using the `cut()` function which takes a numerical variable and cuts into descrite chunks. The following is an example creating 5 groups depending on their tails:

```R
ggplot(data=possum, ase(y=totalL,x=cut(tailL, break = 5)))+
    geom_boxplot()
```
The `cut()` function takes two arguments: the continuous variable you want to discretize and the number of `breaks` that you want to make in that continuous variable in order to discretize it.

The patterns and diviation from those patterns that are given to us by these visual representations can give us some insight into the relationship between variables. Specificaly we look for 4 things:

- form (eg.linear, quadratic, non-linear)
- direction (eg. positive, negative)
- strenght
- outliers

![image_1](images/Correlation_reg_image1.png)

This a **linear, negative and moderately string relationship**.

The relationship between two variables may not be linear. In these cases we can sometimes see strange and even inscrutable patterns in a scatterplot of the data. Sometimes there really is no meaningful relationship between the two variables. Other times, a careful transformation of one or both of the variables can reveal a clear relationship.

`ggplot2` provides several different mechanisms for viewing transformed relationships. The `coord_trans()` function transforms the coordinates of the plot. Alternatively, the `scale_x_log10()` and `scale_y_log10()` functions perform a base-10 log transformation of each axis.

```R
# Scatterplot with coord_trans()
ggplot(data = mammals, aes(x = BodyWt, y = BrainWt)) +
  geom_point() + 
  coord_trans(x = "log10", y = "log10")

# Scatterplot with scale_x_log10() and scale_y_log10()
ggplot(data = mammals, aes(x = BodyWt, y = BrainWt)) +
  geom_point() +
  scale_x_log10() + scale_y_log10()

```
Before the transformation:
![image_2](images/Correlation_reg_image2.png)

After the transformation where we can see a linear relation between the log values

![image_3](images/Correlation_reg_image3.png)

## Chapter 2: Correlation
Correlation is a way to quantify the linear relation between 2 variables. The correlation coefficient is a number between -1 and 1 that measures the strenght of a linear relation. The sign corresponds to the direction of the relation.

Correlation coefficients closer to zero means that there is no linear relation. Notice that this only measures linear relationships and not other non-linear forms.

**Pearson product-moment correlation:** 

$$r(x,y) = \frac{Cov(x,y)}{\sqrt{SXX \cdot SYY}}$$

$$r(x,y) = \frac{\sum_{i=1}^n(x_{i}-\overline{x})(y_{i}-\overline{y}))}{\sum_{i=1}^n(x_{i}-\overline{x})^2\cdot\sum_{i=1}^n(y_{i}-\overline{y})^2}$$

The `cor(x, y)` function will compute the Pearson product-moment correlation between variables, `x` and `y`. Since this quantity is symmetric with respect to `x` and `y`, it doesn't matter in which order you put the variables. Setting the `use` argument to "pairwise.complete.obs" allows `cor()` to compute the correlation coefficient for those observations where the values of `x` and `y` are both not missing.

Code example to use summarise

```R
# Compute correlation for all non-missing pairs
ncbirths %>%
  summarize(N = n(), r = cor(weight, weeks, use = "pairwise.complete.obs"))
```

In 1973, Francis Anscombe famously created four datasets with remarkably similar numerical properties, but obviously different graphic relationships. 

Summary for each data set:

```R
# Compute properties of Anscombe
Anscombe %>%
  group_by(set) %>%
  summarize(N = n(), mean(x), sd(x), mean(y), sd(y), cor(x,y))

# A tibble: 4 x 7
  set       N `mean(x)` `sd(x)` `mean(y)` `sd(y)` `cor(x, y)`
  <chr> <int>     <dbl>   <dbl>     <dbl>   <dbl>       <dbl>
1 1        11         9    3.32      7.50    2.03       0.816
2 2        11         9    3.32      7.50    2.03       0.816
3 3        11         9    3.32      7.5     2.03       0.816
4 4        11         9    3.32      7.50    2.03       0.817
```
Nonethless, when ploted we can see that the 4 sets show a very different reality.

![image_4](images/Correlation_reg_image4.png)

**Correlation does not implies causation. Correlation is a simple bivariance statistic and cannot be used fot multivariated regressions.** Just because two variables are evolving in the same directions does not imply that changes in one result from changes in other.

_Statisticians must always be skeptical of potentially spurious correlations. Human beings are very good at seeing patterns in data,sometimes when the patterns themselves are actually just random noise._

## Chapter 3: Simple linear regression
In statistics we use the _least squares criteria_ to evaluate a fit of a line. 

The method of least squares is a standard approach in regression analysis to approximate the solution of overdetermined systems, i.e., sets of equations in which there are more equations than unknowns. "Least squares" means that the overall solution minimizes the sum of the squares of the residuals made in the results of every single equation.

The most important application is in data fitting. The best fit in the least-squares sense minimizes the sum of squared residuals (a residual being: the difference between an observed value, and the fitted value provided by a model). 

The least squares criterion implies that the slope of the regression line is unique. We can add a line that best fits our model by adding argunents to `ggplot`

```R
ggplot(data = possum, ases(y = totalL, x = tailL))+ 
  geom_point() + geom_smooth(method = "lm", se = FALSE)
```
$$response = f(explanatory)+ noise$$

$$Y = \beta_{0} + \beta{1} \cdot X + \epsilon$$

On a linear model we specify that the distribution of the noise is `normal` with `mean = 0` and a `fixed standard deviation`.

**Fitting procedure:**
- Given $n$ observations of pairs $(x_{i},y_{i})$...
- Find $\hat{\beta_{0}},\hat{\beta_{1}}$ that minimize $\sum_{i=1}^n e_{i}^2$
- $e = Y - \hat{Y}$ 
- Y-hat is expected value given corresponding X
- Beta - hats are estimates of true, unknown betas
- Residuals (e's) are estimates of true, unknown epsilons
  
Two facts enable you to compute the slope b1 and intercept b0 of a simple linear regression model from some basic summary statistics.

First, the slope can be defined as:

$$\beta_{1}=r_{X,Y}\cdot\frac{S_{Y}}{S_{X}}$$

where rX,Y represents the correlation (`cor()`) of X and Y and sX and sY represent the standard deviation (`sd()`) of X and Y, respectively.

Second, the point ($\overline{x}$,$\overline{y}$) is always on the least squares regression line, where $\overline{x}$ and $\overline{y}$ denote the average of x and y, respectively.

We are focusing on this course on simple linear regression models, but there are other models that can be used:
- Least squares
- Weighted
- Generalized
- Nonparametric
- Ridge
- Bayesian
- ...

## Chapter 4 - Interpreting regression models
The units of the slope is the units of the explanatory variable by units of the response variable.

While the geom_smooth(method = "lm") function is useful for drawing linear models on a scatterplot, it doesn't actually return the characteristics of the model. As suggested by that syntax, however, the function that creates linear models is lm(). This function generally takes two arguments:

- A formula that specifies the model
- A data argument for the data frame that contains the data you want to use to fit the model

The lm() function return a model object having class "lm". This object contains lots of information about your regression model, including the data used to fit the model, the specification of the model, the fitted values and residuals, etc.

The function `coef()` over a variable of class `"lm"` or any model, returns the fitted coeficients. The function `summary()` genarates a report with fitting statistics of the model.

To access the fitted values we use the function `fitted.values()`. By definition this generates a vector as big as the one used to create the model. The `residuals()` function retrieves the noise or residuals of the difference between the real and fitted values.

The least squares fitting procedure guarantees that the mean of the residuals is zero (n.b., numerical instability may result in the computed values not being exactly zero). At the same time, the mean of the fitted values must equal the mean of the response variable.

The `predict(lm)` when applied to a model, returns the fitted values for existing data. If we had a `newdata` argument than we can predict the results for any new set of data `predict(lm,newdata)`.

The following code allows to include real and predicted values on a plot:

```R
isrs <- broom::augment(mod, newdata=new_data)
ggplot(data=textbooks, aes(x = amazNew, y = uclaNew))+
  geom_point() + geom_smooth(method = "lm")+
  geom_point(data = isrs, aes(y=.fitted),size = 3, color = "red")
```
## Chapter 5 - Model fit
One way to assess strength of fit is to consider how far off the model is for a typical case. That is, for some observations, the fitted value will be very close to the actual value, while for others it will not. The magnitude of a typical residual can give us a sense of generally how close our estimates are.

dure that the mean of the residuals is zero. Thus, it makes more sense to compute the square root of the mean squared residual, or root mean squared error $(RMSE)$. R calls this quantity the residual standard error.

To make this estimate unbiased, you have to divide the sum of the squared residuals by the degrees of freedom in the model. Thus,

$$RMSE = \sqrt{\frac{\sum_{i}e_{i}^2}{d.f.}} = \sqrt{\frac{SSE}{d.f.}} $$

The `Null model` where $\hat{y} = \overline{y}$ is important to use as banchmark against a fitted model. The ratio of the SSE for our model and the SSE (or normaly called SST) for the Null model is a quantification of the variability explained by our model.

$$R^2 = 1- \frac{SSE}{SST}= 1 - \frac{Var(e)}{Var(y)}$$

**Leverage:**
The leverage of an observation in a regression model is defined entirely in terms of the distance of that observation from the mean of the explanatory variable. That is, observations close to the mean of the explanatory variable have low leverage, while observations far from the mean of the explanatory variable have high leverage. Points of high leverage may or may not be influential.


$$h_{i} = \frac{1}{n} + \frac{(x_{i}-\overline{x})^2}{\sum_{i=1}^n(x_{i}-\overline{x})^2}$$

Points that are near to the center of the scatterplot have low leverage while points that far from teh center have high leverage. On the `augment()` fuction they show as `.hat`. Variables with high leverage can change the slope of a regression. This are called `influencers`.

Cook's distance measures influence and can be found on `augment()` function as `.cooksd`.

```R
# Rank points of high leverage
mod %>%
  augment() %>%
  arrange(desc(.hat)) %>%
  head()
```

Observations of high leverage may or may not be influential. The influence of an observation depends not only on its leverage, but also on the magnitude of its residual. Recall that while leverage only takes into account the explanatory variable (x), the residual depends on the response variable (y) and the fitted value (y^).

Influential points are likely to have high leverage and deviate from the general relationship between the two variables. We measure influence using Cook's distance, which incorporates both the leverage and residual of each observation.

Observations can be outliers for a number of different reasons. Statisticians must always be careful—and more importantly, transparent—when dealing with outliers. Sometimes, a better model fit can be achieved by simply removing outliers and re-fitting the model. However, one must have strong justification for doing this. 
