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

// function libraries
require_once "config.php";
require_once "cS_sql.php";

// get all $_POST data as single stream
$data = explode(';', file_get_contents('db_structure.sql'));

// connect to database
cSsql_db_login();

// execute sql
foreach ($data as $sql)
{
  mysql_unbuffered_query($sql);
}

// disconnect from database
cSsql_db_logout();


?>