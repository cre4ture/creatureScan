<?php

/*

    Project: cS_engine
    File: front end
    Author: Ulrich Hornung
    E-mail: hornunguli@gmx.de
    Date: 05.08.2009
    Type: front end, directly link creatureScan to it
    
    Description:
    
    last wrapper of whole cS_engine project.
    creatureScan must be linked to this file!
    
*/


// right management
require "cS_rights.php";

// function libraries
require_once "cS_sql.php";
require_once "cS_bot_interface.php";

// get all $_POST data as single stream
$data = file_get_contents('php://input'); // hier kein urldecode!!!!

// connect to database
cSsql_db_login();

// do all work
ibot_exec($data);

// disconnect from database
cSsql_db_logout();

?>