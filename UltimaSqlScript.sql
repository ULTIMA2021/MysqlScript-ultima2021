CREATE DATABASE  IF NOT EXISTS `ultimadb` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `ultimadb`;
-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: ultimadb
-- ------------------------------------------------------
-- Server version	5.7.35-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administrador`
--

DROP TABLE IF EXISTS `administrador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrador` (
  `ci` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ci`),
  UNIQUE KEY `ci` (`ci`),
  CONSTRAINT `administrador_ibfk_1` FOREIGN KEY (`ci`) REFERENCES `persona` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrador`
--

LOCK TABLES `administrador` WRITE;
/*!40000 ALTER TABLE `administrador` DISABLE KEYS */;
INSERT INTO `administrador` VALUES ('99999999');
/*!40000 ALTER TABLE `administrador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alumno`
--

DROP TABLE IF EXISTS `alumno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alumno` (
  `ci` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apodo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ci`),
  UNIQUE KEY `ci` (`ci`),
  UNIQUE KEY `apodo` (`apodo`),
  KEY `ci_2` (`ci`),
  CONSTRAINT `alumno_ibfk_1` FOREIGN KEY (`ci`) REFERENCES `persona` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumno`
--

LOCK TABLES `alumno` WRITE;
/*!40000 ALTER TABLE `alumno` DISABLE KEYS */;
INSERT INTO `alumno` VALUES ('66666666','ahumer'),('33333333','cRock'),('11111111','cruzzz'),('44444444','Lexy'),('55555555','pittt'),('22222222','pRed');
/*!40000 ALTER TABLE `alumno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alumno_tiene_grupo`
--

DROP TABLE IF EXISTS `alumno_tiene_grupo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alumno_tiene_grupo` (
  `alumnoCi` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idGrupo` int(11) NOT NULL,
  PRIMARY KEY (`alumnoCi`,`idGrupo`),
  KEY `alumnoCi` (`alumnoCi`,`idGrupo`),
  KEY `idGrupo` (`idGrupo`),
  CONSTRAINT `alumno_tiene_grupo_ibfk_1` FOREIGN KEY (`alumnoCi`) REFERENCES `alumno` (`ci`),
  CONSTRAINT `alumno_tiene_grupo_ibfk_2` FOREIGN KEY (`idGrupo`) REFERENCES `grupo` (`idGrupo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumno_tiene_grupo`
--

LOCK TABLES `alumno_tiene_grupo` WRITE;
/*!40000 ALTER TABLE `alumno_tiene_grupo` DISABLE KEYS */;
INSERT INTO `alumno_tiene_grupo` VALUES ('11111111',1),('33333333',1),('44444444',1),('66666666',1),('11111111',2),('22222222',2),('44444444',2),('22222222',3),('66666666',3),('55555555',5);
/*!40000 ALTER TABLE `alumno_tiene_grupo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alumnotemp`
--

DROP TABLE IF EXISTS `alumnotemp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alumnotemp` (
  `ci` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `clave` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto` blob,
  `avatar` blob,
  `apodo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `grupos` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ci`),
  KEY `ci` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumnotemp`
--

LOCK TABLES `alumnotemp` WRITE;
/*!40000 ALTER TABLE `alumnotemp` DISABLE KEYS */;
/*!40000 ALTER TABLE `alumnotemp` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER checkDataNewAlumno BEFORE INSERT ON AlumnoTemp 
FOR EACH ROW
BEGIN
SET @charType= (NEW.nombre REGEXP "[^a-z^A-Z]") + (NEW.apellido REGEXP "[^a-z^A-Z]") + (NEW.ci REGEXP "[^0-9]");
SET @lengthCi= LENGTH(NEW.ci);
IF @chartype> 0 OR @lengthCi !=8 THEN 
	SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="invalid characters";
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `consultaprivada`
--

DROP TABLE IF EXISTS `consultaprivada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consultaprivada` (
  `idConsultaPrivada` int(11) NOT NULL,
  `docenteCi` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alumnoCi` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `titulo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cpStatus` enum('pendiente','resuelta') COLLATE utf8mb4_unicode_ci NOT NULL,
  `cpFechaHora` datetime NOT NULL,
  PRIMARY KEY (`idConsultaPrivada`,`docenteCi`,`alumnoCi`),
  KEY `idConsultaPrivada` (`idConsultaPrivada`,`docenteCi`,`alumnoCi`),
  KEY `docenteCi` (`docenteCi`),
  KEY `alumnoCi` (`alumnoCi`),
  CONSTRAINT `consultaprivada_ibfk_1` FOREIGN KEY (`docenteCi`) REFERENCES `docente` (`ci`),
  CONSTRAINT `consultaprivada_ibfk_2` FOREIGN KEY (`alumnoCi`) REFERENCES `alumno` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultaprivada`
--

LOCK TABLES `consultaprivada` WRITE;
/*!40000 ALTER TABLE `consultaprivada` DISABLE KEYS */;
INSERT INTO `consultaprivada` VALUES (1,'77777777','11111111','hola','pendiente','2021-09-10 09:32:14'),(1,'77777777','22222222','profe hello','pendiente','2021-09-10 09:32:14'),(1,'77777777','33333333','soy tu alumno','pendiente','2021-09-10 09:32:14'),(1,'77777777','44444444','prat1','pendiente','2021-09-10 09:32:14'),(1,'88888888','11111111','prat1 ej3','pendiente','2021-09-10 09:32:14'),(1,'88888888','33333333','prat4','pendiente','2021-09-10 09:32:14'),(1,'88888888','55555555','prat3','pendiente','2021-09-10 09:32:14'),(2,'77777777','11111111','HOLAAAA','pendiente','2021-09-10 09:32:14'),(3,'77777777','11111111','todobien?','pendiente','2021-09-10 09:32:14'),(4,'77777777','11111111','faltas hoy?','pendiente','2021-09-10 09:32:14'),(5,'77777777','11111111','jelly','pendiente','2021-09-10 09:32:14'),(6,'77777777','11111111','hola','resuelta','2021-09-10 09:32:14');
/*!40000 ALTER TABLE `consultaprivada` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cp_mensaje`
--

DROP TABLE IF EXISTS `cp_mensaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cp_mensaje` (
  `idCp_mensaje` int(11) NOT NULL,
  `idConsultaPrivada` int(11) NOT NULL,
  `ciAlumno` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ciDocente` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contenido` varchar(5000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachment` mediumblob,
  `cp_mensajeFechaHora` datetime NOT NULL,
  `cp_mensajeStatus` enum('recibido','leido') COLLATE utf8mb4_unicode_ci NOT NULL,
  `ciDestinatario` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idCp_mensaje`,`idConsultaPrivada`,`ciAlumno`,`ciDocente`),
  KEY `idCp_mensaje` (`idCp_mensaje`,`idConsultaPrivada`,`ciAlumno`,`ciDocente`),
  KEY `idConsultaPrivada` (`idConsultaPrivada`),
  KEY `ciAlumno` (`ciAlumno`),
  KEY `ciDocente` (`ciDocente`),
  KEY `ciDestinatario` (`ciDestinatario`),
  CONSTRAINT `cp_mensaje_ibfk_1` FOREIGN KEY (`idConsultaPrivada`) REFERENCES `consultaprivada` (`idConsultaPrivada`),
  CONSTRAINT `cp_mensaje_ibfk_2` FOREIGN KEY (`ciAlumno`) REFERENCES `alumno` (`ci`),
  CONSTRAINT `cp_mensaje_ibfk_3` FOREIGN KEY (`ciDocente`) REFERENCES `docente` (`ci`),
  CONSTRAINT `cp_mensaje_ibfk_4` FOREIGN KEY (`ciDestinatario`) REFERENCES `persona` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cp_mensaje`
--

LOCK TABLES `cp_mensaje` WRITE;
/*!40000 ALTER TABLE `cp_mensaje` DISABLE KEYS */;
INSERT INTO `cp_mensaje` VALUES (1,1,'11111111','77777777','this is a test, search for my words',NULL,'2021-09-10 09:32:14','recibido','77777777'),(1,1,'11111111','88888888','sdfsdsdssdsdsdsdsd',NULL,'2021-09-10 09:32:14','leido','88888888'),(1,1,'22222222','77777777','go to the city',NULL,'2021-09-10 09:32:14','recibido','77777777'),(1,1,'33333333','77777777','give up',NULL,'2021-09-10 09:32:14','leido','77777777'),(1,1,'33333333','88888888','sdfsdsdssdsdsdsdsd',NULL,'2021-09-10 09:32:14','leido','88888888'),(1,1,'44444444','77777777','nope',NULL,'2021-09-10 09:32:14','leido','77777777'),(1,1,'55555555','88888888','sdfsdsdssdsdsdsdsd',NULL,'2021-09-10 09:32:14','leido','88888888'),(1,2,'11111111','77777777','asdasda',NULL,'2021-09-10 09:32:14','recibido','77777777'),(1,3,'11111111','77777777','cat',NULL,'2021-09-10 09:32:14','recibido','77777777'),(1,4,'11111111','77777777','jelly welly',NULL,'2021-09-10 09:32:14','recibido','77777777'),(1,5,'11111111','77777777','jelly',NULL,'2021-09-10 09:32:14','recibido','77777777'),(1,6,'11111111','77777777','hola',NULL,'2021-09-10 09:32:14','recibido','77777777'),(2,1,'11111111','77777777','jelly doughnut',NULL,'2021-09-10 09:32:14','leido','11111111'),(2,1,'11111111','88888888','sdfsdsdssdsdsdsdsd',NULL,'2021-09-10 09:32:14','leido','11111111'),(2,1,'22222222','77777777','live like a demon',NULL,'2021-09-10 09:32:14','recibido','22222222'),(2,1,'33333333','77777777','check the jelly',NULL,'2021-09-10 09:32:14','leido','77777777'),(2,1,'33333333','88888888','sdfsdsdssdsdsdsdsd',NULL,'2021-09-10 09:32:14','leido','33333333'),(2,1,'44444444','77777777','sdfsdsdssdsdsdsdsd',NULL,'2021-09-10 09:32:14','leido','44444444'),(2,2,'11111111','77777777','asdasda',NULL,'2021-09-10 09:32:14','recibido','11111111'),(2,3,'11111111','77777777','asdasda',NULL,'2021-09-10 09:32:14','recibido','11111111'),(2,4,'11111111','77777777','blah blah',NULL,'2021-09-10 09:32:14','recibido','11111111');
/*!40000 ALTER TABLE `cp_mensaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `docente`
--

DROP TABLE IF EXISTS `docente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docente` (
  `ci` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ci`),
  UNIQUE KEY `ci` (`ci`),
  KEY `ci_2` (`ci`),
  CONSTRAINT `docente_ibfk_1` FOREIGN KEY (`ci`) REFERENCES `persona` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docente`
--

LOCK TABLES `docente` WRITE;
/*!40000 ALTER TABLE `docente` DISABLE KEYS */;
INSERT INTO `docente` VALUES ('77777777'),('88888888');
/*!40000 ALTER TABLE `docente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `docente_dicta_g_m`
--

DROP TABLE IF EXISTS `docente_dicta_g_m`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docente_dicta_g_m` (
  `idGrupo` int(11) NOT NULL,
  `idMateria` int(11) NOT NULL,
  `docenteCi` char(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idGrupo`,`idMateria`),
  KEY `docenteCi` (`docenteCi`),
  KEY `idMateria` (`idMateria`),
  CONSTRAINT `docente_dicta_g_m_ibfk_1` FOREIGN KEY (`idGrupo`) REFERENCES `grupo` (`idGrupo`),
  CONSTRAINT `docente_dicta_g_m_ibfk_2` FOREIGN KEY (`idMateria`) REFERENCES `materia` (`idMateria`),
  CONSTRAINT `docente_dicta_g_m_ibfk_3` FOREIGN KEY (`docenteCi`) REFERENCES `docente` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docente_dicta_g_m`
--

LOCK TABLES `docente_dicta_g_m` WRITE;
/*!40000 ALTER TABLE `docente_dicta_g_m` DISABLE KEYS */;
INSERT INTO `docente_dicta_g_m` VALUES (1,2,NULL),(1,4,NULL),(1,5,NULL),(2,7,NULL),(2,8,NULL),(2,9,NULL),(2,10,NULL),(3,13,NULL),(3,14,NULL),(4,11,NULL),(4,12,NULL),(4,13,NULL),(4,15,NULL),(5,11,NULL),(5,12,NULL),(5,13,NULL),(5,16,NULL),(1,1,'77777777'),(2,6,'77777777'),(3,11,'77777777'),(1,3,'88888888'),(3,12,'88888888');
/*!40000 ALTER TABLE `docente_dicta_g_m` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grupo`
--

DROP TABLE IF EXISTS `grupo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupo` (
  `idGrupo` int(11) NOT NULL AUTO_INCREMENT,
  `nombreGrupo` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idGrupo`),
  KEY `idGrupo` (`idGrupo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grupo`
--

LOCK TABLES `grupo` WRITE;
/*!40000 ALTER TABLE `grupo` DISABLE KEYS */;
INSERT INTO `grupo` VALUES (1,'1BB'),(2,'2BB'),(3,'3BB'),(4,'3BA'),(5,'3BC');
/*!40000 ALTER TABLE `grupo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grupo_tiene_materia`
--

DROP TABLE IF EXISTS `grupo_tiene_materia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupo_tiene_materia` (
  `idGrupo` int(11) NOT NULL,
  `idMateria` int(11) NOT NULL,
  PRIMARY KEY (`idGrupo`,`idMateria`),
  KEY `idGrupo` (`idGrupo`,`idMateria`),
  KEY `idMateria` (`idMateria`),
  CONSTRAINT `grupo_tiene_materia_ibfk_1` FOREIGN KEY (`idGrupo`) REFERENCES `grupo` (`idGrupo`),
  CONSTRAINT `grupo_tiene_materia_ibfk_2` FOREIGN KEY (`idMateria`) REFERENCES `materia` (`idMateria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grupo_tiene_materia`
--

LOCK TABLES `grupo_tiene_materia` WRITE;
/*!40000 ALTER TABLE `grupo_tiene_materia` DISABLE KEYS */;
INSERT INTO `grupo_tiene_materia` VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(2,6),(2,7),(2,8),(2,9),(2,10),(3,11),(4,11),(5,11),(3,12),(4,12),(5,12),(3,13),(4,13),(5,13),(3,14),(4,15),(5,16);
/*!40000 ALTER TABLE `grupo_tiene_materia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horario`
--

DROP TABLE IF EXISTS `horario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horario` (
  `ci` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dia` tinyint(1) unsigned DEFAULT NULL,
  `timeStart` smallint(4) unsigned DEFAULT NULL,
  `timeEnd` smallint(4) unsigned DEFAULT NULL,
  KEY `ci` (`ci`),
  CONSTRAINT `horario_ibfk_1` FOREIGN KEY (`ci`) REFERENCES `docente` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horario`
--

LOCK TABLES `horario` WRITE;
/*!40000 ALTER TABLE `horario` DISABLE KEYS */;
/*!40000 ALTER TABLE `horario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materia`
--

DROP TABLE IF EXISTS `materia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `materia` (
  `idMateria` int(11) NOT NULL AUTO_INCREMENT,
  `nombreMateria` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idMateria`),
  KEY `idMateria` (`idMateria`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materia`
--

LOCK TABLES `materia` WRITE;
/*!40000 ALTER TABLE `materia` DISABLE KEYS */;
INSERT INTO `materia` VALUES (1,'mat1'),(2,'geo1'),(3,'prog1'),(4,'SO1'),(5,'taller1'),(6,'mat2'),(7,'geo2'),(8,'prog2'),(9,'SO2'),(10,'taller2'),(11,'mat3'),(12,'prog3'),(13,'SO3'),(14,'redes y soporte'),(15,'disenio web'),(16,'unity');
/*!40000 ALTER TABLE `materia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orientacion`
--

DROP TABLE IF EXISTS `orientacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orientacion` (
  `idOrientacion` int(11) NOT NULL AUTO_INCREMENT,
  `nombreOrientacion` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idOrientacion`),
  KEY `idOrientacion` (`idOrientacion`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orientacion`
--

LOCK TABLES `orientacion` WRITE;
/*!40000 ALTER TABLE `orientacion` DISABLE KEYS */;
INSERT INTO `orientacion` VALUES (1,'desarollo y soporte'),(2,'disenio web'),(3,'disenio de juegos');
/*!40000 ALTER TABLE `orientacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orientacion_tiene_grupo`
--

DROP TABLE IF EXISTS `orientacion_tiene_grupo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orientacion_tiene_grupo` (
  `idOrientacion` int(11) NOT NULL,
  `idGrupo` int(11) NOT NULL,
  PRIMARY KEY (`idGrupo`),
  KEY `idGrupo` (`idGrupo`),
  KEY `idOrientacion` (`idOrientacion`),
  CONSTRAINT `orientacion_tiene_grupo_ibfk_1` FOREIGN KEY (`idGrupo`) REFERENCES `grupo` (`idGrupo`),
  CONSTRAINT `orientacion_tiene_grupo_ibfk_2` FOREIGN KEY (`idOrientacion`) REFERENCES `orientacion` (`idOrientacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orientacion_tiene_grupo`
--

LOCK TABLES `orientacion_tiene_grupo` WRITE;
/*!40000 ALTER TABLE `orientacion_tiene_grupo` DISABLE KEYS */;
INSERT INTO `orientacion_tiene_grupo` VALUES (1,3),(2,4),(3,5);
/*!40000 ALTER TABLE `orientacion_tiene_grupo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `persona`
--

DROP TABLE IF EXISTS `persona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `persona` (
  `ci` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(26) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido` varchar(26) COLLATE utf8mb4_unicode_ci NOT NULL,
  `clave` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `foto` blob,
  `avatar` blob,
  `enLinea` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ci`),
  KEY `ci` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persona`
--

LOCK TABLES `persona` WRITE;
/*!40000 ALTER TABLE `persona` DISABLE KEYS */;
INSERT INTO `persona` VALUES ('11111111','Penelope','cruz','clave1',0,NULL,NULL,0),('22222222','pepe','red','clave2',0,NULL,NULL,0),('33333333','coco','rock','clave3',0,NULL,NULL,0),('44444444','lex','luther','clave4',0,NULL,NULL,0),('55555555','arm','pit','clave5',0,NULL,NULL,0),('66666666','amy','schumer','clave6',0,NULL,NULL,0),('77777777','abel','sings','clave7',0,NULL,NULL,0),('88888888','sal','gore','clave8',0,NULL,NULL,0),('99999999','adam','sandler','adminclave',0,NULL,NULL,0);
/*!40000 ALTER TABLE `persona` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER checkData BEFORE INSERT ON Persona 
FOR EACH ROW
BEGIN
SET @charType= (NEW.nombre REGEXP "[^a-z^A-Z]") + (NEW.apellido REGEXP "[^a-z^A-Z]") + (NEW.ci REGEXP "[^0-9]");
SET @lengthCi= LENGTH(NEW.ci);
IF @chartype> 0 OR @lengthCi !=8 THEN 
	SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="invalid characters";
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER userHasLogged BEFORE UPDATE ON Persona
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sala`
--

DROP TABLE IF EXISTS `sala`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sala` (
  `idSala` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `idGrupo` int(11) NOT NULL,
  `idMateria` int(11) NOT NULL,
  `docenteCi` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `anfitrion` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `resumen` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isDone` tinyint(1) NOT NULL DEFAULT '0',
  `creacion` datetime NOT NULL,
  PRIMARY KEY (`idSala`),
  KEY `idSala` (`idSala`,`idGrupo`,`idMateria`),
  KEY `idGrupo` (`idGrupo`),
  KEY `idMateria` (`idMateria`),
  KEY `docenteCi` (`docenteCi`),
  KEY `anfitrion` (`anfitrion`),
  CONSTRAINT `sala_ibfk_1` FOREIGN KEY (`idGrupo`) REFERENCES `grupo` (`idGrupo`),
  CONSTRAINT `sala_ibfk_2` FOREIGN KEY (`idMateria`) REFERENCES `materia` (`idMateria`),
  CONSTRAINT `sala_ibfk_3` FOREIGN KEY (`docenteCi`) REFERENCES `docente` (`ci`),
  CONSTRAINT `sala_ibfk_4` FOREIGN KEY (`anfitrion`) REFERENCES `persona` (`ci`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sala`
--

LOCK TABLES `sala` WRITE;
/*!40000 ALTER TABLE `sala` DISABLE KEYS */;
INSERT INTO `sala` VALUES (1,1,1,'77777777','11111111','se hablo del prat 1 de polinomios',0,'2021-09-04 00:00:00'),(2,1,1,'77777777','11111111','2domsgg',0,'2021-09-06 00:00:00'),(3,1,1,'77777777','11111111','demooososo',0,'2021-09-06 00:00:00'),(4,1,1,'77777777','11111111','jelly',0,'2021-09-06 00:00:00'),(5,2,6,'77777777','77777777','revisamos el ejercicio 10 de prat 2',1,'2021-08-25 00:00:00'),(6,2,6,'77777777','77777777','revision primer escrito',1,'2021-08-30 00:00:00'),(7,2,6,'77777777','77777777','demostracion rufini',1,'2021-08-30 00:00:00'),(8,3,11,'77777777','77777777','E.A y R.G de 1/x',1,'2021-08-31 00:00:00'),(9,3,11,'77777777','77777777','dudas prat1',1,'2021-09-01 00:00:00'),(10,3,11,'77777777','77777777','dudas prat2',0,'2021-09-02 00:00:00'),(11,1,3,'88888888','88888888','intro a java',1,'2021-09-03 00:00:00'),(12,1,3,'88888888','88888888','intro de programacion orientada a objetos',1,'2021-09-04 00:00:00'),(13,1,3,'88888888','88888888','estructuras repetitivas',1,'2021-09-05 00:00:00'),(14,1,3,'88888888','88888888','condicionales',0,'2021-09-06 00:00:00'),(15,3,12,'88888888','88888888','INTRO A C#',1,'2021-09-07 00:00:00'),(16,3,12,'88888888','88888888','Capas de datos',1,'2021-09-08 00:00:00'),(17,3,12,'88888888','88888888','calculadora en c#',1,'2021-09-09 00:00:00'),(18,3,12,'88888888','88888888','ejemplo de conexion a base de datos c#',0,'2021-09-10 00:00:00');
/*!40000 ALTER TABLE `sala` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER loadMembersToSala AFTER INSERT ON Sala 
FOR EACH ROW
BEGIN
INSERT INTO Sala_members(idSala,ci,isConnected) SELECT NEW.idSala,alumnoCi,FALSE FROM alumno_tiene_Grupo WHERE idGrupo=NEW.idGrupo;
INSERT INTO Sala_members(idSala,ci,isConnected) VALUES (NEW.idSala,NEW.docenteCi,FALSE);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sala_members`
--

DROP TABLE IF EXISTS `sala_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sala_members` (
  `idSala` int(10) unsigned NOT NULL,
  `ci` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isConnected` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idSala`,`ci`),
  KEY `idSala` (`idSala`,`ci`),
  KEY `ci` (`ci`),
  CONSTRAINT `sala_members_ibfk_1` FOREIGN KEY (`idSala`) REFERENCES `sala` (`idSala`),
  CONSTRAINT `sala_members_ibfk_2` FOREIGN KEY (`ci`) REFERENCES `persona` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sala_members`
--

LOCK TABLES `sala_members` WRITE;
/*!40000 ALTER TABLE `sala_members` DISABLE KEYS */;
INSERT INTO `sala_members` VALUES (1,'11111111',0),(1,'33333333',0),(1,'44444444',0),(1,'66666666',0),(1,'77777777',0),(2,'11111111',0),(2,'33333333',0),(2,'44444444',0),(2,'66666666',0),(2,'77777777',0),(3,'11111111',0),(3,'33333333',0),(3,'44444444',0),(3,'66666666',0),(3,'77777777',0),(4,'11111111',0),(4,'33333333',0),(4,'44444444',0),(4,'66666666',0),(4,'77777777',0),(5,'11111111',0),(5,'22222222',0),(5,'44444444',0),(5,'77777777',0),(6,'11111111',0),(6,'22222222',0),(6,'44444444',0),(6,'77777777',0),(7,'11111111',0),(7,'22222222',0),(7,'44444444',0),(7,'77777777',0),(8,'22222222',0),(8,'66666666',0),(8,'77777777',0),(9,'22222222',0),(9,'66666666',0),(9,'77777777',0),(10,'22222222',0),(10,'66666666',0),(10,'77777777',0),(11,'11111111',0),(11,'33333333',0),(11,'44444444',0),(11,'66666666',0),(11,'88888888',0),(12,'11111111',0),(12,'33333333',0),(12,'44444444',0),(12,'66666666',0),(12,'88888888',0),(13,'11111111',0),(13,'33333333',0),(13,'44444444',0),(13,'66666666',0),(13,'88888888',0),(14,'11111111',0),(14,'33333333',0),(14,'44444444',0),(14,'66666666',0),(14,'88888888',0),(15,'22222222',0),(15,'66666666',0),(15,'88888888',0),(16,'22222222',0),(16,'66666666',0),(16,'88888888',0),(17,'22222222',0),(17,'66666666',0),(17,'88888888',0),(18,'22222222',0),(18,'66666666',0),(18,'88888888',0);
/*!40000 ALTER TABLE `sala_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sala_mensaje`
--

DROP TABLE IF EXISTS `sala_mensaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sala_mensaje` (
  `idSala` int(10) unsigned NOT NULL,
  `idMensaje` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `autorCi` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contenido` varchar(5000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaHora` datetime NOT NULL,
  PRIMARY KEY (`idMensaje`),
  KEY `idSala` (`idSala`),
  KEY `autorCi` (`autorCi`),
  CONSTRAINT `sala_mensaje_ibfk_1` FOREIGN KEY (`idSala`) REFERENCES `sala` (`idSala`),
  CONSTRAINT `sala_mensaje_ibfk_2` FOREIGN KEY (`autorCi`) REFERENCES `persona` (`ci`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sala_mensaje`
--

LOCK TABLES `sala_mensaje` WRITE;
/*!40000 ALTER TABLE `sala_mensaje` DISABLE KEYS */;
INSERT INTO `sala_mensaje` VALUES (1,1,'11111111','Hola podemos discutir lo del prat 1?','2021-09-05 00:00:00'),(1,2,'33333333','yes im very lost help me','2021-09-06 00:00:00'),(1,3,'77777777','sii pregunta nomas y yo les contesto ','2021-09-08 00:00:00'),(1,4,'77777777','msg3','2021-09-08 00:00:00'),(1,5,'77777777','masg4','2021-09-07 00:00:00'),(1,6,'77777777','msg5','2021-09-10 00:00:00'),(1,7,'77777777','msg6','2021-09-09 00:00:00'),(1,8,'77777777','jelly','2021-09-10 00:00:00'),(2,9,'77777777','buenas chicoos','2021-08-26 00:00:00'),(2,10,'77777777','Hoy vamos a hacer x cosa','2021-08-31 00:00:00'),(3,11,'77777777','hola son el grupo 3ro?','2021-09-06 00:00:00'),(4,12,'77777777','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.','2021-08-31 00:00:00'),(4,13,'77777777','Lorem ipsum dolor sit amet, consectetur adipiscing elgna aliqua.','2021-09-05 00:00:00');
/*!40000 ALTER TABLE `sala_mensaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userlogs`
--

DROP TABLE IF EXISTS `userlogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userlogs` (
  `ci` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `login` datetime NOT NULL,
  `logOut` datetime DEFAULT NULL,
  KEY `ci` (`ci`),
  CONSTRAINT `userlogs_ibfk_1` FOREIGN KEY (`ci`) REFERENCES `persona` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userlogs`
--

LOCK TABLES `userlogs` WRITE;
/*!40000 ALTER TABLE `userlogs` DISABLE KEYS */;
INSERT INTO `userlogs` VALUES ('11111111','2021-08-30 00:00:00','2021-08-30 00:00:00'),('11111111','2021-08-31 00:00:00','2021-08-31 00:00:00'),('11111111','2021-09-01 00:00:00','2021-09-01 00:00:00'),('11111111','2021-09-02 00:00:00','2021-09-02 00:00:00'),('11111111','2021-09-03 00:00:00','2021-09-09 00:00:00'),('77777777','2021-08-30 00:00:00','2021-08-30 00:00:00'),('77777777','2021-08-31 00:00:00','2021-08-31 00:00:00'),('77777777','2021-09-01 00:00:00','2021-09-01 00:00:00'),('77777777','2021-09-02 00:00:00','2021-09-02 00:00:00');
/*!40000 ALTER TABLE `userlogs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-09-10  9:37:15
