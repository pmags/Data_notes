---
TOCtitle: Markdown
PageTitle: Machine Learning- Challenges, Lessons, and Opportunities in Credit Risk Modeling
output: pdfdocumentMachine Learning: Challenges, Lessons, and Opportunities in Credit Risk Modeling
---
# Structural Credit Risk Models with Subordinated Process

> [Link para texto](https://www.moodysanalytics.com/risk-perspectives-magazine/managing-disruption/spotlight/machine-learning-challenges-lessons-and-opportunities-in-credit-risk-modeling)

### Introduction
This paper aims at comparing Moody0s RiskCalc solution to models created using Machine Learning algorithms. It concludes that the accuracy ratios are similar among models although the machine learning approach has a black box "feeling" making it more difficult to interpret the results.

**Machine learning is a method of teaching computers to parse data, learn from it, and then make a determination or prediction regarding new data.** It attempts to find and learn from patterns and trends within large databases to make predictions.

One of the earliest uses of machine learning was within credit risk modeling, whose goal is to use financial data to predict default risk.

> When a business applies for a loan, the _lender must evaluate whether the business can reliably repay the loan principal and interest_. Lenders commonly use measures of profitability and leverage to assess credit risk. **A profitable firm generates enough cash to cover interest expense and principal due. However, a more-leveraged firm has less equity available to weather economic shocks.**

The common objective behind machine learning and traditional statistical learning tools is to learn from data. Both approaches aim to investigate the underlying relationship by using a training set. Typically statistical methods (models) require a formal relationship between variables while machine learning methods can learn from data without requiring any rules-based programming.  As a result of this flexibility, machine learning methods can better fit the patterns in data. 

![exemplo Ml](https://www.moodysanalytics.com/-/media/web-assets/publications/risk-perspectives/edition-images/viiii-managing-disruption/articles-graphics/05-machine-learning/fig-1-statistical-model.png?modified=20170622184156 "exemplo ml")

><span style="color:blue"> <strong> A machine learning model, unconstrained by some of the assumptions of classic statistical models, can yield much better insights that a human analyst could not infer from the data.</strong> </span>

### Machine Learning Approaches
#### 1. Artificial Neural Networks (ANN)
An artificial neural network (ANN) is a mathematical simulation of a biological neural network. It reflects, supposely, the way a human brain creates connections.

![ANN example](https://www.moodysanalytics.com/-/media/web-assets/publications/risk-perspectives/edition-images/viiii-managing-disruption/articles-graphics/05-machine-learning/fig-2-artificial-neural.png?modified=20170622184234)


#### 2. Random Forest (RF)
Random forests combine decision tree predictors, such that each tree depends on the values of a random vector sampled independently, and with the same distribution. A decision tree is the most basic unit of the random forest.

The random forest approach combines the predictions of many trees, and the final decision is based on the average of the output of the underlying independent decision trees.

![RF Example](https://www.moodysanalytics.com/-/media/web-assets/publications/risk-perspectives/edition-images/viiii-managing-disruption/articles-graphics/05-machine-learning/fig-3-random-forest.png?modified=20170710015329)

#### 3. Gradient boosting (GB)
Boosting is similar to random forest, but the underlying decision trees are weighted based on their performance

### Comparing results
To compare different models the following database was used:

| Variable               | Financials Only | Financials + Behavioral |
| ---------------------- | --------------- | ----------------------- |
| Time period            | 1990 - 2014     | 1999-2914               |
| Number of firms        | 240.000 +       | 101.000 +               |
| Number of defaults     | 16.000 +        | 5.700 +                 |
| Number of observations | 1.100.000 +     | 1.100.000 +             |

Explanatory variables used to build the models

| Variable                                            | Description                                                                                                                                                           |
| --------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Firm information                                    | Firm characteristics such as sector and geography                                                                                                                     |
| Financial ratios (balance sheet & income statement) | Set of financial statements ratios constructed from the balance sheet and income statement items; the same set of inputs ratios used for the RiskCalc model were used |
| Credit usage                                        | Utilization on the line of credit available to the borrower                                                                                                           |
| Loan payment behavior                               | Loan - level past due information of the borrower over time                                                                                                           |
| Loan type                                           | Type of loan: revolving line or term loan                                                                                                                             |

Because machine learning offers a high level of modeling freedom, it tends to overfit the data. A model overfits when it performs well on the training data but does not perform well on the evaluation data. A standard way to find out-of-sample prediction error is to use k-fold cross-validation (CV). In a k-fold CV, the dataset is divided into k subsets. One of the k subsets is used as the test set, and the other k-1 subsets are combined to form a training set. This process is repeated k times.

**MODEL RESULTS (1 YR)**

| Method         | Financial Information Only | Financials + Behavioral |
| -------------- | -------------------------- | ----------------------- |
| Risk Calc      | 55,9%                      | 65,8%                   |
| Random Forest  | 58,9%                      | 66,5%                   |
| Boosting       | 59,1%                      | 67,5%                   |
| Neural Network | 56,6%                      | 66,4%                   |

Conclusions:
- Machine learning outperforms Moodys model,
- When included, behavioral variables increase the accuracy,
- A good accuracy for a pd model is around the 65% - 75% range. This is important information considering the Lemon study.

**Besides financial statement and loan payment behavioral data, additional information such as transactional data, social media data, geographical information, and other data can potentially add a tremendous amount of insight.**

### Info on RiskCalc
> Link - [Riskcalc 4.0. France](http://ma.moodys.com/rs/961-KCJ-308/images/RiskCalc_40_France_FINAL.pdf?mkt_tok=3RkMMJWWfF9wsRojuaTOc+/hmjTEU5z17u4uWKC/gYkz2EFye+LIHETpodcMSMJhNL3YDBceEJhqyQJxPr3MKtEN0dZ3RhLiAA==)
> 
> Link - [Riskcalc 3.1 com lista de variáveis] (https://www.moodys.com/sites/products/ProductAttachments/RiskCalc%203.1%20Whitepaper.pdf)

In France, RiskCalc uses the local criteria for default, defined as the date of the initiation of the following types of legal proceedings: _liquidation, under legal regulation, ceasing of payments, and continuation plan_. [**This similar approach can be used for information extracted from SABI on portuguses companies**].

The following companies are excluded from the database:
- **Small companies**: For companies with net sales of less than €500,000 (in 2012 Euros) future success is often linked to the finances of the key individuals. Therefore, they are not reflective of typical middle-market companies and are excluded from the database. 
- **Financial institutions**: The balance sheet of this companies exhibit higher leverage than the typical private firm.This makes this companies very different from the regular company
- **Real Estate Development Companies**: : Since the financial health of real estate development and investment opportunities often hinges on a particular development, such as in “project finance,”4 the annual accounts of these firms provide only a partial description of their dynamics and, therefore, their likelihood of default. 
- **Public Sector and Not-for-Profit Institutions**: The default risk of government-run companies is influenced by the states or municipalities unwillingness to allow them to fail. As a result, their financial results are not comparable to other private firms.
- **Start up companies**: Financial statements for a company during its first two years are extremely volatile and are poor reflection of the creditworthiness of the company.

><span style ='color:blue'>**_Important quote:_** When building a model, we examine potential database weaknesses. Not only should the database cover many firms and defaults, but the defaults should also be distributed among industries and company size.</span> 

<span style ='color:red'>**_Warning:_** Because most companies do not default, defaulting companies are relatively rare, and are, therefore, more valuable in building a default prediction model. Much of the lack in default data is due to data storage issues within financial institutions, such as defaulting companies being purged from the system after troubles begin, not capturing all defaults, or other sample errors. </span>

<span style ='color:red'>**Publicly available sources of default data generally only reflect bankruptcy-related events, and therefore do not capture all default events.** These issues can result in a sample with lower default rates than occur in the general population. If the underlying sample is not representative, it must be adjusted for the true central default tendency (CDT). </span>

#### Model components
RiskCalc model development involves the following steps:

1. Choose a limited number of financial statement variables for the model from a list of possible variables
2. Transform the variables **_into interim probabilities of default_** using non-parametric techniques.
3. Estimate financial statement variable weightings using a _**probit model**_, combined with industry variables.
4. Create a (non-parametric) final transform that converts the probit model score into an actual EDF credit measure.

> A probit model is a type of regression where the dependent variable (this case the default) can only take two values.The purpose of the model is to estimate the probability that an observation with particular characteristics will fall into a specific one of the categories. It treats the same set of problems as does logistic regression using similar technics. The probit model, which employs a probit link function, is mots often estimated using the standard maximum likelihood procedure, such an estimation being called a probit regression. [link](https://en.wikipedia.org/wiki/Probit_model)

The variables used on the model where grouped the following way:

| Group         | Description                                                                                                                                                                                               |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Activity      | These ratios measure a firm's operating efficiency (eg. a large amount of accounts payable relative to sales increases the probability of default)                                                        |
| Debt coverage | Measures a firm's ability to generate income to cover interest payments or some other measure of liabilities                                                                                              |
| Leverage      | Examples of ratios in the leverage category include liabilities - to - assets and long term debt to assets                                                                                                |
| Growth        | Typically includes sales growth. These variables measure the stability of a firm's performance                                                                                                            |
| Liquidity     | Includes cash and marketable securities to assets, the current ratio, and the quick ratio. These variables measure the extent to which the firm has liquid assets relative to the size of its liabilities |
| Profitability | Includes net profit and loss, ordinary profit, EBITDA, EBIT and operating profit in the numerator; and total assets, tangible assets, fixed assets in the denominator.                                    |
| Size          | Measured by total assets or sales deflated to a specific base year to ensure comparability                                                                                                                |

A Model was created with at least one variable per group. The following variables were used 

| Category | Ratios                                                                      |
| -------- | --------------------------------------------------------------------------- |
| Activity | Interest Expense/sales ; Accounts Payable/Sales; Personnel expenses / Sales |
|Debt Coverage|Debt Coverage Ratio: (Profit for Period + Depreciation and Amortization)/(Liabilities – Cash and Marketable Securities)|
|Growth|Sales Growth; Change in ROA|
| Leverage|Equity/Assets |
| Liquidity| Cash & marketable securities/Assets|
| Profitability| Operating margin|
| Size| Real total assets|

_Note: in this model, industry was also included as a variable in the sense that wight was adjusted based on industry._

> Model Note: The first step taken by mooddy's team was to generate univariate models of each variable. (Univariate model means a function or polynominal of only one variable. In this case, it means using the probit model). _[Incluir no modelo uma análise semelhante à Moody's para demonstrar a relação entre variáveis e resultados.]_

EDF credit measures are impacted no only by a company's financial, but also by the economy's general credit cycle. To capture this effect, RiskCal includes a credit cycle adjustment factor (CCA). Moody's calculates this adjustment factor using distance to default (DtD) for public firms. 

If the DtD factor **for public firms in an industry indicates a level of risk above the historical average for that industry**, the private firm EDF values in that industry adjust upward. **Conversely, if the risk level falls below the historical average for that industry, then the private firm EDF values adjust downward.** When the credit cycle adjustment factor is neutral, the CCA EDF value coincides with the FSO EDF value. [In the portuguese case, due to the small number of regularly traded public companies this adjustment doesn't make sense].

The DtD factor used for France is a weighted average of 2 subfactors. The first subfactor is based on an aggregation of DtD for French companies in each industry and the second sub-factor is based on aggregation of regional firms from each industry. The weight on the French factor is industry-specific and determined by the number of French firms in each industry.

