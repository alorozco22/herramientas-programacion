#pip install pandas
#pip install numpy

import pandas as pd
import numpy as np

%cd "C:\Users\magse\Universidad de los Andes\Alfredo Eleazar Orozco Quesada - Curso Programación para datos EdContinua\Clases\Implementación\Clase 5 - Condicionales y ciclos iterados"

pob2005=pd.read_csv("pob2005.csv", dtype={'DP': str, 'DPMP': str,'p2005': int})
pob2005.describe()
pob2005.head()
pob2005.mean()

tipo_filtro="Todos"

if tipo_filtro=="Grandes":
    print("Población de municipios grandes:")
    print(pob2005[pob2005.p2005>100000].agg({"p2005": ["count", "mean", "std", "min", "max",]}))
elif tipo_filtro=="Pequeños":
    print("Población de municipios pequeños:")
    print(pob2005[pob2005.p2005<=100000].agg({"p2005": ["count", "mean", "std", "min", "max",]}))
elif tipo_filtro=="Todos":
    print("Población de municipios pequeños:")
    #Complete esta línea con un código que permita calcular las estadísticas descriptivas para todos los municipios
else:
    print("Seleccione tipo de tabla")
    
pob2005['grandes'] = np.where(pob2005['p2005']>100000, 1, 0)
# Busque otro método para crear esta misma variable

