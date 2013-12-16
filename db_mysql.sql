--
-- MySQL PSA initial database
--


SET FOREIGN_KEY_CHECKS=0;



-- ----------------------------
-- Table structure for `psa_group`
-- ----------------------------
DROP TABLE IF EXISTS `psa_group`;
CREATE TABLE `psa_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Group ID',
  `name` varchar(50) NOT NULL COMMENT 'Group name',
  PRIMARY KEY (`id`),
  UNIQUE KEY `groupname` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of psa_group
-- ----------------------------
INSERT INTO `psa_group` VALUES ('1', 'psa');




-- ----------------------------
-- Table structure for `psa_log`
-- ----------------------------
DROP TABLE IF EXISTS `psa_log`;
CREATE TABLE `psa_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `log_time` datetime DEFAULT NULL COMMENT 'Log creation time',
  `message` text COMMENT 'Log message',
  `client_ip` varchar(40) DEFAULT NULL COMMENT 'Client IP address',
  `user_id` int(11) DEFAULT NULL COMMENT 'User ID',
  `username` varchar(50) DEFAULT NULL COMMENT 'Username',
  `group_id` int(11) DEFAULT NULL COMMENT 'Group ID',
  `groupname` varchar(50) DEFAULT NULL COMMENT 'Group name',
  `function` text COMMENT 'Function, method or debug backtrace that created log',
  `type` varchar(100) DEFAULT NULL COMMENT 'Type of log message',
  `request_uri` varchar(250) DEFAULT NULL,
  `user_agent` varchar(150) DEFAULT NULL,
  `referer` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




-- ----------------------------
-- Table structure for `psa_profile_log`
-- ----------------------------
DROP TABLE IF EXISTS `psa_profile_log`;
CREATE TABLE `psa_profile_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `method` varchar(100) DEFAULT NULL COMMENT 'Action method',
  `method_arguments` text COMMENT 'Arguments passed to the action method. Output of print_r() function.',
  `total_time` float(11,5) DEFAULT NULL COMMENT 'Total execution time of the method in seconds',
  `client_ip` varchar(40) DEFAULT NULL COMMENT 'Client ip address',
  `log_time` datetime DEFAULT NULL COMMENT 'Log creation time',
  `request_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




-- ----------------------------
-- Table structure for `psa_user`
-- ----------------------------
DROP TABLE IF EXISTS `psa_user`;
CREATE TABLE `psa_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'User ID',
  `username` varchar(50) NOT NULL COMMENT 'Username',
  `password` varchar(250) DEFAULT '*' NOT NULL COMMENT 'Password hash',
  `last_login` int(11) DEFAULT NULL COMMENT 'Unix timestamp when user has last logged in.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of psa_user
-- ----------------------------
INSERT INTO `psa_user` VALUES ('1', 'psa', 'a54ed3383c2aa9fc7aa86257ffae23f08b833255d8b20729cf7128c908123749', null);




-- ----------------------------
-- Table structure for `psa_user_in_group`
-- ----------------------------
DROP TABLE IF EXISTS `psa_user_in_group`;
CREATE TABLE `psa_user_in_group` (
  `user_id` int(11) unsigned NOT NULL COMMENT 'User ID',
  `group_id` int(11) unsigned NOT NULL DEFAULT '1' COMMENT 'Group ID',
  PRIMARY KEY (`group_id`,`user_id`),
  KEY `user_id` (`user_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `FK_psa_user_in_group_gid` FOREIGN KEY (`group_id`) REFERENCES `psa_group` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_psa_user_in_group_uid` FOREIGN KEY (`user_id`) REFERENCES `psa_user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of psa_user_in_group
-- ----------------------------
INSERT INTO `psa_user_in_group` VALUES ('1', '1');
