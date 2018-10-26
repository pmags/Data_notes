---
PageTitle: Generalized Linear Models in R
---
# Generalized Linear Models in R
## Chapter 1: GLM's an extension of your regression box
Linear models are the statistical workhorses and include common tools such as linear regression, ANOVA and t-tests. Linear Models seek to explain variability by estimating coefficients for predictor variables, Intercept for baseline effect, slopes model changes caused by continuous predictors.

Linear models assume residuals are normally distributed and they work best with continuous repose variables.

**Generalized Linear Models:**
- Are similar to linear models
- Can have non-normal error distribution
- Have non linear link functions which link the regression coefficients to the distribution and allows the linear model to be generalized. 

We use the function `glm()` to define a GLM in R. Compared to the `lm()` function we have to had a `family = ()` argument referring to the class of model we are using. If we set `familiy = gaussian` meaning that errors follow a normal distribution, them the resulting model from GLM would equal the linear model. We can say that a _linear model is a special case of a generalized linear model_.

**Poisson regressions** are a GLM used to model _count data_. When the count is very high we can assume some form of normality, but that is not what happens in most cases. Poisson distributions only have positive integers and lack symmetry near zero. **In a Poisson distributions, the mean and variance are the same parameter, lambda $\lambda$**.

For a fixed time interval and area, the probability of $x$ observations are a function of $\lambda$ and $x$: $P(x)=\frac{\lambda^x e^{-\lambda}}{x!}$. _We could use the poisson to model the number of goals scored in one game._

**Poisson using R**

The `pois()` family of functions calls the poisson distribution (remember that poisson distribution is defined by lambda). The function `dpois(x = ..., lambda =...)` gives the probability of $x$ observations given lambda.

Using the `glm` function we can set a model to follow the Poisson distribution as follows:

```R
glm(y ~ x, data = dat, family = "poisson")
```

_When our data is not made of counts or includes negatives values, than we cannot fit a poisson model. Likewise, if you have a non-constant sample arae or time, if your mean is bigger than 30 or have an over-dispersed data the poisson is not advisable either_

> This exercise will show you how R's formulas allow two types of intercepts to be estimated. You will use data for the number of goals per game for two players, "Scoring Sam" and "Unlucky Lou". Because these are counts, use a glm() with a Poisson family. First, fit a model that estimates the difference between the two players. Second, fit a model that estimates the effect (or intercept) of both players.

```R
# Fit a glm() that estimates the difference between players
summary(glm(goal ~ player,data = scores, family = "poisson"))

# Fit a glm() that estimates an intercept for each player 
summary(glm(goal ~ player-1,data = scores,family = "poisson"))
```
We will use the tidy function from the `broom package`. This creates a tidy output for each of the models. 

```R
# build your models
lmOut <- lm(Number ~ Month, data = dat) 
poissonOut <- glm(Number ~Month, data = dat, family = "poisson")

# examine the outputs using print
print(lmOut)
print(poissonOut)

# examine the outputs using summary
summary(lmOut)
summary(poissonOut)

# examine the outputs using tidy
tidy(lmOut)
tidy(poissonOut)

 term    estimate std.error   statistic      p.value
1  (Intercept) -2.04425523 0.1458649 -14.0147211 1.266950e-44
2       Month2 -0.34775767 0.2313754  -1.5030017 1.328386e-01
3       Month3 -0.93019964 0.2718605  -3.4216069 6.225225e-04
4       Month4 -0.58375226 0.2444136  -2.3883786 1.692290e-02
5       Month5 -0.29111968 0.2214820  -1.3144168 1.887060e-01
6       Month6 -0.40786159 0.2313755  -1.7627694 7.793940e-02
7       Month7 -0.04599723 0.2074017  -0.2217784 8.244864e-01
8       Month8 -0.50734279 0.2361341  -2.1485371 3.167111e-02
9       Month9 -0.20426264 0.2181563  -0.9363134 3.491118e-01
10     Month10 -0.54243411 0.2387272  -2.2721923 2.307490e-02
11     Month11 -0.20426264 0.2181564  -0.9363130 3.491121e-01
12     Month12 -0.19481645 0.2166046  -0.8994106 3.684340e-01

```
Sometime, we specifically care about model coefficients and their confidence intervals. The `coef()` function extracts coefficients and `confint()` extracts the confidence intervals. 

