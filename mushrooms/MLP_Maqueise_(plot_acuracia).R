### Algoritmo Perceptron Multicamadas ###
# Maqueise Pinheiro
# Última atualização: 26/07/2021
# Salvo com UTF-8
# 

options(scipen = 999) # remove notação científica

# Estrutura do modelo ----
# Inicializa os parametros aleatoriamente entre -1 e 1.
# Recebe:
# 1-tamanhos das camadas de entrada, 
# 2- oculta (que pode ser um vetor) 
# 3- e saída.
# Retorna uma lista contendo: 
# 1- tamanhos das camadas de entrada, oculta e saída.
# 2- lista com parâmetros iniciais de todas as camadas
estrutura.mlp = function(neuronios.entrada = 2,
                         neuronios.oculta = c(3,2),
                         neuronios.saida = 1) {
  
  # Lista com os parâmetros iniciais
  parametros = list()
  
  # Concatenando os tamanhos das camadas de entrada e oculta
  tam.entrada.oculta = c(neuronios.entrada, neuronios.oculta)
  
  # Cada camada da camada oculta vai ter (tam.entrada.oculta[camada]
  # +1) parâmetros para cada (neuronios.oculta[camada]) neurônios 
  # dela. O termo +1 se refere ao viés (theta)
  for(camada in 1:length(neuronios.oculta)){
    parametros[[camada]] =
      runif(min=-1, max=1, 
            n=(neuronios.oculta[camada] *
                 (tam.entrada.oculta[camada]+1)) ) |> 
      matrix(nrow=(tam.entrada.oculta[camada]+1), 
             ncol=neuronios.oculta[camada])
  }
  
  # A camada de saida vai ter (neuronios.oculta+1) parametros 
  # para cada neuronio dela (neuronios.saida). O termo +1 se 
  # refere ao vies (theta)
  parametros$saida = 
    runif(min=-1, max=1, 
          n=(neuronios.saida *
               (tail(neuronios.oculta,1)+1)) ) |> 
    matrix(nrow=(tail(neuronios.oculta,1)+1), 
           ncol=neuronios.saida)
  
  # Lista de retorno com a estrutura do modelo
  ret = list()
  ret$neuronios.entrada = neuronios.entrada
  ret$neuronios.oculta = neuronios.oculta
  ret$neuronios.saida = neuronios.saida
  ret$parametros = parametros
  
  return (ret)
}

# Calculando os resultados de cada neurônio ----
# passa os dados das variaveis explicativas pelo modelo
# Recebe:
# 1-estrutura do modelo
# 2-base de dados com as variáveis explicativas
# 3-indice da linha/observação que será calculada
# Retorna uma lista contendo: 
# 1-resultados dos neurônios da camada oculta em que cada elemento 
# da lista é uma matriz com os resultados de uma camada
# 2-resultados dos neuronios da camada de saída
result.neur = function(estrutura, x, i) {
  
  # Função Sigmoidal 
  f.ativacao = function(redes){1 / (1 + exp(-redes))}
  
  # passando a observação pela camada oculta
  ## lista que vai conter os resultados dos neuronios das camadas 
  result.oculta = list()
  
  redes.oculta = c(as.vector(x[i,]), 1) %*%
    estrutura$parametros[[1]] 
  
  result.oculta[[1]] = f.ativacao(redes.oculta)
  
  ## se tiver mais de uma camada na cam oculta, 
  if(length(estrutura$neuronios.oculta)>1){
    for(camada in 2:length(estrutura$neuronios.oculta) ){
      redes.oculta = c(result.oculta[[camada-1]], 1) %*%
        estrutura$parametros[[camada]] 
      
      result.oculta[[camada]] = f.ativacao(redes.oculta)
    }
  }
  
  # passando o resultado = da camada oculta pela camada de saída
  redes.saida = c(result.oculta[[length(result.oculta)]], 1) %*% 
    estrutura$parametros$saida
  
  result.saida = f.ativacao(redes.saida)
  
  # lista com os resultados dos neurônios
  ret = list()
  ret$result.oculta = result.oculta
  ret$result.saida = result.saida
  
  return (ret)
}

