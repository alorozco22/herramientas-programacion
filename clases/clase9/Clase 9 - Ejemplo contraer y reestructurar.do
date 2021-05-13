* Limpiar la memoria
clear all

* Establecer el directorio de trabajo
cd "C:\Users\magse\Dropbox\Pruebas"

* importar (note el uso de la opción clear, homóloga al comando clear all)
import excel using "asesinatos_lideres.xlsx", firstrow clear
duplicates drop
drop if missing(nombre)
keep nombre género fecha municipio departamento tipodelíder

* crear variables por mes-año y por año
gen mesaño = mofd(fecha)
format mes %tm
gen año = year(fecha)
tab1 mesaño año, m

* Crear tablas que cuenten los líderes por departamento municipio, por mesaño, por año, por departamento y año 
tab1 departamento municipio, m
tab1 año mesaño, m
tab2 departamento año, m // se muestra en estructura ancha en la ventana de resultados

* Crear tablas que cuenten los líderes por departamento municipio, por mesaño, por año, por departamento y año - Toca sacarlas a excel

gen contar=1
preserve
	collapse (count) frecuencia=contar, by(departamento)
	export excel using "lideres.xlsx", firstrow(variables) sheet(depto, replace)
restore

preserve
	collapse (count) frecuencia=contar, by(municipio)
	export excel using "lideres.xlsx", firstrow(variables) sheet(mun, replace)
restore

preserve
	collapse (count) frecuencia=contar, by(año)
	export excel using "lideres.xlsx", firstrow(variables) sheet(año, replace)
restore

preserve
	collapse (count) frecuencia=contar, by(mesaño)
	export excel using "lideres.xlsx", firstrow(variables) sheet(mesaño, replace)
restore

preserve
	collapse (count) frecuencia=contar, by(departamento año)
	export excel using "lideres.xlsx", firstrow(variables) sheet(depto_año, replace)
restore

* Tomemos la tabla depto_año exportada a excel y juguemos con su estructura
import excel using "lideres.xlsx", sheet("depto_año") firstrow clear // otra forma era ejecutando la línea 48 de este código sin que esté entre los comandos preserve y restore

reshape wide frecuencia, i(departamento) j(año)

* A partir de la tabla ancha creemos una tabla larga (con estructura limpia)
reshape long frecuencia, i(departamento) j(año)

* Creemos una tabla con mas estadísticas descriptivas
	* mostremosla en la ventana de resultados
	tabstat frecuencia, by(departamento) statistics(mean max min)
	* dejemosla en el espacio de la base de datos
	
	collapse 	(mean) promedio=frecuencia ///
				(max) maximo=frecuencia ///
				(min) minimo= frecuencia, ///
				by(departamento)
	
	*exportemosla a un libro nuevo de excel
	export excel estadisticas.xlsx, firstrow(variables) replace