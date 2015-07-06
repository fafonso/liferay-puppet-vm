class liferay(
  $liferay_folder       = "liferay-portal-6.2-ce-ga4", 
  $tomcat_folder        = "tomcat-7.0.42", 
  $version              = "6.2.3%20GA4",
  $liferay_zip_filename = "liferay-portal-tomcat-6.2-ce-ga4-20150416163831865.zip",
  $liferay_vagrant_dir   = "/vagrant/liferay",
  $db_user,
  $db_password,
  $db_name,
  $xmx                  = "2048",
  $permsize             = "512",
  $install_path,
  $liferay_user,
  $liferay_group,
  $liferay_cluster      = false,
  $liferay_db,
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
      liferay_group        => $liferay_group,
      liferay_folder       => $liferay_folder, 
      tomcat_folder        => $tomcat_folder, 
      liferay_zip_filename => $liferay_zip_filename,
      zip_file_location    => $zip_file_location,
      liferay_vagrant_dir  => $liferay_vagrant_dir,
      xmx                  => $xmx,
      permsize             => $permsize,
      liferay_db           => $liferay_db,
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
      liferay_group        => $liferay_group,
      liferay_folder       => $liferay_folder, 
      tomcat_folder        => $tomcat_folder, 
      liferay_zip_filename => $liferay_zip_filename,
      zip_file_location    => $zip_file_location,
      liferay_vagrant_dir  => $liferay_vagrant_dir,
      xmx                  => $xmx,
      permsize             => $permsize,
      liferay_db           => $liferay_db,
      require              => [Class["liferay::get"], Package["unzip"]],
    }

  }

  
}