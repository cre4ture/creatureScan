<?php

// Author: Ulrich Hornung
//         aka creature

  require_once "cS_rights.php";

  function return_error($type, $nr, $msg)
  {
    echo('<error type="'.$type.'" no="'.$nr.'">'.$msg.'</error>');
  }
  
  function write_error($sql_query_result)
  {
    if (!$sql_query_result)
    {
      return_error('mysql', mysql_errno(), mysql_error());
      //echo('<error type="mysql" no="'.mysql_errno().'">'.mysql_error().'</error>');
    }
    return !$sql_query_result;
  }

  $db_connect = 0;   //Zähler für db_login und db_logout!
  $db_link = false;
  function db_login()
  {
    global $mysql_server, $mysql_username, $mysql_password, 
           $mysql_db, $db_connect, $db_link;
    
		$db_connect++;
    if ($db_connect = 1)
    {
      $db_link = mysql_connect($mysql_server, $mysql_username, $mysql_password);
      
      if ($db_link)
      {
        mysql_query("USE `$mysql_db`", $db_link);
      }
      else
      { 
        echo mysql_error($db_link);
        $db_connect--;
      }
    }
    
    return $db_link;
  }
  
  function db_logout()
  {
    global $db_connect, $db_link;
  
    if ($db_connect > 0) $db_connect--;
    if ($db_connect = 0) 
    {
      mysql_close();
      $db_link = false;
    }
  }
  
  function delete_solsysID($ID)
  {
    global $planet_table, $solsys_table;
  
    $query = "DELETE FROM `$solsys_table` WHERE `ID` = $ID;";
    $sql = mysql_query($query);
    if (!write_error($sql))
    {
  		$query = "DELETE FROM `$planet_table` WHERE `solsysID` = $ID;";
  		$sql = mysql_query($query);
  		if (!write_error($sql))
  		{
        echo("<a>".mysql_affected_rows()." Planeten gelöscht!</a><br/>");
        return True;
        
      } else return False;
    } else return False;
  }
  
  function deleteSys($gala, $sys)
  {
    global $solsys_table;
    
    $query = "SELECT `ID` FROM `$solsys_table` WHERE `gala`=$gala AND `sys`=$sys;";
    $sql = mysql_query($query);
    echo(mysql_error());
    while ($system = mysql_fetch_array($sql, MYSQL_ASSOC))
    {
      echo("<a>System $gala:$sys gefunden: ID=$system[ID]; Löschen!</a><br/>");
      delete_solsysID($system['ID']);
    }
  }
  
  function getreportID($gala, $sys, $pos, $moon = '0', &$time = NULL)
  {
    global $report_table;
    
    $query = "SELECT `ID`, `time` FROM `$report_table` 
              WHERE (`gala`='$gala' AND
                     `sys`='$sys' AND 
                     `pos`='$pos' AND 
                     `moon`='$moon' )
              ORDER BY `time` DESC
              LIMIT 0, 1";
                     
    $sql = mysql_query($query);
    echo(mysql_error());
    
    if ($report = mysql_fetch_array($sql, MYSQL_ASSOC))
		{
		  $time = $report['time'];
		  return $report['ID'];
		} else return false; 
  }
  
  function reportquerytoxml($sql, $tagname)
  {
    if ($line = mysql_fetch_array($sql, MYSQL_ASSOC)) 
  	{
  	  $a = "<$tagname";
      foreach ($line as $key => $value) 
      {
        if (($key != 'reportID')and($value != 0))
        {
          $a = $a.' '.$key.'="'.$value.'"';
        }
      }
      $a = $a.'/>';
      return $a;
    } else return false;
  }
  
  function getreport_xml($ID)
  {
    global $report_table, $report_resources_table, $report_fleets_table,
		  $report_defence_table, $report_buildings_table, $report_research_table;
    
    
    $query = "SELECT * FROM `$report_table` WHERE `ID`=$ID";
    $sql = mysql_query($query);
    echo(mysql_error());
    
    if ($report = mysql_fetch_array($sql, MYSQL_ASSOC))
    {
      $r = '<report';
      foreach ($report as $key => $value) 
		  {
		    if ($key != 'ID')
		    {
		      if (($key == 'moon') and ($value == 1)) { $value = 'true'; }
		      if (($value != '0') and ("$value" != '')) { $r = $r.' '.$key.'="'.$value.'"';}
		      
		    }
      }
      
      $s = NULL;

      $sql = mysql_query("SELECT * FROM `$report_resources_table` 
																	 WHERE `reportID`='$ID'");
      echo (mysql_error());
      $s = $s.reportquerytoxml($sql, $report_resources_table);    
      
      $sql = mysql_query("SELECT * FROM `$report_fleets_table`
			                             WHERE `reportID`='$ID'");
      echo (mysql_error());
      $s = $s.reportquerytoxml($sql, $report_fleets_table);    
      
      $sql = mysql_query("SELECT * FROM `$report_defence_table` 
			                             WHERE `reportID`='$ID'");
      echo (mysql_error());
      $s = $s.reportquerytoxml($sql, $report_defence_table);    
      
      $sql = mysql_query("SELECT * FROM `$report_buildings_table` 
			                             WHERE `reportID`='$ID'");
      echo (mysql_error());
      $s = $s.reportquerytoxml($sql, $report_buildings_table); 
      
      $sql = mysql_query("SELECT * FROM `$report_research_table` 
			                             WHERE `reportID`='$ID'");
      echo (mysql_error());
      $s = $s.reportquerytoxml($sql, $report_research_table); 

      if ($s == ' ') 
			{ $r = $r.'/>'; }
			else { $r = $r.'>'.$s.'</report>'; }

      return $r;
    } else return False;
  }
  
  function getsys_xml($pos)
  {
    global $planet_table, $solsys_table, $mysql_db;
    
    if (db_login())
    {
      mysql_query("USE $mysql_db");
  	  
  	  $query = "SELECT * FROM `$solsys_table` WHERE `gala` = $pos[0] AND `sys` = $pos[1] ORDER BY `time` DESC LIMIT 0, 1 ";
  	  $sql = mysql_query($query);
  	  
  	  if (!write_error($sql))
  	  {
  	    $s = querytoxmlsys($sql);
  	  }
  	  
  	  db_logout();
  	  
  	  return $s;
    }
  }
  
  function querytoxmlsys($sql_query_result)
  {
    global $planet_table, $solsys_table, $mysql_db;
    
    $s = '';
    
    while ($sys = mysql_fetch_array($sql_query_result, MYSQL_ASSOC))  //alle systeme!
    {
      $s = $s."<solsys";
      foreach ($sys as $key => $value) 
  		{
         if (($key != 'ID')and($key != 'timestamp')) $s = $s.' '.$key.'="'.$value.'"';
      }
       
      $sql = mysql_query("SELECT * FROM `$planet_table` WHERE `solsysID`='$sys[ID]' ORDER BY `pos` ASC ");
      if (!write_error($sql))
      {
        $p = 0;
        while ($planeten = mysql_fetch_array($sql, MYSQL_ASSOC)) 
    	 	{ 
    	 	  if ($p == 0) $s = $s.">";  //ende vom <system tag_anfang
    	 	  
    	 	  $s = $s."<planet";
          foreach ($planeten as $key => $value) 
    	    {
            if (($key != 'solsysID')and($value != NULL)) $s = $s.' '.$key.'="'.$value.'"';
          }
          $s = $s."/>";
            
          $p++;
          }
          if ($p == 0) { $s = $s."/>"; } else { $s = $s."</solsys>"; } //ende vom <system tag
        }
        return $s;
      }
  }
  
?>