```R
# Extract the regression coefficients
coef(poissonOut)

(Intercept)      Month2      Month3      Month4      Month5      Month6 
-2.04425523 -0.34775767 -0.93019964 -0.58375226 -0.29111968 -0.40786159 
     Month7      Month8      Month9     Month10     Month11     Month12 
-0.04599723 -0.50734279 -0.20426264 -0.54243411 -0.20426264 -0.19481645

# Extract the confidence intervals
confint(poissonOut)

                2.5 %      97.5 %
(Intercept) -2.3444432 -1.77136313
Month2      -0.8103027  0.10063404
Month3      -1.4866061 -0.41424128
Month4      -1.0762364 -0.11342457
Month5      -0.7311289  0.14051326
Month6      -0.8704066  0.04053012
Month7      -0.4542037  0.36161360
Month8      -0.9807831 -0.05092540
Month9      -0.6367321  0.22171492
Month10     -1.0218277 -0.08165226
Month11     -0.6367321  0.22171492
Month12     -0.6237730  0.22851779
```

As a reality check, the `coef()` output for a coefficient should fall within the confidence interval. If it does not, something is wrong.

## Chapter 2: Logistic Regression
Many data scientist often use logistic regression to model data with two possible outcomes. We can use a logistic regression to model behavior for passing a test, winning a coin toss or winning a sports game.

Logistic regression is a special type of binomial GLM. First, the model estimates the probability $p$ of a binary outcome $y$. 
$$Y = \text{Binomial}(p)$$

Second, this probability is linked to a linear equation using the `logit` function. The logit function takes probabilities, which are bounded by zero and one and links or transforms the probabilities to real numbers from negative to positive infinity.
$$\text{Logit}(p)= \beta_{0}+ \beta_{1}x+\epsilon $$
$$\text{Logit}(p)=\log\left 
                (\frac{p}{1-p}
                \right)$$

