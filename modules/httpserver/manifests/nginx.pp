class httpserver::nginx(
    $nginx_home = "/etc/nginx",
    $cluster,
  ) {

  if ($cluster) {
    $nodes = $liferay::cluster::nginx_nodes
  } else {
    $nodes    = ["server localhost:8080 max_fails=1 fail_timeout=20s; "]
  }

  package {"nginx":
    ensure => "installed",
  } ->

  file { "liferay.site":
    name    => "${nginx_home}/sites-enabled/liferay.site",
    ensure  => "present",
    source  => "puppet:///modules/httpserver/nginx-liferay.site",
    owner   => "root",
    group   => "root",
    mode    => 0755,
  } -> 

  file {"${nginx_home}/sites-enabled/default":
    ensure  => "absent",
  } ->

  file { "default.conf":
    name    => "${nginx_home}/conf.d/default_liferay.conf",
    ensure  => "present",
    content => template("httpserver/nginx-default.conf.erb"),
    owner   => "root",
    group   => "root",
    mode    => 0755,
  } 

  service { "nginx":
    ensure    => "running",
    subscribe => File["default.conf"],
  }

}