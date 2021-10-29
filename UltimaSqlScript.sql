DROP DATABASE IF EXISTS ultima;
CREATE DATABASE ultima
CHARACTER SET=utf8mb4
COLLATE= utf8mb4_unicode_ci;
USE ultima;

-- consultas pedidas por docente
/*
-- logs de una persona
SET @CIpersona = 77777777;
SELECT p.ci, p.nombre, p.apellido, L.login, L.logout 
FROM userlogs L, persona p
WHERE p.ci = @CIpersona AND L.ci = @CIpersona;

-- logs de una persona en alguna fecha NOSE PORQUE NO FUNCIONA
SET @CIpersona = 77777777;
SET @fecha = "2021-09-10";
select * from userlogs;

SELECT p.ci, p.nombre, p.apellido, L.login, L.logout 
FROM userlogs L, persona p
WHERE p.ci = @CIpersona AND L.ci = @CIpersona 
AND L.login >= @fecha AND L.logout <= @fecha;

-- check who's online
SELECT p.ci,p.nombre,p.apellido 
FROM persona p 
WHERE enLinea=TRUE;

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
*/ 

/*
ME TRAE LOS DOCENTES DEL ALUMNO 
SET @idGrupo = 1;
SELECT DISTINCT g.idGrupo,m.idMateria,dgm.docenteCi, g.nombreGrupo, m.nombreMateria, p.nombre, p.apellido
FROM grupo g, materia m, docente_dicta_g_m dgm, alumno_tiene_grupo ag, persona p
WHERE g.idGrupo = @idGrupo
AND dgm.idGrupo = @idGrupo
AND ag.idGrupo = @idGrupo
AND dgm.docenteCi = p.ci
AND dgm.idMateria = m.idMateria
AND dgm.isDeleted = FALSE
AND ag.isDeleted = FALSE;

SELECT g.nombreGrupo, m.nombreMateria, dgm.docenteCi
FROM grupo g, materia m, docente_dicta_g_m dgm 
WHERE dgm.idGrupo = g.idGrupo
AND dgm.idMateria = m.idMateria
AND dgm.docenteCi IS NOT NULL;
*/

CREATE TABLE grupo (
idGrupo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombreGrupo VARCHAR(25) NOT NULL UNIQUE,
isDeleted BOOL NOT NULL DEFAULT FALSE,
INDEX (idGrupo));

CREATE TABLE materia(
idMateria INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombreMateria VARCHAR(30) NOT NULL UNIQUE,
isDeleted BOOL NOT NULL DEFAULT FALSE,
INDEX (idMateria));

CREATE TABLE grupo_tiene_materia (
    idGrupo INT NOT NULL,
    idMateria INT NOT NULL,
    isDeleted BOOL NOT NULL DEFAULT FALSE,
    PRIMARY KEY (idGrupo , idMateria),
    INDEX (idGrupo,idMateria),
    FOREIGN KEY (idGrupo)
        REFERENCES grupo (idGrupo) ON DELETE CASCADE,
    FOREIGN KEY (idMateria)
        REFERENCES materia (idMateria) ON DELETE CASCADE
); 

CREATE TABLE orientacion(
idOrientacion INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombreOrientacion VARCHAR(30) NOT NULL UNIQUE,
isDeleted BOOL NOT NULL DEFAULT FALSE,
INDEX (idOrientacion)
);
/*
select * from grupo_tiene_materia;
select * from grupo;
delete from grupo where idGrupo=1;
update grupo_tiene_materia set isDeleted=true where idGrupo=1;
update docente_dicta_g_m set isDeleted=true where idGrupo=1;
update alumno_tiene_grupo set isDeleted=true where idGrupo=1;
update grupo set isDeleted=true where idGrupo=1;
*/

CREATE TABLE orientacion_tiene_grupo (
idOrientacion INT NOT NULL,
idGrupo INT NOT NULL,
PRIMARY KEY (idGrupo),
INDEX (idGrupo),
FOREIGN KEY (idGrupo) REFERENCES grupo(idGrupo) ON DELETE CASCADE ,
FOREIGN KEY (idOrientacion) REFERENCES orientacion(idOrientacion) ON DELETE CASCADE 
);

CREATE TABLE persona (
    ci CHAR(8) PRIMARY KEY NOT NULL,
    nombre VARCHAR(26) NOT NULL,
    apellido VARCHAR(26) NOT NULL,
    clave VARCHAR(304) NOT NULL ,
    isDeleted BOOL NOT NULL DEFAULT FALSE,
    foto MEDIUMBLOB NULL,
    enLinea BOOL DEFAULT FALSE,
    INDEX(ci));	

CREATE TABLE userlogs (
    ci CHAR(8) NOT NULL,
    login DATETIME NOT NULL,
	logOut DATETIME NULL,
    INDEX (ci),
    FOREIGN KEY (ci) REFERENCES persona (ci) ON DELETE CASCADE);
   
CREATE TABLE administrador (
    ci CHAR(8) NOT NULL UNIQUE,
    PRIMARY KEY (ci),
    FOREIGN KEY (ci) REFERENCES persona (ci) ON DELETE CASCADE
);

CREATE TABLE docente (
	ci CHAR(8) NOT NULL UNIQUE,
    PRIMARY KEY (ci),
    INDEX (ci),
    FOREIGN KEY (ci) REFERENCES persona (ci) ON DELETE CASCADE
);

/*
uses military time 
0-2400
if timeStart not NULL then 
timeEnd must have a value

timeEnd must be after timeStart so 
timeEnd>timeStart

*/
-- 0 = sunday ... 6 = saturday
CREATE TABLE horario (
	id  INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ci CHAR(8) NOT NULL,
    dia TINYINT(1) UNSIGNED NULL,
    timeStart SMALLINT(4) UNSIGNED NULL,
	timeEnd  SMALLINT(4) UNSIGNED NULL,
    INDEX (ci),
    FOREIGN KEY (ci) REFERENCES docente (ci) ON DELETE CASCADE
);

 -- grupos will be stored as a string and filtered with regular expression
