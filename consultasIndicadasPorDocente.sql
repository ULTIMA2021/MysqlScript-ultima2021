USE ultima;
-- consultas pedidas por docente
-- logs de una persona
SET @CIpersona = 77777777;
SELECT p.ci, p.nombre, p.apellido, L.login, L.logout 
FROM userlogs L, persona p
WHERE p.ci = @CIpersona AND L.ci = @CIpersona;

-- logs de una persona desde alguna fecha hasta ahora 
select * from userlogs;
SET @CIpersona = 77777777;
SET @fecha = "2021-10-25";

SELECT *
FROM userlogs
WHERE  @fecha <= Login
AND ci = @CIpersona;

-- logs de una persona dentro de algun rango  
SET @CIpersona = 77777777;
SET @fecha1 = "2021-10-24";
SET @fecha2 = "2021-10-26";

SELECT *
FROM userlogs
WHERE  @fecha1 <= Login AND @fecha2 >= Login 
AND ci = @CIpersona;


-- check who's online
SELECT p.ci,p.nombre,p.apellido 
FROM persona p 
WHERE enLinea=true;

-- check which students are online
SELECT p.ci,p.nombre,p.apellido 
FROM persona p, alumno a
WHERE enLinea=TRUE AND a.ci=p.ci;

-- check which teachers are online
SELECT p.ci,p.nombre,p.apellido 
FROM persona p, docente d
WHERE enLinea=TRUE AND d.ci=p.ci;


-- trae las consultas donde el contenido de los mensajes o el titulo de la consulta contienen algun string
-- se ordenan por fecha, descending 

set @algunaPalabra="jelly";
select distinct c.* from consultaprivada c 
where (c.idConsultaPrivada,c.docenteCi,c.alumnoCi) 
	in (select idConsultaPrivada,ciDocente,ciAlumno from cp_mensaje where 
		INSTR(contenido COLLATE utf8mb4_general_ci ,@algunaPalabra) > 0) 
OR (c.idConsultaPrivada,c.docenteCi,c.alumnoCi) 
	in (select idConsultaPrivada,docenteCi,alumnoCi from consultaprivada where
		INSTR(titulo COLLATE utf8mb4_general_ci ,@algunaPalabra) > 0)
order by cpFechaHora desc;


-- trae las salas donde el contenido de los mensajes o el resumen de la sala contienen algun string
-- se ordenan por fecha, descending 
set @algunaPalabra="jelly";
select distinct * from sala
where (idSala) 
	in (select idSala from sala where
		INSTR(resumen COLLATE utf8mb4_general_ci,@algunaPalabra) > 0)
OR (idSala) 
	in (select idSala from sala_mensaje where
		INSTR(contenido COLLATE utf8mb4_general_ci,@algunaPalabra) > 0)
order by creacion desc;


-- consultas totales de todos los docentes
select docenteCi, count(*) as "consultas totales" from consultaprivada group by docenteCi;


-- consultas pendientes de todos los docentes
select docenteCi, count(*) as "consultas pendiente" 
from consultaprivada 
where cpStatus="pendiente" group by docenteCi;


-- consultas resueltas de todos los docentes
select docenteCi, count(*) as "consultas finalizadas" 
from consultaprivada 
where cpStatus="resuelta" group by docenteCi;


-- ********* toda la informacion de alguien

-- cambie el valor del variable para buscar diferentes personas
set @ci=11111111;

-- consultas de una persona
SELECT c.*
FROM consultaprivada c 
WHERE c.alumnoCi= @ci OR c.docenteCi= @ci;

-- mensajes de todas consultas de esa persona
SELECT cpm.*
FROM cp_mensaje cpm 
WHERE @ci = cpm.ciAlumno OR @ci = cpm.ciDocente;

-- salas que persona creo 
SELECT s.*
FROM sala s
WHERE s.anfitrion= @ci;

-- mensajes de salas de esa persona
SELECT sm.*
FROM sala_mensaje sm 
WHERE sm.autorCi= @ci;
 
-- salas que persona puede aceder
SELECT sme.*
FROM sala_members sme
WHERE sme.ci= @ci;