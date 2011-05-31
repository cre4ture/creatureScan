-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 31, 2011 at 11:00 AM
-- Server version: 5.0.67
-- PHP Version: 5.2.14

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `cS_engine`
--

-- --------------------------------------------------------

--
-- Table structure for table `buildings`
--

CREATE TABLE `buildings` (
  `reportID` bigint(20) unsigned NOT NULL default '0',
  `buildings` tinyint(1) unsigned NOT NULL default '0',
  `metm` int(10) unsigned default '0',
  `crysm` int(10) unsigned default '0',
  `deuts` int(10) unsigned default '0',
  `solp` int(10) unsigned default '0',
  `fusp` int(10) unsigned default '0',
  `robot` int(10) unsigned default '0',
  `nani` int(10) unsigned default '0',
  `shipy` int(10) unsigned default '0',
  `mets` int(10) unsigned default '0',
  `crys` int(10) unsigned default '0',
  `dtank` int(10) unsigned default '0',
  `rlab` int(10) unsigned default '0',
  `terra` int(10) unsigned default '0',
  `allydep` int(10) unsigned default '0',
  `silo` int(10) unsigned default '0',
  `lunb` int(10) unsigned default '0',
  `phalanx` int(10) unsigned default '0',
  `jumpg` int(10) unsigned default '0',
  PRIMARY KEY  (`reportID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `defence`
--

CREATE TABLE `defence` (
  `reportID` bigint(20) unsigned NOT NULL default '0',
  `defence` tinyint(1) unsigned NOT NULL default '0',
  `msl` int(10) unsigned default '0',
  `sl` int(10) unsigned default '0',
  `hl` int(10) unsigned default '0',
  `gaus` int(10) unsigned default '0',
  `ion` int(10) unsigned default '0',
  `pc` int(10) unsigned default '0',
  `ssd` int(10) unsigned default '0',
  `lsd` int(10) unsigned default '0',
  `abm` int(10) unsigned default '0',
  `inter` int(10) unsigned default '0',
  PRIMARY KEY  (`reportID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `fleets`
--

CREATE TABLE `fleets` (
  `reportID` bigint(20) unsigned NOT NULL default '0',
  `fleets` tinyint(1) unsigned NOT NULL default '0',
  `scs` int(10) unsigned default '0',
  `lcs` int(10) unsigned default '0',
  `lf` int(10) unsigned default '0',
  `hf` int(10) unsigned default '0',
  `cru` int(10) unsigned default '0',
  `bs` int(10) unsigned default '0',
  `cs` int(10) unsigned default '0',
  `recy` int(10) unsigned default '0',
  `esp` int(10) unsigned default '0',
  `bomb` int(10) unsigned default '0',
  `solsat` int(10) unsigned default '0',
  `destr` int(10) unsigned default '0',
  `rip` int(10) unsigned default '0',
  `bcru` int(10) unsigned default '0',
  PRIMARY KEY  (`reportID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `planet`
--

CREATE TABLE `planet` (
  `pos` smallint(5) unsigned NOT NULL default '0',
  `moon` smallint(5) unsigned default NULL,
  `mtemp` float default NULL,
  `tfmet` bigint(20) unsigned default NULL,
  `tfcrys` bigint(20) unsigned default NULL,
  `name` varchar(25) default NULL,
  `player` varchar(25) default NULL,
  `playerid` bigint(20) unsigned default NULL,
  `alliance` varchar(10) default NULL,
  `allianceid` bigint(20) unsigned default NULL,
  `flags` smallint(5) unsigned default NULL,
  `solsysID` bigint(20) unsigned NOT NULL default '0',
  PRIMARY KEY  (`pos`,`solsysID`),
  KEY `solsysID` (`solsysID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

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

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE `report` (
  `ID` bigint(20) unsigned NOT NULL auto_increment,
  `gala` smallint(5) unsigned NOT NULL default '0',
  `sys` smallint(5) unsigned NOT NULL default '0',
  `pos` smallint(5) unsigned NOT NULL default '0',
  `moon` tinyint(1) NOT NULL default '0',
  `time` bigint(20) unsigned NOT NULL default '0',
  `planet` varchar(25) NOT NULL default '',
  `player` varchar(25) default NULL,
  `playerid` bigint(20) unsigned default NULL,
  `activ` int(11) NOT NULL default '0',
  `cspio` tinyint(4) NOT NULL default '0',
  `creator` varchar(25) default NULL,
  `timestamp` bigint(20) unsigned NOT NULL default '0',
  `uploader` varchar(25) NOT NULL default '',
  PRIMARY KEY  (`ID`),
  UNIQUE KEY `gala` (`gala`,`sys`,`pos`,`moon`,`time`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `research`
--

CREATE TABLE `research` (
  `reportID` bigint(20) unsigned NOT NULL default '0',
  `research` tinyint(1) unsigned NOT NULL default '0',
  `spiot` int(4) unsigned default NULL,
  `comput` int(4) unsigned default NULL,
  `weapt` int(4) unsigned default NULL,
  `shieldt` int(4) unsigned default NULL,
  `armourt` int(4) unsigned default NULL,
  `energt` int(4) unsigned default NULL,
  `hypt` int(4) unsigned default NULL,
  `combut` int(4) unsigned default NULL,
  `impe` int(4) unsigned default NULL,
  `hype` int(4) unsigned default NULL,
  `lasert` int(4) unsigned default NULL,
  `iont` int(4) unsigned default NULL,
  `plasmat` int(4) unsigned default NULL,
  `intergal` int(4) unsigned default NULL,
  `expedt` int(4) unsigned default NULL,
  `gravi` int(4) unsigned default NULL,
  PRIMARY KEY  (`reportID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE `resources` (
  `reportID` bigint(20) unsigned NOT NULL default '0',
  `resources` tinyint(1) unsigned NOT NULL default '0',
  `met` bigint(20) unsigned default '0',
  `crys` bigint(20) unsigned default '0',
  `deut` bigint(20) unsigned default '0',
  `energ` int(10) unsigned default '0',
  PRIMARY KEY  (`reportID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `solsys`
--

CREATE TABLE `solsys` (
  `ID` bigint(20) unsigned NOT NULL auto_increment,
  `gala` smallint(6) unsigned NOT NULL default '0',
  `sys` smallint(6) unsigned NOT NULL default '0',
  `time` bigint(20) unsigned NOT NULL default '0',
  `author` varchar(25) NOT NULL default '',
  `timestamp` bigint(20) unsigned NOT NULL default '0',
  `uploader` varchar(25) NOT NULL default '',
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

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

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `username` varchar(25) NOT NULL default '',
  `password` varchar(32) NOT NULL default '',
  PRIMARY KEY  (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

