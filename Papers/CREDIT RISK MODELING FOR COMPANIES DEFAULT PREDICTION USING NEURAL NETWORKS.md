---
title: Credit Risk Modeling for companies default prediction using neural networks
author: 
- Alina Mihaela Dima
- Simona Vasilache  
tags: 
output: pdfdocument
pdf_document:
toc: yes
Date: 2016
---
# Credit Risk Modeling for companies default prediction using neural networks 
[Link to online document](http://www.ipe.ro/rjef/rjef3_16/rjef3_2016p127-143.pdf)

## Introduction
The paper uses a sample of 3000 romanian companies with a distribution that is representative of the romanian economy. The Sample was distributed and rated according to Standard & Poor categories. **We have then, estimated the one-step transitions probability for downgrading for one year, based on the present category, loan amount, size of company and sector of activity.**[The authores are assessing default risk as the transition risk, in a way similar to creditrisk by JP Morgan].Thus, although the approach is bottom-up and unconditioned, focusing on the companies, we have included the economic context, taking into account the type of company and the economic sector.

They have performed the estimations first using **logit regression**, and then **ANN (Artificial Neural Networks)**, and compared the results with Standard & Poor’s
transition matrix for 2010.

A 2005 study in Japan about firms characteristics that bank focus on during the underwriting process, found out that, on balance, the three most important factors when bank screen  borrowers **are their relationship with the borrower, the strength of the borrower's financial statements and the collateral and/or guarantee pledged**.

As far as the empirical modeling choice is concerned, we use logit regression and neural network forecasting, in order to compare the Bayesian approach with the MLP
(multilayer perceptron) model, **and use the second to correct some of the drawbacks of the first**. Previous studies have only used Bayesian approaches or neural
network models to distinguish defaulters from non-defaulters. We repeat the analysis
several times, on matched samples, in order to estimate transition probabilities from
each class to each other.

Many authors through the years identified the main risk-taking factors as moral hazard, leverage, ownership structure, risk preferences and regulatory actions.

## Methodology
The objective of the paper is to estimate the one-step transition probability of downgrading for companies applying for credits.

The independent variables considered for this model were 1. company size, 2. sector of activity, 3.loan amount and 4.credit performance class (AAA to C). The dependent variable was the one-step transition probability for downgrading, expressed as 1- the company will downgrade, 0 - the company will not downgrade.

For the sector and size variables the companies were divided in 1 if a part of a risk sector and 0 otherwise and 1 if part of a risk sector and 0 otherwise.

_Delay_ / _Risk category_ were both defined as categorical variables with 7 levels.

A total of 4 independent variables were used(company size, sector of activity, loan amount, credit performance class).

## Results and discussions
The Neural Network returned an higher accuracy and sensibility when compared with the logit model. Nonetheless, we weren't able to understand if the skew on the base population was corrected before training both models.

Our research, based on a rather large sample of companies applying for credit to the
same bank, with whom some had previous crediting relations, and some not, confirmed
our hypothesis that neural networks estimates are better than Bayesian estimates also
in predicting probabilities of transition, not only probabilities of default.