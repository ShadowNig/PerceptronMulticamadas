### Modelos gerados pelo MLP ###
# Maqueise Pinheiro
# Última atualização: 28/07/2021
# Salvo com UTF-8
# 

# Rodando as funções necessárias para a geração dos modelos 
# do script principal
source("MLP_Maqueise.R", encoding = "UTF-8")

# Definindo bases de treino e teste com suas variáveis explicativas 
# (x) e respostas (y) separadas
treino = read.csv("abalone_treino.csv")
teste  = read.csv("abalone_teste.csv")

x.treino = treino[,-8]
y.treino = as.matrix(treino[, 8])
x.teste  = teste[ ,-8]
y.teste  = as.matrix(teste[ , 8])

# rodando os modelos -------------------------------------------

num.modelo = 0
# 1 camada oculta ----
for (i in c(2,3,5)) {
  num.modelo = num.modelo + 1
  
  # modelo
  set.seed(92021)
  mod = perceptron.multicamadas(treino=x.treino,  
                                esperado=y.treino,
                                teste = x.teste, 
                                esperado.teste = y.teste,
                                cam.oculta = i,
                                max.iteracoes = 10000,
                                titulo.plot = 
                                  paste("modelo", num.modelo))
  
  nome = paste("modelo ", num.modelo, ".rds", sep="")
  
  # salvando o modelo
  saveRDS(mod, nome)
}

# 2 camadas ocultas ----
# 2 neuronios na primeira camada
for (i in c(2,3,5)) {
  num.modelo = num.modelo + 1
  
  # modelo
  set.seed(92021)
  mod = perceptron.multicamadas(treino=x.treino,  
                                esperado=y.treino,
                                teste = x.teste, 
                                esperado.teste = y.teste,
                                cam.oculta = c(2,i),
                                max.iteracoes = 10000,
                                titulo.plot = 
                                  paste("modelo", num.modelo))
  
  nome = paste("modelo ", num.modelo, ".rds", sep="")
  
  # salvando o modelo
  saveRDS(mod, nome)
}
# 3 neuronios na primeira camada
for (i in c(2,3,5)) {
  num.modelo = num.modelo + 1
  
  # modelo
  set.seed(92021)
  mod = perceptron.multicamadas(treino=x.treino,  
                                esperado=y.treino,
                                teste = x.teste, 
                                esperado.teste = y.teste,
                                cam.oculta = c(3,i),
                                max.iteracoes = 10000,
                                titulo.plot = 
                                  paste("modelo", num.modelo))
  
  nome = paste("modelo ", num.modelo, ".rds", sep="")
  
  # salvando o modelo
  saveRDS(mod, nome)
}
# 5 neuronios na primeira camada
for (i in c(2,3,5)) {
  num.modelo = num.modelo + 1
  
  # modelo
  set.seed(92021)
  mod = perceptron.multicamadas(treino=x.treino,  
                                esperado=y.treino,
                                teste = x.teste, 
                                esperado.teste = y.teste,
                                cam.oculta = c(5,i),
                                max.iteracoes = 10000,
                                titulo.plot = 
                                  paste("modelo", num.modelo))
  
  nome = paste("modelo ", num.modelo, ".rds", sep="")
  
  # salvando o modelo
  saveRDS(mod, nome)
}

# 5 camadas ocultas ----
# mesma quantidade de neuronios em cada camada
for (i in c(2,3,5)) {
  num.modelo = num.modelo + 1
  
  # modelo
  set.seed(92021)
  mod = perceptron.multicamadas(treino=x.treino,  
                                esperado=y.treino,
                                teste = x.teste, 
                                esperado.teste = y.teste,
                                cam.oculta = rep(i, 5),
                                max.iteracoes = 10000,
                                titulo.plot = 
                                  paste("modelo", num.modelo))
  
  nome = paste("modelo ", num.modelo, ".rds", sep="")
  
  # salvando o modelo
  saveRDS(mod, nome)
}

# 10 camadas ocultas ----
## 2 neuronios em cada camada
num.modelo = num.modelo + 1
set.seed(92021)
mod = perceptron.multicamadas(treino=x.treino,  
                              esperado=y.treino,
                              teste = x.teste, 
                              esperado.teste = y.teste,
                              cam.oculta = rep(2, 10),
                              max.iteracoes = 10000,
                              titulo.plot = 
                                paste("modelo", num.modelo))
nome = paste("modelo ", num.modelo, ".rds", sep="")
saveRDS(mod, nome)

## 3 neuronios em cada camada
num.modelo = num.modelo + 1
set.seed(92021)
mod = perceptron.multicamadas(treino=x.treino,  
                              esperado=y.treino,
                              teste = x.teste, 
                              esperado.teste = y.teste,
                              cam.oculta = rep(3, 10),
                              max.iteracoes = 10000,
                              titulo.plot = 
                                paste("modelo", num.modelo))
nome = paste("modelo ", num.modelo, ".rds", sep="")
saveRDS(mod, nome)

## 5 neuronios em cada camada
num.modelo = num.modelo + 1
set.seed(92021)
mod = perceptron.multicamadas(treino=x.treino,  
                              esperado=y.treino,
                              teste = x.teste, 
                              esperado.teste = y.teste,
                              cam.oculta = rep(5, 10),
                              max.iteracoes = 10000,
                              titulo.plot = 
                                paste("modelo", num.modelo))
nome = paste("modelo ", num.modelo, ".rds", sep="")
saveRDS(mod, nome)




