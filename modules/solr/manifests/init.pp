class solr(
    $distribution,
    $liferay_user,
    $liferay_group,
    $solr_install_path      = "/opt/solr",
    $solr_zip_file_location = "/etc/puppet/modules/solr/files",
    $http_port,
    $shutdown_port          = "8105",
    $redirect_port          = "8543",
    $ajp_port               = "8109",
    $xmx                    = "512",
    $permsize               = "128",
  ) {

  if ! ($distribution in [ '3.5.0' ]) {
    fail('SOLR distribution parameter must be 3.5.0')
  }

  if ($distribution == "3.5.0") {
    #Setup oracle java
    class { 'solr::3xx':
      http_port              => $http_port,
      shutdown_port          => $shutdown_port,
      redirect_port          => $redirect_port,
      ajp_port               => $ajp_port,
      solr_install_path      => $solr_install_path,
      solr_zip_file_location => $solr_zip_file_location,
      liferay_user           => $liferay_user,
      liferay_group          => $liferay_group,
      xmx                    => $xmx,
      permsize               => $permsize,
      version                => $distribution,
    }

  } 
  
  
}