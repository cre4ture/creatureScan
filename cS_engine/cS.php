<?php

// Author: Ulrich Hornung
//         aka creature

ini_set('session.use_trans_sid', '1');


require "cS_rights.php";

require_once "lib_creax.php";
require_once "config.php";
require_once "cS_xml.php";
require_once "cS_language.php";
require_once "cS_sql.php";

cSsql_db_login();


?>

<form action="<? echo $_SERVER['PHP_SELF']; ?>" name="logout" method="post">
<input name="action" value="logout" type="submit"/>
</form>
<form action="<? echo $_SERVER['PHP_SELF']; ?>" name="f" method="post">
solsys: <br />
<input id="gala" name="galaxie" value="<?php echo ign_udef_index($_POST,'galaxie') ?>" />:
<input id="sys" name="system" value="<?php echo ign_udef_index($_POST,'system') ?>" />
<input name="action" value="getsys_html" type="hidden"/>
<input id="ok" name="action" value="getsys_html" type="submit"/>
<input name="action" value="getsys_xml" type="submit"/>
<input name="action" value="reporttimes_gala" type="submit"/>
<input name="system" value="<?php echo (ign_udef_index($_POST,'system',0)-1) ?>" type="submit"/>
<input name="system" value="<?php echo (ign_udef_index($_POST,'system',0)+1) ?>" type="submit"/>
<input name="action" value="deletesys" type="submit"/>
</form>
<form action="<? echo $_SERVER["PHP_SELF"] ?>" name="w" method="post">
<input name="action" value="overview" type="submit"/>
</form>
<style type="text/css">
<!-- 
/* General font families for common tags */
a { font-family: 1px smallfont }
a { text-decoration: none; }
-->
</style>

