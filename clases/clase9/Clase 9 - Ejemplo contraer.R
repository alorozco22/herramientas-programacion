#install.packages("readxl")
#install.packages("dplyr")
#install.packages("lubridate")
#install.packages("zoo")

library(readxl)
library(lubridate)
library(dplyr)
library(zoo)


#
# file.choose()
setwd("C:\\Users\\magse\\Dropbox\\Pruebas")
getwd()
#
serie <- read_excel("1.1.1.TCM_Serie histórica IQY.xlsx", range = "A8:B10522")

head(serie, n=10) ## muestra las 10 primeras líneas, por defecto muestra 6
serie<-as_tibble(serie)
serie<-rename(serie, fecha=`Fecha (dd/mm/aaaa)`)
serie<-rename(serie, tasa=`Tasa de cambio representativa del mercado (TRM)`)

##usado funciones de la libreria zoo para manejo de fechas
  serie$mesaño<-as.yearmon(serie$fecha)
  table(serie$mesaño)
  
  ## con sintaxis de corrido (anidada)
  serie_mesaño_zoo<- summarise(group_by(serie, mesaño),tasa_mes=mean(tasa))
  
  ## con sintaxis de tuberia (pipe syntax)
  serie_mesaño_zoo<-serie%>%
    group_by(mesaño) %>% 
    summarise(tasa_mes=mean(tasa))


##usado funciones de la libreria lubridate para manejo de fechas
  serie$año<-year(serie$fecha) 
  serie$mes<-month(serie$fecha)
  table(serie$fecha)
  
  ## con sintaxis de corrido (anidada)
  serie_mesaño_lubri<- summarise(group_by(serie, año, mes),tasa_mes=mean(tasa))

  ## con sintaxis de tuberia (pipe syntax)
  serie_mesaño_lubri<- serie%>%
    group_by(año, mes) %>% 
    summarise(tasa_mes=mean(tasa))
  


