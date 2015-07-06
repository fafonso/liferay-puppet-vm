class db::postgresql(
	$db_user,
    $db_password,
    $db_name,
  ) {



    # Install PostgreSQL 9.3 server from the PGDG repository
    class {'postgresql::globals':
      version             => '9.3',
      manage_package_repo => true,
      encoding            => 'UTF8',
    }->
    class { 'postgresql::server':
      listen_addresses => '*',
      postgres_password => $db_password,
    }->
    postgresql::server::db { $db_name:
      user     => $db_user,
      password => postgresql_password($db_user, $db_password),
    }

    # Install contrib modules
    class { 'postgresql::server::contrib':
      package_ensure => 'present',
    }

}