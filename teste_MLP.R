### testes das funções ###
# Maqueise Pinheiro
# Última atualização: 27/07/2021
# Salvo com UTF-8
#

source("MLP_Maqueise.R", 
       encoding = "UTF-8")

(aux = matrix(c(1,2,3,1,
                5,2,1,0,
                2,4,1,1), nrow=3, byrow = T))

(aux2 = matrix(c(-1,  2,3,1,
                 5,1.5,1,0,
                 2,  4,1,1,
                 6,  1,2,0), nrow=4, byrow = T))

set.seed(92021)
(mod = perceptron.multicamadas(treino=aux[,-4],  
                               esperado=as.matrix(aux[,4]),
                               teste = aux2[,-4], 
                               esperado.teste = as.matrix(aux2[,4]),
                               max.iteracoes = 500))


saveRDS(mod, "x.rds")

x=readRDS("x.rds")
