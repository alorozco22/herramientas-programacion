

display "Vamos a eliminar todas las observaciones con caracteres no numéricos en mes"
display "Pero normalmente iríamos una por una recuperando lo que se pueda"



drop if regexm(mes, "Before") == 1
drop if regexm(mes, "Apr") == 1
drop if regexm(mes, "Sep") == 1
drop if regexm(mes, "Nov") == 1
drop if regexm(mes, "May") == 1

drop if regexm(mes, "Jun") == 1
drop if regexm(mes, "Mar") == 1
drop if regexm(mes, "mid") == 1
drop if regexm(mes, "Jul") == 1
drop if regexm(mes, "Unk") == 1

drop if regexm(mes, "summer") == 1
drop if regexm(mes, "Jan") == 1
drop if regexm(mes, "Feb") == 1
drop if regexm(mes, "Dec") == 1
drop if regexm(mes, "Aug") == 1

drop if regexm(mes, "Date") == 1
drop if regexm(mes, "Oct") == 1
drop if regexm(mes, "Suspected") == 1

// algunas observaciones estaban en el formato de fecha incorrecto
drop if regexm(mes, "15") == 1
drop if regexm(mes, "16") == 1

drop if regexm(mes, "21") == 1
drop if regexm(mes, "23") == 1
drop if regexm(mes, "24") == 1
drop if regexm(mes, "25") == 1
drop if regexm(mes, "26") == 1
drop if regexm(mes, "30") == 1
