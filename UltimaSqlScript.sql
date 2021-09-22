DROP DATABASE IF EXISTS ultimaDB;
CREATE DATABASE ultimaDB
CHARACTER SET=utf8mb4
COLLATE= utf8mb4_unicode_ci;
USE ultimaDB;

-- consultas pedidas por docente
/*
-- logs de una persona
SET @CIpersona = 77777777;
SELECT p.ci, p.nombre, p.apellido, L.login, L.logout 
FROM userLogs L, Persona p
WHERE p.ci = @CIpersona AND L.ci = @CIpersona;

-- logs de una persona en alguna fecha NOSE PORQUE NO FUNCIONA
SET @CIpersona = 77777777;
SET @fecha = "2021-09-10";
select * from userLogs;

SELECT p.ci, p.nombre, p.apellido, L.login, L.logout 
FROM userLogs L, Persona p
WHERE p.ci = @CIpersona AND L.ci = @CIpersona 
AND L.login >= @fecha AND L.logout <= @fecha;

-- check who's online
SELECT p.ci,p.nombre,p.apellido 
FROM persona p 
WHERE enLinea=true;

-- check which students are online
SELECT p.ci,p.nombre,p.apellido 
FROM persona p, alumno a
WHERE enLinea=true AND a.ci=p.ci;

-- check which teachers are online
SELECT p.ci,p.nombre,p.apellido 
FROM persona p, docente d
WHERE enLinea=true AND d.ci=p.ci;


-- trae las consultas donde el contenido de los mensajes o el titulo de la consulta contienen algun string
-- se ordenan por fecha, descending 

set @algunaPalabra="jelly";
select distinct c.* from consultaPrivada c 
where (c.idConsultaPrivada,c.docenteCi,c.alumnoCi) 
	in (select idConsultaPrivada,ciDocente,ciAlumno from CP_mensaje where 
		INSTR(contenido COLLATE utf8mb4_general_ci ,@algunaPalabra) > 0) 
OR (c.idConsultaPrivada,c.docenteCi,c.alumnoCi) 
	in (select idConsultaPrivada,docenteCi,alumnoCi from consultaPrivada where
		INSTR(titulo COLLATE utf8mb4_general_ci ,@algunaPalabra) > 0)
order by cpFechaHora desc;


-- trae las salas donde el contenido de los mensajes o el resumen de la sala contienen algun string
-- se ordenan por fecha, descending 
set @algunaPalabra="jelly";
select distinct * from Sala
where (idSala) 
	in (select idSala from Sala where
		INSTR(resumen COLLATE utf8mb4_general_ci,@algunaPalabra) > 0)
OR (idSala) 
	in (select idSala from Sala_mensaje where
		INSTR(contenido COLLATE utf8mb4_general_ci,@algunaPalabra) > 0)
order by creacion desc;


-- consultas totales de todos los docentes
select docenteCi, count(*) as "consultas totales" from consultaPrivada group by docenteCi;


-- consultas pendientes de todos los docentes
select docenteCi, count(*) as "consultas pendiente" 
from consultaPrivada 
where cpStatus="pendiente" group by docenteCi;


-- consultas resueltas de todos los docentes
select docenteCi, count(*) as "consultas finalizadas" 
from consultaPrivada 
where cpStatus="resuelta" group by docenteCi;


-- ********* toda la informacion de alguien

-- cambie el valor del variable para buscar diferentes personas
set @ci=11111111;

-- consultas de una persona
SELECT c.*
FROM consultaPrivada c 
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

CREATE TABLE Grupo (
idGrupo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombreGrupo VARCHAR(25) NOT NULL UNIQUE,
isDeleted BOOL NOT NULL DEFAULT FALSE,
INDEX (idGrupo));

CREATE TABLE Materia(
idMateria INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombreMateria VARCHAR(30) NOT NULL UNIQUE,
isDeleted BOOL NOT NULL DEFAULT FALSE,
INDEX (idMateria));

CREATE TABLE Grupo_tiene_Materia (
    idGrupo INT NOT NULL,
    idMateria INT NOT NULL,
    PRIMARY KEY (idGrupo , idMateria),
    INDEX (idGrupo,idMateria),
    FOREIGN KEY (idGrupo)
        REFERENCES Grupo (idGrupo) ,
    FOREIGN KEY (idMateria)
        REFERENCES Materia (idMateria) 
); 

CREATE TABLE Orientacion(
idOrientacion INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombreOrientacion VARCHAR(30) NOT NULL UNIQUE,
isDeleted BOOL NOT NULL DEFAULT FALSE,
INDEX (idOrientacion)
);

CREATE TABLE Orientacion_tiene_Grupo (
idOrientacion INT NOT NULL,
idGrupo INT NOT NULL,
PRIMARY KEY (idGrupo),
INDEX (idGrupo),
FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo) ,
FOREIGN KEY (idOrientacion) REFERENCES Orientacion(idOrientacion) 
);

CREATE TABLE Persona (
    ci CHAR(8) PRIMARY KEY NOT NULL,
    nombre VARCHAR(26) NOT NULL,
    apellido VARCHAR(26) NOT NULL,
    clave VARCHAR(304) NOT NULL ,
    isDeleted BOOL NOT NULL DEFAULT FALSE,
    foto BLOB  NULL,
    enLinea BOOL DEFAULT FALSE,
    INDEX(ci));	
    
CREATE TABLE userLogs (
    ci CHAR(8) NOT NULL,
    login DATETIME NOT NULL,
	logOut DATETIME NULL,
    INDEX (ci),
    FOREIGN KEY (ci) REFERENCES Persona (ci) );
   
CREATE TABLE Administrador (
    ci CHAR(8) NOT NULL UNIQUE,
    PRIMARY KEY (ci),
    FOREIGN KEY (ci) REFERENCES persona (ci) 
);

CREATE TABLE Docente (
	ci CHAR(8) NOT NULL UNIQUE,
    PRIMARY KEY (ci),
    INDEX (ci),
    FOREIGN KEY (ci) REFERENCES Persona (ci) 
);
/*
uses military time 
0-2400
if timeStart not null then 
timeEnd must have a value

timeEnd must be after timeStart so 
timeEnd>timeStart

*/

