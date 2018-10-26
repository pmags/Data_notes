__---
author: 
- John Hull 
- Izzy Nelken
- Alan White 
Date: September 2004
---
# Merton's Model, Credit Risk, and Volatility Skews
In this paper the authors propose a way the merton model's parameters can be estimated from the implied volatility's of **options on the company's equity**. They use data from the **Credit Default Swap market** and compare to the traditional implementation

## Introduction
A CDS is a derivative that protects the buyer against default by a particular company. The CDS spread is the amount paid for protection and is a direct market-based measure of the company’s credit risk. Most previous researchers have used bond data to test implementations of Merton’s model. Using CDS spreads is an attractive alternative. Bond prices have the disadvantage that they are often indications rather than firm quotes. Also, the credit spread calculated from a bond price depends on the bond’s liquidity and involves an assumption about the benchmark risk-free rate

## Merton's Model
Both Merton (1974) and Black and Scholes (1973) propose a simple model of the firm
that provides a way of relating credit risk to the capital structure of the firm. In this model the value of the firm’s assets is assumed to obey a `lognormal` diffusion process with a constant volatility. The firm has issued two classes of securities: equity and debt. The equity receives no dividends. The debt is a pure discount bond where a payment of $D$ is promised at time $T$.

If at time $T$ the firm’s asset value exceeds the promised payment, $D$, the lenders are paid the promised amount and the shareholders receive the residual asset value. If the asset value is less than the promised payment the firm defaults, the lenders receive a payment equal to the asset value, and the shareholders get nothing.

The riskneutral probability, $P$, that the company will default by time $T$ is the probability that shareholders **will not exercise their call option to buy the assets of the company for $D$ at time $T$**. It is given by

<span style = color:blue> (next sections copied from paper)</span>
_A. Equity value ant the probability of default_

Define $E$ as the value of the firm's equity and $A$ as the value of its assets. Let $E_{0}$ and $A_{0}$ be the values of $E$ and $A$ today and let $E_{T}$ be their values at time $T$. In the Merton framework the payment to the shareholders at time $T$, is given by:

$$E_{T} = \max[A_{T}-D,0]$$

This shows that the equity is a call option on the assets of the firm with strike price equal to the promised debt payment. Applying Black Scholes the current equity price is:

$$E_{0}=A_{0}N(d_{1})-De^{-rT}N(d_{2}$$

$\sigma_{A}$ is the volatility of the asset value, and $r$ is the risk-free rate of interest (which we use to calculate the equity value but not the actual probability of default), both of which are assumed to be constant.

Define $\hat{D} = De^{-rT}$ as the present value of the promised debt payment and let $L = \hat{D}/A_{0}$ be a measure of leverage then equity value is:

$$E_{0} = A_{0}N(d_{1})-De^{-rT}N(d_{2}) = A_{0}N(d_{1})-A_{0}LN(d_{2})$$

<span style = color:red> **Where equity value is dependent on asset value and the leverage level** </span>

Because of this we can apply Ito's lemma and conclude that the equities volatility is as follows:

$$\sigma_{E} = \frac{\sigma_{A}N(d_{1})}{N(d_{1})-LN(d_{2})}$$

This equations let the two unknowns $A_{0}$ and $\sigma_{A}$ to be obtained from $E_{0}$ and $\sigma_{E}$, $L$ and $T$

The risk neutral probability (using $r$ instead of the asset drift $\mu$)
$$P = N(-d_{2})$$

**This depends only on the leverage $L$ the asset volatility, $\sigma$ and the time to repayment $T$.** (Bare in mind that we are talking about the risk free probability rates, meaning that we haven't taken into consideration the asset drift).

_B. Debt Values and the implied credit spread of Risky Debt_
Merton's model can be used to explain risky debt yields, Define $B_{0}$ as the market price of the debt at time zero. The value of the assets at any time equals the total value of the two sources of finance so that
$$B_{0} = A_{0} - E_{0} = A_{0}[N(-d_{1})+LN(d_{2})]$$

The yield to maturity on the debt is defined implicitly by:
$$B_{0} = De^{-yT} = \hat{D}e^{(r-y)T}$$

The yield to maturity:

$$y = r - ln[N(d_{2})+N(-d_{1})/L]/T$$

The credit spread implied by Merton model is therefore

$$s = - ln[N(d_{2})+N(-d_{1})/L]/T$$


