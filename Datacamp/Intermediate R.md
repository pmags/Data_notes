---
PageTitle: Intermediate R
---

# Intermediate R
Operadores  relacionais permitem comparar diferentes objectos. Ex: verificar se dois objetos são iguais. (!= é o operador para desigualdade). No caso de variáveis que são caracteres, o R faz a comparação segundo uma ordem alfabética. Quando comparar dois vetores, o R fará uma comparação elemento a elemento.

`and operator &` permite juntar duas condições. **O resultado é verdadeiro se ambas as condições forem verdadeiras** ex: `x <- 12; x > 15 & x < 15`.

`OR operator |`, neste caso apenas uma das condições terá de ser verdadeira para toda a expressão ser verdadeira.

`NOT operator !` nega a relação lógica. Ex: `!TRUE = FALSE`.

>Caso estejamos a trabalhar com vetores, quando utilizamos `&&` ou `||` então a operação é apenas realizada para o primeiro elemento do vetor.

> Para verificar se um numero X está entre 3 e 7 a expressão 3< x < 7 não vai funcionar. Terá que ser definida e expressão 3 < x & x < 7.

> O somatório de um vetor com variáveis lógicas (TRUE ou FALSE) irá somar apenas os valores verdadeiros. Este resulta é intuitivo se considerarmos que o R está implicitamente a atribuir o valor 1 aos resultados verdadeiros e 0 aos restantes.

### Conditional statements
 `if(conditon){expr}` -> se a condição for verdadeira então o código contido em expr será exectuado.

 A função `else` é executada sempre a condição em if não for verificada. A sintax do código é:
```R
if(condition){expr_1
    } else {    
     expr_2
    }
```

É possível incluir mais condições bastando para tal que se incluia a expressão else if. Desta forma, é possível incluir um número elevado de condições. Sintax:

```R
if(condition){expr_1
    } elseif (condition) {    
     expr_2
    } else {
     expr_3
    }
```
 > You can only use an else statement in combination with an if statement. The elsee statement doesn't require a condition, its corresponding code only runs if all of the preciding conditions in the control structure are false.

 ### While loops
 Por comparação com a condição if, um while loop continuará a ser executado até que determinada condição seja verdadeira.

```R
 # Code syntax for while loop
 while(condition {expr})
``` 
<span style = color:red> **Nota:** É muito importante que exista uma condição que seja falsa em algum momento para que o loop termine. Caso contrário torna-se um loop infinito. </span>

Uma forma de estabelecer uma condição de paragem é através da introdução da condição `Brake`. Exemplo:

```R
if(speed > 80) {Brake}
```

<span style = color:blue> A condição `3 * i %% 8 == 0` verifica se 3 * i é divisivel por 8. Por exemplo se i = 16 então a condição é verdadeira </span>

### For Loops
Sintax do código:
```R
for(var in seq){expr}
```
Traduz-se em _para cada variável na sequência executar a expressão_

Em um `For Loop`, quando utilizamos o operador `Next` com uma determinada condição, o loop vai ignorar essa condição e continuar para a seguinte.

Em vez de seguir o looping automático do R, podemos usar um looping manual, exemplo: 

```R
for(i in 1:lenght(cities)){expr}
```
Neste caso o loop será entre 1 e a dimensão do vectro cidades.

`paste()` é uma função que junta diferentes valores e os transforma em caracteres. Exemplo o código `paste("on row",i,"and colunm",j,"the board contains", ttt[i,j])` cria uma frase com os resultados das variáveis i e j e os valores da matriz ttt na posição i,j. [paste() - Concatenate vectors after converting to character]

> The `break` statement abandons the active loop: the remaining code in the loop is shipped and the loop is not iterated over anymore. 
> The `next` statement ships the remainder of the code in the loop, but continues the iteration.

### Functions
Para obter informação adicional sobre determinada função podemos usar o código `help(function)` ou `?function`. `args(function)` devolve os argumentos necessários à execução de determinada função. 

<span style = color:red> **Nota:** Ter em atenção que o R atribui os inputs a cada passo da função por posição.   </span>

**When to write your own function?**
* Solve a particular, well defined problem
* Blackbox principle
* If it works, innerworking less important

Sintax de criação de qualquer função em R:
```R
my_fun <- function(arg1, arg2){body}
```
Apesar da sintax apresentada, uma função não tem necessária de ter argumentos definidos.
> <span style = color:blue> Function scoping implies that variables that are defined inside a function are not acessible outside that function. An R function cannot change the variable that you input to that function. In practice this means that each function creates its own workspace where a variable existe and is defined. If such variable is not defined inside that workspace, R might look for it on the general workspace. The opposite, accessing a varible outside a function, is not possible.  </span> 

