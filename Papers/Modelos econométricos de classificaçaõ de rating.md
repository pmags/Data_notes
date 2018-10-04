---
title: Modelos Econométricos de Classificação de Rating
author: Davide José Henriques da Silva
tags: 
output: pdfdocument
pdf_document:
toc: yes
Date: 2011
---
# Modelos Econométricos de Classificação de Rating
## Econometric Default Rating Models 
[Link to online document](http://repositorio.ul.pt/handle/10451/8779)
The author focus his analysis only on the banking sector in Portugal. The goal is to generate a model alternative to the ratings houses.

### Methodology:
As model architecture the author uses the **Logistic Regression Maximum Likelihood** <sup>[1]</sup><sup>[2]</sup>. The relevance and predictive power of the explanatory variables chosen will be test using the _wald test_ and _score test_.

The _Logit_ model is suitable for categorical dependent variables and allows for a easy understanding of each variable impact:

- If $\beta x > 0$ then there is a positive relation between variables with a $e^\beta$.
- If $\beta x < 0$ then there is a negative relation between variables with a $e^{-\beta}$.

**Selection methods:**
For selection of the best model this papers uses the _Akaike criterion_ and _Schwarz criterion_.

### Data & Model:
**Data:**

The data used includes financial information for portuguese financial institutions available on the Bloomberg database between 1997 and 2001. The total amount of observations is 2,571.

<span style = color:blue> **Disclaimer**: based on the methodologic information given by the author the goal is to model the class of public rating for each IF. This is different from a default model which measures the going risk and closer to the CreditRisk Models or VaR where the focus is the transitivity of a rating (downgrades generate losses). Given the limitation on the population because of the reduced number of bank defaults this approach is understandable. Nonetheless, given our goals we believe that this approach introduces significant bias into the model.</span>

**Explanatory variables:**

The following variables were used to model:

1. **Var_1 - Region:** Each Financial Institution (FI) was classified according to the headquarters location between Europe / North America / Eastern Europe / Rest of the world 
   
   _(Reflection: The classification of each FI based on its location raises questions if it is relevant for a default analysis. Given the globalized economy most institutions operate we are believe that geographic origin of most assets or revenue stream would be more relevant when studying default risk for financial institutions. Is normal, specially considering that the population only takes into account companies present on Bloomberg database, that most financial institution will locate their main offices near important financial centers. But, does a FI located on London whose clients are mainly located in the far east and one which only operates inside the european markets have the same risk? This study does not take this into account)._

2. **Var_2 - Main Line of Service (MLoS) :** Based on information from Bloomberg it associates a market segment based on the institution most relevant business (Capital Markets, Commercial Bank, Consumer Finance, Diversified Financial Services, Insurance, Real Estate Investment Trusts, Real Estate Management & Devel, Thrifts & Mortgage finance)
   
3. **Var_3 - Liquidity Ratio:** It measures FI capacity to generate liquidity and is calculated as $LR = \frac{Current Assets}{Total Assets} = \frac{CA}{TA}$. 
   
   _(Reflection: For this and other ratio explanatory variables the author doesn't provide enough information regarding the effect of time. Is this ratio being calculated for a moment $T$ or as an average?)_

4. **Var_4 - Profit Ratio:** It measures FI capacity to generate profits. $PR = \frac{RAI}{CP}$
5. **Var_5 - Liabilities Quality Ratio:** Keeping in mind that this study focus on Financial Institutions in special Banks, Liabilities are different from commercial companies and include clients savings accounts and deposits. This Ratio measures the "quality" of this Liabilities by calculating the weight of clients deposits over the total liabilities. The higher the ratio the lower the quality. $LQR =\frac{Client's deposits}{Total liabilities} = \frac{DC}{P}$

     _(Reflection: Although the nature of bank's liabilities is significantly different from other commercial company, total liabilities does not equal funds origins as the ratio seems to show. In our opinion this ratio should measure the weight of deposits as a source of funds and therefore the denominator should be total sources[deposits, securities, other bank loans, overnight, central bank, etc] instead of total liabilities [which includes, for example commercial suppliers])_

6. **Var_6 - Asset Quality Ratio:** It measures the ratio between provisions/inpairment over total loans given. The higher this ratio the worse are asset quality $AQR = \frac{Provisions}{Total\_Loans\_given} = \frac{Pr}{CCLP}$
7. **Var_7 - Policy towards deposits:** The ratio tries to capture the position compared to the average of the market towards bank deposits. This means, a commercial bank, in theory will have an higher ratio meaning that will have an higher ratio of clients deposits when compared to an investment bank. $RP\_DC = \frac{(DC-\overline{DC})}{Dist DC}$ where Dist DC represents the interquantile distribution.
8. **Var_8 - Compared Asset Policy:** $RP\_A = \frac{(\max(A_{i})-A)}{\max(A_{i})}$ where $A_{i}$ represents the total Assets for the FI and max(Ai) represents the maximum value for the assets of a given region on a given year.
9. **Var_9 - Leveraged costs:** It measures the cost of borrowing for each bank. The author does not says how this is effect is calculated and if it is at an overnight (EONIA) or on a average for all sources (which would include the spread payed for each saving account).
10. **Var_10 - Leverage Ratio:** Measured as Equity over Total Liabilities $R\_CP = \frac{CP}{P}$
11. **Var_11 - Cash & equivalents over Liabilities:** This ratio measures the coverage of the highest liquidity assets to face the debt. $R\_DP = \frac{D}{P}$
12. **Var_12 - ROE:**Measures the FI profitability for each € in equity. $ROE = \frac{RL}{CP}$
13. **Var_13 - Country Rating:** It was taking into consideration only the country rating of the FI headquarters. Please take in consideration the note above about location.
14. **Var_14 - Countries Investment Rate:** Measures investment has a ratio of GDP and is a proxy for the countries development.
15. **Var_15 - Countries inflation**
16. **Var_16 - Countries Unemployment rate**
17. **Var_17 - Country total debt ratio**

Summarizing the above on a table based on their descriptions:

| Variable | Type        | Area          |
| -------- | ----------- | ------------- |
| V1       | Categorical | Market        |
| V2       | Categorical | Market        |
| V3       | Numerical   | Liquidity     |
| V4       | Numerical   | Performance   |
| V5       | Numerical   | Leverage      |
| V6       | Numerical   | Performance   |
| V7       | Numerical   | Market        |
| V8       | Numerical   | Market        |
| V9       | Numerical   | Leverage      |
| V10      | Numerical   | Leverage      |
| V11      | Numerical   | Liquidity     |
| V12      | Numerical   | Performance   |
| V13      | Categorical | Macroeconomic |
| V14      | Numerical   | Macroeconomic |
| V15      | Numerical   | Macroeconomic |
| V16      | Numerical   | Macroeconomic |
| V17      | Numerical   | Macroeconomic |

**Modeling:**
For selecting the model variables it was followed a step - by -step approach where each variable was added to the model and the accuracy was evaluated each time.

Following this modeling strategy only 13 of the 17 initial variables were included [V13, V5, V9, V2, V17, V11, V16, V6, V1, V8, V3, V12, V15]

_Side-note Reflection: as stated above the pool of variables chosen was expected given the way they were selected. We call the attention to the fact that the first variable is the country rate and that mote variables are macroeconomic which influence this same variable. Therefore, we express our doubts about the correlation between the variables chosen. This model tends to conclude that markets Risk Rating depends mainly on location and macroeconomic variables. Based on recent bank stress test it shows that it might not be true._

**Conclusion:**
Too many statistical and modeling nonsense...

> Quote: "As agências não têm a capacidade de estimar o "verdadeiro score" devido à existência de assimetria de informação entre os responsáveis pelas entidades e as agências, quer por acesso limitado/restrito à informação existente (como seja informação contabilistica incompleta) quer por atrasos na observação dos fatores de risco."

---
###### [1]: In statistics, the logistic mode (or logit model) is a widely used statistical model that, in its basic form, uses a logistic function to model a binary dependent variable (0/1). Mathematically, a binary logistic model has a dependent variable with two possible values, such as pass/fail, win/lose, alive/dead or healthy/sick; these are represented by an indicator variable, where the two values are labeled "0" and "1". The defining characteristic of the logistic model is that increasing one of the independent variables multiplicatively scales the odds of the given outcome at a constant rate, with each dependent variable having its own parameter.  [Wikipedia link](https://en.wikipedia.org/wiki/Logistic_regression)

> ###### Basic model estimation:
> ###### Consider a model with two predictors $x_{1}$ and $x_{2}$; these may be continuous variables (taking real number as value), or indicator functions for binary variables (taking value 0 or 1). Then the general form of the _log-odds_ is:
>  ###### $l=\beta_{0}+\beta_{1}x_{1}+\beta_{2}x_{2}$
> ###### Where the coefficients $\beta_{i}$ are the parameters of the model. Note that this is a linear model: the _log-odds_ $l$ are a linear combination of the predictors $x_{1}$ and $x_{2}$, including a constant term $\beta_{0}$. The corresponding odds are the exponent:
> ###### $0 = b^{\beta_{0}+\beta_{1}x_{1}+\beta_{2}x_{2}}$ where b is the base of the logartithm and exponent. This is now a non-linear model, since the odds are not a liner combination of the predictors.
> ###### Odds of  $0 = 0:1$ for an event are the same as probability of $0/(0+1)$ therefore the probability is:
> ######  $p=\frac{b^{\beta_{0}+\beta_{1}x_{1}+\beta_{2}x_{2}}}{1+ b^{\beta_{0}+\beta_{1}x_{1}+\beta_{2}x_{2}}} = \frac{1}{1 + b^{-(\beta_{0}+\beta_{1}x_{1}+\beta_{2}x_{2})}}$
> $p = \frac{probabilidade - da- presenção -das -caracteristicas}{probabilidade-de- ausências- das- caracteristicas}$
> ###### [Logistic regression graphic example](http://www.shizukalab.com/toolkits/plotting-logistic-regression-in-r)

###### [2]: The maximum likelihood method is a statistical method commonly used to adjust statistical models to a set of information, providing estimates for the parameters of this model. For logistic regressions, the method of minimizing the sum of the squares of the residuals, used in the case of linear regression, does not have the capacity to produce non-skewed estimators with minimum variance.