class iptables (
    $mail_server,
  ){

  resources { "firewall":
    purge => true
  }

  Firewall {
    before  => Class['iptables::post'],
    require => Class['iptables::pre'],
  }

  class { ['iptables::pre', 'iptables::post']: }

  firewall { '100 allow http and https access':
    dport   => [80, 443],
    proto  => tcp,
    action => accept,
  }

  firewall { '101 allow access to tomcat':
    dport   => [8080, 8000],
    proto  => tcp,
    action => accept,
  }

  firewall { '104 allow access to JMX':
    dport   => [9090, 9091],
    proto  => tcp,
    action => accept,
  }

  if ($mail_server) {
    firewall { '106 allow access to mailcatcher':
      dport   => [1080],
      proto  => tcp,
      action => accept,
    }
  }

  include firewall
  
}