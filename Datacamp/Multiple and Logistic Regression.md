---
PageTitle: Multiple and Logistic regression
---
# Multiple and Logistic regression
## Chapter 1 - Parallel Slopes
We will learn how to expand linear model to include an arbitrary number of explanatory variables, which can be a mixture of numeric and categorical. We will talk about logistic regression which allows us to model a binary response variable.

**Parallel slopes model:** These models occur when one of the explanatory variables is numeric, and the other is categorical. We use the `lm()` function to fit linear models to data. A parallel slopes model has the form `y ~ x + z`, where `z` is a categorical explanatory variable, and `x` is a numerical explanatory variable.

Applying `augment()` to our model will return a data frame with the fitted values attached. In order to add this information into the scatterplot we had the following expression to ggplot:

```R
data_space+
    geom_line(data = augment(mod), aes(y = .fitted,color = factor.year,))
```

Parallel slopes models are so-named because we can visualize these models in the data space as not one line, but two parallel lines. To do this, we'll draw two things:

* a scatterplot showing the data, with color separating the points into groups
* a line for each value of the categorical variable

Our plotting strategy is to compute the fitted values, plot these, and connect the points to form a line. The `augment()` function from the `broom` package provides an easy way to add the fitted values to our data frame, and the `geom_line()` function can then use that data frame to plot the points and connect them.

The following code is an example of the above:

```R
# Augment the model
augmented_mod <- augment(mod)
glimpse(augmented_mod)

# scatterplot, with color
data_space <- ggplot(augmented_mod, aes(x = wheels, y = totalPr, color = cond)) + 
  geom_point()
  
# single call to geom_line()
data_space + 
  geom_line(aes(y = .fitted))
```
In the above code we have created a scatterplot using the observation but by giving the data from the augmented model. This allows to use the fitted values to create the line when the condition `geom_line` is used. Had we used the `mod` as model for the plot and the scatterplot would be the same.

**Avoiding misunderstandings on coefficients interpretation:**

* There is only *one* slope
* Pay careful attention to the reference level of our categorical variable
* Units are important. Every coefficient has units that relate to the units of the response variable. **Intercepts are in the same units as the response variable, and slope coefficients are in the units of the response per unit of the explanatory variable.**
* The key feature is that coefficients must be interpreted in the context of the other explanatory variables.

**Examples of correct interpretation:**

```R
Call:
lm(formula = totalPr ~ wheels + cond, data = mario_kart)

Coefficients:
(Intercept)       wheels     condused  
     42.370        7.233       -5.585  
```

The coefficient on `condused` means that the expected price of a used MarioKart is $5.58 less than that of a new one with the same number of wheels.

For each additional wheel, the expected price of a MarioKart increases by $7.23 regardless of whether it is new or used.

Three ways to describe a model:
* Mathematical
* Geometric
* Syntactic

$y = \beta_{0}+ \beta_{1}x_{1}+\beta_{2}x_{2}+\epsilon$

The coefficients of the model allow us to translate our knowledge about $x$ into information about $y$. A statistical model will always include an error term that captures our uncertainty.

## Chapter 2 - Evaluating and extending parallel slopes model
In order to know who good of a fit is a model we measure the difference between actual value of the response variable and the fitted value from our model. **This distance is called a residual.**

Recall: $R^2 = 1 - \frac{SSE}{SST}$ when $SSE$ gets smaller $\Rightarrow R^2$ increases. SSE is Sum of Squared Errors and SST is the total sum of squares. It measures the percentage of the variability in the response variable that is explained by the model. 

In general a higher $R^2$ would be a sign of a better model fit, but this is a very tricky indicator because increasing the explanatory variables will always increase the indicator value. Therefore, model fits in multiple regression are often compared using the adjusted R squared value defined here:

$$R^2_{adj}= 1 - \frac{SSE}{SST} * \frac{n-1}{n-p-1}$$

Being $p$ the number of explanatory variables. Both this measure show when using the `summary()` function.