-- 0 = sunday ... 6 = saturday
CREATE TABLE Horario (
	id  INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ci CHAR(8) NOT NULL,
    dia TINYINT(1) UNSIGNED NULL,
    timeStart SMALLINT(4) UNSIGNED NULL,
	timeEnd  SMALLINT(4) UNSIGNED NULL,
    INDEX (ci),
    FOREIGN KEY (ci) REFERENCES Docente (ci) 
);
 
 -- grupos will be stored as a string and filtered with regular expression
CREATE TABLE AlumnoTemp (
    ci CHAR(8) PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    clave VARCHAR(304) NOT NULL,
    foto BLOB NULL,
    avatar BLOB NULL,
    apodo VARCHAR(20) NOT NULL,
    grupos VARCHAR(30) NOT NULL,
    INDEX(ci)
);


CREATE TABLE Docente_dicta_G_M (
    idGrupo INT NOT NULL,
    idMateria INT NOT NULL,
    docenteCi CHAR(8),
    PRIMARY KEY (idGrupo , idMateria),
    INDEX (docenteCi),
    FOREIGN KEY (idGrupo) REFERENCES Grupo (idGrupo) ,
    FOREIGN KEY (idMateria) REFERENCES Materia (idMateria) ,
    FOREIGN KEY (docenteCi) REFERENCES Docente (ci) 
);

CREATE TABLE Alumno (
  ci CHAR(8) UNIQUE NOT NULL,
    apodo VARCHAR(20) UNIQUE NOT NULL,
    PRIMARY KEY(ci),
    INDEX (ci),
    FOREIGN KEY (ci) REFERENCES Persona (ci) 
);

CREATE TABLE Alumno_tiene_Grupo(
alumnoCi CHAR(8) NOT NULL,
idGrupo INT NOT NULL,
PRIMARY KEY (alumnoCi,idGrupo),
INDEX(alumnoCi,idGrupo),
FOREIGN KEY (alumnoCi) REFERENCES Alumno(ci) ,
FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo) 
);

CREATE TABLE ConsultaPrivada (
    idConsultaPrivada INT NOT NULL,
    docenteCi CHAR(8) NOT NULL,
    alumnoCi CHAR(8) NOT NULL,
    titulo VARCHAR(50) NOT NULL,
    cpStatus ENUM('pendiente', 'resuelta') NOT NULL,
    cpFechaHora DATETIME NOT NULL,
    PRIMARY KEY (idConsultaPrivada,docenteCi, alumnoCi),
    INDEX (idConsultaPrivada,docenteCi, alumnoCi),
    FOREIGN KEY (docenteCi) REFERENCES Docente (ci) ,
    FOREIGN KEY (alumnoCi) REFERENCES Alumno (ci) );

