---
TOCtitle: Markdown
PageTitle: Beneish M-score
output: pdfdocument
---
# Beneish M-score

> url: https://en.wikipedia.org/wiki/Beneish_M-Score
> url:http://investexcel.net/beneish-m-score/

**Purpose of this score:** Determine if a company has manipulated earning. It uses a similar modeling architecture has used by altman to calculate the Z-Altman which is the z score. It's simply a mathematical formula which uses data from company's financial reports.

Companies facing financial distress sometimes manipulate earnings by altering depreciation rates, delaying when expenses are recognized, registering sales early or other creating accounting tricks. (although this might not be illegal in some cases or countries).

The equation is as follows:

M8 = -4,84 + 0,92 DSRI + 0,528 GMI + 0,404 AQI + 0,892 SGI + 0,115 DEPI - 0,172 SGAI + 4,679 TATA - 0,327 LVGI

M5 = -6.065 + 0.823 DSRI + 0,906 GMI + 0,593 AQI + 0,717 SGI + 0,107 DEPI

- Days Sales in Receivables Index (DSRI). This measures the increase in receivables and revenues between two reporting periods (Netreceivables t-1/Netsales t-1 )/(Netreceivables t/Netsales t )

- Depreciation Index (DEPI) [Depreciation t/(Depreciation t + Property t)/Depreciation t-1/(Depreciation t-1 + Property t-1)]

- Sales Growth Index (SGI) [Netsales t-1/Netsales t]

- Leverage Index (LVGI) [(Long term debt t-1 + current liabilities t-1)/Total assets t-1]/[(Long term debt t + current liabilities t)/Total assets t]

- Total Accruals to Total Assets (TATA)  [(Net income t-1 - CF op t-1)/Total assets]

- Gross Margin Index (GMI) [(GM t/Net sales t)/(GM t-1/Net sales t-1)]

- Asset Quality Index (AQI) 

- Sales, General and Administrative Expenses Index (SGAI) 

An M-Score greater than -2.22 indicates a high probability of earnings manipulation.

Coded function to implement in R:

```R
Mscore_8 <- function (DSRI, GMI, AQI, SGI, DEPI, SGAI, TATA,LVGI) {
    
    M8 = -4.84 + 0.92 * DSRI + 0.528 * GMI + 0.404 * AQI + 0.892* SGI + 0.115 * DEPI + 0.172* SGAI + 4.679 * TATA - 0.327 * LVGI
    
    return(M8)
}
```