Retrieving the fitted values produced by a model can be done in two different ways:

1. The `predict()` function will return the fitted values as a vector
2. The `augment()` function from the broom package will return a data.frame that contains the original observations, the fitted values, the residuals, and several other diagnostic computations.

What if we allow the slope of the variables to not be parallel? This would happen if instead of fix one of the variables we will let it float and interact with the other explanatory variable ([Modeling part 1](D:\Mosaic_Repo\data_notes\Datacamp\statistical_modeling_in_r(part1).md)). Mathematicaly the following would happen:

$$mpg = \beta_{0}+\beta_{1} \cdot displ+\beta_{2} \cdot is\_newer +\beta_{3} \cdot displ\cdot is\_newer $$

Compared to earlier models, in this case both slopes and intercepts are different. 

Including an interaction term in a model is easy---we just have to tell `lm()` that we want to include that new variable. An expression of the form

```R
lm(y ~ x + z + x:z, data = mydata)
```
The use of the colon `(:)` here means that the interaction between x and z will be a third term in the model. 

The following code uses ggplot to visualize:

```R
ggplot(mario_kart, aes(y = totalPr, x = duration, color = cond)) + 
  geom_point() + 
  geom_smooth(method = "lm" , se =FALSE )
```
In this code a new line is added to the ggplot function, the `geom_smooth` which adds the smoothing lines. For the output we added the argument `method = "lm"` to define that this is a linear regression model and the argument `se = FALSE` otherwise it would include a visual representation of the confidence interval. 

![Correlation_model_plot](images\MLR_image1.png)

> Watch out for simpson paradox! When it is present, the direction of the relationship between two variables changes if subgroups are considered. When it appears the group is an important confounder that must be controlled for in order to build an appropriate model.

> _Quote from course: A mild version of Simpson's paradox can be observed in the MarioKart auction data. Consider the relationship between the final auction price and the length of the auction. It seems reasonable to assume that longer auctions would result in higher prices, since---other things being equal---a longer auction gives more bidders more time to see the auction and bid on the item._
> 
> _However, a simple linear regression model reveals the opposite: longer auctions are associated with lower final prices. The problem is that all other things are not equal. In this case, the new MarioKarts---which people pay a premium for---were mostly sold in one-day auctions, while a plurality of the used MarioKarts were sold in the standard seven-day auctions._
> 
> _Our simple linear regression model is misleading, in that it suggests a negative relationship between final auction price and duration. However, for the used MarioKarts, the relationship is positive._

## Chapter 3 - Multiple Regression
Until this point have been only adding categorical variables to our model. We will now add numeric explanatory variables, so this is not a parallel slopes model (where one categorical variable is made constant). Although, mathematical and syntax formula is similar to the one used with categorical variable, the visual formulation of this models become trickier now that we leave the $R^2$ dimension space. (ggplot only handles 2D graphics).

One way of plotting a 3D model is to **Tile the plane** that is, we will create a 2D plot that covers all combination of our two explanatory variables, and we will use color to reflect the corresponding fitted values.

One method for visualizing a multiple linear regression model is to create a heatmap of the fitted values in the plane defined by the two explanatory variables. This heatmap will illustrate how the model output changes over different combinations of the explanatory variables.

This is a multistep process:

- First, create a grid of the possible pairs of values of the explanatory variables. The grid should be over the actual range of the data present in each variable. 

- Use `augment()` with the `newdata` argument to find the $y$'s corresponding to the values in `grid`.

- Add these to the `data_space` plot by using the `fill` aesthetic and `geom_tile()`.

Example code

```R
grid <- babies %>%
  data_grid(
    gestation = seq_range(gestation, by = 1)
    age = seq_range(age, by = 1)
  )

mod <- lm(bwt ~ gestation + age, data = babies)

bwt_hats <- augment(mod, newdata = grid)
```
We them use the `geom_tile()` functiom to superimpose these values on our data space.