We can code a Logit regression using the following code:
```R
glm( y ~ x, data = dat, family = "binomial")
```
This means, the errors distribution is binomial. Please check to more on binomial distributions ([link](https://github.com/pmags/data_notes/blob/master/Datacamp/Foundations%20of%20Proability%20in%20R.md))

 For logistic regression, a positive coefficient indicates the probability of an event occurring increases as a predictor increases.

 `Binomial` and `Bernoulli` distributions are the foundations for logistic regressions. 
 
 The Bernoulli distribution models a single event such as a coin flip. The expected or mean probability of this outcome depends upon the number of times we repeat the event (k), as well as the probability of the event.

 $$f(k,p) = p^k(1-p)^{1-k}$$

 The Binomial distribution is closely related to the Bernoulli, but models multiple events occurring at the same time(for example, multiple coins).

  $$f(k,n,p) = (^n_{k})p^k(1-p)^{n-k}$$

  In R we can generate a random distribution as such:
```R
rbinom(n =..., size = ..., p = ...)
```
Where:
- n:number of random numbers to generate
- size: Number of trials
- p: Probability of "success"
- size = 1: Bernoulli size > 1 than is a binomial distribution.

**A Bernoulli distribution is a special case of a binomial.**
The following are alternatives for fitting logistic regression. The interesting part to focus is that, instead of predicting with an individual approach, in this case it looks by groups. Lets take the example as `a`and `b` as being two students and we are predicting their success rate. They failed and succeed at a number of exams and we are modeling has to given a new exam o any, who would succeed.

```
  x fail success Total successProportion
    1 a   12       2    14         0.1428571
    2 b    3      11    14         0.7857143
```
For the second approach, model a 2 column matrix of success and failures (e.g., number of no's and yes's per group). In this format, use the formula `cbind(success, failure) ~ predictor`.

For the third approach, model the probability of success (e.g., group 1 had 75% yes and group 2 had 65% no) and the weight or number of observations per group (e.g., there were 40 individuals in group 1 and 100 individuals in group 2).

In this format, the formula `proportion of successes ~ response `variable is used with `weights = number in treatment`.

```R
# Fit a wide form logistic regression
lr_2 <- glm(cbind(success,fail)~x, data=dataWide ,family = "binomial")

# Fit a a weighted form logistic regression
lr_3 <- glm(successProportion ~ x, data = dataWide, family = "binomial", weights = Total)
```

When building models, you want to have more observations than parameters that are estimated for the model. These extra variables are called degrees of freedom. In statistics, the number of degrees of freedom is the number of values in the final calculation of a statistic that are free to vary. The number of independent ways by which a dynamic system can move, without violating any constraint imposed on it, is called number of degrees of freedom. In other words, the number of degrees of freedom can be defined as the minimum number of independent coordinates that can specify the position of the system completely.

**Probit vs Logit link**
Probit = **Pro**bability Un**it**

The probit assumes, as the logit model a binomial distribution but has a different link function:

$$\Phi^{-1}(p) = \beta_{0}+ \beta_{1}x+ \epsilon$$

In R to generate a probit we change the argument family in the `glm()` function to `family = binomial(link = "probit")`. The standard for this argument is logit.

_Simulate with probit:_
- Convert from probit scale to probability scale:
```R
p = pnorm(-0.2)
```
- Use probability with binomial distribution
```R
rbinom(n = 10, size = 1, prob = p)
```

_Simulate with logit:_
- Convert for logit scale to probability scale:
```R
p = dlogis(-0.2)
```
- Use probability with a binomial distribution
```R
rbinom (n=10, size = 1, prob = p)
```
## Chapter 3: Interpreting and visualizing GLMs
Linear model coefficients that have the same units are additive. On a Poisson model, coefficients are multiplicative.

Poisson model: $e^{\beta_{0} \cdot \beta_{m}}$ = expected daily injuries for month _m_

Linear model: $\beta_{0} + \beta_{m}$ = expected daily injuries for month _m_

Using R code:
```R
# using poisson
poissonOut <- glm(y ~ x, family = "poisson")
coef(poissonOut)
exp(coef(poissonOut))

#or
tidy(poissonOut, exponentiate = TRUE)
```

Plotting a Poisson regression with `geom_smooth()` works best with continuous predictor variables. Otherwise, use boxplots or similar plotting tools.

Example of a plot:

```R
ggplot(data = dat, aes(x = dose, y= cells))+
  geom_jitter(width = 0.05, height = 0.05)+
  geom_smooth(method = "glm", method.args = list(family = "poisson"))
```

If the confidence interval includes 1.0, the odds-ratio is no significantly different than zero.

In case of factors the following code can transform into numerical data:

```R
bus$Bus2 <- as.numeric(bus$Bus)-1
```
Code for plot a binomial (logistic regression)
```R
ggJitter +
  geom_smooth(method = "glm", method.args = list(family = "binomial))
```
## Chapter 4: Multiple regression with GLMs
Theorical maximum number of coefficients: Number of $\beta$s = Number of samples.
Over fitting: using too many predictors compared to number of samples.

The order of predictor variables can be important when there is significant correlation between them.

Overdispersion is an assumption of this models (check data balance).

```R
# build a binomial glm where Admitted and Rejected are predicted by Gender
glm1 <- glm(cbind(Admitted, Rejected) ~ Gender, family = 'binomial', data = UCBdata)
summary(glm1)
# build a binomial glm where Admitted and Rejected are predicted by Gender and Dept
glm2 <- glm(cbind(Admitted, Rejected) ~ Gender + Dept, family = 'binomial', data = UCBdata)
summary(glm2)
```