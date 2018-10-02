---
title: Evaluating Credit Risk Models
author: 
- Jose A.Lopez 
- Marc R.Saidenberg 
tags: 
output: pdfdocument
pdf_document:
toc: yes
Date: 30/06/1999
---
# Evaluation Credit Risk Models 
[Link to online document](https://www.frbsf.org/economic-research/files/wp99-06.pdf)

><span style = color:red> (**Note:** This paper was written in 1999  and therefore prior to Basel III and economical and financial crisis of 2009. For this reason, some of the conclusion may not apply or correspond to todays reality) </span> 

### Introduction
Credit risk is defined as the degree of value fluctuations in debt instruments and derivatives due to changes in the underlying credit quality of borrowers and counterparties. There is a debate among several institutes, that credit risk models should also be used to formally determine risk adjusted, regulatory capital requirements. (Today we know that this turned out to be implemented in Basel II and III)

Due to the nature of credit risk data, only a limited amount of historical data on credit losses is available and certainly not enough to span several macroeconomic or credit cycles. Given this limitation this paper objective is to present several techniques and evaluation methods that make the most out of limited data. Specially, models are evaluated not only on their forecasts overtime, but also on their forecasts at a given point in time for simulated credit portfolios.

There exists a wide variety of credit risk models that differ in their fundamental assumptions, such as their definition of credit losses: default models define credit losses as loans defaults, while mark-to-market or multi-state models define credit losses as ratings migrations of any magnitude. Models are commonly set to calculate one year horizon risk.

Although a risk based bank equity models would reflect the efforts of portfolio diversification two set of issues need to be addressed:

1. The quality of the inputs to these models,
2. How to validate and test a model.

The most challenging aspect of credit risk modeling is the construction of the distribution function of the $(Nx1)$ random variable $\Delta At+1$. 

### Evaluation Methodology Based on Simulated Credit Portfolios
> In statistics and econometrics, **panel data** or **longitudinal data** are multi-dimensional data involving measurements over time. Panel data contain observations of multiple phenomena obtained over multiple time periods for the same firms or individuals. Time series and cross-sectional data can be thought of as special cases of panel data that are in one dimension only (one panel member or individual for the former, one time point for the latter). If the data over each observation is the same (e.g. all companies have 10 years of observations) then we have a **balanced panel**. Otherwise we say we have an **unbalanced panel**. If each line holds one observation per time then we say that data is on the **long format**, otherwise (one line has all dates) we say that it is on a **wide form**.[please recall basic tidyverse concepts]
> [wikipedia link for panel data](https://en.wikipedia.org/wiki/Panel_data)

#### A. Intuition from time series analysis
The general idea behind forecast evaluation in time-series analysis is to test whether a series of out of sample forecasts (i.e. forecasts of observed data not used to estimate the model) exhibit properties characteristics of accurate forecasts. For example, an important characteristic of point forecasts is that their error (diff between forecasted and real observed amounts) be independent of each other.

The simulation method used on this paper to generate additional credit portfolios is simply resampling with replacement from the original panel dataset of credits. [Please check [link course](https://github.com/pmags/data_notes/blob/master/Datacamp/statistical_modeling_in_r(part1).md) for further information and application about how to generate new test and training series from original data]. **As long as these additional out-of-sample observations are drawn independently from the cross-sectional sample population, the observed prediction errors should be independent.**

Methods that are commonly used for forecast evaluation in time-series analysis can be adapted for use with panel data analysis. 

The principal highlighted by the paper is straightforward: 
- Consider a total population of $N$ assets and $T$ years of observations (or months or days). Normally $T$ would be the maximum forecasts available for the model;
- $\rho \in(0,1)$ represents the % of observation to be selected
- The new sample vector will have $\rho * N$ dimensions instead of $N$
- Redoing this steps $R$ times to generate and evaluate each model for $T$ years we will have a total population of $R*T$ instead of just $T$  

<span style = color:red> **Note:** Although the proposed simulation method does make the most use of the data available, evaluation results based on just one or a few years of data must obviously be interpreted with care since they reflect the macroeconomic conditions prevalent at that time.  </span>

#### B. Evaluation Methods for a Credit Risk Model
Having generated $T*R$ resampled credit portfolios, we can generate the corresponding cumulative density function of credit losses<sup>[1]</sup>, denoted $F_{m}(\Delta P_{it+1})$ with $i=1,...R$ and $t=1,...,T$ for model **m**. Having generated a number of portfolio based on random sampling we can use different technics (as Sum of Mean Squared Error) to evaluate the predictive capacity of each model. This can be done by using the following technics:

1. **Compare the prediction with the actual observation on the resample portfolios.** (this means generating random training and testing sets from the initial population). Calculate the Squared Mean Error.
2. **Evaluation forecasted critical values.**
3. Given that credit risk models generate full distributions of credit losses, it is reasonable to evaluate the accuracy of the $(T * R)$ distribution forecasts themselves.     
###### [1]: In probability theory and statistics, the cumulative distribution function (CDF) of a real-valued random variable X, or just distribution function of X, evaluated at x, is the probability that X will take a value less than or equal to x.

### Limitations
1. Changes in the value of a credit portfolio are mainly driven by changes in credit quality changes in the value of credits of given quality, and changes in the portfolio weights of the credits.Thus, model performance can be evaluated along these dimensions using the resampling approach outlined here, with one notable exception. Many credit instruments, especially potential future exposures, do not have observable market prices and must instead be “marked-to-model” or priced according to a valuation model. This process introduces a source of potential error not captured by this methodology.

2. Credit Risk models are essentially panel data models used for datasets where the number of assets N is much greater than the number of years T. This limited amount of credit default and migration data over time complicates the forecast evaluation of these models because the results are inextricably tied to the prevailing macroeconomic and credit conditions over the T year period.