CREATE TABLE CP_mensaje(
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
FOREIGN KEY (idConsultaPrivada) REFERENCES ConsultaPrivada (idConsultaPrivada) ,
FOREIGN KEY (ciAlumno) REFERENCES Alumno (ci) ,
FOREIGN KEY (ciDocente) REFERENCES Docente (ci) ,
FOREIGN KEY (ciDestinatario) REFERENCES Persona (ci)  );

CREATE TABLE Sala(
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
FOREIGN KEY (idGrupo) REFERENCES Grupo (idGrupo) ,
FOREIGN KEY (idMateria) REFERENCES Materia (idMateria) ,
FOREIGN KEY (docenteCi) REFERENCES Docente (ci) ,
FOREIGN KEY (anfitrion) REFERENCES Persona (ci) 
);
/*
SELECT COUNT(*) FROM Sala WHERE idGrupo=@idGrupo OR idMateria=@idMateria;
SELECT COUNT(*) FROM Alumno_tiene_Grupo WHERE idGrupo=@idGrupo;
SELECT COUNT(*) FROM Docente_dicta_G_M WHERE idGrupo=@idGrupo OR idMateria=@idMateria;
*/

CREATE TABLE Sala_members(
idSala INT UNSIGNED NOT NULL,
ci CHAR(8) NOT NULL,
isConnected BOOL DEFAULT FALSE NOT NULL,
PRIMARY KEY (idSala,ci),
INDEX (idSala,ci),
FOREIGN KEY (idSala) REFERENCES Sala (idSala) ,
FOREIGN KEY (ci) REFERENCES Persona (ci));

CREATE TABLE Sala_mensaje(
idSala INT UNSIGNED NOT NULL,
idMensaje INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
autorCi CHAR(8) NOT NULL ,
contenido VARCHAR(5000) NOT NULL,
fechaHora DATETIME NOT NULL,
INDEX (idSala),
FOREIGN KEY (idSala) REFERENCES Sala (idSala) ,
FOREIGN KEY (autorCi) REFERENCES Persona (ci) );

-- ********************************************TRIGGERS
delimiter $$
CREATE TRIGGER alumnoTp AFTER INSERT ON Alumno
FOR EACH ROW 
BEGIN
DELETE FROM AlumnoTemp WHERE ci=NEW.ci; 
END$$

CREATE TRIGGER loadMembersToSala AFTER INSERT ON Sala 
FOR EACH ROW
BEGIN
INSERT INTO Sala_members(idSala,ci,isConnected) SELECT NEW.idSala,alumnoCi,FALSE FROM alumno_tiene_Grupo WHERE idGrupo=NEW.idGrupo;
INSERT INTO Sala_members(idSala,ci,isConnected) VALUES (NEW.idSala,NEW.docenteCi,FALSE);
END$$



CREATE TRIGGER checkData BEFORE INSERT ON Persona 
FOR EACH ROW
BEGIN
SET @charType= (NEW.nombre REGEXP "[^a-z^A-Z]") + (NEW.apellido REGEXP "[^a-z^A-Z]") + (NEW.ci REGEXP "[^0-9]");
SET @lengthCi= LENGTH(NEW.ci);
IF @chartype> 0 OR @lengthCi !=8 THEN 
	SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="invalid characters";
END IF;
END$$

CREATE TRIGGER checkDataNewAlumno BEFORE INSERT ON AlumnoTemp 
FOR EACH ROW
BEGIN
SET @charType= (NEW.nombre REGEXP "[^a-z^A-Z]") + (NEW.apellido REGEXP "[^a-z^A-Z]") + (NEW.ci REGEXP "[^0-9]");
SET @lengthCi= LENGTH(NEW.ci);
IF @chartype> 0 OR @lengthCi !=8 THEN 
	SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="invalid characters";
END IF;
END$$