```R
data_space + 
  geom_tile(data = bwt_hats, aes(fill= .fitted), alpha = 0.5) +
  scale_fill_continuous("bwt", limits = range (babies$bwt))
```

Another option would be to represent a plane over a cloud of points. That means, using a 3D model. This can be done by using the `plotly` package.

The following code will create a 3D representation of the relation between the total price `totalPr` and the explanatory variables `duration` and `startPr`

```R
# draw the 3D scatterplot
p <- plot_ly(data= mario_kart, z=~totalPr, x=~duration, y=~startPr,opacity=0,6)
  %>% add_markers

# draw the plane
p %>% add_surface (x= ~x, y= ~y, z= ~plane, showscale = FALSE)
```
Please notice that the `plotly` package uses pipes as default connectors.

Lets consider the fitted model for gestation presented before:

$$bwt = -15.5226 + 0.4676 Gestation +0.1657 Age$$

Since both our explanatory variables are numeric, the coefficients of both represent slopes, and because our model is a plane and not a line, our model can have more than one slope. The slope of **0,47** onces per day on gestation reflects the slope of the plane for a fixed number of age. Meaning, for a mother of 30 yr each day increases 0,47 onces. Because this relation does not change depending on the age we often say that it **reflects the effect of gestational length upon birthweight, while holding age constant.**

Coefficients from a multivariate model is not directly comparable since they have different units.

When adding a third variable, in this case a categorical variable, we have a parallel plane model.

`lm(bwt ~ . -case, data = babies)` can be read as fitting a linear model including all variables in the data frame except for case.

## Chapter 4 - Logistic Regression
When our response variable is binary, a regression model has several limitations. Among the more obvious---and logically incongruous---is that the regression line extends infinitely in either direction. This means that even though our response variable $y$ only takes on the values 0 and 1, our fitted values $\hat{y}$ can range anywhere from $-\infty$ to $\infty$ . 

Logistic regression models are good to fit for categorical or binary variables.

Because most categorical variables consist of words the following code chunk is an example of how to transform them into binary variables:

```R
heartTr <- heartTr %>%
  mutate(is_alive = ifelse(survived == "alive",1,0))
```
If we would to fit a linear model for a binary variable prediction could end up being not between 0 and 1. Therefore, for this kind of variables we should use a model family called **Generalized Linear Models** (GLM)
- Generalization of multiple regressions
  
  - model non-normal responses 
- special case: logistic regression

  - models binary response 

> A full treatment of GLMs is beyond the scope of this course, but the basic idea is that you apply a so-called link function to appropriately transform the scale of the response variable to match the output of a linear model.

The link function used by the logistic regression is the _logit_ function. This constrains the fitted values of the model to always lie between 0 and 1, as a valid probability must.

$$logit(p) = \log \left( \frac{p}{1-p} \right) = \beta_{0}+\beta_{1}*x$$

Example code to fit a GLM function:

```R
glm(is_alive ~ age, data = hearTr, family = binomial) 
```
Compared to the fitting a linear model using R, the two differences are the function, which know is `glm` and the fact that you have to define a function family. In order to define a logistic regression we should use the `binominal` family which in turn uses the logit function as a link function. (The terminology stems from the assumption that our binary response follows a binomial distribution)<sup>[1]</sup>.

The following example tries to fit a linear model into a binary variable:

```R
# scatterplot with jitter
data_space <- ggplot(data = MedGPA, aes(y = Acceptance, x = GPA)) + 
  geom_jitter(width = 0, height = 0.05, alpha = 0.5)

# linear regression line
data_space + 
  geom_smooth(method="lm", se= FALSE)
```
Notice that the `geom_smooth` function creates the linear line on the model. The result is as follows:

![Linear model on a binary variable](images\MLR_image2.png "Linear model on a binary variable")

### Visualize Logistic models:
Our logistic regression model can be visualized in the data space by overlaying the appropriate logistic curve. We can use the geom_smooth() function to do this. Recall that geom_smooth() takes a method argument that allows you to specify what type of smoother you want to see. In our case, we need to specify that we want to use the glm() function to do the smoothing.

