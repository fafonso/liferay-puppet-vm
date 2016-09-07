class externalservices::openoffice(
    $liferay_user,
  ) {

  package { "libreoffice":
    ensure  => present,
  } ->

  file { "soffice-init-script":
    name       => "/etc/init.d/soffice",
    ensure     => present,
    content    => template("externalservices/soffice.erb"),
    owner      => "root",
    group      => "root",
    mode       => 0755,
  } ->

  service { "soffice":
    name    => "soffice",
    ensure  => "running",
    enable  => true,
  }
  
}