-- para crear nuevos logs y cerrar sesiones que no se cerraron correctamente sin usar un daemon
-- cuando una persona logs in su estado de enLinea se cambia a true
CREATE TRIGGER userHasLogged BEFORE UPDATE ON Persona
FOR EACH ROW
BEGIN
SET @count = (SELECT COUNT(*) FROM userLogs WHERE ci=NEW.ci);
SET @old = (SELECT logout FROM userLogs WHERE ci=NEW.ci AND logout IS NULL); 
IF NEW.enLinea = true THEN
	IF (@old IS NULL AND @count !=0) THEN 
		UPDATE userLogs SET logout=now() WHERE ci= NEW.ci AND logout IS NULL;
        INSERT INTO userLogs (ci, login, logout) VALUES (NEW.ci, now(), null);
	END IF;
    ELSE IF NEW.enLinea = false THEN
		UPDATE userLogs SET logout=now() WHERE ci= NEW.ci AND logout IS NULL;
    END IF;
END IF;
END$$

CREATE TRIGGER valGrupo BEFORE INSERT ON Grupo
FOR EACH ROW
BEGIN
SET @trimmedName = (TRIM(NEW.nombreGrupo));
	IF @trimmedName = '' THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="name is invalid";
END IF;
END$$
      
CREATE TRIGGER valMateria BEFORE INSERT ON Materia
FOR EACH ROW
BEGIN
SET @trimmedName = (TRIM(NEW.nombreMateria));
	IF @trimmedName = '' THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="name is invalid";
END IF;
END$$

CREATE TRIGGER valOrientacion BEFORE INSERT ON Orientacion
FOR EACH ROW
BEGIN
SET @lengthNombre = (TRIM(NEW.nombreOrientacion));
	IF @lengthNombre = "" THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="name is invalid";
END IF;
END$$
delimiter ;

DROP USER IF EXISTS alumnoLogin@'%';
DROP USER IF EXISTS docenteLogin@'%';
DROP USER IF EXISTS adminLogin@'%';
DROP USER IF EXISTS alumnoDB@'%';
DROP USER IF EXISTS docenteDB@'%';
DROP USER IF EXISTS adminDB@'%';

CREATE USER "alumnoLogin"@"%" IDENTIFIED BY "alumnoLogin";
GRANT SELECT (CI) ON ultimaDB.Alumno TO "alumnoLogin"@"%";
GRANT SELECT ON ultimaDB.Persona TO "alumnoLogin"@"%";
GRANT SELECT ON ultimaDB.Grupo TO "alumnoLogin"@"%";
GRANT INSERT ON ultimaDB.AlumnoTemp TO "alumnoLogin"@"%";

CREATE USER "docenteLogin"@"%" IDENTIFIED BY "docenteLogin";
GRANT SELECT (CI) ON ultimaDB.Docente TO "docenteLogin"@"%";
GRANT SELECT (CI,CLAVE,NOMBRE,APELLIDO,ISDELETED) ON ultimaDB.Persona TO "docenteLogin"@"%";

CREATE USER "adminLogin"@"%" IDENTIFIED BY "adminLogin";
GRANT SELECT (CI) ON ultimaDB.Administrador TO "adminLogin"@"%";
GRANT SELECT (CI,CLAVE,NOMBRE,APELLIDO,ISDELETED) ON ultimaDB.Persona TO "adminLogin"@"%";

-- *************************************************************USUARIOS NORMALES DE LA APP
CREATE USER "alumnoDB"@"%" IDENTIFIED BY "alumnoclave";
GRANT UPDATE (CLAVE,FOTO,ENLINEA,ISDELETED) ON ultimaDB.persona TO "alumnoDB"@"%";
GRANT UPDATE (ISCONNECTED) ON ultimaDB.Sala_members TO "alumnoDB"@"%";
GRANT UPDATE (CP_MENSAJESTATUS) ON ultimaDB.CP_mensaje TO "alumnoDB"@"%";
GRANT UPDATE (ISDONE) ON ultimaDB.Sala TO "alumnoDB"@"%";
GRANT UPDATE (LOGOUT) ON ultimaDB.userLogs TO "alumnoDB"@"%";
GRANT UPDATE (CPSTATUS) ON ultimaDB.ConsultaPrivada TO "alumnoDB"@"%";


GRANT SELECT ON ultimaDB.Persona TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.grupo TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.alumno TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.docente TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.Horario TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.materia TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.grupo_tiene_materia TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.alumno_tiene_Grupo TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.docente_dicta_G_M TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.ConsultaPrivada TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.CP_mensaje TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.Sala TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.Sala_members TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.Sala_mensaje TO "alumnoDB"@"%";

