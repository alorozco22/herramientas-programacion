# Herramientas de programación para el análisis de datos
# Universidad de los Andes
# 21 de mayo de 2021

# Instalación de librerias (Colocar en comentarios una vez instaladas)
install.packages("haven")
install.packages("dplyr")
install.packages("labelled")
install.packages("summarytools")
install.packages("ggplot2")


# Activar librerías
library(haven)        #Import and Export 'SPSS', 'Stata' and 'SAS' Files
library(dplyr)        #A Grammar of Data Manipulation
library(labelled)     #Labelled data
library(summarytools) #Tools to Quickly Summarize Data
library(ggplot2)      #Data Visualisations

# Despejar la memoria
rm(list = ls())  

# Establecer directorio de trabajo
setwd("C:\\Users\\magse\\Universidad de los Andes\\Alfredo Eleazar Orozco Quesada - Curso Programación para datos EdContinua\\Clases\\Implementación\\Clase 13 - Taller")
getwd()

# 1: Consolidar datos
  #1.1: Cargar los datos
  #Upersonas<-read_dta("Upersonas.dta")
  #Uhogar<-read_dta("Uhogar.dta")
  #Rpersonas<-read_dta("Rpersonas.dta")
  #Rhogar<-read_dta("Rhogar.dta")
  #Las anteriores 4 líneas se simplifican con la siguiente sintaxis más general:
  bases <- list.files(pattern = "\\.dta") #Listar las bases .dta en la carpeta
  list2env(lapply(setNames(bases, make.names(gsub("*.dta$", "", bases))), read_dta), envir = .GlobalEnv) # comparar con myfiles = lapply(bases, read_dta)  ## Crea una lista de 4 elementos  con las bases de datos 

  #1.2: Unir datos de personas y hogares de zonas urbanas y rurales
  #Analice la unidad de observación de cada base de datos
  U<-inner_join(Upersonas, Uhogar, by = "llave_n16") # Unión horizontal muchos a 1  - La variable llave se llama igual en ambas bases de datos
  R<-inner_join(Rpersonas, Rhogar, by = "llave_n16") # La variable llave se llama igual en ambas bases de datos
  RU<-bind_rows(R,U) #Unión vertical
  rm(list = c(gsub("*.dta$", "", bases), "U","R")) ## En memoria solo queda la base unida
  
  #1.3: Dejar las variables importantes
  RU<-RU%>%rename(mujer='sexo') #renombrar una variable con una función de dplyr
  variables <-c("hoy_fuma", "come_paquete", "come_fritos", "hospital_veces", "ehace_deporte", 
                "zona", "edad", "mujer", "hijos_vivos", "sp_estrato", "t_personas", "tercil2016", 
                "ha_fumado", "hijos_vivos", "dias_noasistio", "afiliacion")
  RU<-RU%>%select(variables) # Seleccionar las variables con la sintaxis pipe y una función de dplyr
  
#2: Editar variables
  #2.1: Reemplazar valores faltantes y asignar etiquetas de valor
  RU$zona[is.na(RU$zona)==TRUE]=0 #  En lenguaje base de R, reemplazar valores faltantes por ceros. Con dplyr esta operación es ineficiente y en desuso: RU<-RU%>%mutate_at("zona", ~replace(., is.na(.), 0))
  val_labels(RU$zona) <- c(Rural = 0, Urbano = 1) #asignar etiquetas de valor

  #2.2: Variables de sí y no
  vars<-c("ha_fumado", "come_paquete", "come_fritos", "hijos_vivos")
  RU<-RU%>%mutate_at(vars, ~replace(., .==2, 0))
  val_labels(RU[,vars]) <- c(No = 0, Sí = 1) #asignar etiquetas de valor a varias variables, se aprovecha la sintaxis de matriz para los dataframes de Rbase

  #2.3: Variable mujer: Dos cambios de número sucesivos. Hay que diseñar el cambio valor por valor para evitar perder consistencia de la variable
  RU$mujer[RU$mujer==1]=0   # Lenguaje base de R. De nuevo, esto con dplyr es ineficiente y confuso: RU<-RU%>%mutate_at("mujer", ~replace(., .==1, 0))
  RU$mujer[RU$mujer==2]=1   # Lenguaje base de R. De nuevo, esto con dplyr es ineficiente y confuso: RU<-RU%>%mutate_at("mujer", ~replace(., .==2, 1))
  val_labels(RU$mujer) <- c(No = 0, Sí = 1) #asignar etiquetas de valor a varias variables, se aprovecha la sintaxis de matriz para los dataframes de Rbase

#3: Estadísticas descriptivas 
  #3.1: Tablas
  dfSummary(RU)  ## De toda la base de datos, paquete summarytools
  dfSummary(RU[vars])  ## Selección de variables
  
  table(RU$hoy_fuma) #Tabla de frecuencias
  unique(RU$hoy_fuma)
  
  #3.2: Gráficos
    #3.2.1 Barras del promedio de edad por condición de fumador actual
      #Cálculos para el gráfico
      edad_fuma<-RU%>%
        group_by(hoy_fuma)%>%
        summarise(promedio_edad=mean(edad))
      #Gráfico
      ggplot(edad_fuma, aes(hoy_fuma,promedio_edad))+geom_col()+labs(x="",y="Promedio edad") ## con ggplot
      barplot(height=edad_fuma$promedio_edad, names=edad_fuma$hoy_fuma, col="#69b3a2") ## con R base      
    #3.2.2 Barras del promedio de dias de inasistencia por condición de fumador actual
       #Cálculos para el gráfico
       diasno_fuma<-RU%>%
         group_by(hoy_fuma)%>%
         filter(!is.na(dias_noasistio))%>%
         summarise(promedio_dias=mean(dias_noasistio)) # summarise no opera cuando la variable sobre la que se hace el cálculo contiene valores faltantes, hay que eliminarlos con filter
       #Gráfico
       ggplot(diasno_fuma, aes(hoy_fuma,promedio_dias))+geom_col()+labs(x="",y="Promedio días")    
    #3.2.3 Distribución de la variable tamaño del hogar
       ggplot(RU, aes(y=t_personas))+geom_boxplot()+labs(y="6. Número de personas en el hogar")  

#4: Regresión
    #4.1: Correlación
       var_cor<-c("dias_noasistio", "ha_fumado", "tercil2016", "edad", "mujer", "t_personas")
       cor(RU[var_cor], use="pairwise.complete.obs") 
       
    #4.2: regresión
       RU$tercil2016.f <- factor(RU$tercil2016)
       reg1 = lm(dias_noasistio ~ ha_fumado + edad + mujer + t_personas + tercil2016.f, data = RU)
       reg1
       
       
       