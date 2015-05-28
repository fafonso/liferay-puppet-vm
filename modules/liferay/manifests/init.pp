class liferay(
  $liferay_folder       = "liferay-portal-6.2-ce-ga4", 
  $tomcat_folder        = "tomcat-7.0.42", 
  $version              = "6.2.3%20GA4",
  $liferay_zip_filename = "liferay-portal-tomcat-6.2-ce-ga4-20150416163831865.zip",
  $liferay_deploy_dir   = "/vagrant/liferay/deploy",
  $db_user,
  $db_password,
  $db_name,
  $xmx                  = "2048",
  $permsize             = "512",
  $install_path,
  $liferay_user,
  ) {

  $group             = "www"
  $liferay_path      = "${install_path}/${liferay_folder}"
  $liferay_home      = $liferay_path
  $tomcat_path       = "${liferay_path}/${tomcat_folder}"

  $webapp_url        = "http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/${version}/${liferay_zip_filename}"

  $zip_file_location = "/etc/puppet/modules/liferay/files"

  exec {"stop-liferay":
    command => "${tomcat_path}/bin/catalina.sh stop",
    onlyif => "test -f ${tomcat_path}/bin/catalina.sh",
    path => ["/usr/bin", "/bin"],
  }

  exec {"clean-liferay-home":
    command => "rm -fR ${liferay_home}/*",
    path => ["/usr/bin", "/bin"],
    require => Exec["stop-liferay"]
  }

  exec {"clean-liferay-deploy-dir":
    command => "rm -fR ${liferay_deploy_dir}/*",
    path => ["/usr/bin", "/bin"],
    require => Exec["clean-liferay-home"]
  }

  exec {"clean-liferay":
    command => "rm -fR ${install_path}/*",
    path => ["/usr/bin", "/bin"],
    require => Exec["clean-liferay-deploy-dir"]
  }

  package {"wget":
    ensure => present
  }

  exec {"get-liferay":
    command => "wget ${webapp_url} -O ${zip_file_location}/${liferay_zip_filename}",
    cwd     => "/home/vagrant",
    path    => ["/usr/bin", "/bin"],
    require => Package["wget"],
    timeout => 600,
    creates => "${zip_file_location}/${liferay_zip_filename}"
  }

  package {"unzip":
    ensure => present
  }

  file {"${install_path}":
    ensure => "directory",
    owner  => $liferay_user,
    group  => $group,
    mode   => 775,
  }

  exec {"unzip-liferay":
    command => "unzip ${zip_file_location}/${liferay_zip_filename}",
    cwd => "${install_path}",
    require => [Exec["get-liferay"], Package["unzip"], File["${install_path}"], Exec["clean-liferay"]],
    path => ["/usr/bin", "/bin"],
  }

  file { "$liferay_home":
    ensure     => "directory",
    owner      => $liferay_user,
    group      => $group,
    recurse    => "true",
    mode       => 2775,
    require    => Exec["unzip-liferay"],
  }

  file { "$liferay_home/deploy":
    ensure     => "link",
    owner      => $liferay_user,
    group      => $group,
    mode       => 2775,
    target     => $liferay_deploy_dir,
    require    => File["$liferay_home"],
  }

  exec {"remove-liferay-zip":
    command => "rm ${zip_file_location}/${liferay_zip_filename}",
    cwd => "${install_path}",
    require => Exec["unzip-liferay"],
    path => ["/usr/bin", "/bin"],
  }

  file {"portal-ext.properties":
    path => "${tomcat_path}/webapps/ROOT/WEB-INF/classes/portal-ext.properties",
    content => template('liferay/portal-ext.properties.erb'),
    require => Exec["unzip-liferay"]
  }

  file {"setenv.sh":
    path => "${tomcat_path}/bin/setenv.sh",
    content => template('liferay/setenv.sh.erb'),
    require => Exec["unzip-liferay"]
  }

  file { "tomcat":
    name       => "/etc/init.d/tomcat",
    ensure     => present,
    content    => template("liferay/tomcat.erb"),
    owner      => "root",
    group      => "root",
    mode       => 0755,
  }

  service { "tomcat":
    ensure  => "running",
    require => [
        File["portal-ext.properties"],
        File["setenv.sh"],
        File["tomcat"]
      ],
  }

  firewall { '101 allow access to tomcat and JMX':
    port   => [8080, 8000, 9090, 9091],
    proto  => tcp,
    action => accept,
  }
  
}