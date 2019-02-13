---
TOCtitle: Markdown
PageTitle: Structural Credit Risk Models with Subordinated Process
output: pdfdocument
---
Using Ito's lemma we can obtain the 
# Structural Credit Risk Models with Subordinated Process
 
> url: http://downloads.hindawi.com/journals/jam/2013/138272.pdf
 
# Introduction

The probability of default, as one of the key risk parameters in the IRB approach, has many methodologies for its estimation. In general, we can classify the existing methodologies into three groups: 
- structural models **(this paper focus on this kind of models)**, 
- reduced-form models, 
- and credit-scoring (statistical)models.

Structural models were first introduced by Robert Merton in 1974 largely as a logical extension of the Black-Scholes option pricing framework in 1973. He introduced a model for assessing the credit risk of a company by characterizing a company's equity as a derivative on its assets.

The Merton model requires a number of simplifying assumptions (the company can default only at debt's maturity time $T$ but not before; the model is not able to distinguish among the different types of debt, constant and flat term structure of interest rate, etc.) **Notwthstanding, one of the most drawbacks is assuming that company follows the log normal distribution** (this means that equity follows a log-normal distribution which allows for a connection between the market cap and asset value).


> **Quote:** It is well known that log-returns of equities are not Gaussian distributed, and several empirical investigations have shown that **log-returns of equities present skew distributions with excess kurtosis which leads to a greater density in the tails**<sup>[1]</sup>, and that the normal distribution with a comparatively thinner tail simply cannot describe this phenomenon. (in summary it means that the distribution of equity has lot of instances of outlier and therefore is an event that is prone to extreme outcomes).

This paper challenges and proposes and alternative to the use of distribution on log returns of equities.

## Merton and Subordinated Credit Risk Models
The core concept of the Merton model is to treat company's equity and debt as a contingent claim written on company's assets value. In this framework, the company is considered to have a simple capital structure. It is assumed that the company is financed by one type of equity with a market value $E_{t}$ ate time $t$ and a zero-coupon debt instrument $D_{t}$ with a face value of $L$ maturing at time $T$. (Generally, in a credit risk model framework we assume one-year time horizon for debt maturity and subsequent estimation of PD. One year is perceived as being of sufficient length for a bank to raise additional capital on account of increase in portfolio credit risk).<span style = color:blue> [This is a good and synthetic description of Merton's model]  </span> 

At any $t$ moment the following relation always stands:

$$A_{t} = E_{t} + D_{t}$$

In the Merton framework the value of company's equity at maturity time $T$ is given by:

$$E_{T}=\max[A_{T}-L,0]$$

This means, at maturity the value for the shareholder/owner will be equal to the asset value at maturity $T$ minus the face value of a zero coupon bond, or zero if $A_{T}<L$.

**Merton-Black-Scholes Distributional Assumptions:**

**1. Under the Merton model, the assets values is assumed to follow a geometric Brownian motion (GBM)<sup>[2]</sup>** of the following form:

$$dA_{t}=\mu A_{t}dt + \sigma A_{t}dW_{t} (1)$$

Where $\mu$ is the **expected return (drift coefficient)**, $\sigma$ is the **volatility (diffusion coefficient)**

Using Ito's lemma we can obtain the solutions of **(1)** as follows

 $$A_{T}=A_{t}\exp\left [
        \left(
         \mu - \frac{1}{2}\sigma^2
         \right)\cdot
         \left(
         T-t    
         \right)+
         \sigma\sqrt{(T-t)}W_{t} 
      \right]$$

Where $(T-t)$ is the remaining maturity.
 
In accordance with the Black-Scholes option pricing theory the Merton model stipulates that the company's equity value satisfies the following equation for pricing the call option **within a risk neutral framework**:

$$\begin{cases}
    E_{t} = A_{t}\Phi(d_{1})-Le^{-r(T-t)}\Phi(d2)
    \\
    \\
    d_{1} = \frac{\ln(A_{t}/L) + (r + (1/2)\sigma^2)\cdot(T-t)}{\sigma\sqrt{(T-t)}}
    \\
    \\
    d_{2} = d_{1}-\sigma\sqrt{(T-t)}
\end{cases}$$

Where $r$ is the risk free interest rate and $\Phi(\cdot )$ is the cumulative distribution function of the standard normal variable.

Equation $d_{2} = d_{1}-\sigma\sqrt{(T-t)}$ is also called _**Distance To Default (DD)**_ by Moody's KMV. The larger the number in DD is, the less chance the company will default.

Is important to notice that when we are calculating $PD$ under Merton the risk free interest rate $r$ used to estimate $E_{t}$ has to be replaced with real company drift $\mu$ since this step has nothing to do with option pricing.

**Credit Risk Models with Subordinated Assumptions:**

In the mathematics of probability, a subordinator is a concept related to stochastic processes. A subordinator is itself a stochastic process of the evolution of time within another stochastic process, the subordinated stochastic process. **In other words, a subordinator will determine the random number of "time steps" that occur within the subordinated process for a given unit of chronological time.** In order to be a subordinator a process must be a Lévy process. It also must be increasing, almost surely.

When using subordinated processess, we are usually able to capture empirically observed anomalies which are presented in the evolution of return process over time.

> Notice: Given the subject and the goal for studying this paper we won't pay much attention to the subordinated process.

## Estimation Methodology
In Merton model there are just 3 parameters necessary for the estimation of default probabilities:
- the company's market value $A_{t}$
- the asset drift $\mu$
- and the asset volatility $\sigma$  

Since the **market value of assets** is a random variable and cannot be observed directly, it is impossible to directly estimate the drift and the volatility in a movement of log returns on $A_{t}$. This parameters have to be estimated indirectly using the **market value of equity** $E_{t}$ 

Generally, the starting point for the two interactive methodologies proposed in literature (the maximum likelihood estimation method and the Moody's KMV method) is based on the so-called _calibration method_ which finds two unknown parameters($A_{t}$ and $\sigma$) by solving the system of two equations as follows:

$$\begin{cases}

E_{t} = A_{t}\Phi(d_{1})-Le^{-r(T-t)}\Phi(d_{2})
\\
\\
\sigma_{E}=\frac{A_{t}}{E_{t}}\Phi(d_{1})\sigma
\end{cases}$$

**Where $\sigma_{E}$ is the standard deviation of the equity log returns $\ln(E_{th}/E_{(t-1)h})$.** This method calculates the parameters using $r$ risk free rate instead of the asset drift.

One method to estimate the $\sigma_{A}$ and $\mu$ is the KMV methodology which uses an interactive process to minimize differences.

Given that:
$$\overline{R}^{(i)}=\frac{1}{n}\sum^n_{t=1}\hat{R}^{(i)}_{t}$$


$$\hat{R}=\ln\left( 
    \frac{\hat{A}_{th}}{\hat{A}_{(t-1)h}}
    \right)$$

We generate initial variable estimates using the following formulas:

$$
    \begin{cases}
        \hat{\sigma}^{(i+1)}= \sqrt{\frac{1}{nh}\sum^n_{t=1}(\hat{R}^{(i)}_{t}-\overline{R}^{(i)})^2}     
    \\
    \\
        \hat{\mu}^{(i+1)}= \overline{R}^{(i)}\frac{1}{h}+\frac{1}{2}\hat{\sigma}^{2(i+1)}
    \end{cases}
$$

Therefore the initial estimations are given by calculation standard deviation  compared to the expected value of $\overline{R}$ which is the arithmetic mean of log returns of assets $\hat{R}$. The drift parameter $\mu$ is calculated as half the variation of a given time period. (notice that $h=\frac{1}{250}$) normally  for a daily equity value plus the average historical gain. 

This is an iterative procedure, we use the new estimates obtained to calculate $A_{th}^{(i+1)}$. The procedures is repeated until the differences in $\hat{\mu}$ and $\hat{\sigma}$ among successive iterations are sufficiently small.
 
> For the face value of the zero-coupon debt instrument, **we used the sum of the short-termdebt,** current portion of the long-term debt, **and half of the long-term debt**. (There need to be chosen an amount of the debt that is relevant to a potential default during a one year period. Total debt is inadequate when not all of it is due in one year (it is assumed one-year time horizon for debt maturity and subsequent estimation of PD), as the firm may remain solvent even when the value of assets falls below its total liabilities. Using the short-term debt for the default barrier would be often wrong, for instance, when there are covenants that force the company to serve other debts when its financial situation deteriorates.



---
**[1]: Excess Kurtosis:**

Kurtosis refers to the size of the tails on a distribution. The tails of a distribution measure the number of events which have occurred that are outside of the normal range. 

Excess kurtosis is a statistical term describing that a probability, or return distribution, has a kurtosis coefficient that is larger than the coefficient associated with a normal distribution, which is around 3. **This signals that the probability of obtaining an extreme outcome or value from the event in question is higher than would be found in a probabilistically normal distribution of outcomes**

[Investiopedia link](https://www.investopedia.com/terms/e/excesskurtosis.asp#ixzz5UIbXPVsp )

> It is an important consideration to take when examining historical returns from a stock or portfolio, for example. The higher the kurtosis coefficient is above the "normal level," or the fatter the tails on the return distribution graph, the more likely that future returns will be either extremely large or extremely small.


Excess kurtosis is defined mathematically as $EK = kurtosis - 3$
- for a normal distribution $EK = 0$
- When $EK > 0$ then the curs is said to be leptokurtic
- When $EK < 0$ then the curs is said to be Platykurtic

---

**[2]: geometric Brownian motion (GBM)**

_Brownian motion and stochastic Differential Equations_

In order to understand how the structural models work we have to introduce the concepts of Brownian motion and Stochastic differential equations.However, before the geometric Brownian motion is considered, it is necessary to discuss the concept of a Stochastic Differential Equation (SDE). This will allow us to formulate the GBM and solve it to obtain a function for the asset price path.

A **stochastic differential equation (SDE)** is a _differential equation_ in which one or more of the terms is a _stochastic process_, resulting in a solution which is also a stochastic process. Typically, SDEs contain a variable which represents random white noise calculated as the derivative of Brownian motion or the Wiener process.

A _differential equation_ is a mathematical equation that relates some function with its derivatives. In applications, the functions usually represent physical quantities, the derivatives represent their rates of change, and the equation defines a relationship between the two.

In probability theory and related fields, a _stochastic or random process_ is a mathematical object usually defined as a collection of random variables. 

An SDE can be represented as follows:

$$dX_{t}=\mu(X_{t},t)dt+\sigma(X_{t},t)dB_{t} \Rightarrow X_{t-s} - X_{t}=\int_{t}^{t+s}\mu(X_{u},u)du + \int_{t}^{t+s}\sigma(X_{u},u)dB_{u} $$

Where $B$ denotes a Wiener process (standard Brownian motion).
> A heuristic (but very helpful) interpretation of the stochastic differential equation is that in a small time interval of length δ the stochastic process Xt changes its value by an amount that is **normally distributed** with expectation μ(Xt, t) δ and variance σ(Xt, t)² δ and is independent of the past behavior of the process. **The function μ is referred to as the drift coefficient, while σ is called the diffusion coefficient. The stochastic process Xt is called a diffusion process, and satisfies the Markov property**.

[Wikipedia SDE](https://en.wikipedia.org/wiki/Stochastic_differential_equation)

A **geometric Brownian motion (GBM)** (also known as exponential Brownian motion) is a continuous-time stochastic process in which the logarithm of the randomly varying quantity follows a Brownian motion (also called a Wiener process) with drift. It is an important example of stochastic processes satisfying a stochastic differential equation (SDE); in particular, it is used in mathematical finance to model stock prices in the _Black–Scholes_ model.

A stochastic process $S_{t}$ is said to follow a GBM if it satisfies the following stochastic differential equation (SDE)

$$dS_{t}= \mu S_{t}dt+\sigma S_{t}dW_{t}$$

Where $W_{t}$ is a Wiener process or Brownian motion and $\mu$ the percentage drift and $\sigma$ the percentage volatility are constants. **The former is used to model deterministic trends, while the latter term is often used to model a set of unpredictable events occurring during this motion.** If the mean of any increment is zero, then the resulting Wiener or Brownian motion process is said to **have zero drift**.  **If the mean of the increment for any two points in time is equal to the time difference multiplied by some constant $\mu$ , which is a real number, then the resulting stochastic process is said to have drift $\mu$** 

Markov processes are stochastic processes, traditionally in discrete or continuous time, that have the Markov property, which means the next value of the Markov process depends on the current value, but it is conditionally independent of the previous values of the stochastic process. In other words, the behavior of the process in the future is stochastically independent of its behavior in the past, given the current state of the process. **The Brownian motion process and the Poisson process (in one dimension) are both examples of Markov processes in continuous time.**

[Wikipedia GBM](https://en.wikipedia.org/wiki/Geometric_Brownian_motion)

[Wikipedia Stochastic process](https://en.wikipedia.org/wiki/Stochastic_process)
