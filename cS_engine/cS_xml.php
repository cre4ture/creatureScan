<?php

// Author: Ulrich Hornung
//         aka creature

function startElement_write($parser, $name, $attrs) 
{
  global $xmltmp;
  global $solsys_table;
  global $planet_table;
  
  $name = strtolower($name);
  $attrs = array_change_key_case($attrs, CASE_LOWER);
  
  echo "<$name>";
  
  switch ($name)
	{
    case "solsys": 
      $pos[0] = $attrs['gala'];
      $pos[1] = $attrs['sys'];
      $time = $attrs['time'];
      
      //Suche nach schon vorhandenen und neueren Solsys!
      $sql = mysql_query("SELECT ID FROM `$solsys_table` 
			                              WHERE `gala`='$pos[0]' 
																		AND `sys`='$pos[1]' 
																		AND `time`>='$time'");
      
      //wenns keinen Fehler in der abfrage gab und kein neures Solsys gefunden wurde
      if ((!write_error($sql))and(!mysql_fetch_array($sql)))  
      {
        $attrs['timestamp'] = time();
        $attrs['uploader'] = $_SESSION['username'];
        $query = array_to_insertquery($solsys_table, $attrs);
			  if (!mysql_query($query))
		    {
  		    echo "<error>".$query." ".mysql_error()."</error>";
		    }
	    	$xmltmp['solsysID'] = mysql_insert_id();
			} else { $xmltmp['solsysID'] = NULL; }
			break;
			
		case "planet":
		  if ($xmltmp['solsysID'] != NULL)
		  {
		    //print_r($attrs);
			  $attrs['solsysID'] = $xmltmp['solsysID'];
			  $query = array_to_insertquery($planet_table,$attrs);
			  //echo $query;
				$sql = mysql_query($query);
				write_error($sql);
		  } 
			break;
		case "report":
		    
		    $moon_translate['0'] = '0';
        $moon_translate[''] = '0';
        $moon_translate['false'] = '0';
        $moon_translate['1'] = '1';
        $moon_translate['true'] = '1';
		    
		    $attrs['moon'] = $moon_translate[ign_udef_index($attrs,'moon')];
		    $attrs['timestamp'] = time();
		    $attrs['uploader'] = $_SESSION['username'];
	
		    $query = array_to_insertquery('report',$attrs);
		    if (!mysql_query($query))
		    {
  		    echo "<error>".$query." ".mysql_error()."</error>";
		    }
		    $xmltmp['reportID'] = mysql_insert_id();
		    xml_set_element_handler($parser, "startElement_write_report", "endElement_write_report");
		  break;
		  
    default:
      return_error('xml',0,'startElement_write: unexcepted tag: '.$name); 
      break;
  }
}

function endElement_write($parser, $name) 
{
  global $xmltmp, $xml_parser;
  
  $name = strtolower($name);
  
  switch ($name)
	{
    case "solsys": 
      $xmltemp['solsysID'] = NULL;
      break;
      
    case 'write':
      xml_set_element_handler($xml_parser, "startElement", "endElement");
      break;
      
/*    default:
      return_error('xml',0,'endElement_write: unexcepted tag: '.$name); 
      break;
*/
  }
  echo "</$name>";
}

function startElement_read($parser, $name, $attrs) 
{
  global $xmltmp, $solsys_table, $range, $pos_count, $report_table, $universe;
  
  $name = strtolower($name);
  $attrs = array_change_key_case($attrs, CASE_LOWER);
  
  //echo "<$name>";
  
  switch ($name) {
  case 'solsys_pos':
    $pos[0] = $attrs['gala'];
    $pos[1] = $attrs['sys'];
    echo(getsys_xml($pos));
    break; 
    
  case 'solsys_timestamp':
    $from = $attrs['from'];
    $to = $attrs['to'];
    $query = "SELECT * FROM $solsys_table WHERE $range AND `timestamp`>='$from' AND `timestamp`<='$to'";
    $sql = mysql_query($query);
    if (!write_error($sql))
    {
      echo "<count>".mysql_num_rows($sql)."</count>";
      echo (querytoxmlsys($sql));
    }
    break;
    
  case 'solsys_id':  //nur versuchsweise
    $id = $attrs['id'];
    $query = "SELECT * FROM $solsys_table WHERE $range AND `id`=$id";
    echo $query;
    $sql = mysql_query($query);
    echo (mysql_error());
    echo (querytoxmlsys($sql));
    break;
    
  case 'report_id':
    $id = $attrs['id'];
    if ($s = getreport_xml($id))
    {
      echo $s;
    }
    else
    {
      return_error('report_request',0,'failed sending report with id '.$id);
    }
    break;
    
  case 'serverinfo':  //abfragen der uni-konstanten!
    echo '<serverinfo universe="'.$universe.'"'.
         ' time="'.time().'"'.
         ' csvers="0.6" galacount="'.$pos_count[0].'"'.
         ' syscount="'.$pos_count[1].'"'.
         ' planetcount="'.$pos_count[2].'"/>';
    break;
    
  case 'solsystimes_timestamp':
    $from = ign_udef_index($attrs,'from');
    $to = ign_udef_index($attrs,'to');
    $query = "SELECT `gala` , `sys` , `time` FROM $solsys_table WHERE $range";
		if ($from != '') $query = $query." AND `timestamp`>='$from'";
		if ($to != '') $query = $query." AND `timestamp`<='$to'";
    //echo $query;
    $sql = mysql_query($query);
    if (!write_error($sql))
    {
      echo '<queryinfo count="'.mysql_num_rows($sql).'" />';;
      while ($sys = mysql_fetch_array($sql, MYSQL_ASSOC))  
      {
        echo '<solsystime gala="'.$sys['gala'].'" sys="'.$sys['sys'].'" time="'.$sys['time'].'" />';
      }
    }
    break;
    
  case 'reporttimes_gala':
    $gala = $attrs['gala'];
    $query = "SELECT id, sys, pos, moon, time
              FROM `$report_table`
              WHERE (gala = '$gala')
              ORDER BY sys ASC, pos ASC, moon ASC, time DESC";
    
    $sql = mysql_query($query);
    if (!write_error($sql))
    {
      //echo '<queryinfo count="'.mysql_num_rows($sql).'"/>';
      
      $moon_translate['0'] = 'false';
      $moon_translate[''] = 'false';
      $moon_translate['false'] = 'false';
      $moon_translate['1'] = 'true';
      $moon_translate['true'] = 'true';
      
      $sys = 0;
      $pos = 0;
      echo "<reporttimes gala=\"$gala\">";
      while ($report = mysql_fetch_array($sql, MYSQL_ASSOC))  
      {
        if ($report['sys'] != $sys or 
            $report['pos'] != $pos or
            $report['moon'] != $moon )
        {
          if ($pos != 0) echo '</planet>';
          $sys = $report['sys'];
          $pos = $report['pos'];
          $moon = $report['moon'];
          echo '<planet sys="'.$sys.'" pos="'.$pos.'" moon="'.$moon_translate[$moon].'">'; 
        }
        
        echo '<reporttime time="'.$report['time'].'" id="'.$report['id'].'"/>';
      }
      if ($sys != 0) echo '</planet>';
      echo "</reporttimes>";
      
    }
    break; 
    
    default:
      return_error('xml',0,'startElement_read: unexcepted tag: '.$name); 
      break;
  }
}

function endElement_read($parser, $name) 
{
  global $xmltmp;
  
  $name = strtolower($name);
  
  switch ($name)
	{
    case 'read':
      echo "</$name>";
      xml_set_element_handler($parser, "startElement", "endElement");
      break;
    
/*    default:
      return_error('xml',0,'endElement_read: unexcepted tag: '.$name); 
      break;
*/  }
  //echo "</$name>";
}

function startElement($parser, $name, $attrs)
{  
  $name = strtolower($name);
  $attrs = array_change_key_case($attrs, CASE_LOWER);
  
  echo "<$name>";
  
  switch ($name) {
  case 'write': 
    xml_set_element_handler($parser, "startElement_write", "endElement_write");
    break;
  case 'read':
    xml_set_element_handler($parser, "startElement_read", "endElement_read");
    break;
  }
} 

function endElement($parser, $name)
{
  $name = strtolower($name);
  
  echo "</$name>";
}

function startElement_write_report($parser, $name, $attrs)
{
  global $xmltmp;
  
  $name = strtolower($name);
  $attrs = array_change_key_case($attrs, CASE_LOWER);
  
  echo "<$name>";

  $attrs['reportID'] = $xmltmp['reportID'];  //ID mit in insert-query!
  if (isset($attrs['moon']) and ($attrs['moon'] == 'true')) $attrs['moon'] = 1;
  $query = array_to_insertquery($name, $attrs);
  $sql = mysql_query($query);
  write_error($sql);
} 

function endElement_write_report($parser, $name)
{
  global $xmltmp;
  $name = strtolower($name);
  
  if ($name == 'report')
  {
    $xmltmp['reportID'] = NULL;
    xml_set_element_handler($parser, "startElement_write", "endElement_write");
  }
  echo "</$name>";
}

function GoXML($xml) 
{ 
    global  $mysql_db;
    
    //echo "<function>GoXML</function>";
	  if (db_login())
    {
      global $xml_parser;
      
      mysql_query("USE $mysql_db");
      
      $xml_parser = xml_parser_create('UTF-8');
      xml_set_element_handler($xml_parser, "startElement", "endElement");
      
      //echo "xml->".($xml)."<-xml";
      
      if (!xml_parse($xml_parser, html_entity_decode($xml), TRUE))
			{
         echo('<error type="xml">');
				 echo(sprintf("XML error: %s at line %d",
              xml_error_string(xml_get_error_code($xml_parser)),
              xml_get_current_line_number($xml_parser)));
         echo('</error>');
      }
        
      xml_parser_free($xml_parser);
      
      db_logout();
    } /* mysql_connect */ else echo('<error type="db_login">Connection to db failed!</error>');
}
?> 