class vmbuilder(
    $db_user              = "liferay",
    $db_password          = "D3P4ssw0rd",
    $db_name              = "lportal",
    $timzone              = "Europe/Dublin",
    $liferay_user         = "liferay",
    $liferay_group        = "www",
    $install_path         = "/opt/liferay",
    $liferay_db           = "mysql",
    $liferay_zip_filename = "liferay-portal-tomcat-6.2-ce-ga4-20150416163831865.zip",
    $liferay_folder       = "liferay-portal-6.2-ce-ga4",
    $liferay_cluster      = false,
    $xmx                  = "1024",
    $permsize             = "256",
    $use_firewall         = false,
    $httpserver           = "apache2",
    $java_distribution    = "oracle",
  ) {
  

  #Unix configurations
  include hosts

  class { 'groups' :
    liferay_group => $liferay_group,
  }

  class { 'users' :
    liferay_user      => $liferay_user,
    liferay_group     => $liferay_group,
    liferay_user_home => $install_path,
  }

  #Configuring ntp module
  include '::ntp'

  #Setting the proper timezone
  class { 'timezone':
      timezone => $timzone,
  }

  #Updating APT
  class { 'apt':
    update => {
      frequency => 'daily',
    }
  }

  #Setup Java distribution
  class {'javad' :
    distribution => $java_distribution,
  }

  #Setup BD (default mysql)
  class { 'db':
    db_user     => $db_user,
    db_password => $db_password,
    db_name     => $db_name,
    liferay_db  => $liferay_db,
  }

  #Setup Liferay

  class { 'liferay' :
    db_user              => $db_user,
    db_password          => $db_password,
    db_name              => $db_name,
    install_path         => $install_path, 
    liferay_user         => $liferay_user,
    liferay_group        => $liferay_group,
    liferay_cluster      => $liferay_cluster,
    liferay_zip_filename => $liferay_zip_filename,
    liferay_folder       => $liferay_folder,
    xmx                  => $xmx,
    permsize             => $permsize,
    liferay_db           => $liferay_db,
    require              => [
      Class['java'], 
      Class['users'],
      Class['db'],
    ],
  }

  #Setup httpserver (default apache2)
  class {'httpserver' :
    httpserver => $httpserver,
    cluster    => $liferay_cluster,
    require    => [
      Class['apt'], 
      Class['liferay'],
    ],
  }

  #Setup firewall
  if ($use_firewall) {
    class {'iptables' :
      cluster => $liferay_cluster,
    }
  }




}