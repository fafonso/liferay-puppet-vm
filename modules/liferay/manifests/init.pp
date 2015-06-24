class liferay(
  $liferay_folder       = "liferay-portal-6.2-ce-ga4", 
  $tomcat_folder        = "tomcat-7.0.42", 
  $version              = "6.2.3%20GA4",
  $liferay_zip_filename = "liferay-portal-tomcat-6.2-ce-ga4-20150416163831865.zip",
  $liferay_deploy_dir   = "/vagrant/liferay/deploy",
  $db_user,
  $db_password,
  $db_name,
  $xmx                  = "2048",
  $permsize             = "512",
  $install_path,
  $liferay_user,
  $liferay_cluster      = false,
  ) {

  $zip_file_location = "/etc/puppet/modules/liferay/files"

  #Prepararation tasks
  package {"unzip":
    name   => "unzip",
    ensure => present,
  }
  
  class { 'liferay::get' :
  	version              => $version,
  	liferay_zip_filename => $liferay_zip_filename,
  	zip_file_location    => $zip_file_location,
  }

  if($liferay_cluster) {
    #Setup Liferay cluster with 2 nodes
    
    class { 'liferay::cluster' :
      db_user              => $db_user,
      db_password          => $db_password,
      db_name              => $db_name,
      install_path         => $install_path, 
      liferay_user         => $liferay_user,
      liferay_folder       => $liferay_folder, 
      tomcat_folder        => $tomcat_folder, 
      liferay_zip_filename => $liferay_zip_filename,
      zip_file_location    => $zip_file_location,
      liferay_deploy_dir   => $liferay_deploy_dir,
      xmx                  => $xmx,
      permsize             => $permsize,
      require              => [Class["liferay::get"], Package["unzip"]],
    }

  } else {
    #Setup Liferay single node
    liferay::single { 'single' :
      db_user              => $db_user,
      db_password          => $db_password,
      db_name              => $db_name,
      install_path         => $install_path, 
      liferay_user         => $liferay_user,
      liferay_folder       => $liferay_folder, 
      tomcat_folder        => $tomcat_folder, 
      liferay_zip_filename => $liferay_zip_filename,
      zip_file_location    => $zip_file_location,
      liferay_deploy_dir   => $liferay_deploy_dir,
      xmx                  => $xmx,
      permsize             => $permsize,
      require              => [Class["liferay::get"], Package["unzip"]],
    }

  }

  firewall { '101 allow access to tomcat and JMX':
    port   => [8080, 8000, 9090, 9091],
    proto  => tcp,
    action => accept,
  }
  
}