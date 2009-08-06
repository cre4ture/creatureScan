<?php

/*

    Project: cS_engine
    File: mySQL-Interface
    Author: Ulrich Hornung
    E-mail: hornunguli@gmx.de
    Date: 05.08.2009
    Type: function library (please use "require_once" instead of "include")
    
    Description:
    
    This file handles access to the database.
    If you like to use your own database maybe for your own ogame-tool-page,
    you only have to replace this file, and implement these functions in your 
    own way!

    configure this lib by setting the global variable "sqlconf".
    
*/

// true ^= fehler
function cSsql_write_error($sql_query_result)
{
  if (!$sql_query_result)
  {
    return_error('mysql', mysql_errno(), mysql_error());
    //echo('<error type="mysql" no="'.mysql_errno().'">'.mysql_error().'</error>');
  }
  return !$sql_query_result;
}

$sqlconf['db_connect'] = 0;   //Zähler für db_login und db_logout!
$sqlconf['db_link'] = false;

function cSsql_db_login()
{
  global $sqlconf;
  
	$sqlconf['db_connect']++;
  if ($sqlconf['db_connect'] = 1)
  {
    $sqlconf['db_link'] = mysql_connect($sqlconf['mysql_server'], 
                                        $sqlconf['mysql_username'],
                                        $sqlconf['mysql_password']);
    
    if ($sqlconf['db_link'])
    {
      mysql_query("USE `".$sqlconf['mysql_db']."`", $sqlconf['db_link']);
    }
    else
    { 
      echo mysql_error($sqlconf['db_link']);
      $sqlconf['db_connect']--;
    }
  }
  
  return $sqlconf['db_link'];
}

function cSsql_db_logout()
{
  global $sqlconf;

  if ($sqlconf['db_connect'] > 0) $sqlconf['db_connect']--;
  if ($sqlconf['db_connect'] == 0) 
  {
    mysql_close();
    $sqlconf['db_link'] = false;
  }
}
  

