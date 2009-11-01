<?php

require_once "config.php";

$formname = "cSengine_".$universe;

?>

<form action="cS.php" name="<?php echo $formname; ?>" method="get">
username: <br>
<input id="gala" name="username" value="" type="text"/><br>
password: <br>
<input id="sys" name="password" value="" type="password"/><br>
<input id="ok" name="action" value="login" type="submit"/>
</form>
