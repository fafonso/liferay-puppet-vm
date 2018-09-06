class vmbuilder(
    $db_user              = "liferay",
    $db_password          = "D3P4ssw0rd",
    $db_name              = "lportal",
    $timzone              = "Europe/Dublin",
    $liferay_user         = "liferay",
    $liferay_group        = "www",
    $install_path         = "/opt",
    $liferay_db           = "mysql",
    $liferay_zip_filename = "liferay-ce-portal-tomcat-7.1.0-ga1-20180703012531655.zip",
    $liferay_folder       = "liferay-ce-portal-7.1.0-ga1",
    $tomcat_folder        = "tomcat-9.0.6",
    $liferay_version      = "7.1.0%20GA1",
    $xmx                  = "2048",
    $permsize             = "512",
    $use_firewall         = false,
    $httpserver           = "",
    $java_distribution    = "oracle",
    $mail_server          = "",
    $liferay_dev          = false,
    $external_tools       = false,
  ) {

  $liferay_install_path = "${install_path}/liferay"
  
  #Setup and updating APT
  include aptsetup

  #Ensure that we have unzip and wget to use across all the modules
  #Limitation to puppet3
  package {"unzip":
    name   => "unzip",
    ensure => present,
  }

  package {"zip":
    name   => "zip",
    ensure => present,
  }

  package {"wget":
    name   => "wget",
    ensure => present,
  }

  #Unix configurations
  include hosts

  class { 'groups' :
    liferay_group => $liferay_group,
  }

  class { 'users' :
    liferay_user      => $liferay_user,
    liferay_group     => $liferay_group,
    liferay_user_home => $liferay_install_path,
  }

  #Configuring ntp module
  include '::ntp'

  #Setting the proper timezone
  class { 'timezone':
      timezone => $timzone,
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

  #Install the mail server
  if ($mail_server) {
    $mail_server_port = "1025"
    $mail_http_port   = "1080"

    class { 'email':
      mail_server      => $mail_server,
      mail_server_port => $mail_server_port,
      mail_http_port   => $mail_http_port,
    }
  }

  #Setup Liferay
  class { 'liferay' :
    db_user              => $db_user,
    db_password          => $db_password,
    db_name              => $db_name,
    install_path         => $liferay_install_path, 
    liferay_user         => $liferay_user,
    liferay_group        => $liferay_group,
    liferay_zip_filename => $liferay_zip_filename,
    liferay_folder       => $liferay_folder,
    tomcat_folder        => $tomcat_folder,
    version              => $liferay_version,
    xmx                  => $xmx,
    permsize             => $permsize,
    liferay_db           => $liferay_db,
    mail_server_port     => $mail_server_port,
    liferay_dev          => $liferay_dev,
    external_tools       => $external_tools,
    require              => [
      Class['javad'], 
      Class['users'],
      Class['db'],
    ],
  } 

  #Setup httpserver (default apache2)
  class {'httpserver' :
    httpserver => $httpserver,
    require    => [
      Class['liferay'],
    ],
  }

  #Setup firewall
  if ($use_firewall) {
    class {'iptables' :
      mail_server => $mail_server,
    }
  }




}