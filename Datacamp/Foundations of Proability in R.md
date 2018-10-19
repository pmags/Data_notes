---
PageTitle: Foundations of probability in R
---
# Foundations of probability in R
## Chapter 1: The binomial distribution
Statistical inference is the process where you some observed data and you use it to build an underlying model. We will start our study on probabilities with coin flip, or a **binomial distribution.** In order to ask R to simulate this random event we can use the following code `rbinom(1,1,0.5)`.The code `rbinom(10,1,0.5)` runs the simulation 10 times.

>**Binomial distribution:**
>
>$X_{1...n} \sim \text{Binomial}(\text{size},p)$

In the case of a binomial distribution, R provides a way to calculate the exact probability density using the `dbinom(<the outcome we're estimating>,<number of sets>,<probability of 1>)` function.

The cumulative density of a binomial represents the probability of x being less or equal than a number (being x the number of `TRUES` on a given set). The following code gives us this probability:

```R
flips <- rbinom(100000,10,0.5)
mean(flips <= 4)

# or with a direct function
pbinom(4,10,0.5)
```

The following code gives two alternatives to calculate the probability density for a binomial distribution:
```R
# Calculate the probability that 2 are heads using dbinom
dbinom(2,10,0.3)
[1] 0.2334744

# Confirm your answer with a simulation using rbinom
mean(rbinom(10000,10,0.3)==2)
[1] 0.2334744

# Calculate the probability that at least five coins are heads
1-pbinom(4,10,0.3)
[1] 0.1502683

# Confirm your answer with a simulation of 10,000 trials
mean(rbinom(10000,10,0.3)>=5)
[1] 0.1456
```

In statistics when analyzing a distribution we are want to describe it using very specific characteristics. Two that are very important are:

- _Center:_ Where is the distribution center [mean]
- _Spread:_ How spread out is it compared to the center [variance]

The expected value is the mean/average of the distribution. Because we are referring to a binomial distribution we can say that the mean would be at the center of the distribution.

**There is a rule on a binomial distribution where we can get the average of a distribution simply by multiplying the probability of 1 over the number of observations/events.** (meaning, on a binomial distribution with size 20 and p =0.3 the mean is 20*0.3)

In order to measure how spread out is a distribution we use the _variance_ which is the average squared distance of each observation to the mean of the sample. On a binomial variance follows a simple rule:

$$E[x] = \text{size}\cdot p$$
$$Var(x) = \text{size} \cdot p \cdot (1-p)$$

## Chapter 2: Laws of probability
**Probability of A and B**, $Pr(A \ \text{and}\  B)=Pr(A)\cdot Pr(B)$. This is only true if events A and B are independent.

**Probability of or B**, $Pr(A \ \text{or}\  B)=Pr(A) + Pr(B) -Pr(A \ \text{and}\  B)$. 

When we multiply a random variable by a constant number we also multiply the _expected value_ by that number and the variation by the square of that number. In mathematics:

$$E[k \cdot X] = k \cdot E[X]$$
$$Var[k \cdot X] = k^2 \cdot Var[X]$$

**Adding 2 random variables**

Lets use: 

$$X \sim \text{Binom}(10,.5)$$
$$Y \sim \text{Binom}(10,.2)$$
$$Z \sim X + Y$$

The rules for this new variable which is the sum of 2 random variables are as follow:

