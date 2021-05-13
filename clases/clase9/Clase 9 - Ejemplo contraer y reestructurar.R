#install.packages("readxl")
#install.packages("dplyr")
#install.packages("lubridate")
#install.packages("zoo")
#install.packages("tidyr")

library(readxl)
library(lubridate)
library(dplyr)
library(zoo)
library(tidyr)

setwd("C:\\Users\\magse\\Dropbox\\Pruebas")
getwd()
#
lideres <- read_excel("asesinatos_lideres.xlsx")
lideres<-as_tibble(lideres)
head(lideres, n=10) ## muestra las 10 primeras líneas, por defecto muestra 6
tail(lideres, n=10) ## muestra las 10 primeras líneas, por defecto muestra 6

lideres<-distinct(lideres) ## 579 obs - eliminar filas duplicadas (vacias) usando una función de dplyr - queda una sola fila vacia
lideres<-lideres[!is.na(lideres$nombre), ] ## 578 obs - sintaxis como si fuera una matriz, sintaxis base de R, más directo para este caso
lideres<-select(lideres, nombre, género, fecha, municipio, departamento, tipodelíder)

# crear variables por mes-año y por año
lideres$mesaño<-as.yearmon(lideres$fecha) ## de la libreria zoo
lideres$año<-year(lideres$fecha) ## de la libreria lubridate
table(lideres$mesaño)
table(lideres$año)

# tablas de frecuencias
table(lideres$departamento)
lid_depto<-table(lideres$departamento) ## no es un data_frame

lid_depto_tabla<- summarise(group_by(lideres, departamento), frecuencia=n())

    ## Crear tablas que cuenten los líderes por municipio, por mesaño, por año, por departamento y año
lid_mun_tabla<- summarise(group_by(lideres, municipio), frecuencia=n())
lid_mesaño_tabla<- summarise(group_by(lideres, mesaño), frecuencia=n())
lid_año_tabla<- summarise(group_by(lideres, año), frecuencia=n())
lid_depto_año_tabla<- summarise(group_by(lideres, departamento, año), frecuencia=n())

# modificar tabla para exportar (que se pueda leer fácilmente en papel) - con funciones de libreria tidyr
lid_depto_año_tabla_ancha<-pivot_wider(lid_depto_año_tabla, names_from=año,values_from=frecuencia) 

# modificar tabla para analizar (Separación de variables de identificación y  medición)  - con funciones de libreria tidyr
lid_depto_año_tabla_larga<-pivot_longer(lid_depto_año_tabla_ancha, cols=2:5, names_to="año",values_to="frecuencia")

  #sintaxis pipe
  lid_depto_año_tabla_larga<- lid_depto_año_tabla_ancha %>%
    pivot_longer( cols=2:5, names_to="año",values_to="frecuencia")

# más estadísticas descriptivas en una tabla agregada
descriptivas_depto<- lid_depto_año_tabla_larga%>%
  group_by(departamento) %>%
  summarise(promedio=mean(frecuencia), maximo=max(frecuencia), minimo=min(frecuencia))
# Escriba lo anterior con la sintaxis estandar
