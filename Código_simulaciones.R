#Entidad Estudiante:
año_cursado_universidad <- read.csv2("year_universidad.csv")
año_cursado_universidad_mat <- año_cursado_universidad[año_cursado_universidad$Matriculados_en_el_año >0,]
set.seed(2022)
DNI_Estudiante<-sample(70000000:79999999,1375101,replace=F)
Edad <- sample(c(16:30), 1375101, replace = T)
Sexo_Estudiante <- sample(c("Masculino", "Femenino"), 1375101, replace = T)
Clase_Económica <- sample(LETTERS[1:5], 1375101, replace = T)
Situación_Laboral <- sample(c("Sólo estudia","Estudia y trabaja"), 1375101, replace = T)
Nombre_Universidad <- sample(año_cursado_universidad_mat$Nombre_Universidad, 1375101, replace = T)

estudiantes <- data.frame(DNI_Estudiante, Nombre_Universidad, Edad, Sexo_Estudiante, Clase_Económica, Situación_Laboral)

#Write en csv para leerlo en nuestro mysql

write.csv2(estudiantes, "estudiantes.csv", fileEncoding = "UTF-8", quote = F, row.names = F)

##Año_Estudiante

#Para el año_estudiante 2020

estudiante <- read.csv2("estudiantes.csv")
Año <- rep(2020,1234549)
DNI_Estudiante <- sample(estudiante$DNI_Estudiante,1234549,replace=F)
Promedio_Estudiante <- round(runif(1234549,min=8,max=20),1)
cantidad_r<- c(-Inf,10,12,Inf)
valores <- c('Suspendido','Observado','Normal')
Situación_Académica <- cut(Promedio_Estudiante,breaks = cantidad_r,labels = valores)
dataframe1 <- data.frame(Año,DNI_Estudiante,Promedio_Estudiante,Situación_Académica)


#Para el año_estudiante 2021
Año <- rep(2021,1375101)
DNI_Estudiante <- sample(estudiante$DNI_Estudiante,1375101,replace=F)
Promedio_Estudiante <- round(runif(1375101,min=8,max=20),1)
Situación_Académica <- cut(Promedio_Estudiante,breaks = cantidad_r,labels = valores)
dataframe2 <- data.frame(Año,DNI_Estudiante,Promedio_Estudiante,Situación_Académica)
year_estudiantes<-rbind(dataframe1,dataframe2)

#Write en csv para leerlo en nuestro mysql

write.csv2(year_estudiantes, "year_estudiantes.csv", fileEncoding = "UTF-8", quote = F, row.names = F)


#Tabla de hechos: (DNI_Estudiante, Año, Nombre_Universidad, Matriculados_en_el_año, Promedio_Estudiante, Clase_Económica, Tipo_Modalidad, Gestión, Situación_Académica y Departamento)

#Usaremos de base a year_estudiantes
tabla_hechos <- year_estudiantes

#Para obtener: Nombre_Universidad y Clase_Económica

tabla_hechos <- merge(tabla_hechos, dplyr::select(estudiantes, DNI_Estudiante, Nombre_Universidad, Clase_Económica), by = "DNI_Estudiante")

#Para obtener: Matriculados_en_el_año y Tipo_Modalidad
tabla_hechos <- merge(tabla_hechos, dplyr::select(año_cursado_universidad[año_cursado_universidad$Matriculados_en_el_año >0,], Año, Nombre_Universidad, Matriculados_en_el_año, Tipo_Modalidad), by = c("Año", "Nombre_Universidad"))

#Para obtener: Gestión y Departamento
universidades <- read.csv2("universidades.csv")
tabla_hechos <- merge(tabla_hechos, dplyr::select(universidades, Nombre_Universidad, Gestión, Departamento), by = "Nombre_Universidad")

write.csv2(tabla_hechos, "tabla_hechos.csv", fileEncoding = "UTF-8", quote = F, row.names = F)
