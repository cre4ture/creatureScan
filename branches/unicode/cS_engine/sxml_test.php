<?php

require "simplexmldom.php";

$data = file_get_contents('php://input'); // RAW-Data

$dom = xmldom_public_parse_xml($data);

print_r($dom);

echo xmldom_public_generate_xml($dom);

?>