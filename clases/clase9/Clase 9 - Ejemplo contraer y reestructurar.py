import pandas as pd
import numpy as np

%cd 'C:\Users\magse\Dropbox\Pruebas'

#Importar base
file = 'asesinatos_lideres.xlsx' # Creo una variable con el nombre del archivo
#pip install xlrd==1.2.0 #la ultima versión de xlrd tiene problemas importando xlsx, hay que intalar esta versión previa.
lideres = pd.read_excel(file, nrows=577, usecols='A:V')  
# Explorar base y mantener variables de interés
lideres.head(10)
lideres.tail(10)
lideres=lideres[['nombre', 'género', 'fecha', 'municipio', 'departamento', 'tipodelíder']]

# Crear variables de mes, año y mesaño.
lideres['mesaño']=lideres['fecha'].dt.to_period('M')
lideres["año"]=lideres['fecha'].dt.year
lideres["mes"]=lideres['fecha'].dt.month

#Tabla de frecuencias - las organiza de mayor a menor frecuencia
pd.value_counts(lideres.mesaño).to_frame().reset_index()
pd.value_counts(lideres.año).to_frame().reset_index() 

# tablas de frecuencias
pd.value_counts(lideres.departamento).to_frame().reset_index()
lid_depto=pd.value_counts(lideres.departamento).to_frame().reset_index() #¿Que tipo de objeto creó? ¿Diferencias con R?
lid_depto.columns # ¿El uso de las tablas de frecuencia es mas versatil que en Stata o R?

lid_depto_tabla_totvar=lideres.groupby('departamento').count()
lideres['frecuencia']=np.where(lideres['nombre'].isna()=='FALSE', 0, 1) ##creo una variable para contar
lid_depto_tabla=lideres.groupby('departamento')[['frecuencia']].count() # ¿Cuál es la gran diferencia con Stata? ¿y con R?

    ## Crear tablas que cuenten los líderes por municipio, por mesaño, por año, por departamento y año
    lid_mun_tabla=lideres.groupby('municipio')[['frecuencia']].count() 
    lid_mesaño_tabla=lideres.groupby('mesaño')[['frecuencia']].count()
    lid_año_tabla=lideres.groupby('año')[['frecuencia']].count() 
    lid_depto_año_tabla=lideres.groupby(['departamento','año'])[['frecuencia']].count() 

## Reestructurar tablas usando pivot y melt (parecido a R)  ## otras funciones son unstack y stack 
# modificar tabla para exportar (que se pueda leer fácilmente)
lid_depto_año_tabla=lid_depto_año_tabla.reset_index() ## para cambiar la forma las variables involucradas no deben estar indexadas
lid_depto_año_tabla_ancha=lid_depto_año_tabla.pivot(index='departamento', columns='año', values='frecuencia')

# modificar tabla para analizar (Separación de variables de identificación y  medición)  - con funciones de libreria tidyr
lid_depto_año_tabla_ancha=lid_depto_año_tabla_ancha.reset_index() ## para cambiar la forma las variables involucradas no deben estar indexadas
lid_depto_año_tabla_larga=lid_depto_año_tabla_ancha.melt(id_vars='departamento', var_name='año', value_name='frecuencia')

# más estadísticas descriptivas en una tabla agregada
descriptivas_depto=lid_depto_año_tabla_larga.groupby('departamento')[['frecuencia']].agg(['mean', 'max', 'min']) 


