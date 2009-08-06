<?php

/*

    Project: cS_engine
    File: lib_creax
    Author: Ulrich Hornung
    E-mail: hornunguli@gmx.de
    Date: 05.08.2009
    Type: function library (please use "require_once" instead of "include")
    
    Description:
    
    other functions...
    
*/

// checks if $name[$index] exists and returns the value or the default
function ign_udef_index(&$name, $index, $default = "")
{
  if (isset($name[$index]))
  {
    return $name[$index];
  }
  else
  {
    return $default;
  }
}

// Creates a INPUT sql-statement from an assoc-array
function array_to_insertquery($table, $attrs)
{  
  $sql1 = '';
  $sql2 = '';
  $first = true;
  foreach ($attrs as $key => $value) {
    if (!$first) {
      $sql1 = $sql1.",";
      $sql2 = $sql2.",";
    }
    $sql1 = $sql1.' `'.mysql_escape_string($key)."`";
    $sql2 = $sql2." '".mysql_escape_string($value)."'";
    $first = false;
  }
  $query = "INSERT INTO `$table` ($sql1) VALUES ($sql2);";
  return $query;
}

?>