function cSsql_get_report_by_id($id)
{
  global $sqlconf;
  
  if (!$id) return false;
  
  $id = mysql_escape_string($id);
  
  $query = "SELECT *
            FROM `".$sqlconf['report_table']."`
            WHERE (report.ID = '$id')";
  
  $sql = mysql_query($query);
  if (!$sql) exit("SQL: ".mysql_error());
  
  if ($result = mysql_fetch_array($sql, MYSQL_ASSOC))
  {
    $report = Array();
    $report['head'] = $result;
    $report['body'] = Array();
    
    foreach($sqlconf['report_group_table'] as $group => $tablename)
    {   
      $sql = mysql_query("SELECT * FROM `$tablename` 
													WHERE (`reportID`='$id')");														
      if (!$sql) exit("SQL: ".mysql_error());
      
      if ($result = mysql_fetch_array($sql, MYSQL_ASSOC))
        $report['body'][$group] = $result; 
    }

    return $report;
    
  } else return False;
}

function cSsql_add_new_report(&$report)
{
  $head = &$report['head'];
  $body = &$report['body'];
  
  $head['timestamp'] = time();
	$head['uploader'] = $_SESSION['username'];

  // insert report header
  $query = array_to_insertquery('report',$head);
  $sql = mysql_query($query);
  if (!cSsql_write_error($sql))
  {
    // insert scan groups
    $head['id'] = mysql_insert_id(); 
    foreach ($body as $group => $value)
    {
      $value['reportID'] = $head['id'];
      $query = array_to_insertquery($group, $value);
      $sql = mysql_query($query);
      if (cSsql_write_error($sql))
      {
        // error -> delete incomplete report
        cSsql_delete_report_id($head['id']);
        return false;
      } 
    }
  } else return false;
  
  return true;
}

function cSsql_delete_report_id($id) 
{
  global $sqlconf;
  
  $id = mysql_escape_string($id);
  $query = "DELETE FROM `".$sqlconf['report_table']."` WHERE (`ID` = '$id');
            DELETE FROM `".$sqlconf['report_group_table']['resources']."` WHERE (`reportID` = '$id');
            DELETE FROM `".$sqlconf['report_group_table']['fleets']."` WHERE (`reportID` = '$id');
            DELETE FROM `".$sqlconf['report_group_table']['defence']."` WHERE (`reportID` = '$id');
            DELETE FROM `".$sqlconf['report_group_table']['buildings']."` WHERE (`reportID` = '$id');
            DELETE FROM `".$sqlconf['report_group_table']['research']."` WHERE (`reportID` = '$id');";
            
  $sl = explode(';',$query);
  foreach ($sl as $key => $line)
  { 
    if ($line != '')
    {  
      $sql = mysql_query($line);
      cSsql_write_error($sql);
    }
  }
}

function cSsql_add_new_solsys(&$solsys)
{
  global $sqlconf;

  $head = &$solsys['head'];
  $planets = &$solsys['planets'];   

  $head['timestamp'] = time();
  $head['uploader'] = $_SESSION['username'];
  
  $gala = mysql_escape_string($head['gala']);
  $sys = mysql_escape_string($head['sys']);
  $time = mysql_escape_string($head['time']);
  
  $sql = mysql_query("SELECT `ID` 
                      FROM `".$sqlconf['solsys_table']."` 
                      WHERE `gala` = '$gala' 
											AND `sys` = '$sys' 
											AND `time` >= '$time'
                      LIMIT 0, 1");
	
  if ((!cSsql_write_error($sql))and
      (!($ret = mysql_fetch_assoc($sql))))
  {
    // insert solsys-header
    $query = array_to_insertquery($sqlconf['solsys_table'], $head);
		$sql = mysql_query($query);
		if (!cSsql_write_error($sql))
    {
      // insert planets
      $head['id'] = mysql_insert_id();
      foreach ($planets as $key => $value)
      {
        $value['pos'] = $key;
        $value['solsysID'] = $head['id'];
        $query = array_to_insertquery($sqlconf['solsys_planet_table'], $value);
				$sql = mysql_query($query);
				if (cSsql_write_error($sql))
        {
          // error -> delete incomplete solsys
          cSsql_delete_solsys_id($head['id']);
          return false;
        }
      }     
    } else return false;        
  } else return false;
  
  return true;  
}

function cSsql_delete_solsys_id($id)
{
  global $sqlconf;
  
  $id = mysql_escape_string($id);
  $query = "DELETE FROM `".$sqlconf['solsys_table']."` WHERE (`ID` = '$id');
            DELETE FROM `".$sqlconf['solsys_planet_table']."` WHERE (`solsysID` = '$id');";
            
  $sl = explode(';',$query);
  foreach ($sl as $key => $line)
  { 
    if ($line != '')
    {  
      $sql = mysql_query($line);
      cSsql_write_error($sql);
    }
  }
}

function cSsql_private_get_solsys_from_query($query)
{
  global $sqlconf;
  
  $sql = mysql_query($query);
  if (!cSsql_write_error($sql))
  {
    $row = mysql_fetch_assoc($sql);
    
    $solsys = Array();
    $solsys['head'] = $row;
    $solsys['planets'] = Array();
    
    $query = "SELECT * 
              FROM `".$sqlconf['solsys_planet_table']."` 
              WHERE `solsysID`='".$solsys['head']['ID']."' 
              ORDER BY `pos` ASC ";
    
    $sql = mysql_query($query);
    if (!cSsql_write_error($sql))
    {
      while ($planet = mysql_fetch_assoc($sql)) 
      {
        $solsys['planets'][$planet['pos']] = $planet;
      }
    }
    return $solsys;
    
  } return false;
}

function cSsql_solsys_get_by_pos($gala, $sys)
{
  global $sqlconf;
  
  $gala = mysql_escape_string($gala);
  $sys = mysql_escape_string($sys);
  
  $query = "SELECT *
            FROM `".$sqlconf['solsys_table']."`
            WHERE (
                   gala = '$gala' AND
                   sys = '$sys'
                  )
            ORDER BY `time` DESC
            LIMIT 0, 1";
  
  return cSsql_private_get_solsys_from_query($query); 
}

function cSsql_get_report_times_gala($gala)
{
  global $sqlconf;
  
  $gala = mysql_escape_string($gala);
  $query = "SELECT id, sys, pos, moon, time
              FROM `".$sqlconf['report_table']."`
              WHERE (gala = '$gala')
              ORDER BY sys ASC, pos ASC, moon ASC, time DESC";
  $sql = mysql_query($query);
  
  $result = false;
  if (!cSsql_write_error($sql))
  {
    $result = Array();
    while ($report = mysql_fetch_array($sql, MYSQL_ASSOC))  
    {
      $info['time'] = $report['time'];
      $info['id'] = $report['id'];
    
      $result[$report['sys']]
        [$report['pos']][$report['moon']][] = $info;
    }
  }
  return $result;
}

function cSsql_get_solsys_times_timestamp($from, $to)
{
  global $sqlconf;
  
  $query = "SELECT `gala` , `sys` , max(`time`) time 
            FROM ".$sqlconf['solsys_table']." 
            WHERE ( 1=1";
	if ($from != '') 
    $query .= " AND `timestamp`>='".mysql_escape_string($from)."'";
	if ($to != '') 
    $query .= " AND `timestamp`<='".mysql_escape_string($to)."'";
  $query .= " ) 
            GROUP BY gala, sys";
            
  //echo $query;
  
  $sql = mysql_query($query);
  $result = false;
  if (!cSsql_write_error($sql))
  {
    $result = Array();
    while ($solsys = mysql_fetch_array($sql, MYSQL_ASSOC))  
    {
      $result[$solsys['gala']][$solsys['sys']] = $solsys['time'];
    }
  }
  return $result;
}

// ------------ OPTIONAL -------------------------------------------------------
// | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
// V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V


function cSsql_solsys_get_id($gala, $sys)
{
  global $sqlconf;
  
  $gala = mysql_escape_string($gala);
  $sys = mysql_escape_string($sys);
  
  $query = "SELECT `id`
            FROM `".$sqlconf['solsys_table']."` 
            WHERE (
                   gala = '$gala' AND
                   sys = '$sys'
                  )
            ORDER BY `time` DESC
            LIMIT 0, 1";
            
  $ret = mysql_query($query);
  if (!cSsql_write_error($ret))
  {
    $id = mysql_fetch_assoc($ret);
    return $id['id'];
  }
  else return false;
}

function cSsql_solsys_get_by_id($id)
{
  global $sqlconf;
  
  $id = mysql_escape_string($id);
  
  $query = "SELECT * 
            FROM `".$sqlconf['solsys_table']."` 
            WHERE `id` = '$id'";
            
  return cSsql_private_get_solsys_from_query($query); 
}


?>