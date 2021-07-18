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
CREATE TABLE Orientacion_tiene_Grupo (
idOrientacion INT NOT NULL,
idGrupo INT NOT NULL,
PRIMARY KEY (idGrupo),
FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo),
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
Create table PersonaTemp(
ci INT(8) PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    clave VARCHAR(15) NOT NULL,
    foto BLOB  NULL,
    avatar BLOB  NULL,
    tipoUser enum('alumno','docente','admin'));

CREATE TABLE Docente_dicta_G_M (
idGrupo INT NOT NULL,
idMateria INT NOT NULL,
docenteCi INT,
PRIMARY KEY (idGrupo,idMateria),
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
        REFERENCES Alumno (ci)
);
CREATE TABLE CP_mensaje(
idCp_mensaje INT NOT NULL,
idConsultaPrivada INT NOT NULL,
ciAlumno INT NOT NULL,
ciDocente INT NOT NULL,
contenido VARCHAR(1000) NOT NULL,
attachment MEDIUMBLOB,
cp_mensajeFechaHora DATETIME NOT NULL,
cp_mensajeStatus ENUM('recibido','leido'),
ciDestinatario INT NOT NULL,
PRIMARY KEY(idCp_mensaje,idConsultaPrivada,ciAlumno,ciDocente),
FOREIGN KEY (idConsultaPrivada) REFERENCES ConsultaPrivada (idConsultaPrivada),
FOREIGN KEY (ciAlumno) REFERENCES Alumno (ci),
FOREIGN KEY (ciDocente) REFERENCES Docente (ci),
FOREIGN KEY (ciDestinatario) REFERENCES Persona (ci)

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

INSERT INTO Orientacion_tiene_Grupo VALUES
(1,3),
(2,4),
(3,5);

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
(1,2,null),
(1,4,null),
(1,5,null),
(2,6,77777777),
(2,7,null),
(2,8,null),
(2,9,null),
(2,10,null),
(3,13,null),
(3,14,null),
(4,11,null),
(4,12,null),
(4,13,null),
(4,15,null),
(5,11,null),
(5,12,null),
(5,13,null),
(5,16,null),
(3,11,77777777),
(1,3,88888888),
(3,12,88888888);

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

INSERT INTO ConsultaPrivada(idConsultaPrivada,docenteCi,alumnoCi,titulo,cpStatus,cpFechaHora) VALUES
(1,77777777,11111111,'1 consulta','pendiente',NOW()),
(1,77777777,22222222,'1 consulta','pendiente',NOW()),
(1,77777777,33333333,'1 consulta','pendiente',NOW()),
(1,77777777,44444444,'1 consulta','pendiente',NOW()),
(1,88888888,11111111,'1 consulta','pendiente',NOW()),
(1,88888888,33333333,'1 consulta','pendiente',NOW()),
(1,88888888,55555555,'1 consulta','pendiente',NOW()),
(2,77777777,11111111,'1 consulta','pendiente',NOW()),
(3,77777777,11111111,'3 consulta','pendiente',NOW()),
(4,77777777,11111111,'4 consulta','pendiente',NOW());


INSERT INTO CP_Mensaje (idCp_mensaje,idConsultaPrivada,ciDocente,ciAlumno,contenido,attachment,cp_mensajeFechaHora,cp_mensajeStatus, ciDestinatario)
VALUES 
(1,1,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,1,77777777,11111111,'asderererwasda',NULL,NOW(),'leido',11111111),
(3,1,77777777,11111111,'rrrrr',NULL,NOW(),'leido',77777777),
(1,1,77777777,22222222,'asdasda',NULL,NOW(),'recibido',77777777),
(2,1,77777777,22222222,'asdasda',NULL,NOW(),'recibido',22222222),
(3,1,77777777,22222222,'asdasda',NULL,NOW(),'recibido',77777777),
(4,1,77777777,22222222,'asdasda',NULL,NOW(),'recibido',22222222),
(1,1,77777777,33333333,'fsdfsdfsdfsd',NULL,NOW(),'leido',77777777),
(2,1,77777777,33333333,'gfgfdgdf',NULL,NOW(),'leido',77777777),
(1,1,77777777,44444444,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',77777777),
(2,1,77777777,44444444,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',44444444),
(3,1,77777777,44444444,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',44444444),
(4,1,77777777,44444444,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',77777777),
(5,1,77777777,44444444,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',44444444),
(6,1,77777777,44444444,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',77777777),
(1,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(2,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',11111111),
(3,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(4,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',11111111),
(5,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(1,1,88888888,33333333,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(2,1,88888888,33333333,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',33333333),
(6,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(7,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',11111111),
(8,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(1,1,88888888,55555555,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(1,2,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,2,77777777,11111111,'asdasda',NULL,NOW(),'recibido',11111111),
(3,2,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(1,3,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,3,77777777,11111111,'asdasda',NULL,NOW(),'recibido',11111111),
(1,4,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,4,77777777,11111111,'asdasda',NULL,NOW(),'recibido',11111111),
(4,2,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777);

/*

select  dgm.idGrupo,dgm.idMateria,g.nombregrupo, m.NombreMateria  from docente_dicta_G_M dgm,Grupo g,Materia m 
where dgm.docenteCi is null and dgm.idMateria=m.idMateria and g.idGrupo=dgm.idGrupo;
 
UPDATE Docente_Dicta_G_M SET docenteCi=88888888 WHERE idGrupo=2 AND idMateria=7;

INSERT INTO Docente_Dicta_G_M (docenteCi,idGrupo,idMateria) VALUES (88888888,5,16);

SELECT a.ci, p.clave, p.nombre, p.apellido FROM Alumno a,Persona p WHERE p.ci=a.ci AND a.ci=@user AND p.clave=@pass AND P.isDeleted=false;

UPDATE Persona SET clave=@clave, isDeleted=@isDeleted, foto=@foto, avatar=@avatar, enLinea=@enLinea WHERE ci=@ci

UPDATE Persona SET isDeleted=true WHERE ci=11111111;


select * from Alumno;
select * from Alumno_tiene_Grupo;
select * from Administrador;
select * from Docente;
select * from Persona;
SELECT * FROM Docente_dicta_G_M dgm;
SELECT * FROM ConsultaPrivada;
SELECT * FROM CP_Mensaje;

SELECT * FROM Table1 WHERE id NOT IN (SELECT id FROM Table2)

SELECT * FROM Grupo_tiene_Materia WHERE idGrupo,idMateria NOT IN (SELECT idGrupo,idMateria FROM Docente_Dicta_G_M);

SELECT * FROM Grupo_Tiene_Materia WHERE idGrupo NOT IN (SELECT idGrupo FROM Docente_Dicta_G_M dgm);

SELECT * FROM Grupo_Tiene_Materia WHERE idMateria NOT IN (SELECT idMateria FROM Docente_Dicta_G_M dgm);

select distinct gm.idGrupo,gm.idMateria from grupo_tiene_materia gm inner join docente_dicta_G_M dgm on 
gm.idGrupo except (SELECT idGrupo FROM Docente_Dicta_G_M ) 
AND gm.idMateria except (SELECT idMateria FROM Docente_Dicta_G_M );

******trae los nombres  y ids de los grupos y materias en la tabla grupo_tiene_materia
SELECT gm.idGrupo, gm.idMateria,g.nombreGrupo,m.nombreMateria FROM Grupo_Tiene_Materia gm, grupo g, materia m
WHERE gm.idGrupo=g.idGrupo AND gm.idMateria=m.idMateria;

*****queria que me traiga los nombres y id's de los grupos/materias que aun no estan asignados a un docente en 
*****docente_dicta_G_M
SELECT gm.idGrupo, gm.idMateria,g.nombreGrupo,m.nombreMateria FROM Grupo_Tiene_Materia gm, grupo g, materia m, docente_dicta_G_M d
WHERE gm.idGrupo=g.idGrupo AND gm.idMateria=m.idMateria AND NOT (d.idGrupo=d.idGrupo AND d.idMateria=m.idMateria);



SELECT DISTINCT cp.idConsultaPrivada, m.idCp_mensaje, cp.docenteCi, cp.alumnoCi, cp.titulo, cp.cpStatus, cp.cpFechaHora, m.ciDestinatario FROM ConsultaPrivada cp 
inner join CP_Mensaje m on cp.idConsultaPrivada=m.idConsultaPrivada AND cp.docenteCi=m.ciDestinatario;

******trae nombres y ids de materias/grupos, de docentes la ci y nombre. De los datos en docente_dicta_G_M
SELECT g.nombreGrupo, m.nombreMateria , p.nombre AS "nombre de docente", p.apellido AS "apellido de docente", p.ci ,g.idGrupo, m.idMateria
FROM Docente_dicta_G_M dgm, materia m, Persona p, grupo g
WHERE dgm.idMateria=m.idMateria AND p.ci=dgm.docenteCi AND dgm.idGrupo=g.idGrupo;

SELECT * FROM CP_Mensaje cpm WHERE cpm.ciDocente=avalue AND cpm.ciAlumno=avalue AND cpm.idConsultaPrivada=avaluuue ; 

/*pass ciAlumno or ciDocente as parametersbut not both and the idofConsulta  
returns all the msgs of a person knowing the idconsulta and person ci

SELECT cpm.idConsultaPrivada, cpm.ciAlumno, cpm.ciDocente, cpm.idCp_mensaje, cpm.contenido, cpm.attachment, cpm.cp_mensajeFechaHora, cpm.cp_mensajeStatus
FROM CP_Mensaje cpm 
WHERE cpm.idConsultaPrivada=1 AND cpm.ciDocente=77777777 AND cpm.ciAlumno=11111111;

SELECT cpm.idConsultaPrivada, cpm.ciAlumno, cpm.ciDocente, cpm.idCp_mensaje, cpm.contenido, cpm.attachment, cpm.cp_mensajeFechaHora, cpm.cp_mensajeStatus
FROM CP_Mensaje cpm;

SELECT MAX(idConsultaPrivada) FROM ConsultaPrivada WHERE DocenteCi=88888888 AND alumnoCi=11111111;

SELECT  m.nombreMateria,g.nombreGrupo FROM Materia m ,grupo g, grupo_tiene_Materia gm ,Orientacion_tiene_grupo og 
WHERE og.idGrupo=gm.idGrupo AND m.idMateria=gm.idMateria AND gm.idGrupo=g.idGrupo;
*/