<?php  
  
  function timetocolor($time)
  {
    $redsecs = 400*60*60;
    // TODO: ACHTUNG ZEITZONEN !?
    $alter = ((time()) - $time); //in sec!
    
    if ($alter > 0)
    {
      $alter = ($alter/$redsecs)*255;

      $r = floor($alter);
			if ($r > 255) $r = 255;
      $g = 255 - $r;
      $b = $g-$r;

      if ($b < 0) $b = -$b;
      $b = 255-$b;
      
      //rgb rückwärts: bgr->
      $color = dechex($b);
      while (strlen($color) < 2) $color = '0'.$color;
      $color = dechex($g).$color;
			while (strlen($color) < 4) $color = '0'.$color;
			$color = dechex($r).$color;
			while (strlen($color) < 6) $color = '0'.$color;
			
			return '#'.$color;
    } else //Zukunft!?
    { return "silver"; }
  }
  
  function solsys_to_html($solsys)
  {
    echo '
          <script type="text/javascript">
      
          function getreport(p1,p2,p3,p4)
      		{
      			document.getElementById("r_gala").value = p1;
      			document.getElementById("r_sys").value = p2;
      			document.getElementById("r_pos").value = p3;
      			document.getElementById("r_moon").value = p4;
      			document.getElementById("r_ok").click();
      		}

		      </script>';
					
    echo '<form action="'.$_SERVER["PHP_SELF"].'" name="report" method="post"> report: <br/>
  	      <input id="r_gala" name="galaxie" value="'.ign_udef_index($_POST,'galaxie').'"/>:
  				<input id="r_sys" name="system" value="'.ign_udef_index($_POST,'system').'"/>:
  				<input id="r_pos" name="r_pos" value="'.ign_udef_index($_POST,'r_pos').'"/>
  				<input id="r_moon" name="r_moon" value="'.ign_udef_index($_POST,'r_moon').'"/>
  				<input id="r_ok" name="action" value="getreport_html" type="submit"/>
  				<input id="r_ok_xml" name="action" value="getreport_xml" type="submit"/>
  				</form><table border=1>';
  				
  	$head = $solsys['head'];
						
    $r1 = "";
    $r2 = "";
    foreach ($head as $key => $value) 
  	{
  	  if ($key == 'time' or $key == 'timestamp')
      {
        $color = 'bgcolor="'.timetocolor($value).'"';
        $value = date("Y-m-d H:i:s", $value);
      }
      else $color = "";
  	
  	  $r1 = $r1."\t\t<td bgcolor='#77AAFF'>$key</td>\n";
      $r2 = $r2."\t\t<td $color >$value</td>\n";
    }
    echo "\t<tr>\n".$r1."\t</tr>\n";
    echo "\t<tr>\n".$r2."\t</tr>\n";
    
    echo '</table><table border=1>';
          
    $i = 0;
    foreach($solsys['planets'] as $pos => $planet) 
  	{
      $r1 = "";
      $r2 = "";
      foreach ($planet as $key => $value) 
	    {
  	    $r1 = $r1."\t\t<td bgcolor='#77AAFF'>$key</td>\n";  
        $r2 = $r2."\t\t<td";
        
        $ID = true;
        if ($key == 'moon')
          $moon = '1';
        else
        if ($key == 'pos')
          $moon = '0';
        else
          $ID = false;
        
        if ($ID) 
          $ID = report_get_id($head['gala'],$head['sys'],$planet['pos'],$moon, $time);
        if ($ID) 
        {
          $r2 = $r2.' bgcolor="'.timetocolor($time).'" 
                      onClick="getreport('.$head['gala'].','.$head['sys'].','.$planet['pos'].','.$moon.');"';
        }
        
        $r2 = $r2.">$value</td>\n";
      }
      
      if ($i == 0) echo "\t<tr>\n".$r1."\t</tr>\n";
      echo "\t<tr>\n".$r2."\t</tr>\n";
      
      $i++;
    }
    echo "</table>";
  }

  
  function overview()
  {
    global $pos_count;
          
    echo '<script type="text/javascript">
          
          function SetPosition(p1,p2)
          {
            document.getElementById("gala").value = p1;
            document.getElementById("sys").value = p2;
          }
          
          function ClickSubmit()
          {
            document.getElementById("ok").click();
          }
          
          </script>';
    
    echo '<a style="font: normal 11px Verdana, Arial, Helvetica, sans-serif;">
		      <table border="0" cellspacing="0" cellpadding="0" bgcolor="black">';
		      
		$uni = cSsql_get_solsys_times_timestamp('','');
		
    for ($y = 1; $y <= $pos_count[0]; $y++) {
      echo '<tr height="1"/><tr height="16">';
      for ($x = 1; $x <= $pos_count[1]; $x++) {
        echo '<td width="5" onMouseOver="SetPosition('.$y.','.$x.')"';
	      if (isset($uni[$y][$x]))
	      {
	        echo ' bgcolor="'.timetocolor($uni[$y][$x]['time']).'" onClick="ClickSubmit();"';
	      } else ;// echo ' bgcolor="#FFFFFF">';
				echo "></td>\r"; 
      }
      echo '</tr>';
    }
    echo '</table></a>';
  }
  
  function sqlquery_report_html($row)
  {
    global $report_group_names, $report_names;
  
    echo "<table>";
    
      echo "<tr><th bgcolor='#77AAFF' colspan='4'>espionage report \"".$row['planet']."\" [".
            $row['gala'].':'.$row['sys'].':'.$row['pos'];
            
      if ($row['moon'] == '1') echo " M";
            
      echo "] </tr><tr>";
      
      echo "<th bgcolor='#77AAFF' colspan='2'>player: ".$row['player']."</th>";
      echo "<th bgcolor='".timetocolor($row['time'])."' colspan='2'>time: ".date("Y-m-d H:i:s", $row['time'])."</th>";

      echo "</tr><tr>";
      
      echo "<th bgcolor='#77AAFF'>activ</th>";
      echo "<th bgcolor='#77AAFF'>cspio</th>";
      echo "<th bgcolor='#77AAFF'>creator</th>";
      echo "<th bgcolor='#77AAFF'>timestamp</th>";
      echo "<th bgcolor='#77AAFF'>uploader</th>";
      
      echo "</tr><tr>";
      
      echo "<td>".$row['activ']."</th>";
      echo "<td>".$row['cspio']."%</th>";
      echo "<td>".$row['creator']."</th>";
      echo "<td>".date("Y-m-d H:i:s", $row['timestamp'])."</th>";
      echo "<td>".$row['uploader']."</th>";
      
      echo "</tr>";
  
      foreach ($report_group_names as $name => $value)
      {
        if ($row[$name] != NULL)
        {
          echo "<tr><th bgcolor='#77AAFF' colspan='4'>".$value."</th></tr><tr>";
          
          $newline = 2;
          foreach ($report_names[$name] as $item => $itemval)
          {
            if ($row[$item] != NULL and $row[$item] != 0)
            {
              $newline += -1;
            
              echo "<td>".$itemval."</td><td align=\"right\">".$row[$item]."</td>";
  
              if ($newline <= 0)
              {
                $newline = 2;
                echo "</tr><tr>";
              }
            }          
          }
          
          echo "</tr>";
        }
      }
    echo "</table>";
  }
  
  function get_report_html($id)
  {
    $sqllink = db_login();
  
    $sql = "SELECT * FROM `report` h 
            LEFT JOIN resources r ON (h.ID = r.reportID)
            LEFT JOIN defence d ON (h.ID = d.reportID)
            LEFT JOIN fleets f ON (h.ID = f.reportID)
            LEFT JOIN buildings b ON (h.ID = b.reportID)
            LEFT JOIN research re ON (h.ID = re.reportID)
            WHERE (h.ID = '$id')";
    
    $res = mysql_query($sql, $sqllink);
    if (!$res) echo mysql_error($sqllink);
    
    if ($row = mysql_fetch_assoc($res))
    {
      sqlquery_report_html($row);
    }
    
    db_logout();
  }
  
  function get_reports_html($p1, $p2, $p3, $p4)
  {
    $sqllink = cSsql_db_login();
  
    $sql = "SELECT * FROM `report` h 
            LEFT JOIN resources r ON (h.ID = r.reportID)
            LEFT JOIN defence d ON (h.ID = d.reportID)
            LEFT JOIN fleets f ON (h.ID = f.reportID)
            LEFT JOIN buildings b ON (h.ID = b.reportID)
            LEFT JOIN research re ON (h.ID = re.reportID)
            WHERE (h.gala = '$p1' AND
                   h.sys = '$p2' AND
                   h.pos = '$p3' AND
                   h.moon= '$p4')
            ORDER BY h.time DESC";
    
    $res = mysql_query($sql, $sqllink);
    if (!$res) echo mysql_error($sqllink);
    
    while ($row = mysql_fetch_assoc($res))
    {
      sqlquery_report_html($row);
    }
    
    cSsql_db_logout();
  }
  
  function report_get_id($gala, $sys, $pos, $moon, &$time = NULL)
  {
    global $sqlconf;
    
    $query = "SELECT `ID`, `time` 
              FROM `".$sqlconf['report_table']."` 
              WHERE (`gala`='$gala' AND
                     `sys`='$sys' AND 
                     `pos`='$pos' AND 
                     `moon`='$moon' )
              ORDER BY `time` DESC
              LIMIT 0, 1";
                     
    $sql = mysql_query($query);
    if (!cSsql_write_error($sql))
    {
      if ($report = mysql_fetch_array($sql, MYSQL_ASSOC))
    	{
    	  $time = $report['time'];
    	  return $report['ID'];
    	} 
      else return false;
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
  
  

  
  function getreport_html($p1, $p2, $p3)
  {
  
    function line_to_html($sql)
    {
       $i = 0;
        while ($line = mysql_fetch_array($sql, MYSQL_ASSOC)) 
	    	{
          $r1 = "";
  	      $r2 = "";
          foreach ($line as $key => $value) 
			    {
		  	    $r1 = $r1."\t\t<td bgcolor='#77AAFF'>$key</td>\n";  
            $r2 = $r2."\t\t<td";
            if ($key == 'pos')
            {
              $ID = getreportID($pos[0],$pos[1],$value);
              if ($ID)
              {
                $r2 = $r2.' bgcolor="red" onClick="getreport('.$pos[0].','.$pos[1].','.$value.');"';
              }
            }
            $r2 = $r2.">$value</td>\n";
          }
          
          if ($i == 0) echo "\t<tr>\n".$r1."\t</tr>\n";
          echo "\t<tr>\n".$r2."\t</tr>\n";
          
          $i++;
        }
    }
    
    db_login();
    
    echo "report on $p1:$p2:$p3";
    $ID = getreportID($p1,$p2,$p3);
    
    global $report_table, $report_resources_table, $report_fleets_table, $report_defence_table, $report_buildings_table, $report_research_table;
    
    echo "<table border=1>";
    
    $query = "SELECT * FROM `$report_table` WHERE `ID`=$ID";
    $sql = mysql_query($query);
    echo(mysql_error());
    
    if ($report = mysql_fetch_array($sql, MYSQL_ASSOC))
    {
      $r1 = '';
      $r2 = '';
      foreach ($report as $key => $value) 
		  {
		    $r1 = $r1."\t\t<td bgcolor='#77AAFF'>$key</td>\n";
        $r2 = $r2."\t\t<td>$value</td>\n";
      }
      echo "\t<tr>\n".$r1."\t</tr>\n";
      echo "\t<tr>\n".$r2."\t</tr>\n";
    }
    
    $sql = mysql_query("SELECT * FROM `$report_resources_table` WHERE `reportID`='$report[ID]'");
    echo (mysql_error());
    line_to_html($sql);    
    
    $sql = mysql_query("SELECT * FROM `$report_fleets_table` WHERE `reportID`='$report[ID]'");
    echo (mysql_error());
    line_to_html($sql);    
    
    $sql = mysql_query("SELECT * FROM `$report_defence_table` WHERE `reportID`='$report[ID]'");
    echo (mysql_error());
    line_to_html($sql);    
    
    $sql = mysql_query("SELECT * FROM `$report_buildings_table` WHERE `reportID`='$report[ID]'");
    echo (mysql_error());
    line_to_html($sql); 
    
    $sql = mysql_query("SELECT * FROM `$report_research_table` WHERE `reportID`='$report[ID]'");
    echo (mysql_error());
    line_to_html($sql); 

    echo "</table>";
    
    db_logout();
  }

  $action = ign_udef_index($_POST,'action');
  $pos[0] = ign_udef_index($_POST,'galaxie',0);
  $pos[1] = ign_udef_index($_POST,'system',0);
  $id = ign_udef_index($_POST,"id");
  
  switch ($action) {
  //funktionen für den Browserzugriff/Test mit Browser!:
  
  case 'getsys_html': 
      solsys_to_html(cSsql_solsys_get_by_id(cSsql_solsys_get_id($pos[0],$pos[1]))); 
			break;
			
  case 'getsys_xml':
	    echo (htmlspecialchars(getsys_xml($pos)));
			break;
	
	case 'overview':
	    overview();
      break;
  
  case 'getreport_html':
      get_reports_html($pos[0], $pos[1], $_POST['r_pos'], $_POST['r_moon']);
      break;
  
  case 'getreport_xml':
      if (db_login())
      {
        $ID = getreportID($pos[0], $pos[1], $_POST['r_pos'], $_POST['r_moon']);
        echo(htmlspecialchars(getreport_xml($ID)));
      }
      break;
    
  case 'reporttimes_gala':
      GoXML('<read><serverinfo/><reporttimes_gala gala="'.$pos[0].'"/></read>');
      break;
      
  case 'deletesys':
      if (db_login())
      {
        deleteSys($pos[0], $pos[1]);
        db_logout();
      }
      break;
	    
	//funktionen für cS:
	case 'xml': GoXML(stripslashes($_POST['xml']));
	    break;
  }
?>