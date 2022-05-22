
CREATE TABLE IF NOT EXISTS `playlists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4;


DELETE FROM `playlists`;
/*!40000 ALTER TABLE `playlists` DISABLE KEYS */;
INSERT INTO `playlists` (`id`, `label`) VALUES
	(50, '80s'),
	(51, '90s'),
	(53, 'Metal'),
	(54, 'Random music'),
	(55, 'example');
/*!40000 ALTER TABLE `playlists` ENABLE KEYS */;


CREATE TABLE IF NOT EXISTS `playlist_songs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playlist` int(11) DEFAULT NULL,
  `link` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4;


DELETE FROM `playlist_songs`;
/*!40000 ALTER TABLE `playlist_songs` DISABLE KEYS */;
INSERT INTO `playlist_songs` (`id`, `playlist`, `link`) VALUES
	(26, 0, 'https://www.youtube.com/watch?v=EYAjqqWuBxg'),
	(28, 0, 'https://www.youtube.com/watch?v=yXeJ8ZRActM'),
	(29, 54, 'https://www.youtube.com/watch?v=yXeJ8ZRActM'),
	(30, 54, 'https://www.youtube.com/watch?v=CYgDUBH2Zro'),
	(32, 50, 'https://www.youtube.com/watch?v=CYgDUBH2Zro'),
	(33, 54, 'https://www.youtube.com/watch?v=L3wKzyIN1yk');

