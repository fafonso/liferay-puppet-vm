class liferay::cluster(
  $liferay_folder, 
  $tomcat_folder, 
  $liferay_zip_filename,
  $zip_file_location,
  $liferay_deploy_dir,
  $db_user,
  $db_password,
  $db_name,
  $xmx,
  $permsize,
  $install_path,
  $liferay_user,
  ) {

  #Node configurations
  $node1_name     = "node1"
  $node1_ajp_port = "8009"
  $node2_name     = "node2"
  $node2_ajp_port = "8010"

  $ajp_nodes      = ["BalancerMember ajp://localhost:${node1_ajp_port} route=${node1_name}" , "BalancerMember ajp://localhost:${node2_ajp_port} route=${node2_name}"]

  #Ensure that we have the root install path directory
  file {"${install_path}":
    ensure => "directory",
    owner  => $liferay_user,
    group  => $group,
    mode   => 775,
  }

  # Create node 1
  liferay::single { $node1_name :
    db_user              => $db_user,
    db_password          => $db_password,
    db_name              => $db_name,
    install_path         => "${install_path}/${node1_name}", 
    liferay_user         => $liferay_user,
    liferay_folder       => $liferay_folder, 
    tomcat_folder        => $tomcat_folder, 
    liferay_zip_filename => $liferay_zip_filename,
    zip_file_location    => $zip_file_location,
    liferay_deploy_dir   => "${liferay_deploy_dir}/${node1_name}",
    xmx                  => $xmx,
    permsize             => $permsize,
    cluster_conf         => true,
    data_dl_path         => "${install_path}/data/document_library",
    http_port            => "8080",
    shutdown_port        => "8005",
    redirect_port        => "8443",
    ajp_port             => "${node1_ajp_port}",
    require              => File["${install_path}"],
  }

  # Create node 2
  liferay::single { $node2_name :
    db_user              => $db_user,
    db_password          => $db_password,
    db_name              => $db_name,
    install_path         => "${install_path}/${node2_name}", 
    liferay_user         => $liferay_user,
    liferay_folder       => $liferay_folder, 
    tomcat_folder        => $tomcat_folder, 
    liferay_zip_filename => $liferay_zip_filename,
    zip_file_location    => $zip_file_location,
    liferay_deploy_dir   => "${liferay_deploy_dir}/${node2_name}",
    xmx                  => $xmx,
    permsize             => $permsize,
    cluster_conf         => true,
    data_dl_path         => "${install_path}/data/document_library",
    http_port            => "8081",
    shutdown_port        => "8006",
    redirect_port        => "8444",
    ajp_port             => "${node2_ajp_port}",
    require              => File["${install_path}"],
  }

  #Adds extra cluster ports
  firewall { '102 allow access to tomcat extra cluster ports':
	  port   => [8081],
	  proto  => tcp,
	  action => accept,
  }

  firewall { '103 allow access to multicast port for chache syncronization':
  	dst_type => 'MULTICAST',
  	pkttype  => 'multicast',
	  port     => '23301-23351',
	  proto    => udp,
	  action   => accept,
  }
    
}