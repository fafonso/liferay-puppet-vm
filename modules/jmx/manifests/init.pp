class jmx {

  #remote jmx configured with credential controlRole:liferay

  file { "/usr/lib/jvm/java-7-oracle/jre/lib/management/jmxremote.access":
    name   => "/usr/lib/jvm/java-7-oracle/jre/lib/management/jmxremote.access",
    ensure => present,
    source => "puppet:///modules/jmx/jmxremote.access",
    owner  => "root",
    group  => "root",
    mode   => 0644
  }

  file { "/usr/lib/jvm/java-7-oracle/jre/lib/management/jmxremote.password":
    name   => "/usr/lib/jvm/java-7-oracle/jre/lib/management/jmxremote.password",
    ensure => present,
    source => "puppet:///modules/jmx/jmxremote.password",
    owner  => "root",
    group  => "root",
    mode   => 0644
  }
}