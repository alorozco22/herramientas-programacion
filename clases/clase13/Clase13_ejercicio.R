# Herramientas de programaci�n para el an�lisis de datos
# Universidad de los Andes
# 21 de mayo de 2021

# Instalaci�n de librerias (Colocar en comentarios una vez instaladas)
#install.packages("haven")
#install.packages("dplyr")
#install.packages("labelled")
#install.packages("summarytools")
#install.packages("ggplot2")


# Activar librer�as
library(haven)        #Import and Export 'SPSS', 'Stata' and 'SAS' Files
library(dplyr)        #A Grammar of Data Manipulation
library(labelled)     #Labelled data
library(summarytools) #Tools to Quickly Summarize Data
library(ggplot2)      #Data Visualisations

# Despejar la memoria
rm(list = ls())  

# Establecer directorio de trabajo
setwd("C:\\Users\\magse\\Universidad de los Andes\\Alfredo Eleazar Orozco Quesada - Curso Programaci�n para datos EdContinua\\Clases\\Implementaci�n\\Clase 13 - Taller")
getwd()

# 1: Consolidar datos
  #1.1: Cargar los datos
  #Upersonas<-read_dta("Upersonas.dta")
  #Uhogar<-read_dta("Uhogar.dta")
  #Rpersonas<-read_dta("Rpersonas.dta")
  #Rhogar<-read_dta("Rhogar.dta")
  #Las anteriores 4 l�neas se simplifican con la siguiente sintaxis m�s general:
  bases <- list.files(pattern = "\\.dta") #Listar las bases .dta en la carpeta
  list2env(lapply(setNames(bases, make.names(gsub("*.dta$", "", bases))), read_dta), envir = .GlobalEnv) # comparar con myfiles = lapply(bases, read_dta)  ## Crea una lista de 4 elementos  con las bases de datos 

  #1.2: Unir datos de personas y hogares de zonas urbanas y rurales
  #Analice la unidad de observaci�n de cada base de datos
  U<-inner_join(Upersonas, Uhogar, by = "llave_n16") # Uni�n horizontal muchos a 1  - La variable llave se llama igual en ambas bases de datos
  # ���??? Cree la base R, con datos de personas de la zona rural - La variable llave se llama igual en ambas bases de datos
  # ���??? Uni�n vertical de las bases U y R con la funci�n bind_row
  rm(list = c(gsub("*.dta$", "", bases), "U","R")) ## En memoria solo queda la base unida
  
  #1.3: Dejar las variables importantes
  RU<-RU%>%rename(mujer='sexo') #renombrar una variable con una funci�n de dplyr
  variables <-c("hoy_fuma", "come_paquete", "come_fritos", "hospital_veces", "ehace_deporte", 
                "zona", "edad", "mujer", "hijos_vivos", "sp_estrato", "t_personas", "tercil2016", 
                "ha_fumado", "hijos_vivos", "dias_noasistio", "afiliacion")
  RU<-RU%>%select(variables) # Seleccionar las variables con la sintaxis pipe y una funci�n de dplyr
  
#2: Editar variables
  #2.1: Reemplazar valores faltantes y asignar etiquetas de valor
  RU$zona[is.na(RU$zona)==TRUE]=0 #  En lenguaje base de R, reemplazar valores faltantes por ceros. Con dplyr esta operaci�n es ineficiente y en desuso: RU<-RU%>%mutate_at("zona", ~replace(., is.na(.), 0))
  val_labels(RU$zona) <- c(Rural = 0, Urbano = 1) #asignar etiquetas de valor

  #2.2: Variables de s� y no
  vars<-c("ha_fumado", "come_paquete", "come_fritos", "hijos_vivos")
  RU<-RU%>%mutate_at(vars, ~replace(., .==2, 0))
  val_labels(RU[,vars]) <- c(No = 0, S� = 1) #asignar etiquetas de valor a varias variables, se aprovecha la sintaxis de matriz para los dataframes de Rbase

  #2.3: Variable mujer: Dos cambios de n�mero sucesivos. Hay que dise�ar el cambio valor por valor para evitar perder consistencia de la variable
  RU$mujer[RU$mujer==1]=0   # Lenguaje base de R. De nuevo, esto con dplyr es ineficiente y confuso: RU<-RU%>%mutate_at("mujer", ~replace(., .==1, 0))
  RU$mujer[RU$mujer==2]=1   # Lenguaje base de R. De nuevo, esto con dplyr es ineficiente y confuso: RU<-RU%>%mutate_at("mujer", ~replace(., .==2, 1))
  val_labels(RU$mujer) <- c(No = 0, S� = 1) #asignar etiquetas de valor a varias variables, se aprovecha la sintaxis de matriz para los dataframes de Rbase

#3: Estad�sticas descriptivas 
  #3.1: Tablas
  dfSummary(RU)  ## De toda la base de datos, paquete summarytools
  dfSummary(RU[vars])  ## Selecci�n de variables
  
  # ���??? Tabla de frecuencias con funci�n table
  # ���??? Valores �nicos con funci�n unique
  
  #3.2: Gr�ficos
    #3.2.1 Barras del promedio de edad por condici�n de fumador actual
      #C�lculos para el gr�fico
      edad_fuma<-RU%>%
        group_by(hoy_fuma)%>%
        summarise(promedio_edad=mean(edad))
      #Gr�fico
      ggplot(edad_fuma, aes(hoy_fuma,promedio_edad))+geom_col()+labs(x="",y="Promedio edad") ## con ggplot
      barplot(height=edad_fuma$promedio_edad, names=edad_fuma$hoy_fuma, col="#69b3a2") ## con R base      
    #3.2.2 Barras del promedio de dias de inasistencia por condici�n de fumador actual
       #C�lculos para el gr�fico
       diasno_fuma<-RU%>%
         group_by(hoy_fuma)%>%
         filter(!is.na(dias_noasistio))%>%
         summarise(promedio_dias=mean(dias_noasistio)) # summarise no opera cuando la variable sobre la que se hace el c�lculo contiene valores faltantes, hay que eliminarlos con filter
       #Gr�fico
       ggplot(diasno_fuma, aes(hoy_fuma,promedio_dias))+geom_col()+labs(x="",y="Promedio d�as")    
    #3.2.3 Distribuci�n de la variable tama�o del hogar
       ggplot(RU, aes(y=t_personas))+geom_boxplot()+labs(y="6. N�mero de personas en el hogar")  

#4: Regresi�n
    #4.1: Correlaci�n
       var_cor<-c("dias_noasistio", "ha_fumado", "tercil2016", "edad", "mujer", "t_personas")
       cor(RU[var_cor], use="pairwise.complete.obs") 
       
    #4.2: regresi�n
       RU$tercil2016.f <- factor(RU$tercil2016)
       reg1 = lm(dias_noasistio ~ ha_fumado + edad + mujer + t_personas + tercil2016.f, data = RU)
       reg1
       
       
       