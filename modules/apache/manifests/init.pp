class apache ($apache_home = "/etc/apache2/") {

  package { "apache2":
    ensure  => present,
  }

  package { "libapache2-mod-jk":
    ensure  => present,
    require => Package['apache2'],
  }

  service { "apache2":
    ensure  => "running",
    require => [
      Package['apache2'],
      Package['libapache2-mod-jk'],
    ],
  }

  exec {"valid_apache_home":
    command => '/bin/true',
    onlyif => "/usr/bin/test -e ${apache_home}/conf-available",
    require => Package['apache2'],
  }

  file {"jkmount.conf":
    path => "${apache_home}/conf-available/jkmount.conf",
    source => "puppet:///modules/apache/jkmount.conf",
    require => Exec["valid_apache_home"],
  }

  file_line { 'virtual_host_conf':
    ensure  => present,
    path    => "${apache_home}/sites-enabled/000-default.conf",
    line    => 'Include conf-available/jkmount.conf',
    after   => '#Include',
    require => File["jkmount.conf"],
    notify  => Service["apache2"],
  }

  firewall { '100 allow http and https access':
    port   => [80, 443],
    proto  => tcp,
    action => accept,
  }
  
}