GRANT INSERT ON ultimadb.ConsultaPrivada TO "alumnoDB"@"%";
GRANT INSERT ON ultimadb.CP_mensaje TO "alumnoDB"@"%";
GRANT INSERT ON ultimadb.Sala TO "alumnoDB"@"%";
GRANT INSERT ON ultimadb.Sala_mensaje TO "alumnoDB"@"%";
GRANT INSERT ON ultimadb.userLogs TO "alumnoDB"@"%";


CREATE USER "docenteDB"@"%" IDENTIFIED BY "docenteclave";
GRANT UPDATE (CLAVE,FOTO,ENLINEA,ISDELETED) ON ultimaDB.persona TO "docenteDB"@"%";
GRANT UPDATE (LOGOUT) ON ultimaDB.userLogs TO "docenteDB"@"%";
GRANT UPDATE (TIMESTART,TIMEEND) ON ultimaDB.Horario TO "docenteDB"@"%";
GRANT UPDATE (ISCONNECTED) ON ultimaDB.Sala_members TO "docenteDB"@"%";
GRANT UPDATE (CP_MENSAJESTATUS) ON ultimaDB.CP_mensaje TO "docenteDB"@"%";
GRANT UPDATE (ISDONE) ON ultimaDB.Sala TO "docenteDB"@"%";
GRANT UPDATE (CPSTATUS) ON ultimaDB.ConsultaPrivada TO "docenteDB"@"%";

GRANT SELECT ON ultimaDB.Persona TO "docenteDB"@"%";
GRANT SELECT ON ultimaDB.grupo TO "docenteDB"@"%";
GRANT SELECT ON ultimaDB.alumno TO "docenteDB"@"%";
GRANT SELECT ON ultimaDB.docente TO "docenteDB"@"%";
GRANT SELECT ON ultimaDB.Horario TO "alumnoDB"@"%";
GRANT SELECT ON ultimaDB.materia TO "docenteDB"@"%";
GRANT SELECT ON ultimaDB.grupo_tiene_materia TO "docenteDB"@"%";
GRANT SELECT ON ultimaDB.alumno_tiene_Grupo TO "docenteDB"@"%";
GRANT SELECT ON ultimaDB.docente_dicta_G_M TO "docenteDB"@"%";
GRANT SELECT ON ultimaDB.ConsultaPrivada TO "docenteDB"@"%";
GRANT SELECT ON ultimaDB.CP_mensaje TO "docenteDB"@"%";
GRANT SELECT ON ultimaDB.Sala TO "docenteDB"@"%";
GRANT SELECT ON ultimaDB.Sala_members TO "docenteDB"@"%";
GRANT SELECT ON ultimaDB.Sala_mensaje TO "docenteDB"@"%";

GRANT INSERT ON ultimadb.userLogs TO "docenteDB"@"%";
GRANT INSERT ON ultimadb.Horario TO "docenteDB"@"%";
GRANT INSERT ON ultimadb.CP_mensaje TO "docenteDB"@"%";
GRANT INSERT ON ultimadb.Sala TO "docenteDB"@"%";
GRANT INSERT ON ultimadb.Sala_mensaje TO "docenteDB"@"%";


CREATE USER "adminDB"@"%" IDENTIFIED BY "adminclave";
GRANT SELECT ON ultimaDB.* TO "adminDB"@"%";

GRANT INSERT ON ultimadb.grupo TO "adminDB"@"%";
GRANT INSERT ON ultimadb.Materia TO "adminDB"@"%";
GRANT INSERT ON ultimadb.Orientacion TO "adminDB"@"%";
GRANT INSERT ON ultimadb.Orientacion_tiene_grupo TO "adminDB"@"%";
GRANT INSERT ON ultimadb.grupo_tiene_materia TO "adminDB"@"%";
GRANT INSERT ON ultimadb.Persona TO "adminDB"@"%";
GRANT INSERT ON ultimadb.Alumno TO "adminDB"@"%";
GRANT INSERT ON ultimadb.Docente TO "adminDB"@"%";
GRANT INSERT ON ultimadb.Administrador TO "adminDB"@"%";
GRANT INSERT ON ultimadb.alumno_tiene_grupo TO "adminDB"@"%";
GRANT INSERT ON ultimadb.docente_dicta_G_M TO "adminDB"@"%";