### R Packages
Para instalar um package deverá ser utilizada a seguinte função: `install.packages("package")`.
Após a instalação o package ainda não está pronto a ser utilizado. Para tal é necessário fazer o load do mesmo. Fazer load significa que as variáveis e funções do package podem ser procuradas pelo R. `library(package)`.

----
### Lapply
`lapply(nyc,class)` aplica a função `class()` a todos os elementos da lista nyc. <span style = color:red> Ter em atenção que a função lapply devolve sempre os resultados na forma de lista.  </span>

Exemplo de aplicação que cria um vetor onde cada elemento corresponde ao nº de caracteres do elementos do vector `cities`:

```R
num_chars <- c() #creates empty vector
for(i in 1:length(cities)){
    num_chars[i] <- nchar(cities[i])

# This code is equivalent to
unlist(lapply(cities,nchar))
}
```
> `lapply()` takes a vector or lista X, and applies the function FUN to each of its members. If FUN requires additional arguments, you can pass tehm after you've specified X and FUN. The output of `lapply()` is a lista, the same lenght as X, where each element is the result of applying FUN on the corresponding elemento of X

Por norma a cada função é atribuida a um nome que pode ser chamado posteriormente. No entanto R permite a utilização de funções anónimas as quais podem ser úteis no caso de não se prever utilizar posteriormente a mesma função. Exemplo:

```R
#named function
triple <- function(x){3 * x}

#Anonymous functions with same implementation
function(x){3 * x}
```
`lapply()` devolve resultados numa lista para que possam ser utilizados elementos heterogéneos. No entanto, quando sabemos que os resultados serão sempre com a mesma caracteristica podemos usar `sapply()` que devolve os resultados em vector com nome.

`sapply()` applies function over list or vector try to simplify list of arrays.
`vapply()` apply function over list or vector, try to simplify by explicitly specify output format

```R
vapply(x, fun, fun.value, ... , use.names = TRUE)
```
```R
# Exemplos de funções em R:
obs() # calcula o valor absoluto de um array de valores
round() # arredonda os valores de um array de dados numéricos
sum() # devolve o sumatório de um array
mean() # média aritmética
seq() # cria uma sequência de números
rep(x,times = n) #repete uma lista(vector/matriz n vezes[se colocarmos each = 2 repede cada elemento])
as.*() # converte dados em outra tipologia (exemplo vetores em lista)
append() # permite acrescentar elementos a um vector ou matriz
rev() # reverte uma listagem, vector ou matriz
```
### Regular expressions
Regular expressions are:
- Sequence of (meta)characters
- Pattern existence
- Pattern Replacement
- Pattern extraction

A seguint função permite indetificar padrões utilizando caracteres:
```R
grepl(pattern = <regex>, x = <string>)
```
A função `grepl()` devolve o índice/localização no vector em que se aplica a condição.

O R permite substituir valores/caracteres de um vetor que cumpram determinada condição ou sigam determinado padrão:

```R
sub(pattern = <regex>, replacement = <str>, x = <str>)
```
**Explicação do código**: Neste caso, apenas um caracter é substituido em cada elemento do vetor. A função `sub()` assim que encontra o elemento a substituir aplica a alteração e passa para outro elemento. Caso queiramos substituir todos os elementos devemos utilizar a função `gsub()`.

Exemplo de código:
```R
hits <-grup("\\.edu$",emails)
```
Cria um vetor com a posição/índice de valores da matriz e-mails que terminam em `.edu` (`$` para identicar final `^` inicio, \\ para indicar ao R que deverá incluir na procura o ponto `.`[o ponto em REGEX é um elemento especial que significa `todos os elemetos`]).

**More expressions:**
- `.*`: it can read as "any character that is matched zero or more times"
- `\\s`: match a space. The "s" is normally a character, escaping it (\\) makes it a metacharacter
- `[0-9]+`: Match the number 0 to 9, at least once (+)
- `([0-9]+)`: The parenthesis are used to make parts of the matching string available to define the replacement.

### Times and dates
`Sys.date()`: devolve a data atual do sistema
`Sys.time()`: devolve a data e a hora atual do sistema

O seguinte código convert um string para data. Se nada for especificado aquando da utilização da função `as.Date()` o R vai assumir a seguinte estrutura para as datas %Y - %m - %d
```R
my_date <- as.Date("1975-05-14")
```
**Formatos importantes para datas:**
- `%Y`: 4 digits years (1982)
- `%y:`2 digit years(82)
- `%m:` 2 digit months (01)
- `%d:` 2 digit day of the month (13)
- `%A:` weekday (wednesday)
- `%a:` abbreviated weekday (wed)
- `%B:` month (January)
- `%b:` abbreviated month(Jan) 