The following code uses the `geom_smooth` from `ggplot` to plot a logistic regression:

```R
# scatterplot with jitter
data_space <- ggplot(data = MedGPA, aes(y = Acceptance, x = GPA)) + 
  geom_jitter(width = 0, height = 0.05, alpha = 0.5)

# add logistic curve
data_space +
  geom_smooth(method = "glm", se = FALSE, method.args = list(family = "binomial"))
```

**Is very important to notice that when compared to using this function with linear models, in this case a family argument has to be added. In order to achieve that we include a method.args which allows to list a number of arguments from the glm model, in this case the family**

One of the difficulties in working with a binary response variable is understanding how it "changes." The response itself ($y$) is either 0 or 1, while the fitted values ($\hat{y}$)---_which are interpreted as probabilities_---are between 0 and 1

```R
# binned points and line
data_space <- ggplot(data = MedGPA_binned, aes(x = mean_GPA, y = acceptance_rate)) + 
  geom_point() + geom_line()

# augmented model
MedGPA_plus <- mod %>%
  augment(type.predict = "response")

# logistic model on probability scale
data_space +
  geom_line(data = MedGPA_plus, aes(x = GPA, y = .fitted), color = "red")
```
![MLR_image3](images\MLR_image3.png "Fitted with bins")

Is very important to note that in this case we included in the augment function the argument `type.predict = "response"`. By introducing this argument our fitted model generates the probability that we which no analyse. Otherwise we would end up with the result for the _logit_ link function

In order to make visual representations easier is common to sometimes transform the scale from probability to odds:

$$\hat{y} = \frac{\hat{y}}{1-\hat{y}} = \exp(\hat{\beta}_{0}+\hat{\beta}_{1}* x)$$

While these two concepts are often conflated, they are not the same. **The odds of a binary event are the ratio of how often it happens to how often it doesn't happen**. While the odds scale is more useful than the probability scale for certain things, it isn't entirely satisfying. Statisticians regularly use the log odds scale which allows for a linear representation.

This 3 scales have pros and cons:

- **Probability scale**: intuitive, easy to interpret but function non linear and hard to interpret
- **Odds scale**: the scale is harder to interpret and the function is exponential and hard. **On the odds scale, a one unit change in $x$ leads to the odds being multiplied by a factor of $\beta_{1}$**.
- **Log-odds scale**: the scale is impossible to interpret but the function is linear and easy to interpret

In the Odds scale, the coefficients are $exp \beta_{1}$. If its above 1 and increase represents an increase in the odds.Most people tend to interpret the fitted values on the probability scale and the function on the log-odds scale. The interpretation of the coefficients is most commonly done on the odds scale.

The following code changes the scales into odd scale of a previous regression (see above):

```R
# compute odds for bins
MedGPA_binned <- MedGPA_binned %>% mutate(odds = acceptance_rate/(1-acceptance_rate))

# plot binned odds
data_space <- ggplot(data = MedGPA_binned, aes(y = odds, x=mean_GPA))
    +geom_point()+geom_line()

# compute odds for observations
MedGPA_plus <- MedGPA_plus %>% mutate(odds_hat = .fitted/(1-.fitted))

# logistic model on odds scale
data_space +
  geom_line(data = MedGPA_plus,aes(x=GPA,y=odds_hat), color = "red")
```
![MLR_image4](images\MLR_image4.png "odds scale")

One important reason to build a model is to learn from the coefficients about the underlying random process.

Models are commonly used to predict results for "out of the data" values. The following code make predictions using the `augmented()` function

```R
# create new data frame
new_data <- data.frame(GAP = 3.51)

# make predictions
augment(mod, newdata = new_data,type.predict = "response")
```
However, note that while our response variable is binary, our fitted values are probabilities. Thus, we have to round them somehow into binary predictions. While the probabilities convey more information, we might ultimately have to make a decision, and so this rounding is common in practice. There are many different ways to round, but for simplicity we will predict admission if the fitted probability is greater than 0.5, and rejection otherwise.