# Treinando o modelo ----
# Recebe:
# 1-estrutura do modelo
# 2-base de treino com as variaveis explicativas
# 3-base de treino com os rotulos de resposta
# 4-taxa de aprendizado (eta)
# 5-limiar de erro aceitável (delta)
# 6-maximo de iterações
# 7-maximo de tempo de processamento em segundos
# Retorna lista com: 
# 1-numero de neuronios
# 2-parâmetros treinados
# 3-vetor de erros
# 4-quantidade de iteracoes rodadas
treina.mlp = function(estrutura, x.treino, y.treino, 
                      eta=0.1, #delta=0.1,
                      max.iteracoes = 500,
                      tempo.max = 86400, pc=0.5) {
  # controle de tempo do treino 
  tempo.inicial = proc.time()
  
  #erro.quadrado = delta * 2
  iteracao = 0
  armazena.erro = NULL
  precisao = NULL
  
  # enquanto o erro for maior que um limiar delta e o numero de 
  # iterações não atingir o máximo determinado
  while (#erro.quadrado > delta & 
    iteracao < max.iteracoes) {
    
    # Se o tempo de treino for maior que um tempo máximo determinado,
    # a função retorna o que computou até o momento
    if((proc.time()[3] - tempo.inicial[3]) > tempo.max){
      cat("24h atingidas")
      return(estrutura)}
    
    # contabilizando a quantidade de iterações 
    iteracao = iteracao + 1
    
    # erro.quadrado vai conter a soma dos erros ao quadrado 
    # de cada observação na base de treino
    erro.quadrado = 0
    saida = NULL
    
    # para cada observação (linha)
    for (i in 1:nrow(x.treino)) {
      
      # obtendo os resultados de cada neurônio com a i-ésima 
      # observação
      result = result.neur(estrutura, x.treino, i)
      
      # Calculando o erro entre a saída esperada e calculadas
      erro = (y.treino[i,] - result$result.saida)
      erro.quadrado = erro.quadrado + sum(erro^2)
      
      
      # Calculando a derivada relativa a camada de saída que é
      # um termo do gradiente descendente
      der.saida = erro * result$result.saida * (1-result$result.saida)
      
      # Calculando a derivada relativa a camada oculta que é
      # um termo do gradiente descendente
      der.oculta = list()
      aux = der.saida
      
      for(camada in length(estrutura$neuronios.oculta):1){
        
        omega=t(estrutura$parametros[[camada+1]][
          1:estrutura$neuronios.oculta[camada],])
        
        der.oculta[[camada]] = result$result.oculta[[camada]] * 
          (1 - result$result.oculta[[camada]]) * 
          aux %*% omega
        
        aux = der.oculta[[camada]]
      }
      
      # atualizando os parâmetros da camada de saída com o 
      # gradiente descendente
      estrutura$parametros$saida = 
        estrutura$parametros$saida + eta * 
        matrix(c(result$result.oculta[[length(result$result.oculta)]], 
                 1)) %*% der.saida
      
      
      # atualizando os parâmetros da camada oculta com o 
      # gradiente descendente
      for(camada in length(estrutura$neuronios.oculta):1){
        if(camada > 1){
          estrutura$parametros[[camada]] =
            estrutura$parametros[[camada]] + eta * 
            matrix(c(result$result.oculta[[camada-1]], 
                     1)) %*% der.oculta[[camada]]
        }else{
          estrutura$parametros[[camada]] =
            estrutura$parametros[[camada]] + eta * 
            matrix(c(x.treino[i,], 1)) %*% der.oculta[[camada]]
        }
      }
      saida = rbind(saida, as.vector(result$result.saida))
    }
    
    classif = ifelse(saida>=pc, 1, 0)
    precisao[iteracao]=sum(ifelse(classif==y.treino,1,0))/
      length(classif)
    
    # Dividindo o erro.quadrado que é a a soma dos erros ao quadrado
    # de cada observação pela quantidade de observações, a fim de 
    # obter o erro quadrado médio
    erro.quadrado = erro.quadrado / nrow(x.treino)
    armazena.erro[iteracao] = erro.quadrado
    # Imprimindo o erro quadrado médio de cada iteração
    cat("Iteração: ", iteracao, 
        "  Erro quadrado = ", erro.quadrado, "\n", sep="")
    
    estrutura$iteracao = iteracao
    estrutura$erro = armazena.erro
    estrutura$precisao = precisao
  }
  
  # retorna a estrutura do modelo com os parâmetros treinados
  return (estrutura)
}

