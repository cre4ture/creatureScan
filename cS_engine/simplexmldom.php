<?php

/*

    Project: cS_engine
    File: simpleXML-DOM-Engine
    Author: Ulrich Hornung
    E-mail: hornunguli@gmx.de
    Date: 05.08.2009
    Type: function library (please use "require_once" instead of "include")
    
    Description:
    
    use the function xmldom_public_parse_xml() to convert your valid xml-string
    or string-array into an multi-dimensional php-array.
    for the exact structure of the return value, please test it with some test-
    values und analyse the result with print_r().
    
    use the function xmldom_public_generate_xml() to generate the xmlcode from
    a php-array again
    
*/


$xmldom_global = Array(); // initialise our namespace

function xmldom_public_generate_xml($sxml_tag)
{
  if (!$sxml_tag) return false;

  if (!isset($sxml_tag['type'])) // if a new tag
  {
    if (isset($sxml_tag['name']))
    {
      // tag start
      $result = '<'.$sxml_tag['name'];
      
      // attributes
      if (isset($sxml_tag['attrs']))
      foreach($sxml_tag['attrs'] as $name => $value)
      {
        $result .= ' '.$name.'="'.$value.'"';  
      }
    }
    
    // children / content
    $content = '';
    if (isset($sxml_tag['children']))
    foreach($sxml_tag['children'] as $value)
    {
      $content .= xmldom_public_generate_xml($value);
    }
    
    if (isset($sxml_tag['name']))
    {
      // tag end
      if ($content == '')
        $result .= '/>';
      else
        $result .= '>'.$content.'</'.$sxml_tag['name'].'>';
  
      return $result;
    }
    else return $content;  
  }
  else // if something else
  {
    switch ($sxml_tag['type']) {
      case "character_data":
      case "default":
        return $sxml_tag['data'];
        
      case "processing_instruction":
        return '<?'.$sxml_tag['target'].' '.$sxml_tag['data'].'?'.'>';
    }
  }
}

function xmldom_public_parse_xml($xml_code)
{
  global $xmldom_global;
    
  $parser = xml_parser_create('UTF-8');
  
  xml_set_element_handler($parser, "xmldom_private_startElement", 
                                   "xmldom_private_endElement");
  xml_set_character_data_handler($parser, "xmldom_private_character_data");
  xml_set_default_handler($parser, "xmldom_private_default");
  xml_set_processing_instruction_handler($parser, "xmldom_private_processing_instruction");
  
  $xmldom_global[$parser] = Array();
  $root = Array();
  $xmldom_global[$parser]['last'] = &$root;
     
  $xml_code_lines = Array();
  if (!is_array($xml_code))
    $xml_code_lines[0] = $xml_code;
  else
    $xml_code_lines = $xml_code;
   
  $count = count($xml_code_lines);  
  $number = 0; 
  foreach($xml_code_lines as $line => $value)
  { 
    if (!xml_parse($parser, $value, ($count == $number+1)))
  	{
       echo('<error type="xml">');
  		 echo(sprintf("XML error: %s at line %d",
            xml_error_string(xml_get_error_code($parser)),
            xml_get_current_line_number($parser)));
       echo('</error>');
    }
    $number += 1;
  }
    
  xml_parser_free($parser);

  unset($xmldom_global[$parser]);
  return $root;
    
}

function xmldom_private_startElement($parser, $name, $attrs)
{
  global $xmldom_global;
  
  $name = strtolower($name);
  $attrs = array_change_key_case($attrs, CASE_LOWER);
  
  $tag['name'] = $name;
  $tag['attrs'] = $attrs; 
  // $tag['type'] = "element";

  $xmldom_global[$parser]['last']['children'][] = &$tag;
  $tag['parent'] = &$xmldom_global[$parser]['last'];

  $xmldom_global[$parser]['last'] = &$tag; 
}

function xmldom_private_character_data($parser, $data)
{
  $tag['type'] = "character_data";
  $tag['data'] = $data;
  
  $xmldom_global[$parser]['last']['children'][] = &$tag;
}

function xmldom_private_processing_instruction($parser, $target, $data)
{
  $tag['type'] = "processing_instruction";
  $tag['target'] = $target;
  $tag['data'] = $data;
  
  $xmldom_global[$parser]['last']['children'][] = &$tag;
}

function xmldom_private_default($parser, $data)
{
  $tag['type'] = "default";
  $tag['data'] = $data;
  
  $xmldom_global[$parser]['last']['children'][] = &$tag;
}

/* function xmldom_private_unparsed_entity_decl
  ($parser, $entity_name, $base, $system_id, $public_id, $notation_name)
{
  $tag['type'] = "private_unparsed_entity_decl";
  $tag['entity_name'] = $entity_name;
  $tag['base'] = $base;
  $tag['system_id'] = $system_id;
  $tag['public_id'] = $public_id;
  $tag['notation_name'] = $notation_name;
  
  $xmldom_global[$parser]['last']['children'][] = &$tag;
} i hope you see the idea? ... */

function xmldom_private_endElement($parser, $name)
{
  global $xmldom_global;
  
  $name = strtolower($name);
  
  if ($name != $xmldom_global[$parser]['last']['name'])
    exit('XML-ERROR');
  else  
    $xmldom_global[$parser]['last'] = &$xmldom_global[$parser]['last']['parent'];
}

?>
