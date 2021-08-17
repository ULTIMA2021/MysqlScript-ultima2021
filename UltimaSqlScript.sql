DROP DATABASE IF EXISTS ultimaDB;
CREATE DATABASE ultimaDB;
USE ultimaDB;

drop user if exists alumnoLogin@"localhost";
drop user if exists docenteLogin@"localhost";
drop user if exists adminLogin@"localhost";
drop user if exists alumnoDB@"localhost";
drop user if exists docenteDB@"localhost";
drop user if exists adminDB@"localhost";

CREATE TABLE Grupo (
idGrupo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombreGrupo VARCHAR(10) NOT NULL
);

CREATE TABLE Materia(
idMateria INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombreMateria VARCHAR(25) NOT NULL
);

CREATE TABLE Grupo_tiene_Materia (
    idGrupo INT NOT NULL,
    idMateria INT NOT NULL,
    PRIMARY KEY (idGrupo , idMateria),
    FOREIGN KEY (idGrupo)
        REFERENCES Grupo (idGrupo),
    FOREIGN KEY (idMateria)
        REFERENCES Materia (idMateria)
); 

CREATE TABLE Orientacion(
idOrientacion INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombreOrientacion VARCHAR(25) NOT NULL
);

CREATE TABLE Orientacion_tiene_Grupo (
idOrientacion INT NOT NULL,
idGrupo INT NOT NULL,
PRIMARY KEY (idGrupo),
FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo),
FOREIGN KEY (idOrientacion) REFERENCES Orientacion(idOrientacion)
);

CREATE TABLE Persona (
    ci INT(8) PRIMARY KEY NOT NULL,
    nombre VARCHAR(26) NOT NULL,
    apellido VARCHAR(26) NOT NULL,
    clave VARCHAR(32) NOT NULL ,
    isDeleted BOOL NOT NULL,
    foto BLOB  NULL,
    avatar BLOB  NULL,
    enLinea BOOL NOT NULL,
    CONSTRAINT notIn5point7 CHECK (ci between 10000000 AND 99999999),
    CONSTRAINT notIn5point72 CHECK (nombre regexp "^[a-zA-Z]+$"),
    CONSTRAINT notIn5point713 CHECK (apellido regexp "^[a-zA-Z]+$")
);

CREATE TABLE Administrador (
    ci INT NOT NULL UNIQUE,
    idAdmin INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (idAdmin , ci),
    FOREIGN KEY (ci)
        REFERENCES persona (ci)
);
/*
delimiter $$
CREATE TRIGGER adminLogging BEFORE INSERT ON Administrador 
FOR EACH ROW
BEGIN
SET @usr = (substring_index((SELECT USER()),"@",1));
IF @usr = "adminLogin" THEN
	SET @clave = (SELECT p.clave FROM Administrador a,Persona p WHERE NEW.ci=p.ci AND NEW.ci=a.ci AND NEW.idAdmin=p.clave);
    -- no use un switch aca porque no se puede comparar a null en un case
IF @clave IS NULL THEN 
        SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="failed";  -- clave not found
	ELSE
		IF @clave IS NOT NULL THEN
			SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="good"; -- clave found 
		else
			SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="UnkownMysqlException"; -- some strange shit happened
        END IF;
	END IF;
END IF;
END$$
delimiter ;
*/
CREATE TABLE Docente (
	ci INT NOT NULL UNIQUE,
    idDocente INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (idDocente,ci),
    FOREIGN KEY (ci)
        REFERENCES Persona (ci)
);
/*grupos will be stored as a string and filtered with regular expression*/
CREATE TABLE AlumnoTemp(
ci INT(8) PRIMARY KEY NOT NULL ,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    clave VARCHAR(32) NOT NULL,
    foto BLOB  NULL,
    avatar BLOB  NULL,
    apodo VARCHAR(20) UNIQUE,
    grupos VARCHAR(30) NOT NULL,
	CONSTRAINT ATciCheck CHECK (ci between 10000000 AND 99999999),
    CONSTRAINT ATnombreCheck CHECK (nombre regexp "^[a-zA-Z]+$"),
    CONSTRAINT ATapellidoCheck CHECK (apellido regexp "^[a-zA-Z]+$"));
    
CREATE TABLE Docente_dicta_G_M (
idGrupo INT NOT NULL,
idMateria INT NOT NULL,
docenteCi INT,
PRIMARY KEY (idGrupo,idMateria),
FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo),
FOREIGN KEY (idMateria) REFERENCES Materia(idMateria),
FOREIGN KEY (docenteCi) REFERENCES Docente (ci)
);

CREATE TABLE Alumno (
  ci INT(8) UNIQUE NOT NULL,
    idAlumno INT NOT NULL AUTO_INCREMENT,
    apodo VARCHAR(20) UNIQUE NOT NULL,
    PRIMARY KEY(idAlumno,ci),
    FOREIGN KEY (ci)
        REFERENCES Persona (ci)
);

