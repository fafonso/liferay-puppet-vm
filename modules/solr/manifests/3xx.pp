class solr::3xx(
    $liferay_user,
    $liferay_group,
    $http_port,
    $shutdown_port,
    $redirect_port,
    $ajp_port,
    $solr_install_path,
    $solr_zip_file_location,
    $xmx,
    $permsize,
    $version                = "3.5.0",
  ) {

  #SOLR Conf  
  $solr_zip_filename    = "apache-solr-${version}.zip"
  $solr_example_path    = "${solr_install_path}/apache-solr-${version}/example"
  $solr_war_location    = "${solr_example_path}/webapps/solr.war"
  $solr_home            = "${solr_example_path}/solr"

  #Tomcat Conf
  $tomcat7_install_path = "${solr_install_path}/tomcat7"
  $tomcat_url           = "http://mirrors.whoishostingthis.com/apache/tomcat/tomcat-7/v7.0.64/bin/apache-tomcat-7.0.64.tar.gz"
  $java_opts            = "$JAVA_OPTS -Dfile.encoding=UTF8 -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Dsolr.solr.home=${solr_home} -Dsolr.velocity.enabled=false"
  $catalina_opts        = "$CATALINA_OPTS -Duser.timezone=GMT -Xmx${xmx}m -XX:MaxPermSize=${permsize}m"

  #Prepararation tasks
  util::get { "solr${version}" :
    base_url          => "http://archive.apache.org/dist/lucene/solr",
    version           => $version,
    zip_filename      => $solr_zip_filename,
    zip_file_location => $solr_zip_file_location,
  }

  file { 'create-solr-home' :
    path   => $solr_install_path,
    ensure => "directory",
    owner  => $liferay_user,
    group  => $liferay_group,
    mode   => 775,
  }

  exec {"clean-solr-home":
    command => "rm -fR ${solr_install_path}/*",
    path    => ["/usr/bin", "/bin"],
    require => File["create-solr-home"],
  }

  exec {"unzip-solr":
    command => "unzip ${solr_zip_file_location}/${solr_zip_filename}",
    cwd     => "${solr_install_path}",
    path    => ["/usr/bin", "/bin"],
    user    => $liferay_user,
    group   => $liferay_group,
    umask   => 002,
    require => [
      Util::Get["solr${version}"],
      Exec["clean-solr-home"],
      Package["unzip"],
    ],
  }

  # Configuration of Liferay schema
  file {
    "liferay-schema-1":
    path    => "${solr_home}/schema.xml",
    source  => "puppet:///modules/solr/solr3/schema.xml",
    replace => true,
    require => Exec["unzip-solr"];

    "liferay-schema-2":
    path    => "${solr_home}/conf/schema.xml",
    source  => "puppet:///modules/solr/solr3/schema.xml",
    replace => true,
    require => Exec["unzip-solr"];
  }

  #Tomcat Instalation
  class { 'tomcat': 
    group            => $liferay_group,
    manage_group     => false,
    user             => $liferay_user,
    manage_user      => false,
    catalina_home    => $tomcat7_install_path,
    require          => Exec['unzip-solr'],
    purge_connectors => true
  }->
  tomcat::instance{ 'tomcatSOLR':
    source_url    => $tomcat_url,
    catalina_base => $tomcat7_install_path,
  }->
  tomcat::config::server { 'tomcatSOLR':
    catalina_base => $tomcat7_install_path,
    port          => $shutdown_port,
  }->
  tomcat::config::server::connector { 'tomcatSOLR-http':
    catalina_base         => $tomcat7_install_path,
    port                  => $http_port,
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort'      => $redirect_port,
      'connectionTimeout' => "20000"
    },
  }->
  tomcat::config::server::connector { 'tomcatSOLR-ajp':
    catalina_base         => $tomcat7_install_path,
    port                  => $ajp_port,
    protocol              => 'AJP/1.3',
    additional_attributes => {
      'redirectPort' => $redirect_port
    },
  }->
  tomcat::setenv::entry { 
    'JAVA_OPTS':
    quote_char => "\"",
    value      => $java_opts;

    'CATALINA_OPTS':
    quote_char => "\"",
    value      => $catalina_opts;
  }->
  tomcat::war { 'solr.war':
    catalina_base => $tomcat7_install_path,
    war_source    => $solr_war_location,
  }->
  tomcat::service { 'tomcatSOLR':
    catalina_base => $tomcat7_install_path,
  }
  
}