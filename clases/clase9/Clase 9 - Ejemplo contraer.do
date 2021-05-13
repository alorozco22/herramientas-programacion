* Limpiar la memoria
clear all

* Establecer el directorio de trabajo
cd "C:\Users\magse\Dropbox\Pruebas"

* importar (note el uso de la opción clear, homóloga al comando clear all)
import excel using "1.1.1.TCM_Serie histórica IQY.xlsx", cellrange(A8:B10522) firstrow clear
rename (Fechaddmmaaaa Tasadecambiorepresentativade) (fecha tasa) 

* Variable mesaño
gen mesaño = mofd(fecha) // se crea una variable que cuenta meses desde enero de 1960
format mesaño %tm

* Variables mes y año
gen mes = month(fecha) // se crea una variable que toma el mes calendario de esa fecha
gen año = year(fecha) // se crea una variable que toma el año calendario de esa fecha


* tablas de frecuencia
tab  mesaño, m

* mostrar estadisticos por grupo en ventana de resultados
tabstat tasa, by(mesaño) statistics(mean)

* contaer bases con estadisticos y exportarlas a excel (en stata solo podemos tener una tabla cargada, hay una sintaxis para usar "frames" que es muy poco usada)
preserve
	collapse (mean) tasa, by(mesaño)
	export excel using "tasa_mesaño.xlsx", firstrow(variables) sheet(mesaño1, replace)
restore

preserve
	collapse (mean) tasa, by(mes año)
	export excel using "tasa_mesaño.xlsx", firstrow(variables) sheet(mesaño2, replace)
restore




