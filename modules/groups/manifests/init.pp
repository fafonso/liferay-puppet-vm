class groups(
	$liferay_group
  ) {
  
  group { "$liferay_group":
    ensure     => present,
    gid        => "510"
  }
}