CREATE TABLE alumnotemp (
    ci CHAR(8) PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    clave VARCHAR(304) NOT NULL,
    foto MEDIUMBLOB NULL,
    apodo VARCHAR(20) NOT NULL,
    grupos VARCHAR(30) NOT NULL,
    INDEX(ci)
);

CREATE TABLE docente_dicta_g_m (
    idGrupo INT NOT NULL,
    idMateria INT NOT NULL,
    docenteCi CHAR(8),
    isDeleted BOOL DEFAULT FALSE NOT NULL,
    PRIMARY KEY (idGrupo , idMateria),
    INDEX (docenteCi),
    FOREIGN KEY (idGrupo) REFERENCES grupo (idGrupo) ON DELETE CASCADE,
    FOREIGN KEY (idMateria) REFERENCES materia (idMateria) ON DELETE CASCADE,
    FOREIGN KEY (docenteCi) REFERENCES docente (ci) ON DELETE CASCADE
);

CREATE TABLE alumno (
	ci CHAR(8) UNIQUE NOT NULL,
    apodo VARCHAR(20) DEFAULT NULL,
    PRIMARY KEY(ci),
    INDEX (ci),
    FOREIGN KEY (ci) REFERENCES persona (ci) ON DELETE CASCADE
);

CREATE TABLE alumno_tiene_grupo(
alumnoCi CHAR(8) NOT NULL,
idGrupo INT NOT NULL,
isDeleted BOOL DEFAULT FALSE,
PRIMARY KEY (alumnoCi,idGrupo),
INDEX(alumnoCi,idGrupo),
FOREIGN KEY (alumnoCi) REFERENCES alumno(ci) ON DELETE CASCADE,
FOREIGN KEY (idGrupo) REFERENCES grupo(idGrupo) ON DELETE CASCADE 
);

CREATE TABLE consultaprivada (
    idConsultaPrivada INT NOT NULL,
    docenteCi CHAR(8) NOT NULL,
    alumnoCi CHAR(8) NOT NULL,
    titulo VARCHAR(50) NOT NULL,
    cpStatus ENUM('pendiente', 'resuelta') NOT NULL,
    cpFechaHora DATETIME NOT NULL,
    PRIMARY KEY (idConsultaPrivada,docenteCi, alumnoCi),
    INDEX (idConsultaPrivada,docenteCi, alumnoCi),
    FOREIGN KEY (docenteCi) REFERENCES docente (ci) ON DELETE CASCADE,
    FOREIGN KEY (alumnoCi) REFERENCES alumno (ci) ON DELETE CASCADE);

/*
Select 6
SELECT * FROM docente_dicta_g_m ;
SELECT * FROM sala WHERE idMateria=1 AND idGrupo=1; -- mat1
SELECT * FROM grupo_tiene_materia;
SELECT * FROM materia;
SELECT * FROM sala;

SELECT * FROM persona;

select gm.idgrupo, g.nombreGrupo, m.idmateria, m.nombremateria  from grupo_tiene_materia gm, grupo g, materia m where m.idmateria = gm.idmateria and g.idgrupo= gm.idgrupo;
select * from materia;
SET @idMateria = 14;
SELECT  gm.idGrupo,g.nombreGrupo, gm.idMateria, m.NombreMateria 
FROM grupo_tiene_materia gm, grupo g, materia m 
WHERE gm.idGrupo = g.idGrupo
AND gm.idMateria = m.idMateria 
AND m.idMateria = @idMateria 
AND g.isDeleted = FALSE 
AND m.isDeleted = FALSE;
*/

CREATE TABLE cp_mensaje(
idCp_mensaje INT NOT NULL,
idConsultaPrivada INT NOT NULL,
ciAlumno CHAR(8) NOT NULL,
ciDocente CHAR(8) NOT NULL,
contenido VARCHAR(5000) NOT NULL,
attachment MEDIUMBLOB,
cp_mensajeFechaHora DATETIME NOT NULL,
cp_mensajeStatus ENUM('recibido','leido') NOT NULL,
ciDestinatario CHAR(8) NOT NULL,
PRIMARY KEY(idCp_mensaje,idConsultaPrivada,ciAlumno,ciDocente),
INDEX(idCp_mensaje,idConsultaPrivada,ciAlumno,ciDocente),
FOREIGN KEY (idConsultaPrivada) REFERENCES consultaprivada (idConsultaPrivada) ON DELETE CASCADE ,
FOREIGN KEY (ciAlumno) REFERENCES alumno (ci) ON DELETE CASCADE ,
FOREIGN KEY (ciDocente) REFERENCES docente (ci) ON DELETE CASCADE,
FOREIGN KEY (ciDestinatario) REFERENCES persona (ci) ON DELETE CASCADE );

CREATE TABLE sala(
idSala INT UNSIGNED NOT NULL AUTO_INCREMENT,
idGrupo INT NOT NULL,
idMateria INT NOT NULL,
docenteCi CHAR(8) NOT NULL,
anfitrion CHAR(8) NOT NULL,
resumen VARCHAR(1000) NULL,
isDone BOOL DEFAULT FALSE NOT NULL,
creacion DATETIME NOT NULL,
PRIMARY KEY (idSala),
INDEX(idSala,idGrupo,idMateria),
FOREIGN KEY (idGrupo) REFERENCES grupo (idGrupo) ON DELETE CASCADE,
FOREIGN KEY (idMateria) REFERENCES materia (idMateria) ON DELETE CASCADE,
FOREIGN KEY (docenteCi) REFERENCES docente (ci)ON DELETE CASCADE ,
FOREIGN KEY (anfitrion) REFERENCES persona (ci)ON DELETE CASCADE 
);

