define liferay::single(
  $liferay_folder, 
  $tomcat_folder, 
  $liferay_zip_filename,
  $module_files_location,
  $liferay_vagrant_dir,
  $db_user,
  $db_password,
  $db_name,
  $xmx,
  $permsize,
  $install_path,
  $liferay_user,
  $liferay_group,
  $http_port            = "8080",
  $shutdown_port        = "8005",
  $redirect_port        = "8443",
  $ajp_port             = "8009",
  $cluster_conf         = false,
  $data_dl_path         = "",
  $liferay_db,
  $solr_distribution,
  ) {

  $liferay_path      = "${install_path}/${liferay_folder}"
  $liferay_home      = $liferay_path
  $tomcat_path       = "${liferay_path}/${tomcat_folder}"
  $liferay_deploy_dir = "${liferay_vagrant_dir}/deploy"


  if ($http_port == "8080") {
    $service_name = "tomcat"
  } else {
    $service_name = "tomcat${http_port}"
  }

  #Adjust parameters for template, according to the DB to use (default do MySQL)
  if ($liferay_db == "postgresql") {
    $driverClassName = "org.postgresql.Driver"
    $db_url          = "jdbc:postgresql://localhost:5432/${db_name}"
  } else {
    $driverClassName = "com.mysql.jdbc.Driver"
    $db_url          = "jdbc:mysql://localhost/${db_name}?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false"
  }

  exec {"${title}-stop-liferay":
    command => "${tomcat_path}/bin/catalina.sh stop",
    onlyif  => "test -f ${tomcat_path}/bin/catalina.sh",
    path    => ["/usr/bin", "/bin"],
  }

  exec {"${title}-clean-liferay-home":
    command => "rm -fR ${liferay_home}/*",
    path    => ["/usr/bin", "/bin"],
    require => Exec["${title}-stop-liferay"]
  }

  exec {"${title}-clean-liferay-deploy-dir":
    command => "rm -fR ${liferay_vagrant_dir}/*",
    path    => ["/usr/bin", "/bin"],
    require => Exec["${title}-clean-liferay-home"]
  }

  exec {"${title}-clean-liferay":
    command => "rm -fR ${install_path}/*",
    path    => ["/usr/bin", "/bin"],
    require => Exec["${title}-clean-liferay-deploy-dir"]
  }

  file {"${install_path}":
    ensure => "directory",
    owner  => $liferay_user,
    group  => $liferay_group,
    mode   => 775,
  }

  file {"${liferay_vagrant_dir}":
    ensure => "directory",
    owner  => $liferay_user,
    group  => $liferay_group,
    mode   => 775,
  }

  exec {"${title}-unzip-liferay":
    command => "unzip ${module_files_location}/${liferay_zip_filename}",
    cwd     => "${install_path}",
    require => [Package["unzip"], File["${install_path}"], Exec["${title}-clean-liferay"], ],
    path    => ["/usr/bin", "/bin"],
    user    => $liferay_user,
    group   => $liferay_group,
    umask   => 002,
  }

  file { "${title}-liferay-home":
    path    => "$liferay_home",
    ensure  => "directory",
    owner   => $liferay_user,
    group   => $liferay_group,
    recurse => "true",
    mode    => 2775,
    require => Exec["${title}-unzip-liferay"],
  } ->

  file { "${title}-liferay-deploy-folder":
    path    => $liferay_deploy_dir,
    ensure  => "directory",
    owner   => $liferay_user,
    group   => $liferay_group,
    mode    => 2775,
  } ->

  file { "${title}-deploy":
    path    => "$liferay_home/deploy",
    ensure  => "link",
    owner   => $liferay_user,
    group   => $liferay_group,
    mode    => 2775,
    target  => $liferay_deploy_dir,
  }

  if ($cluster_conf) {
    file {"${title}-portal-ext.properties":
      path    => "${liferay_vagrant_dir}/portal-ext.properties",
      content => template('liferay/portal-ext-cluster.properties.erb'),
      owner   => $liferay_user,
      group   => $liferay_group,
      mode    => 2775,
      require => Exec["${title}-unzip-liferay"]
    }
  } else {
    file {"${title}-portal-ext.properties":
      path    => "${liferay_vagrant_dir}/portal-ext.properties",
      content => template('liferay/portal-ext.properties.erb'),
      owner   => $liferay_user,
      group   => $liferay_group,
      mode    => 2775,
      require => Exec["${title}-unzip-liferay"]
    }
  }
  
  #Create the portal-ext.properties file in vagrant folder
  file { "${title}-properties-link":
    path    => "${tomcat_path}/webapps/ROOT/WEB-INF/classes/portal-ext.properties",
    owner   => $liferay_user,
    group   => $liferay_group,
    mode    => 2775,
    content => "include-and-override=${liferay_vagrant_dir}/portal-ext.properties",
    require => Exec["${title}-unzip-liferay"],
  }

  file {"${title}-setenv.sh":
    path    => "${tomcat_path}/bin/setenv.sh",
    content => template('liferay/setenv.sh.erb'),
    require => Exec["${title}-unzip-liferay"]
  }

  file {"${title}-server.xml":
    path    => "${tomcat_path}/conf/server.xml",
    content => template('liferay/server.erb'),
    require => Exec["${title}-unzip-liferay"]
  }

  file { "${title}-tomcat":
    name       => "/etc/init.d/${service_name}",
    ensure     => present,
    content    => template("liferay/tomcat.erb"),
    owner      => "root",
    group      => "root",
    mode       => 0755,
  }

  #If using SOLR, we just need to deploy the prepared war here
  # which is expected to be in: /etc/puppet/modules/liferay/files/solr/XPTO.war
  if ($solr_distribution) {

    exec {"${title}-deploy-war-solr-liferay":
      command => "cp solr/*.war ${liferay_deploy_dir}/",
      cwd     => $module_files_location,
      path    => ["/usr/bin", "/bin"],
      require => [
        Exec["war-solr-liferay"],
        File["${title}-deploy"],
      ]
    }

  }

  if ($http_port == "8080") {
  	# Specific confifurations for first node

    #We just want to start the first node 
    service { "${service_name}":
      name    => "${service_name}",
      ensure  => "running",
      require => [
          File["${title}-portal-ext.properties"],
          File["${title}-setenv.sh"],
          File["${title}-server.xml"],
          File["${title}-tomcat"],
        ],
    }
    
  } 
  
  
}