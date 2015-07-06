class javad::openjdk {

	class { 'java':
		distribution => 'jdk',
    	package      => 'openjdk-7-jdk',
	}

	#Setup jmx access
	class {'jmx' :
		jre_management_path => "/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/management",
    	require             => Class['java'],
	} 

}