DROP DATABASE IF EXISTS ultimaDB;
CREATE DATABASE ultimaDB;
USE ultimaDB;

CREATE TABLE Grupo (
idGrupo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombreGrupo VARCHAR(10) NOT NULL
);
CREATE TABLE Materia(
idMateria INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombreMateria VARCHAR(25) NOT NULL
);
CREATE TABLE Grupo_tiene_Materia(
idGrupo INT  NOT NULL,
idMateria INT  NOT NULL,
PRIMARY KEY(idGrupo,idMateria),
FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo),
FOREIGN KEY (idMateria) REFERENCES Materia(idMateria)
); 
CREATE TABLE Orientacion(
idOrientacion INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombreOrientacion VARCHAR(25) NOT NULL
);
CREATE TABLE Orientacion_tiene_G_M (
idOrientacion INT NOT NULL,
idGrupo INT NOT NULL,
idMateria INT NOT NULL,
PRIMARY KEY (idOrientacion,idGrupo,idMateria),
FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo),
FOREIGN KEY (idMateria) REFERENCES Materia(idMateria),
FOREIGN KEY (idOrientacion) REFERENCES Orientacion(idOrientacion)
);
CREATE TABLE Persona (
    ci INT(8) PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    clave VARCHAR(15) NOT NULL,
    isDeleted BOOL NOT NULL,
    foto BLOB  NULL,
    avatar BLOB  NULL,
    enLinea BOOL NOT NULL
);
CREATE TABLE Administrador (
    ci INT NOT NULL,
    idAdmin INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (idAdmin , ci),
    FOREIGN KEY (ci)
        REFERENCES persona (ci)
);
CREATE TABLE Docente (
ci INT NOT NULL,
    idDocente INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (idDocente,ci),
    FOREIGN KEY (ci)
        REFERENCES Persona (ci)
);
CREATE TABLE Docente_dicta_G_M (
idGrupo INT NOT NULL,
idMateria INT NOT NULL,
docenteCi INT NOT NULL,
PRIMARY KEY (idGrupo,idMateria,docenteCi),
FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo),
FOREIGN KEY (idMateria) REFERENCES Materia(idMateria),
FOREIGN KEY (docenteCi) REFERENCES Docente (ci)
);
CREATE TABLE Docente_Conexion (
    docenteCi INT NOT NULL ,
    FechaConexion DATETIME NOT NULL,
    FOREIGN KEY (docenteCi) REFERENCES Docente (ci) 
);
CREATE TABLE Docente_Desconexion (
    docenteCi INT NOT NULL,
    FechaDesconexion DATETIME NOT NULL,
    FOREIGN KEY (docenteCi)
        REFERENCES Docente (ci)
);

CREATE TABLE Alumno (
  ci INT NOT NULL,
    idAlumno INT NOT NULL AUTO_INCREMENT,
    apodo VARCHAR(20) UNIQUE,
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
    idConsultaPrivada INT NOT NULL AUTO_INCREMENT,
    docenteCi INT,
    alumnoCi INT,
    titulo VARCHAR(50) NOT NULL,
    cpStatus ENUM('pendiente', 'resuelta') NOT NULL,
    cpFechaHora DATETIME NOT NULL,
    PRIMARY KEY (idConsultaPrivada, docenteCi, alumnoCi),
    FOREIGN KEY (docenteCi)
        REFERENCES Docente (ci),
    FOREIGN KEY (alumnoCi)
        REFERENCES Alumno (ci)
);
CREATE TABLE CP_mensaje(
idCp_mensaje INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
idConsultaPrivada INT NOT NULL,
contenido VARCHAR(1000) NOT NULL,
attachment MEDIUMBLOB,
cp_mensajeFechaHora DATETIME NOT NULL,
cp_mensajeStatus ENUM('recibido','leido'),
FOREIGN KEY (idConsultaPrivada) REFERENCES ConsultaPrivada (idConsultaPrivada) 
);

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

INSERT INTO Orientacion_tiene_G_M VALUES
(1,3,11),(1,3,12),(1,3,13),(1,3,14),
(2,4,11),(2,4,12),(2,4,13),(2,4,15),
(3,5,11),(3,5,12),(3,5,13),(3,5,16);

INSERT INTO Persona VALUES
(11111111,'penelope','cruz','clave1',0,NULL,NULL, TRUE),
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
(2,6,77777777),
(3,11,77777777),
(1,3,88888888),
(3,11,88888888);

INSERT INTO Alumno (ci,apodo) VALUES
(11111111,'fefito'),
(22222222,'pRed'),
(33333333,'cRock'),
(44444444,'Lexy'),
(55555555,'pittt'),
(66666666,'pig');

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

INSERT INTO Docente_Conexion(docenteCi,FechaConexion) VALUES
(77777777,NOW()),
(88888888,NOW());

INSERT INTO Docente_Desconexion(docenteCi,FechaDesconexion) VALUES
(77777777,NOW() + INTERVAL 1 DAY),
(88888888,NOW() + INTERVAL 2 HOUR);

INSERT INTO ConsultaPrivada(docenteCi,alumnoCi,titulo,cpStatus,cpFechaHora) VALUES
(77777777,11111111,'1 consulta','pendiente',NOW()),
(77777777,22222222,'2 consulta','pendiente',NOW()),
(77777777,33333333,'3 consulta','pendiente',NOW()),
(77777777,44444444,'4 consulta','pendiente',NOW()),
(88888888,11111111,'5 consulta','pendiente',NOW()),
(88888888,33333333,'6 consulta','pendiente',NOW()),
(88888888,55555555,'7 consulta','pendiente',NOW());

INSERT INTO CP_Mensaje (idConsultaPrivada,contenido,attachment,cp_mensajeFechaHora,cp_mensajeStatus)
VALUES (1,'asdasda',NULL,NOW(),'recibido'),
(2,'asderererwasda',NULL,NOW(),'leido'),
(3,'rrrrr',NULL,NOW(),'leido'),
(2,'asdasda',NULL,NOW(),'recibido'),
(3,'asdasda',NULL,NOW(),'recibido'),
(6,'asdasda',NULL,NOW(),'recibido'),
(3,'asdasda',NULL,NOW(),'recibido'),
(4,'fsdfsdfsdfsd',NULL,NOW(),'leido'),
(5,'gfgfdgdf',NULL,NOW(),'leido'),
(6,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido'),
(7,'hghghghghghghghgh',NULL,NOW(),'recibido');
