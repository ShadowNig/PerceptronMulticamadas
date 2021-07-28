# Perceptron Multicamadas
[Algoritmo](./Algoritmo-Perceptron-Multicamadas-(Maqueise).R) do modelo de aprendizado de máquinas **percetron multicamadas**. 

Esse algoritmo foi criado para meu trabalho de conclusão do curso de estátistica na Universidade Federal Fluminense, intitulado ***[Perceptron Multicamadas: uma ferramenta de Aprendizado Supervisionado](./TCC-MLP-MaqueisePinheiro.pdf)***, visando analisar as diferenças entre modelos com diferentes quantidades de camadas e neurônios na camada oculta.

## Especificações
Para isso, foram rodados diversos modelos utilizando as especificações abaixo:

### Software
- `R`, versão 4.1.0

## Algoritmo
Foi baseado no algoritmo desenvolvido por **Mello e Ponti (2018)** em seu livro *A Practical Approach on the Statistical Learning Theory*, generalizando a quantidade de camadas na camada oculta.

### Argumentos

### Pacotes utilizados
+ `vctrs`, versão 0.3.8

## Modelos
- Todos os modelos foram gerados com semente 92021 por meio da função `set.seed()`
 
### Base de dados
Foi utilizadas a base *[adult](./adult)*, baixada em 18/06/2021 15h10min no [repositório de apredizado de máquinas da Universidade de Irvine, Califórnia (UCI)](https://archive.ics.uci.edu/ml/datasets/Adult).

#### Pré-processamentos 
+ foram removidas as linhas duplicadas, utilizando a função `dplyr::distinct`;
+ foram removidas as linhas que continham dados faltantes (NA), utilizando a função `na.omit`;
+ foram removidas as variaveis de **variancia quase zero** (*"capital_gain", "capital_loss"* e *"native_country"*), utilizando a função `caret::nearZeroVar`;
+ por fim, foi utilizado a função `fastDummies::dummy_cols` para transformar as variáveis categóricas em indicadoras.

#### Pacotes utilizados
+ `readr`, versão 1.4.0
+ `dplyr`, versão 2.1.1
+ `caret`, versão 6.0-88
+ `fastDummies`, versão 1.6.3


## Observações da função
1. Esse código foi pensado em cima do algoritmo desenvolvido por **Mello e Ponti** em seu livro *A Practical Approach on the Statistical Learning Theory*, generalizando a quantidade de camadas na camada oculta.
2. Esse código foi construído para ser utilizado com a **função de ativação sigmoidal**, dada por  html <a href="https://www.codecogs.com/eqnedit.php?latex=\inline&space;\dpi{150}&space;\bg_black&space;\large&space;{\color{White}&space;f=\frac{1}{1&plus;e^{-x}}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\inline&space;\dpi{150}&space;\bg_gray&space;\large&space;{\color{White}&space;f(x)=\frac{1}{1&plus;e^{-x}}}" title="\large {\color{White} f=\frac{1}{1+e^{-x}}}" /></a>. Por esse motivo, as saidas esperadas devem ser entre 0 e 1.
3. É necessario que todas as variáveis sejam numéricas. Caso existam variáveis categóricas, essas devem estar no formato de variavel indicadora (*dummie*).
4. Quando existir mais duas 2 categorias na variavel resposta, esta deve estar no formato de variavel indicadora (*dummie*).
5. É necessário ter instalado o pacote **vctrs**. Caso não tenha, é preciso rodar o comando: `install.packages("vctrs")`.
