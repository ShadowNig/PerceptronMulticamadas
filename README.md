# Perceptron Multicamadas
[Algoritmo](./MLP_Maqueise.R) do modelo de aprendizado de máquinas **perceptron multicamadas**. 

Esse algoritmo foi criado para meu trabalho de conclusão do curso de estátistica na Universidade Federal Fluminense, intitulado ***[Perceptron Multicamadas: uma ferramenta de Aprendizado Supervisionado](./TCC_MaqueisePinheiro.pdf)***, visando analisar as diferenças entre modelos com diferentes quantidades de camadas e neurônios na camada oculta.

## Especificações
Para isso, foram rodados diversos modelos utilizando as especificações abaixo:

### Software
Os modelos foram rodados em uma máquina virtual do ***[Google Cloud](https://console.cloud.google.com/home/dashboard?project=metal-episode-321013)***.
- Tipo de máquina: `e2-standard-4` (4 vCPUs, 16 GB de memória)
- Zona: `us-east4-c`
- `Ubuntu` 16.04.7 LTS (GNU/Linux 4.15.0-1098-gcp x86_64)
- `R`, versão 4.1.0
- `Git`, versão 2.0
- `Screen`, versão 4.03.01

## Algoritmo
Foi baseado no algoritmo desenvolvido por **Mello e Ponti (2018)** em seu livro *A Practical Approach on the Statistical Learning Theory*, generalizando a quantidade de camadas na camada oculta.

### Argumentos
- `treino`: data.frame ou matriz que será usada pra treinar o modelo. 
- `esperado`: data.frame ou matriz que deve conter os rótulos do `treino`. 
- `cam.oculta`: vetor ou constante com o número de neurônios em cada camada oculta. Default = c(2,3) (ou seja, duas camadas contendo 2 neurônios na primeira e 3 na segunda).
- `teste`: data.frame ou matriz que será usada pra testar o modelo. Se NULL, não realiza o teste. Default = NULL.
- `esperado.teste`: data.frame ou matriz que deve conter os rótulos do `teste`. Se NULL, não realiza o teste. Default = NULL.
- `max.iteracoes`: Número máximo de iterações que o modelo vai realizar. Default = 500.
- `max.erro`: Número máximo aceitavél do erro. Default = 0.1. (Obs.: Esse argumento foi disabilitado no meu trabalho. Mas é possível habilitar com simples modificações) 
- `taxa.aprendizado`: Taxa de aprendizado de será usada pra treinar o modelo. Default = 0.1.
- `tempo.max`: Tempo máximo em segundos que o modelo vai ficar rodando. Ao atingir esse tempo, ele retorna o que calculou até o momento. Default = 86400 (24h).
- `titulo.plot`: Título do plot dos erros em cada iteração. Default = "Evolução do erro".

## Modelos
- Todos os modelos foram gerados com semente 92021 por meio da função `set.seed()`.
- Para cada base foi gerado 18 modelos com as seguintes quantidades de neuronios e camadas:
 1. camadas: 1;  neuronios: 2;
 2.  camadas: 1;  neuronios: 3;
 3.  camadas: 1;  neuronios: 5;
 4.  camadas: 2;  neuronios: 2 e 2;
 5.  camadas: 2;  neuronios: 2 e 3;
 6.  camadas: 2;  neuronios: 2 e 5;
 7.  camadas: 2;  neuronios: 3 e 2;
 8.  camadas: 2;  neuronios: 3 e 3;
 9.  camadas: 2;  neuronios: 3 e 5;
 10. camadas: 2;  neuronios: 5 e 2;
 11. camadas: 2;  neuronios: 5 e 3;
 12. camadas: 2;  neuronios: 5 e 5;
 13. camadas: 5;  neuronios: 2 em cada camada;
 14. camadas: 5;  neuronios: 3 em cada camada;
 15. camadas: 5;  neuronios: 5 em cada camada;
 16. camadas: 10; neuronios: 2 em cada camada;
 17. camadas: 10; neuronios: 3 em cada camada;
 18. camadas: 10; neuronios: 5 em cada camada;
 
### Base de dados *Mushrooms*
Foi utilizadas a base *[mushrooms](./mushrooms)*, baixada em 18/06/2021 16h58min no [repositório de apredizado de máquinas da Universidade de Irvine, Califórnia (UCI)](https://archive.ics.uci.edu/ml/datasets/mushroom).

#### Pré-processamentos 
+ foram removidas as variaveis de **variancia quase zero** (*"gill-attachment", "veil-type"* e *"veil-color"*), utilizando a função `caret::nearZeroVar`;
+ foi removida a variável *"stalk-root"* que possui 30,5% de dados faltantes;
+ foi utilizada a função `caret::createDataPartition`, para fazer a divisão da base em uma amostra de treino e outra de teste mantendo a proporção de classe dos rotulos nas duas amostras (utilizando a semente 92021); 
+ por fim, foi utilizado a função `fastDummies::dummy_cols` para transformar as variáveis categóricas em indicadoras.

#### Pacotes utilizados
+ `readr`, versão 1.4.0
+ `dplyr`, versão 2.1.1
+ `caret`, versão 6.0-88
+ `fastDummies`, versão 1.6.3
+ `visdat`, versão 0.5.3

> Futuramente...
> 
> ### Base de dados *Dry Bean*
> Foi utilizadas a base *[drybean](./drybean)*, baixada em 18/06/2021 16h00min no [repositório de apredizado de máquinas da Universidade de Irvine, Califórnia (UCI)](https://archive.ics.uci.edu/ml/datasets/Dry+Bean+Dataset).
>
> #### Pré-processamentos 
> + foram removidas as linhas repetidas usando a função `dplyr::distinct`;
> + foi utilizada a função `caret::createDataPartition`, para fazer a divisão da base em uma amostra de treino e outra de teste mantendo a proporção de classe dos rotulos nas duas amostras (utilizando a semente 92021); 
> + as duas amostras tiveram seus valores padronizados pelos parametros do treino utilizando a função `caret::preProcess`;
> + por fim, foi utilizado a função `fastDummies::dummy_cols` para transformar as variáveis categóricas em indicadoras.
>
> #### Pacotes utilizados
> + `readr`, versão 1.4.0
> + `dplyr`, versão 2.1.1
> + `caret`, versão 6.0-88
> + `fastDummies`, versão 1.6.3
> + `readxl`, versão 1.3.1


## Observações da função
1. Esse código foi pensado em cima do algoritmo desenvolvido por **Mello e Ponti** em seu livro *A Practical Approach on the Statistical Learning Theory*, generalizando a quantidade de camadas na camada oculta.
2. Esse código foi construído para ser utilizado com a **função de ativação sigmoidal**, dada por   <a href="https://www.codecogs.com/eqnedit.php?latex=\inline&space;\dpi{150}&space;\bg_black&space;\large&space;{\color{White}&space;f=\frac{1}{1&plus;e^{-x}}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\inline&space;\dpi{150}&space;\bg_gray&space;\large&space;{\color{White}&space;f(x)=\frac{1}{1&plus;e^{-x}}}" title="\large {\color{White} f=\frac{1}{1+e^{-x}}}" /></a>. Por esse motivo, as saidas esperadas devem ser entre 0 e 1.
3. É necessario que todas as variáveis sejam numéricas. Caso existam variáveis categóricas, essas devem estar no formato de variavel indicadora (*dummie*).
4. Quando existir mais duas 2 categorias na variavel resposta, esta deve estar no formato de variavel indicadora (*dummie*).
