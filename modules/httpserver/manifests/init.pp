class httpserver (
    $httpserver,
    $cluster,
  ) {

  
  if ! ($httpserver in [ 'apache2', 'nginx', '']) {
    fail('httpserver parameter must be apache2 or nginx')
  }

  if ($httpserver == "apache2") {
    #Setup apache2
    class { 'httpserver::apache':
      cluster => $cluster,
    }
  } 
  if ($httpserver == "nginx") {
    #Setup nginx
    class { 'httpserver::nginx':
      cluster => $cluster,
    }
  }


  
}