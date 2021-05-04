clear all
cd "Coloque aquí la dirección de la carpeta donde están los datos"

import delimited pob2005.csv, stringcols(1 3 ) encoding("utf-8")  clear 
describe 
codebook p2005
sum p2005
sum p2005, detaile

local tipo_filtro "otro"  

if "`tipo_filtro'"=="Grandes" | "`tipo_filtro'"=="Todos"   { 
  display "Población de municipios grandes"
  summarize p2005 if p2005>100000 & !missing(p2005) 
} 
else if "`tipo_filtro'"=="Pequeños" | "`tipo_filtro'"=="Todos" { 
  display "Población de municipios pequeños"
  sum p2005 if p2005<=100000 
} 
else if "`tipo_filtro'"=="Todos" { 
  display "Población de todos los municipios"
  sum p2005
} 
else { 
  display "Seleccione un tipo de tabla válido"
}

gen grandes_directo=p2005>100000 
replace grandes_directo=. if missing(p2005)  

gen grandes_if=1 if p2005>100000
replace grandes_if=0 if p2005<=100000

gen grandes_funcion=cond(p2005>100000,1,0)

