### Algoritmo Perceptron ###
# Autor: Maqueise Pinheiro
# Última atualização: 28/04/2021
# Salvo com UTF-8
# 

# Função Heaviside ----
g = function(redes, epsilon=0) {
  epsilon = rep(epsilon, length(redes))
  saida = (redes > epsilon) + 0
}

# Perceptron ----
# treina o modelo e retorna os parâmetros que minimizam o erro quadrado
perceptron = function(treino, delta=0.01, eta=0.1){
  
  # Organizando as variaveis resposta e explicativas
  n = nrow(treino)
  nVar = ncol(treino)
  Y = treino[,nVar]
  X = cbind(treino[,-nVar], rep(1, n))
  
  ## Passo 1: Iniciando os parâmetros aleatoriamente entre -0.5 e 0.5
  parametros_atualizado = runif(min=-0.5, max=0.5, n=nVar)
  erro_quadrado = 2*delta
  iteracao = 0
  
  while (erro_quadrado>delta){
    
    iteracao = iteracao+1
    parametros = parametros_atualizado
    
    ## Passo 2: Calculando as redes
    redes = X %*% parametros
    
    ## Passo 3: Calculando o erro quadrado
    saida = g(redes)
    erro_quadrado = sum( (Y-saida)^2 )
    cat("Erro quadrado = ", erro_quadrado, "\n")
    
    ## Passo 4: Atualizando os parâmetros até erro ser menor que o limite
    for(p in 1:nVar){
      parametros_atualizado[p] = 
        parametros[p] + eta * 2 * sum( (Y-redes)* X[,p] )
    }  
    
  }
  
  cat("num de iterações até convergência:", iteracao, "\n")
  return(parametros)
  
}

# Predizendo novos valores ----
# aplica o modelo em nova amostra e retorna a classificacao da mesma
perceptron.predict = function(modelo, amostra, real=NULL){
  X = cbind(amostra, rep(1, nrow(amostra)))
  rede = X %*% modelo
  saida = g(rede)
  if(!is.null(real)){
    cat("real \t predito \n")
    for(i in 1:nrow(amostra)){
      cat(real[i], "\t", saida[i], "\n")
    }
  }
  saida
}

# Exemplo ----
amostra.treino = matrix(c(0.0, 0.0, 0,
                          0.1, 0.2, 0,
                          0.2, 0.4, 0,
                          0.3, 0.6, 0,
                          0.4, 0.8, 0,
                          0.5, 1.0, 0,
                          0.6, 1.2, 1,
                          0.7, 1.4, 1,
                          0.8, 1.6, 1,
                          0.9, 1.8, 1,
                          1.0, 1.0, 1),
                        nrow=11,
                        ncol=3,
                        byrow=TRUE)

(modelo = perceptron(amostra.treino, eta=0.01))

amostra.teste = matrix(c(0.0, 0.0, 0,
                         0.1, 0.1, 0,
                         2.0, 0.4, 0,
                         0.4, 0.6, 0,
                         0.4, 0.8, 0,
                         0.5, 2.0, 0,
                         0.6, 1.2, 1,
                         0.7, 1.4, 1,
                         0.8, 1.6, 1,
                         0.85,1.8, 1,
                         1.0, 1.0, 1),
                       nrow=11,
                       ncol=3,
                       byrow=TRUE)

predicao = perceptron.predict(modelo, 
                              amostra.teste[,-3], amostra.teste[,3])

#install.packages("caret")
caret::confusionMatrix(data=as.factor(predicao), 
                       reference=as.factor(amostra.teste[,3]))  

