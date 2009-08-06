<?php

/*

    Project: cS_engine
    File: main communication with cS 
    Author: Ulrich Hornung
    E-mail: hornunguli@gmx.de
    Date: 05.08.2009
    Type: function library (please use "require_once" instead of "include")
    
    Description:
    
    handles requests from creatureScan client.
    
    the only function of interest should be "ibot_exec($xml)"
    
*/

require "config.php";

require_once "simplexmldom.php";
require_once "cS_xml.php";
require_once "cS_sql.php";

function return_error($type, $nr, $msg)
{
  echo('<error type="'.$type.'" no="'.$nr.'">'.$msg.'</error>');
}

function ibot_exec($xml)
{
  if ($root = xmldom_public_parse_xml($xml))
  {
    ibot_private_read_write_handler($root);
  }
  else
    echo "<error>failed parsing XML!</error>";
}

function ibot_private_read_write_handler($root)
{
  global $ibot_taghandler;
  
  foreach($root['children'] as $index => $tag)
  {
    switch ($tag['name'])
    {
      case 'write':
      case 'read':
        echo "<".$tag['name'].">";
      
        if (isset($tag['children']))
        foreach ($tag['children'] as $index => $child)
        {
          if (isset($ibot_taghandler[$tag['name']][$child['name']]))
            $ibot_taghandler[$tag['name']][$child['name']]($child);
          else
            echo "<warning type=\"xml\">unknown tag '".$child['name']."'</warning>";
        }

        echo "</".$tag['name'].">";
        break;
        
      case "maintag":  // sometimes there is a <maintag></maintag> around
        ibot_private_read_write_handler($tag);
        break;
        
      default:
        echo "<warning type=\"xml\">unknown tag '".$tag['name']."'</warning>";
    }          
  }
}

// create tag handler list:

$ibot_taghandler['write'] = Array();
$ibot_taghandler['write']['report'] = 'ibot_private_write_handler_report';
$ibot_taghandler['write']['solsys'] = 'ibot_private_write_handler_solsys';

$ibot_taghandler['read'] = Array();
$ibot_taghandler['read']['report_id'] = 'ibot_private_read_handler_report_id';
$ibot_taghandler['read']['serverinfo'] = 'ibot_private_read_handler_serverinfo';
$ibot_taghandler['read']['reporttimes_gala'] = 'ibot_private_read_handler_reporttimes_gala';
$ibot_taghandler['read']['solsystimes_timestamp'] = 'ibot_private_read_handler_solsystimes_timestamp';
$ibot_taghandler['read']['solsys_pos'] = 'ibot_private_read_handler_solsys_pos';




function ibot_private_write_handler_report($tag)
{
  $report = cSxml_sxml_to_report($tag);
  if ($report)
  {
    if (!cSsql_add_new_report($report))
    {
      echo "<error type=\"sql\">failed adding report</error>";
    }
  }
  else echo "<error type=\"xml\">failed reading report</error>";
}

function ibot_private_write_handler_solsys($tag)
{
  $solsys = cSxml_sxml_to_solsys($tag);
  if ($solsys)
  {
    if (!cSsql_add_new_solsys($solsys))
    {
      echo "<error type=\"sql\">failed adding solsys</error>";
    }
  }
  else echo "<error type=\"xml\">failed reading solsys</error>";
}

function ibot_private_read_handler_report_id($tag)
{ 
  if (isset($tag['attrs']['id']))
  {
    $xmlcode = xmldom_public_generate_xml(cSxml_report_to_sxml(
                                cSsql_get_report_by_id($tag['attrs']['id'])));
    if ($xmlcode)
      echo $xmlcode;
    else 
      echo "<error type=\"sql\">failed gettig report_id</error>";
  }
  else echo "<error type=\"xml\">erroneous report_id request</error>";
}

function ibot_private_read_handler_serverinfo($tag)
{
  global $universe, $pos_count;
  
  echo '<serverinfo universe="'.$universe.'"'.
         ' time="'.time().'"'.
         ' csvers="0.6" galacount="'.$pos_count[0].'"'.
         ' syscount="'.$pos_count[1].'"'.
         ' planetcount="'.$pos_count[2].'"/>';
}

function ibot_private_read_handler_reporttimes_gala($tag)
{
  // in my opinion, here it is much faster if we don't go throug "sxml-dom"
  // and additionally it's clearly to see what is done.

  if (isset($tag['attrs']['gala']))
  {
    $gala = $tag['attrs']['gala'];
    
    $times = cSsql_get_report_times_gala($gala);
    
    //print_r($times);
    
    $moon_translate['0'] = 'false';
    $moon_translate[''] = 'false';
    $moon_translate['false'] = 'false';
    $moon_translate['1'] = 'true';
    $moon_translate['true'] = 'true';
    
    if (is_Array($times))
    {
      echo "<reporttimes gala=\"$gala\">";
      foreach($times as $sys => $planets)
      {
        foreach($planets as $pos => $planet_moon)
        {
          foreach($planet_moon as $moon => $report_time_list)
          {
            echo '<planet sys="'.$sys.'" pos="'.$pos.'" moon="'.$moon_translate[$moon].'">'; 
            foreach($report_time_list as $index => $info)
            {
              echo '<reporttime time="'.$info['time'].'" id="'.$info['id'].'"/>';
            }
            echo '</planet>';
          }
        }
      }
      echo "</reporttimes>";
    }
    else echo "<error type=\"sql\">failed get reporttimes list</error>";
  }
  else echo "<error type=\"xml\">erroneous reporttimes_gala request</error>";
}

function ibot_private_read_handler_solsystimes_timestamp($tag)
{
  $from = ign_udef_index($tag['attrs'],'from');
  $to = ign_udef_index($tag['attrs'],'to');
  
  $times = cSsql_get_solsys_times_timestamp($from, $to);
  
  if (is_array($times))
  {
    echo "<solsystimes_timestamp>";
    foreach($times as $gala => $solsyslist)
    {
      foreach($solsyslist as $sys => $time)
      {
        echo '<solsystime gala="'.$gala.'" sys="'.$sys.'" 
                          time="'.$time.'"/>';
      }
    }
    echo "</solsystimes_timestamp>";
  }
  else echo "<error type=\"sql\">failed get solsystimes list</error>";
}

function ibot_private_read_handler_solsys_pos($tag)
{
  $gala = $tag['attrs']['gala'];
  $sys = $tag['attrs']['sys'];
  
  $solsys = cSsql_solsys_get_by_pos($gala, $sys);
  if ($solsys)
  {
    echo xmldom_public_generate_xml(cSxml_solsys_to_sxml($solsys));
  }
  else echo "<error type=\"sql\">failed get solsys at [$gala:$sys]</error>";
}

?>