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
* The key feature is that coefficients must be interpretted in the context of the other explanatory variables.

**Examples of correct interpretation:**

```R
Call:
lm(formula = totalPr ~ wheels + cond, data = mario_kart)

Coefficients:
(Intercept)       wheels     condused  
     42.370        7.233       -5.585  
```


The coefficient on condused means that the expected price of a used MarioKart is $5.58 less than that of a new one with the same number of wheels.

For each additional wheel, the expected price of a MarioKart increases by $7.23 regardless of whether it is new or used.

Three ways to describe a model:
* Mathematical
* Geometric
* Syntactic

$y = \beta_{0}+ \beta_{1}x_{1}+\beta_{2}x_{2}+\epsilon$

The coefficients of the model allow us to translate our knowledge about $x$ into information about $y$. A statistical model will allways include an error term that captures our uncertainty.