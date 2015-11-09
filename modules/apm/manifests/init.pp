class apm(
    $apm,
    $install_path,
    $liferay_cluster,
    $java_distribution,
  ) {


  if ! ($apm in [ 'dynatrace', '' ]) {
    fail('apm parameter must be dynatrace')
  }

  if ($apm == "dynatrace") {
    #Setup Postgres with the required DB
    class { 'apm::dynatrace':
      install_path         => $install_path,
      liferay_cluster      => $liferay_cluster,
      java_distribution   => $java_distribution,
    }

  } 
  
  
}