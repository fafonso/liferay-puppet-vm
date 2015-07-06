class httpserver (
    $httpserver,
    $cluster,
  ) {

  
  if ! ($httpserver in [ 'apache2' ]) {
    fail('httpserver parameter must be apache2')
  }

  if ($httpserver == "apache2") {
    #Setup apache2
    class { 'httpserver::apache':
      cluster => $cluster,
    }
  }


  
}