CREATE TABLE sala_members(
idSala INT UNSIGNED NOT NULL,
ci CHAR(8) NOT NULL,
isConnected BOOL DEFAULT FALSE NOT NULL,
PRIMARY KEY (idSala,ci),
INDEX (idSala,ci),
FOREIGN KEY (idSala) REFERENCES sala (idSala) ON DELETE CASCADE,
FOREIGN KEY (ci) REFERENCES persona (ci) ON DELETE CASCADE);

CREATE TABLE sala_mensaje(
idSala INT UNSIGNED NOT NULL,
idMensaje INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
autorCi CHAR(8) NOT NULL ,
contenido VARCHAR(5000) NOT NULL,
fechaHora DATETIME NOT NULL,
INDEX (idSala),
FOREIGN KEY (idSala) REFERENCES sala (idSala) ON DELETE CASCADE,
FOREIGN KEY (autorCi) REFERENCES persona (ci) ON DELETE CASCADE);

delimiter $$
CREATE TRIGGER alumnoTp AFTER INSERT ON alumno
FOR EACH ROW 
BEGIN
SET @checkAlumnoTemp = (SELECT COUNT(*) FROM alumnotemp WHERE NEW.ci=ci);
	IF @checkAlumnoTemp > 0 THEN
		UPDATE persona,alumnotemp SET persona.foto = alumnotemp.foto WHERE NEW.ci = alumnotemp.ci;
		DELETE FROM alumnotemp WHERE ci=NEW.ci; 
	END IF;
END$$

CREATE TRIGGER loadMembersToSala AFTER INSERT ON sala 
FOR EACH ROW
BEGIN
INSERT INTO sala_members(idSala,ci,isConnected) SELECT NEW.idSala,alumnoCi,FALSE FROM alumno_tiene_grupo WHERE idGrupo=NEW.idGrupo;
INSERT INTO sala_members(idSala,ci,isConnected) VALUES (NEW.idSala,NEW.docenteCi,FALSE);
END$$

CREATE TRIGGER checkPersonaData BEFORE INSERT ON persona 
FOR EACH ROW
BEGIN
SET @charType= (NEW.nombre REGEXP "[^a-z^A-Z]") + (NEW.apellido REGEXP "[^a-z^A-Z]") + (NEW.ci REGEXP "[^0-9]");
SET @lengthCi= LENGTH(NEW.ci);
IF @chartype> 0 OR @lengthCi !=8 OR NEW.nombre="" OR NEW.apellido ="" THEN 
	SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="invalid characters";
END IF;
END$$

CREATE TRIGGER deleteAlumnoTemp AFTER INSERT ON persona 
FOR EACH ROW
BEGIN
	DELETE FROM alumnotemp WHERE ci=NEW.ci;
END$$

CREATE TRIGGER checkAlumnoTempData BEFORE INSERT ON alumnotemp 
FOR EACH ROW
BEGIN
SET @charType= (NEW.nombre REGEXP "[^a-z^A-Z]") + (NEW.apellido REGEXP "[^a-z^A-Z]") + (NEW.ci REGEXP "[^0-9]");
SET @lengthCi= LENGTH(NEW.ci);
IF @chartype> 0 OR @lengthCi !=8 THEN 
	SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="invalid characters";
END IF;
END$$

-- para crear nuevos logs y cerrar sesiones que no se cerraron correctamente sin usar un daemon
-- cuando una persona logs in su estado de enLinea se cambia a TRUE eso dispara este trigger
-- MAKE SURE WHEN PERSON EN LINEA IS UPDATED IN APP. ONLY THAT COLUMN IS BEING CHANGED. AND ON THE REST OF THE UPDATES DO NOT CALL ENLINEA
-- CREATE TRIGGER userHasLogged BEFORE UPDATE ON persona
-- FOR EACH ROW
-- BEGIN
-- SET @countU = (SELECT COUNT(*) FROM userlogs WHERE ci=NEW.ci);
-- SET @old = (SELECT logout FROM userlogs WHERE ci=NEW.ci AND logout IS NULL); 
-- IF NEW.enLinea = TRUE THEN
-- 	IF (@old IS NULL AND @countU !=0) THEN 
-- 		UPDATE userlogs SET logout=NOW() WHERE ci= NEW.ci AND logout IS NULL;
-- 	END IF;
--     ELSE IF NEW.enLinea = FALSE THEN
-- 		UPDATE userlogs SET logout=NOW() WHERE ci= NEW.ci AND logout IS NULL;
--     END IF;
-- END IF;
-- END$$

-- triggers below this point need to be tested
CREATE TRIGGER checkGrupo BEFORE INSERT ON grupo
FOR EACH ROW
BEGIN
SET @trimmedName = (TRIM(NEW.nombreGrupo));
	IF @trimmedName = '' THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="name is invalid";
END IF;
END$$
      
CREATE TRIGGER checkMateria BEFORE INSERT ON materia
FOR EACH ROW
BEGIN
SET @trimmedName = (TRIM(NEW.nombreMateria));
	IF @trimmedName = '' THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="name is invalid";
END IF;
END$$

CREATE TRIGGER checkOrientacion BEFORE INSERT ON orientacion
FOR EACH ROW
BEGIN
SET @lengthNombre = (TRIM(NEW.nombreOrientacion));
	IF @lengthNombre = "" THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="name is invalid";
END IF;
END$$

