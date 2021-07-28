### Tratamento da base de dados 'abalone' ###
# Maqueise Pinheiro
# Última atualização: 28/07/2021
# Salvo com UTF-8
# 
library(caret)
library(dplyr)
library(fastDummies)
library(readr)

# lendo bases de dados
# 4177  9
base = readr::read_csv("abalone.data.csv", col_names = F) 

names(base) =
  c("Sex", "Length", "Diameter", "Height", "Whole weight", 
"Shucked weight", "Viscera weight", "Shell weight", "Rings"	)

# separando treino do teste
set.seed(92021)
noTreino = caret::createDataPartition(y = base$Rings, p = 0.75, 
                                      list = F)
treino = base[noTreino,] # 3134  9
teste = base[-noTreino,] # 1043  9

# transformando dummies ----
### treino: 3134    10
### teste:  1043    10
treino = dummy_cols(treino, 
                    remove_first_dummy = TRUE,
                    remove_selected_columns = TRUE)
teste = dummy_cols(teste, 
                   remove_first_dummy = TRUE,
                   remove_selected_columns = TRUE)

# exportando bases tratadas
readr::write_csv(treino, "abalone_treino.csv")
readr::write_csv(teste, "abalone_teste.csv")