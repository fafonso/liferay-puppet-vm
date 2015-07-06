class jmx (
  $jre_management_path,
  ) {

  #remote jmx configured with credential controlRole:liferay

  file { "${jre_management_path}/jmxremote.access":
    name   => "${jre_management_path}/jmxremote.access",
    ensure => present,
    source => "puppet:///modules/jmx/jmxremote.access",
    owner  => "root",
    group  => "root",
    mode   => 0644
  }

  file { "${jre_management_path}/jmxremote.password":
    name   => "${jre_management_path}/jmxremote.password",
    ensure => present,
    source => "puppet:///modules/jmx/jmxremote.password",
    owner  => "root",
    group  => "root",
    mode   => 0644
  }
}

