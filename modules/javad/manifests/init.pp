class javad(
	  $distribution,
  ) {


  if ! ($distribution in [ 'oracle', 'openjdk' ]) {
    fail('javad distribution parameter must be oracle or openjdk')
  }

  if ($distribution == "oracle") {
    #Setup oracle java
    class { 'javad::oracle':
  
    }

  } else {
    #Setup openjdk java
    class { 'javad::openjdk':
  
    }

  }
  
  
}