class httpserver::apache (
    $apache_home = "/etc/apache2/",
    $cluster,
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
    require => [
      Package['apache2'],
    ],
  }


  if ($cluster) {

    exec {"a2enmod proxy":
      path    => ["/usr/bin", "/bin", "/usr/sbin"],
      require => Exec["valid_apache_home"],
    }

    exec {"a2enmod proxy_ajp":
      path    => ["/usr/bin", "/bin", "/usr/sbin"],
      require => Exec["valid_apache_home"],
    }

    exec {"a2enmod proxy_balancer":
      path    => ["/usr/bin", "/bin", "/usr/sbin"],
      require => Exec["valid_apache_home"],
    }

    exec {"a2enmod lbmethod_byrequests":
      path    => ["/usr/bin", "/bin", "/usr/sbin"],
      require => Exec["valid_apache_home"],
    }

    exec {"a2enmod slotmem_shm":
      path    => ["/usr/bin", "/bin", "/usr/sbin"],
      require => Exec["valid_apache_home"],
    }

    file {"ajp.conf":
      path    => "${apache_home}/conf-available/ajp.conf",
      content => template('httpserver/apache-cluster-conf.erb'),
      require => Exec["valid_apache_home"],
    }

    file_line { 'virtual_ajp_host_conf':
      ensure  => present,
      path    => "${apache_home}/sites-enabled/000-default.conf",
      line    => 'Include conf-available/ajp.conf',
      after   => '#Include',
      require => File["ajp.conf"],
      notify  => Service["apache2"],
    }

  } else {

    package { "libapache2-mod-jk":
      ensure  => present,
      require => Package['apache2'],
    }

    file {"jkmount.conf":
      path => "${apache_home}/conf-available/jkmount.conf",
      source => "puppet:///modules/httpserver/jkmount.conf",
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

  }


  
}