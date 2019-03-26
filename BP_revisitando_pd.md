---
Title: Revisitando probabilidades de incumprimento de empresas
Author: Banco de Portugal
Url: https://www.bportugal.pt/sites/default/files/anexos/papers/re201605_p.pdf
---

# Resumo
O objetivo deste paper passa por determinar os fatores que explicam a probabilidade de uma empresa ter um episódio de incumprimento de crédito significativo junto do sistema bancário no ano seguinte.

Para realização deste estudo foi utilizada informação da central de responsabilidades de crédito para o período 2002-2015 e da central de balanços para o período 2005-2014. 

A variável dependente é binária e a amostra foi devidida m 10 estratos de empresas definidos em termos de dimensão e setor de atividade económica.

# Introdução
O objetivo principal é determinar os fatores que explicam a probabilidade de uma empresa ter um episódio de incumprimento de crédito significativo junto do sistema bancário no ano seguinte. O resultado deste sistema é uma probabilidade de incumprimento no crédito bancário no horizonte de um ano. 

No paper foi utilizada a seguinte tabela de conversaõa de rating em linha com as diretivas do BCE (url: https://www.ecb.europa.eu/paym/coll/risk/ecaf/html/index.en.html)

|Credit Quality Step|Limite superior de proabilidade de incumprimento |
|-------------------|--------------------------------------------|
|1 e 2              | 0,1 |
| 3 | 0,4  |
| 4  | 1,0  |
| 5  | 1,5  |
| 6  | 3,0  |
| 7  | 5,0  |
| 8  | 100  |

O incumprimento na dívida titulada é altamente correlacionado com o incumprimento na divida bancária. Ter ao dispor medidas sintéticas que permitam medir a capacidade de uma entidade cumprir os seus compromissos financeiros facilita a tomada de decisão de investimento. Com efeito, é normal os investidores basearem parte das suas decisões de investimento na notação de crédito das empresas dado que nem sempre é fácil ter acesso e analisar dados detalhados sobre cada empresa que representa uma oportunidade de investimento. 

No âmbito da atual politica monetária europeia, os Bancos Centrais concedem liquidez diretamente ao sistema bancário e todas estas operações de crédito têm como garantia ativos elegíveis que cumpram os padrões do Eurosistem Credit Assessment Framework (ECAF). A avaliação determina se as instituições de crédito podem utilizar uma tivo de uma determinada empresa como garantia e, no caso dos ativos elegíveis, a dimensão do *haircut* é definida igualmente pela notação de crédito

O Paper está organizado da seguinte forma:
1. Dados e definição de incumprimento
2. Metodologia para avaliação de risco
3. Calibração do modelo
4. Probabilidades de incumprimento estimadas e à matriz de transição entre classes de risco de crédito

# Dados utilizados

Central de Balanços - contem informação economica-financeira da generalidade das empresas em Protugal obtida através da IES.
Central de Responsabilidades de Crédito - informação mensal sobre todas as exposições das empresas e particulares junto do setor financeiro em Portugal. 

Neste estudo apenas foram incluidas empresas com pelo menos um empréstimo junto de uma instituição financeira uma vez que o estudo se debruça sobre incumprimento de financiamentos.

## Definição de incumprimento
Uma empresa é considerada em "incumprimento" junto do sistema financeiro se a parcela de crédito em incumprimento for superior a 2,5% do total de crédito. O "evento de incumprimento" ocorre quando a empresa completa três meses consecutivos em incumprimento. Diz-se que uma empresa incumpriu num determinado ano se durante esse ano ocorreu um evento de incumprimento. É possível que a mesma empresa possa ter mais do que um incumprimento durante o período de análise. No entanto, de modo a garantir que a amostra não é enviesada pela existência de empresas com incumprimento recorrente, excluímos todas as observações da empresa após o primeiro evento de incumprimento. 

Apenas são consideradas empresas que ou são novas para o sistema financeiro durante o período em análise ou têm um historial de crédito de três anos totalmente limpo. As empresas que surgem na CRC já em incumprimento são excluidas.

As empresas foram dividias em dois grupos (micro empresas e outras) e posteriormente dividas cf o CAE. Através de um processo de agregação acabou-se a utilizar 5 setores de atividade:

1. Indústria transformadora e extrativa
2. Construção e imobiliário
3. Comércio e setor primário
4. transporte e armazenagem
5. Serviços

**Todas as variáveis em nível foram redefinidas através da sua divisão pelo total do ativo, total do passivo corrente ou do passivo total.Indicadores cujo denominador possa ter valores negativos não são utilizados dado que poderiam gerar descontinuidades significativas quando o denominador está próximo de zero.**

|MEDIDAS|VARIAVEIS|
|--|--|
|Alavancagem|Divida financeira; Divida bancária; Juros pagos|
|Rentabilidade| VAB por trabalhador; Resultados  líquidos/Perdas; EBIT; *Cash flow*; EBITDA|
|Liquidez| Caixa; Responsabilidades correntes|
|Estrutura de financiamento|Capital próprio; Ativo corrente, Ativo tangível|
|Dimensão| Ativo Total; Idade; Volume de negócios; Nº de empregados|
|Outros fatores idiossincráticos|Slários; Débitos comerciais|
|Macroeconomia|Tx. incumprimento anual; Tx. cresc. do credit; Tx. Cresc. PIB Nominal; Tx. cresc PIB Real|

De modo a diminuir os valores de assimetria e curtose, variáveis estritamente positivas foram transformadas em logaritmos. Todas as variáveis explicativas pertencem ao final do ano atual $t$. A variável dependente é o indicador de ocorrência de um evento de incumprimento no ano seguinte $t+1$.

O Modelo utilizado para a estimação foi um *Logit*. **Para cada tipo de empresa foi criado um modelo distinto**.

# Calibrar classes de crédito
O procedimento escolhido para categorizar empresas de acordo com as classes de crédito consiste (i) na obtenção de valores de referência para probabilidades de incumprimento de fontes externas, seguida (ii) da escolha dos limiares em função do z-score para as diferentes classes de risco de crédito e finalmente  (iii) a confirmação, *a posteriori* de que as probabilidades de incumprimento observadas para a amostra são consistentes com as probabilidades usadas para as classes de c´rdito.

**O *z-score* de cada uma das observações é simplesmente definido como a estimativa da variável latente ou seja $z_{t} = x_{t}\Beta$**. Este score é utilizado como uma medida de classificação sobre a qual pode ser medida a percentagem de defaults.

A Classe 3 corresponde à classe de crédito de pior qualidade para a qual, no quadro regular da política monetária, os empréstimos das empresas podem ainda ser usados como colateral pelas instituições financeiras para fins de operações de refinanciamento junto do Eurosistema.

# Dinamica do risco de credito
As tabelas de transição são uma forma útil de caracterizar a dinâmica das empresas entre as diferentes classes de crédito e para o incumprimento. Tipicamente, estas tabelas apresentam a probabilidade da empresa se "deslocar" para uma classe de crédito especifica ou para incumprimento, condicional à classe de crédito atual.
 