CREATE TABLE Alumno_tiene_Grupo(
alumnoCi INT NOT NULL,
idGrupo INT NOT NULL,
PRIMARY KEY (alumnoCi,idGrupo),
FOREIGN KEY (alumnoCi) REFERENCES Alumno(ci),
FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo)
);

CREATE TABLE ConsultaPrivada (
    idConsultaPrivada INT NOT NULL,
    docenteCi INT,
    alumnoCi INT,
    titulo VARCHAR(50) NOT NULL,
    cpStatus ENUM('pendiente', 'resuelta') NOT NULL,
    cpFechaHora DATETIME NOT NULL,
    PRIMARY KEY (idConsultaPrivada,docenteCi, alumnoCi),
    FOREIGN KEY (docenteCi)
        REFERENCES Docente (ci),
    FOREIGN KEY (alumnoCi)
        REFERENCES Alumno (ci));
        
CREATE TABLE CP_mensaje(
idCp_mensaje INT NOT NULL,
idConsultaPrivada INT NOT NULL,
ciAlumno INT NOT NULL,
ciDocente INT NOT NULL,
contenido VARCHAR(10000) NOT NULL,
attachment MEDIUMBLOB,
cp_mensajeFechaHora DATETIME NOT NULL,
cp_mensajeStatus ENUM('recibido','leido'),
ciDestinatario INT NOT NULL,
PRIMARY KEY(idCp_mensaje,idConsultaPrivada,ciAlumno,ciDocente),
FOREIGN KEY (idConsultaPrivada) REFERENCES ConsultaPrivada (idConsultaPrivada),
FOREIGN KEY (ciAlumno) REFERENCES Alumno (ci),
FOREIGN KEY (ciDocente) REFERENCES Docente (ci),
FOREIGN KEY (ciDestinatario) REFERENCES Persona (ci));

CREATE TABLE Sala(
idSala INT UNSIGNED NOT NULL AUTO_INCREMENT,
idGrupo INT NOT NULL,
idMateria INT NOT NULL,
docenteCi INT NOT NULL,
anfitrion INT NOT NULL,
resumen VARCHAR(1000) NULL,
isDone BOOL DEFAULT FALSE NOT NULL,
creacion DATETIME NOT NULL,
PRIMARY KEY (idSala, idGrupo, idMateria, docenteCi),
FOREIGN KEY (idGrupo) REFERENCES Grupo (idGrupo),
FOREIGN KEY (idMateria) REFERENCES Materia (idMateria),
FOREIGN KEY (docenteCi) REFERENCES Docente (ci),
FOREIGN KEY (anfitrion) REFERENCES Persona (ci)
);

CREATE TABLE Sala_members(
idSala INT UNSIGNED NOT NULL,
ci INT NOT NULL,
isConnected BOOL DEFAULT FALSE NOT NULL,
PRIMARY KEY (idSala,ci),
FOREIGN KEY (idSala) REFERENCES Sala (idSala),
FOREIGN KEY (ci) REFERENCES Persona (ci));


CREATE TABLE Sala_mensaje(
idSala INT UNSIGNED NOT NULL,
idMensaje INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
autorCi INT NOT NULL,
contenido VARCHAR(5000) NOT NULL,
fechaHora DATETIME NOT NULL,
FOREIGN KEY (idSala) REFERENCES Sala (idSala),
FOREIGN KEY (autorCi) REFERENCES Persona (ci));


/*
-- in last and change idSala to the id you want to search for
-- me trae la lista de personas conectadas o no a una sala 
SELECT * from Persona p, Sala_Member sm, Grupo g, Sala s, WHERE 
p.ci=sm.ci AND s.idGrupo=g.idGrupo AND s.idSala=sm.idSala; 
*/

/*******************************************USUARIOS PARA LA FORM DE LOGIN/REGISTRO**************************************************/
create user "alumnoLogin"@"localhost" identified by "alumnoLogin";
grant select (ci) on ultimaDB.Alumno to "alumnoLogin"@"localhost";
grant select on ultimaDB.Persona to "alumnoLogin"@"localhost";
grant select on ultimaDB.Grupo to "alumnoLogin"@"localhost";
grant insert on ultimaDB.AlumnoTemp to "alumnoLogin"@"localhost";

create user "docenteLogin"@"localhost" identified by "docenteLogin";
grant insert (ci,idDocente) on ultimaDB.Docente to "docenteLogin"@"localhost";
grant select (ci) on ultimaDB.Docente to "docenteLogin"@"localhost";
grant select on ultimaDB.Persona to "docenteLogin"@"localhost";

