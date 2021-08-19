source("MLP_Maqueise_plot_acuracia.R", encoding = "UTF-8")

treino = read.csv("mushrooms_treino.csv")
teste  = read.csv("mushrooms_teste.csv")

x.treino = treino[1:100,-1]
y.treino = as.matrix(treino[1:100,1])

# modelo 7
set.seed(92021)
mod = perceptron.multicamadas(treino=x.treino,  
                              esperado=y.treino,
                              cam.oculta = c(3,2),
                              max.iteracoes = 10000,
                              pc=0.4991)

saveRDS(mod, "acc mod7.rds")

# modelo 13
set.seed(92021)
mod = perceptron.multicamadas(treino=x.treino,  
                              esperado=y.treino,
                              cam.oculta = c(2,2,2,2,2),
                              max.iteracoes = 10000,
                              pc=0.5085)

saveRDS(mod, "acc mod13.rds")

# modelo 17
set.seed(92021)
mod = perceptron.multicamadas(treino=x.treino,  
                              esperado=y.treino,
                              cam.oculta = c(3,3,3,3,3,3,3,3,3,3) ,
                              max.iteracoes = 10000,
                              pc=0.5302)

saveRDS(mod, "acc mod17.rds")
