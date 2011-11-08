<?php

// Author: Ulrich Hornung
//         aka creature

function startElement_write($parser, $name, $attrs) 
{
  $name = strtolower($name);
  $attrs = array_change_key_case($attrs, CASE_LOWER);
  
  echo "<$name>";

  switch ($name)
	{
    case "solsys":
      $_SERVER['xml_solsys']['head'] = Array(); 
      $head = &$_SERVER['xml_solsys']['head'];
      $head['gala'] = $attrs['gala'];
      $head['sys'] = $attrs['sys'];
      $head['time'] = $attrs['time'];
      if (isset($attrs['author'])) $head['author'] = $attrs['author'];
			break; 
			
		case "planet":
		  if (isset($_SERVER['xml_solsys']))
		  {
		    $_SERVER['xml_solsys']['planets'][$attrs['pos']] = Array();
		    $planet = &$_SERVER['xml_solsys']['planets'][$attrs['pos']];
		    
		    /*$planet['moon'] = $attrs['moon'];
		    $planet['mtemp'] = $attrs['mtemp'];
		    $planet['tfmet'] = $attrs['tfmet'];
		    $planet['tfcrys'] = $attrs['tfcrys'];
		    $planet['name'] = $attrs['name'];
		    $planet['player'] = $attrs['player'];
		    $planet['alliance'] = $attrs['alliance'];
		    $planet['flags'] = $attrs['flags'];*/
		    
		    $planet = $attrs;
		  
		  } else echo '<error type="xml">Tag "planet" hier falsch!!</error>';
			break;
			
		case "report":
		    $_SERVER['xml_report']['head'] = Array(); 
        $_SERVER['xml_report']['body'] = Array();
        $head = &$_SERVER['xml_report']['head'];   
        
		    $moon_translate['0'] = '0';
        $moon_translate[''] = '0';
        $moon_translate['false'] = '0';
        $moon_translate['1'] = '1';
        $moon_translate['true'] = '1';
		    
		    $attrs['moon'] = $moon_translate[ign_udef_index($attrs,'moon')];
		    
		    $head = $attrs;
	
		    xml_set_element_handler($parser, "startElement_write_report", "endElement_write_report");
		  break;
		  
    default:
      return_error('xml',0,'startElement_write: unexcepted tag: '.$name); 
      break;
  }
}

function endElement_write($parser, $name) 
{
  global $xml_parser;
  
  $name = strtolower($name);
  
  switch ($name)
	{
    case "solsys": 
      if (isset($_SERVER['xml_solsys']))
      {
        add_new_solsys($_SERVER['xml_solsys']);							             
        unset($_SERVER['xml_solsys']);
      }
      break;
      
    case 'write':
      xml_set_element_handler($xml_parser, "startElement", "endElement");
      break;
  }

  echo "<$name>";
}

function startElement_write_report($parser, $name, $attrs)
{
  $name = strtolower($name);
  $attrs = array_change_key_case($attrs, CASE_LOWER);
  
  echo "<$name>";
  
  if (isset($_SERVER['xml_report']))
  {
    $body = &$_SERVER['xml_report']['body'];
    $body[$name] = $attrs;
  }
  else echo '<error type="xml_report">no head tag ... !?!?!?</error>';
} 

function endElement_write_report($parser, $name)
{
  $name = strtolower($name);
  
  if ($name == 'report')
  {
    add_new_report($_SERVER['xml_report']);
    unset($_SERVER['xml_report']);
    
    xml_set_element_handler($parser, "startElement_write", "endElement_write");
  }

  echo "</$name>";
}

function startElement_read($parser, $name, $attrs) 
{
  global $xmltmp, $solsys_table, $range, $pos_count, $report_table, $universe;
  
  $name = strtolower($name);
  $attrs = array_change_key_case($attrs, CASE_LOWER);

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
    
 
    
  
  case 'solsystimes_gala':
    $gala = mysql_escape_string($attrs['gala']);
    $query = "SELECT `sys` , MAX(`time`) time 
              FROM $solsys_table
              WHERE (`gala` = '$gala')
              GROUP BY `sys`
              ORDER BY `sys` ASC";

    $sql = mysql_query($query);
    if (!write_error($sql))
    {
      echo '<queryinfo count="'.mysql_num_rows($sql).'"/>';;
      while ($sys = mysql_fetch_array($sql, MYSQL_ASSOC))  
      {
        echo '<solsystime sys="'.$sys['sys'].'" time="'.$sys['time'].'" />';
      }
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
  }
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

  echo "<$name>";
}

function GoXML($xml) 
{ 
	  if ($sqllink = db_login())
    {
      global $xml_parser;
      
      $xml_parser = xml_parser_create('UTF-8');
      xml_set_element_handler($xml_parser, "startElement", "endElement");
      
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
      
    } else echo('<error type="db_login">Connection to db failed!</error>');
}
?> 