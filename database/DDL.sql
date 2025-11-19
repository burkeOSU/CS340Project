-- #############################
-- RESET Database
-- #############################
DROP PROCEDURE IF EXISTS sp_ResetDatabase;
DELIMITER //

CREATE PROCEDURE sp_ResetDatabase()
BEGIN

-- NewGen Security Management System (NSMS) Database
-- Group 18
-- Fern Burke
-- Sean Nugent
-- Blake Carls

-- --------------------------------------------------------

-- Disable foreign key checks and commits
SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- --------------------------------------------------------

-- --------------------------------------------------------
-- TABLE STRUCTURES
-- --------------------------------------------------------

--
-- Table structure for table `Megacorporations`
--

DROP TABLE IF EXISTS `Megacorporations`;
CREATE TABLE `Megacorporations` (
  `megacorp_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `industry` varchar(60) NOT NULL,
  PRIMARY KEY (`megacorp_id`),
  UNIQUE KEY `megacorp_id` (`megacorp_id`)
);

--
-- Table structure for table `Breaches`
--

DROP TABLE IF EXISTS `Breaches`;
CREATE TABLE `Breaches` (
  `breach_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `date_of_breach` datetime NOT NULL,
  `ongoing` tinyint(4) NOT NULL DEFAULT 0,
  `hack_type` varchar(60) DEFAULT NULL,
  `severity_level` varchar(60) DEFAULT NULL,
  `success` tinyint(4) NOT NULL DEFAULT 0,
  `Megacorporations_megacorp_id` int(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`breach_id`),
  UNIQUE KEY `breach_id` (`breach_id`),
  KEY `fk_Breaches_Megacorporations_idx` (`Megacorporations_megacorp_id`),
  CONSTRAINT `fk_Breaches_Megacorporations1`
    FOREIGN KEY (`Megacorporations_megacorp_id`)
    REFERENCES `Megacorporations` (`megacorp_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

--
-- Table structure for table `Assets`
--

DROP TABLE IF EXISTS `Assets`;
CREATE TABLE `Assets` (
  `asset_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `asset_type` varchar(60) NOT NULL,
  `status` varchar(60) NOT NULL,
  `value` decimal(10,2) NOT NULL,
  PRIMARY KEY (`asset_id`),
  UNIQUE KEY `asset_id` (`asset_id`)
);

--
-- Table structure for table `Locations`
--

DROP TABLE IF EXISTS `Locations`;
CREATE TABLE `Locations` (
  `location_id` int(11) NOT NULL AUTO_INCREMENT,
  `lat` decimal(10,8) DEFAULT NULL,
  `long` decimal(11,8) DEFAULT NULL,
  `name` varchar(60) DEFAULT NULL,
  `building_type` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`location_id`),
  UNIQUE KEY `location_id` (`location_id`)
);

--
-- Table structure for table `CyberAgents`
--

