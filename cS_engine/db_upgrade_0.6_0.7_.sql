
--
-- Table structure for table `planet`
--

ALTER TABLE `planet` CHANGE `tfmet` `tfmet` BIGINT( 20 ) UNSIGNED NULL DEFAULT NULL ,
CHANGE `tfcrys` `tfcrys` BIGINT( 20 ) UNSIGNED NULL DEFAULT NULL;
ALTER TABLE `planet` ADD `activity` INT NULL DEFAULT NULL AFTER `name`;
ALTER TABLE `planet` ADD `playerid` BIGINT UNSIGNED NULL DEFAULT NULL AFTER `player`;
ALTER TABLE `planet` ADD `allianceid` BIGINT UNSIGNED NULL DEFAULT NULL AFTER `alliance`;

--
-- Table structure for table `report`
--

ALTER TABLE `report` ADD `playerid` BIGINT UNSIGNED NULL DEFAULT NULL AFTER `player`;

--
-- Table structure for table `resources`
--

ALTER TABLE `resources` CHANGE `met` `met` BIGINT( 20 ) UNSIGNED NULL DEFAULT '0',
CHANGE `crys` `crys` BIGINT( 20 ) UNSIGNED NULL DEFAULT '0',
CHANGE `deut` `deut` BIGINT( 20 ) UNSIGNED NULL DEFAULT '0';

--
-- Table structure for table `rank`
--

CREATE TABLE `rank` (
  `statsID` bigint(20) NOT NULL,
  `pos` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `points` bigint(20) NOT NULL,
  `nameid` bigint(20) NOT NULL,
  `alliance` varchar(255) default NULL,
  `members` int(11) default NULL,
  PRIMARY KEY  (`statsID`,`pos`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `stats`
--

CREATE TABLE `stats` (
  `ID` bigint(20) unsigned NOT NULL auto_increment,
  `partnr` int(10) unsigned NOT NULL,
  `count` int(11) NOT NULL,
  `ntype` varchar(255) NOT NULL,
  `ptype` varchar(255) NOT NULL,
  `time` bigint(20) NOT NULL,
  `timestamp` bigint(20) NOT NULL,
  `uploader` varchar(255) NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;