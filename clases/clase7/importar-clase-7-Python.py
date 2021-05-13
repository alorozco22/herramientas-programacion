# Importamos la librería Pandas 
import pandas as pd

# Importar cabecera - características personas
datosPersonas = pd.read_csv('Cabecera - Caracter°sticas generales (Personas).csv', delimiter=";")
# Importar cabecera - hogares y viviendas
datosHogares = pd.read_csv('Cabecera - Vivienda y Hogares.csv', delimiter=";")

# Para visualizar
datosPersonas.head()
datosHogares.head()
