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
head(lideres, n=10) ## muestra las 10 primeras l�neas, por defecto muestra 6
tail(lideres, n=10) ## muestra las 10 primeras l�neas, por defecto muestra 6

lideres<-distinct(lideres) ## 579 obs - eliminar filas duplicadas (vacias) usando una funci�n de dplyr - queda una sola fila vacia
lideres<-lideres[!is.na(lideres$nombre), ] ## 578 obs - sintaxis como si fuera una matriz, sintaxis base de R, m�s directo para este caso
lideres<-select(lideres, nombre, g�nero, fecha, municipio, departamento, tipodel�der)

# crear variables por mes-a�o y por a�o
lideres$mesa�o<-as.yearmon(lideres$fecha) ## de la libreria zoo
lideres$a�o<-year(lideres$fecha) ## de la libreria lubridate
table(lideres$mesa�o)
table(lideres$a�o)

# tablas de frecuencias
table(lideres$departamento)
lid_depto<-table(lideres$departamento) ## no es un data_frame

lid_depto_tabla<- summarise(group_by(lideres, departamento), frecuencia=n())

    ## Crear tablas que cuenten los l�deres por municipio, por mesa�o, por a�o, por departamento y a�o
lid_mun_tabla<- summarise(group_by(lideres, municipio), frecuencia=n())
lid_mesa�o_tabla<- summarise(group_by(lideres, mesa�o), frecuencia=n())
lid_a�o_tabla<- summarise(group_by(lideres, a�o), frecuencia=n())
lid_depto_a�o_tabla<- summarise(group_by(lideres, departamento, a�o), frecuencia=n())

# modificar tabla para exportar (que se pueda leer f�cilmente en papel) - con funciones de libreria tidyr
lid_depto_a�o_tabla_ancha<-pivot_wider(lid_depto_a�o_tabla, names_from=a�o,values_from=frecuencia) 

# modificar tabla para analizar (Separaci�n de variables de identificaci�n y  medici�n)  - con funciones de libreria tidyr
lid_depto_a�o_tabla_larga<-pivot_longer(lid_depto_a�o_tabla_ancha, cols=2:5, names_to="a�o",values_to="frecuencia")

  #sintaxis pipe
  lid_depto_a�o_tabla_larga<- lid_depto_a�o_tabla_ancha %>%
    pivot_longer( cols=2:5, names_to="a�o",values_to="frecuencia")

# m�s estad�sticas descriptivas en una tabla agregada
descriptivas_depto<- lid_depto_a�o_tabla_larga%>%
  group_by(departamento) %>%
  summarise(promedio=mean(frecuencia), maximo=max(frecuencia), minimo=min(frecuencia))
# Escriba lo anterior con la sintaxis estandar
