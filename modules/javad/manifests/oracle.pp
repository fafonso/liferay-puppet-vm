class javad::oracle() {

	#Adding ppa to get Oracle Java
  package { 'python-software-properties':
    ensure => present,
  }

  apt::ppa { 'ppa:webupd8team/java':
    require     => Package['python-software-properties'],
  }

  #Get and install Oracle Java
  exec {
      'set-licence-selected':
        command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';
   
      'set-licence-seen':
        command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
  }

  class { 'java':
    distribution => 'oracle-jdk',
    package      => 'oracle-java7-installer',
    require      => [
      Apt::Ppa ['ppa:webupd8team/java'],
      Class['apt'],
      Exec['set-licence-selected'], 
      Exec['set-licence-seen'],
    ]
  }

  #Setup jmx access
  class {'jmx' :
    jre_management_path => "/usr/lib/jvm/java-7-oracle/jre/lib/management",
    require             => Class['java'],
  }


}