CREATE TRIGGER doesGMalreadyExist BEFORE INSERT ON grupo_tiene_materia
FOR EACH ROW
BEGIN
SET @isDeleted = (SELECT count(*) FROM grupo_tiene_materia WHERE idMateria = NEW.idMateria AND idGrupo = NEW.idGrupo);
   IF @isDeleted = 1 THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="isDeleted set to FALSE docenteDictaGM";
	END IF;	
END$$

CREATE TRIGGER if_GM_exists_And_Has_Data AFTER UPDATE ON grupo_tiene_materia
FOR EACH ROW
BEGIN
  UPDATE docente_dicta_g_m SET isDeleted=FALSE WHERE idGrupo = NEW.idGrupo AND idMateria = NEW.idMateria; 
END$$

CREATE TRIGGER gm BEFORE DELETE ON grupo_tiene_materia
FOR EACH ROW
BEGIN
SET @countSalasDeMateria = (SELECT COUNT(*) FROM sala WHERE idMateria = OLD.idMateria AND idGrupo = OLD.idGrupo);
   -- IF @countSalasDeMateria > 0 THEN
		-- SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="cannot delete grupoTieneMateria";
	-- END IF;	
    DELETE FROM docente_dicta_g_m  WHERE idGrupo= OLD.idGrupo AND idMateria = OLD.idMateria;
END$$

/*
CREATE TRIGGER delDocenteDicta BEFORE DELETE ON docente_dicta_g_m
FOR EACH ROW
BEGIN
SET @salasMSGCount = (SELECT count(*) FROM sala WHERE idGrupo=OLD.idGrupo AND idMateria= OLD.idMateria AND autorCi=OLD.docenteCi);
IF @salasMSGCount > 0 THEN
	SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "delete failed";
END IF;
END$$

CREATE TRIGGER delAlumnoTieneGrupo BEFORE DELETE ON alumno_tiene_grupo
FOR EACH ROW
BEGIN
SET @salasMSGCount = (SELECT count(*) FROM sala WHERE idGrupo=OLD.idGrupo);
IF @salasMSGCount > 0 THEN
	SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "delete failed";
END IF;
END$$

CREATE TRIGGER checkContentGrupo BEFORE DELETE ON grupo
FOR EACH ROW
BEGIN
SET @countSalasDeGrupo = (SELECT COUNT(*) FROM sala WHERE idGrupo = OLD.idGrupo);
   IF @countSalasDeGrupo > 0 THEN
       -- UPDATE sala SET isDone=TRUE WHERE idGrupo=OLD.idGrupo;
       -- UPDATE grupo SET isDeleted=TRUE WHERE idGrupo=OLD.idGrupo;
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="set grupo isDeleted=TRUE";
	END IF;	
END$$

CREATE TRIGGER checkContentMateria BEFORE DELETE ON materia
FOR EACH ROW
BEGIN
SET @countSalasDeMateria = (SELECT COUNT(*) FROM sala WHERE idMateria = OLD.idMateria);
   IF @countSalasDeMateria > 0 THEN
        -- UPDATE sala SET isDone=TRUE WHERE idMateria=OLD.idMateria;
		-- UPDATE materia SET isDeleted=TRUE WHERE idMateria=OLD.idMateria;
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="set materia isDeleted=TRUE";
	END IF;	
END$$

CREATE TRIGGER checkContentPersona BEFORE DELETE ON persona
FOR EACH ROW
BEGIN
SET @countLogs = (SELECT COUNT(*) FROM userlogs WHERE ci = OLD.ci);
SET @countConsultas = (SELECT COUNT(*) FROM consultaprivada WHERE alumnoCi = OLD.ci);
SET @countMensajesSala = (SELECT COUNT(*) FROM sala_mensaje WHERE autorCi =OLD.ci);
   IF @countMensasjesSala + @countLogs + @countConsultas > 0 THEN
        UPDATE persona SET isDeleted=TRUE WHERE ci=OLD.ci;
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="persona isDeleted set to TRUE";
	END IF;	
END$$

*/

delimiter ;

