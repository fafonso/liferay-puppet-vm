class groups(
	$group = "www"
  ) {
  
  group { "$group":
    ensure     => present,
    gid        => "510"
  }
}