# Predizendo resultados de novos dados ----
# Recebe:
# 1-estrutura do modelo final
# 2-base de teste com as variaveis explicativas
# 3-base de teste com os rotulos de resposta
# 4-se vai apresentar o "debug" ou não
# Retorna: 
# 1-predições
# 2-se debug=T, imprime entrada, saída esperada e saída obtida
predicao.mlp = function(estrutura, x.teste, y.teste=NULL, debug=F) {
  
  if(debug & is.null(y.teste) )stop(
    "os rótulos de resposta y.teste devem ter mesmo 
    comprimento da base x.teste")
  
  # iniciando a matriz que vai conter as predicoes
  saida = matrix(rep(0, estrutura$neuronios.saida), nrow=1)
  
  # para cada observação (linha)
  for (i in 1:nrow(x.teste)) {
    
    # obtendo os resultados de cada neurônio com a i-ésima 
    # observação
    result = result.neur(estrutura, x.teste, i)
    
    # se debug=T, imprime entrada, saída esperada e saída obtida
    if (debug) {
      cat("\n","Entrada = ", as.vector(x.teste[i,]), "\n", 
          "Saida Esperada = ", as.vector(y.teste[i,]), "\n", 
          "Saida Obtida = ", as.vector(result$result.saida), "\n")
    }
    
    # Concatenando as predições de cada observação em uma linha da 
    # matriz saida
    saida = rbind(saida, as.vector(result$result.saida))
  }
  
  predicao = saida[-1,]
  
  # Retornando predições
  return (predicao)
}

# Perceptron Multicamadas ----
# Recebe:
# 1-amostra de treino com as variaveis explicativas
# 2-amostra de treino com a(s) variavei(s) resposta(s)
# 3-quantidade de neuronios em cada camada oculta. (se apenas uma 
# camada, entao 'cam.oculta' será uma constante. Se mais de uma, 
# entao será um vetor)
# 4-amostra de teste com as variaveis explicativas
# 5-amostra de teste com a(s) variavei(s) resposta(s)
# 6-numero maximo de iterações
# 7-limite maximo de erro aceitavel ###
# 8-taxa de aprendizado
# 9-tempo maximo de processamento do modelo em segundos
# Retorna: 
# 1-predições
perceptron.multicamadas=function(treino, 
                                 esperado, 
                                 cam.oculta = c(2,3),
                                 teste = NULL,
                                 esperado.teste = NULL,
                                 max.iteracoes = 500,
                                 # max.erro = 0.1,
                                 taxa.aprendizado = 0.1,
                                 tempo.max = 86400,
                                 titulo.plot = "Evolução do erro",
                                 pc=0.5){
  # t.inicial vai auxiliar na contabilização do tempo de 
  # processamento do modelo
  t.inicial = proc.time()
  
  # testando requisitos básicos
  if((is.null(teste) & !is.null(esperado.teste)) | 
     (!is.null(teste) & is.null(esperado.teste)) )
    stop("para testar o modelo, é preciso preencher o 
         argumento 'teste' e também o 'esperado.teste'")
  
  if( !(class(treino)[1] %in% 
        c("array", "matrix", "data.frame", "tibble", 
          "spec_tbl_df", "tbl_df", "tbl" )))
    stop("A classe do argumento `treino` deve ser um 
         data.frame ou uma matrix")
  
  if( !(class(esperado)[1] %in% 
        c("array", "matrix", "data.frame", "tibble", 
          "spec_tbl_df", "tbl_df", "tbl" )))
    stop("A classe do argumento `esperado` deve ser um 
         data.frame ou uma matrix")
  
  # os dados precisam ser matrizes por causa dos calculos
  treino = as.matrix(treino)
  esperado = as.matrix(esperado)
  # teste = as.matrix(teste)
  # esperado.teste = as.matrix(esperado.teste)
  
  # criando a estrutura do modelo
  est = estrutura.mlp(neuronios.entrada = ncol(treino),
                      neuronios.oculta = cam.oculta,
                      neuronios.saida = ncol(esperado))
  
  # treinando o modelo
  modelo = treina.mlp(estrutura = est, 
                      x.treino = treino, 
                      y.treino = esperado,
                      eta = taxa.aprendizado, 
                      #delta = max.erro,
                      max.iteracoes = max.iteracoes,
                      tempo.max = tempo.max, pc = pc)
  
  # gerando as predicoes em relacao a amostra de treino e o erro 
  # chamado "dentro da amostra" tambem associada a ela 
  modelo$predicao.treino = predicao.mlp(estrutura = modelo , 
                                        x.teste =  treino)
  modelo$erro.dentro.amostra = 
    sum((esperado - modelo$predicao.treino)^2)/nrow(treino)
  
  # gerando as predicoes em relacao a amostra de teste e o erro 
  # chamado "fora da amostra" tambem associada a ela 
  if(!is.null(teste)){
    modelo$predicao = predicao.mlp(estrutura = modelo,
                                   x.teste = teste)
    modelo$erro.fora.amostra =  
      sum((esperado.teste - modelo$predicao)^2)/nrow(teste)
  }
  
  # plotando a evolução dos erros 
  plot(modelo$erro, xlab = "Iteração", 
       ylab = "Erro quadrado médio",
       main = titulo.plot)
  
  # guardando o tempo usado para a geração de todo o modelo
  modelo$tempo.proc = proc.time() - t.inicial
  
  return(modelo)
}
