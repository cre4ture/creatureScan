<?php

// Author: Ulrich Hornung
//         aka creature

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
    $sql1 = $sql1.' `'.$key."`";
    $sql2 = $sql2." '".$value."'";
    $first = false;
  }
  $query = "INSERT INTO `$table` ($sql1) VALUES ($sql2);";
  return $query;
}

?>