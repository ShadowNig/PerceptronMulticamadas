### Tratamento da base de dados 'adult' ###
# Maqueise Pinheiro
# Última atualização: 27/07/2021
# Salvo com UTF-8
# 

# lendo bases de treino e teste
### treino: 32561    15
### teste:  16281    15
treino = readr::read_csv("adult.treino.csv", col_names = F, na = "?")
teste = readr::read_csv("adult.teste.csv", col_names = F, na = "?")

# definindo nome das variaveis
names(treino) = names(teste) =
  c("age", "workclass", "fnlwgt", "education" ,
    "education_num", "marital_status", "occupation", 
    "relationship", "race", "sex", "capital_gain", 
    "capital_loss", "hours_per_week", 
    "native_country", "over_50K_a_year")
treino$`over_50K_a_year` = ifelse(treino$over_50K_a_year==">50K",
                                  "Yes", "No")
teste$`over_50K_a_year` = ifelse(teste$over_50K_a_year==">50K.", 
                                 "Yes", "No")

# removendo:
## linhas repetidas
##### treino: 32537    15 (-24 linhas)
##### teste:  16276    15 (-5 linhas)
## linhas com dados faltantes
##### treino: 30139    15 (-2398 linhas)
##### teste:  15055    15 (-1221 linhas)
## native_country que possui variancia quase zero e 
## education_num que possui a mesma informação que education
##### treino: 30139    13 (-2 colunas)
##### teste:  15055    13 (-2 colunas)
(remover = caret::nearZeroVar(treino, names = T))

treino = treino |> dplyr::distinct() |> na.omit() |> 
  dplyr::select(-c(native_country, education_num))
teste = teste |> dplyr::distinct() |> na.omit() |> 
  dplyr::select(-c(native_country, education_num))

# transformando variaveis categoricas em indicadoras (dummies)
### treino: 30139    56 
### teste:  15055    56
treino = fastDummies::dummy_cols(treino, 
                                 remove_first_dummy = TRUE,
                                 remove_selected_columns = TRUE)
teste = fastDummies::dummy_cols(teste, 
                                remove_first_dummy = TRUE,
                                remove_selected_columns = TRUE)


# exportando bases tratadas
readr::write_csv(treino, "adult_treino.csv")
readr::write_csv(teste, "adult_teste.csv")

