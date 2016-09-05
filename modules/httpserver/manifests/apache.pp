class httpserver::apache (
    $apache_home = "/etc/apache2/",
  ) {

  package { "apache2":
    ensure  => present,
  }

  exec {"valid_apache_home":
    command => '/bin/true',
    onlyif => "/usr/bin/test -e ${apache_home}/conf-available",
    require => Package['apache2'],
  }

  service { "apache2":
    ensure  => "running",
    enable  => true,
    require => [
      Package['apache2'],
    ],
  }

  exec {"a2enmod headers":
    path    => ["/usr/bin", "/bin", "/usr/sbin"],
    require => Exec["valid_apache_home"],
  }

  exec {"a2enmod deflate":
    path    => ["/usr/bin", "/bin", "/usr/sbin"],
    require => Exec["valid_apache_home"],
  }

  package { "libapache2-mod-jk":
    ensure  => present,
    require => Package['apache2'],
  }

  file {"defalte.conf":
    path    => "${apache_home}/conf-available/deflate.conf",
    content => template('httpserver/apache-deflate-conf.erb'),
    require => Exec["valid_apache_home"],
  }

  file {"jkmount.conf":
    path    => "${apache_home}/conf-available/jkmount.conf",
    source  => "puppet:///modules/httpserver/apache-jkmount.conf",
    require => Exec["valid_apache_home"],
  }

  file_line { 'virtual_host_conf':
    ensure  => present,
    path    => "${apache_home}/sites-enabled/000-default.conf",
    line    => 'Include conf-available/jkmount.conf',
    after   => '#Include',
    require => File["jkmount.conf"],
    notify  => Service["apache2"],
  } ->

  file_line { 'deflate_host_conf':
    ensure  => present,
    path    => "${apache_home}/sites-enabled/000-default.conf",
    line    => 'Include conf-available/deflate.conf',
    after   => '#Include',
    require => File["defalte.conf"],
    notify  => Service["apache2"],
  }




  
}