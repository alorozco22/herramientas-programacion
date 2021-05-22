/*====================================================================
			Herramientas para el análisis de datos
					Visualización de datos
====================================================================*/

/*==================================================
              0: Program set up
==================================================*/
	
	version 16
	drop _all
	clear all
	macro drop _all
	
	cd "/Users/alorozco22/OneDrive - Universidad de los Andes/Documentos 2020-20/Curso Programación para datos EdContinua/pagina-curso-herramientas-programacion/clases/clase12"

/*==================================================
				1: Cargar base
==================================================*/
	use PANEL_CONFLICTO_Y_VIOLENCIA, clear

	label define coca 0 "Sin coca" 1 "Con coca", modify
	label values coca coca
	
/*==================================================
				2: Gráficos
==================================================*/	

*----------2.1: Scatter

	*Los condicionales pueden ser agregados sin problema
	scatter homicidios rescatedes~s if rescatedesecuestrados<=15, 				///
		graphregion(colo(white)) xlabel(0(2)12)
	graph export "scatter1.png", replace

	*Twoway: hacer más de un gráfico sobre el mismo entorno
	twoway (scatter homicidios rescatedesecuestrados if rescatedesecuestra<=15) ///
		(lfit homicidios rescatedesecuestrados), graphregion(colo(white)) 		///
	xlabel(0(2)12)
	graph export "scatter2.png", replace
		
*----------2.2: Barras
	graph bar, over(coca) graphregion(colo(white)) ytitle("%")
	graph export "bar1.png", replace

	*Barras horizontales
	graph hbar, over(coca) graphregion(colo(white))
	graph export "bar2.png", replace

	*Barras sobre binaria
	graph bar homicidios, over(coca) graphregion(colo(white)) 					///
		ytitle("Promedio de homicidios")
	graph export "bar3.png", replace

	*Barras apiladas
	graph bar homicidios hurto, over(coca) graphregion(colo(white)) stack 		///
		ytitle("Promedio") legend(order(1 "Homicidios" 2 "Hurtos"))
	graph export "bar4.png", replace

*----------2.3: Líneas
	preserve
		collapse (max) homicidios, by(ano)
		twoway line homicidios ano if ano>2002, graphregion(colo(white))		///
			ytitle("Número máximo de homicidios") xlabel(2003(2)2017)
		graph export "line1.png", replace
	restore

*----------2.4: Boxplot
	graph box homicidios, nooutsides graphregion(colo(white))
	graph export "box1.png", replace
		
	graph box homicidios, over(coca) nooutsides graphregion(colo(white))
	graph export "box2.png", replace
		
*----------2.5: Histogramas
	histogram ano if hurto==0 & ano>2002, graphregion(colo(white)) 				///
		xlabel(2003(2)2017)
	graph export "histogram1.png", replace
	
	kdensity ano if hurto==0  & ano>2002, graphregion(colo(white)) 				///
		xlabel(2003(2)2017)
	graph export "density1.png", replace
	
/*==================================================
				3: Integración
==================================================*/		

clear
import excel "wage2.xls", first