/*
DROP USER IF EXISTS alumnoLogin@'%';
DROP USER IF EXISTS docenteLogin@'%';
DROP USER IF EXISTS adminLogin@'%';
DROP USER IF EXISTS alumnoDB@'%';
DROP USER IF EXISTS docenteDB@'%';
DROP USER IF EXISTS adminDB@'%';

CREATE USER "alumnoLogin"@"%" IDENTIFIED BY "alumnoLogin";
GRANT SELECT (CI) ON ultima.alumno TO "alumnoLogin"@"%";
GRANT SELECT ON ultima.persona TO "alumnoLogin"@"%";
GRANT SELECT ON ultima.grupo TO "alumnoLogin"@"%";
GRANT INSERT ON ultima.alumnotemp TO "alumnoLogin"@"%";

CREATE USER "docenteLogin"@"%" IDENTIFIED BY "docenteLogin";
GRANT SELECT (CI) ON ultima.docente TO "docenteLogin"@"%";
GRANT SELECT ON ultima.persona TO "docenteLogin"@"%";

CREATE USER "adminLogin"@"%" IDENTIFIED BY "adminLogin";
GRANT SELECT (CI) ON ultima.administrador TO "adminLogin"@"%";
GRANT SELECT ON ultima.persona TO "adminLogin"@"%";

-- *************************************************************USUARIOS NORMALES DE LA APP
CREATE USER "alumnoDB"@"%" IDENTIFIED BY "alumnoclave";
GRANT UPDATE (CLAVE,FOTO,ENLINEA,ISDELETED) ON ultima.persona TO "alumnoDB"@"%";
GRANT UPDATE (ISCONNECTED) ON ultima.sala_members TO "alumnoDB"@"%";
GRANT UPDATE (CP_MENSAJESTATUS) ON ultima.cp_mensaje TO "alumnoDB"@"%";
GRANT UPDATE (ISDONE) ON ultima.sala TO "alumnoDB"@"%";
GRANT UPDATE (LOGOUT) ON ultima.userlogs TO "alumnoDB"@"%";
GRANT UPDATE (CPSTATUS) ON ultima.consultaprivada TO "alumnoDB"@"%";


GRANT SELECT ON ultima.persona TO "alumnoDB"@"%";
GRANT SELECT ON ultima.grupo TO "alumnoDB"@"%";
GRANT SELECT ON ultima.alumno TO "alumnoDB"@"%";
GRANT SELECT ON ultima.docente TO "alumnoDB"@"%";
GRANT SELECT ON ultima.horario TO "alumnoDB"@"%";
GRANT SELECT ON ultima.materia TO "alumnoDB"@"%";
GRANT SELECT ON ultima.grupo_tiene_materia TO "alumnoDB"@"%";
GRANT SELECT ON ultima.alumno_tiene_grupo TO "alumnoDB"@"%";
GRANT SELECT ON ultima.docente_dicta_g_m TO "alumnoDB"@"%";
GRANT SELECT ON ultima.consultaprivada TO "alumnoDB"@"%";
GRANT SELECT ON ultima.cp_mensaje TO "alumnoDB"@"%";
GRANT SELECT ON ultima.sala TO "alumnoDB"@"%";
GRANT SELECT ON ultima.sala_members TO "alumnoDB"@"%";
GRANT SELECT ON ultima.sala_mensaje TO "alumnoDB"@"%";

GRANT INSERT ON ultima.consultaprivada TO "alumnoDB"@"%";
GRANT INSERT ON ultima.cp_mensaje TO "alumnoDB"@"%";
GRANT INSERT ON ultima.sala TO "alumnoDB"@"%";
GRANT INSERT ON ultima.sala_mensaje TO "alumnoDB"@"%";
GRANT INSERT ON ultima.userlogs TO "alumnoDB"@"%";


CREATE USER "docenteDB"@"%" IDENTIFIED BY "docenteclave";
GRANT UPDATE (CLAVE,FOTO,ENLINEA,ISDELETED) ON ultima.persona TO "docenteDB"@"%";
GRANT UPDATE (LOGOUT) ON ultima.userlogs TO "docenteDB"@"%";
GRANT UPDATE (TIMESTART,TIMEEND) ON ultima.horario TO "docenteDB"@"%";
GRANT UPDATE (ISCONNECTED) ON ultima.sala_members TO "docenteDB"@"%";
GRANT UPDATE (CP_MENSAJESTATUS) ON ultima.cp_mensaje TO "docenteDB"@"%";
GRANT UPDATE (ISDONE) ON ultima.sala TO "docenteDB"@"%";
GRANT UPDATE (CPSTATUS) ON ultima.consultaprivada TO "docenteDB"@"%";

GRANT SELECT ON ultima.persona TO "docenteDB"@"%";
GRANT SELECT ON ultima.grupo TO "docenteDB"@"%";
GRANT SELECT ON ultima.alumno TO "docenteDB"@"%";
GRANT SELECT ON ultima.docente TO "docenteDB"@"%";
GRANT SELECT ON ultima.horario TO "alumnoDB"@"%";
GRANT SELECT ON ultima.materia TO "docenteDB"@"%";
GRANT SELECT ON ultima.grupo_tiene_materia TO "docenteDB"@"%";
GRANT SELECT ON ultima.alumno_tiene_grupo TO "docenteDB"@"%";
GRANT SELECT ON ultima.docente_dicta_g_m TO "docenteDB"@"%";
GRANT SELECT ON ultima.consultaprivada TO "docenteDB"@"%";
GRANT SELECT ON ultima.cp_mensaje TO "docenteDB"@"%";
GRANT SELECT ON ultima.sala TO "docenteDB"@"%";
GRANT SELECT ON ultima.sala_members TO "docenteDB"@"%";
GRANT SELECT ON ultima.sala_mensaje TO "docenteDB"@"%";

GRANT INSERT ON ultima.userlogs TO "docenteDB"@"%";
GRANT INSERT ON ultima.horario TO "docenteDB"@"%";
GRANT INSERT ON ultima.cp_mensaje TO "docenteDB"@"%";
GRANT INSERT ON ultima.sala TO "docenteDB"@"%";
GRANT INSERT ON ultima.sala_mensaje TO "docenteDB"@"%";

CREATE USER "adminDB"@"%" IDENTIFIED BY "adminclave";
GRANT SELECT ON ultima.* TO "adminDB"@"%";

GRANT INSERT ON ultima.grupo TO "adminDB"@"%";
GRANT INSERT ON ultima.materia TO "adminDB"@"%";
GRANT INSERT ON ultima.orientacion TO "adminDB"@"%";
GRANT INSERT ON ultima.orientacion_tiene_grupo TO "adminDB"@"%";
GRANT INSERT ON ultima.grupo_tiene_materia TO "adminDB"@"%";
GRANT INSERT ON ultima.persona TO "adminDB"@"%";
GRANT INSERT ON ultima.alumno TO "adminDB"@"%";
GRANT INSERT ON ultima.docente TO "adminDB"@"%";
GRANT INSERT ON ultima.administrador TO "adminDB"@"%";
GRANT INSERT ON ultima.alumno_tiene_grupo TO "adminDB"@"%";
GRANT INSERT ON ultima.docente_dicta_g_m TO "adminDB"@"%";

GRANT UPDATE (NOMBRE,APELLIDO,CLAVE,FOTO,ISDELETED,ENLINEA) ON ultima.persona TO "adminDB"@"%";
GRANT UPDATE ON ultima.grupo TO "adminDB"@"%";
GRANT UPDATE ON ultima.materia TO "adminDB"@"%";
GRANT UPDATE ON ultima.orientacion TO "adminDB"@"%";
GRANT UPDATE ON ultima.orientacion_tiene_grupo TO "adminDB"@"%";
GRANT UPDATE ON ultima.grupo_tiene_materia TO "adminDB"@"%";
GRANT UPDATE ON ultima.alumno_tiene_grupo TO "adminDB"@"%";
GRANT UPDATE ON ultima.docente_dicta_g_m TO "adminDB"@"%";
GRANT UPDATE ON ultima.sala TO "adminDB"@"%";

GRANT DELETE ON ultima.grupo TO "adminDB"@"%";
GRANT DELETE ON ultima.materia TO "adminDB"@"%";
GRANT DELETE ON ultima.orientacion TO "adminDB"@"%";
GRANT DELETE ON ultima.orientacion_tiene_grupo TO "adminDB"@"%";
GRANT DELETE ON ultima.grupo_tiene_materia TO "adminDB"@"%";
GRANT DELETE ON ultima.persona TO "adminDB"@"%";
GRANT DELETE ON ultima.alumno TO "adminDB"@"%";
GRANT DELETE ON ultima.docente TO "adminDB"@"%";
GRANT DELETE ON ultima.administrador TO "adminDB"@"%";
GRANT DELETE ON ultima.alumno_tiene_grupo TO "adminDB"@"%";
GRANT DELETE ON ultima.docente_dicta_g_m TO "adminDB"@"%";
GRANT DELETE ON ultima.alumnotemp TO "adminDB"@"%";
*/

