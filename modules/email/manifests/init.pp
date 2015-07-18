class email(
	  $mail_server,
    $mail_server_port,
    $mail_http_port,
  ) {


  if ! ($mail_server in [ 'mailcatcher' ]) {
    fail('email server parameter must be mailcatcher')
  }

  if ($mail_server == "mailcatcher") {
    #Setup mailcatcher
    class { 'email::mailcatcher':
      mail_server_port => $mail_server_port,
      mail_http_port   => $mail_http_port,
    }

  } 
  
  
}