<?php


require "cS_rights.php";

require_once "lib_creax.php";
require_once "config.php";
require_once "cS_engine.php";
require_once "cS_xml.php";

//echo ($_POST["xml"]);

$data = file_get_contents('php://input');

$pos = strpos($data,'&xml=');
$data = substr($data, $pos + 5);

if (isset($_POST["xml"]))
{
  //GoXML(stripslashes($_POST["xml"]));
  GoXML($data);
}

?>