GRANT UPDATE (NOMBRE,APELLIDO,CLAVE,FOTO,ISDELETED,ENLINEA) ON ultimadb.Persona TO "adminDB"@"%";
GRANT UPDATE ON ultimadb.grupo TO "adminDB"@"%";
GRANT UPDATE ON ultimadb.Materia TO "adminDB"@"%";
GRANT UPDATE ON ultimadb.Orientacion TO "adminDB"@"%";
GRANT UPDATE ON ultimadb.Orientacion_tiene_grupo TO "adminDB"@"%";
GRANT UPDATE ON ultimadb.grupo_tiene_materia TO "adminDB"@"%";
GRANT UPDATE ON ultimadb.alumno_tiene_grupo TO "adminDB"@"%";
GRANT UPDATE ON ultimadb.docente_dicta_G_M TO "adminDB"@"%";

GRANT DELETE ON ultimadb.grupo TO "adminDB"@"%";
GRANT DELETE ON ultimadb.Materia TO "adminDB"@"%";
GRANT DELETE ON ultimadb.Orientacion TO "adminDB"@"%";
GRANT DELETE ON ultimadb.Orientacion_tiene_grupo TO "adminDB"@"%";
GRANT DELETE ON ultimadb.grupo_tiene_materia TO "adminDB"@"%";
GRANT DELETE ON ultimadb.Persona TO "adminDB"@"%";
GRANT DELETE ON ultimadb.Alumno TO "adminDB"@"%";
GRANT DELETE ON ultimadb.Docente TO "adminDB"@"%";
GRANT DELETE ON ultimadb.Administrador TO "adminDB"@"%";
GRANT DELETE ON ultimadb.alumno_tiene_grupo TO "adminDB"@"%";
GRANT DELETE ON ultimadb.docente_dicta_G_M TO "adminDB"@"%";
GRANT DELETE ON ultimadb.alumnoTemp TO "adminDB"@"%";

-- ********************************DEMO***********************************************

INSERT INTO Grupo (nombreGrupo) VALUES 
('1BB'),('2BB'),('3BB'),('3BA'),('3BC');

INSERT INTO Materia(nombreMateria) VALUES
('mat1'),('geo1'),('prog1'),('SO1'),('taller1'),
('mat2'),('geo2'),('prog2'),('SO2'),('taller2'),
('mat3'),('prog3'),('SO3'),('redes y soporte'),('disenio web'),('unity');

INSERT INTO Grupo_tiene_Materia VALUES 
(1,1),(1,2),(1,3),(1,4),(1,5),
(2,6),(2,7),(2,8),(2,9),(2,10),
(3,11),(3,12),(3,13),(3,14),
(4,11),(4,12),(4,13),(4,15),
(5,11),(5,12),(5,13),(5,16);

INSERT INTO Orientacion(nombreOrientacion) VALUES
('desarollo y soporte'),('disenio web'),('disenio de juegos');

INSERT INTO Orientacion_tiene_Grupo VALUES
(1,3),
(2,4),
(3,5);

INSERT INTO Persona (ci,nombre,apellido,clave,foto) VALUES
(11111111,'Penelope','cruz','mOþäÅ’–†óÊ8dzz¾”gÇåü4(\0XjyŠXÖË÷‰\rÐa,°¿_…¢qà Ûbcw`ßñ›ˆæÌóë',NULL),
(22222222,'pepe','red','mø€þ¦AÒÇp­é1³l´^D\0ÙÍ·Ùº™ÒÙ„©‘•+l;¢ëŒ]hã‹šÞ«T„j ½¬-n¯Q%À¿6ôVŽu¢q',NULL),
(33333333,'coco','rock','H^©R¶#ýÇÜwú“ÒUøàè°¦4?¢Ãu§ð€Ïì’CZZ¢àVpÝK3.Ã yì\n!Šk¶âæÃ\0‰JV',NULL),
(44444444,'lex','luther','ÿÜÙv:ÿí´æ}¥GOÖ5¡zÌH-t¹ ]&â‘Ê±žõÀŸÞÆžÈœ&ƒ=œ ÿÐ<óIèŒh³í4b]~R',NULL),
(55555555,'arm','pit','¶Žz¨lÔg±9Ø£u”‡•°0Ö=`9ÅÁÄ`\n`—Ti	 }ºëîþÚ³Ü9 Œ¼,$¿ó£‰ù8a7',NULL),
(66666666,'amy','schumer','E–édüíÇý4+h–eé4K+¼Út?í£ú´~«JDwØ1œ› &]M1±êV ™ö;\0Î×ôÆµ]ôîÑP9®',NULL),
(77777777,'abel','sings','÷&ÑŒWjW&…þÒúCš‘¿ï@-·ÊnÇ€Y)Úû ¬¢—ÍÎsm ¾ù4Æ®\ZàSdöq£äðQ',NULL),
(88888888,'sal','gore','‹mnU%·cñRMýî¸\0’ù’kRv´JÕà9îÐ”x•<¾Ïì>Šþ•(éó DoÜhµ3ýWÐ™<ÚHö',NULL),
(99999999,'adam','sandler','Üúýxåê-‚MH\\¶á´q	5*pt°Ze§Ù=^ºïd‡-LPôµ‰°”ö>}×| z“ðl–§	A¨yœ0	›4',NULL);


