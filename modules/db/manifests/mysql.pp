class db::mysql(
	$db_user,
    $db_password,
    $db_name,
  ) {

	$override_options = {
      'mysqld' => {
        'symbolic-links' => '0',
      }
    }

    class { '::mysql::server':
      root_password           => $db_password,
      remove_default_accounts => true,
      override_options        => $override_options,
      restart                 => true,
      package_name            => 'mysql-server-5.6',
    } 
    
    class {'mysql::client':
      package_name   => 'mysql-client-5.6',
    }

    mysql::db { $db_name :
      user     => $db_user,
      password => $db_password,
      host     => 'localhost',
      charset  => 'utf8',
      collate  => 'utf8_general_ci',
    }

}