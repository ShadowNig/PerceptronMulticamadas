### Tratamento da base de dados 'Dry Bean' ###
# Maqueise Pinheiro
# Última atualização: 28/07/2021
# Salvo com UTF-8
# 
library(readxl)
library(caret)
library(dplyr)
library(fastDummies)
library(readr)

# lendo bases de dados
# 13611    17
base = readxl::read_excel("Dry_Bean_Dataset.xlsx") 

# removendo linhas repetidas
# 13543    17
base = dplyr::distinct(base)
summary(base)

# separando treino do teste
set.seed(92021)
noTreino = caret::createDataPartition(y = base$Class, p = 0.75, 
                                      list = F)
treino = base[noTreino,] # 10160    17
teste = base[-noTreino,] # 3383     17

# padronizando os dados 
padronizacao = caret::preProcess(treino, 
                                 method = c("center","scale"))
treino.pad = predict(padronizacao,treino)
teste.pad = predict(padronizacao,teste)

# transformando variaveis categoricas em indicadoras (dummies)
### treino: 10160    22
### teste:  3383     22
treino = fastDummies::dummy_cols(treino.pad, 
                                 remove_first_dummy = TRUE,
                                 remove_selected_columns = TRUE)
teste = fastDummies::dummy_cols(teste.pad, 
                                remove_first_dummy = TRUE,
                                remove_selected_columns = TRUE)

# exportando bases tratadas
readr::write_csv(treino, "drybean_treino.csv")
readr::write_csv(teste, "drybean_teste.csv")