INSERT INTO userLogs (ci, login, logout) VALUES
   (11111111, DATE(DATE_SUB(NOW(), INTERVAL +11 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +10.5 DAY))),
   (11111111, DATE(DATE_SUB(NOW(), INTERVAL +10 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +9.5 DAY))),
   (11111111, DATE(DATE_SUB(NOW(), INTERVAL +9 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +8.5 DAY))),
   (11111111, DATE(DATE_SUB(NOW(), INTERVAL +8 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +7.5 DAY))),
   (11111111, DATE(DATE_SUB(NOW(), INTERVAL +7 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +1 DAY))),
   (77777777, DATE(DATE_SUB(NOW(), INTERVAL +11 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +10.5 DAY))),
   (77777777, DATE(DATE_SUB(NOW(), INTERVAL +10 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +9.5 DAY))),
   (77777777, DATE(DATE_SUB(NOW(), INTERVAL +9 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +8.5 DAY))),
   (77777777, DATE(DATE_SUB(NOW(), INTERVAL +8 DAY)),  DATE(DATE_SUB(NOW(), INTERVAL +7.5 DAY))); 



INSERT INTO Administrador(ci) VALUES (99999999);

INSERT INTO Docente (ci) VALUES
(77777777),
(88888888);

INSERT INTO Docente_dicta_G_M VALUES
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

INSERT INTO Alumno (ci,apodo) VALUES
(11111111,'cruzzz'),
(22222222,'pRed'),
(33333333,'cRock'),
(44444444,'Lexy'),
(55555555,'pittt'),
(66666666,'ahumer');

INSERT INTO Alumno_tiene_Grupo VALUES 
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

INSERT INTO ConsultaPrivada(idConsultaPrivada,docenteCi,alumnoCi,titulo,cpStatus,cpFechaHora) VALUES
(1,77777777,11111111,'hola','pendiente',NOW()),
(1,77777777,22222222,'profe hello','pendiente',NOW()),
(1,77777777,33333333,'soy tu alumno','pendiente',NOW()),
(1,77777777,44444444,'prat1','pendiente',NOW()),
(1,88888888,11111111,'prat1 ej3','pendiente',NOW()),
(1,88888888,33333333,'prat4','pendiente',NOW()),
(1,88888888,55555555,'prat3','pendiente',NOW()),
(2,77777777,11111111,'HOLAAAA','pendiente',NOW()),
(3,77777777,11111111,'todobien?','pendiente',NOW()),
(4,77777777,11111111,'faltas hoy?','pendiente',NOW()),
(5,77777777,11111111,'jelly','pendiente',NOW()),
(6,77777777,11111111,'hola','resuelta',NOW());


INSERT INTO CP_Mensaje (idCp_mensaje,idConsultaPrivada,ciDocente,ciAlumno,contenido,attachment,cp_mensajeFechaHora,cp_mensajeStatus, ciDestinatario)
VALUES 
(1,1,77777777,11111111,'this is a test, search for my words',NULL,NOW(),'recibido',77777777),
(2,1,77777777,11111111,'jelly doughnut',NULL,NOW(),'leido',11111111),
(1,1,77777777,22222222,'go to the city',NULL,NOW(),'recibido',77777777),
(2,1,77777777,22222222,'live like a demon',NULL,NOW(),'recibido',22222222),
(1,1,77777777,33333333,'give up',NULL,NOW(),'leido',77777777),
(2,1,77777777,33333333,'check the jelly',NULL,NOW(),'leido',77777777),
(1,1,77777777,44444444,'nope',NULL,NOW(),'leido',77777777),
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

INSERT INTO Sala (idGrupo,idMateria,docenteCi,anfitrion,resumen,creacion,isDone) VALUES
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

INSERT INTO Sala_mensaje (idSala,autorCi,contenido,fechaHora) VALUES 
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