create user "adminLogin"@"localhost" identified by "adminLogin";
grant insert (ci,idAdmin) on ultimaDB.Administrador to "adminLogin"@"localhost";
grant select (ci) on ultimaDB.Administrador to "adminLogin"@"localhost";
grant select on ultimaDB.Persona to "adminLogin"@"localhost";

/****************************************USUARIOS NORMALES DE LA APP*******************************************************************/

create user "alumnoDB"@"localhost" identified by "alumnoclave";
grant all privileges on ultimaDB.* to "alumnoDB"@"localhost";

create user "docenteDB"@"localhost" identified by "docenteclave";
grant all privileges on ultimaDB.* to "docenteDB"@"localhost";

create user "adminDB"@"localhost" identified by "adminclave";
grant all privileges on ultimaDB.* to "adminDB"@"localhost";



/********************************DEMO***********************************************/

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

INSERT INTO Persona VALUES
(11111111,'Penelope','cruz','clave1',0,NULL,NULL, TRUE),
(22222222,'pepe','red','clave2',0,NULL,NULL, TRUE),
(33333333,'coco','rock','clave3',0,NULL,NULL, TRUE),
(44444444,'lex','luther','clave4',0,NULL,NULL, TRUE),
(55555555,'arm','pit','clave5',0,NULL,NULL, TRUE),
(66666666,'amy','schumer','clave6',0,NULL,NULL, TRUE),
(77777777,'abel','sings','clave7',0,NULL,NULL, TRUE),
(88888888,'sal','gore','clave8',0,NULL,NULL, TRUE),
(99999999,'adam','sandler','adminclave',0,NULL,NULL,TRUE);

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
(4,77777777,11111111,'faltas hoy?','pendiente',NOW());