-- SET @nombreGrupo = '1BB';
-- SET @nombreMateria = 'mat1';
-- SELECT distinct dgm.docenteCi, dgm.idGrupo, dgm.idMateria, g.nombreGrupo, m.nombreMateria 
-- FROM docente_dicta_g_m dgm, grupo g, materia m WHERE 
-- m.idMateria = dgm.idMateria AND
-- g.idGrupo = dgm.idGrupo AND 
-- dgm.isDeleted = false; AND
-- (dgm.docenteCi is NULL OR dgm.docenteCi="77777777");

/*
select dgm.docenteCi,g.idGrupo,g.nombreGrupo, m.idMateria, m.nombreMateria 
from docente_dicta_g_m dgm, grupo g, materia m 
WHERE m.idMateria=dgm.idMateria AND g.idGrupo = dgm.idGrupo order by docenteCi,idGrupo asc;

select g.idGrupo,g.nombreGrupo, m.idMateria, m.nombreMateria 
from grupo_tiene_materia gm, grupo g, materia m 
where gm.idGrupo=g.idGrupo and m.idMateria=gm.idMateria;
*/

-- ********************************DEMO***********************************************

-- INSERT INTO docente_dicta_g_m (idGrupo,idMateria,ci) VALUES (); 

INSERT INTO grupo (nombreGrupo) VALUES 
('1BB'),('2BB'),('3BB'),('3BA'),('3BC');

INSERT INTO materia(nombreMateria) VALUES
('mat1'),('geo1'),('prog1'),('SO1'),('taller1'),
('mat2'),('geo2'),('prog2'),('SO2'),('taller2'),
('mat3'),('prog3'),('SO3'),('redes y soporte'),('disenio web'),('unity');

INSERT INTO grupo_tiene_materia (idGrupo, idMateria)VALUES 
(1,1),(1,2),(1,3),(1,4),(1,5),
(2,6),(2,7),(2,8),(2,9),(2,10),
(3,11),(3,12),(3,13),(3,14),
(4,11),(4,12),(4,13),(4,15),
(5,11),(5,12),(5,13),(5,16);

INSERT INTO orientacion(nombreOrientacion) VALUES
('desarrollo y soporte'),('disenio web'),('disenio de juegos');

INSERT INTO orientacion_tiene_grupo VALUES
(1,3),
(2,4),
(3,5);

INSERT INTO persona (ci,nombre,apellido,clave,foto) VALUES
(11111111,'Penelope','cruz','mOþäÅ’–†óÊ8dzz¾”gÇåü4(\0XjyŠXÖË÷‰\rÐa,°¿_…¢qà Ûbcw`ßñ›ˆæÌóë',NULL),
(22222222,'Peter','Parker','mø€þ¦AÒÇp­é1³l´^D\0ÙÍ·Ùº™ÒÙ„©‘•+l;¢ëŒ]hã‹šÞ«T„j ½¬-n¯Q%À¿6ôVŽu¢q',NULL),
(33333333,'Kendrick','Lamar','ÌòV–+ûMŸh{D·ê	iø/>~§ËXŠl*¢ºšJƒYßîÎ©îõn´=‹FÓšC 0Ô0×$1ÿùè¸«Ø¯ö5',NULL),
(44444444,'Lex','Luther','ÿÜÙv:ÿí´æ}¥GOÖ5¡zÌH-t¹ ]&â‘Ê±žõÀŸÞÆžÈœ&ƒ=œ ÿÐ<óIèŒh³í4b]~R',NULL),
(55555555,'Brad','Pitt','¶Žz¨lÔg±9Ø£u”‡•°0Ö=`9ÅÁÄ`\n`—Ti	 }ºëîþÚ³Ü9 Œ¼,$¿ó£‰ù8a7',NULL),
(66666666,'Dwayne','Johnson','E–édüíÇý4+h–eé4K+¼Út?í£ú´~«JDwØ1œ› &]M1±êV ™ö;\0Î×ôÆµ]ôîÑP9®',NULL),
(77777777,'abel','sings','÷&ÑŒWjW&…þÒúCš‘¿ï@-·ÊnÇ€Y)Úû ¬¢—ÍÎsm ¾ù4Æ®\ZàSdöq£äðQ',NULL),
(88888888,'Kevin','Hart','‹mnU%·cñRMýî¸\0’ù’kRv´JÕà9îÐ”x•<¾Ïì>Šþ•(éó DoÜhµ3ýWÐ™<ÚHö',NULL),
(99999999,'Adam','Sandler','Üúýxåê-‚MH\\¶á´q	5*pt°Ze§Ù=^ºïd‡-LPôµ‰°”ö>}×| z“ðl–§	A¨yœ0	›4',NULL);

