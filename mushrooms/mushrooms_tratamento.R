### Tratamento da base de dados 'mushrooms' ###
# Maqueise Pinheiro
# Última atualização: 28/07/2021
# Salvo com UTF-8
#
library(readr)
library(dplyr)
library(caret)
library(fastDummies)
library(visdat)

# lendo bases de dados
# 8124   23
base = read_csv(
  "mushrooms.csv", na = "?", 
  col_types = cols(bruises = col_character(), 
                   `gill-attachment` = col_character())) 

# redefinindo labels dos fatores ----
base = base|> 
  transmute(
    classes = factor(class, levels = c("e", "p"), 
                     labels = c("edible","poisonous")),
    `cap shape` = factor(`cap-shape`, 
                         levels = c("b","c","f","k","s","x"), 
                         labels = c("bell","conical","flat",
                                    "knobbed","sunken","convex")),
    `cap surface` = factor(`cap-surface`, 
                           levels = c("f","g","y","s"), 
                           labels = c("fibrous","grooves",
                                      "scaly","smooth")),
    `cap color` = factor(`cap-color`, 
                         levels = c("n","b","c","g",
                                    "r","p","u","e","w","y"), 
                         labels = c("brown","buff","cinnamon","gray",
                                    "green","pink","purple","red",
                                    "white","yellow")),
    bruises = factor(bruises, 
                     levels = c("f","t"), 
                     labels = c("no","yes")),
    odor = factor(odor, 
                  levels = c("a","l","c","y","f",
                             "m","n","p","s"), 
                  labels = c("almond","anise","creosote",
                             "fishy","foul","musty","none",
                             "pungent","spicy")),
    `gill-attachment` = factor(`gill-attachment`, 
                               levels = c("a","f"), 
                               labels = c("attached","free")),
    `gill-spacing` = factor(`gill-spacing`, 
                            levels = c("c","w"), 
                            labels = c("close","crowded")),
    `gill-size` = factor(`gill-size`, 
                         levels = c("b","n"), 
                         labels = c("broad","narrow")),
    `gill-color` = factor(`gill-color`, 
                          levels = c("k","n","b","h","g",
                                     "r","o","p","u","e",
                                     "w","y"), 
                          labels = c("black","brown","buff","chocolate","gray",
                                     "green","orange","pink","purple","red",
                                     "white","yellow")),
    `stalk-shape` = factor(`stalk-shape`, 
                           levels = c("e","t"), 
                           labels = c("enlarging","tapering")),
    `stalk-root` = factor(`stalk-root`, 
                          levels = c("b","c","e","r"), 
                          labels = c("bulbous","club","equal","rooted")),
    `stalk-surface-above-ring` = factor(`stalk-surface-above-ring`, 
                                        levels = c("f","y","k","s"), 
                                        labels = c("fibrous","scaly","silky","smooth")),
    `stalk-surface-below-ring` = factor(`stalk-surface-below-ring`, 
                                        levels = c("f","y","k","s"), 
                                        labels = c("fibrous","scaly","silky","smooth")),
    `stalk-color-above-ring` = factor(`stalk-color-above-ring`, 
                                      levels = c("n","b","c","g","o",
                                                 "p","e","w","y"), 
                                      labels = c("brown","buff","cinnamon","gray","orange",
                                                 "pink","red","white","yellow")),
    `stalk-color-below-ring` = factor(`stalk-color-below-ring`,
                                      levels = c("n","b","c","g","o",
                                                 "p","e","w","y"), 
                                      labels = c("brown","buff","cinnamon","gray","orange",
                                                 "pink","red","white","yellow")),
    `veil-type` = factor(`veil-type`, 
                         levels = c("p","u"), 
                         labels = c("partial","universal")),
    `veil-color` = factor(`veil-color`, 
                          levels = c("n","o","w","y"), 
                          labels = c("brown","orange","white","yellow")),
    `ring-number` = factor(`ring-number`, 
                           levels = c("n","o","t"), 
                           labels = c("none","one","two")),
    `ring-type` = factor(`ring-type`, 
                         levels = c("e","f","l","n","p"), 
                         labels = c("evanescent","flaring","large",
                                    "none","pendant")),
    `spore-print-color` = factor(`spore-print-color`, 
                                 levels = c("k","n","b","h","r",
                                            "o","u","w","y"), 
                                 labels = c("black","brown","buff","chocolate","green",
                                            "orange","purple","white","yellow")),
    population = factor(population, 
                        levels = c("a","c","n",
                                   "s","v","y"), 
                        labels = c("abundant","clustered","numerous",
                                   "scattered","several","solitary")),
    habitat = factor(habitat, 
                     levels = c("g","l","m","p",
                                "u","w","d"), 
                     labels = c("grasses","leaves","meadows","paths",
                                "urban","waste","woods"))
  )



# pre processamento ----
# near zero-var
nearZeroVar(base, names = T)
prop.table(table(base$`gill-attachment`))*100
prop.table(table(base$`veil-type`))*100
prop.table(table(base$`veil-color`))*100

# NAs
vis_miss(base)
vis_miss(select(base, `stalk-root`))

# removendo:
## stalk-root que possui 30,5% de dados faltantes 
## `veil-color` e `gill-attachment` que possuem variancia quase zero
## veil-type que possui variancia zero
##### 8124  19
base = base |> 
  select(-c(`stalk-root`, `veil-type`, 
            `gill-attachment`,`veil-color`))

# separando treino do teste
set.seed(92021)
noTreino = caret::createDataPartition(y = base$classes, p = 0.75, 
                                      list = F)
treino = base[noTreino,] # 6093    19
teste = base[-noTreino,] # 2031    19

# transformando dummies ----
### treino: 6093    88
### teste:  2031    88
treino = dummy_cols(treino, 
                  remove_first_dummy = TRUE,
                  remove_selected_columns = TRUE)
teste = dummy_cols(teste, 
                  remove_first_dummy = TRUE,
                  remove_selected_columns = TRUE)

# exportando bases tratadas
readr::write_csv(treino, "mushrooms_treino.csv")
readr::write_csv(teste, "mushrooms_teste.csv")










