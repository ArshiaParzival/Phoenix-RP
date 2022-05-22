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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `___mdw_bulletin` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `title` longtext NOT NULL,
  `info` longtext NOT NULL,
  `time` varchar(50) NOT NULL DEFAULT '0',
  `src` mediumtext NOT NULL,
  `author` mediumtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `___mdw_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` longtext NOT NULL,
  `time` mediumtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `___mdw_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` varchar(255) NOT NULL DEFAULT 'police',
  `name` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `time` varchar(255) DEFAULT NULL,
  `profilepic` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `___mdw_profiles` (
  `idP` int(11) NOT NULL AUTO_INCREMENT,
  `cid` varchar(60) NOT NULL,
  `image` longtext DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `tags` longtext NOT NULL DEFAULT '{}',
  `gallery` longtext NOT NULL DEFAULT '{}',
  PRIMARY KEY (`idP`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

ALTER TABLE `users`
	ADD COLUMN `callsign` VARCHAR(50) NULL DEFAULT '0';

ALTER TABLE `user_licenses`
	ADD COLUMN `status` INT(11) NULL DEFAULT 1;