When predicting values using the predict type `response` the results will turn out to be probabilities. Nonetheless our population data has binary responses. In order to transform we need to set a treshold to transform probabilities into binary answers. The following code is a simple example that converts to 1 every value above 0.5. Take into consideration that the use of the function `round()` makes sense in this case because of the treshold. Otherwise we could use `ifelse()`.

```R
# data frame with binary predictions
tidy_mod <- augment(mod, type.predict="response") %>% mutate(Acceptance_hat = round(.fitted))
  
# confusion matrix
tidy_mod %>%
  select(Acceptance, Acceptance_hat) %>% 
  table()

            Acceptance_hat
Acceptance  0  1
         0 16  9
         1  6 24

```

## Chapter 5 - Case Study: Italian restaurants in NYC
The `pairs()` function generates a visual relation between variables that are part of our database.

The following code calculates the average price for a meal on a east or west side restaurant

```R
nyc %>%
  group_by(East) %>%
  summarize (mean_price = mean(Price))

# A tibble: 2 x 2
    East  mean_price
1   0     40.43
2   1     33.01
```
The following code chunk includes an example of a 3D graphic for a linear model. 

```R
# fit model
lm(Price ~ Food + Service, data = nyc)

# draw 3D scatterplot
p <- plot_ly(data = nyc, z = ~ Price, x = ~ Food, y = ~ Service, opacity = 0.6) %>%
  add_markers() 

# draw a plane
p %>%
  add_surface(x = ~x, y = ~y, z = ~ plane, showscale = FALSE) 

```

**Multicollinearity**
- Explanatory variables are highly correlated
- Unstable coefficient estimates
- Doesn't affect $R^2$
- Be skeptical of surprising results

The following code creates a parallel planes 3D graphic which represents the difference by location:

```R
# draw 3D scatterplot
p <- plot_ly(data = nyc, z = ~Price, x = ~Food, y = ~Service, opacity = 0.6) %>%
  add_markers(color = ~factor(East)) 

# draw two planes
p %>%
  add_surface(x = ~x, y = ~y, z = ~plane0, showscale = FALSE) %>%
  add_surface(x = ~x, y = ~y, z = ~plane1, showscale = FALSE)
```

## Chapter 6 - Additional interpretation of logistic regression
Everything starts with the concept of probability.  Let’s say that the probability of success of some event is .8.  Then the probability of failure is 1- .8 = .2.  The odds of success are defined as the ratio of the probability of success over the probability of failure.  In our example, the odds of success are .8/.2 = 4.  That is to say that the odds of success are  4 to 1.  If the probability of success is .5, i.e., 50-50 percent chance, then the odds of success is 1 to 1. **Odds increase as the probability increases or vice versa**. The transformation from odds to log odds is the **log transformation**.

Why do we take all the trouble doing the transformation from probability to log odds?  One reason is that it is usually difficult to model a variable which has restricted range, such as probability.  This transformation is an attempt to get around the restricted range problem.  It maps probability ranging between 0 and 1 to log odds ranging from negative infinity to positive infinity.  Another reason is that among all of the infinitely many choices of transformation, the log of odds is one of the easiest to understand and interpret.  This transformation is called logit transformation.  


---
###### [1]: _Binomial distribution:_ In probability theory and statistics, the binomial distribution with parameters n and p is the discrete probability distribution of the number of successes in a sequence of n independent experiments, each asking a yes–no question, and each with its own boolean-valued outcome: a random variable containing a single bit of information: success/yes/true/one (with probability p) or failure/no/false/zero (with probability q = 1 − p). A single success/failure experiment is also called a Bernoulli trial or Bernoulli experiment and a sequence of outcomes is called a Bernoulli process; for a single trial, i.e., n = 1, the binomial distribution is a Bernoulli distribution. The binomial distribution is the basis for the popular binomial test of statistical significance. [link to wikipedia](https://en.wikipedia.org/wiki/Binomial_distribution). 