-- INSERT INTO userlogs (ci, login, logout) VALUES
--    (11111111, DATE(DATE_SUB(NOW(), INTERVAL +11 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +10.5 DAY))),
--    (11111111, DATE(DATE_SUB(NOW(), INTERVAL +10 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +9.5 DAY))),
--    (11111111, DATE(DATE_SUB(NOW(), INTERVAL +9 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +8.5 DAY))),
--    (11111111, DATE(DATE_SUB(NOW(), INTERVAL +8 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +7.5 DAY))),
--    (11111111, DATE(DATE_SUB(NOW(), INTERVAL +7 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +1 DAY))),
--    (77777777, DATE(DATE_SUB(NOW(), INTERVAL +11 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +10.5 DAY))),
--    (77777777, DATE(DATE_SUB(NOW(), INTERVAL +10 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +9.5 DAY))),
--    (77777777, DATE(DATE_SUB(NOW(), INTERVAL +9 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +8.5 DAY))),
--    (77777777, DATE(DATE_SUB(NOW(), INTERVAL +8 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +7.5 DAY))); 

INSERT INTO administrador(ci) VALUES (99999999);

INSERT INTO docente (ci) VALUES
(77777777),
(88888888);

INSERT INTO docente_dicta_g_m (idGrupo,idMateria,docenteCi)VALUES
(1,1,77777777),
(1,2,NULL),
(1,4,NULL),
(1,5,NULL),
(2,6,77777777),
(2,7,NULL),
(2,8,NULL),
(2,9,NULL),
(2,10,NULL),
(3,13,NULL),
(3,14,NULL),
(4,11,NULL),
(4,12,NULL),
(4,13,NULL),
(4,15,NULL),
(5,11,NULL),
(5,12,NULL),
(5,13,NULL),
(5,16,NULL),
(3,11,77777777),
(1,3,88888888),
(3,12,88888888);

delimiter $$
CREATE TRIGGER loadIntoDdGM AFTER INSERT ON grupo_tiene_materia
FOR EACH ROW
BEGIN
SET @alreadyexists = (SELECT COUNT(*) FROM docente_dicta_g_m WHERE NEW.idGrupo=idGrupo AND NEW.idMateria = idMateria);
IF @alreadyexists != 1 THEN 
	INSERT INTO docente_dicta_g_m (idGrupo, idMateria, docenteCi) VALUES (NEW.idGrupo, NEW.idMateria, NULL);
ELSE 
	SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "already in docente_dicta_g_m set isdeleted to false";
END IF;
END$$
delimiter ;

INSERT INTO alumno (ci,apodo) VALUES
(11111111,'cruzzz'),
(22222222,'Spider-man'),
(33333333,'Kdot'),
(44444444,'Lexy'),
(55555555,'Capt. Pitt'),
(66666666,'The Rock');

INSERT INTO alumno_tiene_grupo (alumnoCi, idGrupo) VALUES 
(11111111,1),
(11111111,2),
(22222222,3),
(33333333,1),
(44444444,2),
(55555555,5),
(66666666,3),
(66666666,1),
(22222222,2),
(44444444,1);

INSERT INTO consultaprivada(idConsultaPrivada,docenteCi,alumnoCi,titulo,cpStatus,cpFechaHora) VALUES
(1,77777777,11111111,'hola','pendiente',DATE(DATE_SUB(NOW(), INTERVAL +6 DAY))),
(1,77777777,22222222,'profe hello','pendiente',DATE(DATE_SUB(NOW(), INTERVAL +5 DAY))),
(1,77777777,33333333,'soy tu alumno','pendiente',DATE(DATE_SUB(NOW(), INTERVAL +3 DAY))),
(1,77777777,44444444,'prat1','pendiente',DATE(DATE_SUB(NOW(), INTERVAL +4 DAY))),
(1,88888888,11111111,'prat1 ej3','pendiente',NOW()),
(1,88888888,33333333,'prat4','pendiente',NOW()),
(1,88888888,55555555,'prat3','pendiente',NOW()),
(2,77777777,11111111,'HOLAAAA','pendiente',NOW()),
(3,77777777,11111111,'todobien?','pendiente',NOW()),
(4,77777777,11111111,'faltas hoy?','pendiente',NOW()),
(5,77777777,11111111,'jelly','pendiente',NOW()),
(6,77777777,11111111,'hola','resuelta',NOW());

