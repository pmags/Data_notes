---
title: Forecasting bankruptcy more accurately, a simple hazard model 
author: 
- Tyler Shumway 
tags: 
output: pdfdocument
pdf_document:
toc: yes
Date: 16/07/1999
---
 
[Link to online document](http://www-personal.umich.edu/~shumway/papers.dir/forcbank.pdf)

> I describe a simple technique for estimating a discrete-time hazard model with a logit model estimation program. Applying my technique i find that about half of the accounting ratios that have been used in previous models are note statistically significant predictors. I propose a model that uses a combination of accounting ratios and market-driven variables to produce more accurate out-of-sample forecasts.

Most researchers have estimated single-period classification models, which i refer to as *static* models, with multiple-period bankruptcy data. This models ignore the fact that firms change through time.

Static models are inappropriate for forecasting bankruptcy because of the nature of bankruptcy data. Since bankruptcy occurs infrequently, forecasters use samples that span several years to estimate their models. Researchers that apply static models to bankruptcy have to select when to observe each firm's characteristics and most choose to observe the data before bankruptcy. **They ignore data on healthy firms that eventually go bankrupt. By choosing when to observe each firm's arbitararily, forecasters that use static models introduce an unnecessary selection bias into their estimates.**


## Advantages of hazard models
Hazard models resolve the problems of static models by explicitly accounting for time. *The dependent variable in a hazard model is the time spent by a firm in the healthy group.*

When firms leave the healthy group for some other reason other than bankruptcy they are considered censored. **In a hazard model, a firm's risk of bankruptcy changes through time and its health is a function of its latest financial data and its age. The bankruptcy probability that a static model assigns to a firm does not vary with time.**

Some other reasons that were presented towards hazard models:

- Static models fail to control for each firm's period at risk. It is important to control for the fact that some firms file for bankruptcy after many years of being at risk while other firms fail in their first year.
- They incorporate time-varying covariates, or explanatory variables that change with time.
- they may produce more efficient out-of-sample forescasts by utilizing much more data. *The hazard model can be thought of as a binary logit model that includes each form-year as a separate observation.*

The survivor function gives the probability of surviving up to time t and the hazard function gives the probability of failure at *t* conditional on surviving to *t*.




