-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.21-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             9.5.0.5315
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for phoenix
CREATE DATABASE IF NOT EXISTS `phoenix` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `phoenix`;

-- Dumping structure for table phoenix.addon_account
CREATE TABLE IF NOT EXISTS `addon_account` (
  `name` varchar(60) COLLATE utf8_persian_ci NOT NULL,
  `label` varchar(100) COLLATE utf8_persian_ci NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table phoenix.addon_account: ~19 rows (approximately)
/*!40000 ALTER TABLE `addon_account` DISABLE KEYS */;
INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_ambulance', 'Ambulance', 1),
	('society_bahamas', 'Bahamas', 1),
	('society_cafe', 'Cafe', 1),
	('society_casino', 'Casino', 1),
	('society_dadgostari', 'Dadgostari', 1),
	('society_lawyer', 'Lawyer', 1),
	('society_mechanic', 'Mechanic', 1),
	('society_motormechanic', 'Motorcycle Mechanic', 1),
	('society_nojob', 'nojob', 1),
	('society_offambulance', 'Ambulance', 1),
	('society_offdadgostari', 'DOJ', 1),
	('society_offpolice', 'Police', 1),
	('society_offweazel', 'Weazel', 1),
	('society_police', 'Police', 1),
	('society_realstate', 'Real State', 1),
	('society_semsary', 'Semsary', 1),
	('society_streetclub', 'StreetClub', 1),
	('society_taxi', 'Taxi', 1),
	('society_weazel', 'Weazel', 1);
/*!40000 ALTER TABLE `addon_account` ENABLE KEYS */;

-- Dumping structure for table phoenix.addon_account_data
CREATE TABLE IF NOT EXISTS `addon_account_data` (
  `account_name` varchar(100) COLLATE utf8_persian_ci DEFAULT NULL,
  `money` int(11) NOT NULL,
  `owner` varchar(100) COLLATE utf8_persian_ci DEFAULT NULL,
  UNIQUE KEY `index_addon_account_data_account_name_owner` (`account_name`,`owner`) USING BTREE,
  KEY `index_addon_account_data_account_name` (`account_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table phoenix.addon_account_data: ~19 rows (approximately)
/*!40000 ALTER TABLE `addon_account_data` DISABLE KEYS */;
INSERT INTO `addon_account_data` (`account_name`, `money`, `owner`) VALUES
	('society_ambulance', 0, NULL),
	('society_dadgostari', 0, NULL),
	('society_mechanic', 0, NULL),
	('society_police', 0, NULL),
	('society_taxi', 0, NULL),
	('society_nojob', 0, NULL),
	('society_offambulance', 0, NULL),
	('society_offdadgostari', 0, NULL),
	('society_offpolice', 0, NULL),
	('society_offweazel', 0, NULL),
	('society_weazel', 0, NULL),
	('society_cafe', 0, NULL),
	('society_realstate', 0, NULL),
	('society_streetclub', 0, NULL),
	('society_bahamas', 0, NULL),
	('society_casino', 0, NULL),
	('society_semsary', 0, NULL),
	('society_lawyer', 0, NULL),
	('society_motormechanic', 0, NULL);
/*!40000 ALTER TABLE `addon_account_data` ENABLE KEYS */;

-- Dumping structure for table phoenix.allhousing
CREATE TABLE IF NOT EXISTS `allhousing` (
  `id` int(11) NOT NULL,
  `owner` varchar(50) NOT NULL,
  `ownername` varchar(50) NOT NULL,
  `owned` tinyint(4) NOT NULL,
  `price` int(11) NOT NULL,
  `resalepercent` int(11) NOT NULL,
  `resalejob` varchar(50) NOT NULL,
  `entry` longtext DEFAULT NULL,
  `garage` longtext DEFAULT NULL,
  `furniture` longtext DEFAULT NULL,
  `shell` varchar(50) NOT NULL,
  `interior` varchar(50) NOT NULL,
  `shells` longtext DEFAULT NULL,
  `doors` longtext DEFAULT NULL,
  `housekeys` longtext DEFAULT NULL,
  `wardrobe` longtext DEFAULT NULL,
  `inventory` longtext DEFAULT NULL,
  `inventorylocation` longtext DEFAULT NULL,
  `mortgage_owed` int(11) NOT NULL DEFAULT 0,
  `last_repayment` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.allhousing: ~0 rows (approximately)
/*!40000 ALTER TABLE `allhousing` DISABLE KEYS */;
/*!40000 ALTER TABLE `allhousing` ENABLE KEYS */;

-- Dumping structure for table phoenix.billing
CREATE TABLE IF NOT EXISTS `billing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) COLLATE utf8_persian_ci NOT NULL,
  `sender` varchar(255) COLLATE utf8_persian_ci NOT NULL,
  `target_type` varchar(50) COLLATE utf8_persian_ci NOT NULL,
  `target` varchar(255) COLLATE utf8_persian_ci NOT NULL,
  `label` varchar(255) COLLATE utf8_persian_ci NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table phoenix.billing: ~0 rows (approximately)
/*!40000 ALTER TABLE `billing` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing` ENABLE KEYS */;

-- Dumping structure for table phoenix.denied
CREATE TABLE IF NOT EXISTS `denied` (
  `steamid` varchar(50) NOT NULL DEFAULT '',
  `hardwareid` varchar(50) NOT NULL DEFAULT '',
  `reason` varchar(50) NOT NULL DEFAULT '',
  `icname` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.denied: ~0 rows (approximately)
/*!40000 ALTER TABLE `denied` DISABLE KEYS */;
/*!40000 ALTER TABLE `denied` ENABLE KEYS */;

-- Dumping structure for table phoenix.divisions
CREATE TABLE IF NOT EXISTS `divisions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `division_name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `vehicles` longtext COLLATE utf8_bin NOT NULL,
  `skin_male` longtext COLLATE utf8_bin NOT NULL,
  `skin_female` longtext COLLATE utf8_bin NOT NULL,
  `others` longtext COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

-- Dumping data for table phoenix.divisions: ~0 rows (approximately)
/*!40000 ALTER TABLE `divisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `divisions` ENABLE KEYS */;

-- Dumping structure for table phoenix.fines
CREATE TABLE IF NOT EXISTS `fines` (
  `id` int(100) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `fineamount` int(100) NOT NULL,
  `reason` varchar(50) NOT NULL,
  `punisher` varchar(50) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Dumping data for table phoenix.fines: ~0 rows (approximately)
/*!40000 ALTER TABLE `fines` DISABLE KEYS */;
/*!40000 ALTER TABLE `fines` ENABLE KEYS */;

-- Dumping structure for table phoenix.fine_types
CREATE TABLE IF NOT EXISTS `fine_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) COLLATE utf8_persian_ci DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

-- Dumping data for table phoenix.fine_types: ~54 rows (approximately)
/*!40000 ALTER TABLE `fine_types` DISABLE KEYS */;
INSERT INTO `fine_types` (`id`, `label`, `amount`, `category`) VALUES
	(1, 'Aloodegi soti', 200, 0),
	(2, 'Oboor az cheraghe ghermez', 500, 0),
	(3, 'Vorood mamnoo', 500, 0),
	(4, 'Dor zadan gheyr e mojaz', 400, 0),
	(5, 'Ranandegi dar line mokhalef', 500, 0),
	(6, 'Ranandegi khatarnak', 700, 0),
	(7, 'Tavaghof mamnoo', 200, 0),
	(8, 'Park e bad', 300, 0),
	(9, 'Adam tavajoh be hagh e taghadom', 200, 0),
	(10, 'Adam tavajo be fasele tooli', 100, 0),
	(11, 'Adam tavajoh be tavaghof', 500, 0),
	(12, 'Adam e tavajoh be alayeme ranandegi', 400, 0),
	(13, 'Harakat e khatarnak', 700, 0),
	(14, 'tajavoz be harime khososi', 600, 0),
	(15, 'Ranandegi bedoone govahinam', 700, 0),
	(16, 'Zadan o dar raftan', 700, 0),
	(17, 'Sorat e kamtar az 60Km/h', 200, 0),
	(18, 'Soraat mojaz 60Km/h', 200, 0),
	(19, 'Soraat mojaz 80Km/h', 400, 0),
	(20, 'Soraat mojaz 120Km/h', 600, 0),
	(21, 'Ijad e traffic', 250, 1),
	(22, 'Bastan e khiyaboon', 700, 1),
	(23, 'Beham rikhtan e nazm ', 450, 1),
	(24, 'Bi tavajohi be ekhtar e police', 800, 1),
	(25, 'Bi ehterami', 300, 1),
	(26, 'Tohin be mamoor e police', 500, 1),
	(27, 'Tahdid shahrvandan', 950, 1),
	(28, 'Tahdid Police', 1200, 1),
	(29, 'Eteraz be ghanoon', 300, 1),
	(30, 'Ijad e fesad', 1500, 1),
	(31, 'Estefade az selahe sard dar shahr', 400, 2),
	(32, 'Estefade az selahe garm dar shahr', 800, 2),
	(33, 'Hamle aslahe bedoon e mojavez', 1500, 2),
	(34, 'Dashtan e aslahe gheyre mojaz', 5500, 2),
	(35, 'hamkari nakardan ba mamore ghanon', 2500, 2),
	(36, 'Dozdi khodro', 5000, 2),
	(37, 'Foroosh e mavad e mokhader', 2000, 2),
	(38, 'Tolid e mavad e mokhader', 3500, 2),
	(39, 'Dashtan e mavad e mokhader', 2500, 2),
	(40, 'Majrooh kardan shahrvand', 3500, 2),
	(41, 'Majrooh kardan e mamoor e ghanoon', 5000, 2),
	(42, 'Dozdi', 1500, 2),
	(43, 'Dozdi az maghaze', 5000, 2),
	(44, 'Dozdi az bank', 10000, 2),
	(45, 'Shelik be shahrvandan', 4000, 3),
	(46, 'Shelik be samte mamoor e ghanoon', 7500, 3),
	(47, 'Eghdam be ghatle shahrvand', 5000, 3),
	(48, 'Eghdam be ghatle mamoor e ghanoon', 10000, 3),
	(49, 'Koshtan e shahrvand', 7500, 3),
	(50, 'Koshtan e mamoor e ghanoon', 12500, 3),
	(51, 'Ghatl e gheyre amd', 5000, 3),
	(52, 'Kolah bardari kari', 2500, 2),
	(53, 'Mojavez Aslahe', 15000, 1),
	(54, NULL, NULL, NULL);
/*!40000 ALTER TABLE `fine_types` ENABLE KEYS */;

-- Dumping structure for table phoenix.gangs
CREATE TABLE IF NOT EXISTS `gangs` (
  `name` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `label` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

-- Dumping data for table phoenix.gangs: ~2 rows (approximately)
/*!40000 ALTER TABLE `gangs` DISABLE KEYS */;
INSERT INTO `gangs` (`name`, `label`) VALUES
	('nogang', 'nogang'),
	('Military', 'gang');
/*!40000 ALTER TABLE `gangs` ENABLE KEYS */;

-- Dumping structure for table phoenix.gangs_data
CREATE TABLE IF NOT EXISTS `gangs_data` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `gang_name` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `blip` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `armory` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `locker` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `boss` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `veh` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `vehdel` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `vehspawn` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `bulletproof` int(255) DEFAULT 50,
  `slot` int(255) DEFAULT 10,
  `vestperm` int(11) DEFAULT 1,
  `craftperm` int(11) DEFAULT 2,
  `stashperm` int(11) DEFAULT 2,
  `blip_icon` int(11) DEFAULT 1,
  `blip_color` int(11) DEFAULT 1,
  `icon` varchar(255) COLLATE utf8_persian_ci DEFAULT 'http://uupload.ir/files/1j24_gang.png',
  `invperm` int(11) DEFAULT 6,
  `gangsblip` int(11) DEFAULT 0,
  `expire_time` date DEFAULT NULL,
  `register_time` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

-- Dumping data for table phoenix.gangs_data: ~0 rows (approximately)
/*!40000 ALTER TABLE `gangs_data` DISABLE KEYS */;
INSERT INTO `gangs_data` (`ID`, `gang_name`, `blip`, `armory`, `locker`, `boss`, `veh`, `vehdel`, `vehspawn`, `bulletproof`, `slot`, `vestperm`, `craftperm`, `stashperm`, `blip_icon`, `blip_color`, `icon`, `invperm`, `gangsblip`, `expire_time`, `register_time`) VALUES
	(2, 'Military', '{"x":-2329.274658203125,"y":3253.469482421875,"z":33.32762908935547}', '{"x":-2349.8330078125,"y":3266.299560546875,"z":31.81076049804687}', '{"x":-2357.797119140625,"y":3255.0869140625,"z":31.81071853637695}', '{"x":-2347.8173828125,"y":3269.11572265625,"z":31.81076049804687}', '{"x":-2343.338134765625,"y":3262.257568359375,"z":31.82763671875}', '{"x":-2341.66845703125,"y":3251.5712890625,"z":31.82763671875}', '{"y":3259.583251953125,"x":-2334.64453125,"a":329.28167724609377,"z":32.82763671875}', 100, 10, 1, 2, 2, 1, 1, 'http://uupload.ir/files/1j24_gang.png', 6, 0, '2025-01-03', NULL);
/*!40000 ALTER TABLE `gangs_data` ENABLE KEYS */;

-- Dumping structure for table phoenix.gang_account
CREATE TABLE IF NOT EXISTS `gang_account` (
  `name` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `label` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `shared` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

-- Dumping data for table phoenix.gang_account: ~0 rows (approximately)
/*!40000 ALTER TABLE `gang_account` DISABLE KEYS */;
INSERT INTO `gang_account` (`name`, `label`, `shared`) VALUES
	('gang_military', 'gang', 1);
/*!40000 ALTER TABLE `gang_account` ENABLE KEYS */;

-- Dumping structure for table phoenix.gang_account_data
CREATE TABLE IF NOT EXISTS `gang_account_data` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `gang_name` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `money` double DEFAULT NULL,
  `pay` int(11) DEFAULT NULL,
  `owner` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

-- Dumping data for table phoenix.gang_account_data: ~0 rows (approximately)
/*!40000 ALTER TABLE `gang_account_data` DISABLE KEYS */;
INSERT INTO `gang_account_data` (`ID`, `gang_name`, `money`, `pay`, `owner`) VALUES
	(2, 'gang_military', 0, NULL, NULL);
/*!40000 ALTER TABLE `gang_account_data` ENABLE KEYS */;

-- Dumping structure for table phoenix.gang_grades
CREATE TABLE IF NOT EXISTS `gang_grades` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `gang_name` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `grade` int(11) DEFAULT NULL,
  `name` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `label` varchar(254) COLLATE utf8_persian_ci DEFAULT NULL,
  `salary` int(11) DEFAULT NULL,
  `skin_male` longtext COLLATE utf8_persian_ci DEFAULT NULL,
  `skin_female` longtext COLLATE utf8_persian_ci DEFAULT NULL,
  `skin_male2` longtext COLLATE utf8_persian_ci DEFAULT NULL,
  `skin_female2` longtext COLLATE utf8_persian_ci DEFAULT NULL,
  `skin_male3` longtext COLLATE utf8_persian_ci DEFAULT NULL,
  `skin_female3` longtext COLLATE utf8_persian_ci DEFAULT NULL,
  `cars` longtext COLLATE utf8_persian_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `gang_name` (`gang_name`),
  KEY `grade` (`grade`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

-- Dumping data for table phoenix.gang_grades: ~11 rows (approximately)
/*!40000 ALTER TABLE `gang_grades` DISABLE KEYS */;
INSERT INTO `gang_grades` (`ID`, `gang_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`, `skin_male2`, `skin_female2`, `skin_male3`, `skin_female3`, `cars`) VALUES
	(1, 'nogang', 0, 'nogang', 'NoGang', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(8, 'Military', 3, 'Rank 3', 'Rank3', 0, '[]', NULL, NULL, '[]', NULL, NULL, NULL),
	(9, 'Military', 4, 'Rank 4', 'Rank4', 0, '[]', NULL, NULL, '[]', NULL, NULL, NULL),
	(10, 'Military', 8, 'Rank 8', 'Rank8', 0, '[]', NULL, NULL, '[]', NULL, NULL, NULL),
	(11, 'Military', 6, 'Rank 6', 'Rank6', 0, '[]', NULL, NULL, '[]', NULL, NULL, NULL),
	(12, 'Military', 1, 'Rank 1', 'Rank1', 0, '[]', NULL, NULL, '[]', NULL, NULL, NULL),
	(13, 'Military', 7, 'Rank 7', 'Rank7', 0, '[]', NULL, NULL, '[]', NULL, NULL, NULL),
	(14, 'Military', 2, 'Rank 2', 'Rank2', 0, '[]', NULL, NULL, '[]', NULL, NULL, NULL),
	(15, 'Military', 9, 'Rank 9', 'Rank9', 0, '[]', NULL, NULL, '[]', NULL, NULL, NULL),
	(16, 'Military', 5, 'Rank 5', 'Rank5', 0, '[]', NULL, '[]', '[]', NULL, NULL, NULL),
	(17, 'Military', 10, 'Rank 10', 'Rank10', 0, '[]', NULL, NULL, '[]', NULL, NULL, NULL);
/*!40000 ALTER TABLE `gang_grades` ENABLE KEYS */;

-- Dumping structure for table phoenix.inventory_stash
CREATE TABLE IF NOT EXISTS `inventory_stash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stash` varchar(50) NOT NULL,
  `items` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Dumping data for table phoenix.inventory_stash: 5 rows
/*!40000 ALTER TABLE `inventory_stash` DISABLE KEYS */;
INSERT INTO `inventory_stash` (`id`, `stash`, `items`) VALUES
	(1, 'gang_Military', '[]'),
	(2, 'streetclub', '[]'),
	(3, 'bahamas', '[]'),
	(4, 'semsary', '[]'),
	(5, 'Container | 5018 | 3881 |', '[]');
/*!40000 ALTER TABLE `inventory_stash` ENABLE KEYS */;

-- Dumping structure for table phoenix.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) COLLATE utf8_bin NOT NULL,
  `label` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

-- Dumping data for table phoenix.jobs: ~19 rows (approximately)
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` (`name`, `label`) VALUES
	('ambulance', 'Ambulance'),
	('bahamas', 'Bahamas'),
	('cafe', 'Cafe'),
	('casino', 'Casino'),
	('dadgostari', 'DOJ'),
	('lawyer', 'Lawyer'),
	('mechanic', 'Mechanic'),
	('motormechanic', 'MC Mechanic'),
	('nojob', 'nojob'),
	('offambulance', 'Ambulance'),
	('offdadgostari', 'DOJ'),
	('offpolice', 'Police'),
	('offweazel', 'Weazel'),
	('police', 'Police'),
	('realstate', 'Real State'),
	('semsary', 'Semsary'),
	('streetclub', 'StreetClub'),
	('taxi', 'Taxi'),
	('weazel', 'Weazel');
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;

-- Dumping structure for table phoenix.job_grades
CREATE TABLE IF NOT EXISTS `job_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_bin NOT NULL,
  `label` varchar(255) COLLATE utf8_bin NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext COLLATE utf8_bin NOT NULL,
  `skin_female` longtext COLLATE utf8_bin NOT NULL,
  `vehicles` longtext COLLATE utf8_bin NOT NULL,
  KEY `skin_male` (`skin_male`(255)),
  KEY `skin_female` (`skin_female`(255)),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=318 DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

-- Dumping data for table phoenix.job_grades: ~96 rows (approximately)
/*!40000 ALTER TABLE `job_grades` DISABLE KEYS */;
INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`, `vehicles`) VALUES
	(1, 'nojob', 0, 'Bikar', 'Gada', 0, '{}', '{}', ''),
	(3, 'police', 2, 'employee', 'Officer I', 130, '{}', '{}', ''),
	(4, 'police', 3, 'employee', 'Officer II', 140, '{}', '{}', ''),
	(5, 'police', 4, 'employee', 'Officer III', 150, '{}', '{}', ''),
	(6, 'police', 5, 'employee', 'Senior Lead', 160, '{}', '{}', ''),
	(7, 'police', 6, 'employee', 'Sergeant', 170, '{}', '{}', ''),
	(8, 'police', 9, 'employee', 'Capitan', 200, '{}', '{}', ''),
	(9, 'police', 10, 'boss', 'DeputyChief', 220, '{}', '{}', ''),
	(10, 'police', 11, 'boss', 'Chief', 250, '{"bracelet":{"defaultItem":-1,"defaultTexture":0,"item":-1,"texture":0},"mask":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"lipstick":{"defaultItem":-1,"defaultTexture":1,"item":-1,"texture":1},"torso2":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"bag":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"glass":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"accessory":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"ear":{"defaultItem":-1,"defaultTexture":0,"item":-1,"texture":0},"arms":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"ageing":{"defaultItem":-1,"defaultTexture":0,"item":-1,"texture":0},"blush":{"defaultItem":-1,"defaultTexture":1,"item":-1,"texture":1},"makeup":{"defaultItem":-1,"defaultTexture":1,"item":-1,"texture":1},"shoes":{"defaultItem":1,"defaultTexture":0,"item":0,"texture":0},"pants":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"beard":{"defaultItem":-1,"defaultTexture":1,"item":-1,"texture":1},"face":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"t-shirt":{"defaultItem":1,"defaultTexture":0,"item":4,"texture":0},"decals":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"hair":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"hat":{"defaultItem":-1,"defaultTexture":0,"item":-1,"texture":0},"watch":{"defaultItem":-1,"defaultTexture":0,"item":-1,"texture":0},"vest":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"eyebrows":{"defaultItem":-1,"defaultTexture":1,"item":-1,"texture":1}}', '{}', ''),
	(11, 'mechanic', 0, 'employee', 'Employee', 100, '{}', '{}', ''),
	(16, 'taxi', 0, 'employee', 'Training', 100, '{}', '{}', ''),
	(17, 'taxi', 1, 'employee', 'Driver', 110, '{}', '{}', ''),
	(18, 'taxi', 3, 'boss', 'Boss', 120, '{}', '{}', ''),
	(21, 'ambulance', 0, 'employee', 'Intern', 150, '{}', '{}', ''),
	(22, 'ambulance', 1, 'employee', 'Nurse', 160, '{}', '{}', ''),
	(23, 'ambulance', 2, 'employee', 'EMT', 170, '{}', '{}', ''),
	(24, 'ambulance', 3, 'employee', 'Doctor', 180, '{}', '{}', ''),
	(25, 'ambulance', 4, 'employee', 'Resident', 190, '{}', '{}', ''),
	(26, 'ambulance', 5, 'employee', 'Sergeon', 200, '{}', '{}', ''),
	(27, 'ambulance', 7, 'boss', 'Assisst', 250, '{}', '{}', ''),
	(28, 'ambulance', 8, 'boss', 'Chief', 300, '{}', '{}', ''),
	(61, 'police', 0, 'employee', 'Under Train', 2000, '{}', '{}', ''),
	(62, 'dadgostari', 0, 'employee', 'Security G', 110, '{}', '{}', ''),
	(63, 'dadgostari', 1, 'employee', 'Security HC', 130, '{}', '{}', ''),
	(64, 'dadgostari', 2, 'employee', 'Federal', 150, '{}', '{}', ''),
	(65, 'dadgostari', 3, 'employee', 'Federal SuperVisor', 160, '{}', '{}', ''),
	(66, 'dadgostari', 4, 'employee', 'Detective', 170, '{}', '{}', ''),
	(67, 'dadgostari', 5, 'employee', 'Judge Test', 150, '{}', '{}', ''),
	(68, 'dadgostari', 6, 'employee', 'Dadsetan', 180, '{}', '{}', ''),
	(69, 'dadgostari', 7, 'boss', 'Judge', 200, '{}', '{}', ''),
	(70, 'dadgostari', 8, 'boss', 'Chief', 250, '{}', '{}', ''),
	(71, 'offpolice', 0, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(72, 'offpolice', 1, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(73, 'offpolice', 2, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(74, 'offpolice', 3, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(75, 'offpolice', 4, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(76, 'offpolice', 5, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(77, 'offpolice', 6, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(78, 'offpolice', 9, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(79, 'offpolice', 10, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(80, 'offpolice', 11, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(87, 'offambulance', 1, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(88, 'offambulance', 2, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(89, 'offambulance', 3, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(90, 'offambulance', 4, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(91, 'offambulance', 5, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(92, 'offambulance', 7, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(93, 'offambulance', 8, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(114, 'offdadgostari', 0, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(115, 'offdadgostari', 1, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(116, 'offdadgostari', 2, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(117, 'offdadgostari', 3, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(118, 'offdadgostari', 4, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(119, 'offdadgostari', 5, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(120, 'offdadgostari', 6, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(121, 'offdadgostari', 7, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(122, 'offdadgostari', 8, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(123, 'weazel', 1, 'employee', 'Film Bardar', 7000, '{}', '{}', ''),
	(124, 'weazel', 2, 'employee', 'Khabar Negar', 8000, '{}', '{}', ''),
	(125, 'weazel', 3, 'employee', 'Herfe i', 9000, '{}', '{}', ''),
	(126, 'weazel', 4, 'boss', 'SarParast', 12000, '{}', '{}', ''),
	(127, 'weazel', 5, 'boss', 'Modir Kol', 15000, '{}', '{}', ''),
	(128, 'offweazel', 1, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(129, 'offweazel', 2, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(130, 'offweazel', 3, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(131, 'offweazel', 4, 'boss', 'Off-Duty', 0, '{}', '{}', ''),
	(132, 'offweazel', 5, 'boss', 'Off-Duty', 0, '{}', '{}', ''),
	(133, 'mechanic', 1, 'employee', 'Customer', 120, '{}', '{}', ''),
	(153, 'weazel', 0, 'employee', 'Taze Kar', 5000, '{}', '{}', ''),
	(154, 'offweazel', 0, 'employee', 'Off-Duty', 0, '{}', '{}', ''),
	(155, 'cafe', 0, 'employee', 'Employee', 0, '{}', '{}', ''),
	(159, 'cafe', 1, 'boss', 'Boss', 0, '{}', '{}', ''),
	(160, 'realstate', 0, 'employee', 'Employee', 0, '{}', '{}', ''),
	(161, 'realstate', 1, 'boss', 'Boss', 0, '{}', '{}', ''),
	(134, 'mechanic', 2, 'boss', 'Boss', 150, '{}', '{}', ''),
	(245, 'streetclub', 1, 'boss', 'Boss', 250, '{}', '{}', ''),
	(246, 'bahamas', 0, 'employee', 'zero', 0, '{}', '{}', ''),
	(252, 'bahamas', 1, 'boss', 'Boss', 0, '{}', '{}', ''),
	(284, 'casino', 0, 'employee', 'Employee', 0, '{}', '{}', ''),
	(285, 'casino', 1, 'boss', 'Boss', 0, '{}', '{}', ''),
	(289, 'streetclub', 0, 'employee', 'Employee', 0, '{}', '{}', ''),
	(298, 'semsary', 0, 'employee', 'kargar ', 0, '{}', '{}', ''),
	(299, 'semsary', 1, 'boss', 'Boss', 0, '{}', '{}', ''),
	(300, 'lawyer', 0, '0', 'Lawyer', 150, '{}', '{}', ''),
	(301, 'lawyer', 1, 'boss', 'DOJ Judge', 0, '{}', '{}', ''),
	(302, 'lawyer', 2, 'boss', 'DOJ Chief', 0, '{}', '{}', ''),
	(303, 'police', 7, 'detective', 'Detective', 180, '{}', '{}', ''),
	(304, 'offpolice', 7, 'detective', 'Off-Duty', 0, '{}', '{}', ''),
	(305, 'police', 8, 'dispatch', 'Commander', 190, '{}', '{}', ''),
	(306, 'offpolice', 8, 'dispatch', 'Off-Duty', 0, '{}', '{}', ''),
	(310, 'motormechanic', 0, 'employee', 'Employee', 100, '{}', '{}', ''),
	(311, 'motormechanic', 1, 'employee', 'Customer', 120, '{}', '{}', ''),
	(312, 'motormechanic', 2, 'boss', 'Boss', 150, '{}', '{}', ''),
	(316, 'ambulance', 6, 'paramedics', 'Dispatch', 210, '{}', '{}', ''),
	(317, 'offambulance', 6, 'commander', 'Off-Duty', 0, '{}', '{}', ''),
	(2, 'police', 1, 'employee', 'Cadet', 120, '{}', '{}', '');
/*!40000 ALTER TABLE `job_grades` ENABLE KEYS */;

-- Dumping structure for table phoenix.licenses
CREATE TABLE IF NOT EXISTS `licenses` (
  `type` varchar(60) COLLATE utf8_persian_ci NOT NULL,
  `label` varchar(60) COLLATE utf8_persian_ci NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

-- Dumping data for table phoenix.licenses: ~6 rows (approximately)
/*!40000 ALTER TABLE `licenses` DISABLE KEYS */;
INSERT INTO `licenses` (`type`, `label`) VALUES
	('boat', 'Boat License'),
	('dmv', 'Ayin Naame'),
	('drive', 'Govahiname Mashin'),
	('drive_bike', 'Govahiname Motor'),
	('drive_truck', 'Govahiname Kamiyon'),
	('weapon', 'Mojavez Aslahe');
/*!40000 ALTER TABLE `licenses` ENABLE KEYS */;

-- Dumping structure for table phoenix.okokbanking_societies
CREATE TABLE IF NOT EXISTS `okokbanking_societies` (
  `society` varchar(255) DEFAULT NULL,
  `society_name` varchar(255) DEFAULT NULL,
  `value` int(50) DEFAULT NULL,
  `iban` varchar(255) NOT NULL,
  `is_withdrawing` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.okokbanking_societies: ~2 rows (approximately)
/*!40000 ALTER TABLE `okokbanking_societies` DISABLE KEYS */;
INSERT INTO `okokbanking_societies` (`society`, `society_name`, `value`, `iban`, `is_withdrawing`) VALUES
	('society_police', 'Police', 0, 'OKPOLICE', 0),
	('society_ambulance', 'Ambulance', 0, 'OKAMBULANCE', NULL);
/*!40000 ALTER TABLE `okokbanking_societies` ENABLE KEYS */;

-- Dumping structure for table phoenix.okokbanking_transactions
CREATE TABLE IF NOT EXISTS `okokbanking_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `receiver_identifier` varchar(255) NOT NULL,
  `receiver_name` varchar(255) NOT NULL,
  `sender_identifier` varchar(255) NOT NULL,
  `sender_name` varchar(255) NOT NULL,
  `date` varchar(255) NOT NULL,
  `value` int(50) NOT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.okokbanking_transactions: ~0 rows (approximately)
/*!40000 ALTER TABLE `okokbanking_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `okokbanking_transactions` ENABLE KEYS */;

-- Dumping structure for table phoenix.owned_shops
CREATE TABLE IF NOT EXISTS `owned_shops` (
  `owner` varchar(250) DEFAULT 'government',
  `number` int(11) NOT NULL,
  `money` int(11) DEFAULT 0,
  `value` varchar(255) DEFAULT '[]',
  `inventory` varchar(250) DEFAULT '[]',
  `name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.owned_shops: ~20 rows (approximately)
/*!40000 ALTER TABLE `owned_shops` DISABLE KEYS */;
INSERT INTO `owned_shops` (`owner`, `number`, `money`, `value`, `inventory`, `name`) VALUES
	('{"name":"Rony Collins","identifier":"steam:110000144c6a3b8"}', 1, 170, '{"forsale":false,"value":1000000}', '{"macka":300,"chips":513,"lighter":99,"fanta":720,"marabou":321,"cigarett":2999,"radio":963,"phone":943,"cocacola":200,"sprite":571,"water":300}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 2, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 3, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 4, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 5, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 6, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 7, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 8, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 9, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 10, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 11, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 12, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 13, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 14, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 15, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 16, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 17, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 18, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 19, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop'),
	('{"identifier":"government","name":"Government"}', 20, 0, '{"forsale":true,"value":1000000}', '{"lighter":100,"fanta":720,"sprite":571,"cocacola":200,"radio":963,"water":300,"cigarett":3000,"marabou":321,"macka":300,"chips":513,"phone":943}', 'Shop');
/*!40000 ALTER TABLE `owned_shops` ENABLE KEYS */;

-- Dumping structure for table phoenix.owned_vehicles
CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `owner` varchar(60) NOT NULL,
  `plate` varchar(50) NOT NULL,
  `vehicle` longtext NOT NULL,
  `stored` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'State of the vehicle',
  `type` varchar(10) NOT NULL DEFAULT 'car',
  `job` varchar(50) DEFAULT 'personal',
  `garage` varchar(200) DEFAULT 'A',
  `storedhouse` int(11) NOT NULL,
  `gloveboxitems` longtext DEFAULT NULL,
  `trunkitems` longtext DEFAULT NULL,
  PRIMARY KEY (`plate`),
  KEY `vehsowned` (`owner`),
  KEY `carOwner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table phoenix.owned_vehicles: ~0 rows (approximately)
/*!40000 ALTER TABLE `owned_vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `owned_vehicles` ENABLE KEYS */;

-- Dumping structure for table phoenix.phone_messages
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `messages` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`),
  KEY `number` (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.phone_messages: ~0 rows (approximately)
/*!40000 ALTER TABLE `phone_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_messages` ENABLE KEYS */;

-- Dumping structure for table phoenix.player_contacts
CREATE TABLE IF NOT EXISTS `player_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `iban` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.player_contacts: ~0 rows (approximately)
/*!40000 ALTER TABLE `player_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_contacts` ENABLE KEYS */;

-- Dumping structure for table phoenix.player_mails
CREATE TABLE IF NOT EXISTS `player_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinyint(4) DEFAULT 0,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.player_mails: ~0 rows (approximately)
/*!40000 ALTER TABLE `player_mails` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_mails` ENABLE KEYS */;

-- Dumping structure for table phoenix.playlists
CREATE TABLE IF NOT EXISTS `playlists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.playlists: ~2 rows (approximately)
/*!40000 ALTER TABLE `playlists` DISABLE KEYS */;
INSERT INTO `playlists` (`id`, `label`) VALUES
	(74, 'https://dl.my-ahangha.ir/up/2021/Sepehr+Khalse+-+Yakuza.mp3'),
	(75, 'https://dl.my-ahangha.ir/up/2021/Sepehr+Khalse+-+Yakuza.mp3');
/*!40000 ALTER TABLE `playlists` ENABLE KEYS */;

-- Dumping structure for table phoenix.playlist_songs
CREATE TABLE IF NOT EXISTS `playlist_songs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playlist` int(11) DEFAULT NULL,
  `link` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.playlist_songs: ~6 rows (approximately)
/*!40000 ALTER TABLE `playlist_songs` DISABLE KEYS */;
INSERT INTO `playlist_songs` (`id`, `playlist`, `link`) VALUES
	(26, 0, 'https://www.youtube.com/watch?v=EYAjqqWuBxg'),
	(28, 0, 'https://www.youtube.com/watch?v=yXeJ8ZRActM'),
	(30, 54, 'https://www.youtube.com/watch?v=CYgDUBH2Zro'),
	(33, 54, 'https://www.youtube.com/watch?v=L3wKzyIN1yk'),
	(34, 0, 'https://www.youtube.com/watch?v=3MBQGGzDB_U'),
	(35, 14, 'https://www.youtube.com/watch?v=3MBQGGzDB_U');
/*!40000 ALTER TABLE `playlist_songs` ENABLE KEYS */;

-- Dumping structure for table phoenix.twitter_tweets
CREATE TABLE IF NOT EXISTS `twitter_tweets` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(50) DEFAULT NULL,
  `lastName` varchar(50) DEFAULT NULL,
  `message` varchar(50) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `time` varchar(50) DEFAULT NULL,
  `picture` varchar(255) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.twitter_tweets: ~0 rows (approximately)
/*!40000 ALTER TABLE `twitter_tweets` DISABLE KEYS */;
/*!40000 ALTER TABLE `twitter_tweets` ENABLE KEYS */;

-- Dumping structure for table phoenix.users
CREATE TABLE IF NOT EXISTS `users` (
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `firstname` varchar(255) COLLATE utf8mb4_bin DEFAULT '',
  `lastname` varchar(255) COLLATE utf8mb4_bin DEFAULT '',
  `money` int(11) DEFAULT NULL,
  `bank` int(11) DEFAULT NULL,
  `permission_level` int(11) DEFAULT NULL,
  `position` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `inventory` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `gender` int(1) DEFAULT 0,
  `skin` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `gang` varchar(255) COLLATE utf8mb4_bin DEFAULT 'nogang',
  `gang_grade` int(2) DEFAULT 0,
  `job` varchar(255) COLLATE utf8mb4_bin DEFAULT 'nojob',
  `job_grade` int(11) DEFAULT 0,
  `status` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `is_dead` tinyint(1) DEFAULT 0,
  `jail` varchar(100) COLLATE utf8mb4_bin DEFAULT '0',
  `dateofbirth` varchar(15) COLLATE utf8mb4_bin DEFAULT NULL,
  `armour` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `tattoos` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `IsBeingCprd` tinyint(1) DEFAULT NULL,
  `comserv` int(3) NOT NULL DEFAULT 0,
  `divisions` longtext COLLATE utf8mb4_bin DEFAULT '[]',
  `iban` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `pincode` int(50) DEFAULT NULL,
  `stress` int(3) DEFAULT 0,
  `phone` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `profilepicture` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `background` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `callsign` varchar(50) COLLATE utf8mb4_bin DEFAULT '0',
  `salary` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`),
  KEY `playerName` (`firstname`(191)),
  KEY `tattoos` (`tattoos`(191)),
  KEY `is_dead` (`is_dead`),
  KEY `skin` (`skin`(191)),
  KEY `inventory` (`inventory`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Dumping data for table phoenix.users: ~1 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`identifier`, `license`, `firstname`, `lastname`, `money`, `bank`, `permission_level`, `position`, `inventory`, `gender`, `skin`, `gang`, `gang_grade`, `job`, `job_grade`, `status`, `is_dead`, `jail`, `dateofbirth`, `armour`, `tattoos`, `IsBeingCprd`, `comserv`, `divisions`, `iban`, `pincode`, `stress`, `phone`, `profilepicture`, `background`, `callsign`, `salary`) VALUES
	('steam:110000144c6a3b8', 'license:4dc27c69be7c3e3bc675f50c31f2de620ad5a91b', 'Rony', 'Collins', 500, 3950, 10, '{"z":34.26698684692383,"x":1855.53515625,"y":3682.7412109375}', '[{"slot":1,"count":1,"name":"phone","type":"item","info":""},{"slot":2,"count":1,"name":"id-card","type":"item","info":{"firstname":"Rony","identifier":"steam:110000144c6a3b8","lastname":"Collins"}},{"slot":3,"count":5,"name":"water","type":"item","info":""},{"slot":4,"count":5,"name":"macka","type":"item","info":""},{"slot":5,"count":1,"name":"weapon_assaultrifle_mk2","type":"weapon","info":{"serie":"47Vpd4Vp475VpdO","quality":100,"ammo":60}},{"slot":6,"count":8,"name":"rifle-ammo","type":"item","info":""},{"slot":7,"count":1,"name":"mask","type":"item","info":{"number":4,"color":1}}]', 0, '{"ageing":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"accessory":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"bag":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"lipstick":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"arms":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"shoes":{"defaultItem":1,"texture":0,"defaultTexture":0,"item":0},"eyebrows":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"glass":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"decals":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"ear":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"blush":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"mask":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"watch":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"beard":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"pants":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"makeup":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"hair":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"vest":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"torso2":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"t-shirt":{"defaultItem":1,"texture":0,"defaultTexture":0,"item":4},"bracelet":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"hat":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"face":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0}}', 'Military', 10, 'police', 11, '[{"name":"hunger","val":771000,"percent":77.10000000000001},{"name":"thirst","val":828250,"percent":82.825},{"name":"health","val":100,"percent":100},{"name":"armor","val":0,"percent":0}]', 0, '0', '04/13/22', 0, NULL, NULL, 0, '[]', '786', NULL, 8, '0690277777', NULL, NULL, '0', 0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Dumping structure for table phoenix.user_convictions
CREATE TABLE IF NOT EXISTS `user_convictions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) DEFAULT NULL,
  `offense` varchar(255) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.user_convictions: ~0 rows (approximately)
/*!40000 ALTER TABLE `user_convictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_convictions` ENABLE KEYS */;

-- Dumping structure for table phoenix.user_licenses
CREATE TABLE IF NOT EXISTS `user_licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(60) COLLATE utf8_persian_ci NOT NULL,
  `owner` varchar(60) COLLATE utf8_persian_ci NOT NULL,
  `status` int(11) DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `type` (`type`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table phoenix.user_licenses: ~0 rows (approximately)
/*!40000 ALTER TABLE `user_licenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_licenses` ENABLE KEYS */;

-- Dumping structure for table phoenix.user_outfits
CREATE TABLE IF NOT EXISTS `user_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) DEFAULT NULL,
  `skin` text DEFAULT NULL,
  `outfitId` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table phoenix.user_outfits: 0 rows
/*!40000 ALTER TABLE `user_outfits` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_outfits` ENABLE KEYS */;

-- Dumping structure for table phoenix.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `name` varchar(60) COLLATE utf8mb4_persian_ci NOT NULL,
  `model` varchar(60) COLLATE utf8mb4_persian_ci NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) COLLATE utf8mb4_persian_ci DEFAULT NULL,
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_persian_ci;

-- Dumping data for table phoenix.vehicles: ~241 rows (approximately)
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES
	('Adder', 'adder', 600000, 'super'),
	('Akuma', 'AKUMA', 19500, 'motorcycles'),
	('Alpha', 'alpha', 117000, 'sports'),
	('Asea', 'asea', 21000, 'compacts'),
	('Autarch', 'autarch', 567000, 'super'),
	('Avarus', 'avarus', 18000, 'motorcycles'),
	('Bagger', 'bagger', 16500, 'motorcycles'),
	('Baller', 'baller2', 75000, 'suvs'),
	('Baller Sport', 'baller3', 97500, 'suvs'),
	('Banshee', 'banshee', 135000, 'sports'),
	('Banshee 900R', 'banshee2', 180000, 'sports'),
	('Bati 801', 'bati', 19500, 'motorcycles'),
	('Bati 801RR', 'bati2', 22500, 'motorcycles'),
	('Bestia GTS', 'bestiagts', 120000, 'sports'),
	('BF400', 'bf400', 13500, 'motorcycles'),
	('Bf Injection', 'bfinjection', 33000, 'offroad'),
	('Bifta', 'bifta', 36000, 'offroad'),
	('Bison', 'bison', 33000, 'vans'),
	('Blade', 'blade', 21000, 'muscle'),
	('Blazer', 'blazer', 15000, 'offroad'),
	('Blazer Sport', 'blazer4', 18000, 'offroad'),
	('Blista', 'blista', 27000, 'compacts'),
	('BMX (velo)', 'bmx', 4500, 'motorcycles'),
	('Bobcat XL', 'bobcatxl', 102000, 'vans'),
	('Brawler', 'brawler', 60000, 'offroad'),
	('Brioso R/A', 'brioso', 30000, 'compacts'),
	('Btype', 'btype', 142500, 'sportsclassics'),
	('Btype Hotroad', 'btype2', 135000, 'sportsclassics'),
	('Btype Luxe', 'btype3', 285000, 'sportsclassics'),
	('Buccaneer', 'buccaneer', 42000, 'muscle'),
	('Buccaneer Rider', 'buccaneer2', 39000, 'muscle'),
	('Buffalo', 'buffalo', 73500, 'sports'),
	('Buffalo S', 'buffalo2', 94500, 'sports'),
	('Bullet', 'bullet', 297000, 'super'),
	('Burrito', 'burrito3', 72000, 'vans'),
	('Camper', 'camper', 117000, 'vans'),
	('caracara2', 'caracara2', 88500, 'offroad'),
	('Carbonizzare', 'carbonizzare', 117000, 'sports'),
	('Carbon RS', 'carbonrs', 27000, 'motorcycles'),
	('Casco', 'casco', 103500, 'sportsclassics'),
	('Cavalcade', 'cavalcade2', 105000, 'suvs'),
	('Cheetah', 'cheetah', 442500, 'super'),
	('Chimera', 'chimera', 30000, 'motorcycles'),
	('Chino', 'chino', 57000, 'muscle'),
	('Chino Luxe', 'chino2', 37500, 'muscle'),
	('Cliffhanger', 'cliffhanger', 19500, 'motorcycles'),
	('Cognoscenti Cabrio', 'cogcabrio', 70500, 'coupes'),
	('Cognoscenti', 'cognoscenti', 82500, 'sedans'),
	('Comet', 'comet2', 135000, 'sports'),
	('comet3', 'comet3', 135000, 'coupes'),
	('Comet 5', 'comet5', 172500, 'sports'),
	('Contender', 'contender', 135000, 'suvs'),
	('Coquette', 'coquette', 150000, 'sports'),
	('Coquette Classic', 'coquette2', 195000, 'sportsclassics'),
	('Coquette BlackFin', 'coquette3', 69000, 'muscle'),
	('Cruiser (velo)', 'cruiser', 21000, 'motorcycles'),
	('Cyclone', 'cyclone', 510000, 'super'),
	('Daemon', 'daemon', 18000, 'motorcycles'),
	('Daemon High', 'daemon2', 21000, 'motorcycles'),
	('Defiler', 'defiler', 20250, 'motorcycles'),
	('Dominator', 'dominator', 58500, 'muscle'),
	('Double T', 'double', 27000, 'motorcycles'),
	('drafter', 'drafter', 1950000, 'sports'),
	('Dubsta', 'dubsta', 90000, 'suvs'),
	('Dubsta Luxuary', 'dubsta2', 135000, 'suvs'),
	('Bubsta 6x6', 'dubsta3', 193500, 'offroad'),
	('Dukes', 'dukes', 43500, 'muscle'),
	('Dune Buggy', 'dune', 67500, 'offroad'),
	('dynasty', 'dynasty', 195000, 'sportsclassics'),
	('elegy', 'elegy', 195000, 'sports'),
	('Elegy', 'elegy2', 117000, 'sports'),
	('emerus', 'emerus', 675000, 'super'),
	('Emperor', 'emperor', 52500, 'sedans'),
	('Enduro', 'enduro', 16500, 'motorcycles'),
	('Entity XF', 'entityxf', 585000, 'super'),
	('Esskey', 'esskey', 16500, 'motorcycles'),
	('Exemplar', 'exemplar', 51000, 'coupes'),
	('F620', 'f620', 58500, 'coupes'),
	('Faction', 'faction', 40500, 'muscle'),
	('Faction Rider', 'faction2', 42750, 'muscle'),
	('Faction XL', 'faction3', 48000, 'muscle'),
	('Faggio', 'faggio', 9000, 'motorcycles'),
	('Vespa', 'faggio2', 9750, 'motorcycles'),
	('Felon', 'felon', 63000, 'sedans'),
	('Felon GT', 'felon2', 135000, 'sports'),
	('Feltzer', 'feltzer2', 210000, 'sports'),
	('Stirling GT', 'feltzer3', 201000, 'sportsclassics'),
	('Fixter (velo)', 'fixter', 13500, 'motorcycles'),
	('FMJ', 'fmj', 583500, 'super'),
	('Fhantom', 'fq2', 129000, 'suvs'),
	('Fugitive', 'fugitive', 96000, 'sedans'),
	('Furore GT', 'furoregt', 147000, 'sports'),
	('Fusilade', 'fusilade', 147000, 'sports'),
	('Gargoyle', 'gargoyle', 15000, 'motorcycles'),
	('Gauntlet', 'gauntlet', 60000, 'muscle'),
	('Gang Burrito', 'gburrito', 99000, 'vans'),
	('Burrito', 'gburrito2', 73200, 'vans'),
	('Glendale', 'glendale', 70500, 'sedans'),
	('Grabger', 'granger', 90000, 'suvs'),
	('Gresley', 'gresley', 105000, 'suvs'),
	('GT 500', 'gt500', 435000, 'sportsclassics'),
	('Guardian', 'guardian', 109500, 'offroad'),
	('Hakuchou', 'hakuchou', 30000, 'motorcycles'),
	('Hakuchou Sport', 'hakuchou2', 43500, 'motorcycles'),
	('hellion', 'hellion', 135000, 'suvs'),
	('Hermes', 'hermes', 72000, 'muscle'),
	('Hexer', 'hexer', 16500, 'motorcycles'),
	('Hotknife', 'hotknife', 73500, 'muscle'),
	('hotring', 'hotring', 72000, 'muscle'),
	('Huntley S', 'huntley', 120000, 'suvs'),
	('Hustler', 'hustler', 76500, 'muscle'),
	('Infernus', 'infernus', 630000, 'super'),
	('Innovation', 'innovation', 60000, 'motorcycles'),
	('Intruder', 'intruder', 69000, 'sedans'),
	('Issi', 'issi2', 30000, 'compacts'),
	('issi7', 'issi7', 60000, 'compacts'),
	('Jackal', 'jackal', 118500, 'sedans'),
	('Jester', 'jester', 141000, 'sports'),
	('Jester(Racecar)', 'jester2', 240000, 'sports'),
	('Journey', 'journey', 70500, 'vans'),
	('jugular', 'jugular', 195000, 'sports'),
	('Kamacho', 'kamacho', 120000, 'offroad'),
	('Khamelion', 'khamelion', 135000, 'sports'),
	('krieger', 'krieger', 675000, 'super'),
	('Landstalker', 'landstalker', 124500, 'suvs'),
	('RE-7B', 'le7b', 420000, 'super'),
	('Lynx', 'lynx', 180000, 'sports'),
	('Mamba', 'mamba', 139500, 'sports'),
	('Manana', 'manana', 100500, 'sportsclassics'),
	('Manchez', 'manchez', 23550, 'motorcycles'),
	('Massacro', 'massacro', 144000, 'sports'),
	('Massacro(Racecar)', 'massacro2', 135000, 'sports'),
	('Mesa', 'mesa', 70500, 'suvs'),
	('Mesa Trail', 'mesa3', 111000, 'suvs'),
	('Minivan', 'minivan', 88500, 'vans'),
	('Monroe', 'monroe', 201000, 'sportsclassics'),
	('Moonbeam', 'moonbeam', 70500, 'vans'),
	('Moonbeam Rider', 'moonbeam2', 88500, 'vans'),
	('Nemesis', 'nemesis', 14850, 'motorcycles'),
	('neo', 'neo', 525000, 'super'),
	('Neon', 'neon', 168000, 'sports'),
	('Nightblade', 'nightblade', 58500, 'motorcycles'),
	('Nightshade', 'nightshade', 67500, 'muscle'),
	('9F', 'ninef', 240000, 'sports'),
	('9F Cabrio', 'ninef2', 270000, 'sports'),
	('Omnis', 'omnis', 60000, 'coupes'),
	('Oracle XS', 'oracle2', 121500, 'sedans'),
	('Osiris', 'osiris', 510000, 'super'),
	('Panto', 'panto', 28500, 'compacts'),
	('Paradise', 'paradise', 72000, 'vans'),
	('Pariah', 'pariah', 315000, 'sports'),
	('Patriot', 'patriot', 105000, 'suvs'),
	('PCJ-600', 'pcj', 16500, 'motorcycles'),
	('Penumbra', 'penumbra', 97500, 'sports'),
	('Pfister', 'pfister811', 267000, 'sports'),
	('Phoenix', 'phoenix', 67500, 'muscle'),
	('Picador', 'picador', 57000, 'muscle'),
	('Pigalle', 'pigalle', 150000, 'sportsclassics'),
	('Prairie', 'prairie', 42000, 'compacts'),
	('Premier', 'premier', 37500, 'compacts'),
	('Primo Custom', 'primo2', 84000, 'sedans'),
	('X80 Proto', 'prototipo', 600000, 'super'),
	('Radius', 'radi', 45000, 'suvs'),
	('raiden', 'raiden', 195000, 'sports'),
	('Rapid GT', 'rapidgt', 270000, 'sports'),
	('Rapid GT Convertible', 'rapidgt2', 345000, 'sports'),
	('Rapid GT3', 'rapidgt3', 283500, 'sportsclassics'),
	('Reaper', 'reaper', 510000, 'super'),
	('Rebel', 'rebel2', 75000, 'offroad'),
	('Regina', 'regina', 60000, 'sedans'),
	('Retinue', 'retinue', 270000, 'sportsclassics'),
	('riata', 'riata', 105000, 'offroad'),
	('Rocoto', 'rocoto', 105000, 'suvs'),
	('Ruffian', 'ruffian', 16500, 'motorcycles'),
	('Rumpo', 'rumpo', 70500, 'vans'),
	('Sabre Turbo', 'sabregt', 55500, 'muscle'),
	('Sabre GT', 'sabregt2', 55500, 'muscle'),
	('Sanchez', 'sanchez', 16500, 'motorcycles'),
	('Sanchez Sport', 'sanchez2', 22500, 'motorcycles'),
	('Sanctus', 'sanctus', 24000, 'motorcycles'),
	('Sandking', 'sandking', 105000, 'offroad'),
	('SC 1', 'sc1', 480000, 'super'),
	('Schafter', 'schafter2', 100500, 'sedans'),
	('Scorcher (velo)', 'scorcher', 14700, 'motorcycles'),
	('Seminole', 'seminole', 100500, 'suvs'),
	('Sentinel', 'sentinel', 111000, 'sports'),
	('Sentinel XS', 'sentinel2', 133500, 'sports'),
	('Sentinel3', 'sentinel3', 84000, 'coupes'),
	('Seven 70', 'seven70', 180000, 'sports'),
	('ETR1', 'sheava', 375000, 'super'),
	('Shotaro Concept', 'shotaro', 180000, 'motorcycles'),
	('Slam Van', 'slamvan3', 54000, 'muscle'),
	('Sovereign', 'sovereign', 21750, 'motorcycles'),
	('specter2', 'specter', 120000, 'sports'),
	('Stinger', 'stinger', 270000, 'sportsclassics'),
	('Stinger GT', 'stingergt', 225000, 'sportsclassics'),
	('Streiter', 'streiter', 102000, 'offroad'),
	('Stretch', 'stretch', 133500, 'sedans'),
	('Sultan', 'sultan', 84000, 'sports'),
	('Sultan RS', 'sultanrs', 135000, 'sports'),
	('Super Diamond', 'superd', 148500, 'sedans'),
	('Surano', 'surano', 126000, 'sports'),
	('Surfer', 'surfer', 69000, 'vans'),
	('T20', 't20', 750000, 'super'),
	('Tailgater', 'tailgater', 117000, 'sedans'),
	('Tampa', 'tampa', 54000, 'muscle'),
	('Drift Tampa', 'tampa2', 147000, 'sports'),
	('Thrust', 'thrust', 31500, 'motorcycles'),
	('Toros', 'Toros', 360000, 'suvs'),
	('Tri bike (velo)', 'tribike3', 165000, 'motorcycles'),
	('Trophy Truck', 'trophytruck', 120000, 'offroad'),
	('Trophy Truck Limited', 'trophytruck2', 135000, 'offroad'),
	('Tropos', 'tropos', 109500, 'sports'),
	('Turismo R', 'turismor', 600000, 'super'),
	('Tyrus', 'tyrus', 600000, 'super'),
	('Vader', 'vader', 21000, 'motorcycles'),
	('vagner', 'vagner', 600000, 'super'),
	('Verlierer', 'verlierer2', 117000, 'sports'),
	('Vigero', 'vigero', 37500, 'muscle'),
	('Virgo', 'virgo', 22500, 'muscle'),
	('Visione', 'visione', 675000, 'super'),
	('Voltic', 'voltic', 148500, 'sports'),
	('Voodoo', 'voodoo', 85500, 'muscle'),
	('Vortex', 'vortex', 45000, 'motorcycles'),
	('Warrener', 'warrener', 130500, 'sedans'),
	('Washington', 'washington', 69000, 'sedans'),
	('Windsor', 'windsor', 120000, 'coupes'),
	('Windsor Drop', 'windsor2', 118500, 'sedans'),
	('Woflsbane', 'wolfsbane', 27000, 'motorcycles'),
	('xa21', 'xa21', 450000, 'super'),
	('XLS', 'xls', 117000, 'suvs'),
	('Yosemite', 'yosemite', 93000, 'muscle'),
	('Youga', 'youga', 52500, 'vans'),
	('Youga Luxuary', 'youga2', 52500, 'vans'),
	('Z190', 'z190', 285000, 'sportsclassics'),
	('Zentorno', 'zentorno', 900000, 'super'),
	('Zion', 'zion', 133500, 'sports'),
	('Zion Cabrio', 'zion2', 165000, 'sports'),
	('Zombie', 'zombiea', 30750, 'motorcycles'),
	('Zombie Luxuary', 'zombieb', 19500, 'motorcycles'),
	('Z-Type', 'ztype', 400500, 'sportsclassics');
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;

-- Dumping structure for table phoenix.vehicle_categories
CREATE TABLE IF NOT EXISTS `vehicle_categories` (
  `name` varchar(60) COLLATE utf8mb4_persian_ci NOT NULL,
  `label` varchar(60) COLLATE utf8mb4_persian_ci NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_persian_ci;

-- Dumping data for table phoenix.vehicle_categories: ~11 rows (approximately)
/*!40000 ALTER TABLE `vehicle_categories` DISABLE KEYS */;
INSERT INTO `vehicle_categories` (`name`, `label`) VALUES
	('compacts', 'Compacts'),
	('coupes', 'Coupes'),
	('motorcycles', 'Motors'),
	('muscle', 'Muscle'),
	('offroad', 'Off Road'),
	('sedans', 'Sedans'),
	('sports', 'Sports'),
	('sportsclassics', 'Sports Classics'),
	('super', 'Super'),
	('suvs', 'SUVs'),
	('vans', 'Vans');
/*!40000 ALTER TABLE `vehicle_categories` ENABLE KEYS */;

-- Dumping structure for table phoenix.vehicle_mdt
CREATE TABLE IF NOT EXISTS `vehicle_mdt` (
  `dbid` int(11) NOT NULL AUTO_INCREMENT,
  `license_plate` varchar(50) NOT NULL DEFAULT '',
  `stolen` longtext NOT NULL,
  `notes` varchar(255) DEFAULT '{}',
  `image` longtext NOT NULL,
  `code5` longtext NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `info` longtext NOT NULL,
  PRIMARY KEY (`dbid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table phoenix.vehicle_mdt: ~0 rows (approximately)
/*!40000 ALTER TABLE `vehicle_mdt` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_mdt` ENABLE KEYS */;

-- Dumping structure for table phoenix.___mdw_bulletin
CREATE TABLE IF NOT EXISTS `___mdw_bulletin` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `title` longtext NOT NULL,
  `info` longtext NOT NULL,
  `time` varchar(50) NOT NULL DEFAULT '0',
  `src` mediumtext NOT NULL,
  `author` mediumtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.___mdw_bulletin: ~0 rows (approximately)
/*!40000 ALTER TABLE `___mdw_bulletin` DISABLE KEYS */;
/*!40000 ALTER TABLE `___mdw_bulletin` ENABLE KEYS */;

-- Dumping structure for table phoenix.___mdw_incidents
CREATE TABLE IF NOT EXISTS `___mdw_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `author` varchar(100) NOT NULL,
  `time` varchar(100) NOT NULL,
  `details` longtext NOT NULL,
  `tags` longtext NOT NULL,
  `officers` longtext NOT NULL,
  `civilians` longtext NOT NULL,
  `evidence` longtext NOT NULL,
  `associated` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.___mdw_incidents: ~0 rows (approximately)
/*!40000 ALTER TABLE `___mdw_incidents` DISABLE KEYS */;
/*!40000 ALTER TABLE `___mdw_incidents` ENABLE KEYS */;

-- Dumping structure for table phoenix.___mdw_logs
CREATE TABLE IF NOT EXISTS `___mdw_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` longtext NOT NULL,
  `time` mediumtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.___mdw_logs: ~0 rows (approximately)
/*!40000 ALTER TABLE `___mdw_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `___mdw_logs` ENABLE KEYS */;

-- Dumping structure for table phoenix.___mdw_messages
CREATE TABLE IF NOT EXISTS `___mdw_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` varchar(255) NOT NULL DEFAULT 'police',
  `name` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `time` varchar(255) DEFAULT NULL,
  `profilepic` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.___mdw_messages: ~0 rows (approximately)
/*!40000 ALTER TABLE `___mdw_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `___mdw_messages` ENABLE KEYS */;

-- Dumping structure for table phoenix.___mdw_profiles
CREATE TABLE IF NOT EXISTS `___mdw_profiles` (
  `idP` int(11) NOT NULL AUTO_INCREMENT,
  `cid` varchar(60) NOT NULL,
  `image` longtext DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `tags` longtext NOT NULL DEFAULT '{}',
  `gallery` longtext NOT NULL DEFAULT '{}',
  PRIMARY KEY (`idP`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.___mdw_profiles: ~0 rows (approximately)
/*!40000 ALTER TABLE `___mdw_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `___mdw_profiles` ENABLE KEYS */;

-- Dumping structure for table phoenix.____mdw_bolos
CREATE TABLE IF NOT EXISTS `____mdw_bolos` (
  `dbid` int(11) NOT NULL AUTO_INCREMENT,
  `title` mediumtext DEFAULT NULL,
  `author` mediumtext DEFAULT NULL,
  `time` mediumtext DEFAULT NULL,
  `license_plate` mediumtext DEFAULT NULL,
  `owner` mediumtext DEFAULT NULL,
  `individual` varchar(60) NOT NULL DEFAULT '',
  `detail` longtext DEFAULT NULL,
  `tags` longtext DEFAULT NULL,
  `gallery` longtext DEFAULT NULL CHECK (json_valid(`gallery`)),
  `officers` longtext DEFAULT NULL,
  PRIMARY KEY (`dbid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.____mdw_bolos: ~0 rows (approximately)
/*!40000 ALTER TABLE `____mdw_bolos` DISABLE KEYS */;
/*!40000 ALTER TABLE `____mdw_bolos` ENABLE KEYS */;

-- Dumping structure for table phoenix.____mdw_reports
CREATE TABLE IF NOT EXISTS `____mdw_reports` (
  `dbid` int(11) NOT NULL AUTO_INCREMENT,
  `title` mediumtext DEFAULT NULL,
  `type` mediumtext DEFAULT NULL,
  `author` mediumtext DEFAULT NULL,
  `time` mediumtext DEFAULT NULL,
  `detail` longtext DEFAULT NULL,
  `tags` longtext DEFAULT '[]',
  `gallery` longtext DEFAULT '[]',
  `officers` longtext DEFAULT '[]',
  `civsinvolved` longtext DEFAULT '[]',
  PRIMARY KEY (`dbid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table phoenix.____mdw_reports: ~0 rows (approximately)
/*!40000 ALTER TABLE `____mdw_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `____mdw_reports` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
