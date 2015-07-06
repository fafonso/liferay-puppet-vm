class db(
	  $liferay_db,
	  $db_user,
    $db_password,
    $db_name,
  ) {


  if ! ($liferay_db in [ 'mysql', 'postgresql' ]) {
    fail('liferay_db parameter must be mysql or postgresql')
  }

  if ($liferay_db == "postgresql") {
    #Setup Postgres with the required DB
    class { 'db::postgresql':
      db_user     => $db_user,
      db_password => $db_password,
      db_name     => $db_name,
    }

  } else {
    #Setup MySQL with the required DB
    class { 'db::mysql':
      db_user     => $db_user,
      db_password => $db_password,
      db_name     => $db_name,
    }

  }
  
  
}