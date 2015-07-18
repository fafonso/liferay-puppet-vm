class email::mailcatcher(
    $mail_server_port,
    $mail_http_port,
  ) {


  package { 'build-essential':
    ensure => present,
    before => Package['mailcatcher'],
  }

  package { 'software-properties-common':
    ensure => present,
    before => Package['mailcatcher'],
  }

  package { 'sqlite3':
    ensure => present,
    before => Package['mailcatcher'],
  }

  package { 'libsqlite3-dev':
    ensure => present,
    before => Package['mailcatcher'],
  }

  package { 'ruby1.9.1-dev':
    ensure => present,
    before => Package['mailcatcher'],
  }

  package { 'mailcatcher':
    provider => gem,
    ensure   => present,
  }

  file { '/etc/init/mailcatcher.conf':
    content => template('email/upstart.conf.erb'),
    alias   => 'mailcatcher.conf'
  }

  service { 'mailcatcher':
    ensure    => running,
    provider  => upstart,
    hasstatus => true,
    require   => [ File['mailcatcher.conf'], Package['mailcatcher'] ]
  }


}