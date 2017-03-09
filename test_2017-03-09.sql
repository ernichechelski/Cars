# ************************************************************
# Sequel Pro SQL dump
# Version 4529
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.16)
# Database: test
# Generation Time: 2017-03-09 21:29:22 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table Cars
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Cars`;

CREATE TABLE `Cars` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `make` varchar(20) DEFAULT NULL,
  `model` varchar(20) DEFAULT NULL,
  `sub_model` varchar(30) DEFAULT NULL,
  `year` int(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8;

LOCK TABLES `Cars` WRITE;
/*!40000 ALTER TABLE `Cars` DISABLE KEYS */;

INSERT INTO `Cars` (`id`, `make`, `model`, `sub_model`, `year`)
VALUES
	(42,'Toyota','Corolla','1.6 TDI',2010),
	(45,'Porsche','Cayenne','3.5 V8',2010),
	(46,'Porsche','911','3.5 V6',2006),
	(47,'Nissan','Skyline','5.0 V8',1996),
	(48,'Batmobil','Turbo','8.0 V16',2001),
	(49,'Jelcz','315','11.2 SW 680',1968),
	(57,'Jaguar','XJS','5.3 V12',1975),
	(58,'Chevrolet','Camaro','5.4 V8',1996),
	(59,'Citroen','Jumper','3.0 TDI',2014),
	(87,'Make','Model','Submodel',0),
	(88,'sda','sadxa','xadSubmodel',1234);

/*!40000 ALTER TABLE `Cars` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
