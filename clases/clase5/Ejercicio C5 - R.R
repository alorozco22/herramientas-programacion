#install.packages("dplyr")
#install.packages("readr")
#install.packages("Hmisc")
#install.packages("tidyr")
#install.packages("summarytools")

library(summarytools)
library(Hmisc)
library(readr)
library(dplyr)
library(tidyr)

setwd("C:/Users/magse/Universidad de los Andes/Alfredo Eleazar Orozco Quesada - Curso Programación para datos EdContinua/Clases/Implementación/Clase 5 - Condicionales y ciclos iterados")

pob2005<-read_csv("pob2005.csv")
describe(pob2005)

tipo_filtro<-"Todos"
descr(pob2005$p2005,stats=c("min","max","sd","mean","n.valid"))
if(tipo_filtro=="Grandes" | tipo_filtro=="Todos"  ) {
  print("Población de municipios grandes")
  descr(pob2005$p2005[which(pob2005$p2005>100000)],stats=c("min","max","sd","mean","n.valid"))
} else if(tipo_filtro=="Pequeños" | tipo_filtro=="Todos" ) {
  print("Población de municipios pequeños")
  descr(pob2005$p2005[which(pob2005$p2005<=100000)],stats=c("min","max","sd","mean","n.valid"))
} else if (tipo_filtro=="Todos") {
  print("Población de todos los municipios")
  #Complete esta línea con un código que permita calcular las estadisticas descriptivas para todos los municipios
} else {
  print("Seleccione tipo de tabla")
}

pob2005$grandes_directo<-pob2005$p2005>100000
pob2005$grandes_funcion<-ifelse(pob2005$p2005>100000,1,0)

pob2005$grandes_directo<-NULL
pob2005$grandes_funcion<-NULL
