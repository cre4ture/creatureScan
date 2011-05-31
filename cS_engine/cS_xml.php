<?php

/*

    Project: cS_engine
    File: simpleXML-DOM - Interface
    Author: Ulrich Hornung
    Date: 05.08.2009
    Type: function library (please use "require_once" instead of "include")
    
    Description:
    
    this file converts xml structures to "normal" cS_engine structures
    and vice versa
    
*/

require_once "simplexmldom.php";

/* converts a simplexmldom-structure to a report */
function cSxml_sxml_to_report($xml)
{
  if ($xml['name'] != 'report')
    return false;
    
  $report = Array();
  $report['head'] = $xml['attrs'];
  
  // --
  $moontrans[''] = 0;
  $moontrans['0'] = 0;
  $moontrans[0] = 0;
  $moontrans['false'] = 0;
  $moontrans['true'] = 1;
  $moontrans['1'] = 1;
  $moontrans[1] = 1;
  $report['head']['moon'] = $moontrans[ign_udef_index($report['head'],'moon')];
  // --
  
  $report['body'] = Array();
  foreach ($xml['children'] as $key => $value)
  {
    $report['body'][$value['name']] = $value['attrs'];
  }
  
  return $report;
}

/* converts a report to a simplexmldom-structure */
function cSxml_report_to_sxml($report)
{
  if (!$report) return false;

  // --
  $moontrans[''] = '';
  $moontrans['0'] = '';
  $moontrans[0] = '';
  $moontrans['false'] = '';
  $moontrans['true'] = 'true';
  $moontrans['1'] = 'true';
  $moontrans[1] = 'true';
  $report['head']['moon'] = $moontrans[ign_udef_index($report['head'],'moon')];
  // --
  
  $xml['name'] = 'report';
  $xml['attrs'] = cSxml_private_remove_zero($report['head']);
  $xml['children'] = Array();
  
  foreach ($report['body'] as $key => $value)
  {
    $child = Array();
    $child['name'] = $key;
    $child['attrs'] = cSxml_private_remove_zero($value);
    $child['parent'] = &$xml;
    
    $xml['children'][] = $child;
  }
  
  return $xml;
}

/* converts a simplexmldom-structure to a solsys */
function cSxml_sxml_to_solsys($xml)
{
  if ($xml['name'] != 'solsys')
    return false;
    
  $solsys = Array();
  $solsys['head'] = $xml['attrs'];
  $solsys['planets'] = Array();

  if (isset($xml['children']))
    foreach ($xml['children'] as $index => $childtag)
    {
      $solsys['planets'][$childtag['attrs']['pos']] = $childtag['attrs'];
    }
  
  return $solsys;
}

/* converts a simplexmldom-structure to a stats-part */
function cSxml_sxml_to_stats($xml)
{
  if ($xml['name'] != 'stats')
    return false;
    
  $stats = Array();
  $stats['head'] = $xml['attrs'];
  $stats['ranks'] = Array();

  if (isset($xml['children']))
    foreach ($xml['children'] as $index => $childtag)
    {
      $stats['ranks'][$childtag['attrs']['pos']] = $childtag['attrs'];
    }
  
  return $stats;
}

/* converts a solsys to a simplexmldom-structure */
function cSxml_solsys_to_sxml($solsys)
{
  $xml['name'] = 'solsys';
  $xml['attrs'] = cSxml_private_remove_zero($solsys['head']);
  $xml['children'] = Array();
  
  foreach ($solsys['planets'] as $pos => $planet)
  {
    if (!isset($planet['pos']))
      $planet['pos'] = $pos;
    else
      if ($planet['pos'] != $pos)
        exit("<error>inconsistent data found (cSxml_solsys_to_sxml)</error>");
  
    $child = Array();
    $child['name'] = 'planet';
    $child['attrs'] = cSxml_private_remove_zero($planet);
    $child['parent'] = &$xml;
    
    $xml['children'][] = $child;
  }
  
  return $xml;
}

/* converts a stats-part to a simplexmldom-structure */
function cSxml_stats_to_sxml($stats)
{
  $xml['name'] = 'stats';
  $xml['attrs'] = cSxml_private_remove_zero($stats['head']);
  $xml['children'] = Array();
  
  foreach ($stats['ranks'] as $pos => $rank)
  {
    if (!isset($rank['pos']))
      $rank['pos'] = $pos;
    else
      if ($rank['pos'] != $pos)
        exit("<error>inconsistent data found (cSxml_stats_to_sxml)</error>");
        
    unset($rank['statsID']);
  
    $child = Array();
    $child['name'] = 'rank';
    $child['attrs'] = cSxml_private_remove_zero($rank);
    $child['parent'] = &$xml;
    
    $xml['children'][] = $child;
  }
  
  return $xml;
}

/* private function, not to use outside this namespace */
/* removes array elements with 0 or '0' or '' values */
function cSxml_private_remove_zero(&$attr_list)
{
  foreach($attr_list as $key => $value)
  {
    if (($value == '0') or 
        ($value == ''))
    {
      unset($attr_list[$key]);
    }    
  }
  
  return $attr_list;
}

function cSxml_sxml_to_highscore($tag)
{
  
}


?>
