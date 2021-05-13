import os # Miscellaneous operating system interfaces
import pandas as pd
import numpy as np

%cd "C:\Users\magse\Dropbox\Pruebas"
cwd = os.getcwd()  # guardar el directorio en una variable . Tambien puede cambiar el directorio así: os.chdir("/path/to/your/folder")
cwd
os.listdir('.') #Lista los archivos que contiene el directorio

file = "1.1.1.TCM_Serie histórica IQY.xlsx" # Creo una variable con el nombre del archivo
#pip install xlrd==1.2.0 #la ultima versión de xlrd tiene problemas importando xlsx, hay que intalar esta versión previa.
serie = pd.read_excel(file, header=7, nrows=10514, usecols="A,B")  
serie
serie.head(10)
serie.tail(10)
serie=serie.rename(columns={"Fecha (dd/mm/aaaa)": "Fecha", "Tasa de cambio representativa del mercado (TRM)": "Tasa"})
serie.columns
serie["mesaño"]=serie["Fecha"].dt.to_period("M")

serie
pd.value_counts(serie.mesaño)   #Tabla de frecuencias - las organiza de mayor a menor frecuencia
pd.value_counts(serie.mesaño).to_frame().reset_index()   # ¿Qué información adicional hay aquí? ¿Se puede usar la tabla como un objeto de python?
# contraer bases de datos con groupby
serie_mesaño_unavar=serie.groupby('mesaño')[['Tasa']].mean() # usar todos los paréntesis para que se cree como un dataframe
serie_mesaño_unavar.columns ## la columna de indexación es mesaño. 
serie["año"]=serie['Fecha'].dt.year
serie["mes"]=serie['Fecha'].dt.month

serie_mesaño_dosvar=serie.groupby(['año','mes'])[['Tasa']].mean() # los paréntesis cuadrado agrupan variables en el by
serie_mesaño_dosvar #Las variables en by son de indexación
serie_mesaño_dosvar.columns