INSERT INTO CP_Mensaje (idCp_mensaje,idConsultaPrivada,ciDocente,ciAlumno,contenido,attachment,cp_mensajeFechaHora,cp_mensajeStatus, ciDestinatario)
VALUES 
(1,1,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,1,77777777,11111111,'asderererwasda',NULL,NOW(),'leido',11111111),
(1,1,77777777,22222222,'asdasda',NULL,NOW(),'recibido',77777777),
(2,1,77777777,22222222,'asdasda',NULL,NOW(),'recibido',22222222),
(1,1,77777777,33333333,'fsdfsdfsdfsd',NULL,NOW(),'leido',77777777),
(2,1,77777777,33333333,'gfgfdgdf',NULL,NOW(),'leido',77777777),
(1,1,77777777,44444444,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',77777777),
(2,1,77777777,44444444,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',44444444),
(1,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(2,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',11111111),
(1,1,88888888,33333333,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(2,1,88888888,33333333,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',33333333),
(1,1,88888888,55555555,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(1,2,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,2,77777777,11111111,'asdasda',NULL,NOW(),'recibido',11111111),
(1,3,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,3,77777777,11111111,'asdasda',NULL,NOW(),'recibido',11111111),
(1,4,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,4,77777777,11111111,'asdasda',NULL,NOW(),'recibido',11111111);

INSERT INTO Sala (idGrupo,idMateria,docenteCi,anfitrion,resumen,creacion,isDone) VALUES
(1,1,77777777,11111111,"se hablo del prat 1 de polinomios",DATE(DATE_SUB(NOW(), INTERVAL -6 DAY)),false),

(2,6,77777777,77777777,"revisamos el ejercicio 10 de prat 2",DATE(DATE_SUB(NOW(), INTERVAL -16 DAY)),true),
(2,6,77777777,77777777,"revision primer escrito", DATE(DATE_SUB(NOW(), INTERVAL -11 DAY)),true),
(2,6,77777777,77777777,"demostracion rufini", DATE(DATE_SUB(NOW(), INTERVAL -11 DAY)),true),

(3,11,77777777,77777777,"E.A y R.G de 1/x", DATE(DATE_SUB(NOW(), INTERVAL -10 DAY)),true),
(3,11,77777777,77777777,"dudas prat1", DATE(DATE_SUB(NOW(), INTERVAL -9 DAY)),true),
(3,11,77777777,77777777,"dudas prat2", DATE(DATE_SUB(NOW(), INTERVAL -8 DAY)),false),

(1,3,88888888,88888888,"intro a java", DATE(DATE_SUB(NOW(), INTERVAL -7 DAY)),true),
(1,3,88888888,88888888,"intro de programacion orientada a objetos", DATE(DATE_SUB(NOW(), INTERVAL -6 DAY)),true),
(1,3,88888888,88888888,"estructuras repetitivas", DATE(DATE_SUB(NOW(), INTERVAL -5 DAY)),true),
(1,3,88888888,88888888,"condicionales", DATE(DATE_SUB(NOW(), INTERVAL -4 DAY)),false),

(3,12,88888888,88888888,"INTRO A C#", DATE(DATE_SUB(NOW(), INTERVAL -3 DAY)),true),
(3,12,88888888,88888888,"Capas de datos", DATE(DATE_SUB(NOW(), INTERVAL -2 DAY)),true),
(3,12,88888888,88888888,"calculadora en c#", DATE(DATE_SUB(NOW(), INTERVAL -1 DAY)),true),
(3,12,88888888,88888888,"ejemplo de conexion a base de datos c#", DATE(DATE_SUB(NOW(), INTERVAL -5 HOUR)),false);

-- mirar a alumnoTieneGrupo y docentedictaGM
INSERT INTO Sala_Members (idSala,ci) VALUES 
(1,11111111),(1,33333333),(1,44444444),(1,66666666),(1,77777777),

(2,11111111),(2,22222222),(2,44444444),(2,77777777),

(3,11111111),(3,22222222),(3,77777777),

(4,11111111),(4,22222222),(4,77777777),

(5,22222222),(5,66666666),(5,77777777),

(6,22222222),(6,66666666),(6,77777777),

(7,22222222),(7,66666666),(7,77777777),

(8,11111111),(8,33333333),(8,44444444),(8,66666666),(8,88888888),

(9,11111111),(9,33333333),(9,44444444),(9,66666666),(9,88888888),

(10,11111111),(10,33333333),(10,44444444),(10,66666666),(10,88888888),

(11,11111111),(11,33333333),(11,44444444),(11,66666666),(11,88888888),

(12,22222222),(12,66666666),(12,88888888),

(13,22222222),(13,66666666),(13,88888888),

(14,22222222),(14,66666666),(14,88888888),

(15,22222222),(15,66666666),(15,88888888);

INSERT INTO Sala_mensaje (idSala,autorCi,contenido,fechaHora) VALUES 
(1,11111111,"Hola podemos discutir lo del prat 1?", DATE(DATE_SUB(NOW(), INTERVAL -5 DAY))),
(1,77777777,"sii pregunta nomas y yo les contesto ",  DATE(DATE_SUB(NOW(), INTERVAL -2 DAY))),

(2,77777777,"buenas chicoos", DATE(DATE_SUB(NOW(), INTERVAL -15 DAY))),
(2,77777777,"Hoy vamos a hacer x cosa", DATE(DATE_SUB(NOW(), INTERVAL -10 DAY))),

(3,77777777,"hola son el grupo 3ro?", DATE(DATE_SUB(NOW(), INTERVAL -4 DAY))),

(4,77777777,"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", DATE(DATE_SUB(NOW(), INTERVAL -10 DAY))),
(4,77777777,"Lorem ipsum dolor sit amet, consectetur adipiscing elgna aliqua.", DATE(DATE_SUB(NOW(), INTERVAL -5 DAY)))
/*
,(5,77777777,"Hola podemos discutir lo del prat 1?", curdate()-10day),
(5,77777777,"sii pregunta nomas y yo les contesto ", curdate()-5day),

(6,77777777,"Hola podemos discutir lo del prat 1?", curdate()-10day),
(6,77777777,"sii pregunta nomas y yo les contesto ", curdate()-5day),

(7,77777777,"Hola podemos discutir lo del prat 1?", curdate()-10day),
(7,77777777,"sii pregunta nomas y yo les contesto ", curdate()-5day),

(8,11111111,"Hola podemos discutir lo del prat 1?", curdate()-10day),
(8,77777777,"sii pregunta nomas y yo les contesto ", curdate()-5day),

(9,11111111,"Hola podemos discutir lo del prat 1?", curdate()-10day),
(9,77777777,"sii pregunta nomas y yo les contesto ", curdate()-5day),

(10,11111111,"Hola podemos discutir lo del prat 1?", curdate()-10day),
(10,77777777,"sii pregunta nomas y yo les contesto ", curdate()-5day),

(11,11111111,"Hola podemos discutir lo del prat 1?", curdate()-10day),
(11,77777777,"sii pregunta nomas y yo les contesto ", curdate()-5day),

(12,11111111,"Hola podemos discutir lo del prat 1?", curdate()-10day),
(12,77777777,"sii pregunta nomas y yo les contesto ", curdate()-5day),

(13,11111111,"Hola podemos discutir lo del prat 1?", curdate()-10day),
(13,77777777,"sii pregunta nomas y yo les contesto ", curdate()-5day),

(14,11111111,"Hola podemos discutir lo del prat 1?", curdate()-10day),
(14,77777777,"sii pregunta nomas y yo les contesto ", curdate()-5day),

(15,11111111,"Hola podemos discutir lo del prat 1?", curdate()-10day),
(15,77777777,"sii pregunta nomas y yo les contesto ", curdate()-5day),
*/
;
