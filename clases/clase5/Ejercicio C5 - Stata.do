** Miguel Andrés Garzón Ramírez
** Universidad de los Andes - Facultad de Economía
** 3 de mayo de 2021
* Estadísticas descriptivas por grupos de municipios
cd "C:\Users\magse\Universidad de los Andes\Alfredo Eleazar Orozco Quesada - Curso Programación para datos EdContinua\Clases\Implementación\Clase 5 - Condicionales y ciclos iterados" // Esta es la dirección de la carpeta donde están los datos"

import delimited pob2005.csv, stringcols(1 3 ) encoding("utf-8")  clear // Stata importa como variable numérica columnas que contienen solo caracteres numéricos. Como las variables 1 y 3 (dp y dpmp) son códigos DIVIPOLA del DANE pueden iniciar con cero, se debe especificar que estas variables sean importadas como caradenas de caracteres con la opción stringcols(). Al importar los datos los nombres de los municipios tuvieron problemas con las palabras con tíldes. Para solucionarlo se especificó que los datos tienen condificación UTF-8, que se usaba en la decada de los 2000
* La unidad de observación de esta base de datos es el municipio. Solo hay información para el año 2005.
describe // describe todas las variables de la base de datos
codebook p2005 // Estadísticas descriptivas amplias de la variable población. Si no especifica el nombre de una o mas variables lo hace para todas las variables de la base de datos 
* La variable p2005 no tiene valores faltantes, todos los municipios tienen dato de población. Esto facilita los cálculos.
sum p2005 // Estadísticas descriptivas básicas de la variable población. Si no especifica el nombre de una o mas variables lo hace para todas las variables de la base de datos 
sum p2005, detail // Estadísticas descriptivas detalladas de la variable población. Si no especifica el nombre de una o mas variables lo hace para todas las variables de la base de datos. Ver cocumentación del comando summarize

*** Inicio del programa para seleccionar el grupo para el cuál se calcularán estadísticas descriptivas
*El criterio para definir los grupos es que un municipio es grande si tiene mas de 100000 habitantes, es pequeño si tiene 100000 habitantes o menos.

local tipo_filtro "Grandes"  // Elemento (macro) que permite reemplazar más adelante el grupo de municipios para el cual se quiere hacer las estadísticas descriptivas

if "`tipo_filtro'"=="Grandes" | "`tipo_filtro'"=="Todos"   { // Paso 1, verificar si se quiere hacer estadísticas descriptivas solo para municipios grandes
  display "Población de municipios grandes"
  summarize p2005 if p2005>100000 & !missing(p2005) // Es necesario especificar que no tome los valores faltantes en el filtro porque estos se consideran números muy grandes en una operación de comparación. La idea es que si se crea una variable con base en los valores de otra, los valores faltantes de la variable inicial se conserven en la nueva variable. Si se incluye o no este filtro adicional <!missing(p2005)> no cambia el resultado, pero es la forma más precisa de escribirlo. Si se utiliza este código para otras variables que sí tengan valores faltantes puede ser útil. Siempre se deben tener en cuenta.
} 
else if "`tipo_filtro'"=="Pequeños" | "`tipo_filtro'"=="Todos" { // Paso 2, si no se quería hacer las estadisticas de los municipios grandes, ahora se verifica si se quiere hacer estadísticas descriptivas solo para municipios pequeños
  display "Población de municipios pequeños"
  sum p2005 if p2005<=100000 
} 
else if "`tipo_filtro'"=="Todos" { // Paso 3, si no se quería hacer las estadisticas de los municipios pequeño, ahora se verifica si se quiere hacer estadísticas descriptivas para todos los municipios
  display "Población de todos los municipios"
  sum p2005
} 
else { // Paso 4, si nada de lo anterior fue verdadero entonces se ingresó un valor no válido para este programa y esta es la verificación de salida. 
  display "Seleccione un tipo de tabla válido"
}

*** Creación de una variable de identifique a los municipios grandes.
*En la variable habrán dos posibles valores, 0 o 1. 1 es un municipio grande según el criterio definido previamente.

* Método 1 - Método directo
gen grandes_directo=p2005>100000 // Aquí se aprovecha el resultado de una operación lógica, ya que Stata toma la respuesta "Verdadero" como el número 1 y la respuesta "Falso" como el número 0. Si la variable tuviera valores faltantes la nueva variable no los tendría, ya que se camuflarían en la respuesta "Falso", por esto es necesaria la siguiente línea de código
replace grandes_directo=. if missing(p2005)  // "." es la notación en Stata para un valor faltante en una variable númerica. Para una variable de caracter es "" (vacio entre comillas)

* Método 2 - Método por casos - La más común entre los usuarios de Stata
gen grandes_if=1 if p2005>100000  // Los municipios grandes
replace grandes_if=0 if p2005<=100000 & missing(p2005) // Los municipios pequeños conservando los valores faltantes

* Método 3 - Método con la función "cond" - Esta es la forma más parecida a como se hace en otros lenguajes, pero es la menos común entre los usuarios de Stata
gen grandes_funcion=cond(p2005>100000,1,0) // La gran ventaja es que conserva los valores faltantes de la variable base




