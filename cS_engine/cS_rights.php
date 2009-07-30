<?php 
  require_once "lib_creax.php";
  require_once "cS_engine.php";
  require_once "config.php";

  $range = "1=1"; // Überbleibsel....
  
  ini_set('session.use_cookies', '0');
  session_name("cSsid");
  session_start();
  
  if (!isset($_SESSION['first']))
  {
    $_SESSION['first'] = true;
    $_SESSION['ip'] = $_SERVER['REMOTE_ADDR'];
    echo "<sessionid restricted_ip=\"".$_SERVER['REMOTE_ADDR']."\">".session_id()."</sessionid>";
  }
  else
    $_SESSION['first'] = false;
    
  if (!isset($_SESSION['username']))
  {
    // not logged in
    if (ign_udef_index($_POST,'action') == 'login')
    {
      $user = mysql_escape_string(ign_udef_index($_POST,'username'));
      $pass = mysql_escape_string(ign_udef_index($_POST,'password'));
    
      $link = db_login();
      
      $sql = "SELECT `username` 
              FROM `users` 
              WHERE (
                    `username` = '$user'
                    AND `password` = MD5('$pass')
                    )";
                    
      $ret = mysql_query($sql, $link);
      if ($ret)
      {
        $row = mysql_fetch_assoc($ret);
        if (ign_udef_index($row,'username') != '')
        {
          $_SESSION['username'] = $row['username'];
          echo "<acknowledge>login successful</acknowledge>";
          
        } else exit('<error type="login">Login failed</error>');
      } else exit('<error type="login">Login failed</error>');
      
      db_logout();
    }
    else exit('<error type="login">You are not logged in</error>');
  }    
  else
  {
    if ($_SESSION['ip'] != $_SERVER['REMOTE_ADDR'])
      exit('your ip changed, please login again!');
  }
  
  echo "<msg>loginname: ".$_SESSION['username']."</msg>";
  
  if (ign_udef_index($_POST,'action') == 'logout')
  {
    if (session_destroy())
      echo "<acknowledge>logout successfull</acknowledge>";
    else
      echo "<error type=\"login\">logout failed</error>";
      
    exit("");
  }
   
?>