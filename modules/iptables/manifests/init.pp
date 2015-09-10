class iptables (
    $cluster,
    $solr,
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

  if ($cluster) {
    #Adds extra cluster ports
    firewall { '102 allow access to tomcat extra cluster ports':
      dport   => [8081],
      proto  => tcp,
      action => accept,
    }

    firewall { '103 allow access to multicast port for chache syncronization':
      dst_type => 'MULTICAST',
      pkttype  => 'multicast',
      dport     => '23301-23351',
      proto    => udp,
      action   => accept,
    }
  }

  firewall { '104 allow access to JMX':
    dport   => [9090, 9091],
    proto  => tcp,
    action => accept,
  }

  if ($solr) {
    firewall { '105 allow access to solr':
      dport   => [8180],
      proto  => tcp,
      action => accept,
    }
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