INSERT INTO cp_mensaje (idCp_mensaje,idConsultaPrivada,ciDocente,ciAlumno,contenido,attachment,cp_mensajeFechaHora,cp_mensajeStatus, ciDestinatario)
VALUES 
(1,1,77777777,11111111,'this is a test, search for my words',NULL,DATE(DATE_SUB(NOW(), INTERVAL +6 DAY)),'recibido',77777777),
(2,1,77777777,11111111,'jelly doughnut',NULL,NOW(),'leido',11111111),
(1,1,77777777,22222222,'go to the city',NULL,DATE(DATE_SUB(NOW(), INTERVAL +5 DAY)),'recibido',77777777),
(2,1,77777777,22222222,'live like a demon',NULL,DATE(DATE_SUB(NOW(), INTERVAL +3.5 DAY)),'recibido',22222222),
(1,1,77777777,33333333,'give up',NULL,DATE(DATE_SUB(NOW(), INTERVAL +3 DAY)),'leido',77777777),
(2,1,77777777,33333333,'check the jelly',NULL,DATE(DATE_SUB(NOW(), INTERVAL +2 DAY)),'leido',77777777),
(1,1,77777777,44444444,'nope',NULL,DATE(DATE_SUB(NOW(), INTERVAL +4 DAY)),'leido',77777777),
(2,1,77777777,44444444,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',44444444),
(1,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(2,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',11111111),
(1,1,88888888,33333333,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(2,1,88888888,33333333,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',33333333),
(1,1,88888888,55555555,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(1,2,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,2,77777777,11111111,'asdasda',NULL,NOW(),'recibido',11111111),
(1,3,77777777,11111111,'cat',NULL,NOW(),'recibido',77777777),
(2,3,77777777,11111111,'asdasda',NULL,NOW(),'recibido',11111111),
(1,4,77777777,11111111,'jelly welly',NULL,NOW(),'recibido',77777777),
(2,4,77777777,11111111,'blah blah',NULL,NOW(),'recibido',11111111),
(1,5,77777777,11111111,'jelly',NULL,NOW(),'recibido','77777777'),
(1,6,77777777,11111111,'hola',NULL,NOW(),"recibido",'77777777');

INSERT INTO sala (idGrupo,idMateria,docenteCi,anfitrion,resumen,creacion,isDone) VALUES
(1,1,77777777,11111111,"se hablo del prat 1 de polinomios",DATE(DATE_SUB(NOW(), INTERVAL +6 DAY)),FALSE),
(1,1,77777777,11111111,"2domsgg",DATE(DATE_SUB(NOW(), INTERVAL +4 DAY)),FALSE),
(1,1,77777777,11111111,"demooososo",DATE(DATE_SUB(NOW(), INTERVAL +4 DAY)),FALSE),
(1,1,77777777,11111111,"jelly",DATE(DATE_SUB(NOW(), INTERVAL +4 DAY)),FALSE),


(2,6,77777777,77777777,"revisamos el ejercicio 10 de prat 2",DATE(DATE_SUB(NOW(), INTERVAL +16 DAY)),TRUE),
(2,6,77777777,77777777,"revision primer escrito", DATE(DATE_SUB(NOW(), INTERVAL +11 DAY)),TRUE),
(2,6,77777777,77777777,"demostracion rufini", DATE(DATE_SUB(NOW(), INTERVAL +11 DAY)),TRUE),

(3,11,77777777,77777777,"E.A y R.G de 1/x", DATE(DATE_SUB(NOW(), INTERVAL +10 DAY)),TRUE),
(3,11,77777777,77777777,"dudas prat1", DATE(DATE_SUB(NOW(), INTERVAL +9 DAY)),TRUE),
(3,11,77777777,77777777,"dudas prat2", DATE(DATE_SUB(NOW(), INTERVAL +8 DAY)),FALSE),

(1,3,88888888,88888888,"intro a java", DATE(DATE_SUB(NOW(), INTERVAL +7 DAY)),TRUE),
(1,3,88888888,88888888,"intro de programacion orientada a objetos", DATE(DATE_SUB(NOW(), INTERVAL +6 DAY)),TRUE),
(1,3,88888888,88888888,"estructuras repetitivas", DATE(DATE_SUB(NOW(), INTERVAL +5 DAY)),TRUE),
(1,3,88888888,88888888,"condicionales", DATE(DATE_SUB(NOW(), INTERVAL +4 DAY)),FALSE),

(3,12,88888888,88888888,"INTRO A C#", DATE(DATE_SUB(NOW(), INTERVAL +3 DAY)),TRUE),
(3,12,88888888,88888888,"Capas de datos", DATE(DATE_SUB(NOW(), INTERVAL +2 DAY)),TRUE),
(3,12,88888888,88888888,"calculadora en c#", DATE(DATE_SUB(NOW(), INTERVAL +1 DAY)),TRUE),
(3,12,88888888,88888888,"ejemplo de conexion a base de datos c#", DATE(DATE_SUB(NOW(), INTERVAL +5 HOUR)),FALSE);


INSERT INTO sala_mensaje (idSala,autorCi,contenido,fechaHora) VALUES 
(1,11111111,"Hola podemos discutir lo del prat 1?", DATE(DATE_SUB(NOW(), INTERVAL +5 DAY))),
(1,33333333,"yes im very lost help me", DATE(DATE_SUB(NOW(), INTERVAL +4 DAY))),
(1,77777777,"sii pregunta nomas y yo les contesto ",  DATE(DATE_SUB(NOW(), INTERVAL +2 DAY))),
(1,77777777,"msg3",  DATE(DATE_SUB(NOW(), INTERVAL +2 DAY ))),
(1,77777777,"masg4",  DATE(DATE_SUB(NOW(), INTERVAL +3 DAY))),
(1,77777777,"msg5",  DATE(DATE_SUB(NOW(), INTERVAL +5 HOUR))),
(1,77777777,"msg6",  DATE(DATE_SUB(NOW(), INTERVAL +1 DAY))),
(1,77777777,"jelly",  DATE(DATE_SUB(NOW(), INTERVAL +1 HOUR))),

(2,77777777,"buenas chicoos", DATE(DATE_SUB(NOW(), INTERVAL +15 DAY))),
(2,77777777,"Hoy vamos a hacer x cosa", DATE(DATE_SUB(NOW(), INTERVAL +10 DAY))),

(3,77777777,"hola son el grupo 3ro?", DATE(DATE_SUB(NOW(), INTERVAL +4 DAY))),

(4,77777777,"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", DATE(DATE_SUB(NOW(), INTERVAL +10 DAY))),
(4,77777777,"Lorem ipsum dolor sit amet, consectetur adipiscing elgna aliqua.", DATE(DATE_SUB(NOW(), INTERVAL +5 DAY)));