$$E[X + Y] = E[X] + E[Y]$$
(Even if X and Y aren't independent)
$$\text{Var}[X + Y] =\text{Var}[X] + \text{Var}[Y] $$
(Only if X and Y are independent)

## Chapter 3: Bayesian statistics
Bayesian statistics is a mathematically rigorous method for updating your beliefs based on evidence. 

The following exercise simulates a draw of 11 heads after 20 coin flips. The goal is to simulate if this coin is either fair or bias.

```R
# Simulate 50000 cases of flipping 20 coins from fair and from biased
fair <- rbinom(50000,20,0.5)
biased <- rbinom(50000,20,0.75) 

# How many fair cases, and how many biased, led to exactly 11 heads?
fair_11 <- sum(fair == 11)
biased_11 <- sum(biased == 11) 

# Find the fraction of fair coins that are 11 out of all coins that were 11
fair_11/(fair_11+biased_11)

[1] 0.8600792
```
The second group of code measures how many times (from the 50.000 simulation of 20 flips) did heads came out 11 times. We came to the conclusion that the probability of this coin being fair is of around _86%_.

Prior probability is an important part of bayesian statistics. To calculate the conditional probability of a coin being biased given the prior probability of being biased of 10% we do as follows:

```R
fair <- rbinom(90000,20,0.5)
sum(fair == 14)
# [1] 3410

fair <- rbinom(10000,20,0.75)
sum(fair == 14)
# [1] 1706

1706/(1706+3410) = 0.333
```
We first thought that there was a 10% chance that the coin was biased, but after seeing 14 head out of 20 flips, our probability rose to 33%.

Instead of finding the probability of an event by simulation we can use the `dbinom()` function to give us an exact probability:

```R
fair <- rbinom (90000,20,0.5)
sum(fair == 14)
#[1] 3410

dbinom(14,20,0.5)*0.9
#[1] 0.03326
```

```R
prob_14_fair <- dbinom(14,20,.5)*.9
prob_14_biased <- dbinom(14,20,.75)*.1

prob_14_biased / (prob_14_biased + prob_14_fair)
```

**Bayes' theorem:**

$$\text{Pr}(A|B)=\frac{\text{Pr}(B|A)\cdot \text{Pr}(A)}{\text{Pr}(B|A)\cdot \text{Pr}(A)+\text{Pr}(B|not A)\cdot \text{Pr}(not A)}$$

<span style = color:blue> This means, probability of event $A$ given event $B$ when you know the probability of event $B$ given event $A$. </span> From the above code chunk event $A$ is that it is biased and $B$ is 14 heads. We new the probability of getting 14 heads if the coin was bias (75%), **but what we wanted to know was the probability of the coin be biased given that we got 14 heads**.

## Chapter 4: Related distributions
Until now we have only discuss a binomial distribution. In this chapter we will introduce new probability distributions.

**Normal distributions:**
When you draw from a binomial with a very large size the result approximates a normal distribution. Normal distributions are gaussian distributions (also referred as bell curved distributions)

A normal distribution is defined with two parameters: the mean $\mu$ and the standard deviation $\sigma$.  

$$X \sim \text{Normal} (\mu, \sigma)$$
$$\sigma = \sqrt{Var(X)}$$

From a binomial distribution we can extrapolate a normal distribution given the formulas for expected values and standard deviations seen before. They are a good approximation.

```R
expected_value <- 1000*.5
variance <- 1000 * .5 * (1-.5)
stdev <- sqrt(variance)

normal <- rnorm(100000, expected_value, stdev)
```
The following code compares characteristics of both binomial and normal distribution using simulation and exact probabilities:

```R
# Simulations from the normal and binomial distributions
binom_sample <- rbinom(100000, 1000, .2)
normal_sample <- rnorm(100000, 200, sqrt(160))

# Use binom_sample to estimate the probability of <= 190 heads
mean(binom_sample<=190)

# Use normal_sample to estimate the probability of <= 190 heads
mean(normal_sample<= 190)

# Calculate the probability of <= 190 heads with pbinom
pbinom(190,1000,0.2)

# Calculate the probability of <= 190 heads with pnorm
pnorm(190,200,sqrt(160))
```

**Poisson distribution:**

We are considering how often a rare event happens from a large set of opportunities. The poisson distribution is simpler than the binomial in the extent that it only takes one parameter to describe, the mean $\lambda$.

$$X \sim \text{Poisson}[\lambda]$$
$$E[X] = \lambda$$
$$\text{Var}(X) = \lambda$$

As a Normal distribution resembles a binomial distribution with lots of events (or flips), the poisson resembles a binomial distribution with a very small probability of the event.

A Poisson distribution can have any mean as long as it is positive. The function `rpois(<mean>)` generates a poisson distribution.

One of the useful properties of the Poisson distribution is that when you add multiple Poisson distributions together, the result is also a Poisson distribution. 

**Geometric distribution**
A random variable where you are waiting for a particular event with some probability to happen is called a geometric distribution.

This code allows to generate a vector which indicates all positions where heads has first shown:

```R
replicate(10,which(rbinom(100,1,.1)==1)[1])
```
This distribution is important for example when you know a machine as a 10% probability of breaking each day and you want to know how long it will last until it breaks. We can simulate geometric distributions using the `rgeom(<probability of the event>)` function.

$$X\sim \text{Geom}(p)$$
$$E[X] = \frac{1}{p}-1$$
