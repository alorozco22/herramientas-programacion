# Directorio de trabajo
setwd("/Users/alorozco22/OneDrive - Universidad de los Andes/Documentos 2020-20/Curso Programación para datos EdContinua/Clases/Implementación/clase6/clase7/Enero.csv")

# Importar cabecera - características personas
datosPersonas <- read.csv("Cabecera - Caracter°sticas generales (Personas).csv", sep = ';')
# Importar cabecera - hogares y viviendas
datosHogares <- read.csv("Cabecera - Vivienda y Hogares.csv", sep = ';')

# Para visualizar
View(datosPersonas)
View(datosHogares)