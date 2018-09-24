---
PageTitle: Introdution to R
---
# Introdution to R
O R funciona com diversos tipos de dados sendo os seguintes os mais utilizados:
- Decimais como 4.5 (ter em atenção que o R está formatado para inglês onde os decimais usam ponto e não virgual) são chamados de _numerics_
- Numeros naturais como 4 são chamados de _integers_. Os Integers também são decimais
- Caracteres Boleanos (verdadeiro ou falso) são chamados de _lógicos_. (Para os definir não é necessário utilizar "" como nos caracteres)
- Texto ou _characters_

Existem diferentes formas e funções que nos permitem saber a classe de determinada variável. Uma das mais utilizadas é através da função (base) `class()`.

>Ter em atenção que o R é Case sensitive

> **Quote:** vectors are one dimension arrays that can hold numeric data, character data, or logical data. In other words, a vector is a simple tool to store data. For example, you can store your daily gains and losses in the casinos.

Para criar um vetor usamos a função `c()`. Exemplo:

```R
music_vector <- c(1,2,3)
```
De forma a tornar mais clara a leitura dos dados podemos nomear os elementos do vetor. Para tal usamos a função `names()`.

```R
some_vector <- c("John Doe","poker player")
names(some_vector) <- c("Name","Profession")

Name        Profession
John Doe    poker player
```
É necessário tem em atenção que se os nomes forem em texto então têm que ser introduzidos como um vector de caracteres. Em vez de nomear cada elemento individualmente, também é possivel definir os nomes a atribuir através de uma variável.

> Ter em atenção que o R quando executa operações com vectores, por defeito, efetua a operação elemento por elemento, ou seja, somando vetor A e B vai somar o primeiro elemento de A com o primeiro elemento de B.

A função `sum()` soma todos os valores dentro de um vetor.

> **Quote:** To select elements of a vector (and later matrices, data frames, ...) you can use square brackets []. Between the square brackets, you indicate what elements to select. For example, to select the first of the vector, you type `poker_vector[1]`

Se quisermos mais que um valor, então podemos definir um vector com as posições necessárias, exemplo A[c(1,5)] devolve a 1ª e 5º elemento do vector A. Se os nº forem sequênciais podemos abreviar utilizando `:`, exemplo `A[2:4]` devolverá a 2ª, 3ª e 4ª posição. Caso tenhamos nomeado os elementos do vector, então podemos fazer a selecção utilizando os nomes dentro de [].

`mean()` devolve a média simples de um vector.

---
O R usa os seguintes comparadores lógicos:

```R
< for less than
> for greater than 
<= for less than or equal to
>= for greater than or equal to
== for equal to each other
!= not equal to each other
```
Quando colocamos em selecção (entre parêntesis rectos) um vector lógico, R sabe que tem de devolver apenas aqueles que são verdadeiros.

---

Uma **matriz** é uma colecção de elementos do mesmo tipo de data. A matriz pode ser criada utilizando a formula `matrix()`.

```R
matrix (1:9, byrow = TRUE, nrow = 3)

[1]
1 2 3
4 5 6
7 8 9
```
Este código cria uma matriz com 3 linhas preenchidas com os números entre 1 e 9. Como escolhemos `byrow = TRUE` então a matriz foi preenchida seguindo uma ordem por linha. Caso tivessemos seleccionado FALSE, então a matriz seria preenchida coluna a coluna. Utilizando este código, o nº de linhas tem sempre de ser um multiplo das colunas. Ou seja, no caso de termos definido apenas a sequência 1:8, de onde não resultaria um elemento para a posição [3,3], o código daria um erro.

Tal como no caso dos vectore, também é possível nomear as colunas e linhas de um vetor. Para tal usamos o seguinte código:

```R
rownames(my_matrix) <- row_names_vector
colnames(my_matrix) <- col_names_vector
```
Em R a função `rowSums()` devolve o somatório para cada linha em uma matriz. Esta função cria um novo vector com os resultados. Alternativamente para a soma das colunas utilizamos a função `colSums()`.

Para acrescentar a um vetor ou matriz uma nova coluna utilizamos a função `cbind()` ou para o caso de linhas `rbind()`

À semelhança do que acontece com os vetores, também é possível utilizar [] para seleccionar elementos de uma matriz. No entanto, no caso das matrizes, é necessário incluir nas coordenadas informação quanto à linha tal como a coluna.

`my_matrix [1,2]` devolve o elemento contido na linha 1 e coluna 2. Se quisermos seleccionar apenas a primeira coluna ou linha (na sua totalidade), devemos deixar a outra coordenada em branco, exemplo `my_matrix [,1]` selecciona apenas a primeira coluna._ É importante ter em atenção que estas funções têm como outputs novos vetores ou matrizes._

> **Nota:** caso queiramos efetuar a multiplicação aplicando cálculo matricial deveremos utilizar `%x%`. 

Ver exemplo de cálculo matricial em  [Explicação operações com matrizes](https://www.somatematica.com.br/emedio/matrizes/matrizes4.php)

> **Quote** The term factor refers to a statistical data type used to store categorical variables. The difference between a categorical variable and a continuous variable is that a categorical variable can belong to a limited number of categories. A continuous variable, on the other hand, can correspond to an infinite number of values. [Um exemplo é o genero que apenas pode ser masculino ou feminino].

Para criar fatores em R usa-se a função `factor()`. Exemplo `factor(sex_vector)` cria o vector com factor e vai considerar que existem níveis dentro deste vector.

> **Quote** There are two types of categorical variables: a nominal categorical variables and an ordinal categorical variable. A nominal variable is a categorical variable without an implied order. This mean that it is impossible to say that one is worth more than the other.

A função `level()` permie renomear os níveis das categorias. Quando utilizamos categorias, a função `summary()` diz-nos quantos elementos existem dentro de cada uma. Esta função, quando aplicada a um vector sem class, devolveria apenas a dimensão e o tipo de dados.

Por defeito a função `factor()` cria categorias não ordenadas. Para criar ordem que permita ser comparada é necessário incluir termos adicionais à função:

```R
factor(,ordered = TRUE, levels = c("level 1", "level 2",...))
```
---
### Dataframes
Um data frame, por oposição às matrizes, incluid dados de diferentes categorias. Por norma, as variáveis de um dataframe aparecem como colunas sendo que as obeservações são registadas como linhas. Devido ao facto de muitos dataframes serem extensos e conterem muitos dados, é usual verificar a tipologia dos dados recorrendo às funções `head()` e `tail()`

A função `str()` permite consultar a estrutura de um data frame.
A função `data.frame()` permite criar um data frame. À semelhança dos vetores e matrizes, é possivel seleccionar elementos especificos recorrendo a [].

A função `subset(my_df, subset = some_condition)` permite dividir um dataframe. Se por exemplo a variável for lógica, a inclusão do nº da coluna significa automáticamente que só queremos condições que são verdadeiras.

`order()` is a function that gives you the ranked position of each element when it is applied on a variable, such as vector for example:
```R
a <- c(100,10,1000)
order(a)
[1] 2 1 3

a[order(a)]
10 100 1000
```

Se usar a mesma formula de selecção [], mas colocar na coordenada das linhas uma variável de ordem, o R irá reorganizar o Dataframe (crescente ou decrescente).

A list in R allows you to gather a variety of objects under one name in ordered way. These objects can be matrices, vectors, dataframes, even other lists. It is not required that these objects are related to each other in any way. In order to build a list we use the base function `List()`.