DROP TABLE IF EXISTS `CyberAgents`;
CREATE TABLE `CyberAgents` (
  `agent_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(60) DEFAULT NULL,
  `job_title` varchar(60) NOT NULL,
  `hired_by_us` tinyint(4) NOT NULL DEFAULT 0,
  `Locations_location_id` int(11) NOT NULL,
  PRIMARY KEY (`agent_id`),
  UNIQUE KEY `agent_id` (`agent_id`),
  KEY `fk_CyberAgents_Locations_idx` (`Locations_location_id`),
  CONSTRAINT `fk_CyberAgents_Locations1`
    FOREIGN KEY (`Locations_location_id`)
    REFERENCES `Locations` (`location_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- --------------------------------------------------------

--
-- Table structure for intersectional table `AssetsHasBreaches`
--

DROP TABLE IF EXISTS `AssetsHasBreaches`;
CREATE TABLE `AssetsHasBreaches` (
  `Assets_asset_id` int(11) UNSIGNED NOT NULL,
  `Breaches_breach_id` int(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`Assets_asset_id`, `Breaches_breach_id`),
  KEY `fk_AssetsHasBreaches_Assets_idx` (`Assets_asset_id`),
  KEY `fk_AssetsHasBreaches_Breaches_idx` (`Breaches_breach_id`),
  CONSTRAINT `AssetsHasBreaches_ibfk_1`
    FOREIGN KEY (`Assets_asset_id`)
    REFERENCES `Assets` (`asset_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `AssetsHasBreaches_ibfk_2`
    FOREIGN KEY (`Breaches_breach_id`)
    REFERENCES `Breaches` (`breach_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

--
-- Table structure for intersectional table `BreachesHasCyberAgents`
--

DROP TABLE IF EXISTS `BreachesHasCyberAgents`;
CREATE TABLE `BreachesHasCyberAgents` (
  `Breaches_breach_id` int(11) UNSIGNED NOT NULL,
  `CyberAgents_agent_id` int(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`Breaches_breach_id`, `CyberAgents_agent_id`),
  KEY `fk_BreachesHasCyberAgents_Breaches_idx` (`Breaches_breach_id`),
  KEY `fk_BreachesHasCyberAgents_CyberAgents_idx` (`CyberAgents_agent_id`),
  CONSTRAINT `BreachesHasCyberAgents_ibfk_1`
    FOREIGN KEY (`CyberAgents_agent_id`)
    REFERENCES `CyberAgents` (`agent_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `BreachesHasCyberAgents_ibfk_2`
    FOREIGN KEY (`Breaches_breach_id`)
    REFERENCES `Breaches` (`breach_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

--
-- Table structure for intersectional table `MegacorporationsHasLocations`
--

DROP TABLE IF EXISTS `MegacorporationsHasLocations`;
CREATE TABLE `MegacorporationsHasLocations` (
  `Megacorporations_megacorp_id` int(11) UNSIGNED NOT NULL,
  `Locations_location_id` int(11) NOT NULL,
  PRIMARY KEY (`Megacorporations_megacorp_id`, `Locations_location_id`),
  KEY `fk_MegacorporationsHasLocations_Locations_idx` (`Locations_location_id`),
  KEY `fk_MegacorporationsHasLocations_Megacorporations_idx` (`Megacorporations_megacorp_id`),
  CONSTRAINT `MegacorporationsHasLocations_ibfk_1`
    FOREIGN KEY (`Megacorporations_megacorp_id`)
    REFERENCES `Megacorporations` (`megacorp_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `MegacorporationsHasLocations_ibfk_2`
  FOREIGN KEY (`Locations_location_id`)
  REFERENCES `Locations` (`location_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

-- --------------------------------------------------------

-- --------------------------------------------------------
-- DUMPING DATA
-- --------------------------------------------------------

--
-- Dumping data for table `Megacorporations`
--

INSERT INTO `Megacorporations` (`name`, `industry`) VALUES
('NewGen', 'Cloud Tech'),
('FernTech', 'Agriculture'),
('BurnLake', 'Military'),
('Nozama Inc.', 'Logistics'),
('Akasara', 'AI');

--
-- Dumping data for table `Breaches`
--

INSERT INTO `Breaches` (`date_of_breach`, `ongoing`, `hack_type`, `severity_level`, `success`, `Megacorporations_megacorp_id`) VALUES
('2077-12-10 21:43:13', 0, 'Fatal Sys Wipe', 'Red', 1, 1),
('2077-12-24 03:31:52', 0, 'Fatal Sys Wipe', 'Red', 1, 4),
('2078-01-15 15:45:02', 0, 'Penetration Testing', 'Green', 0, 1),
('2078-05-02 17:35:22', 0, 'Fatal Sys Wipe', 'Green', 0, 1),
('2079-11-02 09:15:51', 0, 'Account Breach', 'Yellow', 1, 1),
('2083-04-17 16:42:08', 0, 'Archive Theft', 'Red', 0, 1),
('2087-07-29 23:58:34', 0, 'Archive Theft', 'Red', 0, 1);

--
-- Dumping data for table `Assets`
--

INSERT INTO `Assets` (`name`, `asset_type`, `status`, `value`) VALUES
('Quantum CPU', 'firmware', 'recovered', 56138.00),
('Cybercoin', 'cryptocurrency', 'stolen', 1200000.00),
('Johnny S.', 'sentience', 'stolen', 4200000.00),
('Lucy K.', 'sentience', 'stolen', 4200000.00);

--
-- Dumping data for table `Locations`
--

INSERT INTO `Locations` (`lat`, `long`, `name`, `building_type`) VALUES
(-3.46530000, -62.21590000, 'Nozoma Dataforest', 'server complex'),
(37.23500000, -115.81110000, 'Area 51', 'military complex'),
(35.68120000, 139.76710000, 'Akasara Tower', 'main hq'),
(29.97920000, 31.13420000, 'Roditos factory', 'chip processing plant'),
(51.50070000, -0.12460000, 'Little Larry', 'secret data vault'),
(35.15526209, -90.05205815, 'NewGen Tower', 'Public HQ');

--
-- Dumping data for table `CyberAgents`
--

INSERT INTO `CyberAgents` (`name`, `job_title`, `hired_by_us`, `Locations_location_id`) VALUES
('Jack Pincher', 'Black Hat', 0, 1),
('James Wicke', 'Red Hat', 1, 5),
('Jim Lackey', 'Blue Hat', 1, 1),
('AI Model 1.0', 'Green Hat', 0, 6),
('David Martin', 'Black Hat', 0, 3);

-- --------------------------------------------------------

--
-- Dumping data for intersectional table `AssetsHasBreaches`
--

INSERT INTO `AssetsHasBreaches` (`Assets_asset_id`, `Breaches_breach_id`) VALUES
(1, 1),
(1, 2),
(2, 5),
(3, 6),
(4, 7);

--
-- Dumping data for intersectional table `BreachesHasCyberAgents`
--

INSERT INTO `BreachesHasCyberAgents` (`Breaches_breach_id`, `CyberAgents_agent_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 5),
(7, 5);

--
-- Dumping data for intersectional table `MegacorporationsHasLocations`
--

INSERT INTO `MegacorporationsHasLocations` (`Megacorporations_megacorp_id`, `Locations_location_id`) VALUES
(4, 1),
(1, 5),
(2, 4),
(3, 2),
(5, 3);

-- --------------------------------------------------------

-- Enable foreign key checks and commits, then commit
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

-- --------------------------------------------------------

END //
DELIMITER ;