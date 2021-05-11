////////////////////////////////////////////
// CLASE 8 - Herramientas de programación //
////////////////////////////////////////////

// Objetivo:
// Vamos a rebanar la base de datos y haremos algunas series de tiempo
// diferentes sobre muertes de periodistas
clear all
//////////////// CARGANDO LOS DATOS ////////////////

// Estableciendo directorio de trabajo
cd "/Users/alorozco22/OneDrive - Universidad de los Andes/Documentos 2020-20/Curso Programación para datos EdContinua/Clases/Implementación/clase8/"

// Importar muertes de periodistas, la opción varn(1) es abreviación de varname(1): indica la fila con el nombre de las variables
import delimited using "cpj-database.csv", varn(1)

// Visualizamos con browse
br

// Eliminamos variables vacías
drop v*

//////////////// LIMPIANDO LA FECHA ////////////////

// Note que cada dos filas hay una fila con valor de date (fecha) ",,,,,,,,," vamos a eliminarlas

drop if date == ",,,,,,,,," // ponerlos a completar esta línea

// Separamos componentes de la fecha en date1, date2 y date3
split date, p("/")

// les ponemos el nombre
rename date1 mes
rename date2 dia
rename date3 anio

// Indicamos a Stata que las columnas de fecha son numéricas
destring mes dia, replace

// mes y día tienen caracteres no numéricos, revisamos
tab dia

// Día es fácil, eliminamos la observación 12-11
drop if dia == "12-11"
destring dia, replace // éxito

// Revisamos qué caracteres tiene mes
tab mes // tiene fechas en diferentes formatos

// para efectos de esta clase, eliminamos todas las fechas
// normalmente iríamos observación por observación y la recuperaríamos
do "./eliminar-datos.do"

tab mes // chulo
dis "conservamos en porcentaje el "
dis 1793/1879*100

destring mes, replace


// antes de volver a año numerica, observamos
tab anio // hay valores menores o iguales a 18 y luego superiores a 91, así que discriminamos
destring anio, replace // la volvemos numérica
gen anioCompleto = anio+2000 if anio < 19 // ponerlos a completar esta línea
replace anioCompleto = anio+1900 if anio > 91 // ponerlos a completar esta línea

// Verificamos
br anio anioCompleto


// creamos una columna con la fecha en formato correcto
gen fecha = mdy(mes, dia, anioCompleto)
br mes dia anioCompleto fecha

// El formato está en segundos desde 1 de enero de 1960, así que asignamos formato

format fecha %d

// revisamos la base 
br

// Borramos las variables que sobran: date4 date anio
drop date4 date anio // ponerlos a completar esta línea


//////////////// CODIFICAMOS NACIONALIDAD COMO CATEGORÍA ////////////////
encode countrykilled, gen(paisDeMuerte)

//////////////// EXPLORACIÓN DE DATOS ////////////////

// veamos la distribución de muertes por país
tab paisDeMuerte, m
br paisDeMuerte

tab paisDeMuerte, m

// preserve restore: vamos a recortar la base para contar observaciones por año
preserve
// nos quedamos con las observaciones para colombia
keep if paisDeMuerte == 21 // Colombia
keep paisDeMuerte anioCompleto
br

collapse (count) paisDeMuerte, by(anioCompleto) // Completar el by

// Una operación compleja para hacer gráficas, no le pongan atención
tsset anioCompleto
tsline paisDeMuerte, title("Serie de tiempo muertes de periodistas en Colombia") xtitle("Año") ytitle("Número de muertes")

restore
br


// Repetir el preserve restore para otro país interesante
