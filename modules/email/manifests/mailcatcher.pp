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

  # https://github.com/sj26/mailcatcher/issues/277
  # Should give an error but it will work
  # Don't forget to check if mailcatcher service is up and running.
  # If not, please start the service manually (sudo service mailcatcher start)
  package { 'mime-types':
    provider => gem,
    ensure   => '< 3',
    before   => Package['mailcatcher'],
  }

  package { 'mailcatcher':
    provider        => gem,
    ensure          => '0.6.4',
    install_options => '--conservative',
  }


  file { '/etc/init/mailcatcher.conf':
    content => template('email/upstart.conf.erb'),
    alias   => 'mailcatcher.conf'
  }

  service { 'mailcatcher':
    ensure    => running,
    provider  => upstart,
    hasstatus => true,
    enable    => true,
    require   => [ File['mailcatcher.conf'], Package['mailcatcher'] ]
  }


}